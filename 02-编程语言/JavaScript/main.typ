#import "../../99-索引与模板/TypstTemplate/computer-notes.typ": *


// ── 文档元信息 ──
#set document(
  title: "JavaScript",
  author: "Violet",
  date: datetime.today(),
)

// 应用全局样式
#show: apply-style

// ══════════════════════════════════════════════════════════════════════
// 封面
// ══════════════════════════════════════════════════════════════════════

#make-cover(
  "JavaScript",
  "Violet",
  date: datetime.today().display(),
)

// 目录
#make-outline(depth: 2)


#part("JS & TS 核心基础")
#include "chapters/核心基础.typ"

#part("JavaScript 核心特性")
#include "chapters/核心特性.typ"

#part("TypeScript 类型系统与高级特性")

#part("标准库与常用 API")

#part("浏览器端 JavaScript")

#part("Node.js 与 Bun")
#include "chapters/Nodejs与Bun.typ"

#part("JavaScript 工程化")
#include "chapters/工程化.typ"

#part("JavaScript 底层原理")


// 目录

// ─────────────────────────────────────────────────────────────────────
// Part 1：JS & TS 核心基础
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：JS & TS 概述与环境搭建 ✅
// 1.1 JavaScript 演进史：ES5 → ES6+、TypeScript 诞生、现代 JS 生态
// 1.2 运行环境：浏览器引擎（V8、SpiderMonkey）、Node.js、Deno、Bun
// 1.3 开发环境搭建：Node.js 安装、npm/yarn/pnpm、VS Code 配置
// 1.4 TypeScript 入门：为什么需要 TS、tsc 编译、tsconfig.json

// Chapter 2：基础语法与变量 ✅
// 2.1 变量声明：var/let/const、块级作用域、暂时性死区
// 2.2 数据类型：原始类型、引用类型、typeof、instanceof
// 2.3 运算符与表达式：算术、比较、逻辑、可选链、空值合并
// 2.4 流程控制：if-else、switch、for/while、break/continue

// Chapter 3：函数与作用域 ✅
// 3.1 函数定义：函数声明、函数表达式、箭头函数
// 3.2 参数处理：默认参数、剩余参数、arguments 对象
// 3.3 作用域链：全局作用域、函数作用域、块级作用域
// 3.4 闭包：概念、应用场景、内存泄漏

// Chapter 4：对象与数组 ✅
// 4.1 对象基础：创建、访问、遍历、解构赋值
// 4.2 数组方法：map/filter/reduce、find/some/every、sort/reverse
// 4.3 展开与剩余：...operator、浅拷贝、数组合并
// 4.4 Set 与 Map：集合操作、键值对、WeakMap/WeakSet

// ─────────────────────────────────────────────────────────────────────
// Part 2：JavaScript 核心特性
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：原型与面向对象 🔶
// 1.1 原型链：__proto__、prototype、原型继承机制
// 1.2 构造函数：new 关键字、constructor、实例与原型
// 1.3 ES6 Class：class 语法、extends、super、静态方法
// 1.4 面向对象设计：封装、继承、多态、设计模式简介

// Chapter 2：this 与执行上下文 🔶
// 2.1 this 绑定规则：默认绑定、隐式绑定、显式绑定、new 绑定
// 2.2 call/apply/bind：手动指定 this、柯里化、借用方法
// 2.3 执行上下文：变量对象、作用域链、this 指向
// 2.4 提升机制：变量提升、函数提升、TDZ

// Chapter 3：异步编程与事件循环 🔶
// 3.1 事件循环机制：调用栈、任务队列、微任务/宏任务
// 3.2 Promise 核心：状态机、then/catch/finally、链式调用
// 3.3 async/await：语法糖、错误处理、并行执行
// 3.4 高级异步：Promise.all/race/allSettled、生成器、异步迭代器

// Chapter 4：模块化系统 ⚪
// 4.1 CommonJS：require/module.exports、Node.js 模块
// 4.2 ES Modules：import/export、动态导入、Tree-Shaking
// 4.3 模块解析：路径解析、循环依赖、裸 specifier
// 4.4 模块打包：Webpack、Rollup、Vite 的模块处理

// Chapter 5：错误处理与调试 ⚪
// 5.1 错误类型：Error、SyntaxError、TypeError、ReferenceError
// 5.2 try-catch-finally：异常捕获、错误传播、自定义错误
// 5.3 调试技巧：Chrome DevTools、断点、性能分析
// 5.4 日志与监控：console API、错误上报、Sentry

// ─────────────────────────────────────────────────────────────────────
// Part 3：TypeScript 类型系统与高级特性
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：TypeScript 基础类型 🔶
// 1.1 类型注解：基本类型、数组、元组、枚举、any/unknown/never
// 1.2 接口与类型别名：interface vs type、扩展、实现
// 1.3 联合与交叉类型：|、&、类型守卫、窄化
// 1.4 字面量类型：字符串字面量、数字字面量、模板字面量

// Chapter 2：泛型与工具类型 🔶
// 2.1 泛型基础：泛型函数、泛型接口、泛型约束
// 2.2 工具类型：Partial、Required、Pick、Omit、Record
// 2.3 条件类型：extends、infer、分布式条件类型
// 2.4 映射类型：keyof、in、as、模板字面量类型

// Chapter 3：高级类型技巧 ⚪
// 3.1 类型推断：上下文推断、最佳通用类型、候选者推断
// 3.2 类型兼容：结构化类型、协变与逆变、双向协变
// 3.3 装饰器：类装饰器、方法装饰器、属性装饰器
// 3.4 命名空间与模块：namespace、declare module、类型声明文件

// Chapter 4：TypeScript 工程化 ⚪
// 4.1 tsconfig.json：compilerOptions、include/exclude、项目引用
// 4.2 类型声明：@types、手写 .d.ts、第三方库类型
// 4.3 严格模式：strict、noImplicitAny、strictNullChecks
// 4.4 迁移策略：JS → TS、渐进式采用、混合项目

// ─────────────────────────────────────────────────────────────────────
// Part 4：标准库与常用 API
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：内置对象与方法 🔶
// 1.1 String 方法：split/join、slice/substring、replace/replaceAll
// 1.2 Number 与 Math：精度问题、舍入、随机数、常量
// 1.3 Date 与时间：日期格式化、时区处理、Intl.DateTimeFormat
// 1.4 JSON：序列化、反序列化、reviver/replacer、循环引用

// Chapter 2：正则表达式 🔶
// 2.1 正则基础：字符类、量词、分组、断言
// 2.2 RegExp 对象：test、exec、match、replace
// 2.3 常用模式：邮箱、URL、手机号、身份证
// 2.4 高级技巧：零宽断言、回溯、性能优化

// Chapter 3：Web API 概览 ⚪
// 3.1 DOM 操作：querySelector、createElement、事件委托
// 3.2 BOM API：window、location、navigator、history
// 3.3 Storage：localStorage、sessionStorage、Cookie
// 3.4 Fetch API：请求/响应、Headers、Body、AbortController

// Chapter 4：实用工具函数 ⚪
// 4.1 防抖与节流：debounce、throttle、实现原理
// 4.2 深拷贝：JSON.parse/stringify、structuredClone、递归实现
// 4.3 数组去重：Set、filter、reduce
// 4.4 扁平化：flat、flatMap、递归实现

// ─────────────────────────────────────────────────────────────────────
// Part 5：浏览器端 JavaScript
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：DOM 编程 🔶
// 1.1 DOM 树结构：节点类型、遍历、查询
// 1.2 DOM 操作：创建、插入、删除、替换
// 1.3 事件系统：事件流、事件委托、自定义事件
// 1.4 表单处理：验证、提交、FormData、File API

// Chapter 2：浏览器存储 ⚪
// 2.1 Cookie：设置、读取、HttpOnly、Secure
// 2.2 Web Storage：localStorage、sessionStorage、容量限制
// 2.3 IndexedDB：事务、游标、版本管理
// 2.4 Cache API：Service Worker 缓存、离线支持

// Chapter 3：网络通信 🔶
// 3.1 XMLHttpRequest：传统 AJAX、readyState、progress
// 3.2 Fetch API：Promise-based、Streaming、Request/Response
// 3.3 WebSocket：全双工通信、心跳检测、重连机制
// 3.4 Server-Sent Events：单向推送、自动重连

// Chapter 4：浏览器性能优化 ⚪
// 4.1 渲染性能：重排与重绘、will-change、GPU 加速
// 4.2 加载优化：懒加载、预加载、资源提示
// 4.3 内存管理：垃圾回收、内存泄漏、Performance API
// 4.4 Web Workers：多线程、SharedArrayBuffer、转移所有权

// ─────────────────────────────────────────────────────────────────────
// Part 6：Node.js 与现代运行时（Node.js + Bun）
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：Node.js 基础与演进 🔶
// 1.1 Node.js 架构：单线程、非阻塞 I/O、libuv、事件驱动
// 1.2 版本演进：LTS 策略、重要版本特性（v14/v16/v18/v20/v22）
// 1.3 模块系统：CommonJS、ES Modules、内置模块、混合使用
// 1.4 全局对象：global、process、__dirname、__filename、import.meta

// Chapter 2：Bun 现代运行时 🔶
// 2.1 Bun 简介：为什么需要 Bun、性能对比、设计理念
// 2.2 Bun vs Node.js：架构差异、API 兼容性、性能优势
// 2.3 Bun 特有 API：Bun.serve、Bun.file、Bun.spawn、JSC 引擎
// 2.4 迁移指南：Node.js → Bun、兼容性问题、最佳实践

// Chapter 3：文件系统与路径 🔶
// 3.1 fs 模块：同步/异步 API、Stream、Watch、Promise API
// 3.2 path 模块：路径拼接、解析、规范化、URL 支持
// 3.3 文件操作：读写、追加、删除、权限、大文件处理
// 3.4 目录操作：遍历、创建、删除、统计、递归操作

// Chapter 4：HTTP 服务器 🔶
// 4.1 http 模块：创建服务器、请求/响应对象、流式处理
// 4.2 路由处理：URL 解析、方法判断、中间件模式
// 4.3 RESTful API：CRUD、状态码、错误处理、版本控制
// 4.4 静态文件服务：mime 类型、缓存头、范围请求、压缩

// Chapter 5：Express/Koa 框架 ⚪
// 5.1 Express 基础：路由、中间件、模板引擎、错误处理
// 5.2 Koa 核心：Context、洋葱模型、async/await、中间件
// 5.3 数据库集成：MongoDB、MySQL、ORM（Prisma、TypeORM）
// 5.4 身份认证：JWT、Session、OAuth、Passport

// Chapter 6：Node.js/Bun 高级主题 ⚪
// 6.1 Stream：Readable、Writable、Transform、Duplex、管道
// 6.2 Buffer：二进制数据、编码转换、性能优化
// 6.3 Cluster/Worker Threads：多进程、多线程、负载均衡
// 6.4 调试与性能：Inspector、Profiler、Benchmark、火焰图

// ─────────────────────────────────────────────────────────────────────
// Part 7：JavaScript 工程化
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：包管理器 🔶
// 1.1 npm：package.json、scripts、依赖管理、workspace
// 1.2 yarn：lock 文件、workspaces、缓存、Plug'n'Play
// 1.3 pnpm：硬链接、符号链接、磁盘空间优化、严格模式
// 1.4 Bun：内置包管理器、极速安装、锁文件、兼容性

// Chapter 2：构建工具 🔶
// 2.1 Webpack：Entry、Output、Loader、Plugin
// 2.2 Rollup：Tree-Shaking、Code Splitting、Plugins
// 2.3 Vite：ESBuild、HMR、预构建、插件系统
// 2.4 对比与选型：场景分析、性能对比、生态

// Chapter 3：代码质量 ⚪
// 3.1 ESLint：规则配置、插件、自动修复
// 3.2 Prettier：代码格式化、集成 ESLint
// 3.3 TypeScript：类型检查、strict 模式
// 3.4 Git Hooks：Husky、lint-staged、commitlint

// Chapter 4：测试框架 ⚪
// 4.1 Jest：单元测试、Mock、Snapshot、Coverage
// 4.2 Vitest：Vite 原生、快速、兼容 Jest API
// 4.3 Cypress/Playwright：E2E 测试、用户流程
// 4.4 测试策略：TDD、BDD、测试金字塔

// Chapter 5：部署与 CI/CD ⚪
// 5.1 静态托管：Vercel、Netlify、GitHub Pages
// 5.2 Docker 化：多阶段构建、镜像优化
// 5.3 GitHub Actions：工作流、自动化测试、部署
// 5.4 监控与日志：Sentry、LogRocket、Analytics

// ─────────────────────────────────────────────────────────────────────
// Part 8：JavaScript 底层原理
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：V8 引擎与执行机制 🔶
// 1.1 V8 架构：Ignition（解释器）、TurboFan（编译器）
// 1.2 字节码与 JIT：即时编译、优化编译、去优化
// 1.3 隐藏类与内联缓存：对象形状、属性访问优化
// 1.4 垃圾回收：标记-清除、分代回收、增量标记

// Chapter 2：内存管理与性能优化 🔶
// 2.1 内存模型：栈、堆、常量池
// 2.2 内存泄漏：常见场景、检测方法、预防措施
// 2.3 性能分析：Chrome DevTools、Performance API
// 2.4 优化技巧：对象池、惰性初始化、缓存

// Chapter 3：事件循环深度解析 ⚪
// 3.1 浏览器事件循环：macrotask、microtask、渲染
// 3.2 Node.js 事件循环：6个阶段、timers、poll
// 3.3 process.nextTick vs setImmediate
// 3.4 实战案例：异步顺序、竞态条件

// Chapter 4：安全与最佳实践 ⚪
// 4.1 XSS 攻击：反射型、存储型、DOM 型、防御
// 4.2 CSRF 攻击：原理、Token 防御、SameSite
// 4.3 安全编码：输入验证、输出转义、CSP
// 4.4 最佳实践：不可变性、纯函数、错误边界
