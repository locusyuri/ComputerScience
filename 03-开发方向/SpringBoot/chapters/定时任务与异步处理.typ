#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= 定时任务与异步处理

#note[
  本文档基于 *Spring Boot 3.2.4* 和 *Java 17* 编写，所有代码示例均在该环境下测试通过。
]

本章将详细介绍 Spring Boot 中的定时任务和异步处理机制，包括：

- 基础定时任务配置和使用
- 异步方法执行和线程池管理
- 高级定时任务（动态、分布式）
- Quartz 框架集成
- 异步编程最佳实践

#tip[
  建议按顺序阅读，从基础到高级逐步深入。每个章节都有完整的代码示例，可以直接在项目中使用。
]

== 定时任务基础

=== `@Scheduled` 注解详解

Spring Boot 提供了 `@Scheduled` 注解来简化定时任务的配置。该注解可以标注在方法上，使该方法按照指定的时间规则周期性执行。

#note[
  使用 `@Scheduled` 前，需要在启动类或配置类上添加 `@EnableScheduling` 注解以启用定时任务支持。
]

基本使用示例：

```java
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import java.time.LocalDateTime;

@Component
public class SimpleTask {
    
    @Scheduled(fixedRate = 5000)
    public void executeFixedRate() {
        System.out.println("每5秒执行一次: " + LocalDateTime.now());
    }
}
```

#tip[
  `fixedRate` 表示从上一次任务开始执行的时间点计算间隔，而 `fixedDelay` 表示从上一次任务结束的时间点计算间隔。
]

=== Cron 表达式语法

Cron 表达式是定时任务中最灵活的调度方式，由 6 或 7 个字段组成：

#tex-table(
  ("位置", "字段", "允许值", "特殊字符"),
  ("1", "秒", "0-59", ", - * /"),
  ("2", "分", "0-59", ", - * /"),
  ("3", "时", "0-23", ", - * /"),
  ("4", "日", "1-31", ", - * ? / L W"),
  ("5", "月", "1-12 或 JAN-DEC", ", - * /"),
  ("6", "周", "0-7 或 SUN-SAT", ", - * ? / L #"),
  ("7", "年（可选）", "1970-2099", ", - * /"),
)

#caution[
  「日」和「周」字段不能同时指定具体值，其中一个必须为 `?`（不指定）。
]

常用 Cron 表达式示例：

#tex-table(
  ("表达式", "含义"),
  (`"0 0 * * * *"`, "每小时整点执行"),
  (`"0 0 0 * * *"`, "每天凌晨执行"),
  (`"0 */5 * * * *"`, "每5分钟执行一次"),
  (`"0 0 9-17 * * MON-FRI"`, "工作日9点到17点每小时执行"),
  (`"0 0 12 1 * ?"`, "每月1号中午12点执行"),
  (`"0 0/30 8-10 * * *"`, "每天8点到10点，每30分钟执行"),
)

实际应用示例：

```java
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import java.time.LocalDateTime;

@Component
public class CronTask {
    
    // 每天凌晨2点执行数据备份
    @Scheduled(cron = "0 0 2 * * ?")
    public void backupData() {
        System.out.println("执行数据备份: " + LocalDateTime.now());
    }
    
    // 每周一上午9点发送周报
    @Scheduled(cron = "0 0 9 ? * MON")
    public void sendWeeklyReport() {
        System.out.println("发送周报: " + LocalDateTime.now());
    }
}
```

#tip[
  可以使用在线工具如 https://crontab.guru/ 来验证和生成 Cron 表达式。
]

=== 固定速率与固定延迟

`@Scheduled` 提供了三种主要的调度策略：

==== fixedRate（固定速率）

从上一次任务开始执行的时间点计算下一次执行的间隔。

```java
import org.springframework.scheduling.annotation.Scheduled;
import java.util.Date;

@Scheduled(fixedRate = 3000)
public void fixedRateTask() {
    long start = System.currentTimeMillis();
    System.out.println("任务开始: " + new Date());
    
    // 模拟耗时操作
    try {
        Thread.sleep(2000);
    } catch (InterruptedException e) {
        e.printStackTrace();
    }
    
    long end = System.currentTimeMillis();
    System.out.println("任务结束，耗时: " + (end - start) + "ms");
}
```

#info[
  如果任务执行时间超过 `fixedRate` 设定的间隔，下一次任务会立即执行，不会等待。
]

==== fixedDelay（固定延迟）

从上一次任务执行完成的时间点计算下一次执行的间隔。

```java
import org.springframework.scheduling.annotation.Scheduled;
import java.util.Date;

@Scheduled(fixedDelay = 3000)
public void fixedDelayTask() {
    long start = System.currentTimeMillis();
    System.out.println("任务开始: " + new Date());
    
    // 模拟耗时操作
    try {
        Thread.sleep(2000);
    } catch (InterruptedException e) {
        e.printStackTrace();
    }
    
    long end = System.currentTimeMillis();
    System.out.println("任务结束，耗时: " + (end - start) + "ms");
}
```

#note[
  `fixedDelay` 保证了任务之间的间隔时间是固定的，适合需要严格控制执行频率的场景。
]

==== initialDelay（初始延迟）

应用启动后，延迟指定时间再开始执行定时任务。

```java
import org.springframework.scheduling.annotation.Scheduled;
import java.util.Date;

// 应用启动后延迟10秒，然后每5秒执行一次
@Scheduled(fixedRate = 5000, initialDelay = 10000)
public void delayedTask() {
    System.out.println("延迟任务执行: " + new Date());
}
```

#tex-table(
  ("特性", "fixedRate", "fixedDelay"),
  ("计算起点", "上次任务开始时间", "上次任务结束时间"),
  ("任务重叠", "可能发生", "不会发生"),
  ("适用场景", "周期性数据采集", "资源密集型任务"),
  ("稳定性", "可能累积延迟", "间隔稳定"),
)

#warning[
  默认情况下，Spring 的定时任务是单线程串行执行的。如果某个任务执行时间过长，会阻塞后续任务的执行。建议使用线程池来解决这个问题（后续章节会详细介绍）。
]

== 异步处理核心

=== `@Async` 注解使用

Spring Boot 提供了 `@Async` 注解来实现方法的异步执行。标注了该注解的方法会在独立的线程中运行，不会阻塞调用线程。

#note[
  使用 `@Async` 前，需要在启动类或配置类上添加 `@EnableAsync` 注解以启用异步支持。
]

基本使用示例：

```java
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import java.util.concurrent.CompletableFuture;

@Service
public class AsyncService {
    
    @Async
    public void asyncMethod() {
        System.out.println("异步方法执行，线程: " + Thread.currentThread().getName());
        // 模拟耗时操作
        try {
            Thread.sleep(3000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("异步方法完成");
    }
}
```

调用异步方法：

```java
@RestController
public class AsyncController {
    
    @Autowired
    private AsyncService asyncService;
    
    @GetMapping("/async")
    public String handleAsync() {
        System.out.println("主线程开始: " + Thread.currentThread().getName());
        
        // 异步方法立即返回，不阻塞
        asyncService.asyncMethod();
        
        System.out.println("主线程结束: " + Thread.currentThread().getName());
        return "请求已接受，异步任务正在执行";
    }
}
```

#tip[
  `@Async` 可以标注在类上，这样该类的所有 public 方法都会异步执行。
]

#caution[
  `@Async` 方法必须是 *public* 的，且在同一个类内部调用时不会生效（因为 Spring AOP 代理机制的限制）。
]

=== 线程池配置与管理

默认的异步执行器使用 `SimpleAsyncTaskExecutor`，它每次调用都会创建新线程，不适合生产环境。建议配置自定义线程池。

==== 基础线程池配置

```java
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import java.util.concurrent.Executor;
import java.util.concurrent.ThreadPoolExecutor;

@Configuration
public class AsyncConfig {
    
    @Bean("taskExecutor")
    public Executor taskExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        
        // 核心线程数：线程池创建时的初始线程数
        executor.setCorePoolSize(5);
        
        // 最大线程数：线程池允许的最大线程数
        executor.setMaxPoolSize(10);
        
        // 队列容量：当核心线程都在忙时，新任务放入队列等待
        executor.setQueueCapacity(100);
        
        // 线程名称前缀：便于调试和监控
        executor.setThreadNamePrefix("async-task-");
        
        // 拒绝策略：当队列满且达到最大线程数时的处理方式
        executor.setRejectedExecutionHandler(new ThreadPoolExecutor.CallerRunsPolicy());
        
        // 等待所有任务结束后再关闭线程池
        executor.setWaitForTasksToCompleteOnShutdown(true);
        
        // 等待时间（秒）
        executor.setAwaitTerminationSeconds(60);
        
        executor.initialize();
        return executor;
    }
}
```

#tex-table(
  ("参数", "说明", "推荐值"),
  ("corePoolSize", "核心线程数", "CPU核数 × 2"),
  ("maxPoolSize", "最大线程数", "CPU核数 × 4"),
  ("queueCapacity", "队列容量", "根据业务量设定，如100-1000"),
  ("keepAliveSeconds", "空闲线程存活时间", "60秒"),
  ("rejectedExecutionHandler", "拒绝策略", "CallerRunsPolicy 或 AbortPolicy"),
)

==== 指定线程池

可以在 `@Async` 注解中指定使用的线程池 Bean 名称：

```java
@Service
public class MultiPoolService {
    
    // 使用默认的 taskExecutor
    @Async
    public void defaultAsyncTask() {
        System.out.println("默认线程池: " + Thread.currentThread().getName());
    }
    
    // 使用指定的线程池
    @Async("taskExecutor")
    public void customAsyncTask() {
        System.out.println("自定义线程池: " + Thread.currentThread().getName());
    }
}
```

==== 多线程池配置

对于不同优先级的任务，可以配置多个线程池：

```java
@Configuration
public class MultiExecutorConfig {
    
    // 高优先级任务线程池
    @Bean("highPriorityExecutor")
    public Executor highPriorityExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(10);
        executor.setMaxPoolSize(20);
        executor.setQueueCapacity(50);
        executor.setThreadNamePrefix("high-priority-");
        executor.initialize();
        return executor;
    }
    
    // 低优先级任务线程池
    @Bean("lowPriorityExecutor")
    public Executor lowPriorityExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(2);
        executor.setMaxPoolSize(5);
        executor.setQueueCapacity(200);
        executor.setThreadNamePrefix("low-priority-");
        executor.initialize();
        return executor;
    }
}
```

#warning[
  线程池参数需要根据实际业务场景调优。核心线程数过多会导致上下文切换开销增加，过少则无法充分利用 CPU 资源。
]

=== 异步返回值 Future

`@Async` 方法可以返回 `Future`、`CompletableFuture` 或 `ListenableFuture`，以便获取异步执行的结果。

==== CompletableFuture 返回类型

`CompletableFuture` 是 Java 8 引入的强大异步编程工具：

```java
@Service
public class AsyncResultService {
    
    @Async
    public CompletableFuture<String> asyncWithResult() {
        System.out.println("异步任务开始: " + Thread.currentThread().getName());
        
        try {
            // 模拟耗时操作
            Thread.sleep(2000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        
        String result = "异步任务完成";
        System.out.println("异步任务结束");
        
        return CompletableFuture.completedFuture(result);
    }
    
    @Async
    public CompletableFuture<Integer> asyncCalculation(int a, int b) {
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        
        return CompletableFuture.completedFuture(a + b);
    }
}
```

调用并获取结果：

```java
@RestController
public class AsyncResultController {
    
    @Autowired
    private AsyncResultService asyncResultService;
    
    @GetMapping("/result")
    public String handleAsyncResult() throws Exception {
        System.out.println("主线程开始");
        
        // 发起异步调用
        CompletableFuture<String> future = asyncResultService.asyncWithResult();
        
        // 可以继续执行其他逻辑
        System.out.println("主线程继续执行其他任务...");
        
        // 阻塞等待结果（超时时间5秒）
        String result = future.get(5, TimeUnit.SECONDS);
        
        System.out.println("获取到结果: " + result);
        return "结果: " + result;
    }
}
```

==== 多个异步任务组合

`CompletableFuture` 支持多个异步任务的组合：

```java
@Service
public class CombinedAsyncService {
    
    @Autowired
    private AsyncResultService asyncResultService;
    
    public String executeParallel() throws Exception {
        // 并行执行多个异步任务
        CompletableFuture<String> task1 = asyncResultService.asyncWithResult();
        CompletableFuture<Integer> task2 = asyncResultService.asyncCalculation(10, 20);
        
        // 等待所有任务完成
        CompletableFuture.allOf(task1, task2).join();
        
        // 获取结果
        String result1 = task1.get();
        Integer result2 = task2.get();
        
        return result1 + ", 计算结果: " + result2;
    }
    
    // 链式调用
    public CompletableFuture<String> chainedAsync() {
        return asyncResultService.asyncWithResult()
            .thenApply(result -> result.toUpperCase())
            .thenApply(result -> "处理后: " + result)
            .exceptionally(ex -> "异常: " + ex.getMessage());
    }
}
```

#tex-table(
  ("方法", "用途", "示例"),
  ("allOf", "等待所有任务完成", "CompletableFuture.allOf(f1, f2, f3)"),
  ("anyOf", "任一任务完成即返回", "CompletableFuture.anyOf(f1, f2)"),
  ("thenApply", "转换结果", "future.thenApply(s -> s.toUpperCase())"),
  ("thenAccept", "消费结果", "future.thenAccept(System.out::println)"),
  ("thenCompose", "链式异步调用", "future.thenCompose(this::anotherAsync)"),
  ("exceptionally", "异常处理", "future.exceptionally(ex -> \"default\")"),
)

#info[
  使用 `CompletableFuture` 可以实现复杂的异步编排，避免回调地狱（Callback Hell），使代码更加清晰易读。
]

==== 异常处理

异步方法的异常不会直接抛出给调用者，需要特殊处理：

```java
@Service
public class AsyncExceptionService {
    
    @Async
    public CompletableFuture<String> asyncWithException() {
        try {
            // 可能抛出异常的操作
            if (Math.random() > 0.5) {
                throw new RuntimeException("随机异常");
            }
            return CompletableFuture.completedFuture("成功");
        } catch (Exception e) {
            // 返回异常结果的 CompletableFuture
            CompletableFuture<String> future = new CompletableFuture<>();
            future.completeExceptionally(e);
            return future;
        }
    }
}
```

调用时处理异常：

```java
@GetMapping("/exception")
public String handleException() {
    CompletableFuture<String> future = asyncExceptionService.asyncWithException();
    
    return future
        .thenApply(result -> "结果: " + result)
        .exceptionally(ex -> "捕获异常: " + ex.getCause().getMessage())
        .join();
}
```

#danger[
  异步方法中的未捕获异常会被线程池的异常处理器吞掉，不会传播到调用线程。务必做好异常处理和日志记录。
]

== 高级定时任务

=== 动态定时任务

在实际业务中，经常需要动态调整定时任务的执行时间或启停状态，而不是在代码中硬编码 Cron 表达式。

==== 基于数据库的动态配置

将定时任务的配置存储在数据库中，通过管理界面动态修改：

```java
import org.springframework.scheduling.Trigger;
import org.springframework.scheduling.TriggerContext;
import org.springframework.scheduling.annotation.SchedulingConfigurer;
import org.springframework.scheduling.config.ScheduledTaskRegistrar;
import org.springframework.scheduling.support.CronTrigger;
import org.springframework.stereotype.Component;

@Component
public class DynamicScheduledTask implements SchedulingConfigurer {
    
    @Autowired
    private TaskConfigRepository taskConfigRepository;
    
    @Override
    public void configureTasks(ScheduledTaskRegistrar taskRegistrar) {
        taskRegistrar.addTriggerTask(
            // 任务逻辑
            () -> {
                System.out.println("执行动态定时任务: " + LocalDateTime.now());
                // 执行业务逻辑
            },
            // 触发器：从数据库读取 Cron 表达式
            new Trigger() {
                @Override
                public Date nextExecutionTime(TriggerContext triggerContext) {
                    // 从数据库获取最新的 Cron 表达式
                    String cron = taskConfigRepository.findCronByTaskName("dynamicTask");
                    if (cron == null || cron.isEmpty()) {
                        return null; // 任务暂停
                    }
                    CronTrigger trigger = new CronTrigger(cron);
                    return trigger.nextExecutionTime(triggerContext);
                }
            }
        );
    }
}
```

数据库表设计示例：

#tex-table(
  ("字段", "类型", "说明"),
  ("id", "BIGINT", "主键"),
  ("task_name", "VARCHAR(100)", "任务名称（唯一）"),
  ("cron_expression", "VARCHAR(50)", "Cron 表达式"),
  ("enabled", "BOOLEAN", "是否启用"),
  ("description", "VARCHAR(500)", "任务描述"),
  ("update_time", "DATETIME", "最后更新时间"),
)

==== 使用 TaskScheduler 动态注册

通过 `TaskScheduler` 可以在运行时动态创建和取消定时任务：

```java
import org.springframework.scheduling.TaskScheduler;
import org.springframework.scheduling.support.CronTrigger;
import org.springframework.stereotype.Service;
import java.util.concurrent.ScheduledFuture;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class DynamicTaskService {
    
    @Autowired
    private TaskScheduler taskScheduler;
    
    // 存储已调度的任务
    private Map<String, ScheduledFuture<?>> scheduledTasks = new ConcurrentHashMap<>();
    
    /**
     * 动态添加定时任务
     */
    public void addTask(String taskId, Runnable task, String cronExpression) {
        // 如果任务已存在，先取消
        cancelTask(taskId);
        
        // 注册新任务
        ScheduledFuture<?> future = taskScheduler.schedule(
            task,
            new CronTrigger(cronExpression)
        );
        
        scheduledTasks.put(taskId, future);
        System.out.println("任务 " + taskId + " 已注册，Cron: " + cronExpression);
    }
    
    /**
     * 取消定时任务
     */
    public void cancelTask(String taskId) {
        ScheduledFuture<?> future = scheduledTasks.remove(taskId);
        if (future != null) {
            future.cancel(false);
            System.out.println("任务 " + taskId + " 已取消");
        }
    }
    
    /**
     * 更新任务的 Cron 表达式
     */
    public void updateTaskCron(String taskId, String newCron) {
        // 先取消旧任务
        cancelTask(taskId);
        
        // 重新注册（需要重新传入任务逻辑）
        // 实际应用中可以从数据库或其他存储中获取任务逻辑
        System.out.println("任务 " + taskId + " 的 Cron 已更新为: " + newCron);
    }
}
```

#tip[
  动态定时任务适合场景：用户自定义报表生成时间、灵活的活动提醒、可配置的清理策略等。
]

#warning[
  动态任务需要注意线程安全问题，建议使用 `ConcurrentHashMap` 存储任务引用，并在操作时做好同步控制。
]

=== 分布式定时任务

在微服务架构或多实例部署的场景下，同一个定时任务可能在多个节点上同时执行，导致数据重复处理等问题。

==== 常见问题

#tex-table(
  ("问题", "说明", "影响"),
  ("重复执行", "多实例同时执行同一任务", "数据重复、资源浪费"),
  ("单点故障", "某个实例宕机导致任务不执行", "业务中断"),
  ("负载不均", "某些实例执行过多任务", "性能瓶颈"),
)

==== 解决方案对比

#tex-table(
  ("方案", "优点", "缺点", "适用场景"),
  ("数据库锁", "实现简单", "性能较差，有锁竞争", "小规模应用"),
  ("Redis 分布式锁", "性能好，实现相对简单", "需要 Redis 依赖", "中等规模应用"),
  ("Quartz 集群", "功能完善，支持持久化", "配置复杂，重量级", "大型企业应用"),
  ("XXL-JOB", "可视化界面，功能强大", "需要额外部署调度中心", "微服务架构"),
  ("Elastic-Job", "去中心化，高可用", "依赖 ZooKeeper", "高并发场景"),
)

==== 基于 Redis 的分布式锁实现

===== 步骤一：添加依赖

在 pom.xml 中添加 Spring Data Redis：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
```

#note[
  Spring Boot 3.2.4 默认使用 Lettuce 作为 Redis 客户端。如果需要，也可以切换到 Jedis。
]

===== 步骤二：配置 Redis 连接

在 application.yml 中配置：

```yaml
spring:
  data:
    redis:
      host: localhost
      port: 6379
      password: your_password  # 如果有密码
      database: 0
      lettuce:
        pool:
          max-active: 8
          max-idle: 8
          min-idle: 0
```

===== 步骤三：实现分布式锁服务

```java
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.script.DefaultRedisScript;
import org.springframework.stereotype.Component;
import java.util.Collections;
import java.util.concurrent.TimeUnit;

@Component
public class DistributedLockService {
    
    @Autowired
    private StringRedisTemplate redisTemplate;
    
    /**
     * 尝试获取分布式锁
     * @param lockKey 锁的 key
     * @param requestId 请求标识（用于释放锁时验证）
     * @param expireTime 锁的过期时间（秒）
     * @return 是否获取成功
     */
    public boolean tryLock(String lockKey, String requestId, long expireTime) {
        Boolean result = redisTemplate.opsForValue()
            .setIfAbsent(lockKey, requestId, expireTime, TimeUnit.SECONDS);
        return result != null && result;
    }
    
    /**
     * 释放分布式锁
     * @param lockKey 锁的 key
     * @param requestId 请求标识
     * @return 是否释放成功
     */
    public boolean releaseLock(String lockKey, String requestId) {
        String script = "if redis.call('get', KEYS[1]) == ARGV[1] then " +
                       "return redis.call('del', KEYS[1]) else return 0 end";
        Long result = redisTemplate.execute(
            new DefaultRedisScript<>(script, Long.class),
            Collections.singletonList(lockKey),
            requestId
        );
        return result != null && result == 1;
    }
}
```

在定时任务中使用分布式锁：

```java
@Component
public class DistributedScheduledTask {
    
    @Autowired
    private DistributedLockService lockService;
    
    @Scheduled(cron = "0 0 2 * * ?")
    public void distributedTask() {
        String lockKey = "lock:daily-report-task";
        String requestId = UUID.randomUUID().toString();
        
        try {
            // 尝试获取锁，过期时间设置为任务预计执行时间的 2 倍
            boolean locked = lockService.tryLock(lockKey, requestId, 600);
            
            if (!locked) {
                System.out.println("其他实例正在执行，跳过本次任务");
                return;
            }
            
            System.out.println("获取锁成功，开始执行任务");
            
            // 执行业务逻辑
            executeBusinessLogic();
            
        } catch (Exception e) {
            log.error("定时任务执行失败", e);
        } finally {
            // 确保释放锁
            lockService.releaseLock(lockKey, requestId);
            System.out.println("锁已释放");
        }
    }
    
    private void executeBusinessLogic() {
        // 业务逻辑
    }
}
```

#note[
  使用 Redis 分布式锁时，务必设置合理的过期时间，防止死锁。同时，释放锁时要验证锁的持有者，避免误删其他线程的锁。
]

==== XXL-JOB 集成

XXL-JOB 是一个轻量级分布式任务调度平台，提供了可视化的管理界面。

核心特性：

- 可视化任务管理
- 弹性扩容缩容
- 故障转移和失败重试
- 分片广播任务
- 多种路由策略
- 实时日志查看

===== 步骤一：部署调度中心

下载并启动 xxl-job-admin（调度中心）：

```bash
# 从 GitHub 下载
git clone https://github.com/xuxueli/xxl-job.git
cd xxl-job

# 执行数据库脚本（tables_xxl_job.sql）
mysql -u root -p < doc/db/tables_xxl_job.sql

# 修改配置文件 application.properties
# 设置数据库连接信息

# 编译并启动
mvn clean package
cd xxl-job-admin/target
java -jar xxl-job-admin-2.4.0.jar
```

访问 http://localhost:8080/xxl-job-admin，默认账号密码为 admin/123456。

===== 步骤二：引入依赖

在 Spring Boot 项目的 pom.xml 中添加：

```xml
<dependency>
    <groupId>com.xuxueli</groupId>
    <artifactId>xxl-job-core</artifactId>
    <version>2.4.0</version>
</dependency>
```

#caution[
  XXL-JOB 2.4.0 版本兼容 Spring Boot 3.x。如果使用更早版本，可能需要额外配置。
]

===== 步骤三：配置连接信息

在 application.yml 中配置：

```yaml
xxl:
  job:
    admin:
      addresses: http://127.0.0.1:8080/xxl-job-admin  # 调度中心地址
    executor:
      appname: my-springboot-app  # 执行器名称
      port: 9999  # 执行器端口
      logpath: /data/applogs/xxl-job/jobhandler  # 日志路径
      logretentiondays: 30  # 日志保留天数
    accessToken: default_token  # 通信令牌（可选）
```

===== 步骤四：创建配置类

```java
import com.xxl.job.core.executor.impl.XxlJobSpringExecutor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class XxlJobConfig {
    
    @Value("${xxl.job.admin.addresses}")
    private String adminAddresses;
    
    @Value("${xxl.job.executor.appname}")
    private String appName;
    
    @Value("${xxl.job.executor.port}")
    private int port;
    
    @Value("${xxl.job.accessToken:}")
    private String accessToken;
    
    @Value("${xxl.job.executor.logpath}")
    private String logPath;
    
    @Value("${xxl.job.executor.logretentiondays}")
    private int logRetentionDays;
    
    @Bean
    public XxlJobSpringExecutor xxlJobExecutor() {
        XxlJobSpringExecutor executor = new XxlJobSpringExecutor();
        executor.setAdminAddresses(adminAddresses);
        executor.setAppname(appName);
        executor.setPort(port);
        executor.setAccessToken(accessToken);
        executor.setLogPath(logPath);
        executor.setLogRetentionDays(logRetentionDays);
        return executor;
    }
}
```

===== 步骤五：创建任务类

使用 `@XxlJob` 注解定义任务：

```java
import com.xxl.job.core.handler.annotation.XxlJob;
import com.xxl.job.core.context.XxlJobHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

@Component
public class SampleXxlJob {
    
    private static final Logger logger = LoggerFactory.getLogger(SampleXxlJob.class);
    
    /**
     * 简单任务示例
     */
    @XxlJob("demoJobHandler")
    public void demoJobHandler() throws Exception {
        logger.info("XXL-JOB 任务开始执行");
        
        // 获取任务参数
        String param = XxlJobHelper.getJobParam();
        logger.info("任务参数: {}", param);
        
        // 执行业务逻辑
        for (int i = 0; i < 5; i++) {
            logger.info("执行进度: {}/5", i + 1);
            Thread.sleep(1000);
        }
        
        // 设置任务结果
        XxlJobHelper.handleSuccess("任务执行成功");
        logger.info("XXL-JOB 任务执行完成");
    }
    
    /**
     * 分片任务示例
     */
    @XxlJob("shardingJobHandler")
    public void shardingJobHandler() throws Exception {
        // 分片参数
        int shardIndex = XxlJobHelper.getShardIndex();
        int shardTotal = XxlJobHelper.getShardTotal();
        
        logger.info("分片任务执行，当前分片: {}/{}", shardIndex, shardTotal);
        
        // 根据分片参数处理数据
        // 例如：查询 id % shardTotal == shardIndex 的数据
        List<Data> dataList = dataRepository.findByShard(shardIndex, shardTotal);
        
        for (Data data : dataList) {
            processData(data);
        }
        
        XxlJobHelper.handleSuccess("分片任务完成");
    }
    
    private void processData(Data data) {
        // 处理单条数据
    }
}
```

===== 步骤六：管理界面配置

1. 登录 XXL-JOB 管理界面
2. 进入「执行器管理」，确认执行器已注册
3. 进入「任务管理」，点击「新增」
4. 配置任务信息：
   - 执行器：选择 my-springboot-app
   - 任务描述：填写任务说明
   - 负责人：填写负责人
   - 调度类型：选择 CRON
   - Cron 表达式：输入 cron 表达式（如 0 0 2 * * ?）
   - 运行模式：选择 BEAN
   - JobHandler：填写 `@XxlJob` 注解的值（如 demoJobHandler）
   - 路由策略：选择第一个、轮询、故障转移等
5. 保存后可以在任务列表中启动/停止任务

#tip[
  XXL-JOB 支持在线查看任务执行日志，便于问题排查。建议在任务中使用 logger 记录关键信息。
]

#warning[
  生产环境务必修改默认的 accessToken，并配置防火墙规则限制调度中心的访问权限。
]

=== Quartz 框架集成

Quartz 是一个功能强大的开源作业调度框架，支持复杂的调度需求和持久化。

#info[
  Spring Boot 3.2.4 内置支持 Quartz 2.3.2 版本，无需额外指定版本号。
]

==== 核心概念

#tex-table(
  ("概念", "说明"),
  ("Job", "执行的任务接口，定义 execute 方法"),
  ("JobDetail", "任务的详细信息，包括名称、组、参数等"),
  ("Trigger", "触发器，定义任务何时执行"),
  ("Scheduler", "调度器，管理 Job 和 Trigger"),
  ("Calendar", "日历，排除特定日期"),
  ("JobStore", "任务存储，支持内存和数据库"),
)

==== Spring Boot 集成 Quartz

===== 步骤一：添加依赖

在 pom.xml 中添加 Quartz starter：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-quartz</artifactId>
</dependency>
```

#note[
  Spring Boot 3.2.4 会自动管理 Quartz 的版本（2.3.2），无需手动指定 version。
]

===== 步骤二：定义 Job 类

创建实现 `Job` 接口的类：

```java
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.quartz.JobDataMap;
import org.springframework.stereotype.Component;
import java.time.LocalDateTime;

@Component
public class ReportJob implements Job {
    
    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        System.out.println("Quartz 任务执行: " + LocalDateTime.now());
        
        // 获取任务参数
        JobDataMap dataMap = context.getMergedJobDataMap();
        String reportType = dataMap.getString("reportType");
        
        System.out.println("报表类型: " + reportType);
        
        // 执行业务逻辑
        generateReport(reportType);
    }
    
    private void generateReport(String reportType) {
        // 生成报表逻辑
        System.out.println("生成 " + reportType + " 报表");
    }
}
```

#caution[
  Job 类必须由无参构造函数，且应该是线程安全的（因为可能被多个线程同时执行）。
]

===== 步骤三：配置 JobDetail 和 Trigger

创建配置类定义任务的详细信息和触发器：

```java
import org.quartz.*;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class QuartzConfig {
    
    @Bean
    public JobDetail reportJobDetail() {
        return JobBuilder.newJob(ReportJob.class)
            .withIdentity("reportJob", "reportGroup")
            .withDescription("日报生成任务")
            .storeDurably()  // 即使没有 Trigger 关联也持久化
            .build();
    }
    
    @Bean
    public Trigger reportJobTrigger() {
        // 每天凌晨 2 点执行
        CronScheduleBuilder scheduleBuilder = CronScheduleBuilder
            .cronSchedule("0 0 2 * * ?");
        
        return TriggerBuilder.newTrigger()
            .forJob(reportJobDetail())
            .withIdentity("reportTrigger", "reportGroup")
            .withDescription("每天凌晨2点触发")
            .withSchedule(scheduleBuilder)
            .build();
    }
}
```

#tip[
  `withIdentity(name, group)` 中的 group 参数可以用于对任务进行分类管理。
]

==== Quartz 持久化配置

使用数据库存储任务信息，支持集群模式：

===== 步骤一：配置 application.yml

```yaml
spring:
  quartz:
    job-store-type: jdbc  # 使用数据库存储
    jdbc:
      initialize-schema: always  # 自动创建表结构（生产环境建议改为 never）
    properties:
      org:
        quartz:
          scheduler:
            instanceName: clusteredScheduler
            instanceId: AUTO  # 自动生成实例 ID
          jobStore:
            class: org.quartz.impl.jdbcjobstore.JobStoreTX
            driverDelegateClass: org.quartz.impl.jdbcjobstore.StdJDBCDelegate
            tablePrefix: QRTZ_  # 表前缀
            isClustered: true  # 启用集群模式
            clusterCheckinInterval: 10000  # 集群检查间隔（毫秒）
            useProperties: false
          threadPool:
            class: org.quartz.simpl.SimpleThreadPool
            threadCount: 10  # 线程池大小
            threadPriority: 5
```

#info[
  Quartz 持久化需要执行官方提供的 SQL 脚本创建 11 张表，Spring Boot 可以自动初始化（initialize-schema: always）。生产环境建议将 SQL 脚本保存到版本控制中，并将此选项设为 never。
]

===== 步骤二：数据源配置

确保项目中配置了数据源（以 MySQL 为例）：

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/quartz_db?useSSL=false&serverTimezone=UTC
    username: root
    password: your_password
    driver-class-name: com.mysql.cj.jdbc.Driver
```

添加 MySQL 驱动依赖：

```xml
<dependency>
    <groupId>com.mysql</groupId>
    <artifactId>mysql-connector-j</artifactId>
    <scope>runtime</scope>
</dependency>
```

===== 步骤三：验证表结构

启动应用后，数据库中会自动创建以下 11 张表：

#tex-table(
  ("表名", "用途"),
  ("QRTZ_CALENDARS", "存储 Calendar 信息"),
  ("QRTZ_CRON_TRIGGERS", "存储 CronTrigger 信息"),
  ("QRTZ_FIRED_TRIGGERS", "存储已触发的 Trigger"),
  ("QRTZ_JOB_DETAILS", "存储 JobDetail 信息"),
  ("QRTZ_LOCKS", "存储锁信息"),
  ("QRTZ_PAUSED_TRIGGER_GRPS", "存储暂停的 Trigger 组"),
  ("QRTZ_SCHEDULER_STATE", "存储调度器状态"),
  ("QRTZ_SIMPLE_TRIGGERS", "存储 SimpleTrigger 信息"),
  ("QRTZ_SIMPROP_TRIGGERS", "存储 SimpropTrigger 信息"),
  ("QRTZ_TRIGGERS", "存储 Trigger 基本信息"),
  ("QRTZ_BLOB_TRIGGERS", "存储 BlobTrigger 信息"),
)

#warning[
  集群模式下，所有节点必须使用相同的数据源配置。确保数据库连接稳定，否则可能导致任务重复执行或丢失。
]

==== SimpleTrigger 与 CronTrigger

Quartz 提供两种主要的触发器类型：

*SimpleTrigger*：简单的周期性触发

```java
@Bean
public Trigger simpleTrigger() {
    return TriggerBuilder.newTrigger()
        .forJob(simpleJobDetail())
        .withIdentity("simpleTrigger")
        .startAt(new Date(System.currentTimeMillis() + 5000)) // 5秒后开始
        .withSchedule(SimpleScheduleBuilder.simpleSchedule()
            .withIntervalInSeconds(10)  // 每10秒执行
            .repeatForever())           // 无限重复
        .build();
}
```

*CronTrigger*：基于 Cron 表达式的触发

```java
@Bean
public Trigger cronTrigger() {
    return TriggerBuilder.newTrigger()
        .forJob(cronJobDetail())
        .withIdentity("cronTrigger")
        .withSchedule(CronScheduleBuilder.cronSchedule("0 0/5 * * * ?"))
        .build();
}
```

#tex-table(
  ("特性", "SimpleTrigger", "CronTrigger"),
  ("适用场景", "固定间隔执行", "复杂时间规则"),
  ("配置难度", "简单", "需要掌握 Cron 语法"),
  ("灵活性", "较低", "高"),
  ("示例", "每5分钟执行", "工作日9-17点每小时执行"),
)

==== 动态管理 Quartz 任务

通过 `Scheduler` API 可以在运行时动态管理任务：

```java
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class QuartzTaskService {
    
    @Autowired
    private Scheduler scheduler;
    
    /**
     * 添加任务
     */
    public void addJob(String jobName, String jobGroup, String cronExpression) 
            throws SchedulerException {
        JobDetail jobDetail = JobBuilder.newJob(ReportJob.class)
            .withIdentity(jobName, jobGroup)
            .build();
        
        CronTrigger trigger = TriggerBuilder.newTrigger()
            .withIdentity(jobName + "_trigger", jobGroup)
            .withSchedule(CronScheduleBuilder.cronSchedule(cronExpression))
            .build();
        
        scheduler.scheduleJob(jobDetail, trigger);
    }
    
    /**
     * 暂停任务
     */
    public void pauseJob(String jobName, String jobGroup) throws SchedulerException {
        scheduler.pauseJob(JobKey.jobKey(jobName, jobGroup));
    }
    
    /**
     * 恢复任务
     */
    public void resumeJob(String jobName, String jobGroup) throws SchedulerException {
        scheduler.resumeJob(JobKey.jobKey(jobName, jobGroup));
    }
    
    /**
     * 删除任务
     */
    public void deleteJob(String jobName, String jobGroup) throws SchedulerException {
        scheduler.deleteJob(JobKey.jobKey(jobName, jobGroup));
    }
    
    /**
     * 立即执行任务
     */
    public void triggerJob(String jobName, String jobGroup) throws SchedulerException {
        scheduler.triggerJob(JobKey.jobKey(jobName, jobGroup));
    }
}
```

#tip[
  动态管理功能适合需要用户自定义任务时间的场景，如用户设置的提醒、定期报表等。
]

== 异步编程最佳实践

=== 异常处理机制

异步编程中的异常处理比同步代码更复杂，因为异常不会直接传播到调用线程。

==== 全局异常处理器

为异步线程池配置全局异常处理器：

```java
import org.springframework.aop.interceptor.AsyncUncaughtExceptionHandler;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.AsyncConfigurer;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import java.lang.reflect.Method;
import java.util.concurrent.Executor;

@Configuration
public class AsyncExceptionConfig implements AsyncConfigurer {
    
    @Override
    public Executor getAsyncExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(5);
        executor.setMaxPoolSize(10);
        executor.setQueueCapacity(100);
        executor.setThreadNamePrefix("async-");
        
        // 设置异常处理器
        executor.setRejectedExecutionHandler(new ThreadPoolExecutor.CallerRunsPolicy());
        
        executor.initialize();
        return executor;
    }
    
    @Override
    public AsyncUncaughtExceptionHandler getAsyncUncaughtExceptionHandler() {
        return new CustomAsyncExceptionHandler();
    }
}

class CustomAsyncExceptionHandler implements AsyncUncaughtExceptionHandler {
    
    private static final Logger log = LoggerFactory.getLogger(CustomAsyncExceptionHandler.class);
    
    @Override
    public void handleUncaughtException(Throwable ex, Method method, Object... params) {
        log.error("异步方法 {} 执行异常，参数: {}", method.getName(), params, ex);
        
        // 可以发送邮件告警、记录监控指标等
        // alertService.sendAlert(ex.getMessage());
    }
}
```

==== CompletableFuture 异常处理

```java
@Service
public class ExceptionHandlingService {
    
    @Async
    public CompletableFuture<String> riskyOperation() {
        return CompletableFuture.supplyAsync(() -> {
            // 可能抛出异常的操作
            if (Math.random() > 0.5) {
                throw new RuntimeException("业务异常");
            }
            return "成功";
        }).exceptionally(ex -> {
            log.error("异步操作失败", ex);
            return "降级结果";
        });
    }
    
    // 链式异常处理
    public CompletableFuture<String> chainedWithErrorHandling() {
        return asyncMethod1()
            .thenCompose(result1 -> asyncMethod2(result1))
            .thenApply(result2 -> transform(result2))
            .exceptionally(ex -> {
                log.error("链式调用失败", ex);
                return "默认值";
            });
    }
}
```

#caution[
  不要在 `exceptionally` 中再次抛出异常，这会导致异常被吞掉。应该返回一个合理的默认值或错误标识。
]

==== 超时控制

为异步操作设置超时，防止长时间阻塞：

```java
@GetMapping("/timeout")
public String handleWithTimeout() {
    CompletableFuture<String> future = asyncService.slowOperation();
    
    try {
        // 设置 3 秒超时
        String result = future.get(3, TimeUnit.SECONDS);
        return result;
    } catch (TimeoutException e) {
        future.cancel(true); // 取消任务
        return "操作超时";
    } catch (Exception e) {
        return "执行失败: " + e.getMessage();
    }
}
```

或者使用 `orTimeout`（Java 9+）：

```java
CompletableFuture<String> result = asyncService.slowOperation()
    .orTimeout(3, TimeUnit.SECONDS)
    .exceptionally(ex -> "超时或失败: " + ex.getMessage());
```

=== 上下文传递

异步执行时，ThreadLocal 中的上下文信息（如用户信息、请求 ID、事务上下文等）不会自动传递到子线程。

==== 问题演示

```java
// 主线程设置上下文
RequestContext.setUser(currentUser);

// 异步方法中无法获取
@Async
public void asyncMethod() {
    User user = RequestContext.getUser(); // null!
}
```

==== 解决方案一：手动传递参数

最简单直接的方式是通过方法参数传递：

```java
@Async
public void asyncMethodWithContext(User user, String requestId) {
    // 直接使用传入的参数
    log.info("用户: {}, 请求ID: {}", user.getUsername(), requestId);
    // 业务逻辑
}
```

#tip[
  这是最推荐的方式，简单可靠，没有额外的复杂性。
]

==== 解决方案二：使用 TaskDecorator

Spring 5.0 引入了 `TaskDecorator`，可以在任务提交到线程池时复制上下文：

```java
import org.springframework.core.task.TaskDecorator;

public class ContextCopyingDecorator implements TaskDecorator {
    
    @Override
    public Runnable decorate(Runnable runnable) {
        // 捕获主线程的上下文
        RequestAttributes context = RequestContextHolder.currentRequestAttributes();
        User currentUser = RequestContext.getCurrentUser();
        String requestId = MDC.get("requestId");
        
        return () -> {
            try {
                // 在子线程中恢复上下文
                RequestContextHolder.setRequestAttributes(context);
                RequestContext.setCurrentUser(currentUser);
                MDC.put("requestId", requestId);
                
                // 执行原始任务
                runnable.run();
            } finally {
                // 清理上下文，防止内存泄漏
                RequestContextHolder.resetRequestAttributes();
                MDC.clear();
            }
        };
    }
}
```

配置线程池使用装饰器：

```java
@Bean("taskExecutor")
public Executor taskExecutor() {
    ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
    executor.setCorePoolSize(5);
    executor.setMaxPoolSize(10);
    executor.setQueueCapacity(100);
    executor.setThreadNamePrefix("async-");
    
    // 设置任务装饰器
    executor.setTaskDecorator(new ContextCopyingDecorator());
    
    executor.initialize();
    return executor;
}
```

==== 解决方案三：使用 InheritableThreadLocal

对于简单的场景，可以使用 `InheritableThreadLocal` 代替 `ThreadLocal`：

```java
public class RequestContext {
    // 使用 InheritableThreadLocal
    private static final InheritableThreadLocal<User> currentUser = 
        new InheritableThreadLocal<>();
    
    public static void setUser(User user) {
        currentUser.set(user);
    }
    
    public static User getUser() {
        return currentUser.get();
    }
    
    public static void clear() {
        currentUser.remove();
    }
}
```

#caution[
  `InheritableThreadLocal` 只在*线程创建时*复制父线程的值，如果父线程后续修改了值，子线程不会感知。且在线程池场景下，线程复用会导致上下文混乱，不推荐在生产环境使用。
]

==== MDC 上下文传递

在日志系统中，MDC（Mapped Diagnostic Context）用于追踪请求链路：

```java
import org.slf4j.MDC;

// 过滤器中设置 MDC
@Component
public class RequestIdFilter implements Filter {
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, 
                         FilterChain chain) throws IOException, ServletException {
        String requestId = UUID.randomUUID().toString();
        MDC.put("requestId", requestId);
        
        try {
            chain.doFilter(request, response);
        } finally {
            MDC.clear();
        }
    }
}
```

配合 `TaskDecorator` 实现 MDC 在异步线程中的传递（见上文示例）。

=== 性能调优与监控

==== 线程池参数调优

根据任务类型选择合适的线程池配置：

#tex-table(
  ("任务类型", "CPU 密集型", "IO 密集型", "混合型"),
  ("特点", "计算密集，少等待", "大量 IO 操作，多等待", "既有计算又有 IO"),
  ("核心线程数", "CPU 核数 + 1", "CPU 核数 × 2", "根据实际情况调整"),
  ("最大线程数", "CPU 核数 + 1", "CPU 核数 × 4", "CPU 核数 × 2~4"),
  ("队列容量", "较小（10-50）", "较大（100-1000）", "适中（50-200）"),
  ("示例场景", "加密解密、图像处理", "数据库查询、HTTP 请求", "一般业务逻辑"),
)

计算公式参考：

- *CPU 密集型*：N(cpu) + 1
- *IO 密集型*：N(cpu) / (1 - 阻塞系数)，阻塞系数通常在 0.8~0.9 之间

#info[
  实际生产中，建议通过压测和监控来确定最优参数，理论公式仅供参考。
]

==== 监控指标

关键监控指标：

#tex-table(
  ("指标", "说明", "告警阈值"),
  ("活跃线程数", "当前正在执行任务的线程数", "接近最大线程数"),
  ("队列大小", "等待执行的任务数量", "超过队列容量的 80%"),
  ("任务完成时间", "平均任务执行时长", "超过预期时间"),
  ("拒绝次数", "被拒绝执行的任务数", "大于 0"),
  ("线程池活跃度", "活跃线程数 / 最大线程数", "持续高于 80%"),
)

实现监控：

```java
import io.micrometer.core.instrument.MeterRegistry;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import org.springframework.stereotype.Component;
import javax.annotation.PostConstruct;

@Component
public class ThreadPoolMonitor {
    
    @Autowired
    private ThreadPoolTaskExecutor taskExecutor;
    
    @Autowired
    private MeterRegistry meterRegistry;
    
    @PostConstruct
    public void init() {
        // 注册监控指标
        meterRegistry.gauge("thread.pool.active", taskExecutor, 
            executor -> executor.getActiveCount());
        meterRegistry.gauge("thread.pool.queue.size", taskExecutor,
            executor -> executor.getThreadPoolExecutor().getQueue().size());
        meterRegistry.gauge("thread.pool.completed.tasks", taskExecutor,
            executor -> (double) executor.getThreadPoolExecutor().getCompletedTaskCount());
        meterRegistry.gauge("thread.pool.rejected.tasks", taskExecutor,
            executor -> (double) executor.getThreadPoolExecutor().getRejectedExecutionHandler());
    }
}
```

配合 Prometheus + Grafana 可以实现可视化监控和告警。

==== 常见问题与优化

*问题 1：线程池耗尽*

现象：任务被拒绝或长时间等待。

解决方案：
- 增加线程池大小
- 优化任务执行时间
- 使用有界队列 + 合适的拒绝策略
- 考虑任务拆分和并行化

*问题 2：内存泄漏*

现象：应用运行一段时间后 OOM。

原因：
- ThreadLocal 未清理
- 任务持有大对象引用
- 队列积压过多任务

解决方案：
- 确保在 finally 块中清理 ThreadLocal
- 及时释放大对象引用
- 设置合理的队列容量

*问题 3：任务堆积*

现象：队列持续增长，响应变慢。

解决方案：
- 增加消费者（线程数）
- 优化单个任务性能
- 实现背压机制（拒绝新任务）
- 考虑使用消息队列削峰填谷

#warning[
  定期审查线程池的运行状态，通过日志和监控及时发现潜在问题。不要等到生产环境出现故障才进行优化。
]

==== 调试技巧

#tex-table(
  ("技巧", "说明"),
  ("线程命名", "为线程池设置有意义的名称前缀，便于排查"),
  ("日志增强", "在异步方法入口和出口记录日志，包含线程名和时间戳"),
  ("超时检测", "为长时间运行的任务设置超时和告警"),
  ("链路追踪", "使用 requestId 贯穿整个调用链"),
  ("单元测试", "编写异步方法的单元测试，验证异常处理和返回值"),
)

示例：增强的日志记录

```java
@Async
public CompletableFuture<String> tracedAsyncMethod(String param) {
    String threadName = Thread.currentThread().getName();
    String requestId = MDC.get("requestId");
    long startTime = System.currentTimeMillis();
    
    log.info("[{}] 异步任务开始, requestId={}, param={}", 
             threadName, requestId, param);
    
    try {
        // 业务逻辑
        String result = doBusinessLogic(param);
        
        long duration = System.currentTimeMillis() - startTime;
        log.info("[{}] 异步任务完成, duration={}ms", threadName, duration);
        
        return CompletableFuture.completedFuture(result);
    } catch (Exception e) {
        long duration = System.currentTimeMillis() - startTime;
        log.error("[{}] 异步任务失败, duration={}ms", threadName, duration, e);
        
        CompletableFuture<String> future = new CompletableFuture<>();
        future.completeExceptionally(e);
        return future;
    }
}
```

#fancy-divider

== 本章小结

通过本章的学习，我们掌握了 Spring Boot 中定时任务和异步处理的核心知识：

=== 定时任务

- *基础使用*：`@Scheduled` 注解支持 fixedRate、fixedDelay 和 Cron 表达式
- *动态任务*：通过 SchedulingConfigurer 或 TaskScheduler 实现运行时调整
- *分布式任务*：使用 Redis 分布式锁、XXL-JOB 或 Quartz 集群解决多实例问题
- *Quartz 集成*：功能强大的企业级调度框架，支持持久化和复杂调度

=== 异步处理

- *`@Async` 注解*：简单实现方法异步执行
- *线程池配置*：自定义 ThreadPoolTaskExecutor，避免使用默认的 SimpleAsyncTaskExecutor
- *CompletableFuture*：强大的异步编程工具，支持链式调用和组合
- *上下文传递*：通过 TaskDecorator 或参数传递解决 ThreadLocal 失效问题

=== 最佳实践

- *异常处理*：配置全局异常处理器，使用 CompletableFuture.exceptionally()
- *性能调优*：根据任务类型（CPU/IO 密集型）合理配置线程池参数
- *监控告警*：使用 Micrometer + Prometheus 监控线程池状态
- *日志追踪*：通过 MDC 和 requestId 实现完整的链路追踪

#tip[
  在实际项目中，建议：
  - 优先使用 Spring Boot 内置的 `@Scheduled` 和 `@Async`
  - 对于复杂的调度需求，考虑使用 Quartz 或 XXL-JOB
  - 始终配置自定义线程池，不要使用默认配置
  - 做好异常处理和监控，便于问题排查
]

#warning[
  异步编程虽然能提升性能，但也增加了系统的复杂性。在使用前务必评估是否真的需要异步，避免过度设计。
]

#fancy-divider

本章完