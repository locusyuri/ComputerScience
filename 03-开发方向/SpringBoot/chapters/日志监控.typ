#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= 日志、监控与可观测性

日志是应用程序的“黑匣子”，记录系统运行状态；监控提供实时指标；可观测性帮助理解系统内部状态。三者结合构成完整的应用运维体系。

#note[
  Spring Boot的日志设计遵循*门面模式*，通过SLF4J统一接口，底层可以灵活切换实现框架，实现了日志系统的解耦和可扩展性。
]

== SLF4J 与 Logback 配置

=== Java日志生态演变

==== 早期混乱局面

在SLF4J出现之前，Java日志领域存在多个 competing 框架：

#tex-table(
  ("框架", "发布年份", "特点", "问题"),
  ("java.util.logging (JUL)", "2002", "JDK自带", "功能简单，性能一般"),
  ("Log4j 1.x", "2001", "功能强大", "已停止维护，有安全漏洞"),
  ("Logback", "2006", "Log4j改进版", "需要SLF4J配合"),
  ("Log4j 2.x", "2014", "高性能", "API不兼容Log4j 1.x"),
)

*问题*：

- 不同库使用不同的日志框架
- 项目中可能出现多个日志实现
- 配置复杂，难以统一管理

==== SLF4J的解决方案

SLF4J（Simple Logging Facade for Java）是一个*日志门面*（Logging Facade）。

*核心理念*：

```
应用代码 → SLF4J API（接口） → 具体实现（Logback/Log4j2/JUL）
```

*优势*：

1. *解耦*：应用代码只依赖SLF4J API
2. *灵活*：可以随时切换底层实现
3. *统一*：所有库都通过SLF4J输出日志
4. *性能*：支持参数化日志，避免不必要的字符串拼接

```java
// 使用SLF4J API（推荐）
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class UserService {
    private static final Logger log = LoggerFactory.getLogger(UserService.class);

    public void createUser(String name) {
        // 参数化日志，只有当日志级别启用时才拼接字符串
        log.info("Creating user: {}", name);
    }
}
```

#tip[
  永远使用SLF4J API，不要直接使用Logback或Log4j的API。这样可以在不修改代码的情况下切换日志实现。
]

=== Spring Boot的日志架构

==== 默认日志框架

Spring Boot默认使用*Logback*作为日志实现。

*依赖关系*：

```xml
<!-- spring-boot-starter -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter</artifactId>
</dependency>
    ↓ 传递依赖
<!-- spring-boot-starter-logging -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-logging</artifactId>
</dependency>
    ↓ 包含
<!-- SLF4J API -->
<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-api</artifactId>
</dependency>
<!-- Logback Classic（实现） -->
<dependency>
    <groupId>ch.qos.logback</groupId>
    <artifactId>logback-classic</artifactId>
</dependency>
<!-- Logback Core -->
<dependency>
    <groupId>ch.qos.logback</groupId>
    <artifactId>logback-core</artifactId>
</dependency>
<!-- JUL到SLF4J的桥接 -->
<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>jul-to-slf4j</artifactId>
</dependency>
```

*架构图*：

```
┌─────────────────────────────────────┐
│      你的应用代码                    │
│  Logger log = LoggerFactory...      │
└──────────────┬──────────────────────┘
               │ 调用
┌──────────────▼──────────────────────┐
│      SLF4J API                      │
│  (slf4j-api.jar)                    │
└──────────────┬──────────────────────┘
               │ 绑定
┌──────────────▼──────────────────────┐
│      Logback                        │
│  (logback-classic.jar)              │
│  (logback-core.jar)                 │
└──────────────┬──────────────────────┘
               │ 输出
┌──────────────▼──────────────────────┐
│  Console / File / RollingFile       │
└─────────────────────────────────────┘
```

==== 日志桥接（Bridge）

Spring Boot自动配置了日志桥接，将其他日志框架的输出重定向到SLF4J：

#tex-table(
  ("桥接模块", "作用", "重定向"),
  ("jcl-over-slf4j", "Jakarta Commons Logging", "→ SLF4J"),
  ("jul-to-slf4j", "java.util.logging", "→ SLF4J"),
  ("log4j-over-slf4j", "Log4j 1.x", "→ SLF4J"),
)

*效果*：即使第三方库使用JUL或Log4j，日志也会统一通过SLF4J输出。

#caution[
  不要同时引入 `log4j-over-slf4j` 和 `slf4j-log4j12`，会导致循环依赖和StackOverflowError。
]

=== Logback配置详解

==== 配置文件位置

Spring Boot按以下顺序查找Logback配置：

1. `logback-spring.xml`（推荐，支持Spring特性）
2. `logback.xml`
3. `application.properties/yml`中的配置

*推荐*：使用 `logback-spring.xml`，因为它支持Spring的Profile和属性占位符。

==== 基本配置结构

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>

    <!-- 属性定义 -->
    <property name="LOG_PATTERN"
              value="%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n"/>
    <property name="LOG_PATH" value="logs"/>

    <!-- 控制台输出 -->
    <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>${LOG_PATTERN}</pattern>
            <charset>UTF-8</charset>
        </encoder>
    </appender>

    <!-- 文件输出 -->
    <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>${LOG_PATH}/application.log</file>
        <encoder>
            <pattern>${LOG_PATTERN}</pattern>
        </encoder>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>${LOG_PATH}/application.%d{yyyy-MM-dd}.log</fileNamePattern>
            <maxHistory>30</maxHistory>
            <totalSizeCap>1GB</totalSizeCap>
        </rollingPolicy>
    </appender>

    <!-- 根日志器 -->
    <root level="INFO">
        <appender-ref ref="CONSOLE"/>
        <appender-ref ref="FILE"/>
    </root>

    <!-- 特定包的日志级别 -->
    <logger name="com.example.myapp" level="DEBUG"/>
    <logger name="org.springframework.web" level="INFO"/>
    <logger name="org.hibernate.SQL" level="DEBUG"/>

</configuration>
```

==== 日志级别

#tex-table(
  ("级别", "值", "用途", "生产环境"),
  ("TRACE", "0", "最详细追踪", "禁用"),
  ("DEBUG", "10", "调试信息", "禁用"),
  ("INFO", "20", "重要信息", "✓ 推荐"),
  ("WARN", "30", "警告信息", "✓ 推荐"),
  ("ERROR", "40", "错误信息", "✓ 推荐"),
  ("OFF", "Integer.MAX_VALUE", "关闭日志", "特殊场景"),
)

*继承规则*：

- 子Logger继承父Logger的级别
- 如果未显式设置，使用root的级别
- 更具体的配置覆盖通用配置

```xml
<!-- root设置为INFO -->
<root level="INFO">
    <appender-ref ref="CONSOLE"/>
</root>

<!-- com.example包下的类使用DEBUG级别 -->
<logger name="com.example" level="DEBUG"/>

<!-- com.example.service包下的类使用TRACE级别 -->
<logger name="com.example.service" level="TRACE"/>
```

==== 日志格式模式

常用模式字符：

#tex-table(
  ("模式", "含义", "示例"),
  ("`%d{pattern}`", "日期时间", "`2024-01-15 10:30:45.123`"),
  ("`%thread`", "线程名", "`main`, `http-nio-8080-exec-1`"),
  ("`%-5level`", "日志级别", "`INFO `, `ERROR`"),
  ("`%logger{length}`", "Logger名称", "`c.e.m.UserService`"),
  ("`%msg`", "日志消息", "`Creating user: Alice`"),
  ("`%n`", "换行符", ""),
  ("`%exception`", "异常堆栈", "完整堆栈信息"),
)

*彩色输出*（仅控制台）：

```xml
<pattern>%clr(%d{yyyy-MM-dd HH:mm:ss.SSS}){faint}
         %clr(%5p) %clr(${PID:- }){magenta}
         %clr(---){faint} %clr([%15.15t]){faint}
         %clr(%-40.40logger{39}){cyan} %clr(:){faint} %m%n</pattern>
```

#tip[
  Spring Boot默认的日志格式已经包含了彩色输出，开发时更易读。
]

=== application.properties配置

对于简单场景，可以直接在配置文件中设置：

```properties
# 日志级别
logging.level.root=INFO
logging.level.com.example.myapp=DEBUG
logging.level.org.springframework.web=WARN

# 日志文件
logging.file.name=logs/application.log
logging.file.max-size=10MB
logging.file.max-history=30

# 日志格式
logging.pattern.console=%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n
logging.pattern.file=%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n

# 日志组（Spring Boot 2.1+）
logging.group.tomcat=org.apache.catalina,org.apache.coyote,org.apache.tomcat
logging.level.tomcat=DEBUG
```

#note[
  对于复杂的日志配置（如多appender、滚动策略），建议使用 `logback-spring.xml`。
]

=== 高级配置

==== 异步日志

异步日志可以提升性能，特别是高并发场景：

```xml
<appender name="ASYNC_FILE" class="ch.qos.logback.classic.AsyncAppender">
    <!-- 队列大小 -->
    <queueSize>512</queueSize>
    <!-- 丢弃阈值（队列剩余容量低于此值时丢弃TRACE/DEBUG/INFO） -->
    <discardingThreshold>0</discardingThreshold>
    <!-- 是否包含调用者信息 -->
    <includeCallerData>false</includeCallerData>

    <appender-ref ref="FILE"/>
</appender>

<root level="INFO">
    <appender-ref ref="ASYNC_FILE"/>
</root>
```

*性能提升*：

- 同步日志：~100K msg/s
- 异步日志：~1M msg/s

#caution[
  异步日志在应用关闭时可能丢失少量日志。设置 `queueSize` 时要权衡内存占用。
]

==== 条件配置（Profile）

`logback-spring.xml` 支持Spring Profile：

```xml
<configuration>

    <!-- 开发环境 -->
    <springProfile name="dev">
        <root level="DEBUG">
            <appender-ref ref="CONSOLE"/>
        </root>
        <logger name="com.example" level="TRACE"/>
    </springProfile>

    <!-- 生产环境 -->
    <springProfile name="prod">
        <root level="WARN">
            <appender-ref ref="ASYNC_FILE"/>
        </root>
        <logger name="com.example" level="INFO"/>
    </springProfile>

    <!-- 测试环境 -->
    <springProfile name="test">
        <root level="INFO">
            <appender-ref ref="CONSOLE"/>
        </root>
    </springProfile>

</configuration>
```

==== 自定义Appender

可以将日志发送到自定义目标：

```java
import ch.qos.logback.core.AppenderBase;

public class KafkaAppender extends AppenderBase<ILoggingEvent> {
    private KafkaProducer<String, String> producer;
    private String topic;

    @Override
    public void start() {
        // 初始化Kafka Producer
        producer = new KafkaProducer<>(...);
        super.start();
    }

    @Override
    protected void append(ILoggingEvent event) {
        String message = String.format("[%s] %s - %s",
            event.getLevel(),
            event.getLoggerName(),
            event.getFormattedMessage()
        );
        producer.send(new ProducerRecord<>(topic, message));
    }

    @Override
    public void stop() {
        producer.close();
        super.stop();
    }
}
```

```xml
<appender name="KAFKA" class="com.example.KafkaAppender">
    <topic>application-logs</topic>
</appender>
```

== 结构化日志与 MDC

结构化日志是将日志以机器可读的格式（如JSON）输出，便于日志聚合和分析。

=== 为什么需要结构化日志

*传统日志的问题*：

```
2024-01-15 10:30:45.123 [http-nio-8080-exec-1] INFO  c.e.m.UserService - Creating user: Alice, age=25, email=alice@example.com
```

- 难以解析和查询
- 无法高效聚合分析
- 不支持多维度的过滤

*结构化日志*：

```json
{
  "timestamp": "2024-01-15T10:30:45.123Z",
  "level": "INFO",
  "thread": "http-nio-8080-exec-1",
  "logger": "com.example.myapp.UserService",
  "message": "Creating user",
  "user_name": "Alice",
  "user_age": 25,
  "user_email": "alice@example.com",
  "trace_id": "abc123",
  "span_id": "def456"
}
```

*优势*：

- 易于机器解析
- 支持复杂查询
- 便于日志聚合（ELK、Loki）
- 支持链路追踪

#tip[
  微服务架构中，结构化日志是标配，强烈推荐使用。
]

=== MDC（Mapped Diagnostic Context）

MDC是SLF4J提供的线程级别的上下文存储，用于在日志中添加额外信息。

==== 基本原理

```text
请求进入 → 生成trace_id → 放入MDC → 所有日志自动包含trace_id → 请求结束清除MDC
```

==== 基本用法

```java
import org.slf4j.MDC;

@Service
public class OrderService {
    private static final Logger log = LoggerFactory.getLogger(OrderService.class);

    public void createOrder(String orderId) {
        // 将订单ID放入MDC
        MDC.put("order_id", orderId);
        MDC.put("user_id", "user123");

        try {
            log.info("Creating order");
            // ... 业务逻辑
            log.info("Order created successfully");
        } finally {
            // 清理MDC（重要！）
            MDC.clear();
        }
    }
}
```

*日志输出*：

```
2024-01-15 10:30:45.123 [http-nio-8080-exec-1] INFO  c.e.m.OrderService - Creating order {order_id=ORD001, user_id=user123}
2024-01-15 10:30:45.456 [http-nio-8080-exec-1] INFO  c.e.m.OrderService - Order created successfully {order_id=ORD001, user_id=user123}
```

#caution[
  必须在finally块中清理MDC，否则在线程池环境下会导致内存泄漏和数据污染。
]

==== 在Filter中设置Trace ID

```java
import org.slf4j.MDC;
import org.springframework.stereotype.Component;
import javax.servlet.*;
import java.io.IOException;
import java.util.UUID;

@Component
public class TraceIdFilter implements Filter {

    private static final String TRACE_ID_KEY = "trace_id";

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {
        try {
            // 从请求头获取或生成新的trace_id
            String traceId = ((HttpServletRequest) request).getHeader("X-Trace-Id");
            if (traceId == null || traceId.isEmpty()) {
                traceId = UUID.randomUUID().toString().replace("-", "");
            }

            // 放入MDC
            MDC.put(TRACE_ID_KEY, traceId);

            // 继续处理
            chain.doFilter(request, response);
        } finally {
            // 清理MDC
            MDC.clear();
        }
    }
}
```

*配置Logback pattern*：

```xml
<pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %X{trace_id} - %msg%n</pattern>
```

*效果*：

```
2024-01-15 10:30:45.123 [http-nio-8080-exec-1] INFO  c.e.m.OrderService - abc123def456 - Creating order
2024-01-15 10:30:45.456 [http-nio-8080-exec-1] INFO  c.e.m.PaymentService - abc123def456 - Processing payment
```

#tip[
  通过trace_id可以追踪一个请求在所有服务中的完整调用链路。
]

=== JSON格式化日志

==== 使用logback-contrib

```xml
<dependency>
    <groupId>net.logstash.logback</groupId>
    <artifactId>logstash-logback-encoder</artifactId>
    <version>7.4</version>
</dependency>
```

*配置*：

```xml
<appender name="JSON_CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
    <encoder class="net.logstash.logback.encoder.LogstashEncoder">
        <!-- 自定义字段 -->
        <customFields>{"app":"myapp","env":"${APP_ENV:-dev}"}</customFields>

        <!-- 包含MDC -->
        <includeMdcKeyName>trace_id</includeMdcKeyName>
        <includeMdcKeyName>user_id</includeMdcKeyName>

        <!-- 时间戳格式 -->
        <timestampPattern>yyyy-MM-dd'T'HH:mm:ss.SSS'Z'</timestampPattern>
        <timeZone>UTC</timeZone>
    </encoder>
</appender>

<root level="INFO">
    <appender-ref ref="JSON_CONSOLE"/>
</root>
```

*输出*：

```json
{
  "@timestamp": "2024-01-15T10:30:45.123Z",
  "@version": "1",
  "message": "Creating order",
  "logger_name": "com.example.myapp.OrderService",
  "thread_name": "http-nio-8080-exec-1",
  "level": "INFO",
  "level_value": 20000,
  "app": "myapp",
  "env": "dev",
  "trace_id": "abc123def456",
  "user_id": "user123"
}
```

==== 自定义JSON Encoder

```java
import net.logstash.logback.encoder.LogstashEncoder;
import net.logstash.logback.fieldnames.LogstashFieldNames;

public class CustomJsonEncoder extends LogstashEncoder {

    public CustomJsonEncoder() {
        super();

        // 自定义字段名
        LogstashFieldNames fieldNames = getFieldNames();
        fieldNames.setTimestamp("@timestamp");
        fieldNames.setMessage("message");
        fieldNames.setLogger("logger");
        fieldNames.setThread("thread");
        fieldNames.setLevel("level");

        // 添加固定字段
        setCustomFields("{\"service\":\"order-service\",\"version\":\"1.0.0\"}");
    }
}
```

=== 最佳实践

==== 1. 统一的日志工具类

```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;

public class LogUtils {

    public static void putTraceId(String traceId) {
        MDC.put("trace_id", traceId);
    }

    public static void putUserId(String userId) {
        MDC.put("user_id", userId);
    }

    public static void putRequestId(String requestId) {
        MDC.put("request_id", requestId);
    }

    public static void clear() {
        MDC.clear();
    }

    // 便捷方法：记录业务操作
    public static void logBusinessOperation(Logger log, String operation,
                                            String status, Object... params) {
        log.info("operation={}, status={}, params={}", operation, status, params);
    }
}
```

==== 2. AOP自动添加上下文

```java
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.slf4j.MDC;
import org.springframework.stereotype.Component;
import java.util.UUID;

@Aspect
@Component
public class LoggingAspect {

    @Around("@annotation(org.springframework.web.bind.annotation.RestController)")
    public Object addLoggingContext(ProceedingJoinPoint joinPoint) throws Throwable {
        String traceId = UUID.randomUUID().toString().replace("-", "");
        MDC.put("trace_id", traceId);

        try {
            return joinPoint.proceed();
        } finally {
            MDC.clear();
        }
    }
}
```

==== 3. 敏感信息脱敏

```java
import ch.qos.logback.classic.pattern.MessageConverter;
import ch.qos.logback.classic.spi.ILoggingEvent;

public class SensitiveDataConverter extends MessageConverter {

    @Override
    public String convert(ILoggingEvent event) {
        String message = event.getFormattedMessage();

        // 脱敏手机号
        message = message.replaceAll("(\\d{3})\\d{4}(\\d{4})", "$1****$2");

        // 脱敏邮箱
        message = message.replaceAll("(\\w{3})\\w*@", "$1***@");

        // 脱敏身份证
        message = message.replaceAll("(\\d{6})\\d{8}(\\d{4})", "$1********$2");

        return message;
    }
}
```

```xml
<conversionRule conversionWord="msg"
                converterClass="com.example.SensitiveDataConverter" />
```

#note[
  生产环境必须对敏感信息（手机号、身份证、银行卡等）进行脱敏，符合GDPR等法规要求。
]

#fancy-divider

未完待续...

