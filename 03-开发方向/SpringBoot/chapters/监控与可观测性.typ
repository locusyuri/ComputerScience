#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= 监控与可观测性

可观测性（Observability）是理解系统内部状态的能力，由三大支柱构成：*日志（Logs）*、*指标（Metrics）*、*链路追踪（Traces）*。本章聚焦于指标和追踪，日志已在第4章详细讲解。

#note[
  可观测性的目标是：当系统出现问题时，能够通过外部输出快速定位根本原因，而无需修改代码或重新部署。
]

== 可观测性三大支柱

=== Logs（日志）

*特点*：

- 离散事件记录
- 包含时间戳、级别、消息
- 适合排查具体问题

*工具*：SLF4J + Logback、ELK、Loki

#tip[
  日志的详细配置和使用见第4章《日志系统详解》。
]

=== Metrics（指标）

*特点*：

- 数值型数据，可聚合
- 随时间变化的趋势
- 适合监控和告警

*类型*：

#tex-table(
  ("类型", "特点", "示例"),
  ("Counter（计数器）", "只增不减", "请求总数、错误数"),
  ("Gauge（仪表盘）", "可增可减", "当前线程数、内存使用"),
  ("Timer（计时器）", "耗时统计", "接口响应时间"),
  ("Histogram（直方图）", "分布统计", "响应时间分布"),
)

*工具*：Micrometer、Prometheus、Grafana

=== Traces（链路追踪）

*特点*：

- 请求的完整调用链
- 跨服务的分布式追踪
- 适合性能分析和瓶颈定位

*核心概念*：

#tex-table(
  ("概念", "说明", "示例"),
  ("Trace", "完整的请求链路", "一个用户请求的全过程"),
  ("Span", "链路中的一个节点", "某个服务的调用"),
  ("Context", "传递的追踪上下文", "trace_id、span_id"),
)

*工具*：OpenTelemetry、Zipkin、Jaeger

=== 三大支柱的关系

```
问题发生
    ↓
┌─────────────────────────┐
│  Metrics 发现异常       │ ← 监控告警：CPU使用率突增
└────────────┬────────────┘
             ↓
┌─────────────────────────┐
│  Traces 定位服务        │ ← 链路追踪：哪个服务慢
└────────────┬────────────┘
             ↓
┌─────────────────────────┐
│  Logs 查找根因          │ ← 日志分析：为什么慢
└─────────────────────────┘
```

*协同工作*：

1. *Metrics* 告诉你*什么*出了问题
2. *Traces* 告诉你*哪里*出了问题
3. *Logs* 告诉你*为什么*出问题

== Actuator端点详解

=== 什么是Actuator

Spring Boot Actuator提供了生产级别的应用监控和管理功能。

*核心功能*：

- 健康检查（Health）
- 指标收集（Metrics）
- 环境信息（Environment）
- 线程转储（Thread Dump）
- HTTP追踪（HTTP Traces）

=== 启用Actuator

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

```properties
# 暴露所有端点（生产环境慎用）
management.endpoints.web.exposure.include=*

# 或者只暴露需要的端点
management.endpoints.web.exposure.include=health,info,metrics,prometheus
```

=== 常用端点

#tex-table(
  ("端点", "路径", "作用", "生产环境"),
  ("health", "/actuator/health", "应用健康状态", "✓ 推荐"),
  ("info", "/actuator/info", "应用信息", "✓ 推荐"),
  ("metrics", "/actuator/metrics", "性能指标", "✓ 推荐"),
  ("prometheus", "/actuator/prometheus", "Prometheus格式指标", "✓ 推荐"),
  ("env", "/actuator/env", "环境变量", "✗ 敏感"),
  ("threaddump", "/actuator/threaddump", "线程转储", "按需"),
  ("heapdump", "/actuator/heapdump", "堆转储", "按需"),
  ("loggers", "/actuator/loggers", "日志配置", "按需"),
)

=== health端点

*基本响应*：

```json
{
  "status": "UP",
  "components": {
    "db": {
      "status": "UP",
      "details": {
        "database": "MySQL",
        "validationQuery": "isValid()"
      }
    },
    "diskSpace": {
      "status": "UP",
      "details": {
        "total": 500000000000,
        "free": 300000000000,
        "threshold": 10485760
      }
    },
    "redis": {
      "status": "UP",
      "details": {
        "version": "6.2.6"
      }
    }
  }
}
```

*详细模式*：

```properties
# 显示详细信息
management.endpoint.health.show-details=always
# 或仅在授权时显示
management.endpoint.health.show-details=when-authorized
```

=== info端点

*自定义应用信息*：

```properties
# application.properties
info.app.name=My Application
info.app.version=1.0.0
info.app.description=A Spring Boot application

# Git信息（需要git-commit-id-plugin）
info.git.branch=${git.branch}
info.git.commit.id=${git.commit.id}
info.git.commit.time=${git.commit.time}
```

*响应*：

```json
{
  "app": {
    "name": "My Application",
    "version": "1.0.0",
    "description": "A Spring Boot application"
  },
  "git": {
    "branch": "main",
    "commit": {
      "id": "abc123",
      "time": "2024-01-15T10:30:00Z"
    }
  }
}
```

=== metrics端点

*查看所有可用指标*：

```bash
curl http://localhost:8080/actuator/metrics
```

*查看具体指标*：

```bash
# JVM内存使用
curl http://localhost:8080/actuator/metrics/jvm.memory.used

# HTTP请求数
curl http://localhost:8080/actuator/metrics/http.server.requests

# 带标签查询
curl "http://localhost:8080/actuator/metrics/http.server.requests?tag=status:200"
```

*常用JVM指标*：

#tex-table(
  ("指标", "说明"),
  ("`jvm.memory.used`", "JVM内存使用"),
  ("`jvm.gc.pause`", "GC暂停时间"),
  ("`jvm.threads.live`", "活跃线程数"),
  ("`process.cpu.usage`", "CPU使用率"),
  ("`system.load.average.1m`", "系统负载"),
)

== 自定义健康检查

=== HealthIndicator接口

实现自定义健康检查逻辑：

```java
import org.springframework.boot.actuate.health.Health;
import org.springframework.boot.actuate.health.HealthIndicator;
import org.springframework.stereotype.Component;

@Component
public class DatabaseHealthIndicator implements HealthIndicator {

    @Override
    public Health health() {
        try {
            // 执行健康检查逻辑
            boolean databaseIsUp = checkDatabaseConnection();

            if (databaseIsUp) {
                return Health.up()
                    .withDetail("database", "MySQL")
                    .withDetail("status", "Connected")
                    .build();
            } else {
                return Health.down()
                    .withDetail("database", "MySQL")
                    .withDetail("error", "Connection failed")
                    .build();
            }
        } catch (Exception e) {
            return Health.down(e)
                .withDetail("database", "MySQL")
                .build();
        }
    }

    private boolean checkDatabaseConnection() {
        // 检查数据库连接
        return true;
    }
}
```

=== AbstractHealthIndicator

更简洁的实现方式：

```java
import org.springframework.boot.actuate.health.AbstractHealthIndicator;
import org.springframework.boot.actuate.health.Health;
import org.springframework.stereotype.Component;

@Component
public class RedisHealthIndicator extends AbstractHealthIndicator {

    @Override
    protected void doHealthCheck(Health.Builder builder) throws Exception {
        try {
            // 检查Redis连接
            redisTemplate.opsForValue().get("health_check");
            builder.up()
                .withDetail("redis", "Connected")
                .withDetail("version", redisServerVersion());
        } catch (Exception e) {
            builder.down()
                .withDetail("redis", "Disconnected")
                .withDetail("error", e.getMessage());
        }
    }

    private String redisServerVersion() {
        return "6.2.6";
    }
}
```

=== 复合健康检查

组合多个检查结果：

```java
@Component
public class CompositeHealthIndicator implements HealthIndicator {

    @Autowired
    private DataSource dataSource;

    @Autowired
    private RedisTemplate<String, String> redisTemplate;

    @Override
    public Health health() {
        Health.Builder builder = Health.up();

        // 检查数据库
        builder.withDetail("database", checkDatabase());

        // 检查Redis
        builder.withDetail("redis", checkRedis());

        // 检查外部API
        builder.withDetail("external_api", checkExternalApi());

        // 如果有任何一个DOWN，整体状态为DOWN
        if (hasAnyDown(builder.build())) {
            return Health.down(builder.build().getDetails()).build();
        }

        return builder.build();
    }

    private String checkDatabase() {
        try {
            dataSource.getConnection().close();
            return "UP";
        } catch (SQLException e) {
            return "DOWN: " + e.getMessage();
        }
    }

    private String checkRedis() {
        try {
            redisTemplate.opsForValue().get("test");
            return "UP";
        } catch (Exception e) {
            return "DOWN: " + e.getMessage();
        }
    }

    private String checkExternalApi() {
        // 检查外部API
        return "UP";
    }

    private boolean hasAnyDown(Health health) {
        return health.getDetails().values().stream()
            .anyMatch(detail -> detail.toString().contains("DOWN"));
    }
}
```

#tip[
  自定义健康检查应该轻量快速，避免阻塞health端点的响应。
]

== 自定义指标收集

=== MeterRegistry

MeterRegistry是Micrometer的核心接口，用于注册和收集指标。

*自动注入*：

```java
import io.micrometer.core.instrument.MeterRegistry;
import org.springframework.stereotype.Service;

@Service
public class OrderService {

    private final MeterRegistry meterRegistry;

    public OrderService(MeterRegistry meterRegistry) {
        this.meterRegistry = meterRegistry;
    }
}
```

=== Counter（计数器）

用于统计只增不减的数值：

```java
@Service
public class OrderService {

    private final Counter orderCounter;
    private final Counter errorCounter;

    public OrderService(MeterRegistry meterRegistry) {
        // 创建计数器
        this.orderCounter = Counter.builder("orders.total")
            .description("Total number of orders")
            .tag("type", "all")
            .register(meterRegistry);

        this.errorCounter = Counter.builder("orders.errors")
            .description("Number of failed orders")
            .register(meterRegistry);
    }

    public void createOrder(Order order) {
        try {
            // 业务逻辑
            orderCounter.increment();
        } catch (Exception e) {
            errorCounter.increment();
            throw e;
        }
    }
}
```

*快捷方式*：

```java
// 简单计数
meterRegistry.counter("orders.total").increment();

// 带标签
meterRegistry.counter("orders.total", "status", "success").increment();

// 增加指定数量
meterRegistry.counter("bytes.received").increment(1024);
```

=== Gauge（仪表盘）

用于监控可增可减的数值：

```java
@Service
public class CacheService {

    private final AtomicInteger cacheSize = new AtomicInteger(0);

    public CacheService(MeterRegistry meterRegistry) {
        // 注册Gauge，绑定到AtomicInteger
        Gauge.builder("cache.size", cacheSize, AtomicInteger::get)
            .description("Current cache size")
            .register(meterRegistry);
    }

    public void addToCache(String key, Object value) {
        cache.put(key, value);
        cacheSize.incrementAndGet();
    }

    public void removeFromCache(String key) {
        cache.remove(key);
        cacheSize.decrementAndGet();
    }
}
```

*监控集合大小*：

```java
List<String> activeConnections = new ArrayList<>();

Gauge.builder("connections.active", activeConnections, List::size)
    .register(meterRegistry);
```

=== Timer（计时器）

用于统计耗时：

```java
@Service
public class PaymentService {

    private final Timer paymentTimer;

    public PaymentService(MeterRegistry meterRegistry) {
        this.paymentTimer = Timer.builder("payment.processing.time")
            .description("Time taken to process payments")
            .publishPercentiles(0.5, 0.95, 0.99)  // P50, P95, P99
            .register(meterRegistry);
    }

    public void processPayment(Payment payment) {
        // 方式1：record包裹
        paymentTimer.record(() -> {
            // 支付处理逻辑
            doProcessPayment(payment);
        });
    }

    public void processPaymentAsync(Payment payment) {
        // 方式2：手动计时
        long start = System.nanoTime();
        try {
            doProcessPayment(payment);
        } finally {
            long end = System.nanoTime();
            paymentTimer.record(end - start, TimeUnit.NANOSECONDS);
        }
    }
}
```

*AOP方式（`@Timed`注解）*：

```java
import io.micrometer.core.annotation.Timed;

@Service
public class OrderService {

    @Timed(value = "order.creation.time", description = "Time to create order")
    public Order createOrder(OrderRequest request) {
        // 自动记录方法执行时间
        return orderRepository.save(request.toOrder());
    }
}
```

```java
// 启用@Timed注解
@EnableTimed
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```

=== DistributionSummary（分布摘要）

用于统计非时间类的分布数据：

```java
@Service
public class FileUploadService {

    private final DistributionSummary fileSizeSummary;

    public FileUploadService(MeterRegistry meterRegistry) {
        this.fileSizeSummary = DistributionSummary.builder("file.upload.size")
            .description("Distribution of uploaded file sizes")
            .baseUnit("bytes")
            .publishPercentiles(0.5, 0.95, 0.99)
            .register(meterRegistry);
    }

    public void uploadFile(MultipartFile file) {
        long size = file.getSize();
        fileSizeSummary.record(size);

        // 保存文件
        saveFile(file);
    }
}
```

== Micrometer核心概念与抽象层

=== Micrometer是什么

Micrometer是JVM应用的*指标门面*（Metrics Facade），类似于SLF4J之于日志。

*优势*：

- *统一API*：一套代码支持多种监控系统
- *自动集成*：Spring Boot自动配置
- *丰富类型*：Counter、Gauge、Timer等
- *多维标签*：支持Tags进行多维度分析

=== 架构设计

```
应用代码
    ↓
Micrometer API（门面）
    ↓
MeterRegistry（注册表）
    ↓
┌─────────┬──────────┬──────────┐
│Prometheus│Datadog   │InfluxDB  │ ... （各种实现）
└─────────┴──────────┴──────────┘
```

=== 核心概念

==== Meter

Meter是所有指标类型的父接口：

#tex-table(
  ("类型", "用途", "示例"),
  ("Counter", "递增计数", "请求数、错误数"),
  ("Gauge", "当前值", "线程数、队列大小"),
  ("Timer", "耗时+计数", "接口响应时间"),
  ("DistributionSummary", "分布统计", "文件大小、订单金额"),
  ("LongTaskTimer", "长任务计时", "批处理任务"),
)

==== Tags（标签）

Tags允许对指标进行多维度分析：

```java
// 不带标签
Counter counter = meterRegistry.counter("http.requests");

// 带标签
Counter successCounter = meterRegistry.counter("http.requests",
    "status", "200",
    "method", "GET",
    "uri", "/api/users"
);

Counter errorCounter = meterRegistry.counter("http.requests",
    "status", "500",
    "method", "POST",
    "uri", "/api/orders"
);
```

*查询时按标签过滤*：

```bash
# Prometheus查询
curl "http://localhost:8080/actuator/metrics/http.requests?tag=status:200"
```

==== Common Tags（公共标签）

为所有指标添加公共标签：

```properties
# application.properties
management.metrics.tags.application=${spring.application.name}
management.metrics.tags.environment=${spring.profiles.active}
management.metrics.tags.region=us-east-1
```

或者通过代码：

```java
@Configuration
public class MetricsConfig {

    @Bean
    public MeterRegistryCustomizer<MeterRegistry> metricsCommonTags() {
        return registry -> registry.config().commonTags(
            "application", "my-app",
            "environment", "production"
        );
    }
}
```

== 集成Prometheus与Grafana可视化

=== Prometheus简介

Prometheus是一个开源的*监控系统*和*时间序列数据库*。

*特点*：

- 多维数据模型（基于Tags）
- 强大的查询语言（PromQL）
- 不依赖分布式存储
- 支持服务发现
- Pull模式采集数据

=== Spring Boot集成Prometheus

==== 添加依赖

```xml
<dependency>
    <groupId>io.micrometer</groupId>
    <artifactId>micrometer-registry-prometheus</artifactId>
</dependency>
```

==== 配置端点

```properties
# 暴露prometheus端点
management.endpoints.web.exposure.include=prometheus,health,info,metrics

# 可选：自定义指标前缀
management.metrics.export.prometheus.descriptions=true
```

==== 访问指标

```bash
# 查看Prometheus格式的指标
curl http://localhost:8080/actuator/prometheus
```

*输出示例*：

```
# HELP jvm_memory_used_bytes The amount of used memory
# TYPE jvm_memory_used_bytes gauge
jvm_memory_used_bytes{area="heap",id="PS Eden Space",} 2.5769808E7
jvm_memory_used_bytes{area="heap",id="PS Survivor Space",} 1234567.0
jvm_memory_used_bytes{area="nonheap",id="Metaspace",} 5.4321E7

# HELP http_server_requests_seconds Time taken to process HTTP requests
# TYPE http_server_requests_seconds summary
http_server_requests_seconds_count{method="GET",status="200",uri="/api/users",} 1523.0
http_server_requests_seconds_sum{method="GET",status="200",uri="/api/users",} 45.678
```

=== Prometheus部署

==== docker-compose.yml

```yaml
version: '3'
services:
  prometheus:
    image: prom/prometheus:latest
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/usr/share/prometheus/console_libraries'
      - '--web.console.templates=/usr/share/prometheus/consoles'

volumes:
  prometheus_data:
```

==== prometheus.yml配置

```yaml
global:
  scrape_interval: 15s  # 每15秒采集一次
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'spring-boot-app'
    metrics_path: '/actuator/prometheus'
    static_configs:
      - targets: ['host.docker.internal:8080']
        labels:
          application: 'my-spring-boot-app'
          environment: 'development'
```

*启动*：

```bash
docker-compose up -d
```

访问 `http://localhost:9090` 查看Prometheus UI。

=== PromQL查询语言

==== 基本查询

```promql
# JVM内存使用
jvm_memory_used_bytes{area="heap"}

# HTTP请求总数
sum(http_server_requests_seconds_count)

# 特定接口的平均响应时间
rate(http_server_requests_seconds_sum{uri="/api/users"}[5m])
/
rate(http_server_requests_seconds_count{uri="/api/users"}[5m])
```

==== 常用函数

#tex-table(
  ("函数", "作用", "示例"),
  ("`rate()`", "计算增长率", "`rate(http_requests_total[5m])`"),
  ("`sum()`", "求和", "`sum(jvm_memory_used_bytes)`"),
  ("`avg()`", "平均值", "`avg(response_time_seconds)`"),
  ("`histogram_quantile()`", "分位数", "`histogram_quantile(0.95, ...)`"),
  ("`increase()`", "增长量", "`increase(errors_total[1h])`"),
)

==== P95/P99响应时间

```promql
# P95响应时间
histogram_quantile(0.95,
  rate(http_server_requests_seconds_bucket[5m])
)

# P99响应时间
histogram_quantile(0.99,
  rate(http_server_requests_seconds_bucket[5m])
)
```

=== Grafana可视化

==== Grafana简介

Grafana是一个开源的*分析和监控平台*，支持多种数据源。

*优势*：

- 丰富的图表类型
- 灵活的Dashboard
- 支持告警
- 社区模板丰富

==== Docker部署

```yaml
# 在docker-compose.yml中添加
services:
  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - grafana_data:/var/lib/grafana

volumes:
  grafana_data:
```

访问 `http://localhost:3000`，默认账号：`admin/admin`。

==== 配置Prometheus数据源

1. 登录Grafana
2. Configuration → Data Sources → Add data source
3. 选择Prometheus
4. URL：`http://prometheus:9090`
5. Save & Test

==== 导入Dashboard

*方式1：使用社区模板*

1. Browse → Import Dashboard
2. 输入模板ID（如：JVM Micrometer = 4701）
3. 选择Prometheus数据源
4. Import

*常用模板*：

#tex-table(
  ("模板名称", "ID", "用途"),
  ("JVM Micrometer", "4701", "JVM监控"),
  ("Spring Boot Statistics", "12900", "Spring Boot应用"),
  ("HTTP Server Requests", "13619", "HTTP请求监控"),
  ("Micrometer Spring Boot", "14441", "综合监控"),
)

*方式2：自定义Dashboard*

创建自己的面板，添加PromQL查询。

#tip[
  推荐从社区模板开始，然后根据需求定制。
]

== 链路追踪基础

=== 为什么需要链路追踪

在微服务架构中，一个请求可能经过多个服务：

```
用户请求 → API Gateway → Order Service → Payment Service → Notification Service
                                    ↓
                              Inventory Service
```

*问题*：

- 哪个服务慢了？
- 请求经过了哪些服务？
- 错误发生在哪一层？

*解决方案*：分布式链路追踪

=== OpenTelemetry

OpenTelemetry是CNCF的*可观测性框架*，提供统一的API和SDK。

*组成*：

- *Tracing*：分布式追踪
- *Metrics*：指标收集
- *Logs*：日志关联

*优势*：

- 厂商中立
- 多语言支持
- Spring Boot 3.x原生支持

=== Spring Boot集成Micrometer Tracing

==== 添加依赖（Spring Boot 3.x）

```xml
<!-- Micrometer Tracing -->
<dependency>
    <groupId>io.micrometer</groupId>
    <artifactId>micrometer-tracing-bridge-brave</artifactId>
</dependency>

<!-- Zipkin导出器 -->
<dependency>
    <groupId>io.zipkin.reporter2</groupId>
    <artifactId>zipkin-reporter-brave</artifactId>
</dependency>
```

#note[
  Spring Boot 2.x使用Spring Cloud Sleuth，3.x已迁移到Micrometer Tracing。
]

==== 配置

```properties
# 应用名称（显示在追踪系统中）
spring.application.name=order-service

# Zipkin服务器地址
management.zipkin.tracing.endpoint=http://localhost:9411/api/v2/spans

# 采样率（1.0 = 100%采样）
management.tracing.sampling.probability=1.0
```

==== 自动追踪

Spring Boot会自动追踪：

- HTTP请求（RestTemplate、WebClient）
- 数据库查询
- 消息队列
- 异步任务

*无需额外代码*！

=== 手动创建Span

对于自定义逻辑，可以手动创建Span：

```java
import io.micrometer.tracing.Tracer;
import org.springframework.stereotype.Service;

@Service
public class OrderService {

    private final Tracer tracer;

    public OrderService(Tracer tracer) {
        this.tracer = tracer;
    }

    public void processOrder(Order order) {
        // 创建子Span
        Span span = tracer.nextSpan().name("validate-order").start();

        try (Tracer.SpanInScope ws = tracer.withSpan(span)) {
            // 业务逻辑
            validateOrder(order);

            // 添加标签
            span.tag("order.id", order.getId());
            span.tag("order.amount", String.valueOf(order.getAmount()));
        } finally {
            span.end();
        }
    }
}
```

=== Trace ID传播

Trace ID需要在服务间传递：

*HTTP请求*：

```
Request Headers:
  X-B3-TraceId: abc123def456
  X-B3-SpanId: 789xyz
  X-B3-ParentSpanId: 456abc
```

*消息队列*：

```java
// Kafka消息头自动包含追踪信息
kafkaTemplate.send("orders", order);
```

== 分布式追踪实践

=== Zipkin部署

==== Docker部署

```yaml
version: '3'
services:
  zipkin:
    image: openzipkin/zipkin:latest
    ports:
      - "9411:9411"
    environment:
      - STORAGE_TYPE=mem  # 生产环境使用elasticsearch
```

```bash
docker-compose up -d
```

访问 `http://localhost:9411` 查看Zipkin UI。

==== 查看追踪数据

1. 点击"Run Query"
2. 选择Service Name
3. 查看Trace列表
4. 点击Trace查看详细调用链

*界面展示*：

```
Trace: abc123def456
┌────────────────────────────────────────┐
│ API Gateway          [████████] 120ms │
│   └─ Order Service   [██████] 80ms    │
│       ├─ Validate    [██] 20ms        │
│       ├─ Payment     [███] 40ms       │
│       └─ Inventory   [█] 10ms         │
└────────────────────────────────────────┘
```

=== Jaeger部署

Jaeger是Uber开源的分布式追踪系统。

==== Docker部署

```yaml
version: '3'
services:
  jaeger:
    image: jaegertracing/all-in-one:latest
    ports:
      - "16686:16686"  # UI
      - "14268:14268"  # Collector
    environment:
      - COLLECTOR_ZIPKIN_HOST_PORT=:9411
```

访问 `http://localhost:16686` 查看Jaeger UI。

==== Spring Boot配置

```properties
# Jaeger exporter
management.otlp.tracing.endpoint=http://localhost:4318/v1/traces
```

==== Zipkin vs Jaeger

#tex-table(
  ("特性", "Zipkin", "Jaeger"),
  ("开发公司", "Twitter", "Uber"),
  ("UI简洁度", "简单", "功能丰富"),
  ("存储后端", "Memory/MySQL/ES", "Memory/Cassandra/ES"),
  ("社区活跃度", "中等", "高"),
  ("适用场景", "小型项目", "大型微服务"),
)

#tip[
  小型项目推荐Zipkin（简单易用），大型微服务推荐Jaeger（功能强大）。
]

=== 追踪数据分析

==== 性能瓶颈定位

通过Trace视图可以快速发现：

1. *慢服务*：哪个Span耗时最长
2. *并行优化*：哪些Span可以并行执行
3. *调用次数*：是否有不必要的重复调用

===== 示例分析

```
Trace: order-creation
┌──────────────────────────────────────┐
│ OrderController    [████████] 250ms │ ← 总耗时
│   ├─ Validation    [█] 20ms         │ ✓ 快速
│   ├─ DB Insert     [██] 50ms        │ ✓ 正常
│   ├─ Payment       [████] 150ms     │ ✗ 慢！
│   │   └─ API Call  [███] 140ms     │ ← 外部API慢
│   └─ Notification  [█] 30ms         │ ✓ 正常
└──────────────────────────────────────┘

结论：Payment服务调用的外部API是瓶颈
```

==== 错误追踪

Span会记录异常信息：

```java
try {
    callExternalService();
} catch (Exception e) {
    span.tag("error", "true");
    span.event("exception");
    throw e;
}
```

在Zipkin/Jaeger中可以：

- 过滤出错误的Trace
- 查看异常堆栈
- 分析错误率趋势

== 日志聚合与分析

=== 为什么需要日志聚合

在分布式系统中，日志分散在多个服务器：

*问题*：

- 如何跨服务追踪一个请求？
- 如何快速搜索特定日志？
- 如何分析日志趋势？

*解决方案*：集中式日志聚合

=== ELK Stack

ELK是Elasticsearch、Logstash、Kibana的缩写。

==== 架构

```
应用日志 → Filebeat → Logstash → Elasticsearch → Kibana
```

#tex-table(
  ("组件", "作用"),
  ("Filebeat", "日志收集器，轻量级"),
  ("Logstash", "日志处理和转换"),
  ("Elasticsearch", "日志存储和搜索"),
  ("Kibana", "日志可视化"),
)

==== Docker部署

```yaml
version: '3'
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.11.0
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
    ports:
      - "9200:9200"

  kibana:
    image: docker.elastic.co/kibana/kibana:8.11.0
    ports:
      - "5601:5601"
    depends_on:
      - elasticsearch

  logstash:
    image: docker.elastic.co/logstash/logstash:8.11.0
    volumes:
      - ./logstash.conf:/usr/share/logstash/pipeline/logstash.conf
    ports:
      - "5044:5044"
```

==== Spring Boot配置

使用JSON格式输出日志（见第4章），Filebeat自动采集并发送到Logstash。

访问 `http://localhost:5601` 查看Kibana。

=== Loki + Grafana

Loki是Grafana Labs开发的*轻量级日志聚合系统*。

*优势*：

- 不索引日志内容，只索引标签
- 存储成本低
- 与Grafana无缝集成
- 适合云原生环境

==== 架构

```
应用日志 → Promtail → Loki → Grafana
```

#tex-table(
  ("组件", "作用"),
  ("Promtail", "日志收集器"),
  ("Loki", "日志存储"),
  ("Grafana", "日志查询和可视化"),
)

==== Docker部署

```yaml
version: '3'
services:
  loki:
    image: grafana/loki:latest
    ports:
      - "3100:3100"
    command: -config.file=/etc/loki/local-config.yaml

  promtail:
    image: grafana/promtail:latest
    volumes:
      - /var/log:/var/log
      - ./promtail-config.yaml:/etc/promtail/config.yaml
    command: -config.file=/etc/promtail/config.yaml
```

==== Grafana中查询日志

使用LogQL查询语言：

```logql
# 查询特定应用的日志
{app="order-service"}

# 包含特定关键词
{app="order-service"} |= "error"

# 排除特定级别
{app="order-service"} !~ "level=DEBUG"

# 统计错误数量
sum(count_over_time({app="order-service"} |= "error" [5m]))
```

==== ELK vs Loki

#tex-table(
  ("特性", "ELK", "Loki"),
  ("全文搜索", "✓ 强大", "✗ 有限"),
  ("存储成本", "高", "低"),
  ("学习曲线", "陡峭", "平缓"),
  ("适用场景", "复杂分析", "快速排查"),
  ("资源占用", "高", "低"),
)

#tip[
  简单日志排查推荐Loki（轻量），复杂分析推荐ELK（功能强大）。
]

== 告警与通知

=== Prometheus Alertmanager

==== 告警规则

创建 `alert.rules.yml`：

```yaml
groups:
  - name: application-alerts
    rules:
      # CPU使用率过高
      - alert: HighCPUUsage
        expr: process_cpu_usage > 0.8
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High CPU usage detected"
          description: "CPU usage is {{ $value }}% for more than 5 minutes"

      # 错误率过高
      - alert: HighErrorRate
        expr: rate(http_server_requests_seconds_count{status=~"5.."}[5m]) > 0.1
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "High error rate"
          description: "Error rate is {{ $value }} errors/sec"

      # 响应时间过长
      - alert: SlowResponse
        expr: histogram_quantile(0.95, rate(http_server_requests_seconds_bucket[5m])) > 2
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Slow response time"
          description: "P95 response time is {{ $value }}s"
```

==== Alertmanager配置

```yaml
route:
  receiver: 'default-receiver'
  group_by: ['alertname']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 4h

receivers:
  - name: 'default-receiver'
    email_configs:
      - to: 'admin@example.com'
        from: 'alertmanager@example.com'
        smarthost: 'smtp.example.com:587'
        auth_username: 'alertmanager@example.com'
        auth_password: 'password'
```

=== Grafana告警

==== 配置告警

1. Dashboard面板 → Alert → Create Alert
2. 设置条件（如：CPU > 80%）
3. 配置通知渠道
4. 保存

==== 通知渠道

Grafana支持多种通知方式：

#tex-table(
  ("渠道", "配置难度", "适用场景"),
  ("Email", "简单", "正式通知"),
  ("钉钉", "中等", "国内团队"),
  ("企业微信", "中等", "国内团队"),
  ("Slack", "简单", "国际团队"),
  ("Webhook", "灵活", "自定义"),
)

=== 钉钉告警配置

==== Webhook方式

```java
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class DingTalkAlertService {

    private static final String WEBHOOK_URL = "https://oapi.dingtalk.com/robot/send?access_token=YOUR_TOKEN";

    public void sendAlert(String title, String message) {
        RestTemplate restTemplate = new RestTemplate();

        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("msgtype", "markdown");

        Map<String, String> markdown = new HashMap<>();
        markdown.put("title", title);
        markdown.put("text", "## " + title + "\n\n" + message);

        requestBody.put("markdown", markdown);

        restTemplate.postForObject(WEBHOOK_URL, requestBody, String.class);
    }
}
```

==== 集成Prometheus

通过Alertmanager的Webhook receiver转发到钉钉。

#fancy-divider

本章详细介绍了Spring Boot的监控与可观测性体系，从Actuator端点到Micrometer指标，从Prometheus+Grafana可视化到分布式链路追踪，再到日志聚合和告警通知。结合第4章的日志系统，您已经掌握了构建完整可观测性平台的所有关键技术。
