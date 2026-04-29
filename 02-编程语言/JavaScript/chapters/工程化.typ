#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= 包管理器

JavaScript 生态系统依赖强大的包管理器来管理依赖、脚本和工具链。从 npm 到 Bun，包管理器经历了多次演进。

== npm

npm（Node Package Manager）是 Node.js 的默认包管理器，也是世界上最大的软件注册表。

=== 安装策略与 node_modules

*传统安装方式*：

```bash
# npm 直接安装到 node_modules
npm install express

# 项目结构
project/
├── node_modules/      # 所有依赖都在这里
│   ├── express/
│   ├── lodash/
│   └── ... (数百个文件夹)
├── package.json
└── package-lock.json
```

*问题*：

#tex-table(
  ("问题", "说明", "影响"),
  ("磁盘占用大", "每个项目都有完整副本", "100个项目 = 5GB+"),
  ("安装慢", "需要复制大量文件", "大型项目需要分钟级"),
  ("嵌套深", "依赖树嵌套导致路径过长", "Windows 路径长度限制"),
  ("Phantom deps", "可以访问未声明的依赖", "隐藏 bug"),
)

#caution[
  npm 的传统安装方式是 JavaScript 生态“node_modules 黑洞”的根源。
]

=== 命令简写

npm 提供了丰富的命令简写，提高开发效率。

```bash
# 安装依赖
npm install express        # 完整写法
npm i express              # 简写
npm add express            # 另一种简写（不常用）

# 开发依赖
npm install --save-dev typescript   # 完整
npm i -D typescript                 # 简写
npm i --dev typescript              # 另一种

# 全局安装
npm install -g nodemon     # 完整
npm i -g nodemon           # 简写

# 卸载
npm uninstall express      # 完整
npm rm express             # 简写
npm remove express         # 另一种

# 运行脚本
npm run dev                # 完整
npm run build              # 完整

# 查看信息
npm list                   # 列出依赖
npm ls                     # 简写
npm outdated               # 查看过时依赖
npm update                 # 更新依赖
npm up                     # 简写
```

*常用简写对照表*：

#tex-table(
  ("完整命令", "简写", "说明"),
  ("install", "i", "安装依赖"),
  ("uninstall", "rm/remove/un", "卸载依赖"),
  ("--save-dev", "-D", "开发依赖"),
  ("--global", "-g", "全局安装"),
  ("list", "ls", "列出依赖"),
  ("update", "up", "更新依赖"),
  ("init", "create", "初始化项目"),
  ("test", "t/tst", "运行测试"),
)

#tip[
  团队项目中应统一使用完整命令或简写，避免混用造成混乱。
]

=== package.json

```json
{
  "name": "my-project",
  "version": "1.0.0",
  "description": "My awesome project",
  "main": "index.js",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "test": "vitest",
    "lint": "eslint ."
  },
  "dependencies": {
    "express": "^4.18.0",
    "lodash": "~4.17.21"
  },
  "devDependencies": {
    "typescript": "^5.0.0",
    "vitest": "^1.0.0"
  },
  "engines": {
    "node": ">=18.0.0"
  }
}
```

*关键字段*：

#tex-table(
  ("字段", "说明", "示例"),
  ("name", "包名", "my-package"),
  ("version", "版本号", "1.0.0"),
  ("dependencies", "生产依赖", "express: ^4.18.0"),
  ("devDependencies", "开发依赖", "typescript: ^5.0.0"),
  ("scripts", "脚本命令", "build: vite build"),
  ("engines", "引擎要求", "node: >=18"),
  ("peerDependencies", "同伴依赖", "react: ^18.0.0"),
)

#note[
  `^` 表示兼容版本（允许小版本升级），`~` 表示补丁版本（只允许补丁升级）。
]

=== scripts

```json
{
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "test": "vitest",
    "test:coverage": "vitest --coverage",
    "lint": "eslint src --ext .ts,.vue",
    "lint:fix": "eslint src --ext .ts,.vue --fix",
    "type-check": "tsc --noEmit",
    "clean": "rm -rf dist",
    "prebuild": "npm run clean",
    "postbuild": "echo Build complete!"
  }
}
```

*生命周期钩子*：

```bash
# pre/post 钩子自动执行
npm run build
# 执行顺序：prebuild → build → postbuild

# 常用组合
npm run lint && npm run test && npm run build
```

*传递参数*：

```bash
# 使用 -- 传递参数
npm run test -- --reporter=verbose
npm run dev -- --port 3000

# 或使用环境变量
PORT=3000 npm run dev
```

=== 依赖管理

```bash
# 安装依赖
npm install express              # 生产依赖
npm install -D typescript        # 开发依赖（--save-dev）
npm install lodash@4.17.21       # 指定版本

# 更新依赖
npm update                       # 更新所有依赖
npm update express               # 更新指定依赖
npm outdated                     # 查看可更新的依赖

# 卸载依赖
npm uninstall express
npm uninstall -D typescript

# 清理缓存
npm cache clean --force
```

*版本控制*：

```bash
# 语义化版本
npm version patch    # 1.0.0 → 1.0.1
npm version minor    # 1.0.0 → 1.1.0
npm version major    # 1.0.0 → 2.0.0

# 查看版本
npm view express versions
npm view express latest
```

#tip[
  始终使用锁文件（package-lock.json）确保依赖版本一致。
]

=== npx

npx（npm package executor）是 npm 5.2+ 内置的工具执行器，可以运行本地或远程的包。

*基本用法*：

```bash
# 运行本地安装的包
npx jest                    # 使用项目中的 jest
npx typescript              # 使用项目中的 tsc

# 运行未安装的包（临时下载）
npx create-react-app my-app    # 自动下载并执行
npx cowsay "Hello"             # 有趣的命令行工具

# 指定版本
npx eslint@8.0.0 src/

# 忽略本地版本，始终使用最新
npx --ignore-existing create-react-app my-app
```

*工作原理*：

```text
npx 执行流程:
1. 检查 node_modules/.bin/ 中是否有该命令
2. 如果有，直接执行
3. 如果没有，从 npm registry 临时下载
4. 执行完成后删除（不保留在项目中）
```

*常见用途*：

```bash
# 1. 初始化项目
npx create-next-app@latest
npx create-vite@latest
npx @angular/cli new my-app

# 2. 代码格式化
npx prettier --write src/
npx eslint src/ --fix

# 3. 测试
npx jest
npx mocha test/

# 4. 构建
npx webpack
npx vite build

# 5. 数据库迁移
npx prisma migrate dev
npx typeorm migration:run

# 6. 临时工具
npx http-server ./dist    # 快速启动静态服务器
npx serve ./dist          # 另一种选择
npx ngrok http 3000       # 内网穿透
```

*npx vs npm scripts*：

```json
// package.json
{
  "scripts": {
    // ✅ 推荐：在 scripts 中定义
    "lint": "eslint src/",
    "test": "jest",
    "build": "vite build",

    // ❌ 不推荐：每次都写 npx
    "lint": "npx eslint src/",
  }
}
```

```bash
# 使用 scripts
npm run lint        # ✅ 简洁

# 直接使用 npx
npx eslint src/     # ⚠️ 每次都要写
```

*优势*：

#tex-table(
  ("优势", "说明", "示例"),
  ("无需全局安装", "避免污染全局命名空间", "npx create-react-app"),
  ("版本隔离", "每个项目可以使用不同版本", "project-a 用 jest@27, project-b 用 jest@29"),
  ("临时执行", "用完即删，不占用空间", "npx cowsay"),
  ("最新版本", "总是使用最新版", "npx create-next-app@latest"),
)

#note[
  npx 是现代 JavaScript 开发的核心工具，几乎每天都会用到。
]

=== Bun 的等价物

Bun 提供了类似的工具执行功能。

*Bun x*：

```bash
# Bun x 类似于 npx
bunx create-react-app my-app
bunx jest
bunx eslint src/

# 简写
bun x create-vite@latest
```

*区别*：

#tex-table(
  ("特性", "npx", "bunx"),
  ("来源", "npm 内置", "Bun 内置"),
  ("速度", "中等", "更快"),
  ("缓存", "npm 缓存", "Bun 缓存"),
  ("兼容性", "所有 npm 包", "所有 npm 包"),
  ("额外功能", "无", "可以利用 Bun 性能优势"),
)

*实际使用*：

```bash
# 大多数情况下，npx 和 bunx 可以互换
npx create-next-app@latest   # ✅
bunx create-next-app@latest  # ✅ 更快

# 但如果使用 Bun 运行时，建议用 bunx
bunx --bun create-next-app@latest  # 使用 Bun 运行时
```

#tip[
  如果你已经安装了 Bun，可以用 bunx 替代 npx 获得更快的速度。
]

npm workspaces 支持 monorepo 项目管理。

```json
// package.json (root)
{
  "name": "monorepo-root",
  "private": true,
  "workspaces": [
    "packages/*"
  ]
}
```

```text
monorepo/
├── package.json
├── packages/
│   ├── pkg-a/
│   │   ├── package.json
│   │   └── src/
│   └── pkg-b/
│       ├── package.json
│       └── src/
```

```bash
# 安装所有 workspace 的依赖
npm install

# 在特定 workspace 中运行命令
npm run build --workspace=pkg-a

# 添加跨 workspace 依赖
npm install pkg-a --workspace=pkg-b
```

*优势*：

- *共享依赖*：多个项目共享相同的依赖
- *本地链接*：workspace 之间自动链接
- *统一脚本*：可以批量执行脚本
- *简化维护*：统一管理多个相关项目

#note[
  npm workspaces 是 npm 7+ 的特性，之前需要使用 Lerna 或 Yarn workspaces。
]

== yarn

Yarn 是由 Facebook 开发的替代 npm 的包管理器，提供了更快的安装速度和更好的依赖管理。

=== Yarn 的现状

*历史回顾*：

```text
2016: Yarn v1 发布，解决 npm v3/v4 的性能问题
2017: npm v5 发布，缩小了与 Yarn 的差距
2019: Yarn v2 (Berry) 发布，引入 PnP 等重大变更
2020+: npm 持续改进，pnpm 崛起，Bun 出现
2024: Yarn 市场份额下降，pnpm 和 Bun 更受欢迎
```

*当前市场地位*：

#tex-table(
  ("包管理器", "2020年份额", "2024年份额", "趋势"),
  ("npm", "~70%", "~65%", "稳定"),
  ("yarn", "~20%", "~10%", "下降 ↓"),
  ("pnpm", "~5%", "~15%", "上升 ↑"),
  ("Bun", "~0%", "~8%", "快速增长 ↑↑"),
)

*为什么 Yarn 使用减少？*

#tex-table(
  ("原因", "说明"),
  ("npm 改进", "npm v5+ 性能大幅提升，锁文件、workspace 等特性跟进"),
  ("pnpm 崛起", "节省空间、严格模式、monorepo 支持更好"),
  ("Bun 出现", "极速安装、一体化体验、开发者喜爱"),
  ("Yarn v2 变更", "PnP 破坏兼容性，迁移成本高"),
  ("生态惯性", "大部分项目默认使用 npm"),
)

#note[
  Yarn 仍然是一个优秀的包管理器，但在新项目中选择率下降。现有 Yarn 项目可以继续使用，无需迁移。
]

=== Yarn Classic vs Yarn Berry

*Yarn Classic (v1)*：

```bash
# 安装
npm install -g yarn

# 基本命令
yarn add express
yarn add -D typescript
yarn remove express
yarn install
```

*Yarn Berry (v2/v3/v4)*：

```bash
# 安装
corepack enable
yarn set version stable

# 新的命令语法
yarn add express
yarn add -D typescript
yarn remove express
yarn install
```

*主要区别*：

#tex-table(
  ("特性", "Yarn v1", "Yarn v2+"),
  ("锁文件", "yarn.lock", "yarn.lock"),
  ("node_modules", "传统文件夹", "Plug'n'Play"),
  ("缓存", "全局缓存", "零安装"),
  ("配置", ".yarnrc", ".yarnrc.yml"),
  ("工作区", "支持", "增强支持"),
)

#caution[
  Yarn Berry 引入了重大变更，迁移需要谨慎评估。
]

=== lock 文件

```yaml
# yarn.lock 示例
express@^4.18.0:
  version "4.18.2"
  resolved "https://registry.yarnpkg.com/express/-/express-4.18.2.tgz#..."
  integrity sha512-...
  dependencies:
    accepts "~1.3.8"
    body-parser "1.20.1"
```

*作用*：

- *锁定版本*：确保所有开发者使用相同的依赖版本
- *快速安装*：直接从锁文件解析依赖树
- *一致性*：避免 "works on my machine" 问题

#tip[
  始终将 lock 文件提交到版本控制系统。
]

=== workspaces

```json
// package.json (root)
{
  "private": true,
  "workspaces": [
    "packages/*"
  ]
}
```

```bash
# Yarn workspaces 命令
yarn workspace @myorg/pkg-a add express
yarn workspace @myorg/pkg-b run build

# 在所有 workspace 中运行
yarn workspaces foreach run build
```

*优势*：

- *提升依赖*：自动 hoist 共享依赖到根目录
- *本地链接*：workspace 之间自动链接
- *并行安装*：更快的安装速度

=== Plug'n'Play (PnP)

Yarn Berry 的 PnP 模式消除了 node_modules 文件夹。

```yaml
# .yarnrc.yml
nodeLinker: pnp
```

*优势*：

- *磁盘空间*：减少重复依赖，节省空间
- *安装速度*：无需复制文件到 node_modules
- *确定性*：完全确定的依赖解析
- * phantom dependencies*：防止访问未声明的依赖

*劣势*：

- *兼容性*：某些工具可能不支持 PnP
- *学习曲线*：需要理解新的工作原理

#note[
  PnP 是 Yarn 的创新特性，但 adoption 仍然有限。
]

=== 缓存

```bash
# Yarn 全局缓存
yarn cache dir          # 查看缓存目录
yarn cache clean        # 清理缓存
yarn cache list         # 列出缓存

# 离线模式
yarn install --offline  # 使用缓存离线安装
```

*Zero-Installs*：

Yarn Berry 支持将所有依赖提交到 Git，实现零安装。

```yaml
# .yarnrc.yml
enableGlobalCache: false
```

```bash
# 所有依赖存储在 .yarn/cache/
git add .yarn/cache/
git commit -m "Add dependencies"

# 克隆后无需安装
git clone repo
cd repo
yarn run build  # 直接运行！
```

#tip[
  Zero-Installs 适合小型项目，大型项目可能导致 Git 仓库过大。
]

== pnpm

pnpm（performant npm）是一个快速、节省磁盘空间的包管理器。

=== 硬链接与符号链接

pnpm 使用内容寻址存储和硬链接来节省磁盘空间，类似于 Java 的 Maven 本地仓库。

*Maven 对比*：

```text
Java Maven:
~/.m2/repository/          # 全局仓库
  org/springframework/
    spring-core/5.3.0/
    spring-web/5.3.0/

project-a/pom.xml          # 项目引用全局仓库
project-b/pom.xml          # 共享相同的依赖

JavaScript pnpm:
~/.pnpm-store/v3/          # 全局仓库（类似 .m2）
  files/ab/cd/lodash-4.17.21/
  files/ef/gh/express-4.18.2/

project-a/node_modules/    # 通过符号链接引用
project-b/node_modules/    # 共享相同的依赖
```

*传统方式（npm/yarn）*：

```text
project-a/node_modules/lodash/      # 完整副本
project-b/node_modules/lodash/      # 完整副本
project-c/node_modules/lodash/      # 完整副本
# 每个项目都有一份完整的 lodash 副本
# 100个项目 = 100份副本 = 浪费空间
```

*pnpm 方式*：

```text
~/.pnpm-store/v3/files/ab/cd/lodash-4.17.21/  # 只有一个副本

project-a/node_modules/.pnpm/lodash@4.17.21/ -> 符号链接到 store
project-b/node_modules/.pnpm/lodash@4.17.21/ -> 符号链接到 store
project-c/node_modules/.pnpm/lodash@4.17.21/ -> 符号链接到 store
# 只有一个副本，通过符号链接共享
# 100个项目 = 1份副本 = 节省90%空间
```

*工作流程*：

```bash
# 1. 首次安装
pnpm install express
# ↓
# 下载 express 到 ~/.pnpm-store/
# 创建符号链接到 node_modules/

# 2. 第二个项目安装同样的依赖
pnpm install express
# ↓
# 检测到 ~/.pnpm-store/ 中已有 express
# 直接创建符号链接，无需下载！

# 3. 离线安装
pnpm install --offline
# ↓
# 完全从本地 store 读取，无需网络
```

*磁盘空间对比*：

#tex-table(
  ("包管理器", "100个项目", "节省空间", "原理"),
  ("npm", "~5GB", "0%", "每个项目完整副本"),
  ("yarn", "~5GB", "0%", "每个项目完整副本"),
  ("pnpm", "~500MB", "90%", "全局 store + 符号链接"),
  ("Bun", "~500MB", "90%", "全局 cache + 硬链接"),
)

#note[
  pnpm 和 Bun 的缓存机制类似于 Maven/Gradle，避免了重复下载和存储。
]


=== 严格模式

pnpm 默认启用严格模式，防止 phantom dependencies。

*Phantom Dependencies 问题*：

```javascript
// package.json
{
  "dependencies": {
    "express": "^4.18.0"
  }
}

// index.js
const express = require('express')  // ✅ 已声明
const lodash = require('lodash')    // ❌ 未声明，但可能工作
// 因为 lodash 是 express 的依赖
```

*pnpm 的行为*：

```javascript
const lodash = require('lodash')  // ❌ Error!
// Cannot find module 'lodash'
```

*解决方案*：

```bash
# 显式安装
pnpm add lodash

# 或配置允许（不推荐）
# .npmrc
shamefully-hoist=true
```

#tip[
  严格模式强制显式声明所有依赖，提高项目的可维护性。
]

=== 基本用法

```bash
# 安装
pnpm add express           # 生产依赖
pnpm add -D typescript     # 开发依赖
pnpm add lodash@4.17.21    # 指定版本

# 安装所有依赖
pnpm install

# 更新
pnpm update
pnpm update express

# 卸载
pnpm remove express

# 运行脚本
pnpm run dev
pnpm run build
```

*workspace 支持*：

```bash
# pnpm workspace
pnpm --filter @myorg/pkg-a add express
pnpm --filter @myorg/pkg-b run build

# 所有 workspace
pnpm -r run build
```

=== 性能优势

*安装速度*：

```bash
# 首次安装（冷缓存）
npm install    # ~30s
yarn install   # ~25s
pnpm install   # ~20s

# 二次安装（有缓存）
npm install    # ~10s
yarn install   # ~8s
pnpm install   # ~2s  ← 显著更快
```

*原因*：

1. *内容寻址存储*：避免重复下载
2. *硬链接*：无需复制文件
3. *并行安装*：充分利用 CPU
4. *智能缓存*：高效的缓存策略

#note[
  pnpm 在大型项目和 monorepo 中性能优势更明显。
]

== Bun

Bun 内置了超快速的包管理器，旨在替代 npm/yarn/pnpm。

=== 极速安装

```bash
# Bun 包管理器命令
bun install              # 安装依赖
bun add express          # 添加依赖
bun add -d typescript    # 开发依赖
bun remove express       # 移除依赖
bun update               # 更新依赖
```

*性能对比*：

```bash
# 安装大型项目（1000+ 依赖）
npm install    # ~30s
yarn install   # ~25s
pnpm install   # ~20s
bun install    # ~2s   ← 快 10-15 倍
```

*为什么这么快？*

1. *Zig 编写*：系统级语言，无运行时开销
2. *并行下载*：充分利用网络带宽
3. *高效缓存*：智能缓存策略（类似 Maven）
4. *优化算法*：更快的依赖解析
5. *硬链接*：避免文件复制

*Bun 的缓存机制*：

```text
Bun Cache:
~/.bun/install/cache/      # 全局缓存（类似 ~/.m2 或 ~/.pnpm-store）
  express@4.18.2/
  lodash@4.17.21/
  react@18.2.0/

project-a/node_modules/    # 通过硬链接引用缓存
project-b/node_modules/    # 共享相同的缓存

# 首次安装：下载并缓存
bun install express
# ↓ 下载到 ~/.bun/install/cache/
# ↓ 硬链接到 node_modules/

# 第二次安装：直接使用缓存
bun install express
# ↓ 检测到缓存中已有
# ↓ 直接硬链接，无需下载！
```

#tip[
  即使不使用 Bun 运行时，也可以单独使用 Bun 作为包管理器获得极速体验。
]

=== 锁文件

```toml
# bun.lockb (二进制格式)
# 比 package-lock.json 和 yarn.lock 更小、更快

# 查看锁文件内容
bun install --lockfile

# 生成文本格式的锁文件（用于调试）
bun install --generate-lockfile
```

*特点*：

- *二进制格式*：更小、解析更快
- *确定性*：确保一致的依赖安装
- *兼容性*：可以读取 package-lock.json 和 yarn.lock

#note[
  bun.lockb 是二进制格式，不适合人工阅读，但性能极佳。
]

=== 兼容性

*兼容 npm*：

```bash
# Bun 可以读取 package.json
bun install

# 兼容 npm scripts
bun run dev
bun run build

# 兼容 npm registry
bun add express  # 从 npm registry 下载
```

*私有 registry*：

```bash
# 配置私有 registry
bun config set registry https://registry.npmmirror.com

# 或使用 .npmrc
# registry=https://registry.npmmirror.com
```

*workspace 支持*：

```bash
# Bun 支持 npm workspaces
bun install  # 自动识别 workspaces

# 在特定 workspace 中运行
bun run --filter=pkg-a build
```

=== 与其他包管理器对比

#tex-table(
  ("特性", "npm", "yarn", "pnpm", "Bun"),
  ("安装速度", "慢", "中", "快", "极快"),
  ("磁盘空间", "高", "高", "低", "低"),
  ("锁文件格式", "JSON", "YAML", "YAML", "二进制"),
  ("严格模式", "❌", "❌", "✅", "✅"),
  ("workspace", "✅", "✅", "✅", "✅"),
  ("零安装", "❌", "✅", "❌", "❌"),
  ("生态成熟度", "极高", "高", "中高", "中"),
)

*选择建议*：

#tex-table(
  ("场景", "推荐", "原因"),
  ("新手入门", "npm", "默认、文档多"),
  ("追求速度", "Bun", "最快"),
  ("节省空间", "pnpm", "硬链接"),
  ("monorepo", "pnpm/Bun", "性能好"),
  ("企业项目", "npm/pnpm", "稳定"),
  ("创新实验", "Bun/Yarn PnP", "新特性"),
)

#fancy-divider

本章完

= 构建工具

= 代码质量

= 测试框架

= 部署与 CI/CD
