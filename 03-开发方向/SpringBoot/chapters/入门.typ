#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= 初识 Spring Boot

#note[
  *版本说明*：本笔记基于以下技术栈版本编写，示例代码均在此环境下测试通过。

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

在Spring Boot出现之前，使用Spring框架开发应用存在诸多问题：

*配置复杂*：

- 大量的XML配置文件
- 依赖管理繁琐
- 需要手动配置Tomcat等Web容器

*部署困难*：

- 需要打包成WAR文件
- 部署到外部应用服务器
- 环境配置复杂

*开发效率低*：

- 项目搭建耗时长
- 约定不明确
- 学习曲线陡峭

=== Spring Boot的解决方案

Spring Boot的核心理念是*“约定优于配置”*（Convention over Configuration）。

*核心特性*：

#tex-table(
  ("特性", "说明", "优势"),
  ("自动配置", "根据依赖自动配置Bean", "零配置启动"),
  ("内嵌容器", "内置Tomcat/Jetty/Undertow", "独立运行"),
  ("Starter依赖", "一站式依赖管理", "简化Maven/Gradle"),
  ("生产就绪", "Actuator监控端点", "开箱即用"),
  ("无代码生成", "无需XML，无需代码生成", "简洁清晰"),
)

=== Spring Boot的核心价值

1. *快速启动*：
  - 几分钟内创建可运行的应用
  - 减少样板代码
  - 专注业务逻辑

2. *简化配置*：
  - 自动配置大多数场景
  - 配置文件简单明了
  - 支持多种配置格式

3. *独立运行*：
  - 内嵌Web容器
  - JAR包直接运行
  - 微服务友好

4. *生态丰富*：
  - 大量Starter可用
  - 社区活跃
  - 文档完善

#tip[
  Spring Boot不是要替代Spring，而是让Spring更容易使用。
]

== Spring Boot版本演进与选型建议

=== 版本历史

#tex-table(
  ("版本", "发布年份", "JDK要求", "状态"),
  ("1.x", "2014", "Java 6+", "已停止维护"),
  ("2.x", "2018", "Java 8+", "部分维护"),
  ("3.x", "2022", "Java 17+", "当前主流"),
)

=== Spring Boot 3.x重大变化

Spring Boot 3.x是基于Spring Framework 6的重大版本升级：

*核心变化*：

1. *最低JDK版本*：从Java 8提升到*Java 17*
2. *Jakarta EE*：从`javax.*`迁移到`jakarta.*`
3. *GraalVM原生镜像*：原生支持AOT编译
4. *Observability*：内置可观测性支持
5. *Kotlin协程*：更好的响应式支持

==== Jakarta EE迁移

```java
// Spring Boot 2.x (javax)
import javax.servlet.http.HttpServletRequest;
import javax.persistence.Entity;

// Spring Boot 3.x (jakarta)
import jakarta.servlet.http.HttpServletRequest;
import jakarta.persistence.Entity;
```

#caution[
  从2.x升级到3.x时，所有`javax.*`包都需要改为`jakarta.*`，这是破坏性变更。
]

=== 版本选型建议

*新项目*：

- *推荐*：Spring Boot 3.2+ + JDK 17/21
- *理由*：长期支持、性能更好、新特性

*存量项目*：

- Spring Boot 2.7.x：可以继续使用，但建议规划升级
- Spring Boot 2.x以下：强烈建议升级

#note[
  本笔记所有示例基于*Spring Boot 3.2.4*和*JDK 17*编写。
]

== 开发环境准备

=== JDK安装与配置

==== 推荐版本

- *JDK 17* (LTS)：Spring Boot 3.x最低要求
- *JDK 21* (LTS)：最新长期支持版本

==== 安装方式

*方式1：SDKMAN!（推荐，Linux/Mac）*

```bash
# 安装SDKMAN!
curl -s "https://get.sdkman.io" | bash

# 安装JDK 17
sdk install java 17.0.10-tem

# 切换版本
sdk use java 17.0.10-tem
```

*方式2：官方下载*

访问 https://adoptium.net/ 下载Temurin JDK。

*方式3：Homebrew（Mac）*

```bash
brew install openjdk@17
```

==== 验证安装

```bash
java -version
# 输出：openjdk version "17.0.10" ...

javac -version
# 输出：javac 17.0.10
```

=== Maven安装

==== 推荐版本

Maven 3.9+

==== 安装方式

*SDKMAN!*

```bash
sdk install maven 3.9.6
```

*Homebrew*

```bash
brew install maven
```

*官方下载*

访问 https://maven.apache.org/download.cgi

==== 配置国内镜像

编辑 `~/.m2/settings.xml`：

```xml
<settings>
  <mirrors>
    <mirror>
      <id>aliyun</id>
      <mirrorOf>central</mirrorOf>
      <name>Aliyun Maven</name>
      <url>https://maven.aliyun.com/repository/public</url>
    </mirror>
  </mirrors>
</settings>
```

==== 验证安装

```bash
mvn -version
# 输出：Apache Maven 3.9.6 ...
```

=== Gradle安装（可选）

==== 推荐版本

Gradle 8.5+

==== 安装方式

```bash
# SDKMAN!
sdk install gradle 8.5

# Homebrew
brew install gradle
```

==== 验证安装

```bash
gradle -version
```

=== IDE选择

#tex-table(
  ("IDE", "优点", "适用人群"),
  ("IntelliJ IDEA", "Spring支持最好，智能提示强大", "专业开发者"),
  ("VS Code", "轻量级，插件丰富", "全栈开发者"),
  ("Eclipse", "免费，老牌IDE", "传统企业"),
)

*推荐*：IntelliJ IDEA Ultimate（付费）或Community（免费）

==== IntelliJ IDEA配置

1. 安装Spring Boot插件（Ultimate版自带）
2. 配置JDK 17
3. 启用注解处理（Annotation Processing）

== 使用 Spring Initializr 创建第一个项目

=== 什么是Spring Initializr

Spring Initializr是Spring官方提供的项目生成工具，可以快速创建Spring Boot项目骨架。

*访问地址*：https://start.spring.io/

=== 在线方式创建项目

==== 步骤

1. 访问 https://start.spring.io/
2. 选择项目配置：
  - Project: Maven/Gradle
  - Language: Java/Kotlin
  - Spring Boot: 3.2.4
  - Group: com.example
  - Artifact: demo
  - Package name: com.example.demo
  - Packaging: Jar
  - Java: 17
3. 添加依赖：
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

这是Spring Boot应用的*核心注解*，是一个组合注解：

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
@RestController      // REST控制器（@Controller + @ResponseBody）
@Service             // 服务层
@Repository          // 数据访问层
@Component           // 通用组件
```

==== 依赖注入

```java
@Autowired           // 自动注入（字段注入）
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
  - 推断应用类型（SERVLET/REACTIVE/NONE）
  - 加载ApplicationContextInitializer
  - 加载ApplicationListener

2. *执行run()方法*
  - 启动计时器
  - 创建ApplicationContext
  - 刷新上下文（加载Bean）
  - 调用Runner（CommandLineRunner/ApplicationRunner）
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
刷新Context（自动配置）
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

*运行应用*：

```bash
mvn spring-boot:run
```

*访问*：

```bash
curl http://localhost:8080/api/hello
# 输出：Hello, Spring Boot!

curl http://localhost:8080/api/greet/World
# 输出：Hello, World!
```

#fancy-divider

本章介绍了Spring Boot的基础知识，包括其诞生背景、核心价值、版本选型、环境准备、项目创建和启动原理。下一章将深入探讨Spring Boot的配置管理与自动配置机制。
