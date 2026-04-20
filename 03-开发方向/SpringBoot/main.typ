#import "../../99-索引与模板/TypstTemplate/computer-notes.typ": *


// ── 文档元信息 ──
#set document(
  title: "Spring Boot",
  author: "Violet",
  date: datetime.today(),
)

// 应用全局样式
#show: apply-style


// ══════════════════════════════════════════════════════════════════════
// 封面
// ══════════════════════════════════════════════════════════════════════

#make-cover(
  "Spring Boot",
  "Violet",
  date: datetime.today().display(),
)

// 目录
#make-outline(depth: 3)


#part("Spring Boot 基础")
#include "chapters/入门.typ"
#include "chapters/日志系统.typ"

#part("Spring Boot 核心")
#include "chapters/Web开发核心.typ"
#include "chapters/数据访问与持久层框架.typ"
#include "chapters/安全与认证授权.typ"
#include "chapters/定时任务与异步处理.typ"
#include "chapters/日志系统.typ"

#include "chapters/监控与可观测性.typ"

#part("微服务与中间件")
#include "chapters/微服务架构基础.typ"

#part("Spring Boot 源码")


// % Part 1：Spring Boot 快速入门与核心基础
// % Chapter 1：初识 Spring Boot
// % 1.1 Spring Boot 诞生背景与核心价值
// % 1.2 Spring Boot 版本演进与选型建议
// % 1.3 开发环境准备（JDK、Maven/Gradle、IDE）
// % 1.4 使用 Spring Initializr 创建第一个项目
// % 1.5 项目结构解析与核心注解 @SpringBootApplication
// % 1.6 内嵌 Web 容器与启动原理初探
//
// % Chapter 2：配置管理与自动配置基础
// % 2.1 配置文件格式与语法（properties / yml）
// % 2.2 多环境配置与 Profile 机制
// % 2.3 @ConfigurationProperties 与类型安全的属性绑定
// % 2.4 配置文件的加载顺序与覆盖规则
// % 2.5 自定义配置类与 @Conditional 条件注解入门
//
// % Chapter 3：IoC 容器与依赖注入
// % 3.1 Spring IoC 容器概述与 Bean 概念
// % 3.2 定义 Bean 的常用注解（@Component、@Service、@Repository、@Controller）
// % 3.3 依赖注入方式：字段注入、构造器注入、Setter 注入
// % 3.4 Bean 的作用域（@Scope）与生命周期回调（@PostConstruct、@PreDestroy）
// % 3.5 配置类与 @Bean 的配合使用
//
// % Chapter 4：日志系统详解
// % 4.1 Java日志生态与SLF4J门面模式
// % 4.2 Spring Boot默认日志框架（Logback）
// % 4.3 Logback配置详解（appender、layout、rolling policy）
// % 4.4 日志级别与继承规则
// % 4.5 异步日志与性能优化
// % 4.6 结构化日志与JSON格式输出
// % 4.7 MDC与链路追踪上下文
// % 4.8 敏感信息脱敏与安全日志
// % 4.9 多环境日志配置（Profile）
// % 4.10 自定义Appender与日志扩展


// % Part 2：Spring Boot 企业级开发实战
// % Chapter 5：Web 开发核心
// % 5.1 HTTP 协议与 RESTful API 设计（HTTP 基础、Spring MVC 架构、RESTful 规范）
// % 5.2 请求处理：参数接收与数据绑定（@PathVariable、@RequestParam、@RequestBody、@RequestHeader）
// % 5.3 请求处理：文件上传与下载（MultipartFile、大文件处理、断点续传）
// % 5.4 响应处理：ResponseEntity 与统一响应结构（泛型封装、分页响应）
// % 5.5 参数校验：Bean Validation 实战（@Valid、分组校验、自定义校验器、国际化错误消息）
// % 5.6 全局异常处理：@ControllerAdvice + @ExceptionHandler（异常分类、错误码设计）
// % 5.7 拦截器与过滤器：HandlerInterceptor、Filter、OncePerRequestFilter（执行顺序、应用场景）
// % 5.8 跨域配置：CORS 原理与实现（@CrossOrigin、WebMvcConfigurer、过滤器方式）
// % 5.9 内容协商与国际化：Accept Header、MessageSource、LocaleResolver
// % 5.10 静态资源处理：ResourceHandler、WebJars、CDN 集成
//
// % Chapter 6：数据访问与持久层框架
// % 6.1 数据源配置与连接池（HikariCP）
// % 6.2 MyBatis 整合（XML 映射、注解映射、@MapperScan）
// % 6.3 MyBatis-Plus 整合（CRUD 接口、条件构造器、分页插件）
// % 6.4 Spring Data JPA 基础（Repository 接口、方法命名规则）
// % 6.5 多数据源与动态数据源实现
// % 6.6 事务管理基础（@Transactional、传播行为、隔离级别、声明式事务）
//
// % Chapter 7：安全与认证授权
// % 7.1 Spring Security 核心概念与架构
// % 7.2 基于表单的认证与授权
// % 7.3 JWT 无状态认证（登录接口、令牌生成与校验、过滤器集成）
// % 7.4 方法级安全控制（@PreAuthorize、@Secured）
// % 7.5 自定义 UserDetailsService 与密码编码器
// % 7.6 OAuth2 客户端与资源服务器入门
//
// % Chapter 8：定时任务与异步处理
// % 8.1 定时任务（@Scheduled、cron 表达式、固定延迟与固定速率）
// % 8.2 异步任务（@Async、线程池配置、异步回调）
// % 8.3 分布式定时任务方案概述（Quartz、XXL-JOB）
//
// % Chapter 9：常用依赖与工具集成
// % 9.1 Lombok 详解（@Data、@Builder、@Slf4j、@AllArgsConstructor）
// % 9.2 MapStruct 对象映射（编译时类型安全、自定义转换）
// % 9.3 Guava 工具库（集合、缓存、RateLimiter限流）
// % 9.4 Apache Commons 工具类（Lang、IO、Collections）
// % 9.5 JSON 处理（Jackson 注解、Gson 对比、性能优化）
// % 9.6 HTTP 客户端（RestTemplate、WebClient、OkHttp）
// % 9.7 API 文档生成（SpringDoc OpenAPI 3.0、Swagger UI）
// % 9.8 日期时间处理（java.time、Jackson 序列化）
// % 9.9 其他实用工具（Hutool、Apache POI、EasyExcel）
//
// Chapter 10：响应式编程与 WebFlux
// 10.1 响应式编程基础（Reactor 核心：Mono/Flux、背压机制）
// 10.2 Spring WebFlux 核心组件与路由函数
// 10.3 WebFlux 中的数据访问（R2DBC、MongoDB Reactive）
// 10.4 响应式安全与测试
//
// Chapter 11：监控与可观测性
// 11.1 可观测性三大支柱（Logs、Metrics、Traces）
// 11.2 Actuator端点详解（health、info、metrics、env、threaddump）
// 11.3 自定义健康检查（HealthIndicator）
// 11.4 自定义指标收集（MeterRegistry、Counter、Gauge、Timer）
// 11.5 Micrometer核心概念与抽象层
// 11.6 集成Prometheus与Grafana可视化
// 11.7 链路追踪基础（OpenTelemetry、Micrometer Tracing）
// 11.8 分布式追踪实践（Zipkin、Jaeger）
// 11.9 日志聚合与分析（ELK Stack、Loki + Grafana）
// 11.10 告警与通知（Alertmanager、钉钉/企业微信）


// % Part 3：微服务与中间件（高并发场景实战）
// % Chapter 12：微服务架构基础
// % 12.1 微服务架构概述与 Spring Cloud 生态
// % 12.2 服务注册与发现（Nacos / Consul / Kubernetes Service）
// % 12.3 配置中心（Nacos Config / Spring Cloud Config）
// % 12.4 声明式服务调用（OpenFeign + Spring Cloud LoadBalancer）
// % 12.5 API 网关（Spring Cloud Gateway 路由、断言、过滤器）
//
// % Chapter 13：服务容错与流量控制
// % 13.1 熔断与限流原理（Resilience4j、Sentinel）
// % 13.2 基于 Sentinel 的限流、熔断、热点参数限流
// % 13.3 网关层限流与熔断整合
// % 13.4 分布式系统容错模式（舱壁隔离、重试、超时控制）
//
// % Chapter 14：消息驱动与异步通信
// % 14.1 消息中间件选型（RocketMQ、Kafka、RabbitMQ）
// % 14.2 Spring Boot 整合 RocketMQ（生产、消费、事务消息）
// % 14.3 Spring Boot 整合 Kafka（分区、消费组、批量处理）
// % 14.4 Spring Cloud Stream 统一编程模型
// % 14.5 消息可靠性与幂等设计
//
// % Chapter 15：分布式事务与最终一致性
// % 15.1 分布式事务理论基础（CAP、BASE、2PC、TCC）
// % 15.2 Seata 整合（AT 模式、TCC 模式）
// % 15.3 可靠消息最终一致性方案（事务消息、本地消息表）
// % 15.4 最大努力通知与补偿机制
//
// % Chapter 16：缓存高并发设计
// % 16.1 本地缓存（Caffeine）与分布式缓存（Redis）
// % 16.2 缓存穿透、击穿、雪崩解决方案
// % 16.3 多级缓存架构（本地+分布式）
// % 16.4 热点数据缓存更新策略（双写一致、延迟双删）
// % 16.5 布隆过滤器实战
//
// % Chapter 17：链路追踪与全链路压测
// % 17.1 分布式链路追踪原理（TraceId、Span）
// % 17.2 基于 OpenTelemetry 的埋点与集成
// % 17.3 Zipkin / Jaeger 可视化
// % 17.4 全链路压测平台与影子库方案
//
// % Chapter 18：微服务安全与认证
// % 18.1 OAuth2 授权码模式与 OIDC 协议
// % 18.2 Keycloak 集成与单点登录
// % 18.3 Spring Security 与 Gateway 统一认证
// % 18.4 服务间认证（JWT 传递、mTLS）
//
// % Chapter 19：云原生与容器化部署
// % 19.1 Docker 镜像构建与优化（Jib、多阶段构建）
// % 19.2 Kubernetes 部署（Deployment、Service、ConfigMap、Secret）
// % 19.3 CI/CD 集成（GitHub Actions、Jenkins）
// % 19.4 服务网格初步（Istio 流量管理）
// % 19.5 容器化环境下的配置与监控

// % Part 4：Spring Boot 源码深度剖析
// % Chapter 20：Spring Boot 启动流程源码解析
// % 20.1 SpringApplication 的初始化过程（构造器、WebApplicationType 推断）
// % 20.2 run() 方法执行流程（启动监听器、环境准备、上下文创建与刷新）
// % 20.3 事件与监听器机制（ApplicationEvent、ApplicationListener 的发布与监听）
// % 20.4 应用上下文（ApplicationContext）的创建与刷新时机
// % Chapter 21：IoC 容器核心（Bean 生命周期与依赖注入）
// % 21.1 BeanDefinition 的解析与注册（@Component、@Bean 等）
// % 21.2 Bean 的创建过程（实例化、属性填充、初始化、销毁）
// % 21.3 依赖注入底层实现（AutowiredAnnotationBeanPostProcessor 处理流程）
// % 21.4 循环依赖解决机制（三级缓存）
// % 21.5 BeanPostProcessor 与 BeanFactoryPostProcessor 扩展点
// % Chapter 22：自动配置原理深度剖析
// % 22.1 @EnableAutoConfiguration 入口与 AutoConfigurationImportSelector
// % 22.2 自动配置类的加载机制（spring.factories、META-INF/spring/org.springframework.boot.autoconfigure.AutoConfiguration.imports）
// % 22.3 条件注解（@Conditional 系列）的解析与评估过程
// % 22.4 自定义 Starter 实现原理与最佳实践
// % 22.5 自动配置高级：@AutoConfigureAfter、@AutoConfigureBefore、自动配置排序
// % Chapter 23：AOP 与动态代理
// % 23.1 Spring AOP 的使用场景与核心概念（切点、通知、织入）
// % 23.2 动态代理机制对比（JDK 动态代理 vs CGLIB）
// % 23.3 @EnableAspectJAutoProxy 与代理创建过程
// % 23.4 AOP 通知的执行顺序与切面优先级
// % 23.5 事务管理中的 AOP 实现（TransactionInterceptor）
// % Chapter 24：事务管理源码剖析
// % 24.1 @EnableTransactionManagement 与事务基础设施（TransactionManager、TransactionDefinition）
// % 24.2 事务拦截器（TransactionInterceptor）的工作原理
// % 24.3 事务传播行为与隔离级别的底层实现
// % 24.4 事务同步与资源管理（TransactionSynchronizationManager）
// % Chapter 25：Spring MVC 源码剖析
// % 25.1 DispatcherServlet 初始化与 onRefresh 加载策略
// % 25.2 请求处理核心流程（doDispatch）
// % 25.3 HandlerMapping 与 HandlerAdapter 的查找与执行
// % 25.4 参数解析器（HandlerMethodArgumentResolver）与返回值处理器（HandlerMethodReturnValueHandler）
// % 25.5 视图解析与响应渲染
// % 25.6 拦截器（HandlerInterceptor）的执行时机与顺序
// % Chapter 26：Spring Data 源码剖析
// % 26.1 Repository 接口的代理机制（@EnableJpaRepositories、JpaRepositoryFactoryBean）
// % 26.2 方法命名查询的解析与执行
// % 26.3 自定义 Repository 实现与扩展
// % Chapter 27：Spring Security 源码剖析
// % 27.1 @EnableWebSecurity 与安全配置的加载
// % 27.2 过滤器链的构建与执行顺序
// % 27.3 认证流程（AuthenticationManager、ProviderManager、AuthenticationProvider）
// % 27.4 授权决策（AccessDecisionManager、AccessDecisionVoter）
// % Chapter 28：其他核心扩展机制
// % 28.1 应用事件发布与监听源码追踪
// % 28.2 自定义 ApplicationContextInitializer 与 ApplicationRunner/CommandLineRunner
// % 28.3 嵌入式 Web 容器启动原理（TomcatServletWebServerFactory）
// % 28.4 @ConfigurationProperties 绑定原理与 ConfigurationPropertiesBindingPostProcessor
