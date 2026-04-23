#import "../../99-索引与模板/TypstTemplate/computer-notes.typ": *


// ── 文档元信息 ──
#set document(
  title: "Java",
  author: "Violet",
  date: datetime.today(),
)

// 应用全局样式
#show: apply-style


// ══════════════════════════════════════════════════════════════════════
// 封面
// ══════════════════════════════════════════════════════════════════════

#make-cover(
  "Java",
  "Violet",
  date: datetime.today().display(),
)

// 目录
#make-outline(depth: 2)


#part("Java & Kotlin 核心基础")
#include "chapters/基础.typ"

#part("JVM 标准库与常用工具")
#include "chapters/标准库.typ"

#part("构建工具与工程化")
#include "chapters/构建工具.typ"

#part("高级特性与函数式编程")

#part("并发编程")
#include "chapters/并发编程.typ"

#part("网络编程与高性能 IO")

#part("JVM 底层原理与性能调优")
#include "chapters/GraalVM.typ"


// % Part 1：Java & Kotlin 核心基础（语法 + 面向对象）
// % Chapter 1：Java & Kotlin 入门与环境搭建 ✅
// % 1.1 语言概述：Java 与 Kotlin 的关系、JVM 跨平台原理、无缝互操作优势1.2 开发环境搭建：JDK 安装配置、IDEA 中 Java+Kotlin 环境配置1.3 编译运行流程：Java 源码→字节码、Kotlin 源码→JVM 字节码的完整流程1.4 第一个程序：Hello World 的 Java 实现、Kotlin 实现、两者互调用演示
// % Chapter 2：基础语法 ✅
// % 2.1 标识符、注释与编码规范（Java+Kotlin 对照）2.2 变量与数据类型：Java 变量 / 基本类型 → Kotlin val/var、类型推断、基本类型兼容2.3 空安全体系（Kotlin 核心特性）：可空类型、安全调用符、非空断言、Elvis 表达式2.4 运算符与类型转换（Java+Kotlin 对照）2.5 流程控制：Java 分支 / 循环 → Kotlin if 表达式、when 表达式、循环简化写法
// % Chapter 3：数组与基础数据结构 ✅
// % 3.1 Java 数组：声明、初始化、遍历、Arrays 工具类3.2 Kotlin 数组：数组实现、与 Java 数组的互操作、原生类型数组优化3.3 集合基础：Java 集合初识 → Kotlin 只读 / 可变集合、集合快速创建
// % Chapter 4：函数（方法）与代码复用 ✅
// % 4.1 Java 方法：定义、调用、值传递、重载、递归、可变参数4.2 Kotlin 函数：函数定义、默认参数、命名参数、顶级函数、局部函数4.3 代码块与执行顺序：Java 静态 / 构造代码块 → Kotlin init 初始化块4.4 函数设计基础规范
// % Chapter 5：面向对象编程（OOP）核心 🔶
// % 5.1 类与对象：Java 类 / 封装 / 构造器 /this → Kotlin 类、主 / 次构造器、this 关键字5.2 静态特性：Java static 成员 → Kotlin object 单例、伴生对象、静态注解兼容5.3 继承与多态：Java extends/super/ 重写 / 向上转型 → Kotlin open 关键字、继承、多态实现5.4 抽象类与接口：Java abstract / 接口默认方法 → Kotlin 抽象类、接口、函数式接口兼容5.5 Kotlin 专属 OOP 特性：数据类、密封类、枚举类、内联类5.6 内部类、包机制与访问控制（Java+Kotlin 对照）5.7 Object 类与 Any 类：Java Object 核心方法 → Kotlin Any 类、两者兼容关系
// % Chapter 6：基础综合实战 ✅
// % 6.1 学生信息管理：Java 实现、Kotlin 实现6.2 Java 与 Kotlin 混合调用小案例

// % Part 2：JVM 标准库与常用工具（Java & Kotlin）
// % Chapter 1：字符串处理 🔶
// % 1.1 Java 字符串：String 不可变性、常量池、StringBuilder/StringBuffer、正则表达式1.2 Kotlin 字符串扩展：字符串模板、常用扩展函数、正则简化操作1.3 两者字符串互操作与最佳实践
// % Chapter 2：集合框架 🔶
// % 2.1 Java 集合体系：Collection/List/Set/Map、迭代器、Collections 工具类、底层扩容机制2.2 Kotlin 集合扩展：集合操作符（过滤 / 映射 / 分组）、只读集合实现、与 Java 集合的互操作2.3 集合面试核心与易错点
// % Chapter 3：异常处理 🔶
// % 3.1 Java 异常体系：Throwable 结构、try-catch-finally、try-with-resources、自定义异常3.2 Kotlin 异常处理：受检异常取消、use 自动资源管理函数、自定义异常3.3 异常处理最佳实践与互操作注意事项
// % Chapter 4：IO 与 NIO 基础 🔶
// % 4.1 Java IO 体系：字节流 / 字符流、缓冲流 / 转换流 / 对象流、NIO 核心（Channel/Buffer）4.2 Kotlin IO 扩展：文件读写简化、IO 扩展函数、use 资源管理4.3 Files/Path 文件操作新类（Java+Kotlin 对照）4.4 IO 实战：通用文件读写工具封装
// % Chapter 5：日期时间 API 🔶
// % 5.1 旧版 Date/Calendar 缺陷与基础用法5.2 Java java.time 包：核心类、格式化、时间计算、时区处理5.3 Kotlin 日期时间扩展函数与简化用法5.4 两者互操作兼容
// % Chapter 6：通用工具类 ✅
// % 6.1 Java 基础工具：Math、BigDecimal、Objects、Optional 空值处理6.2 Kotlin 标准库工具：作用域函数（let/run/with/apply/also）、空安全处理工具6.3 第三方常用库（Java+Kotlin 通用）：Apache Commons、Guava、Hutool ⚪

// % Part 3：构建工具与工程化（Maven & Gradle）
// % Chapter 1：构建工具概述
// % 1.1 为什么需要构建工具：依赖管理、构建自动化、项目标准化
// % 1.2 Maven vs Gradle：设计理念、优缺点对比、选型建议
// % 1.3 构建生命周期：编译、测试、打包、部署的完整流程
// % Chapter 2：Maven 核心概念
// % 2.1 POM 文件结构：坐标、依赖、插件、继承与聚合
// % 2.2 依赖管理：传递性依赖、依赖冲突解决、依赖范围
// % 2.3 仓库管理：本地仓库、中央仓库、私有仓库（Nexus/Artifactory）
// % 2.4 常用插件：compiler、surefire、jar、shade、assembly
// % Chapter 3：Gradle 核心概念
// % 3.1 build.gradle 配置：Groovy DSL vs Kotlin DSL
// % 3.2 依赖声明：implementation/api/testImplementation、依赖配置
// % 3.3 Task 系统：自定义 Task、Task 依赖、增量构建
// % 3.4 插件系统：应用插件、自定义插件、插件市场
// % Chapter 4：多模块项目管理
// % 4.1 Maven 多模块：parent POM、模块依赖、聚合构建
// % 4.2 Gradle 多模块：settings.gradle、子项目配置、依赖传递
// % 4.3 版本统一管理：BOM、platform、dependencyManagement
// % Chapter 5：构建优化与最佳实践
// % 5.1 构建性能优化：并行构建、缓存机制、守护进程
// % 5.2 持续集成：与 Jenkins/GitLab CI 集成、自动化构建流程
// % 5.3 常见问题分析：依赖冲突、构建失败排查、内存溢出

// % Part 4：高级特性与函数式编程
// % Chapter 1：泛型 🔶
// % 1.1 Java 泛型：泛型类 / 接口 / 方法、通配符上下界、类型擦除1.2 Kotlin 泛型：声明处型变、星投影、泛型约束、与 Java 泛型的互操作1.3 泛型常见问题与最佳实践
// % Chapter 2：注解 🔶
// % 2.1 Java 注解：内置注解、元注解、自定义注解、注解解析2.2 Kotlin 注解：注解定义、JVM 兼容性注解（@JvmStatic/@JvmOverloads 等）、注解解析2.3 注解实战：自定义注解 + 反射实现简易框架
// % Chapter 3：反射机制 🔶
// % 3.1 Java 反射：Class 对象、属性 / 方法 / 构造器操作、动态代理3.2 Kotlin 反射：KClass、Kotlin 反射 API、与 Java 反射的互操作3.3 反射应用场景、优缺点与性能优化
// % Chapter 4：Java 模块化（Java 9+）⚪
// % 4.1 模块化概述、module-info 定义、模块导出与依赖
// % Chapter 5：函数式编程范式 🔶
// % 5.1 函数式接口：Java 内置核心函数式接口 → Kotlin 函数式接口兼容5.2 Lambda 表达式：Java Lambda 语法 → Kotlin Lambda、高阶函数、内联函数5.3 方法引用与构造器引用（Java+Kotlin 对照）
// % Chapter 6：流式数据处理 🔶
// % 6.1 Java Stream API：创建、中间操作、终端操作、Collectors 收集器、并行流6.2 Kotlin 序列 Sequence：与 Stream 的区别、惰性求值、集合流式操作6.3 两者性能对比与适用场景
// % Chapter 7：Kotlin 专属高级特性 🔶
// % 7.1 扩展函数与扩展属性7.2 委托：类委托、属性委托、懒加载 lazy7.3 运算符重载、infix 函数7.4 高级特性实战：用 Kotlin 扩展简化 Java 工具类

// % Part 5：并发编程（Java 线程 & Kotlin 协程）
// % 设计原则：
// % 1) 先“线程与共享内存模型”再“工具与实战”；
// % 2) 先 Java 并发基石，再 Kotlin 协程抽象；
// % 3) 与 Part 6（JMM）避免重复：Part 4 讲“怎么用”，Part 6 讲“为什么”。
// % Chapter 1：并发基础与问题模型 🔶
// % 1.1 进程与线程、并发 vs 并行、上下文切换成本
// % 1.2 Java 线程生命周期、创建方式、守护线程、线程中断语义
// % 1.3 并发核心问题：原子性 / 可见性 / 有序性（应用层视角，JMM 深入放 Part 6）
// % Chapter 2：线程安全与同步机制（Java 为主）🔶
// % 2.1 synchronized、Lock、volatile、happens-before 实战理解
// % 2.2 CAS 与原子类（Atomic*）、ABA 问题与常见对策
// % 2.3 线程安全集合与并发容器选型（ConcurrentHashMap、CopyOnWrite 系列）
// % Chapter 3：并发协作与线程池 🔶
// % 3.1 线程通信：wait/notify、Condition、生产者消费者模型
// % 3.2 线程池：核心参数、队列策略、拒绝策略、任务监控
// % 3.3 JUC 工具：CountDownLatch、Semaphore、BlockingQueue、CompletableFuture
// % Chapter 4：Kotlin 协程基础 🔶
// % 4.1 协程模型：与线程区别、优势、结构化并发
// % 4.2 挂起函数、协程作用域、launch/async、取消与超时
// % 4.3 协程上下文与调度器（Dispatcher）
// % Chapter 5：协程进阶与异步流 🔶
// % 5.1 协程并发安全：Mutex、并发限制、共享状态治理
// % 5.2 Channel、Flow、背压与取消传播
// % 5.3 协程与 Java 异步工具互操作（CompletableFuture、线程池）
// % Chapter 6：并发诊断与综合实战 🔶
// % 6.1 Java 线程池方案 vs Kotlin 协程方案：同题对照
// % 6.2 并发问题排查：死锁、竞态、活锁、线程泄漏
// % 6.3 监控与调优：线程 dump、阻塞分析、吞吐与延迟权衡

// % Part 6：网络编程与高性能 IO
// % Chapter 1：网络编程基础 ✅
// % 1.1 网络核心概念：IP / 端口 / TCP/UDP 协议、OSI 七层模型1.2 InetAddress 网络地址操作（Java+Kotlin 通用）
// % Chapter 2：BIO 编程 🔶
// % 2.1 TCP BIO 通信：Java Socket/ServerSocket 实现、多线程 BIO2.2 Kotlin BIO 简化实现2.3 UDP 编程基础、BIO 性能瓶颈分析
// % Chapter 3：NIO 编程 🔶
// % 3.1 NIO 三大核心：Channel/Buffer/Selector3.2 非阻塞 NIO 通信实现（Java+Kotlin 对照）3.3 NIO 与 BIO 的对比、适用场景
// % Chapter 4：AIO 与零拷贝 ⚪
// % 4.1 AIO 异步 IO 概述、实现示例4.2 零拷贝原理、mmap/sendfile 机制、JVM 上的实现
// % Chapter 5：高性能网络框架 ⚪
// % 5.1 Netty 框架入门：核心优势、架构、简易 TCP 通信实现5.2 Ktor 框架入门：Kotlin 原生高性能网络框架、服务端 / 客户端实现

// % Part 7：JVM 底层原理与性能调优（Java & Kotlin 通用）
// % 核心内容完全复用 JVM 体系，仅补充 Kotlin 特性的底层实现，无需修改原有核心逻辑
// % Chapter 1：JVM 整体架构 🔶
// % 1.1 HotSpot JVM 核心组成：类加载子系统、运行时数据区、执行引擎1.2 Java & Kotlin 程序执行全流程：源码→字节码→JVM 执行1.3 主流 JVM 实现：HotSpot、OpenJ9
// % Chapter 2：类加载机制 🔶
// % 2.1 类加载生命周期：加载 / 验证 / 准备 / 解析 / 初始化2.2 类加载器分类、双亲委派模型原理与破坏场景2.3 Kotlin 类的加载：顶级函数、扩展函数的字节码实现与类加载逻辑
// % Chapter 3：运行时数据区 🔶
// % 3.1 程序计数器、虚拟机栈、本地方法栈3.2 堆内存：分代模型、内存配置、OOM 场景分析3.3 方法区 / 元空间、直接内存3.4 Kotlin 特性的内存布局：内联函数、Lambda、挂起函数的内存实现
// % Chapter 4：执行引擎 🔶
// % 4.1 字节码基础、Java 与 Kotlin 字节码对比4.2 解释器与 JIT 即时编译器：热点代码、分层编译4.3 JNI 本地方法接口
// % Chapter 5：垃圾回收（GC）🔶
// % 5.1 垃圾判定：可达性分析、GC Roots、引用类型5.2 垃圾回收算法：标记 - 清除 / 复制 / 标记 - 整理 / 分代收集5.3 主流垃圾收集器：Serial/ParNew/CMS/G1/ZGC5.4 GC 日志解读、常用 GC 参数
// % Chapter 6：JVM 内存模型（JMM）🔶
// % 6.1 JMM 核心规范：可见性 / 原子性 / 有序性6.2 指令重排、内存屏障6.3 volatile、锁的内存语义、锁优化机制6.4 Kotlin 并发特性的 JMM 实现
// % Chapter 7：JVM 监控与调优 🔶
// % 7.1 JVM 常用监控工具：jps/jstat/jmap/jstack/VisualVM7.2 OOM、CPU 占用过高问题排查实战7.3 JVM 核心参数配置、调优原则与实战案例7.4 Kotlin 代码的 JVM 调优注意事项
// % Chapter 8：JDK & Kotlin 版本演进 ⚪
// % 8.1 JDK LTS 版本核心特性（8/11/17）、版本迁移注意事项8.2 Kotlin 版本演进、与 JDK 版本的兼容性、新特性

