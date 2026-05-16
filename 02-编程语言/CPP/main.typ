#import "../../99-索引与模板/TypstTemplate/computer-notes.typ": *


// ── 文档元信息 ──
#set document(
  title: "C & C++",
  author: "Violet",
  date: datetime.today(),
)

// 应用全局样式
#show: apply-style

// ══════════════════════════════════════════════════════════════════════
// 封面
// ══════════════════════════════════════════════════════════════════════

#make-cover(
  "C & C++",
  "Violet",
  date: datetime.today().display(),
)

// 目录
#make-outline(depth: 2)


// ─────────────────────────────────────────────────────────────────────
// Part 1：C 语言基础
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：语言概述与环境 ✅
// 1.1 C/C++ 的历史与定位：系统级编程、高性能计算、中级语言特性
// 1.2 标准发展：C89、C99、C11、C++98/03/11/14/17/20
// 1.3 编译器：GCC、Clang、MSVC、Intel C++、MinGW
// 1.4 程序结构：头文件、命名空间、主函数、注释
// 1.5 编译流程：预处理、编译、汇编、链接

// Chapter 2：数据类型与变量 🔶
// 2.1 基本数据类型：整型、浮点型、字符型、布尔型
// 2.2 修饰符：signed、unsigned、short、long、long long
// 2.3 常量：字面常量、符号常量（#define、const）
// 2.4 变量：定义、初始化、作用域（局部/全局/块/类作用域）
// 2.5 存储类型：auto、register、static、extern、mutable、thread_local

// Chapter 3：运算符与表达式 🔶
// 3.1 算术运算符：+、-、*、/、%、++、--
// 3.2 关系与逻辑运算符：==、!=、<、>、&&、||、!
// 3.3 位运算符：&、|、^、~、<<、>>
// 3.4 赋值运算符与复合赋值
// 3.5 其他运算符：sizeof、三目运算符、逗号运算符、成员访问运算符
// 3.6 运算符优先级与结合性

// Chapter 4：控制流 🔶
// 4.1 条件语句：if、if-else、嵌套 if、switch-case
// 4.2 循环语句：while、for、do-while
// 4.3 跳转语句：break、continue、goto、return
// 4.4 类型转换：隐式转换、显式转换（强制转换、to_string、sto*）


// ─────────────────────────────────────────────────────────────────────
// Part 2：C 语言进阶
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：数组与指针 🔶
// 1.1 数组：定义、初始化、多维数组、数组名本质
// 1.2 指针基础：声明、取地址（&）、解引用（*）、指针运算
// 1.3 指针与数组：数组名作为指针、指针算术、下标访问
// 1.4 指针与字符串：字符数组、字符串字面值
// 1.5 指针数组与数组指针：int* arr[] vs int (*p)[n]

// Chapter 2：结构体与联合体 🔶
// 2.1 结构体：定义、初始化、成员访问、内存对齐
// 2.2 结构体与函数：值传递、指针传递
// 2.3 结构体与 typedef：简化类型定义
// 2.4 联合体：定义、用途、内存布局
// 2.5 枚举类型：enum、枚举值、枚举与switch

// Chapter 3：函数深化 🔶
// 3.1 函数基础：声明、定义、调用、参数传递
// 3.2 函数参数：值传递、地址传递、数组作为参数
// 3.3 函数返回：返回值、返回指针、返回引用
// 3.4 函数递归：递归调用、递归终止条件
// 3.5 函数指针：声明、使用、回调函数
// 3.6 内联函数：inline、编译展开、注意事项

// Chapter 4：内存管理与预处理器 ⚪
// 4.1 内存布局：栈、堆、数据段、代码段
// 4.2 动态内存：malloc、free、calloc、realloc
// 4.3 内存错误：野指针、内存泄漏、双重释放
// 4.4 预处理指令：#define、#include、#if、#ifdef
// 4.5 宏定义：对象宏、函数宏、条件编译

// ─────────────────────────────────────────────────────────────────────
// Part 3：C++ 核心特性
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：C++ 对 C 的扩展 🔶
// 1.1 输入输出流：cin、cout、cerr、clog、iomanip
// 1.2 命名空间：namespace、using、std
// 1.3 引用：引用 vs 指针、引用的应用场景
// 1.4 类型推导：auto、decltype（C++11）
// 1.5 范围 for 循环（C++11）
// 1.6 nullptr（C++11）

// Chapter 2：面向对象编程 🔶
// 2.1 类与对象：封装、访问控制（public/private/protected）
// 2.2 构造函数：默认构造、参数构造、初始化列表、拷贝构造
// 2.3 析构函数：资源释放、RAII 原则
// 2.4 拷贝赋值运算符与移动语义
// 2.5 继承：公有/私有/保护继承、菱形继承、虚继承
// 2.6 多态：虚函数、纯虚函数、抽象类、虚表

// Chapter 3：模板与泛型编程 🔶
// 3.1 函数模板：模板函数、类型参数、模板特化
// 3.2 类模板：模板类、默认模板参数
// 3.3 模板参数：非类型参数、模板模板参数
// 3.4 模板元编程：编译期计算、递归模板
// 3.5 类型萃取：type_traits（C++11）
// 3.6 概念与约束：Concepts（C++20）

// Chapter 4：Lambda 与函数对象 ⚪
// 4.1 Lambda 表达式：捕捉列表、参数列表、返回类型、函数体
// 4.2 捕捉方式：值捕捉、引用捕捉、混合捕捉、初始化捕捉
// 4.3 mutable 修饰符与 Lambda 的常量性
// 4.4 函数对象（Functor）：仿函数、STL 中的应用
// 4.5 std::function 与 std::bind


// ─────────────────────────────────────────────────────────────────────
// Part 4：C++ 标准库
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：STL 容器 🔶
// 1.1 顺序容器：vector、deque、list、array、forward_list
// 1.2 关联容器：set、multiset、map、multimap
// 1.3 无序容器：unordered_map、unordered_set（C++11）
// 1.4 容器适配器：stack、queue、priority_queue
// 1.5 容器迭代器：Iterator、ConstIterator、reverse_iterator

// Chapter 2：STL 算法 ⚪
// 2.1 算法分类：非修改式算法、修改式算法、排序算法
// 2.2 查找与遍历：find、count、for_each、transform
// 2.3 排序与搜索：sort、stable_sort、binary_search
// 2.4 数值算法：accumulate、inner_product
// 2.5 范围接口（C++20）：ranges

// Chapter 3：智能指针与内存管理 🔶
// 3.1 智能指针概述：RAII 原则
// 3.2 unique_ptr：独占所有权、移动语义
// 3.3 shared_ptr：共享所有权、引用计数、循环引用
// 3.4 weak_ptr：打破循环引用、lock()
// 3.5 定制删除器与作用域

// Chapter 4：常用库组件 ⚪
// 4.1 字符串：std::string、字符串视图（C++17）
// 4.2 正则表达式：regex、匹配、替换
// 4.3 时间与日期：chrono 库（C++11）
// 4.4 异常处理：try-catch、异常规格、std::exception
// 4.5 元组与可选值：tuple、optional（C++17）、variant（C++17）


// ─────────────────────────────────────────────────────────────────────
// Part 5：C++ 高级特性
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：现代 C++ 新特性 🔶
// 1.1 C++11/14 新特性：移动语义、右值引用、完美转发
// 1.2 C++17 新特性：结构化绑定、if constexpr、折叠表达式
// 1.3 C++20 新特性：概念（Concepts）、协程（Coroutines）、模块（Modules）
// 1.4 constexpr：constexpr 函数、constexpr 变量、constexpr if
// 1.5 lambda 表达式演进：C++14泛型lambda、C++17 constexpr lambda

// Chapter 2：并发与多线程 🔶
// 2.1 线程管理：std::thread、线程 join/detach
// 2.2 线程同步：互斥锁（mutex）、读写锁（shared_mutex）
// 2.3 条件变量：condition_variable、wait、notify
// 2.4 原子操作：atomic、内存序（memory_order）
// 2.5 异步编程：std::async、future、promise
// 2.6 并发容器：ConcurrentQueue、ConcurrentVector

// Chapter 3：模板元编程深度 ⚪
// 3.1 SFINAE：替换失败不是错误
// 3.2 类型特征库：std::is_same、std::is_base_of
// 3.3 模板模板参数：模板作为参数
// 3.4 变量模板：C++14
// 3.5 模板字面值：C++14

// Chapter 4：编译与链接 ⚪
// 4.1 符号表与链接：静态链接、动态链接
// 4.2 名字修饰（Name Mangling）与函数重载
// 4.3 DLL 与共享库：导出符号、隐式/显式加载
// 4.4 内联与链接：ODR（单一定义规则）


// ─────────────────────────────────────────────────────────────────────
// Part 6：性能优化与工程实践
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：性能分析与优化 🔶
// 1.1 性能分析工具：gprof、perf、VTune
// 1.2 编译器优化：-O2、-O3、LTO（链接时间优化）
// 1.3 缓存优化：局部性原理、预取、内存对齐
// 1.4 SIMD 指令：SSE、AVX、NEON、自动向量化
// 1.5 移动语义优化：避免不必要的拷贝

// Chapter 2：设计模式 ⚪
// 2.1 创建型模式：单例、工厂、建造者、原型
// 2.2 结构型模式：适配器、桥接、装饰器、外观
// 2.3 行为型模式：观察者、策略、命令、状态
// 2.4 C++ 惯用法：RAII、Pimpl、Proxy、Decorator

// Chapter 3：代码规范与测试 ⚪
// 3.1 编码规范：Google C++ 风格指南、命名约定
// 3.2 异常安全：强异常安全保证、noexcept
// 3.3 单元测试：Google Test、Catch2
// 3.4 静态分析：clang-tidy、cppcheck
// 3.5 代码审查与重构

// Chapter 4：构建与工程化 ⚪
// 4.1 CMake 基础：CMakeLists.txt、target、property
// 4.2 CMake 高级：生成器表达式、模块、FindXXX
// 4.3 跨平台开发：Windows、Linux、macOS
// 4.4 包管理：Conan、vcpkg
// 4.5 CI/CD：GitHub Actions、GitLab CI


// ─────────────────────────────────────────────────────────────────────
// Part 7：应用方向与实战
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：系统级编程 ⚪
// 1.1 POSIX 编程：文件操作（open/read/write）、进程管理（fork/exec）
// 1.2 信号处理：signal、sigaction、实时信号
// 1.3 进程间通信：管道、共享内存、消息队列、套接字
// 1.4 线程编程：POSIX threads、线程池
// 1.5 网络编程：TCP/UDP 服务器、客户端模型

// Chapter 2：高性能计算 ⚪
// 2.1 数值计算库：Eigen、Armadillo、BLAS/LAPACK
// 2.2 并行计算：OpenMP、MPI、CUDA、OpenCL
// 2.3 内存池与对象池：定制分配器
// 2.4 零拷贝技术：mmap、DMA
// 2.5 高性能数据结构：无锁队列、Bloom Filter

// Chapter 3：游戏与图形 ⚪
// 3.1 游戏引擎架构：渲染、物理、音频、脚本
// 3.2 图形 API：DirectX、OpenGL、Vulkan
// 3.3 资源管理：纹理、模型、音频
// 3.4 脚本绑定：Lua、Python
// 3.5 寻路算法：A*、NavMesh

// Chapter 4：工具与框架 ⚪
// 4.1 序列化：Protocol Buffers、FlatBuffers、JSON
// 4.2 日志库：spdlog、glog
// 4.3 网络框架：libevent、Boost.Asio
// 4.4 RPC 框架：gRPC、Thrift
// 4.5 领域特定库：正则表达式、XML 解析、数据库访问
