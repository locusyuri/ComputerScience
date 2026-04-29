#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= Node.js 基础与演进

Node.js 是一个基于 Chrome V8 引擎的 JavaScript 运行时，让 JavaScript 可以运行在服务器端。它采用事件驱动、非阻塞 I/O 模型，使其轻量且高效。

== Node.js 架构

=== 单线程模型

```javascript
// Node.js 是单线程的，但通过事件循环实现高并发
const http = require('http')

const server = http.createServer((req, res) => {
  // 每个请求都在同一个线程中处理
  console.log(`Request: ${req.url}`)
  res.end('Hello World')
})

server.listen(3000)
console.log('Server running on port 3000')
```

*为什么单线程？*

#tex-table(
  ("优势", "说明"),
  ("无锁竞争", "不需要处理多线程同步问题"),
  ("内存占用低", "无需为每个线程分配栈空间"),
  ("上下文切换少", "减少 CPU 开销"),
  ("编程简单", "避免死锁、竞态条件"),
)

#caution[
  单线程意味着 CPU 密集型任务会阻塞整个应用，需要使用 Worker Threads 或子进程。
]

=== 非阻塞 I/O

```javascript
const fs = require('fs')

// ❌ 阻塞 I/O（不推荐）
const data = fs.readFileSync('/path/to/file', 'utf8')
console.log(data)  // 等待文件读取完成

// ✅ 非阻塞 I/O（推荐）
fs.readFile('/path/to/file', 'utf8', (err, data) => {
  if (err) throw err
  console.log(data)  // 文件读取完成后回调
})

console.log('This runs immediately')  // 不会等待文件读取
```

*阻塞 vs 非阻塞*：

```text
阻塞 I/O:
Thread: [Read File]───────────────[Process]──────[Response]
         ↑ 等待 I/O 完成

非阻塞 I/O:
Thread: [Start Read]──[Other Work]──[Callback]──[Response]
         ↑            ↑             ↑ 异步回调
         发起请求      继续执行       I/O 完成
```

=== libuv 与事件循环

```text
Node.js 架构:
┌─────────────────────────┐
│   JavaScript Code       │  ← V8 引擎执行 JS
├─────────────────────────┤
│   Node.js APIs          │  ← fs, net, http 等
├─────────────────────────┤
│   libuv                 │  ← 事件循环、线程池
├─────────────────────────┤
│   C++ Bindings          │  ← 系统调用封装
├─────────────────────────┤
│   Operating System      │  ← 文件系统、网络等
└─────────────────────────┘
```

*libuv 核心功能*：

1. **事件循环**：管理异步操作的生命周期
2. **线程池**：处理文件系统、DNS 等阻塞操作（默认4个线程）
3. **异步 I/O**：封装不同平台的 I/O API
4. **定时器**：setTimeout、setInterval 的实现

#note[
  libuv 是 Node.js 跨平台的核心，提供了统一的事件循环和异步 I/O 抽象。
]

=== 事件驱动

```javascript
const EventEmitter = require('events')

class MyEmitter extends EventEmitter {}

const myEmitter = new MyEmitter()

// 注册事件监听器
myEmitter.on('event', () => {
  console.log('事件触发了！')
})

// 触发事件
myEmitter.emit('event')

// 带参数的事件
myEmitter.on('greet', (name, age) => {
  console.log(`Hello ${name}, you are ${age} years old`)
})

myEmitter.emit('greet', 'Alice', 25)
```

*EventEmitter 常用方法*：

#tex-table(
  ("方法", "说明", "示例"),
  ("on/listen", "注册监听器", "emitter.on('data', handler)"),
  ("emit", "触发事件", "emitter.emit('data', value)"),
  ("once", "只监听一次", "emitter.once('connect', handler)"),
  ("off/removeListener", "移除监听器", "emitter.off('data', handler)"),
  ("removeAllListeners", "移除所有", "emitter.removeAllListeners()"),
)

== 版本演进

=== LTS 策略

Node.js 采用长期支持（LTS）策略，确保生产环境的稳定性。

*版本类型*：

#tex-table(
  ("类型", "支持周期", "适用场景"),
  ("Current", "6个月", "测试新特性"),
  ("Active LTS", "12个月", "生产环境推荐"),
  ("Maintenance LTS", "18个月", "遗留系统维护"),
  ("End-of-Life", "无", "不再支持"),
)

*发布周期*：

```
每年4月发布偶数版本（v18, v20, v22...）
v18 → Current (6个月) → Active LTS (12个月) → Maintenance (18个月) → EOL
```

#tip[
  生产环境始终使用 Active LTS 或 Maintenance LTS 版本。
]

=== 重要版本特性

*v14 (2020)*：

```javascript
// 可选链操作符
const name = user?.profile?.name

// 空值合并运算符
const value = input ?? 'default'

// Promise.allSettled
Promise.allSettled([p1, p2, p3])

// 全局 this
globalThis === window  // 浏览器
globalThis === global  // Node.js
```

*v16 (2021)*：

```javascript
// fetch API（实验性）
const response = await fetch('https://api.example.com')

// AbortController
const controller = new AbortController()
setTimeout(() => controller.abort(), 5000)

fetch(url, { signal: controller.signal })

// Error.cause
throw new Error('Failed', { cause: originalError })
```

*v18 (2022)*：

```javascript
// fetch API（稳定）
const response = await fetch('https://api.example.com')
const data = await response.json()

// Test Runner（实验性）
import { test } from 'node:test'
import assert from 'node:assert'

test('adds 1 + 2 to equal 3', () => {
  assert.strictEqual(1 + 2, 3)
})

// Web Crypto API
const key = await crypto.subtle.generateKey(...)
```

*v20 (2023)*：

```javascript
// Test Runner（稳定）
import { test, describe } from 'node:test'

describe('Math', () => {
  test('addition', () => {
    assert.strictEqual(1 + 2, 3)
  })
})

// Permission Model（实验性）
// node --allow-read=src app.js

// Single Executable Applications
// pkg 工具的官方替代
```

*v22 (2024)*：

```javascript
// require() 支持 ES Modules
import { createRequire } from 'module'
const require = createRequire(import.meta.url)

// WebSocket（稳定）
const ws = new WebSocket('ws://localhost:8080')

// SQLite（内置）
import db from 'node:sqlite'
const database = db.openSync('./app.db')
```

#note[
  每个主要版本都带来重要的新特性和性能改进，建议定期升级。
]

=== 版本对比

#tex-table(
  ("特性", "v14", "v16", "v18", "v20", "v22"),
  ("fetch API", "❌", "🧪", "✅", "✅", "✅"),
  ("Test Runner", "❌", "❌", "🧪", "✅", "✅"),
  ("Web Crypto", "❌", "❌", "✅", "✅", "✅"),
  ("Permission Model", "❌", "❌", "❌", "🧪", "🧪"),
  ("WebSocket", "❌", "❌", "❌", "❌", "✅"),
  ("SQLite", "❌", "❌", "❌", "❌", "✅"),
)

*图例*：❌ 不支持 | 🧪 实验性 | ✅ 稳定支持

== 模块系统

=== CommonJS

```javascript
// math.js - 导出
function add(a, b) {
  return a + b
}

function subtract(a, b) {
  return a - b
}

module.exports = { add, subtract }
// 或者
exports.add = add
exports.subtract = subtract
```

```javascript
// app.js - 导入
const { add, subtract } = require('./math')

console.log(add(1, 2))  // 3
console.log(subtract(5, 3))  // 2
```

*特点*：

- *同步加载*：require() 是同步的
- *运行时解析*：在代码执行时解析模块
- *动态导入*：可以根据条件加载模块
- *缓存机制*：模块只加载一次，后续从缓存获取

#note[
  CommonJS 是 Node.js 的原生模块系统，至今仍广泛使用。
]

=== ES Modules

```javascript
// math.mjs - 导出
export function add(a, b) {
  return a + b
}

export function subtract(a, b) {
  return a - b
}

// 默认导出
export default function multiply(a, b) {
  return a * b
}
```

```javascript
// app.mjs - 导入
import { add, subtract } from './math.mjs'
import multiply from './math.mjs'

console.log(add(1, 2))  // 3
console.log(multiply(2, 3))  // 6
```

*在 package.json 中启用*：

```json
{
  "type": "module"  // 启用 ES Modules
}
```

*特点*：

- *异步加载*：import 是异步的
- *编译时解析*：在代码执行前解析依赖
- *静态分析*：支持 Tree-Shaking
- *浏览器兼容*：与浏览器 ES Modules 一致

#tip[
  新项目推荐使用 ES Modules，旧项目可以逐步迁移。
]

=== 混合使用

```javascript
// 在 ES Module 中使用 CommonJS
import { createRequire } from 'module'
const require = createRequire(import.meta.url)

const lodash = require('lodash')

// 在 CommonJS 中使用 ES Module（需要动态导入）
async function loadModule() {
  const module = await import('./esm-module.mjs')
  return module.default
}
```

*兼容性对比*：

#tex-table(
  ("特性", "CommonJS", "ES Modules"),
  ("语法", "require/module.exports", "import/export"),
  ("加载方式", "同步", "异步"),
  ("解析时机", "运行时", "编译时"),
  ("Tree-Shaking", "❌", "✅"),
  ("动态导入", "✅", "✅ (import())"),
  ("浏览器支持", "❌", "✅"),
  ("文件扩展名", ".js", ".mjs 或 type: module"),
)

=== 内置模块

```javascript
// 核心模块（无需安装）
const fs = require('fs')           // 文件系统
const path = require('path')       // 路径处理
const http = require('http')       // HTTP 服务器
const os = require('os')           // 操作系统信息
const crypto = require('crypto')   // 加密
const events = require('events')   // 事件发射器
const stream = require('stream')   // 流处理
const util = require('util')       // 工具函数

// ES Modules 导入
import fs from 'fs'
import path from 'path'
import http from 'http'
```

*常用内置模块*：

#tex-table(
  ("模块", "用途", "常用方法"),
  ("fs", "文件操作", "readFile, writeFile, mkdir"),
  ("path", "路径处理", "join, resolve, basename"),
  ("http", "HTTP 服务", "createServer, request"),
  ("os", "系统信息", "platform, cpus, freemem"),
  ("crypto", "加密", "createHash, randomBytes"),
  ("events", "事件", "EventEmitter"),
  ("stream", "流", "Readable, Writable"),
  ("child_process", "子进程", "exec, spawn"),
)

== 全局对象

=== global

```javascript
// global 是 Node.js 的全局对象（类似浏览器的 window）

// 设置全局变量
global.myVar = 'Hello'
console.log(global.myVar)  // 'Hello'

// 全局函数
global.sayHi = () => console.log('Hi')
global.sayHi()  // 'Hi'

// 注意：避免污染全局命名空间
```

#caution[
  尽量避免使用 global，会导致命名冲突和难以维护的代码。
]

=== process

```javascript
// 进程信息
console.log(process.pid)        // 进程 ID
console.log(process.version)    // Node.js 版本
console.log(process.platform)   // 操作系统平台
console.log(process.arch)       // CPU 架构

// 环境变量
console.log(process.env.NODE_ENV)  // 'development' or 'production'
console.log(process.env.PORT)      // 端口号

// 命令行参数
console.log(process.argv)  // ['node', 'script.js', 'arg1', 'arg2']

// 退出进程
process.exit(0)   // 成功退出
process.exit(1)   // 失败退出

// 事件监听
process.on('exit', (code) => {
  console.log(`About to exit with code: ${code}`)
})

process.on('uncaughtException', (err) => {
  console.error('Uncaught Exception:', err)
  process.exit(1)
})
```

*常用属性*：

#tex-table(
  ("属性", "说明", "示例"),
  ("argv", "命令行参数", "['node', 'app.js', '--port=3000']"),
  ("env", "环境变量", "process.env.NODE_ENV"),
  ("pid", "进程 ID", "12345"),
  ("platform", "平台", "'linux', 'darwin', 'win32'"),
  ("version", "Node 版本", "'v20.10.0'"),
  ("cwd()", "当前目录", "process.cwd()"),
)

=== `__dirname` 和 `__filename`

```javascript
// __dirname: 当前模块的目录名
console.log(__dirname)  // '/home/user/project/src'

// __filename: 当前模块的文件名（绝对路径）
console.log(__filename)  // '/home/user/project/src/app.js'

// 常用组合
const path = require('path')
const configPath = path.join(__dirname, 'config.json')
```

*ES Modules 中的等价物*：

```javascript
import { fileURLToPath } from 'url'
import { dirname } from 'path'

const __filename = fileURLToPath(import.meta.url)
const __dirname = dirname(__filename)
```

#note[
  `__dirname` 和 `__filename` 在 ES Modules 中不可用，需要使用 `import.meta.url`。
]

=== import.meta

```javascript
// ES Modules 中的元信息

// 当前模块的 URL
console.log(import.meta.url)  // 'file:///home/user/project/src/app.js'

// 解析路径
import { fileURLToPath } from 'url'
const __filename = fileURLToPath(import.meta.url)

// 判断是否为主模块
if (import.meta.url === `file://${process.argv[1]}`) {
  console.log('这是主模块')
}

// 加载 JSON 文件
import { readFileSync } from 'fs'
const packageJson = JSON.parse(
  readFileSync(new URL('../package.json', import.meta.url), 'utf8')
)
```

*import.meta 的优势*：

- *标准化*：ES Modules 标准的一部分
- *浏览器兼容*：在浏览器中也可用
- *更灵活*：可以传递任意元信息
- *类型安全*：TypeScript 完整支持

#fancy-divider

本章完

= Bun 现代运行时

Bun 是一个现代化的 JavaScript 运行时，旨在成为 Node.js 的快速、一体化替代品。它由 Zig 编写，使用 JavaScriptCore 引擎，提供了卓越的性能和内置的工具链。

== Bun 简介

=== 为什么需要 Bun

Node.js 已经存在十多年，虽然成熟稳定，但也积累了一些问题：

*Node.js 的痛点*：

#tex-table(
  ("问题", "说明"),
  ("启动速度慢", "大型项目启动需要数秒"),
  ("包管理慢", "npm install 可能需要几分钟"),
  ("工具分散", "需要 webpack、jest、eslint 等多个工具"),
  ("性能瓶颈", "V8 引擎在某些场景下不够快"),
  ("内存占用高", "大型应用内存消耗大"),
)

*Bun 的解决方案*：

1. *极速启动*：比 Node.js 快 4-5 倍
2. *内置工具链*：bundler、test runner、package manager
3. *高性能*：基于 JavaScriptCore，某些场景快 2-3 倍
4. *原生 TypeScript*：无需配置即可运行 .ts 文件
5. *Web API 兼容*：fetch、WebSocket、ReadableStream 等

#tip[
  Bun 的目标不是完全取代 Node.js，而是提供一个更快、更现代的替代选择。
]

=== 性能对比

```bash
# 启动速度对比
$ time node app.js      # ~100ms
$ time bun app.js       # ~20ms (快 5 倍)

# 包安装速度
$ time npm install      # ~30s
$ time bun install      # ~2s (快 15 倍)

# HTTP 服务器吞吐量
$ wrk -t12 -c400 -d30s http://localhost:3000
# Node.js: ~50,000 req/sec
# Bun: ~150,000 req/sec (快 3 倍)
```

*基准测试*：

#tex-table(
  ("场景", "Node.js", "Bun", "提升"),
  ("启动时间", "100ms", "20ms", "5x"),
  ("npm install", "30s", "2s", "15x"),
  ("HTTP 请求", "50k req/s", "150k req/s", "3x"),
  ("TypeScript 编译", "需 tsc", "原生支持", "∞"),
  ("内存占用", "100MB", "60MB", "40%↓"),
)

#note[
  性能数据仅供参考，实际表现取决于具体应用场景。
]

=== 设计理念

*Bun 的核心原则*：

1. *速度优先*：所有操作都追求极致性能
2. *开箱即用*：内置常用工具，减少配置
3. *Web 标准*：优先实现 Web API，提高兼容性
4. *开发者体验*：简化工作流程，减少摩擦
5. *兼容性*：尽可能兼容 Node.js API

*技术栈*：

```text
Bun 架构:
┌─────────────────────────┐
│   JavaScript/TypeScript │  ← 用户代码
├─────────────────────────┤
│   Bun APIs              │  ← Bun.serve, Bun.file 等
├─────────────────────────┤
│   Web APIs              │  ← fetch, WebSocket, etc.
├─────────────────────────┤
│   Node.js Compatibility │  ← fs, path, http 等
├─────────────────────────┤
│   JavaScriptCore        │  ← Apple's JSC 引擎
├─────────────────────────┤
│   Zig                   │  ← 系统级编程语言
└─────────────────────────┘
```

#caution[
  Bun 使用 JavaScriptCore 而非 V8，这带来了性能优势，但也可能导致某些 V8 特有行为不兼容。
]

== Bun vs Node.js

=== 架构差异

*引擎对比*：

#tex-table(
  ("特性", "Node.js (V8)", "Bun (JSC)"),
  ("引擎", "Google V8", "Apple JavaScriptCore"),
  ("语言", "C++", "Zig"),
  ("JIT 编译", "TurboFan", "DFG + FTL"),
  ("垃圾回收", "Orinoco", "Mark-and-Sweep"),
  ("启动速度", "中等", "极快"),
  ("峰值性能", "极高", "高"),
  ("内存占用", "较高", "较低"),
)

*为什么 JSC 更快？*

1. *更简单的 JIT*：JSC 的编译器层级更少，启动更快
2. *更低的内存开销*：JSC 的对象模型更紧凑
3. *更好的冷启动*：JSC 在首次执行时优化更快
4. *Zig 的优势*：系统级语言，无运行时开销

#note[
  V8 在长时间运行的应用中可能表现更好，但 JSC 在启动速度和内存效率上占优。
]

=== API 兼容性

*完全兼容*：

```javascript
// 这些 API 在 Bun 中完全兼容 Node.js
const fs = require('fs')
const path = require('path')
const http = require('http')
const crypto = require('crypto')

// ES Modules
import fs from 'fs'
import path from 'path'
```

*部分兼容*：

```javascript
// child_process - 部分 API 未实现
const { exec } = require('child_process')  // ✅
const { fork } = require('child_process')  // ⚠️ 实验性

// cluster - 不支持
const cluster = require('cluster')  // ❌ 未实现

// worker_threads - 实验性支持
const { Worker } = require('worker_threads')  // ⚠️ 实验性
```

*Bun 特有 API*：

```javascript
// Bun.serve - 高性能 HTTP 服务器
const server = Bun.serve({
  port: 3000,
  fetch(request) {
    return new Response('Hello World')
  },
})

// Bun.file - 惰性文件读取
const file = Bun.file('package.json')
console.log(file.size)  // 不读取文件内容
const text = await file.text()  // 惰性读取

// Bun.spawn - 高性能子进程
const proc = Bun.spawn(['ls', '-la'])
const stdout = await new Response(proc.stdout).text()

// Bun.hash - 快速哈希
const hash = Bun.hash('hello')  // Wyhash 算法
```

*兼容性对比表*：

#tex-table(
  ("模块", "Node.js", "Bun", "备注"),
  ("fs", "✅", "✅", "完全兼容"),
  ("path", "✅", "✅", "完全兼容"),
  ("http", "✅", "✅", "完全兼容"),
  ("https", "✅", "✅", "完全兼容"),
  ("crypto", "✅", "✅", "完全兼容"),
  ("child_process", "✅", "⚠️", "部分支持"),
  ("cluster", "✅", "❌", "未实现"),
  ("worker_threads", "✅", "⚠️", "实验性"),
  ("Bun.*", "❌", "✅", "Bun 特有"),
)

*图例*：✅ 完全支持 | ⚠️ 部分支持 | ❌ 不支持

=== 性能优势

*Bun 的优势场景*：

1. *CLI 工具*：快速启动，即时响应
2. *脚本执行*：快速运行一次性任务
3. *开发服务器*：热更新更快，重启更快
4. *TypeScript 项目*：无需编译，直接运行
5. *高并发 I/O*：更高的吞吐量

*Node.js 的优势场景*：

1. *CPU 密集型*：V8 的优化编译器更强
2. *长期运行服务*：成熟的生态和稳定性
3. *复杂应用*：更多的库和工具支持
4. *企业级应用*：LTS 支持和商业保障

#tip[
  选择 Bun 还是 Node.js 取决于具体需求：追求速度和开发体验选 Bun，追求稳定性和生态选 Node.js。
]

== Bun 特有 API

=== Bun.serve

Bun 内置的高性能 HTTP 服务器，比 Express/Koa 快得多。

```javascript
// 基本用法
const server = Bun.serve({
  port: 3000,
  fetch(request) {
    return new Response('Hello World')
  },
})

console.log(`Listening on http://localhost:${server.port}`)
```

*路由处理*：

```javascript
Bun.serve({
  port: 3000,
  fetch(request) {
    const url = new URL(request.url)

    if (url.pathname === '/') {
      return new Response('Home Page')
    }

    if (url.pathname === '/api/users') {
      return Response.json([
        { id: 1, name: 'Alice' },
        { id: 2, name: 'Bob' },
      ])
    }

    return new Response('Not Found', { status: 404 })
  },
})
```

*静态文件服务*：

```javascript
Bun.serve({
  port: 3000,
  async fetch(request) {
    const url = new URL(request.url)
    const filePath = `./public${url.pathname}`

    try {
      const file = Bun.file(filePath)
      if (await file.exists()) {
        return new Response(file)
      }
    } catch {}

    return new Response('Not Found', { status: 404 })
  },
})
```

*WebSocket 支持*：

```javascript
Bun.serve({
  port: 3000,
  fetch(request, server) {
    if (server.upgrade(request)) {
      return  // WebSocket 连接已升级
    }
    return new Response('Regular HTTP')
  },
  websocket: {
    open(ws) {
      console.log('Client connected')
      ws.send('Welcome!')
    },
    message(ws, message) {
      console.log('Received:', message)
      ws.send(`Echo: ${message}`)
    },
    close(ws, code, reason) {
      console.log('Client disconnected')
    },
  },
})
```

#note[
  Bun.serve 基于低层 C API，性能远超基于 Node.js http 模块的框架。
]

=== Bun.file

惰性文件读取 API，只在需要时才读取文件内容。

```javascript
// 创建文件引用（不读取内容）
const file = Bun.file('package.json')

// 获取元信息（不读取内容）
console.log(file.size)      // 文件大小
console.log(file.type)      // MIME 类型
console.log(await file.exists())  // 是否存在

// 读取内容（惰性加载）
const text = await file.text()        // 文本
const json = await file.json()        // JSON
const arrayBuffer = await file.arrayBuffer()  // ArrayBuffer
const blob = await file.blob()        // Blob
```

*性能优势*：

```javascript
// ❌ Node.js - 立即读取整个文件
const data = fs.readFileSync('large-file.txt', 'utf8')

// ✅ Bun - 惰性读取，按需加载
const file = Bun.file('large-file.txt')
const size = file.size  // 不读取内容
const firstLine = await file.text().then(t => t.split('\n')[0])
```

*流式处理*：

```javascript
// 大文件流式传输
Bun.serve({
  port: 3000,
  fetch() {
    const file = Bun.file('video.mp4')
    return new Response(file.stream(), {
      headers: {
        'Content-Type': 'video/mp4',
        'Content-Length': file.size,
      },
    })
  },
})
```

=== Bun.spawn

高性能子进程 API，比 child_process 更快。

```javascript
// 基本用法
const proc = Bun.spawn(['ls', '-la'])

// 等待完成
await proc.exited
console.log('Exit code:', proc.exitCode)

// 读取输出
const stdout = await new Response(proc.stdout).text()
const stderr = await new Response(proc.stderr).text()

console.log('Output:', stdout)
```

*传入输入*：

```javascript
const proc = Bun.spawn(['cat'], {
  stdin: 'Hello World\n',
  stdout: 'pipe',
  stderr: 'pipe',
})

const output = await new Response(proc.stdout).text()
console.log(output)  // 'Hello World\n'
```

*环境变量*：

```javascript
const proc = Bun.spawn(['node', '-v'], {
  env: {
    ...process.env,
    NODE_ENV: 'production',
  },
  cwd: '/path/to/directory',
})

await proc.exited
```

*性能对比*：

```javascript
// ❌ Node.js - 较慢
const { exec } = require('child_process')
exec('ls -la', (error, stdout) => {
  console.log(stdout)
})

// ✅ Bun - 更快
const proc = Bun.spawn(['ls', '-la'])
const stdout = await new Response(proc.stdout).text()
console.log(stdout)
```

#tip[
  Bun.spawn 避免了 Node.js child_process 的序列化开销，性能提升显著。
]

=== 其他 Bun API

*Bun.hash*：

```javascript
// 快速哈希函数（Wyhash 算法）
const hash = Bun.hash('hello world')
console.log(hash)  // BigInt

// 指定种子
const hash2 = Bun.hash('hello', 12345)
```

*Bun.write*：

```javascript
// 高效写入文件
await Bun.write('output.txt', 'Hello World')
await Bun.write('data.json', JSON.stringify({ key: 'value' }))

// 写入 Buffer
const buffer = new Uint8Array([1, 2, 3])
await Bun.write('binary.bin', buffer)
```

*Bun.sleep*：

```javascript
// 更简洁的 setTimeout
await Bun.sleep(1000)  // 睡眠 1 秒

// 等价于
await new Promise(resolve => setTimeout(resolve, 1000))
```

*Bun.which*：

```javascript
// 查找可执行文件路径
const nodePath = Bun.which('node')
console.log(nodePath)  // '/usr/bin/node'

const pythonPath = Bun.which('python3')
```

*完整 API 列表*：

#tex-table(
  ("API", "用途", "示例"),
  ("Bun.serve", "HTTP 服务器", "Bun.serve({ fetch })"),
  ("Bun.file", "惰性文件", "Bun.file('path')"),
  ("Bun.spawn", "子进程", "Bun.spawn(['cmd'])"),
  ("Bun.hash", "哈希", "Bun.hash('data')"),
  ("Bun.write", "写入文件", "Bun.write(path, data)"),
  ("Bun.sleep", "延迟", "Bun.sleep(ms)"),
  ("Bun.which", "查找命令", "Bun.which('node')"),
  ("Bun.env", "环境变量", "Bun.env.NODE_ENV"),
)

== 迁移指南

=== Node.js → Bun

*步骤 1：安装 Bun*

```bash
# macOS/Linux
curl -fsSL https://bun.sh/install | bash

# Windows
powershell -c "irm bun.sh/install.ps1|iex"

# 验证安装
bun --version
```

*步骤 2：替换运行命令*

```bash
# Node.js
node app.js
node --watch app.js

# Bun
bun app.js
bun --watch app.js
```

*步骤 3：替换包管理器*

```bash
# npm
npm install
npm run dev

# Bun
bun install
bun run dev
```

*步骤 4：检查兼容性*

```bash
# 运行项目
bun app.js

# 查看警告
# Bun 会提示不兼容的 API
```

#note[
  大多数 Node.js 项目可以直接用 Bun 运行，无需修改代码。
]

=== 兼容性问题

*已知不兼容*：

#tex-table(
  ("问题", "影响", "解决方案"),
  ("cluster 模块", "多进程", "使用 Bun.spawn 或外部工具"),
  ("某些 native addons", "C++ 扩展", "寻找纯 JS 替代"),
  ("vm 模块", "沙箱执行", "使用 isolated-vm"),
  ("inspector", "调试协议", "使用 Chrome DevTools"),
  ("perf_hooks", "性能监控", "使用 Bun 内置工具"),
)

*常见陷阱*：

```javascript
// ❌ 依赖 V8 特定行为
const v8 = require('v8')  // Bun 不支持

// ✅ 使用标准 API
const crypto = require('crypto')  // 两者都支持

// ❌ 使用 cluster
const cluster = require('cluster')  // Bun 不支持

// ✅ 使用多个 Bun 实例
// 在 shell 中启动多个实例
```

#caution[
  在生产环境使用 Bun 前，务必进行充分的测试。
]

=== 最佳实践

*渐进式采用*：

```bash
# 1. 先在开发环境试用
bun run dev

# 2. 运行测试
bun test

# 3. 构建生产版本
bun build ./src/index.ts --outdir ./dist

# 4. 生产环境仍使用 Node.js（初期）
node dist/index.js
```

*利用 Bun 特性*：

```typescript
// 直接使用 TypeScript，无需编译
// index.ts
import { serve } from 'bun'

serve({
  port: 3000,
  fetch: () => new Response('Hello'),
})

// 运行
bun index.ts  // 无需 tsc
```

*使用 Bun 内置工具*：

```bash
# Bundler
bun build ./src/index.ts --outdir ./dist

# Test Runner
bun test

# Package Manager
bun install
bun add lodash
bun remove lodash

# Hot Reload
bun --watch app.ts
```

*性能优化*：

```javascript
// 使用 Bun.file 惰性读取
const config = Bun.file('config.json')

// 使用 Bun.serve 替代 Express
Bun.serve({ fetch })

// 使用 Bun.spawn 替代 child_process
const proc = Bun.spawn(['cmd'])
```

#tip[
  充分利用 Bun 的特有 API，可以获得最佳性能和开发体验。
]

#fancy-divider

本章完

= 文件系统与路径

= HTTP 服务器

= Express/Koa 框架

= Node.js/Bun 高级主题
