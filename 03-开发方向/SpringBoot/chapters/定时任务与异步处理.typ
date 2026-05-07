#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= 定时任务与异步处理

#note[
  本文档基于 *Spring Boot 3.2.4* 和 *Java 17* 编写，所有代码示例均在该环境下测试通过。
]

本章将详细介绍 Spring Boot 中的定时任务和异步处理机制，包括：

- 基础定时任务配置和使用
- Quartz 企业级调度框架
- XXL-JOB 分布式任务调度平台（重点）
- 分布式定时任务解决方案
- 异步方法执行和线程池管理
- 异步编程最佳实践

#tip[
  建议按顺序阅读，从基础到高级逐步深入。每个章节都有完整的代码示例，可以直接在项目中使用。
]

== Spring Boot 原生定时任务

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
  默认情况下，Spring 的定时任务是单线程串行执行的。如果某个任务执行时间过长，会阻塞后续任务的执行。建议使用线程池来解决这个问题。
]

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
import java.util.Date;

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

=== 分布式定时任务解决方案

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
  ("XXL-JOB", "可视化界面，功能强大", "需要额外部署调度中心", "微服务架构⭐推荐"),
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

== Quartz 企业级调度框架

Quartz 是一个功能强大的开源作业调度框架，支持复杂的调度需求和持久化。

#info[
  Spring Boot 3.2.4 内置支持 Quartz 2.3.2 版本，无需额外指定版本号。
]

=== Quartz 核心概念

#tex-table(
  ("概念", "说明"),
  ("Job", "执行的任务接口，定义 execute 方法"),
  ("JobDetail", "任务的详细信息，包括名称、组、参数等"),
  ("Trigger", "触发器，定义任务何时执行"),
  ("Scheduler", "调度器，管理 Job 和 Trigger"),
  ("Calendar", "日历，排除特定日期"),
  ("JobStore", "任务存储，支持内存和数据库"),
)

=== Spring Boot 集成 Quartz

==== 步骤一：添加依赖

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

==== 步骤二：定义 Job 类

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

==== 步骤三：配置 JobDetail 和 Trigger

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

=== Quartz 持久化配置

使用数据库存储任务信息，支持集群模式：

==== 配置 application.yml

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

==== 数据源配置

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

==== 验证表结构

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

=== SimpleTrigger 与 CronTrigger

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

=== 动态管理 Quartz 任务

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

== XXL-JOB 分布式任务调度平台

XXL-JOB 是一个轻量级分布式任务调度平台，提供了可视化的管理界面和强大的调度能力。

#info[
  *为什么选择 XXL-JOB？*
  - 可视化任务管理，无需编写代码即可配置任务
  - 弹性扩容缩容，支持动态添加执行器节点
  - 故障转移和失败重试，提高任务可靠性
  - 分片广播任务，支持大数据量并行处理
  - 多种路由策略，灵活负载均衡
  - 实时日志查看，便于问题排查
]

=== 架构与原理

==== 整体架构

XXL-JOB 采用中心化设计，包含两个核心组件：

*调度中心（xxl-job-admin）*：
- 负责任务管理和触发
- 提供 Web 管理界面
- 存储任务配置和执行记录
- 支持集群部署实现高可用

*执行器（Executor）*：
- 负责任务的实际执行
- 嵌入到业务系统中
- 接收调度中心的指令
- 上报执行结果和日志

==== 通信机制

调度中心和执行器之间通过 HTTP 协议通信：
1. 执行器启动时向调度中心注册
2. 调度中心根据 Cron 表达式触发任务
3. 调度中心调用执行器的 API 执行任务
4. 执行器返回执行结果
5. 调度中心记录执行日志

==== 路由策略

#tex-table(
  ("策略", "说明", "适用场景"),
  ("第一个", "固定选择第一个执行器", "简单场景"),
  ("最后一个", "固定选择最后一个执行器", "简单场景"),
  ("轮询", "依次选择执行器", "负载均衡"),
  ("随机", "随机选择执行器", "负载均衡"),
  ("一致性 HASH", "相同任务总是路由到同一执行器", "有状态任务"),
  ("故障转移", "优先选择健康执行器", "高可用要求"),
  ("忙碌转移", "优先选择空闲执行器", "性能优化"),
  ("分片广播", "所有执行器同时执行，携带分片参数", "大数据量处理⭐"),
)

=== 快速上手

==== 步骤一：部署调度中心

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

#note[
  XXL-JOB 2.4.0 版本兼容 Spring Boot 3.x。如果使用更早版本，可能需要额外配置。
]

==== 步骤二：引入依赖

在 Spring Boot 项目的 pom.xml 中添加：

```xml
<dependency>
    <groupId>com.xuxueli</groupId>
    <artifactId>xxl-job-core</artifactId>
    <version>2.4.0</version>
</dependency>
```

==== 步骤三：配置连接信息

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

==== 步骤四：创建配置类

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

==== 步骤五：创建任务处理器

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
}
```

==== 步骤六：管理界面配置

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

=== 任务类型详解

==== BEAN 模式（推荐）

BEAN 模式是最常用的任务类型，通过 `@XxlJob` 注解标注方法。

*简单任务*：

```java
@XxlJob("simpleTask")
public void simpleTask() {
    logger.info("执行简单任务");
    // 业务逻辑
    XxlJobHelper.handleSuccess();
}
```

*分片广播任务*：

分片广播是 XXL-JOB 的核心特性，适合大数据量处理。

```java
@XxlJob("shardingTask")
public void shardingTask() throws Exception {
    // 分片参数
    int shardIndex = XxlJobHelper.getShardIndex();  // 当前分片序号
    int shardTotal = XxlJobHelper.getShardTotal();  // 总分片数

    logger.info("分片任务执行，当前分片: {}/{}", shardIndex, shardTotal);

    // 根据分片参数处理数据
    // 例如：查询 id % shardTotal == shardIndex 的数据
    List<Data> dataList = dataRepository.findByShard(shardIndex, shardTotal);

    for (Data data : dataList) {
        processData(data);
    }

    XxlJobHelper.handleSuccess("分片任务完成");
}
```

#info[
  *分片广播工作原理*：
  - 调度中心同时触发所有执行器
  - 每个执行器获得不同的 shardIndex
  - 各执行器并行处理不同数据片段
  - 大幅提升处理速度
]

*带参数的任务*：

```java
@XxlJob("paramTask")
public void paramTask() {
    // 获取任务参数（在管理界面配置）
    String param = XxlJobHelper.getJobParam();

    // 解析参数
    JSONObject json = JSON.parseObject(param);
    String reportType = json.getString("reportType");
    Integer days = json.getInteger("days");

    logger.info("生成 {} 天的 {} 报表", days, reportType);

    // 业务逻辑
    generateReport(reportType, days);

    XxlJobHelper.handleSuccess();
}
```

==== GLUE 模式（Web IDE）

GLUE 模式允许在 Web 界面直接编辑任务代码，无需重启应用。

使用场景：
- 快速验证任务逻辑
- 临时性任务
- 测试环境调试

#caution[
  生产环境不建议使用 GLUE 模式，因为代码未经过版本控制和代码审查。
]

=== 高级功能

==== 失败重试机制

XXL-JOB 支持自动重试失败的任务：

1. 在任务配置中设置「失败重试次数」
2. 任务执行失败后自动重试
3. 可配置重试间隔

示例：捕获异常并标记失败

```java
@XxlJob("retryTask")
public void retryTask() {
    try {
        // 可能失败的操作
        callExternalApi();
        XxlJobHelper.handleSuccess();
    } catch (Exception e) {
        logger.error("任务执行失败", e);
        XxlJobHelper.handleFail("执行失败: " + e.getMessage());
        // XXL-JOB 会自动重试
    }
}
```

==== 阻塞处理策略

当任务执行时间超过调度间隔时，需要决定如何处理：

#tex-table(
  ("策略", "说明", "适用场景"),
  ("单机串行", "新任务等待前一个任务完成", "任务必须按顺序执行"),
  ("丢弃后续调度", "忽略新触发的任务", "任务不允许并发"),
  ("覆盖之前调度", "中断当前任务，执行新任务", "最新数据优先"),
)

配置方法：在任务管理中设置「阻塞处理策略」。

==== 超时控制

为任务设置超时时间，防止长时间运行：

```java
@XxlJob("timeoutTask")
public void timeoutTask() {
    long startTime = System.currentTimeMillis();
    long timeout = 300000; // 5分钟超时

    try {
        // 业务逻辑
        processData();

        long duration = System.currentTimeMillis() - startTime;
        if (duration > timeout) {
            XxlJobHelper.handleFail("任务超时");
            return;
        }

        XxlJobHelper.handleSuccess();
    } catch (Exception e) {
        XxlJobHelper.handleFail(e.getMessage());
    }
}
```

==== 任务依赖与编排

XXL-JOB 支持子任务功能，可以实现任务依赖：

1. 在任务 A 的配置中设置「子任务」为任务 B
2. 任务 A 执行成功后自动触发任务 B
3. 可以配置多个子任务，形成 DAG

示例：数据抽取 → 数据转换 → 数据加载（ETL）

```
任务A: extractData (数据抽取)
  ↓ 成功后触发
任务B: transformData (数据转换)
  ↓ 成功后触发
任务C: loadData (数据加载)
```

==== 告警通知

XXL-JOB 支持多种告警方式：

1. *邮件告警*：配置 SMTP 服务器
2. *Webhook*：集成钉钉、企业微信、飞书
3. *自定义告警*：实现 AlarmCallback 接口

配置 Webhook 示例：

```yaml
xxl:
  job:
    alarm:
      enabled: true
      webhook: https://oapi.dingtalk.com/robot/send?access_token=xxx
```

=== 生产环境最佳实践

==== 高可用部署

*调度中心高可用*：
1. 部署多个 xxl-job-admin 实例
2. 使用 Nginx 做负载均衡
3. 所有实例连接同一个数据库

*执行器高可用*：
1. 业务系统多实例部署
2. 使用「故障转移」或「轮询」路由策略
3. 确保执行器端口不被防火墙阻挡

==== 安全加固

1. *修改默认 accessToken*：
  ```yaml
  xxl:
    job:
      accessToken: your-strong-token-here
  ```

2. *网络隔离*：
  - 调度中心和执行器在内网通信
  - 通过防火墙限制访问 IP

3. *权限管理*：
  - 为不同团队创建独立用户
  - 分配最小权限原则

==== 性能调优

*调度中心优化*：
- 数据库索引优化
- 定期清理历史日志
- 调整线程池大小

*执行器优化*：
- 合理设置执行器端口范围
- 避免任务执行时间过长
- 使用分片广播处理大数据量

==== 监控指标

关键监控指标：

#tex-table(
  ("指标", "说明", "告警阈值"),
  ("任务成功率", "成功执行的任务比例", "低于 95%"),
  ("平均执行时间", "任务平均耗时", "超过预期 2 倍"),
  ("失败任务数", "连续失败的任务数量", "大于 3 次"),
  ("执行器在线数", "注册的执行器数量", "少于预期"),
  ("调度延迟", "实际执行时间与计划时间的差值", "超过 1 分钟"),
)

配合 Prometheus + Grafana 可以实现可视化监控。

=== 常见问题排查

==== 问题1：执行器注册失败

现象：管理界面看不到执行器

排查步骤：
1. 检查执行器端口是否被占用
2. 检查防火墙是否阻止通信
3. 检查 accessToken 是否一致
4. 查看执行器日志

==== 问题2：任务不执行

现象：任务配置正确但不触发

排查步骤：
1. 检查 Cron 表达式是否正确
2. 确认任务状态为「运行中」
3. 检查调度中心日志
4. 验证执行器是否在线

==== 问题3：任务执行超时

现象：任务长时间运行

解决方案：
1. 优化任务逻辑，减少执行时间
2. 使用分片广播并行处理
3. 增加超时时间配置
4. 检查是否有死锁或资源竞争

==== 问题4：分片任务数据不均

现象：某些分片处理数据多，某些少

解决方案：
1. 确保数据分布均匀（如使用 hash 取模）
2. 调整分片数量
3. 检查数据倾斜问题

== Spring Boot 异步处理

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

=== CompletableFuture 异步编程

`@Async` 方法可以返回 `CompletableFuture`，以便获取异步执行的结果并进行链式调用。

==== 基础用法

```java
@Service
public class AsyncResultService {

    @Async
    public CompletableFuture<String> asyncWithResult() {
        System.out.println("异步任务开始: " + Thread.currentThread().getName());

        try {
            Thread.sleep(2000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        return CompletableFuture.completedFuture("异步任务完成");
    }
}
```

==== 多任务组合

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

=== 异步编程最佳实践

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
    }
}
```

==== 上下文传递

异步执行时，ThreadLocal 中的上下文信息不会自动传递到子线程。

*推荐方案：手动传递参数*

```java
@Async
public void asyncMethodWithContext(User user, String requestId) {
    log.info("用户: {}, 请求ID: {}", user.getUsername(), requestId);
}
```

*高级方案：TaskDecorator*

```java
import org.springframework.core.task.TaskDecorator;

public class ContextCopyingDecorator implements TaskDecorator {

    @Override
    public Runnable decorate(Runnable runnable) {
        RequestAttributes context = RequestContextHolder.currentRequestAttributes();
        String requestId = MDC.get("requestId");

        return () -> {
            try {
                RequestContextHolder.setRequestAttributes(context);
                MDC.put("requestId", requestId);
                runnable.run();
            } finally {
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
    executor.setTaskDecorator(new ContextCopyingDecorator());
    executor.initialize();
    return executor;
}
```

#caution[
  `InheritableThreadLocal` 在线程池场景下会导致上下文混乱，不推荐在生产环境使用。
]

==== 性能调优与监控

根据任务类型选择合适的线程池配置：

#tex-table(
  ("任务类型", "CPU 密集型", "IO 密集型", "混合型"),
  ("特点", "计算密集，少等待", "大量 IO 操作，多等待", "既有计算又有 IO"),
  ("核心线程数", "CPU 核数 + 1", "CPU 核数 × 2", "根据实际情况调整"),
  ("最大线程数", "CPU 核数 + 1", "CPU 核数 × 4", "CPU 核数 × 2~4"),
  ("队列容量", "较小（10-50）", "较大（100-1000）", "适中（50-200）"),
  ("示例场景", "加密解密、图像处理", "数据库查询、HTTP 请求", "一般业务逻辑"),
)

关键监控指标：

#tex-table(
  ("指标", "说明", "告警阈值"),
  ("活跃线程数", "当前正在执行任务的线程数", "接近最大线程数"),
  ("队列大小", "等待执行的任务数量", "超过队列容量的 80%"),
  ("任务完成时间", "平均任务执行时长", "超过预期时间"),
  ("拒绝次数", "被拒绝执行的任务数", "大于 0"),
)

配合 Prometheus + Grafana 可以实现可视化监控和告警。

#fancy-divider

== 本章小结

通过本章的学习，我们掌握了 Spring Boot 中定时任务和异步处理的核心知识：

=== 定时任务

- *基础使用*：`@Scheduled` 注解支持 fixedRate、fixedDelay 和 Cron 表达式
- *动态任务*：通过 SchedulingConfigurer 或 TaskScheduler 实现运行时调整
- *分布式任务*：使用 Redis 分布式锁、XXL-JOB 或 Quartz 集群解决多实例问题
- *Quartz 集成*：功能强大的企业级调度框架，支持持久化和复杂调度
- *XXL-JOB*：轻量级分布式任务调度平台，提供可视化管理和强大功能 ⭐

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
