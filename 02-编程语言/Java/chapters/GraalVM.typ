#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= GraalVM

GraalVM是一个高性能的通用虚拟机，由Oracle主导开发。它不仅能运行Java字节码，还能运行JavaScript、Python、Ruby、R等多种语言，并提供了原生镜像（Native Image）编译能力，显著提升了启动速度和降低了内存占用。

#note[
  GraalVM的核心理念是*多语言支持*和*高性能*，通过Ahead-of-Time（AOT）编译技术，将Java应用编译为原生可执行文件，实现毫秒级启动和极低的内存占用。
]

== GraalVM概述

=== 发展历程

- *2018年*：Oracle正式发布GraalVM
- *2019年*：推出GraalVM Enterprise Edition
- *2020年*：GraalVM成为OpenJDK项目
- *2021年*：Spring Boot 2.4开始支持GraalVM原生镜像
- *2022年*：Spring Boot 3.0全面支持GraalVM
- *现在*：云原生Java应用的首选运行时

=== 核心组件

==== Graal编译器

- 高性能的JIT编译器
- 用Java编写，易于扩展
- 支持多种语言
- 比C2编译器性能更好

==== Native Image

- AOT编译工具
- 将Java应用编译为原生可执行文件
- 无需JVM即可运行
- 启动速度快，内存占用低

==== Polyglot API

- 多语言互操作性
- 在Java中调用其他语言代码
- 共享数据和对象
- 零拷贝性能

==== Truffle框架

- 语言实现框架
- 简化新语言的实现
- 自动获得Graal编译器优化

=== GraalVM vs 传统JVM

#tex-table(
  ("特性", "传统JVM", "GraalVM"),
  ("启动速度", "秒级", "毫秒级"),
  ("内存占用", "较高", "极低"),
  ("峰值性能", "优秀", "优秀或更好"),
  ("多语言支持", "有限", "原生支持"),
  ("容器友好性", "一般", "优秀"),
  ("冷启动", "慢", "快"),
  ("适用场景", "长期运行服务", "Serverless、微服务"),
)

#tip[
  GraalVM不是要取代传统JVM，而是在特定场景下提供更好的选择。对于长期运行的服务，传统JVM的JIT优化可能更有优势；而对于需要快速启动的场景，GraalVM的原生镜像是更好的选择。
]

== Native Image详解

Native Image是GraalVM最引人注目的特性，它将Java应用提前编译为原生机器码。

=== 工作原理

==== 构建时初始化

```text
传统JVM:                          Native Image:
源代码 -> 字节码                   源代码 -> 字节码
     ↓                                  ↓
运行时JIT编译                      构建时AOT编译
     ↓                                  ↓
机器码（热点代码）                  原生可执行文件
     ↓                                  ↓
运行                               直接运行
```

*关键区别*：

- 传统JVM：运行时动态编译热点代码
- Native Image：构建时静态编译所有可达代码

==== 封闭世界假设

Native Image基于*封闭世界假设*（Closed World Assumption）：

- 构建时确定所有可达的代码和数据
- 运行时不能动态加载新的类
- 反射、JNI等需要在构建时配置

#caution[
  封闭世界假设是Native Image的主要限制。任何运行时动态行为（反射、动态代理、资源加载等）都需要显式配置。
]

==== 静态分析

```text
入口点（main方法）
    ↓
静态分析可达代码
    ↓
移除未使用的代码（Dead Code Elimination）
    ↓
内联优化
    ↓
生成原生机器码
    ↓
链接系统库
    ↓
生成可执行文件
```

=== 构建Native Image

==== 使用native-image命令

```bash
# 基本用法
native-image -jar myapp.jar

# 指定输出名称
native-image -jar myapp.jar -o myapp

# 启用所有安全提示
native-image -jar myapp.jar --enable-all-security-services

# 指定主类
native-image -cp myapp.jar com.example.Main
```

==== 使用Maven插件

```xml
<plugin>
    <groupId>org.graalvm.buildtools</groupId>
    <artifactId>native-maven-plugin</artifactId>
    <version>0.9.28</version>
    <executions>
        <execution>
            <id>build-native</id>
            <goals>
                <goal>compile-no-fork</goal>
            </goals>
            <phase>package</phase>
        </execution>
    </executions>
</plugin>
```

```bash
# 构建原生镜像
mvn -Pnative native:compile

# 运行测试
mvn -Pnative test
```

==== 使用Gradle插件

```groovy
plugins {
    id 'org.graalvm.buildtools.native' version '0.9.28'
}

graalvmNative {
    binaries {
        main {
            imageName.set('myapp')
            mainClass.set('com.example.Main')
        }
    }
}
```

```bash
# 构建原生镜像
./gradlew nativeCompile

# 运行
./build/native/nativeCompile/myapp
```

#tip[
  Spring Boot 3.0+内置了GraalVM支持，使用 `spring-boot-maven-plugin` 即可轻松构建原生镜像。
]

=== 性能对比

==== 启动时间

```text
传统JVM (Spring Boot):
  - 启动时间: 5-10秒
  - 首次请求: 可能有JIT编译延迟

Native Image (Spring Boot):
  - 启动时间: 50-200毫秒
  - 首次请求: 无额外延迟
```

*提升*：*50-100倍*

==== 内存占用

```text
传统JVM:
  - RSS内存: 200-500 MB
  - 堆内存: 根据配置

Native Image:
  - RSS内存: 20-50 MB
  - 无独立堆（使用系统内存）
```

*降低*：*80-90%*

==== 吞吐量

```
短期运行（< 1分钟）:
  - Native Image: 更优（无JIT预热）

长期运行（> 10分钟）:
  - 传统JVM: 可能更优（JIT优化热点代码）
  - Native Image: 稳定（已优化）
```

#note[
  Native Image的优势在于启动速度和内存占用，而不是峰值吞吐量。对于长期运行的高负载服务，传统JVM的JIT优化可能达到更高的峰值性能。
]

== 配置与优化

Native Image需要特殊配置来处理反射、资源文件等动态特性。

=== 反射配置

反射是Native Image最常见的配置需求。

==== 问题示例

```java
// 这段代码在Native Image中会失败
class MyClass {
    public void doSomething() {
        // ...
    }
}

// 运行时反射
Class<?> clazz = Class.forName("com.example.MyClass");
Object obj = clazz.getDeclaredConstructor().newInstance();
```

*原因*：Native Image在构建时不知道需要保留`MyClass`的反射元数据。

==== 解决方案

===== 方式1：reflect-config.json

创建 `src/main/resources/META-INF/native-image/reflect-config.json`：

```json
[
  {
    "name": "com.example.MyClass",
    "allDeclaredConstructors": true,
    "allPublicMethods": true,
    "allDeclaredFields": true
  }
]
```

===== 方式2：`@RegisterForReflection`注解

```java
import org.graalvm.nativeimage.hosted.RegisterForReflection;

@RegisterForReflection
public class MyClass {
    public void doSomething() {
        // ...
    }
}
```

===== 方式3：Spring Boot自动配置

Spring Boot 3.0+会自动处理大部分反射配置：

```java
// Spring会自动注册这些类用于反射
@Component
public class MyService {
    // ...
}
```

#tip[
  Spring Boot 3.0+的AOT处理会自动生成大部分所需的配置文件，大大简化了Native Image的配置工作。
]

=== 资源文件配置

==== 问题

```java
// 读取资源文件
InputStream is = getClass().getResourceAsStream("/config.properties");
```

在Native Image中，资源文件不会自动包含。

==== 解决方案

创建 `src/main/resources/META-INF/native-image/resource-config.json`：

```json
{
  "resources": {
    "includes": [
      {"pattern": "\\Qconfig.properties\\E"},
      {"pattern": "static/.*"}
    ]
  }
}
```

或使用通配符：

```json
{
  "resources": {
    "includes": [
      {"pattern": ".*\\.properties$"},
      {"pattern": "static/.*"}
    ]
  }
}
```

=== JNI配置

如果使用了JNI，需要配置 `jni-config.json`：

```json
[
  {
    "name": "com.example.NativeLibrary",
    "methods": [
      {"name": "nativeMethod", "parameterTypes": ["java.lang.String"]}
    ]
  }
]
```

=== 代理模式配置

Spring AOP、Hibernate等使用动态代理，需要配置：

```json
[
  {
    "interfaces": [
      "com.example.MyInterface"
    ]
  }
]
```

#note[
  Spring Boot 3.0+的AOT处理会自动检测并配置大部分代理场景，通常不需要手动配置。
]

=== 构建时初始化

有些类需要在构建时初始化，而不是运行时：

```properties
# application.properties
spring.native.remove-unused-autoconfig=true
spring.native.remove-yaml-support=true
```

或在 `native-image.properties` 中配置：

```properties
Args = --initialize-at-build-time=com.example.MyClass
```

== Spring Boot与GraalVM

Spring Boot 3.0+对GraalVM提供了原生支持，使得构建原生镜像变得非常简单。

=== Spring Boot 3.0的新特性

==== AOT处理

Spring Boot 3.0引入了AOT（Ahead-of-Time）处理引擎：

- 在构建时分析Spring应用上下文
- 生成GraalVM所需的配置文件
- 优化Bean定义和依赖注入

```text
传统Spring Boot:
  启动时扫描 -> 创建Bean -> 依赖注入 -> 运行

Spring Boot + GraalVM:
  构建时AOT处理 -> 生成配置 -> 编译为原生镜像 -> 运行
```

==== 自动配置优化

Spring Boot会自动：

- 检测并注册反射类
- 配置资源文件
- 处理动态代理
- 优化条件注解

=== 实践示例

==== 创建Spring Boot应用

```java
@SpringBootApplication
@RestController
public class DemoApplication {

    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }

    @GetMapping("/hello")
    public String hello() {
        return "Hello from GraalVM!";
    }
}
```

==== pom.xml配置

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
         https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.2.0</version>
    </parent>

    <groupId>com.example</groupId>
    <artifactId>graalvm-demo</artifactId>
    <version>1.0.0</version>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
            <plugin>
                <groupId>org.graalvm.buildtools</groupId>
                <artifactId>native-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
```

==== 构建和运行

```bash
# 构建JAR
mvn package

# 构建原生镜像
mvn -Pnative native:compile

# 运行原生镜像
./target/graalvm-demo

# 测试
curl http://localhost:8080/hello
```

=== 常见陷阱与解决

==== 陷阱1：反射问题

*问题*：JSON序列化/反序列化失败

*解决*：

```java
// 使用Jackson，Spring会自动配置
@RestController
public class UserController {

    @PostMapping("/users")
    public User createUser(@RequestBody User user) {
        return user;
    }
}

// Jackson会自动处理反射配置
public class User {
    private String name;
    private int age;

    // 必须有getter/setter或public字段
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }
}
```

==== 陷阱2：资源文件缺失

*问题*：找不到配置文件或静态资源

*解决*：

```properties
# application.properties
# Spring Boot会自动包含以下资源
spring.mvc.static-path-pattern=/static/**
spring.web.resources.static-locations=classpath:/static/
```

*陷阱3：第三方库兼容性*

*问题*：某些库不支持Native Image

*解决*：

```xml
<!-- 检查库是否有GraalVM支持 -->
<dependency>
    <groupId>com.example</groupId>
    <artifactId>some-library</artifactId>
    <version>1.0.0</version>
    <!-- 寻找有native-image配置的版本 -->
</dependency>
```

#tip[
  在选择第三方库时，优先选择已经提供GraalVM支持的库。可以查看库的文档或GitHub仓库是否有 `META-INF/native-image` 目录。
]

==== 陷阱4：启动参数

*问题*：运行时传递的参数不生效

*解决*：

```bash
# Native Image支持大部分JVM参数
./myapp -Xmx64m -Dspring.profiles.active=prod

# 但某些参数需要在构建时指定
native-image -jar app.jar -H:+ReportExceptionStackTraces
```

== 多语言编程

GraalVM的Polyglot API允许在Java中调用其他语言代码。

=== 支持的語言

- JavaScript (Node.js兼容)
- Python
- Ruby
- R
- LLVM（C/C++等）
- WebAssembly

=== Java调用JavaScript

```java
import org.graalvm.polyglot.*;

public class PolyglotExample {
    public static void main(String[] args) {
        try (Context context = Context.create()) {
            // 执行JavaScript代码
            Value result = context.eval("js", "1 + 2");
            System.out.println(result.asInt()); // 输出: 3

            // 调用JavaScript函数
            context.eval("js", "function add(a, b) { return a + b; }");
            Value addFunction = context.getBindings("js").getMember("add");
            int sum = addFunction.execute(10, 20).asInt();
            System.out.println(sum); // 输出: 30

            // 访问JavaScript对象
            context.eval("js", "var person = {name: 'Alice', age: 30};");
            Value person = context.getBindings("js").getMember("person");
            System.out.println(person.getMember("name").asString()); // Alice
        }
    }
}
```

=== Java调用Python

```java
import org.graalvm.polyglot.*;

public class PythonExample {
    public static void main(String[] args) {
        try (Context context = Context.newBuilder()
                .allowAllAccess(true)
                .build()) {

            // 执行Python代码
            context.eval("python", "print('Hello from Python!')");

            // 调用Python函数
            context.eval("python", """
                def fibonacci(n):
                    if n <= 1:
                        return n
                    return fibonacci(n-1) + fibonacci(n-2)
                """);

            Value fibFunc = context.getBindings("python").getMember("fibonacci");
            int result = fibFunc.execute(10).asInt();
            System.out.println("Fibonacci(10) = " + result); // 55
        }
    }
}
```

=== 数据共享

不同语言之间可以共享数据：

```java
import org.graalvm.polyglot.*;

public class DataSharing {
    public static void main(String[] args) {
        try (Context context = Context.create()) {
            // 创建Java对象
            java.util.Map<String, Object> map = new java.util.HashMap<>();
            map.put("name", "Alice");
            map.put("age", 30);

            // 传递给JavaScript
            context.getBindings("js").putMember("data", map);

            // 在JavaScript中访问
            Value result = context.eval("js", "data.name + ' is ' + data.age + ' years old'");
            System.out.println(result.asString()); // Alice is 30 years old
        }
    }
}
```

#note[
  多语言编程适合混合语言架构的场景，如使用Python进行数据分析，使用Java处理业务逻辑。但在生产环境中需要谨慎评估性能和复杂度。
]

== 性能调优

=== 构建优化

==== 减少镜像大小

```bash
# 移除未使用的代码
native-image -jar app.jar --no-fallback

# 压缩镜像
native-image -jar app.jar -Ob

# 启用优化
native-image -jar app.jar -O2
```

==== 并行编译

```bash
# 使用多个线程编译
native-image -jar app.jar -J-Xmx4g -J-XX:ParallelGCThreads=4
```

=== 运行时优化

==== 内存管理

```bash
# 设置最大堆大小
./myapp -Xmx128m

# 使用G1 GC（如果支持）
./myapp -XX:+UseG1GC
```

==== 线程优化

```bash
# 设置线程栈大小
./myapp -Xss256k

# 限制线程数
./myapp -Djava.util.concurrent.ForkJoinPool.common.parallelism=4
```

=== 监控与调试

==== 启用追踪

```bash
# 报告异常堆栈
native-image -jar app.jar -H:+ReportExceptionStackTraces

# 生成构建报告
native-image -jar app.jar -H:GenerateDebugInfo=1
```

==== 性能分析

```bash
# 使用perf分析（Linux）
perf record ./myapp
perf report

# 使用async-profiler
./profiler.sh start <pid>
./profiler.sh stop <pid>
```

#tip[
  使用 `-H:+PrintAnalysisCallTree` 可以在构建时查看调用树，帮助识别性能瓶颈。
]

== 实际应用场景

=== Serverless函数

GraalVM原生镜像非常适合Serverless场景：

*优势*：

- 冷启动时间短（毫秒级）
- 内存占用低（降低成本）
- 按需扩展

*示例*：AWS Lambda + GraalVM

```java
public class LambdaHandler implements RequestHandler<Map<String, Object>, String> {

    @Override
    public String handleRequest(Map<String, Object> input, Context context) {
        return "Hello from GraalVM Lambda!";
    }
}
```

*效果*：

- 冷启动：从几秒降低到几百毫秒
- 成本：降低50-70%

=== 微服务

在微服务架构中，GraalVM可以显著提升整体性能：

*优势*：

- 快速启动（适合频繁重启）
- 低内存占用（更多实例）
- 快速扩缩容

*示例*：Kubernetes部署

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: graalvm-service
spec:
  replicas: 10
  template:
    spec:
      containers:
      - name: app
        image: myapp:latest
        resources:
          requests:
            memory: "32Mi"  # 只需32MB
            cpu: "100m"
          limits:
            memory: "64Mi"
            cpu: "200m"
```

*效果*：

- 相同硬件可运行更多实例
- 自动扩缩容响应更快

=== CLI工具

GraalVM非常适合构建命令行工具：

*优势*：

- 单文件分发
- 无需安装JVM
- 启动速度快

*示例*：

```java
@Command(name = "mytool", description = "My CLI Tool")
public class MyTool implements Callable<Integer> {

    @Option(names = {"-n", "--name"}, description = "Your name")
    String name;

    @Override
    public Integer call() throws Exception {
        System.out.println("Hello, " + name + "!");
        return 0;
    }

    public static void main(String[] args) {
        int exitCode = new CommandLine(new MyTool()).execute(args);
        System.exit(exitCode);
    }
}
```

```bash
# 构建
native-image -jar mytool.jar

# 分发单个文件
./mytool --name Alice
```

=== 边缘计算

在资源受限的边缘设备上：

*优势*：

- 小内存占用
- 快速启动
- 无需JVM环境

*应用场景*：

- IoT设备
- 嵌入式系统
- 移动边缘计算

#note[
  GraalVM在边缘计算场景中可以显著降低硬件要求，使得在低端设备上运行Java应用成为可能。
]

== 局限性与注意事项

=== 主要限制

==== 反射限制

- 需要在构建时配置
- 动态类加载不支持
- 增加了配置复杂度

==== 动态特性限制

- 不支持 `Class.forName()` 动态加载
- JNI需要特殊配置
- 动态代理需要配置

==== 构建时间长

```text
传统JAR构建: 10-30秒
Native Image构建: 2-10分钟
```

*影响*：CI/CD流水线变慢

==== 平台相关性

- 需要为目标平台构建
- 跨平台编译复杂
- 需要安装对应平台的工具链

=== 不适合的场景

#tex-table(
  ("场景", "原因", "建议"),
  ("长时间运行服务", "JIT优化更好", "使用传统JVM"),
  ("高度动态的应用", "反射配置复杂", "评估成本"),
  ("快速迭代的开发", "构建时间长", "开发时用JVM"),
  ("需要热部署", "不支持", "使用传统JVM"),
)

=== 最佳实践

==== 开发阶段

- 使用传统JVM进行开发和测试
- 定期构建Native Image验证兼容性
- 使用Spring Boot DevTools加速开发

==== 测试阶段

- 编写集成测试验证Native Image
- 测试所有反射和资源访问路径
- 性能基准测试

==== 生产阶段

- 监控内存和CPU使用
- 准备回滚方案
- 逐步灰度发布

#tip[
  推荐策略：开发和测试使用传统JVM，生产环境根据实际需求选择JVM或Native Image。
]

== 生态系统与支持

=== 框架支持

==== Spring生态

- Spring Boot 3.0+：原生支持
- Spring Framework 6.0+：AOT处理
- Spring Cloud：部分支持

==== Micronaut

- 天生为Native Image设计
- 编译时依赖注入
- 优秀的GraalVM支持

==== Quarkus

- "Supersonic Subatomic Java"
- 专为Kubernetes和GraalVM优化
- 最快的启动速度

#tex-table(
  ("框架", "启动速度", "内存占用", "学习曲线", "生态"),
  ("Spring Boot", "快", "低", "低", "丰富"),
  ("Micronaut", "很快", "很低", "中", "良好"),
  ("Quarkus", "最快", "最低", "中", "增长中"),
)

=== 云服务支持

- AWS Lambda：支持Custom Runtime
- Google Cloud Run：完美支持
- Azure Functions：支持
- Alibaba Cloud FC：支持

=== 社区资源

- 官方文档：https://www.graalvm.org/
- GitHub：https://github.com/oracle/graal
- Spring Boot指南：https://spring.io/guides/topicals/spring-boot-graalvm
- Awesome GraalVM：https://github.com/akullpp/awesome-graalvm

#fancy-divider

本章完aalVM
