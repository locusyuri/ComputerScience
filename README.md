# Computer Science Notes

基于 Typst 的计算机科学笔记模板，提供统一、美观、易用的排版方案。

## 项目结构

```
ComputerScience/
├── 01-计算机基础/          # 数据结构、算法、计算机组成等
├── 02-编程语言/            # Java、Python、JavaScript 等语言笔记
├── 03-开发方向/            # 前端、后端、移动端等方向
├── 04-数据与智能/          # 数据库、机器学习等
├── 05-安全与密码/          # 网络安全、密码学等
├── 06-工程化与运维/        # DevOps、容器化等
├── 07-架构与解决方案/      # 系统设计、架构模式等
└── 99-索引与模板/          # 模板文件和样式定义
```

## Typst 模板

模板文件位于 `99-索引与模板/TypstTemplate/`：

| 文件 | 说明 |
|------|------|
| `computer-notes.typ` | 样式文件，定义颜色、字体、组件等 |
| `example.typ` | 完整功能演示文档 |

### 快速开始

1. 安装 Typst
2. 复制模板文件夹到你的笔记目录
3. 创建新的 `.typ` 文件，导入模板：

```typst
#import "computer-notes.typ": *

#show: apply-style

#make-cover(
  "我的笔记标题",
  "作者名",
  date: datetime.today().display(),
)

#make-outline(depth: 3)

// 开始写笔记...
```

### 编译

```bash
# 编译 PDF
typst compile example.typ

# 监视模式（修改自动重新编译）
typst watch example.typ
```

## 功能特性

### 标题体系
- 七级标题，每级有独特样式
- Part 页面：蓝色背景 + 居中标题
- Chapter：带 Chapter 编号和横线装饰
- Section：胶囊形背景
- Subsection：蓝色编号前缀
- Sub-subsection：蓝色竖线装饰
- Paragraph/Subparagraph：绿色样式

### 列表组件
- 无序列表：自定义标记（• ◦ ▪）
- 有序列表：itemize 包增强
- 树形列表：彩色标记 + 连接线
- Checklist：复选框样式（需启用）

### 代码高亮
- 基于 Codly 包
- 支持 30+ 编程语言
- 语言图标 + 行号

### 提示框
| 类型 | 用途 |
|------|------|
| `#note` | 笔记、补充说明 |
| `#tip` | 技巧、实践经验 |
| `#info` | 通用信息 |
| `#warning` | 警告 |
| `#caution` | 注意 |
| `#danger` | 危险 |
| `#todo` | 待办事项 |

### 表格
- `plain-table`：完整网格线
- `tex-table`：LaTeX 风格（仅水平线）
- 原生 `table`：复杂功能（单元格合并等）

### 其他功能
- 数学公式（带编号）
- 脚注
- 交叉引用
- 超链接
- 终端命令样式
- 算法伪代码框

## 字体配置

模板使用以下字体（需自行安装）：

| 用途 | 字体 |
|------|------|
| 中文正文 | 霞鹜文楷 (LXGW WenKai) |
| 中文回退 | 思源宋体 |
| 英文正文 | Cantarell |
| 英文标题 | Merriweather |
| 等宽/代码 | Consolas |

## 外部依赖

模板依赖以下 Typst 包（自动下载）：

- `@preview/itemize:0.2.0` - 增强列表
- `@preview/catppuccin:1.0.1` - 配色方案
- `@preview/codly:1.3.0` - 代码高亮

## License

MIT
