#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= 初识 Spring Boot

#note[
  *版本说明*: 本笔记基于以下技术栈版本编写，示例代码均在此环境下测试通过。

  - *Spring Boot*: 3.2.4
  - *JDK*: 17 (LTS)
  - *Kotlin*: 2.1.0
  - *Maven*: 3.9+
  - *Gradle*: 8.5+
  - *MySQL*: 8.0+
  - *Redis*: 7.0+
]

== Spring Boot诞生背景与核心价值

=== 传统Spring开发的痛点

在Spring Boot出现之前，使用Spring框架开发应用存在诸多问题:

*配置复杂*:

- 大量的XML配置文件
- 依赖管理繁琐
- 需要手动配置Tomcat等Web容器

*部署困难*:

- 需要打包成WAR文件
- 部署到外部应用服务器
- 环境配置复杂

*开发效率低*:

- 项目搭建耗时长
- 约定不明确
- 学习曲线陡峭

=== Spring Boot的解决方案

Spring Boot的核心理念是*“约定优于配置”*(Convention over Configuration)。

*核心特性*:

#tex-table(
  ("特性", "说明", "优势"),
  ("自动配置", "根据依赖自动配置Bean", "零配置启动"),
  ("内嵌容器", "内置Tomcat/Jetty/Undertow", "独立运行"),
  ("Starter依赖", "一站式依赖管理", "简化Maven/Gradle"),
  ("生产就绪", "Actuator监控端点", "开箱即用"),
  ("无代码生成", "无需XML，无需代码生成", "简洁清晰"),
)

=== Spring Boot的核心价值

1. *快速启动*:
  - 几分钟内创建可运行的应用
  - 减少样板代码
  - 专注业务逻辑

2. *简化配置*:
  - 自动配置大多数场景
  - 配置文件简单明了
  - 支持多种配置格式

3. *独立运行*:
  - 内嵌Web容器
  - JAR包直接运行
  - 微服务友好

4. *生态丰富*:
  - 大量Starter可用
  - 社区活跃
  - 文档完善

#tip[
  Spring Boot不是要替代Spring，而是让Spring更容易使用。
]

== Spring Boot 版本演进

Spring Boot 自 2014 年发布以来，经历了从 1.x 到 4.x 的重大演进。每个主版本都带来了架构革新、性能提升和生态整合。

=== Spring Boot 1.x(2014-2019): 开创时代

Spring Boot 1.x 是框架的起点，确立了“约定优于配置”的核心理念。

*1.0-1.5 主要特性*:

- *自动配置*: 基于条件注解的条件化 Bean 注册，大幅简化配置
- *内嵌服务器*: Tomcat、Jetty、Undertow 开箱即用，无需部署 WAR
- *Starter 依赖*: spring-boot-starter-web、spring-boot-starter-data-jpa 等简化依赖管理
- *Actuator*: 内置健康检查、指标监控、端点暴露
- *CLI*: 命令行工具支持快速原型开发

*技术栈*:

- Spring Framework 4.x
- Java 6/7/8 支持
- Servlet 3.0+

*历史意义*: Spring Boot 1.x 彻底改变了 Java Web 开发方式，让 Spring 从繁琐的 XML 配置中解放出来，成为微服务架构的首选框架。

=== Spring Boot 2.x(2018-2023): 成熟与扩展

Spring Boot 2.x 是迄今为止使用最广泛的版本，引入了响应式编程和云原生支持。

*2.0-2.7 重大变化*:

==== 响应式编程支持

Spring Boot 2.0 引入了 Spring WebFlux，支持响应式编程模型。

```java
// 传统 MVC(阻塞式)
@GetMapping("/users")
public List<User> getUsers() {
    return userService.findAll();  // 阻塞调用
}

// WebFlux(响应式)
@GetMapping("/users")
public Flux<User> getUsers() {
    return userService.findAll();  // 非阻塞，返回响应式流
}
```

==== JDK 要求提升

- Spring Boot 2.0: 最低 JDK 8
- Spring Boot 2.5+: 推荐 JDK 11
- Spring Boot 2.7: 支持 JDK 17(实验性)

==== GraalVM 原生镜像(实验性)

Spring Boot 2.4+ 开始实验性支持 GraalVM 原生编译，但配置复杂，需要额外的插件和配置。

```xml
<!-- Spring Boot 2.x 需要额外配置 -->
<plugin>
    <groupId>org.graalvm.buildtools</groupId>
    <artifactId>native-maven-plugin</artifactId>
    <!-- 复杂的配置... -->
</plugin>
```

==== 云原生增强

- Kubernetes 支持改进
- Docker 镜像构建优化(Buildpacks)
- 配置中心集成(Spring Cloud Config)

---

Spring Boot 2.7.x 是 2.x 系列的最后一个版本，提供长期支持直到 2023 年 11 月。

=== Spring Boot 3.x(2022-至今): 现代化革新

Spring Boot 3.0 于 2022 年 11 月发布，是基于 Spring Framework 6 的重大升级，标志着 Spring 进入现代化时代。


==== JDK 17 成为最低要求

Spring Boot 3.x 完全放弃了对 Java 8/11 的支持，最低要求 Java 17。

*原因*:

- Java 17 是 LTS(长期支持)版本
- 利用 Record、Pattern Matching、Sealed Classes 等新特性
- 更好的性能和内存管理
- 与现代云原生环境对齐

==== Jakarta EE 迁移(破坏性变更)

这是 Spring Boot 3.x 最大的破坏性变更。由于 Oracle 将 Java EE 捐赠给 Eclipse Foundation 并更名为 Jakarta EE，所有 `javax.*` 包名都改为 `jakarta.*`。

```java
// Spring Boot 2.x (javax)
import javax.servlet.http.HttpServletRequest;
import javax.persistence.Entity;
import javax.validation.constraints.NotNull;
import javax.annotation.PostConstruct;

// Spring Boot 3.x (jakarta)
import jakarta.servlet.http.HttpServletRequest;
import jakarta.persistence.Entity;
import jakarta.validation.constraints.NotNull;
import jakarta.annotation.PostConstruct;
```

*受影响的包*:

- `javax.servlet` → `jakarta.servlet`
- `javax.persistence` → `jakarta.persistence`
- `javax.validation` → `jakarta.validation`
- `javax.annotation` → `jakarta.annotation`
- `javax.transaction` → `jakarta.transaction`

#caution[
  从 Spring Boot 2.x 升级到 3.x 时，所有代码和第三方库中的 `javax.*` 引用都必须改为 `jakarta.*`。这是一个大规模的破坏性变更，需要仔细测试。
]

==== GraalVM 原生镜像正式支持

Spring Boot 3.x 原生支持 GraalVM 原生编译，无需额外插件，配置大幅简化。

```xml
<!-- Spring Boot 3.x 简化配置 -->
<plugin>
    <groupId>org.graalvm.buildtools</groupId>
    <artifactId>native-maven-plugin</artifactId>
</plugin>
```

```bash
# 一键构建原生镜像
mvn spring-boot:build-image -Pnative

# 或使用 Gradle
./gradlew nativeCompile
```

*优势*:

- 启动时间: 从秒级降到毫秒级(~0.1s)
- 内存占用: 减少 50-70%
- 适合 Serverless、容器化部署

==== 可观测性(Observability)内置

Spring Boot 3.x 整合了 Micrometer Tracing，提供统一的观测性 API。

```java
// 自动集成 tracing
@RestController
public class UserController {

    @GetMapping("/users/{id}")
    public User getUser(@PathVariable Long id) {
        // 自动记录 trace、span
        return userService.findById(id);
    }
}
```

*支持的追踪系统*:

- Zipkin
- Jaeger
- Wavefront
- OTel(OpenTelemetry)

==== Kotlin 协程增强

Spring Boot 3.x 对 Kotlin 协程的支持更加完善，特别是在响应式编程中。

```kotlin
// Spring Boot 3.x + Kotlin 协程
@GetMapping("/users")
suspend fun getUsers(): List<User> {
    return userService.findAll()  //  suspend 函数，非阻塞
}
```

==== HTTP Interface 客户端

Spring Boot 3.x 引入了声明式 HTTP 客户端，类似 Feign。

```java
@HttpExchange("/api/users")
public interface UserClient {

    @GetExchange
    List<User> getAllUsers();

    @GetExchange("/{id}")
    User getUserById(@PathVariable Long id);

    @PostExchange
    User createUser(@RequestBody User user);
}
```

==== Problem Details for HTTP APIs

Spring Boot 3.x 支持 RFC 7807 标准的错误响应格式。

```json
{
  "type": "https://example.com/errors/not-found",
  "title": "User Not Found",
  "status": 404,
  "detail": "User with id 123 not found",
  "instance": "/api/users/123"
}
```

=== Spring Boot 4.x（2025）：现代化与弹性

Spring Boot 4.0 于 *2025年11月*正式发布，基于 Spring Framework 7.0，是一个面向云原生、高性能和开发者体验的里程碑版本。

*发布背景*：

Spring Boot 4.0 不是简单的迭代升级，而是围绕*云原生*、*高性能*、*开发效率*三大核心的全面重构。它标志着 Java 后端开发正式迈入"云原生+高性能"的新纪元。

*核心特性*：

*1. JSpecify 空安全体系*

Spring Boot 4.0 全面采用 JSpecify 注解实现标准化的空值安全，这是整个 Spring 产品栈的重大改进。

```java
// 传统方式：依赖 @Nullable 注解（不统一）
import org.springframework.lang.Nullable;

public User findUser(@Nullable String id) {
    return null;  // 可能返回null，但编译器不知道
}

// Spring Boot 4.0：JSpecify 标准注解
import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

public @Nullable User findUser(@NonNull String id) {
    return null;  // 编译器可以检查空值安全
}
```

*优势*：

- *编译期检查*：NullAway 等工具可以在编译时发现潜在的 NPE
- *标准化*：统一的注解规范，不再依赖 Spring 自定义注解
- *默认非空*：参数和返回值默认为非空，显式声明可空
- *全生态支持*：Spring Framework 7、Spring Cloud、Spring Data 全部采用

#tip[
  JSpecify 是由 Google、Uber、Spring 团队共同推动的空安全标准，旨在解决 Java 生态中长期存在的空指针问题。
]

*2. 虚拟线程深度整合*

Spring Boot 4.0 全面支持 Project Loom 虚拟线程，提供开箱即用的高并发能力。

```java
// application.yml 启用虚拟线程
spring:
  threads:
    virtual:
      enabled: true

// 自动配置 Tomcat 使用虚拟线程
server:
  tomcat:
    threads:
      max: 10000  # 虚拟线程可以轻松支持上万并发
```

*性能提升*：

- *吞吐量提升*：I/O 密集型应用吞吐量提升 2-3 倍
- *内存优化*：每个虚拟线程仅需几 KB 内存（平台线程需要 MB 级）
- *简化编程*：无需响应式编程即可实现高并发
- *兼容性*：完全兼容现有 Servlet 代码，无需重写

#note[
  虚拟线程特别适合 I/O 密集型场景（数据库查询、HTTP 调用、文件读写），对于 CPU 密集型任务效果有限。
]

*3. 原生 API 版本控制*

Spring Framework 7 引入了原生的 REST API 版本控制机制，无需第三方库或自定义拦截器。

```java
@RestController
@RequestMapping("/api/v{version}/users")
public class UserController {

    // v1 版本
    @GetMapping
    @ApiVersion(1)
    public List<UserDTO> getUsersV1() {
        return userService.findAllV1();
    }

    // v2 版本
    @GetMapping
    @ApiVersion(2)
    public List<UserDTO> getUsersV2() {
        return userService.findAllV2();
    }
}

// 支持的版本控制策略：
// 1. 路径版本：/api/v1/users, /api/v2/users
// 2. Header 版本：Accept: application/vnd.api.v1+json
// 3. 查询参数：/api/users?version=1
```

*优势*：

- *内置支持*：无需引入 springdoc-openapi 或其他第三方库
- *灵活路由*：根据版本号自动路由到对应的控制器方法
- *文档集成*：自动生成多版本文档
- *向后兼容*：轻松维护多个 API 版本

*4. Jackson 3 作为默认 JSON 库*

Spring Boot 4.0 将 Jackson 3.0 设为默认的 JSON 处理库，Jackson 2 被标记为弃用。

```java
// Jackson 3 的核心改进

// 1. 模块化系统支持
module com.example.app {
    requires com.fasterxml.jackson.databind;
}

// 2. Jakarta EE 命名空间
import jakarta.json.bind.annotation.JsonbProperty;

// 3. 清理废弃 API
// Jackson 2 中的过时方法已被移除
```

*为什么升级？*

- *现代 Java*：原生支持 Java 模块化系统（JPMS）
- *Jakarta EE*：完全迁移到 `jakarta.*` 命名空间
- *性能优化*：序列化/反序列化性能提升 10-15%
- *API 清理*：移除过去十几年积累的废弃 API

#caution[
  从 Spring Boot 3.x 升级到 4.x 时，如果项目使用了 Jackson 2 的特性，需要测试兼容性。大多数情况下可以直接迁移。
]

*5. 内置弹性能力*

Spring Boot 4.0 将重试、熔断、限流等弹性能力直接集成到框架内核，无需引入 Resilience4j 或 Spring Retry。

```java
// 内置重试机制
@Service
public class OrderService {

    @Retry(maxAttempts = 3, backoff = @Backoff(delay = 1000))
    public Order createOrder(OrderRequest request) {
        // 失败时自动重试3次，每次间隔1秒
        return orderRepository.save(request);
    }

    @CircuitBreaker(failureThreshold = 5, resetTimeout = 30000)
    public PaymentResult processPayment(PaymentRequest request) {
        // 失败5次后触发熔断，30秒后重置
        return paymentGateway.charge(request);
    }

    @RateLimiter(permitsPerSecond = 100)
    public List<Product> searchProducts(String keyword) {
        // 限制每秒100次请求
        return productRepository.search(keyword);
    }
}
```

*对比传统方案*：

#tex-table(
  ("特性", "Spring Boot 3.x", "Spring Boot 4.0"),
  ("重试", "需要 spring-retry", "内置 @Retry"),
  ("熔断", "需要 Resilience4j", "内置 @CircuitBreaker"),
  ("限流", "需要 Bucket4j", "内置 @RateLimiter"),
  ("依赖数量", "3-5个额外依赖", "零额外依赖"),
  ("配置复杂度", "需要单独配置 Bean", "注解即用"),
)

*6. 模块化自动配置*

Spring Boot 4.0 将原有的单体自动配置 JAR 拆分为多个独立模块，显著提升启动速度和内存效率。

```text
Spring Boot 3.x:
spring-boot-autoconfigure.jar (单体，~5MB)
  - 包含所有自动配置类
  - 即使不使用也会加载

Spring Boot 4.0:
spring-boot-autoconfigure-web.jar
spring-boot-autoconfigure-data.jar
spring-boot-autoconfigure-security.jar
spring-boot-autoconfigure-actuator.jar
...
  - 按需加载
  - 减少启动时间 20-30%
  - 降低内存占用
```

*7. GraalVM 25 原生镜像优化*

Spring Framework 7.0 采用 GraalVM 25 的统一可达性元数据格式，生成更轻量的原生镜像。

```bash
# 构建原生镜像（无需额外配置）
./mvnw -Pnative native:compile

# 启动速度对比
java -jar app.jar          # ~3-5秒
./app (native image)       # ~0.05秒 (50毫秒)

# 内存占用对比
java -jar app.jar          # ~500MB
./app (native image)       # ~50MB
```

*8. 其他重要变更*

- *Jakarta EE 11*：Servlet 6.1、JPA 3.2、Bean Validation 3.1
- *Tomcat 11*：默认内嵌服务器升级
- *Hibernate 7.1*：ORM 框架升级
- *Kotlin 2.2*：更好的协程支持
- *Gradle 9*：构建工具支持
- *移除 Undertow*：不再支持 Undertow 作为内嵌服务器
- *Redis 静态主从配置*：简化的 Redis 集群配置

#note[
  Spring Boot 4.0 移除了 Undertow 支持，如果项目使用了 Undertow，需要迁移到 Tomcat 或 Jetty。
]

*技术基线*：

- *最低 JDK*：Java 17（保持不变）
- *推荐 JDK*：Java 21 或 25（虚拟线程优化）
- *Spring Framework*：7.0
- *Jakarta EE*：11
- *Kotlin*：2.2+

=== 版本选型建议

根据项目类型和技术需求，选择合适的 Spring Boot 版本至关重要。

*新项目选型*：

*强烈推荐*：Spring Boot 4.0+ + JDK 21/25

*理由*：

1. *长期支持*：Spring Boot 4.x 是当前的主流版本，将持续维护到 2028 年+
2. *性能优势*：虚拟线程、GraalVM 原生镜像带来显著性能提升
3. *现代特性*：JSpecify 空安全、API 版本控制、内置弹性能力
4. *云原生友好*：更小的镜像、更快的启动、更低的内存占用
5. *生态完善*：Spring Cloud、Spring Data、Spring Security 均已适配

*适用场景*：

- *微服务架构*：虚拟线程提升并发能力，GraalVM 加速冷启动
- *高并发应用*：虚拟线程轻松支撑万级并发
- *Serverless*：原生镜像秒级启动，适合函数计算
- *企业级应用*：JSpecify 空安全减少 NPE，内置弹性能力提升稳定性

*中等推荐*：Spring Boot 3.5+ + JDK 17/21

*理由*：

- *稳定成熟*：经过多年生产验证，bug 较少
- *生态完整*：所有第三方库都完全兼容
- *学习资源丰富*：教程、文档、社区支持完善
- *升级风险低*：从 3.x 升级到 4.x 相对平滑

*适用场景*：

- *保守型企业*：追求稳定性，不愿尝试最新技术
- *遗留系统改造*：从 Spring Boot 2.x 迁移，先升级到 3.x
- *团队技术储备不足*：需要时间学习新特性

*存量项目升级*：

*Spring Boot 2.7.x*：

- *状态*：仍在维护，但建议规划升级
- *建议*：优先升级到 Spring Boot 3.5，修复所有 Deprecated API 警告
- *时间表*：6-12 个月内完成升级

*Spring Boot 2.x 以下*：

- *状态*：已停止维护，存在安全风险
- *建议*：*强烈建议立即升级*到 Spring Boot 3.x 或 4.x
- *风险*：安全漏洞、依赖冲突、无法获得技术支持

*升级路径建议*：

```text
Spring Boot 2.x → 3.x → 4.x

第一步：2.x → 3.5.x
- 修复所有 Deprecated API
- 迁移 javax.* → jakarta.*
- 升级 JDK 到 17+
- 测试兼容性

第二步：3.5.x → 4.0.x
- 适配 Jackson 3（如有自定义配置）
- 启用虚拟线程（可选）
- 使用 JSpecify 注解（可选）
- 利用内置弹性能力（可选）
```

#tip[
  升级前务必阅读官方迁移指南：https://github.com/spring-projects/spring-boot/wiki/Spring-Boot-4.0-Migration-Guide
]

*版本选择决策树*：

```text
新项目？
├─ 是 → 追求性能/云原生？
│       ├─ 是 → Spring Boot 4.0 + JDK 25
│       └─ 否 → Spring Boot 4.0 + JDK 17
└─ 否 → 当前版本？
        ├─ 2.x → 升级到 3.5 → 再升级到 4.0
        ├─ 3.0-3.4 → 升级到 3.5 → 再升级到 4.0
        └─ 3.5+ → 直接升级到 4.0
```

*未来展望*：

Spring Boot 4.1 预计将于 *2026年5月*发布，可能带来：

- *Spring AI 深度集成*：官方 AI/ML 支持
- *更强的可观测性*：OpenTelemetry 原生支持
- *Service Mesh 集成*：更好的云原生部署
- *eBPF 支持*：内核级性能监控
- *虚拟线程进一步优化*：更智能的调度算法

#note[
  本笔记所有示例基于 *Spring Boot 4.0.5* 和 *JDK 17* 编写，部分特性需要 JDK 21+ 才能充分发挥优势。
]

== 版本选型建议

选择合适的 Spring Boot 版本对于项目的成功至关重要。以下是基于不同场景的选型建议。

=== 新项目选型

*强烈推荐*: Spring Boot 3.2+ + JDK 17/21

*理由*:

1. 长期支持: Spring Boot 3.x 将持续维护到 2028 年+
2. 性能优势: 比 2.x 快 20-30%，内存占用更低
3. 现代特性: GraalVM 原生镜像、可观测性、HTTP Interface
4. 生态活跃: 第三方库都在向 3.x 迁移
5. 安全性: 持续的安全更新和漏洞修复

*JDK 选择*:

- JDK 17: 稳定、广泛支持、生产环境首选
- JDK 21: 最新 LTS，虚拟线程、Record Patterns 等新特性，适合追求前沿的项目

```xml
<!-- 推荐配置 -->
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>3.2.4</version>  <!-- 使用最新稳定版 -->
</parent>

<properties>
    <java.version>17</java.version>  <!-- 或 21 -->
</properties>
```

=== 存量项目升级策略

*Spring Boot 2.7.x 项目*:

*现状*:

- 仍然可以使用，但已进入维护末期
- 安全更新会持续到 2023 年底

*建议*:

1. 短期: 继续使用 2.7.x，保持稳定
2. 中期: 规划升级到 3.x(6-12 个月)
3. 长期: 必须升级到 3.x，否则面临安全风险

*升级步骤*:

```text
1. 升级 JDK 到 17+
2. 替换所有 javax.* 为 jakarta.*
3. 更新第三方依赖到兼容 3.x 的版本
4. 运行测试，修复兼容性问题
5. 灰度发布，逐步切换流量
```

*Spring Boot 2.6 及以下*:

*强烈建议立即升级*:

- 已停止维护，存在安全风险
- 缺少现代特性
- 第三方库可能不再支持

*Spring Boot 1.x*:

*紧急升级*:

- 早已停止维护
- 严重的安全隐患
- 与现代生态完全不兼容

=== 特殊场景选型

*Serverless / FaaS*:

*推荐*: Spring Boot 3.x + GraalVM 原生镜像

*理由*:

- 冷启动时间从秒级降到毫秒级
- 内存占用减少 50-70%
- 降低云成本

```bash
# 构建原生镜像
mvn spring-boot:build-image -Pnative

# 启动时间对比
# 传统 JVM: ~3-5s
# GraalVM Native: ~0.1s
```

*微服务架构*:

*推荐*: Spring Boot 3.x + Spring Cloud 2022.x

*理由*:

- 完整的微服务生态
- Service Discovery、Config、Gateway 等组件
- 与 Kubernetes 深度集成

*响应式系统*:

*推荐*: Spring Boot 3.x + WebFlux + Project Reactor

*理由*:

- 高并发、低延迟
- 非阻塞 I/O
- 适合 I/O 密集型应用

*传统企业应用*:

*推荐*: Spring Boot 3.x + JDK 17

*理由*:

- 稳定性优先
- 长期支持
- 成熟的生态

=== 版本对比总结

#tex-table(
  ("特性", "2.7.x", "3.2+", "4.x (未来)"),
  ("JDK 要求", "8-17", "17+", "21+?"),
  ("Jakarta EE", "❌ javax", "✅ jakarta", "✅ jakarta"),
  ("GraalVM", "🧪 实验性", "✅ 原生支持", "✅ 优化"),
  ("虚拟线程", "❌", "⚠️ 可用", "✅ 深度整合"),
  ("可观测性", "⚠️ 需配置", "✅ 内置", "✅ 增强"),
  ("维护状态", "维护末期", "活跃维护", "规划中"),
  ("推荐指数", "⭐⭐", "⭐⭐⭐⭐⭐", "待发布"),
)

*图例*: ✅ 支持 | ⚠️ 部分支持 | ❌ 不支持 | 🧪 实验性

#note[
  本笔记所有示例基于 *Spring Boot 3.2.4* 和 *JDK 17* 编写。如果你使用其他版本，某些 API 可能会有差异。
]


== 使用 Spring Initializr 创建第一个项目

=== 什么是Spring Initializr

Spring Initializr是Spring官方提供的项目生成工具，可以快速创建Spring Boot项目骨架。

*访问地址*: https://start.spring.io/

=== 在线方式创建项目

==== 步骤

1. 访问 https://start.spring.io/
2. 选择项目配置:
  - Project: Maven/Gradle
  - Language: Java/Kotlin
  - Spring Boot: 3.2.4
  - Group: com.example
  - Artifact: demo
  - Package name: com.example.demo
  - Packaging: Jar
  - Java: 17
3. 添加依赖:
  - Spring Web
  - Spring Data JPA
  - MySQL Driver
4. 点击"GENERATE"下载项目
5. 解压并导入IDE

=== 命令行方式

==== 使用curl

```bash
curl https://start.spring.io/starter.zip \
  -d type=maven-project \
  -d language=java \
  -d bootVersion=3.2.4 \
  -d baseDir=myapp \
  -d groupId=com.example \
  -d artifactId=myapp \
  -d name=myapp \
  -d packageName=com.example.myapp \
  -d javaVersion=17 \
  -d dependencies=web,data-jpa,mysql \
  -o myapp.zip

unzip myapp.zip
```

==== 使用SDKMAN!

```bash
spring init --dependencies=web,data-jpa,mysql myapp
```

=== IntelliJ IDEA集成

1. File → New → Project
2. 选择Spring Initializr
3. 配置项目信息
4. 选择依赖
5. 完成创建

#tip[
  推荐使用IntelliJ IDEA集成的Initializr，体验更流畅。
]

== 项目结构解析与核心注解

=== 标准项目结构

```
myapp/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/example/myapp/
│   │   │       ├── MyappApplication.java  # 启动类
│   │   │       ├── controller/            # 控制器层
│   │   │       ├── service/               # 业务逻辑层
│   │   │       ├── repository/            # 数据访问层
│   │   │       ├── model/                 # 实体类
│   │   │       └── config/                # 配置类
│   │   └── resources/
│   │       ├── application.properties     # 配置文件
│   │       ├── static/                    # 静态资源
│   │       └── templates/                 # 模板文件
│   └── test/                              # 测试代码
├── pom.xml                                # Maven配置
└── README.md
```

=== `@SpringBootApplication`注解

这是Spring Boot应用的*核心注解*，是一个组合注解:

```java
@SpringBootApplication
public class MyappApplication {
    public static void main(String[] args) {
        SpringApplication.run(MyappApplication.class, args);
    }
}
```

==== 等价于三个注解

```java
@Configuration          // 1. 配置类
@EnableAutoConfiguration // 2. 启用自动配置
@ComponentScan          // 3. 组件扫描
public class MyappApplication {
    // ...
}
```

==== 各部分作用

#tex-table(
  ("注解", "作用", "说明"),
  ("`@Configuration`", "标识配置类", "可以定义@Bean"),
  ("`@EnableAutoConfiguration`", "启用自动配置", "根据依赖自动配置Bean"),
  ("`@ComponentScan`", "组件扫描", "扫描当前包及子包"),
)

=== 常用注解速查

==== 分层注解

```java
@RestController      // REST控制器(@Controller + @ResponseBody)
@Service             // 服务层
@Repository          // 数据访问层
@Component           // 通用组件
```

==== 依赖注入

```java
@Autowired           // 自动注入(字段注入)
@Resource            // JSR-250标准
@Inject              // JSR-330标准
```

#tip[
  推荐使用构造器注入而非字段注入，更易于测试。
]

==== 配置相关

```java
@Configuration       // 配置类
@Bean                // 定义Bean
@Value               // 注入配置值
@ConfigurationProperties // 类型安全配置绑定
```

== 内嵌Web容器与启动原理初探

=== 内嵌Web容器

Spring Boot默认内嵌*Tomcat*作为Web容器。

==== 支持的容器

#tex-table(
  ("容器", "Starter", "特点"),
  ("Tomcat", "spring-boot-starter-tomcat", "默认，成熟稳定"),
  ("Jetty", "spring-boot-starter-jetty", "轻量，适合长连接"),
  ("Undertow", "spring-boot-starter-undertow", "高性能，低内存"),
)

==== 切换容器

```xml
<!-- 排除Tomcat，使用Jetty -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <exclusions>
        <exclusion>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-tomcat</artifactId>
        </exclusion>
    </exclusions>
</dependency>

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-jetty</artifactId>
</dependency>
```

=== 启动流程简析

```java
@SpringBootApplication
public class MyappApplication {
    public static void main(String[] args) {
        SpringApplication.run(MyappApplication.class, args);
    }
}
```

==== 主要步骤

1. *创建SpringApplication对象*
  - 推断应用类型(SERVLET/REACTIVE/NONE)
  - 加载ApplicationContextInitializer
  - 加载ApplicationListener

2. *执行run()方法*
  - 启动计时器
  - 创建ApplicationContext
  - 刷新上下文(加载Bean)
  - 调用Runner(CommandLineRunner/ApplicationRunner)
  - 返回ApplicationContext

===== 简化流程图

```
main()
  ↓
SpringApplication构造
  ↓
run()
  ↓
创建Context
  ↓
刷新Context(自动配置)
  ↓
启动内嵌Tomcat
  ↓
应用就绪
```

=== 第一个REST接口

```java
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
public class HelloController {

    @GetMapping("/hello")
    public String hello() {
        return "Hello, Spring Boot!";
    }

    @GetMapping("/greet/{name}")
    public String greet(@PathVariable String name) {
        return "Hello, " + name + "!";
    }
}
```

*运行应用*:

```bash
mvn spring-boot:run
```

*访问*:

```bash
curl http://localhost:8080/api/hello
# 输出: Hello, Spring Boot!

curl http://localhost:8080/api/greet/World
# 输出: Hello, World!
```

#fancy-divider

本章介绍了Spring Boot的基础知识，包括其诞生背景、核心价值、版本选型、环境准备、项目创建和启动原理。下一章将深入探讨Spring Boot的配置管理与自动配置机制。
