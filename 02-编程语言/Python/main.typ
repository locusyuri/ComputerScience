#import "../../99-索引与模板/TypstTemplate/computer-notes.typ": *


// ── 文档元信息 ──
#set document(
  title: "Python",
  author: "Violet",
  date: datetime.today(),
)

// 应用全局样式
#show: apply-style

// ══════════════════════════════════════════════════════════════════════
// 封面
// ══════════════════════════════════════════════════════════════════════

#make-cover(
  "Python",
  "Violet",
  date: datetime.today().display(),
)

// 目录
#make-outline(depth: 2)

#part("Python 核心基础")
#include "chapters/Python基础.typ"

#part("Python 高级特性与函数式编程")
#include "chapters/Python高级特性.typ"

#part("标准库与常用工具")
#include "chapters/标准库.typ"

#part("Python 工程化与最佳实践")
#include "chapters/工程化.typ"

#part("Python 底层原理与性能优化")
#include "chapters/底层原理.typ"

// ─────────────────────────────────────────────────────────────────────
// Part 1：Python 核心基础（语法 + 编程范式）
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：Python 入门与环境搭建 ✅
// 1.1 语言概述：Python 设计理念、解释型 vs 编译型、动态类型系统
// 1.2 开发环境搭建：Python 安装、虚拟环境（venv/conda）、IDE 配置（PyCharm/VSCode）
// 1.3 运行流程：源码→字节码→解释执行、.pyc 文件作用
// 1.4 第一个程序：Hello World、交互式解释器、脚本模式

// Chapter 2：基础语法 ✅
// 2.1 标识符、注释、编码规范（PEP 8）
// 2.2 变量与数据类型：动态类型、基本类型（int/float/bool/str）、类型注解
// 2.3 运算符与表达式：算术、比较、逻辑、身份、成员运算符
// 2.4 流程控制：if-elif-else、for/while 循环、break/continue/pass
// 2.5 输入输出：input()、print() 格式化、f-string

// Chapter 3：数据结构基础 ✅
// 3.1 列表（List）：创建、切片、常用方法、列表推导式
// 3.2 元组（Tuple）：不可变序列、解包赋值、命名元组
// 3.3 字典（Dict）：键值对、字典推导式、defaultdict/OrderedDict
// 3.4 集合（Set）：集合运算、frozenset
// 3.5 字符串高级操作：split/join、正则表达式、文本处理

// Chapter 4：函数与模块化 ✅
// 4.1 函数定义：def、参数类型（位置/关键字/默认/可变参数）
// 4.2 返回值：单值/多值返回、None、return 语句
// 4.3 作用域：LEGB 规则、global/nonlocal 关键字
// 4.4 Lambda 表达式：匿名函数、高阶函数
// 4.5 模块与包：import 机制、__name__、包结构、相对导入

// Chapter 5：面向对象编程（OOP）🔶
// 5.1 类与对象：class 定义、__init__、self、实例属性
// 5.2 封装：私有属性（_/__）、property 装饰器
// 5.3 继承：单继承/多继承、super()、MRO（方法解析顺序）
// 5.4 多态：鸭子类型、抽象基类（ABC）
// 5.5 魔术方法：__str__/__repr__、__eq__、__len__、运算符重载
// 5.6 类方法与静态方法：@classmethod、@staticmethod
// 5.7 数据类：dataclasses、NamedTuple

// Chapter 6：异常处理 🔶
// 6.1 异常体系：Exception 层次结构、内置异常类型
// 6.2 try-except-else-finally：异常捕获、多重 except
// 6.3 自定义异常：继承 Exception、异常链
// 6.4 上下文管理器：with 语句、__enter__/__exit__
// 6.5 异常最佳实践：EAFP vs LBYL、异常粒度


// ─────────────────────────────────────────────────────────────────────
// Part 2：Python 高级特性与函数式编程
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：迭代器与生成器 🔶
// 1.1 迭代协议：__iter__/__next__、可迭代对象
// 1.2 生成器函数：yield、惰性求值、无限序列
// 1.3 生成器表达式：与列表推导式的区别
// 1.4 itertools 模块：高效迭代工具

// Chapter 2：装饰器 🔶
// 2.1 闭包与作用域：嵌套函数、自由变量
// 2.2 装饰器基础：@syntax、函数装饰器
// 2.3 带参数的装饰器、类装饰器
// 2.4 functools 模块：wraps、lru_cache、partial
// 2.5 装饰器实战：日志、缓存、权限检查

// Chapter 3：描述符与元类 🔶
// 3.1 描述符协议：__get__/__set__/__delete__
// 3.2 property 实现原理、描述符应用
// 3.3 元类基础：type、metaclass、__new__ vs __init__
// 3.4 元类应用场景：ORM、接口验证

// Chapter 4：函数式编程 🔶
// 4.1 一等公民函数：函数作为参数/返回值
// 4.2 map/filter/reduce：函数式数据处理
// 4.3 偏函数：functools.partial
// 4.4 纯函数与副作用、不可变性


// ─────────────────────────────────────────────────────────────────────
// Part 3：标准库与常用工具
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：文件系统与路径操作 🔶
// 1.1 os 模块：文件/目录操作、环境变量
// 1.2 pathlib 模块：面向对象的路径操作
// 1.3 shutil 模块：高级文件操作（复制/移动/压缩）
// 1.4 glob 模块：文件名模式匹配

// Chapter 2：日期时间与时间处理 🔶
// 2.1 datetime 模块：date/time/datetime/timedelta
// 2.2 时区处理：timezone、pytz、zoneinfo（Python 3.9+）
// 2.3 time 模块：时间戳、睡眠、性能计时
// 2.4 calendar 模块：日历操作

// Chapter 3：正则表达式 🔶
// 3.1 re 模块基础：match/search/findall
// 3.2 正则语法：字符类、量词、分组、断言
// 3.3 编译正则、替换、分割
// 3.4 实战：数据提取、验证、清洗

// Chapter 4：JSON 与数据序列化 🔶
// 4.1 json 模块：序列化/反序列化、自定义编码器
// 4.2 pickle 模块：Python 对象序列化
// 4.3 CSV 文件处理：csv 模块、pandas 简介 ⚪
// 4.4 XML/HTML 解析：xml.etree、BeautifulSoup ⚪

// Chapter 5：并发编程基础 🔶
// 5.1 threading 模块：线程创建、锁、条件变量
// 5.2 multiprocessing 模块：进程池、共享内存
// 5.3 concurrent.futures：ThreadPoolExecutor/ProcessPoolExecutor
// 5.4 GIL 全局解释器锁：影响与应对策略

// Chapter 6：异步编程（asyncio）🔶
// 6.1 协程基础：async/await、事件循环
// 6.2 asyncio 核心 API：create_task、gather、wait
// 6.3 异步 IO：aiohttp、异步文件操作
// 6.4 异步 vs 多线程：适用场景对比

// Chapter 7：网络编程 🔶
// 7.1 socket 编程：TCP/UDP 客户端/服务端
// 7.2 HTTP 请求：urllib、requests 库 ⚪
// 7.3 Web 框架简介：Flask/FastAPI/Django 概览 ⚪


// ─────────────────────────────────────────────────────────────────────
// Part 4：Python 工程化与最佳实践
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：虚拟环境与依赖管理
// 1.1 Python 依赖管理概述（与特殊性说明：为什么没有项目级配置文件？）
//     - 对比其他生态：Maven/Gradle（pom.xml/build.gradle）、npm（package.json）
//     - Python 的历史原因：pip + requirements.txt 的演进历程
//     - 现代解决方案：pyproject.toml、Poetry、uv 的项目级配置
// 1.2 venv 模块：创建与管理虚拟环境
//     - python -m venv .venv、激活/退出虚拟环境
//     - 虚拟环境原理：隔离 site-packages、PYTHONPATH
// 1.3 pip 包管理：安装、卸载、冻结依赖
//     - pip install/uninstall/list、requirements.txt 生成与使用
//     - 版本约束：==、>=、~=、^ 语法
// 1.4 conda 环境管理：Anaconda/Miniconda
//     - conda create/activate/deactivate、环境导出与导入
//     - conda vs pip：包来源、跨语言依赖、科学计算优势
// 1.5 Poetry：现代依赖管理与打包工具
//     - pyproject.toml 配置、poetry add/remove、依赖解析
//     - 虚拟环境管理、发布到 PyPI
// 1.6 uv：超快速的 Python 包管理器（🔥 2024 最火）
//     - uv 简介：Rust 编写、比 pip 快 10-100 倍
//     - uv init/pip/install/sync、项目初始化
//     - uv.lock 锁定文件、确定性构建
//     - uv vs pip vs Poetry：性能对比、适用场景
// 1.7 依赖管理最佳实践
//     - 开发环境 vs 生产环境、dev/prod 依赖分离
//     - 锁定文件的重要性：requirements.txt vs poetry.lock vs uv.lock
//     - 持续集成中的依赖安装策略

// Chapter 2：代码质量与规范
// 2.1 PEP 8 编码规范：命名、缩进、空格
// 2.2 类型提示（Type Hints）：typing 模块、mypy 静态检查
// 2.3 文档字符串（Docstring）：Google/Numpy/Sphinx 风格
// 2.4 代码格式化工具：black、autopep8
// 2.5 Linter 工具：flake8、pylint

// Chapter 3：测试与调试
// 3.1 unittest 框架：TestCase、断言、测试套件
// 3.2 pytest 框架：fixture、参数化、插件生态 ⚪
// 3.3 调试技巧：pdb、断点、日志记录
// 3.4 测试覆盖率：coverage.py

// Chapter 4：打包与发布
// 4.1 setup.py/pyproject.toml：项目配置
// 4.2 setuptools/wheel：构建分发包
// 4.3 PyPI 发布：twine、版本管理
// 4.4 内部包管理：私有 PyPI、Git 依赖


// ─────────────────────────────────────────────────────────────────────
// Part 5：数据处理与科学计算（选学）⚪
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：NumPy 数值计算
// 1.1 ndarray 数组：创建、索引、切片、广播
// 1.2 数学运算：线性代数、统计、随机数
// 1.3 性能优化：向量化操作、避免 Python 循环

// Chapter 2：Pandas 数据分析
// 2.1 DataFrame/Series：数据加载、清洗、转换
// 2.2 数据聚合：groupby、pivot_table
// 2.3 时间序列处理

// Chapter 3：Matplotlib 数据可视化
// 3.1 基础绘图：折线图、柱状图、散点图
// 3.2 高级图表：热力图、箱线图、子图布局
// 3.3 Seaborn 美化 ⚪


// ─────────────────────────────────────────────────────────────────────
// Part 6：Python 底层原理与性能优化
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：Python 对象模型 🔶
// 1.1 一切皆对象：PyObject、引用计数
// 1.2 可变 vs 不可变对象：内存布局差异
// 1.3 小整数缓存、字符串驻留

// Chapter 2：内存管理与垃圾回收 🔶
// 2.1 引用计数机制：增减时机、循环引用问题
// 2.2 标记-清除算法：解决循环引用
// 2.3 分代回收：三代模型、触发条件
// 2.4 内存泄漏检测：tracemalloc、objgraph

// Chapter 3：GIL 与并发模型 🔶
// 3.1 GIL 原理：为什么需要 GIL、锁定机制
// 3.2 GIL 的影响：CPU 密集型 vs IO 密集型
// 3.3 绕过 GIL：multiprocessing、C 扩展、Jython

// Chapter 4：性能分析与优化 🔶
// 4.1 性能分析工具：cProfile、timeit、line_profiler
// 4.2 优化策略：算法优化、数据结构选择、缓存
// 4.3 C 扩展与 Cython：加速关键代码
// 4.4 JIT 编译器：PyPy、Numba ⚪

// Chapter 5：CPython 解释器架构 🔶
// 5.1 编译流程：源码→AST→字节码→解释执行
// 5.2 字节码指令：dis 模块、常见指令解析
// 5.3 解释器循环：eval_frame、调用栈
// 5.4 其他实现：PyPy、Jython、IronPython 对比


