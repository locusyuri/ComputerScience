# GitHub Copilot Harness 功能完整使用指南

基于 GitHub 官方文档与实战资料，以下是 7 大 Harness 功能的配置步骤、语法格式、加载机制及典型用法的完整总结。

---

## 一、功能全景速查

| 功能 | 文件位置 | 触发方式 | 核心用途 |
|------|---------|---------|---------|
| **Custom Instructions** | `.github/copilot-instructions.md` / `.github/instructions/*.instructions.md` / `AGENTS.md` | 自动（始终加载） | 编码规范、团队约定 |
| **Prompt Files** | `.github/prompts/*.prompt.md` | 手动（`/` 斜杠命令） | 可复用一次性任务模板 |
| **Custom Agents** | `.github/agents/AGENT-NAME.md` | 手动（从 Agent 下拉列表选择） | 专家角色 + 工具权限控制 |
| **Subagents** | 无文件（运行时生成） | 自动（主 Agent 派生） | 隔离复杂子任务 |
| **Agent Skills** | `.github/skills/<name>/SKILL.md` | 自动按需加载 / 手动 `/` 命令 | 多步骤工作流 + 脚本资源封装 |
| **Hooks** | `.github/hooks/*.json` | 自动（生命周期事件触发） | 强制策略门控 |
| **MCP Servers** | `.vscode/mcp.json` | 自动发现 / 按名称调用 | 连接外部系统、数据库、API |

---

## 二、Custom Instructions（自定义指令）

### 加载机制
- `copilot-instructions.md`：整个仓库所有交互**始终注入**
- `*.instructions.md`：通过 `applyTo` 字段按**文件路径匹配**加载
- `AGENTS.md`：跨工具开放标准，支持子目录覆盖，**优先级高于全局规则**

### 配置步骤

**步骤 1**：在项目根目录创建文件：
```bash
mkdir -p .github/instructions
touch .github/copilot-instructions.md
```

**步骤 2**：编写全局规则 `.github/copilot-instructions.md`：
```markdown
# 项目编码规范

## 技术栈
- 后端：Java 17 + Spring Boot 3.x，禁止引入其他 Web 框架
- 前端：React 18 + TypeScript 5，禁止使用 Class 组件
- 数据库：PostgreSQL 16，禁止使用任何 NoSQL

## 安全规则
- 禁止硬编码任何密钥、密码、Token
- 所有 SQL 查询使用参数化语句，禁止字符串拼接
- 敏感字段（password、token）禁止打印日志

## 测试要求
- 单元测试覆盖率 > 80%
- 所有新 API 必须有集成测试
```

**步骤 3**：创建路径特定规则 `.github/instructions/react.instructions.md`：
```markdown
---
applyTo: "src/components/**/*.tsx"
---

# React 组件规范
- 必须是函数式组件
- Props 必须用 TypeScript interface 定义
- 使用 React Query 管理服务端状态，禁止 useEffect 手动 fetch
- 样式统一使用 Tailwind CSS，禁止内联 style
```

### 四种指令类型选择指南

| 类型 | 适用场景 |
|------|---------|
| `copilot-instructions.md` | 单项目、仅用 Copilot |
| `*.instructions.md` + `applyTo` | 多技术栈差异化规则 |
| `AGENTS.md` | 多 Agent 工作流、Monorepo 子目录 |
| 组织级设置 | 跨所有仓库的统一基线 |

---

## 三、Prompt Files（提示词文件）

### 加载机制
- 存放于 `.github/prompts/` 目录，文件名即斜杠命令名
- **不自动加载**，需用户在 Copilot Chat 中输入 `/` 手动触发
- 支持 `mode`（ask/edit/agent）、`tools`、`model`、`description` 等 frontmatter 字段
- 支持 `{{variable}}` 输入变量占位符

### 配置步骤

**步骤 1**：创建目录：
```bash
mkdir -p .github/prompts
```

**步骤 2**：编写 `/security-review` 命令 `.github/prompts/security-review.prompt.md`：
```markdown
---
mode: agent
description: 对指定文件进行全面安全审查
tools:
  - codebase
  - search
---

# 安全代码审查

对以下文件进行安全分析：`{{file}}`

## 检查范围
1. **注入漏洞**：SQL 注入、命令注入、XSS
2. **认证授权**：权限绕过、不安全的直接对象引用
3. **敏感数据**：硬编码密钥、明文存储密码
4. **输入验证**：缺失或不充分的验证逻辑

## 输出格式
每个问题给出：严重程度（Critical/High/Medium/Low）、位置（行号）、修复建议（附代码示例）
```

**步骤 3**：编写 `/generate-tests` 命令：
```markdown
---
mode: agent
description: 为指定类生成 JUnit 5 单元测试
---

# 单元测试生成

为 `{{className}}` 生成完整的 JUnit 5 测试。

## 要求
- 覆盖所有 public 方法
- 包含正常路径、边界条件、异常路径
- 使用 Mockito Mock 外部依赖
- 覆盖率目标 > 90%
- 命名规范：`should{Behavior}When{Condition}`
```

### 典型触发方式
```
/security-review src/main/java/UserController.java
/generate-tests UserService
/release-notes v1.2.0
```

---

## 四、Custom Agents（自定义代理）

### 加载机制
- 存放于 `.github/agents/` 目录，每个文件定义一个 Agent
- 从 Copilot Chat 的**下拉菜单**手动选择激活，整个会话持久保持该人设
- 可通过 `tools` / `disabledTools` 精确控制工具权限
- 支持 `model` 字段指定特定模型

### 配置步骤

创建 `.github/agents/java-architect.agent.md`：
```markdown
---
name: Java 架构设计师
description: 专注于 Spring Boot 架构设计、DDD 领域建模和性能优化的专家顾问
tools:
  - codebase
  - search
  - githubRepo
disabledTools:
  - terminal
  - writeFile
model: claude-3.7-sonnet
---

# 角色定义

你是拥有 15 年经验的 Java 后端架构师，专注于：
- DDD 领域驱动设计与六边形架构
- Spring Boot 3.x 最佳实践
- 数据库设计与查询优化
- 微服务拆分与治理

## 工作原则
- 给出建议而不直接修改代码（只读模式）
- 每个架构决策必须说明权衡（Trade-offs）
- 优先考虑可维护性，其次考虑性能
```

创建 `.github/agents/security-auditor.agent.md`（只读审计员）：
```markdown
---
name: 安全审计员
description: 专注安全漏洞检测，严格限制只读权限，绝不修改代码
tools:
  - codebase
  - search
disabledTools:
  - terminal
  - writeFile
  - editFile
---

你是渗透测试专家。所有发现按 CVSS 评分排序，只出报告，不做修复。
```

---

## 五、Agent Skills（代理技能）

### 加载机制
采用**渐进式披露（Progressive Disclosure）**三阶段机制：
1. **探索阶段**：启动时仅加载所有 Skill 的名称和 `description`
2. **激活阶段**：用户提示词与某 Skill 描述匹配时，加载完整 `SKILL.md`
3. **执行阶段**：按需加载 scripts/references/templates 等附属资源

### 文件位置（多路径支持）

| 路径 | 作用域 |
|------|--------|
| `.github/skills/<name>/SKILL.md` | 项目级（推荐） |
| `.claude/skills/<name>/SKILL.md` | 项目级（Claude 兼容） |
| `.agents/skills/<name>/SKILL.md` | 项目级（通用标准） |
| `~/.copilot/skills/<name>/SKILL.md` | 个人全局 |

### 配置步骤

**步骤 1**：创建 Skill 目录结构：
```bash
mkdir -p .github/skills/mvn-local-test/scripts
mkdir -p .github/skills/mvn-local-test/references
```

**步骤 2**：编写 `.github/skills/mvn-local-test/SKILL.md`：
```markdown
---
name: mvn-local-test
description: 本地 Java 服务自动化测试流。包含 Maven 打包、启动 Jar 包、
  cURL 接口验证及进程清理。用户请求本地测试/验证接口时触发。
license: MIT
metadata:
  author: dev-team
  version: 1.0.0
allowed-tools:
  - Bash
  - Read
  - Grep
---

# 本地 Java 服务测试工作流

## 执行步骤

### 1. 环境检查
确认当前目录存在 `pom.xml`，检查端口 8080 是否被占用。

### 2. 构建与启动
调用 `./scripts/build_and_run.sh`：
- 执行 `mvn clean package -DskipTests`
- 失败时立即停止并报告错误日志
- 成功后后台启动 Jar，记录 PID 到 `.server.pid`

### 3. 健康检查
轮询 `http://localhost:8080/actuator/health`，每 2 秒检查一次，超时 60 秒。

### 4. 接口测试
调用 `./scripts/test_endpoints.sh` 执行 cURL 测试用例。

### 5. 清理环境
测试完成后执行 `kill $(cat .server.pid)`，确认端口已释放。
```

**步骤 3**：编写附属脚本 `scripts/build_and_run.sh`：
```bash
#!/bin/bash
mvn clean package -DskipTests
[ $? -ne 0 ] && echo "Build failed" && exit 1
JAR_PATH=$(find target -name "*.jar" | head -n 1)
java -jar $JAR_PATH > server.log 2>&1 &
echo $! > .server.pid
echo "Server started with PID $(cat .server.pid)"
```

---

## 六、Hooks（生命周期钩子）

### 加载机制
- 存放于 `.github/hooks/` 目录，按事件类型命名
- 在 Agent 工作流的**特定生命周期节点自动触发**，用户无法绕过
- 与 Instructions 的核心区别：**Instructions 是建议，Hooks 是强制执行**
- `onFailure: "block"` 可直接阻止后续操作

### 支持的生命周期事件

| 事件 | 触发时机 | 典型用途 |
|------|---------|---------|
| `preToolUse` | 调用任何工具前 | 安全门控（最常用） |
| `postToolUse` | 工具调用完成后 | 自动格式化 |
| `sessionStart` | Agent 会话启动 | 加载合规声明 |
| `sessionEnd` | 会话结束 | 生成审计日志 |
| `userPromptSubmitted` | 用户提交提示词后 | 敏感词过滤 |
| `errorOccurred` | 发生错误时 | 错误上报 |

### 配置步骤

创建 `.github/hooks/pre-tool-use.json`（安全门控）：
```json
{
  "hooks": [
    {
      "event": "preToolUse",
      "matcher": {
        "tool": ["bash", "terminal", "editFile"]
      },
      "commands": [
        {
          "type": "shell",
          "command": "scripts/security-gate.sh",
          "args": ["{{tool}}", "{{input}}"],
          "onFailure": "block",
          "failureMessage": "安全检查未通过，操作已阻止。请检查 security-gate.sh 的输出。"
        }
      ]
    }
  ]
}
```

创建 `.github/hooks/post-tool-use.json`（编辑后自动格式化）：
```json
{
  "hooks": [
    {
      "event": "postToolUse",
      "matcher": {
        "tool": ["editFile", "writeFile"],
        "filePattern": "**/*.{ts,tsx,js,jsx}"
      },
      "commands": [
        {
          "type": "shell",
          "command": "npx",
          "args": ["prettier", "--write", "{{file}}"],
          "onFailure": "warn"
        }
      ]
    }
  ]
}
```

---

## 七、MCP Servers（模型上下文协议服务器）

### 加载机制
- 配置于 `.vscode/mcp.json`（项目级）或 `~/.vscode/mcp.json`（全局）
- VS Code 启动时**自动发现并注册**所有配置的 MCP 服务器
- 工具自动注入 Agent 的可用工具集，也可在提示词中**按名称指定调用**

### 配置步骤

创建 `.vscode/mcp.json`：
```json
{
  "servers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/",
      "headers": {
        "X-MCP-Toolsets": "default,copilot_spaces,actions,security"
      }
    },
    "playwright": {
      "type": "stdio",
      "command": "npx",
      "args": ["@playwright/mcp@latest"]
    },
    "postgres": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "${env:DB_URL}"
      }
    }
  }
}
```

### GitHub MCP Server 工具集

| 工具集 | 启用方式 | 提供能力 |
|--------|---------|---------|
| `default` | 默认启用 | Issues、PRs、仓库搜索、提交记录 |
| `copilot_spaces` | 显式声明 | 读写 Copilot Spaces |
| `actions` | 显式声明 | 触发/查看工作流运行日志 |
| `security` | 显式声明 | Code Scanning、Dependabot 告警 |

### 典型对话示例
```
"帮我查 #42 Issue 的最新评论，然后写修复方案并创建 PR"
→ Copilot 调用 github MCP → 读取 Issue → 分析代码 → 创建 Draft PR

"用 Playwright 测试登录页面的表单验证"
→ Copilot 调用 playwright MCP → 启动浏览器 → 执行测试 → 返回截图
```

---

## 八、完整项目配置示例

```
your-project/
├── AGENTS.md                              # 跨工具全局技术宪法
├── .github/
│   ├── copilot-instructions.md            # 仓库级全局规范
│   ├── instructions/
│   │   ├── java.instructions.md           # Java 规则（applyTo: **/*.java）
│   │   └── react.instructions.md          # React 规则（applyTo: **/*.tsx）
│   ├── prompts/
│   │   ├── security-review.prompt.md      # /security-review
│   │   ├── generate-tests.prompt.md       # /generate-tests
│   │   └── release-notes.prompt.md        # /release-notes
│   ├── agents/
│   │   ├── java-architect.agent.md        # 架构设计专家（只读）
│   │   └── security-auditor.agent.md      # 安全审计专家（只读）
│   ├── skills/
│   │   ├── mvn-local-test/SKILL.md        # 本地测试自动化
│   │   └── db-migration/SKILL.md          # 数据库迁移工作流
│   └── hooks/
│       ├── pre-tool-use.json              # 操作前安全门控
│       └── post-tool-use.json             # 编辑后自动格式化
└── .vscode/
    └── mcp.json                           # GitHub + Playwright + PostgreSQL MCP
```

---

## 九、功能选择决策指南

```
面对一个新需求，按以下顺序判断：

需要始终生效的规范？          → Custom Instructions
可复用的一次性任务（审查/测试）？→ Prompt Files
需要专家角色 + 工具权限控制？  → Custom Agents
多步骤工作流 + 脚本/模板资源？ → Agent Skills
执行节点的强制拦截（不可绕过）？→ Hooks
需要外部系统/数据库/API 数据？ → MCP Servers
复杂并行任务/上下文隔离需求？  → Subagents（自动，无需配置）

注意：MCP 和 Hooks 是叠加层，可与上述任意功能组合使用。
```

---

来源：
- 来源：Copilot customization cheat sheet - GitHub Docs [链接](https://docs.github.com/en/copilot/reference/customization-cheat-sheet)
- 来源：GitHub Copilot Instructions vs Prompts vs Custom Agents vs Skills vs Hooks - DEV Community [链接](https://dev.to/pwd9000/github-copilot-instructions-vs-prompts-vs-custom-agents-vs-skills-vs-x-vs-why-339l)
- 来源：Adding agent skills for GitHub Copilot - GitHub Docs [链接](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/add-skills)
- 来源：Use custom instructions in VS Code - VS Code Docs [链接](https://code.visualstudio.com/docs/copilot/customization/custom-instructions)

如需将以上内容整理成可存档的 Word 或 PDF 文档，我可以继续帮您生成。