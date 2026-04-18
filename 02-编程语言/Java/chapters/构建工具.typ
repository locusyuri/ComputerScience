#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= 构建工具概述

#note[
  构建工具是现代 Java/Kotlin 项目的基础设施，负责依赖管理、编译、测试、打包和部署等自动化任务。
]

== 为什么需要构建工具

在大型项目中，手动管理依赖和构建流程会变得极其复杂且容易出错。

=== 依赖管理的痛点

*没有构建工具时*：

- 手动下载 JAR 包
- 处理传递性依赖（A依赖B，B依赖C）
- 解决版本冲突
- 管理不同环境的依赖

*示例*：一个 Spring Boot 项目可能需要 50+ 个依赖包

```text
手动管理：
├─ spring-boot-starter-web.jar
├─ spring-core.jar
├─ spring-context.jar
├─ jackson-databind.jar
├─ tomcat-embed-core.jar
└─ ... (还有40+个)
```

=== 构建自动化的优势

*传统方式*：

```bash
# 手动编译
javac -cp "lib/*" src/*.java

# 手动打包
jar cvf app.jar -C bin .

# 手动运行
java -cp "app.jar:lib/*" com.example.Main
```

*使用构建工具*：

```bash
# Maven
mvn clean package

# Gradle
gradle build
```

=== 项目标准化

构建工具提供了*统一的项目结构*：

```
maven-project/
├── pom.xml              # 项目配置
├── src/
│   ├── main/
│   │   ├── java/        # 源代码
│   │   └── resources/   # 资源文件
│   └── test/
│       ├── java/        # 测试代码
│       └── resources/   # 测试资源
└── target/              # 构建输出
```

#tip[
  标准化的项目结构使得团队成员可以快速理解项目，IDE 也能提供更好的支持。
]

== Maven vs Gradle

Maven 和 Gradle 是 JVM 生态中最主流的两个构建工具。

=== 设计理念对比

#tex-table(
  ("特性", "Maven", "Gradle"),
  ("配置语言", "XML", "Groovy/Kotlin DSL"),
  ("约定优于配置", "强", "灵活"),
  ("学习曲线", "平缓", "陡峭"),
  ("构建速度", "较慢", "较快"),
  ("灵活性", "较低", "高"),
  ("社区成熟度", "非常成熟", "成熟"),
)

=== Maven 的优势与劣势

*优势*：

- *简单易学*：XML 配置直观，约定明确
- *生态成熟*：几乎所有 Java 库都提供 Maven 坐标
- *稳定性好*：经过多年验证，企业级应用广泛
- *IDE 支持完善*：IntelliJ IDEA、Eclipse 原生支持

*劣势*：

- *配置冗长*：XML  verbose，重复配置多
- *灵活性差*：自定义构建逻辑困难
- *构建速度慢*：不支持增量构建

*示例*：Maven 依赖声明

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <version>3.2.0</version>
</dependency>
```

=== Gradle 的优势与劣势

*优势*：

- *构建速度快*：增量构建、构建缓存、守护进程
- *灵活性高*：可以用代码编写构建逻辑
- *Kotlin DSL*：类型安全、IDE 智能提示
- *现代化*：Android 官方构建工具，Spring Boot 推荐

*劣势*：

- *学习曲线陡*：需要理解 Groovy/Kotlin 和 Gradle API
- *配置复杂*：过度灵活可能导致配置混乱
- *调试困难*：构建脚本错误信息不够友好

*示例*：Gradle 依赖声明（Kotlin DSL）

```kotlin
dependencies {
    implementation("org.springframework.boot:spring-boot-starter-web:3.2.0")
}
```

=== 选型建议

*选择 Maven*：

- 传统企业项目
- 团队对 Maven 熟悉
- 项目结构简单
- 追求稳定性和可维护性

*选择 Gradle*：

- Android 项目（官方推荐）
- 大型多模块项目
- 需要自定义构建逻辑
- 追求构建性能

#note[
  Spring Boot 3.x 同时支持 Maven 和 Gradle，但官方文档中 Gradle 示例越来越多。
]

== 构建生命周期

构建生命周期是一系列有序的阶段，每个阶段完成特定的任务。

=== Maven 构建生命周期

Maven 有三个内置的生命周期：

==== clean 生命周期

清理项目，删除构建输出。

```
clean
└─ clean: 删除 target/ 目录
```

==== default 生命周期

核心构建流程，包含以下主要阶段：

```
validate         → 验证项目配置
download-sources → 下载源码
compile          → 编译源代码
test             → 运行单元测试
package          → 打包（JAR/WAR）
verify           → 验证包的有效性
install          → 安装到本地仓库
deploy           → 部署到远程仓库
```

*常用命令*：

```bash
mvn clean compile    # 清理并编译
mvn clean package    # 清理并打包
mvn clean install    # 清理、打包并安装到本地仓库
mvn deploy           # 部署到远程仓库
```

==== site 生命周期

生成项目站点文档。

```
site
└─ site: 生成项目文档网站
```

=== Gradle 构建生命周期

Gradle 的生命周期分为三个阶段：

==== 1. Initialization（初始化）

确定哪些项目参与构建，创建 Project 对象。

==== 2. Configuration（配置）

执行构建脚本，配置 Task 和依赖关系。

==== 3. Execution（执行）

根据依赖关系执行 Task。

*常用 Task*：

```bash
gradle tasks         # 列出所有可用 Task
gradle build         # 完整构建（编译 + 测试 + 打包）
gradle clean         # 清理构建输出
gradle test          # 运行测试
gradle jar           # 打包为 JAR
```

=== 构建流程对比

*Maven*：

```
mvn clean package

[INFO] --- maven-clean-plugin:3.2.0:clean ---
[INFO] Deleting target/
[INFO] --- maven-resources-plugin:3.3.0:resources ---
[INFO] Copying resources
[INFO] --- maven-compiler-plugin:3.11.0:compile ---
[INFO] Compiling source files
[INFO] --- maven-surefire-plugin:3.1.2:test ---
[INFO] Running tests
[INFO] --- maven-jar-plugin:3.3.0:jar ---
[INFO] Building jar: target/app.jar
```

*Gradle*：

```
gradle build

> Task :compileJava
> Task :processResources
> Task :classes
> Task :jar
> Task :assemble
> Task :compileTestJava
> Task :processTestResources
> Task :testClasses
> Task :test
> Task :check
> Task :build

BUILD SUCCESSFUL in 2s
```

#fancy-divider

本章介绍了构建工具的基本概念、Maven 与 Gradle 的对比以及构建生命周期。理解这些基础概念是深入学习具体构建工具的前提。
= Maven 核心概念

#note[
  Maven 是 Apache 基金会的项目，采用“约定优于配置”的理念，通过 POM 文件管理项目。
]

== POM 文件结构

POM（Project Object Model）是 Maven 项目的核心配置文件。

=== 基本结构

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <!-- 项目坐标 -->
    <groupId>com.example</groupId>
    <artifactId>my-app</artifactId>
    <version>1.0.0</version>
    <packaging>jar</packaging>

    <!-- 项目信息 -->
    <name>My Application</name>
    <description>A sample Maven project</description>

    <!-- 依赖 -->
    <dependencies>
        <!-- 依赖声明 -->
    </dependencies>

    <!-- 构建配置 -->
    <build>
        <plugins>
            <!-- 插件配置 -->
        </plugins>
    </build>
</project>
```

=== 项目坐标（GAV）

每个 Maven 项目由三个坐标唯一标识：

*groupId*：组织标识，通常是公司域名的反写

```xml
<groupId>com.example</groupId>
<groupId>org.springframework.boot</groupId>
```

*artifactId*：项目名称

```xml
<artifactId>my-app</artifactId>
<artifactId>spring-boot-starter-web</artifactId>
```

*version*：版本号

```xml
<version>1.0.0</version>
<version>3.2.0-SNAPSHOT</version>  <!-- 快照版本 -->
```

*完整坐标示例*：

```text
com.example:my-app:1.0.0
org.springframework.boot:spring-boot-starter-web:3.2.0
```

=== 继承与聚合

==== 继承（Inheritance）

子项目可以继承父项目的配置。

*父 POM*：

```xml
<!-- parent/pom.xml -->
<project>
    <groupId>com.example</groupId>
    <artifactId>parent-project</artifactId>
    <version>1.0.0</version>
    <packaging>pom</packaging>

    <properties>
        <java.version>17</java.version>
        <spring-boot.version>3.2.0</spring-boot.version>
    </properties>

    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-dependencies</artifactId>
                <version>${spring-boot.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>
</project>
```

*子 POM*：

```xml
<!-- child/pom.xml -->
<project>
    <parent>
        <groupId>com.example</groupId>
        <artifactId>parent-project</artifactId>
        <version>1.0.0</version>
    </parent>

    <artifactId>child-module</artifactId>

    <!-- 继承父项目的依赖管理，无需指定版本 -->
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
            <!-- 版本从父项目继承 -->
        </dependency>
    </dependencies>
</project>
```

==== 聚合（Aggregation）

父项目可以聚合多个子模块，一次性构建所有模块。

```xml
<!-- aggregator/pom.xml -->
<project>
    <groupId>com.example</groupId>
    <artifactId>aggregator</artifactId>
    <version>1.0.0</version>
    <packaging>pom</packaging>

    <modules>
        <module>module-a</module>
        <module>module-b</module>
        <module>module-c</module>
    </modules>
</project>
```

#tip[
  继承用于共享配置，聚合用于统一构建。一个 POM 可以同时是父项目和聚合项目。
]

== 依赖管理

Maven 的依赖管理是其最核心的功能之一。

=== 依赖声明

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
        <version>3.2.0</version>
        <scope>compile</scope>  <!-- 可选，默认为 compile -->
        <optional>false</optional>  <!-- 可选，默认 false -->
        <exclusions>  <!-- 排除传递性依赖 -->
            <exclusion>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-tomcat</artifactId>
            </exclusion>
        </exclusions>
    </dependency>
</dependencies>
```

=== 依赖范围（Scope）

#tex-table(
  ("Scope", "编译", "测试", "运行", "打包", "说明"),
  ("compile", "✓", "✓", "✓", "✓", "默认，全程可用"),
  ("provided", "✓", "✓", "✗", "✗", "容器提供，如 Servlet API"),
  ("runtime", "✗", "✓", "✓", "✓", "运行时才需要，如 JDBC 驱动"),
  ("test", "✗", "✓", "✗", "✗", "仅测试时使用，如 JUnit"),
  ("system", "✓", "✓", "✗", "✗", "本地系统路径，不推荐"),
)

*示例*：

```xml
<!-- Servlet API：由 Tomcat 提供 -->
<dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>javax.servlet-api</artifactId>
    <version>4.0.1</version>
    <scope>provided</scope>
</dependency>

<!-- MySQL 驱动：运行时才需要 -->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.33</version>
    <scope>runtime</scope>
</dependency>

<!-- JUnit：仅测试使用 -->
<dependency>
    <groupId>junit</groupId>
    <artifactId>junit</artifactId>
    <version>4.13.2</version>
    <scope>test</scope>
</dependency>
```

=== 传递性依赖

Maven 会自动解析并下载依赖的依赖。

*示例*：

```text
A 依赖 B
B 依赖 C

则 A 自动依赖 C（传递性依赖）
```

*依赖树查看*：

```bash
mvn dependency:tree

[INFO] com.example:my-app:jar:1.0.0
[INFO] +- org.springframework.boot:spring-boot-starter-web:jar:3.2.0:compile
[INFO] |  +- org.springframework.boot:spring-boot-starter:jar:3.2.0:compile
[INFO] |  |  +- org.springframework.boot:spring-boot:jar:3.2.0:compile
[INFO] |  |  +- org.springframework.boot:spring-boot-autoconfigure:jar:3.2.0:compile
[INFO] |  |  +- org.springframework.boot:spring-boot-starter-logging:jar:3.2.0:compile
[INFO] |  |  |  +- ch.qos.logback:logback-classic:jar:1.4.11:compile
[INFO] |  |  |  +- org.slf4j:slf4j-api:jar:2.0.9:compile
[INFO] |  +- org.springframework.boot:spring-boot-starter-json:jar:3.2.0:compile
[INFO] |  +- org.springframework.boot:spring-boot-starter-tomcat:jar:3.2.0:compile
```

=== 依赖冲突解决

当不同依赖引入同一库的不同版本时，Maven 使用以下策略解决冲突：

==== 最短路径优先

```text
A -> B -> C(1.0)
A -> D(2.0)

选择 D(2.0)，因为路径更短
```

==== 声明顺序优先

如果路径长度相同，先声明的优先。

```xml
<dependencies>
    <!-- 先声明，优先 -->
    <dependency>
        <groupId>com.example</groupId>
        <artifactId>lib</artifactId>
        <version>1.0</version>
    </dependency>

    <!-- 后声明，被忽略 -->
    <dependency>
        <groupId>com.example</groupId>
        <artifactId>lib</artifactId>
        <version>2.0</version>
    </dependency>
</dependencies>
```

==== 手动解决冲突

*方法1：排除传递性依赖*

```xml
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
```

*方法2：在 dependencyManagement 中统一管理版本*

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>com.example</groupId>
            <artifactId>lib</artifactId>
            <version>2.0</version>  <!-- 强制使用 2.0 -->
        </dependency>
    </dependencies>
</dependencyManagement>
```

#caution[
  依赖冲突是 Maven 最常见的问题，建议使用 `mvn dependency:tree` 定期检柨依赖树。
]

== 仓库管理

Maven 通过仓库管理依赖的存储和获取。

=== 仓库类型

==== 本地仓库（Local Repository）

存储在本地文件系统，默认位置：

- Windows: `C:\Users\用户名\.m2\repository`
- Linux/Mac: `~/.m2/repository`

*修改本地仓库位置*：

```xml
<!-- ~/.m2/settings.xml -->
<settings>
    <localRepository>/path/to/custom/repository</localRepository>
</settings>
```

==== 中央仓库（Central Repository）

Maven 官方维护的公共仓库，地址：

```
https://repo.maven.apache.org/maven2/
```

*搜索依赖*：

```
https://search.maven.org/
```

==== 私有仓库（Private Repository）

企业内部搭建的仓库，常用工具：

- *Nexus*：Sonatype 开发，最流行
- *Artifactory*：JFrog 开发，功能强大
- *Archiva*：Apache 项目

*配置私有仓库*：

```xml
<!-- pom.xml -->
<repositories>
    <repository>
        <id>nexus</id>
        <name>Nexus Repository</name>
        <url>http://nexus.example.com/repository/maven-public/</url>
        <releases>
            <enabled>true</enabled>
        </releases>
        <snapshots>
            <enabled>true</enabled>
        </snapshots>
    </repository>
</repositories>
```

=== 镜像配置

使用国内镜像加速下载。

*阿里云镜像*：

```xml
<!-- ~/.m2/settings.xml -->
<settings>
    <mirrors>
        <mirror>
            <id>aliyun</id>
            <mirrorOf>central</mirrorOf>
            <name>Aliyun Maven Mirror</name>
            <url>https://maven.aliyun.com/repository/public</url>
        </mirror>
    </mirrors>
</settings>
```

#tip[
  国内开发强烈建议配置阿里云镜像，可以大幅提升依赖下载速度。
]

== 常用插件

Maven 通过插件扩展功能，以下是常用插件。

=== compiler 插件

配置 Java 编译版本。

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-compiler-plugin</artifactId>
            <version>3.11.0</version>
            <configuration>
                <source>17</source>
                <target>17</target>
                <encoding>UTF-8</encoding>
            </configuration>
        </plugin>
    </plugins>
</build>
```

=== surefire 插件

运行单元测试。

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-surefire-plugin</artifactId>
    <version>3.1.2</version>
    <configuration>
        <includes>
            <include>**/*Test.java</include>
        </includes>
        <skipTests>false</skipTests>  <!-- 跳过测试 -->
    </configuration>
</plugin>
```

=== jar 插件

打包为 JAR 文件。

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-jar-plugin</artifactId>
    <version>3.3.0</version>
    <configuration>
        <archive>
            <manifest>
                <mainClass>com.example.Main</mainClass>  <!-- 主类 -->
            </manifest>
        </archive>
    </configuration>
</plugin>
```

=== shade 插件

创建可执行 JAR（Fat JAR），包含所有依赖。

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-shade-plugin</artifactId>
    <version>3.5.1</version>
    <executions>
        <execution>
            <phase>package</phase>
            <goals>
                <goal>shade</goal>
            </goals>
            <configuration>
                <transformers>
                    <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                        <mainClass>com.example.Main</mainClass>
                    </transformer>
                </transformers>
            </configuration>
        </execution>
    </executions>
</plugin>
```

*运行*：

```bash
mvn clean package
java -jar target/my-app-1.0.0.jar
```

=== assembly 插件

自定义打包格式（ZIP、TAR.GZ 等）。

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-assembly-plugin</artifactId>
    <version>3.6.0</version>
    <configuration>
        <descriptors>
            <descriptor>src/assembly/dist.xml</descriptor>
        </descriptors>
    </configuration>
    <executions>
        <execution>
            <id>make-assembly</id>
            <phase>package</phase>
            <goals>
                <goal>single</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```

#fancy-divider

本章详细介绍了 Maven 的核心概念，包括 POM 文件结构、依赖管理、仓库管理和常用插件。掌握这些内容是有效使用 Maven 的基础。
= Gradle 核心概念

#note[
  Gradle 是一个基于 JVM 的现代化构建工具，结合了 Maven 和 Ant 的优点，以灵活性和高性能著称。
]

== build.gradle 配置

Gradle 使用 DSL（领域特定语言）来配置项目，支持 Groovy 和 Kotlin 两种语法。

=== Groovy DSL vs Kotlin DSL

==== Groovy DSL（传统方式）

*优点*：

- 语法简洁，动态类型
- 社区资源丰富
- 学习成本低

*缺点*：

- 缺少编译时检查
- IDE 智能提示较弱
- 运行时才能发现错误

*示例*：

```groovy
// build.gradle (Groovy)
plugins {
    id 'java'
    id 'application'
}

group = 'com.example'
version = '1.0.0'

repositories {
    mavenCentral()
}

dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-web:3.2.0'
    testImplementation 'org.springframework.boot:spring-boot-starter-test:3.2.0'
}

application {
    mainClass = 'com.example.Main'
}
```

==== Kotlin DSL（推荐方式）

*优点*：

- 类型安全，编译时检查
- IDE 智能提示完善
- 重构友好
- 与 Kotlin 项目无缝集成

*缺点*：

- 语法稍显冗长
- 学习曲线略陡

*示例*：

```kotlin
// build.gradle.kts (Kotlin)
plugins {
    java
    application
}

group = "com.example"
version = "1.0.0"

repositories {
    mavenCentral()
}

dependencies {
    implementation("org.springframework.boot:spring-boot-starter-web:3.2.0")
    testImplementation("org.springframework.boot:spring-boot-starter-test:3.2.0")
}

application {
    mainClass.set("com.example.Main")
}
```

#tip[
  新项目推荐使用 Kotlin DSL，特别是 Kotlin 项目。Groovy DSL 适合维护旧项目。
]

=== 项目结构

Gradle 项目的标准结构：

```
gradle-project/
├── build.gradle.kts      # 构建脚本（Kotlin DSL）
├── settings.gradle.kts   # 设置脚本
├── gradle/
│   └── wrapper/
│       ├── gradle-wrapper.jar
│       └── gradle-wrapper.properties
├── gradlew               # Unix 包装器脚本
├── gradlew.bat           # Windows 包装器脚本
├── src/
│   ├── main/
│   │   ├── kotlin/       # 或 java/
│   │   └── resources/
│   └── test/
│       ├── kotlin/       # 或 java/
│       └── resources/
└── build/                # 构建输出
```

=== settings.gradle.kts

配置项目元信息和多模块结构。

```kotlin
// settings.gradle.kts
rootProject.name = "my-project"

// 多模块配置
include("module-a")
include("module-b")
include("module-c")
```

=== gradle-wrapper.properties

配置 Gradle 版本和分发方式。

```properties
# gradle/wrapper/gradle-wrapper.properties
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-8.5-bin.zip
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
```

#note[
  Gradle Wrapper 确保所有开发者使用相同版本的 Gradle，避免版本不一致导致的问题。
]

== 依赖声明

Gradle 的依赖管理比 Maven 更灵活，提供了多种依赖配置。

=== 依赖配置（Configuration）

#tex-table(
  ("配置", "编译", "测试", "运行", "打包", "说明"),
  ("implementation", "✓", "✓", "✓", "✓", "推荐使用，隐藏实现细节"),
  ("api", "✓", "✓", "✓", "✓", "暴露给使用者，类似 compile"),
  ("compileOnly", "✓", "✗", "✗", "✗", "仅编译时需要"),
  ("runtimeOnly", "✗", "✓", "✓", "✓", "仅运行时需要"),
  ("testImplementation", "✗", "✓", "✗", "✗", "测试依赖"),
  ("testCompileOnly", "✗", "✓", "✗", "✗", "仅测试编译需要"),
  ("testRuntimeOnly", "✗", "✓", "✓", "✗", "仅测试运行需要"),
)

=== 依赖声明语法

==== 字符串 notation

```kotlin
dependencies {
    // group:module:version
    implementation("org.springframework.boot:spring-boot-starter-web:3.2.0")

    // 简写（需要配置 dependencyManagement）
    implementation("org.springframework.boot:spring-boot-starter-web")
}
```

==== Map notation

```kotlin
dependencies {
    implementation(mapOf(
        "group" to "org.springframework.boot",
        "name" to "spring-boot-starter-web",
        "version" to "3.2.0"
    ))
}
```

==== 依赖项目

```kotlin
dependencies {
    implementation(project(":module-a"))
    implementation(project(path = ":module-b", configuration = "apiElements"))
}
```

==== 文件依赖

```kotlin
dependencies {
    implementation(files("libs/my-lib.jar"))
    implementation(fileTree("libs") { include("*.jar") })
}
```

=== 依赖排除

```kotlin
dependencies {
    implementation("org.springframework.boot:spring-boot-starter-web:3.2.0") {
        exclude(group = "org.springframework.boot", module = "spring-boot-starter-tomcat")
    }
}
```

=== BOM 依赖管理

使用 Spring Boot BOM 统一管理版本。

```kotlin
// build.gradle.kts
plugins {
    java
}

dependencyManagement {
    imports {
        mavenBom("org.springframework.boot:spring-boot-dependencies:3.2.0")
    }
}

dependencies {
    // 无需指定版本，从 BOM 继承
    implementation("org.springframework.boot:spring-boot-starter-web")
    implementation("org.springframework.boot:spring-boot-starter-data-jpa")
}
```

或使用 Kotlin DSL 原生支持：

```kotlin
// build.gradle.kts
plugins {
    java
    id("org.springframework.boot") version "3.2.0"
    id("io.spring.dependency-management") version "1.1.4"
}

dependencies {
    implementation("org.springframework.boot:spring-boot-starter-web")
    // 版本由 Spring Boot Plugin 管理
}
```

=== 查看依赖树

```bash
# 查看依赖树
gradle dependencies

# 查看特定配置的依赖
gradle dependencies --configuration runtimeClasspath

# 查看依赖冲突
gradle dependencyInsight --dependency slf4j
```

*输出示例*：

```
runtimeClasspath - Runtime classpath of source set 'main'.
+--- org.springframework.boot:spring-boot-starter-web:3.2.0
|    +--- org.springframework.boot:spring-boot-starter:3.2.0
|    |    +--- org.springframework.boot:spring-boot:3.2.0
|    |    +--- org.springframework.boot:spring-boot-autoconfigure:3.2.0
|    |    +--- org.springframework.boot:spring-boot-starter-logging:3.2.0
|    |    |    +--- ch.qos.logback:logback-classic:1.4.11
|    |    |    \--- org.slf4j:slf4j-api:2.0.9
```

== Task 系统

Task 是 Gradle 的基本执行单元，每个 Task 代表一个原子操作。

=== 内置 Task

Gradle Java 插件提供的常用 Task：

#tex-table(
  ("Task", "说明", "依赖"),
  ("compileJava", "编译 Java 源代码", "-"),
  ("processResources", "处理资源文件", "-"),
  ("classes", "生成类文件", "compileJava, processResources"),
  ("jar", "打包为 JAR", "classes"),
  ("assemble", "组装输出", "jar"),
  ("compileTestJava", "编译测试代码", "classes"),
  ("processTestResources", "处理测试资源", "-"),
  ("testClasses", "生成测试类", "compileTestJava, processTestResources"),
  ("test", "运行测试", "testClasses"),
  ("check", "执行检查", "test"),
  ("build", "完整构建", "check, assemble"),
  ("clean", "清理构建输出", "-"),
)

*执行 Task*：

```bash
gradle build          # 完整构建
gradle clean build    # 清理后构建
gradle test           # 仅运行测试
gradle jar            # 仅打包
```

=== 自定义 Task

==== 简单 Task

```kotlin
// build.gradle.kts
tasks.register("hello") {
    doLast {
        println("Hello, Gradle!")
    }
}
```

*执行*：

```bash
gradle hello

> Task :hello
Hello, Gradle!
```

==== 带参数的 Task

```kotlin
tasks.register("greet") {
    val name = project.findProperty("name") ?: "World"
    doLast {
        println("Hello, $name!")
    }
}
```

*执行*：

```bash
gradle greet -Pname=Gradle

> Task :greet
Hello, Gradle!
```

==== 依赖其他 Task

```kotlin
tasks.register("customBuild") {
    dependsOn("clean", "build")
    doLast {
        println("Custom build completed!")
    }
}
```

=== Task 生命周期

Gradle Task 有三个阶段：

==== 1. Configuration Phase（配置阶段）

执行 Task 配置代码。

```kotlin
println("This runs during configuration")  // 每次都会执行

tasks.register("myTask") {
    println("This also runs during configuration")

    doLast {
        println("This runs during execution")  // 仅在 Task 执行时运行
    }
}
```

==== 2. Execution Phase（执行阶段）

执行 Task 的 `doFirst` 和 `doLast` 动作。

```kotlin
tasks.register("lifecycle") {
    doFirst {
        println("Step 1: Before")
    }

    doLast {
        println("Step 3: After")
    }
}
```

==== 3. Finalization Phase（结束阶段）

执行 `finalizedBy` 指定的 Task。

```kotlin
tasks.register("cleanup") {
    doLast {
        println("Cleanup")
    }
}

tasks.named("build") {
    finalizedBy("cleanup")
}
```

=== 增量构建

Gradle 支持增量构建，只重新执行发生变化的 Task。

==== 输入和输出

```kotlin
tasks.register("generateDocs") {
    val inputDir = file("src/docs")
    val outputDir = file("build/docs")

    inputs.dir(inputDir)   // 声明输入
    outputs.dir(outputDir) // 声明输出

    doLast {
        // 只有输入变化时才执行
        copy {
            from(inputDir)
            into(outputDir)
        }
    }
}
```

*效果*：

```bash
# 第一次执行
gradle generateDocs
> Task :generateDocs

# 第二次执行（无变化）
gradle generateDocs
> Task :generateDocs UP-TO-DATE  ← 跳过执行
```

==== 构建缓存

启用构建缓存可以跨构建复用输出。

```properties
# gradle.properties
org.gradle.caching=true
```

```kotlin
// settings.gradle.kts
buildCache {
    local {
        isEnabled = true
    }
    remote(HttpBuildCache::class) {
        url = uri("http://cache-server:8080/cache/")
        isPush = false
    }
}
```

=== 并行构建

加速多模块项目的构建。

```properties
# gradle.properties
org.gradle.parallel=true
org.gradle.workers.max=4  # 最大工作线程数
```

== 插件系统

Gradle 通过插件扩展功能，插件可以分为两类。

=== 应用插件

==== 核心插件

```kotlin
plugins {
    java                    // Java 支持
    application             // 应用程序打包
    `java-library`          // Java 库
    war                     // WAR 打包
}
```

==== 社区插件

```kotlin
plugins {
    id("org.springframework.boot") version "3.2.0"
    id("io.spring.dependency-management") version "1.1.4"
    id("com.github.johnrengelman.shadow") version "8.1.1"
}
```

==== 旧式应用方式（不推荐）

```kotlin
// buildscript 块
buildscript {
    repositories {
        mavenCentral()
    }
    dependencies {
        classpath("org.springframework.boot:spring-boot-gradle-plugin:3.2.0")
    }
}

apply(plugin = "org.springframework.boot")
```

=== 常用插件

==== Spring Boot Plugin

```kotlin
plugins {
    id("org.springframework.boot") version "3.2.0"
    id("io.spring.dependency-management") version "1.1.4"
}

dependencies {
    implementation("org.springframework.boot:spring-boot-starter-web")
}

// 自动创建可执行 JAR
// 运行: gradle bootRun
```

==== Shadow Plugin（Fat JAR）

```kotlin
plugins {
    id("com.github.johnrengelman.shadow") version "8.1.1"
}

// 创建包含所有依赖的 JAR
// 运行: gradle shadowJar
// 输出: build/libs/myapp-all.jar
```

==== Kotlin Plugin

```kotlin
plugins {
    kotlin("jvm") version "1.9.20"
}

dependencies {
    implementation(kotlin("stdlib"))
}
```

=== 自定义插件

==== 脚本插件

```kotlin
// custom-plugin.gradle.kts
plugins.withType<JavaPlugin> {
    tasks.test {
        useJUnitPlatform()
    }
}
```

*应用*：

```kotlin
apply(from = "custom-plugin.gradle.kts")
```

==== Binary 插件

```kotlin
// buildSrc/src/main/kotlin/MyPlugin.kt
import org.gradle.api.Plugin
import org.gradle.api.Project

class MyPlugin : Plugin<Project> {
    override fun apply(project: Project) {
        project.plugins.apply("java")

        project.tasks.register("myTask") {
            doLast {
                println("My custom task")
            }
        }
    }
}
```

*应用*：

```kotlin
plugins {
    id("my-plugin")
}
```

=== 插件市场

Gradle 插件门户：

```
https://plugins.gradle.org/
```

*搜索插件*：

```bash
# 在网站上搜索，或直接查看热门插件
```

*常用插件*：

#tex-table(
  ("插件", "用途", "ID"),
  ("Spring Boot", "Spring Boot 支持", "org.springframework.boot"),
  ("Shadow", "Fat JAR 打包", "com.github.johnrengelman.shadow"),
  ("Kotlin", "Kotlin 支持", "org.jetbrains.kotlin.jvm"),
  ("Docker", "Docker 镜像构建", "com.bmuschko.docker-java-application"),
  ("SonarQube", "代码质量分析", "org.sonarqube"),
)

#fancy-divider

本章详细介绍了 Gradle 的核心概念，包括配置语法、依赖管理、Task 系统和插件机制。Gradle 的灵活性使其成为现代 JVM 项目的首选构建工具。
= 多模块项目管理

#note[
  多模块项目将大型应用拆分为多个独立的模块，每个模块负责特定的功能，便于管理和维护。
]

== Maven 多模块

Maven 通过 parent POM 和 module 元素实现多模块管理。

=== 项目结构

```
multi-module-project/
├── pom.xml                    # 父 POM（聚合 + 继承）
├── module-common/             # 公共模块
│   └── pom.xml
├── module-service/            # 服务模块
│   └── pom.xml
├── module-web/                # Web 模块
│   └── pom.xml
└── module-api/                # API 模块
    └── pom.xml
```

=== Parent POM

父 POM 负责聚合子模块和共享配置。

```xml
<!-- pom.xml (Parent) -->
<project>
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>multi-module-project</artifactId>
    <version>1.0.0</version>
    <packaging>pom</packaging>  <!-- 必须是 pom -->

    <!-- 聚合子模块 -->
    <modules>
        <module>module-common</module>
        <module>module-api</module>
        <module>module-service</module>
        <module>module-web</module>
    </modules>

    <!-- 属性定义 -->
    <properties>
        <java.version>17</java.version>
        <spring-boot.version>3.2.0</spring-boot.version>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>

    <!-- 依赖管理（子模块继承，无需指定版本） -->
    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-dependencies</artifactId>
                <version>${spring-boot.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>

    <!-- 插件管理 -->
    <build>
        <pluginManagement>
            <plugins>
                <plugin>
                    <groupId>org.apache.maven.plugins</groupId>
                    <artifactId>maven-compiler-plugin</artifactId>
                    <version>3.11.0</version>
                    <configuration>
                        <source>${java.version}</source>
                        <target>${java.version}</target>
                    </configuration>
                </plugin>
            </plugins>
        </pluginManagement>
    </build>
</project>
```

=== 子模块 POM

子模块继承父 POM 的配置。

```xml
<!-- module-common/pom.xml -->
<project>
    <parent>
        <groupId>com.example</groupId>
        <artifactId>multi-module-project</artifactId>
        <version>1.0.0</version>
    </parent>

    <artifactId>module-common</artifactId>
    <packaging>jar</packaging>

    <dependencies>
        <!-- 无需指定版本，从父 POM 继承 -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter</artifactId>
        </dependency>
    </dependencies>
</project>
```

```xml
<!-- module-service/pom.xml -->
<project>
    <parent>
        <groupId>com.example</groupId>
        <artifactId>multi-module-project</artifactId>
        <version>1.0.0</version>
    </parent>

    <artifactId>module-service</artifactId>

    <dependencies>
        <!-- 依赖其他模块 -->
        <dependency>
            <groupId>com.example</groupId>
            <artifactId>module-common</artifactId>
            <version>${project.version}</version>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>
    </dependencies>
</project>
```

```xml
<!-- module-web/pom.xml -->
<project>
    <parent>
        <groupId>com.example</groupId>
        <artifactId>multi-module-project</artifactId>
        <version>1.0.0</version>
    </parent>

    <artifactId>module-web</artifactId>
    <packaging>jar</packaging>

    <dependencies>
        <dependency>
            <groupId>com.example</groupId>
            <artifactId>module-service</artifactId>
            <version>${project.version}</version>
        </dependency>

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
        </plugins>
    </build>
</project>
```

=== 模块依赖关系

```
module-web
    └─ module-service
         └─ module-common

module-api
    └─ module-common
```

*依赖原则*：

- 避免循环依赖
- 依赖方向：上层 → 下层
- 公共代码放在底层模块

=== 聚合构建

在父项目目录执行构建命令，会自动构建所有子模块。

```bash
# 构建所有模块
mvn clean install

# 仅构建特定模块
mvn clean install -pl module-web -am
# -pl: 指定模块
# -am: 同时构建依赖的模块

# 跳过测试
mvn clean install -DskipTests

# 并行构建（加速）
mvn clean install -T 4
# -T 4: 使用4个线程
```

#tip[
  使用 `-pl` 和 `-am` 参数可以只构建修改的模块及其依赖，大幅提升构建速度。
]

== Gradle 多模块

Gradle 的多模块管理更加灵活，通过 `settings.gradle.kts` 和子项目配置实现。

=== 项目结构

```
multi-module-project/
├── settings.gradle.kts        # 设置脚本
├── build.gradle.kts           # 根项目构建脚本
├── gradle.properties          # Gradle 属性
├── module-common/             # 公共模块
│   └── build.gradle.kts
├── module-service/            # 服务模块
│   └── build.gradle.kts
├── module-web/                # Web 模块
│   └── build.gradle.kts
└── module-api/                # API 模块
    └── build.gradle.kts
```

=== settings.gradle.kts

配置包含的子项目。

```kotlin
// settings.gradle.kts
rootProject.name = "multi-module-project"

include("module-common")
include("module-api")
include("module-service")
include("module-web")

// 自定义模块路径（可选）
// include(":module-common")
// project(":module-common").projectDir = file("libs/common")
```

=== 根项目 build.gradle.kts

配置所有子项目的通用设置。

```kotlin
// build.gradle.kts (Root)
plugins {
    java
    id("org.springframework.boot") version "3.2.0" apply false
    id("io.spring.dependency-management") version "1.1.4" apply false
}

allprojects {
    group = "com.example"
    version = "1.0.0"

    repositories {
        mavenCentral()
    }
}

subprojects {
    apply(plugin = "java")
    apply(plugin = "io.spring.dependency-management")

    dependencies {
        // 所有子项目都需要的依赖
        implementation(platform("org.springframework.boot:spring-boot-dependencies:3.2.0"))
    }

    tasks.withType<JavaCompile> {
        sourceCompatibility = "17"
        targetCompatibility = "17"
    }
}
```

=== 子项目 build.gradle.kts

```kotlin
// module-common/build.gradle.kts
plugins {
    java
}

dependencies {
    implementation("org.springframework.boot:spring-boot-starter")
}
```

```kotlin
// module-service/build.gradle.kts
plugins {
    java
}

dependencies {
    implementation(project(":module-common"))
    implementation("org.springframework.boot:spring-boot-starter-data-jpa")
}
```

```kotlin
// module-web/build.gradle.kts
plugins {
    id("org.springframework.boot")
}

dependencies {
    implementation(project(":module-service"))
    implementation("org.springframework.boot:spring-boot-starter-web")
}
```

=== 依赖传递

Gradle 自动处理模块间的依赖传递。

```
module-web 依赖 module-service
module-service 依赖 module-common

则 module-web 自动可以访问 module-common 的 public API
```

*控制依赖可见性*：

```kotlin
// module-service/build.gradle.kts
dependencies {
    // api: 暴露给使用者（传递性）
    api(project(":module-common"))

    // implementation: 不暴露（非传递性）
    implementation("com.h2database:h2")
}
```

```kotlin
// module-web/build.gradle.kts
dependencies {
    implementation(project(":module-service"))

    // 可以访问 module-common（因为 service 用 api 声明）
    // 不能访问 h2（因为 service 用 implementation 声明）
}
```

=== 构建命令

```bash
# 构建所有模块
gradle build

# 构建特定模块
gradle :module-web:build

# 构建模块及其依赖
gradle :module-web:build --include-build :module-service

# 查看模块依赖
gradle :module-web:dependencies

# 并行构建
gradle build --parallel

# 持续构建（开发模式）
gradle build --continuous
```

== 版本统一管理

在多模块项目中，统一版本管理至关重要。

=== Maven 版本管理

==== 属性管理

```xml
<!-- parent/pom.xml -->
<properties>
    <spring-boot.version>3.2.0</spring-boot.version>
    <lombok.version>1.18.30</lombok.version>
    <junit.version>5.10.1</junit.version>
</properties>

<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>${lombok.version}</version>
        </dependency>
    </dependencies>
</dependencyManagement>
```

==== BOM（Bill of Materials）

BOM 是一组协调版本的依赖集合。

```xml
<!-- 导入 Spring Boot BOM -->
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-dependencies</artifactId>
            <version>3.2.0</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>

<!-- 子模块使用，无需指定版本 -->
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
        <!-- 版本从 BOM 继承 -->
    </dependency>
</dependencies>
```

==== Versions Plugin（推荐）

使用 `versions-maven-plugin` 检查和更新依赖版本。

```xml
<plugin>
    <groupId>org.codehaus.mojo</groupId>
    <artifactId>versions-maven-plugin</artifactId>
    <version>2.16.2</version>
</plugin>
```

*使用*：

```bash
# 检查可用更新
mvn versions:display-dependency-updates

# 检查插件更新
mvn versions:display-plugin-updates

# 更新版本
mvn versions:set -DnewVersion=1.1.0
```

=== Gradle 版本管理

==== Platform（类似 BOM）

```kotlin
// build.gradle.kts (Root)
subprojects {
    dependencies {
        // 导入 Spring Boot BOM
        implementation(platform("org.springframework.boot:spring-boot-dependencies:3.2.0"))
    }
}
```

==== Version Catalogs（推荐）

Gradle 8.x 推荐的版本管理方式。

*定义版本目录*：

```toml
# gradle/libs.versions.toml
[versions]
spring-boot = "3.2.0"
lombok = "1.18.30"
junit = "5.10.1"

[libraries]
spring-boot-starter-web = { module = "org.springframework.boot:spring-boot-starter-web", version.ref = "spring-boot" }
spring-boot-starter-data-jpa = { module = "org.springframework.boot:spring-boot-starter-data-jpa", version.ref = "spring-boot" }
lombok = { module = "org.projectlombok:lombok", version.ref = "lombok" }
junit-jupiter = { module = "org.junit.jupiter:junit-jupiter", version.ref = "junit" }

[bundles]
spring-web = ["spring-boot-starter-web"]
testing = ["junit-jupiter"]

[plugins]
spring-boot = { id = "org.springframework.boot", version.ref = "spring-boot" }
```

*使用版本目录*：

```kotlin
// build.gradle.kts
dependencies {
    implementation(libs.spring.boot.starter.web)
    implementation(libs.spring.boot.starter.data.jpa)
    compileOnly(libs.lombok)
    annotationProcessor(libs.lombok)
    testImplementation(libs.bundles.testing)
}

plugins {
    alias(libs.plugins.spring.boot)
}
```

*优势*：

- 集中管理所有版本
- IDE 智能提示
- 类型安全
- 易于维护

==== Dependency Management Plugin

Spring 提供的插件，兼容 Maven 的 dependencyManagement。

```kotlin
// build.gradle.kts
plugins {
    id("io.spring.dependency-management") version "1.1.4"
}

dependencyManagement {
    imports {
        mavenBom("org.springframework.boot:spring-boot-dependencies:3.2.0")
    }
}

dependencies {
    // 无需指定版本
    implementation("org.springframework.boot:spring-boot-starter-web")
}
```

=== 版本管理最佳实践

#tex-table(
  ("实践", "说明", "工具"),
  ("使用 BOM/Platform", "统一管理框架版本", "Spring Boot BOM"),
  ("集中定义版本", "避免硬编码版本号", "Properties / Version Catalogs"),
  ("定期更新依赖", "保持依赖最新", "versions plugin / Renovate"),
  ("锁定版本", "生产环境使用固定版本", "明确版本号，不用 LATEST"),
  ("语义化版本", "遵循 SemVer 规范", "MAJOR.MINOR.PATCH"),
)

#caution[
  避免使用 `LATEST`、`RELEASE` 等动态版本，会导致构建不可重现。
]

#fancy-divider

本章介绍了 Maven 和 Gradle 的多模块项目管理，以及版本统一管理的最佳实践。合理的模块划分和版本管理是大型项目成功的关键。
= 构建优化与最佳实践
