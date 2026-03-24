% ======================================================================
%   Computer Notes LaTeX Template - 合并版 README
%   最后更新: 2026-03-21
% ======================================================================

# Computer Notes LaTeX Template

一套开箱即用的计算机学科笔记模板，科技简约风，适配中文，推荐使用 XeLaTeX。

---

## 版本与状态

- 当前文档状态：稳定可用（Stable）
- 模板类文件：`computer-notes.cls`
- 示例文件：`example.tex`
- 推荐编译器：XeLaTeX（LuaLaTeX 可作为备选）

> 注：本 README 已合并原 `START_HERE.md`、`QUICKREF.md`、`MANIFEST.md` 内容，并按当前实现修正了过时说明。

---

## 30 秒快速开始

```bash
# 1) 编译示例
xelatex -interaction=nonstopmode example.tex

# 2) 复制一份自己的文档
# macOS / Linux
cp example.tex mynotes.tex

# Windows PowerShell
Copy-Item example.tex mynotes.tex

# 3) 编辑后继续编译
xelatex -interaction=nonstopmode mynotes.tex
```

---

## 最小可用模板

```latex
\documentclass{computer-notes}

\settitle{我的笔记}
\setauthor{Your Name}
\setdate{\today}

\begin{document}
\makecover
	ableofcontents
\newpage

\chapter{主题}
\section{小节}
正文内容。

\end{document}
```

---

## 标题体系（已按当前样式更新）

当前文档类基于 `book`，推荐层级如下：

```latex
\chapter{一级标题}        % 蓝色居中 + 下方装饰横线
\section{二级标题}        % 蓝底白字圆角盒，编号从这里开始（1, 2, ...）
\subsection{三级标题}     % 行内标题，编号 1.1, 1.2 ...
\subsubsection{四级标题}  % 左侧竖线装饰，无编号
```

---

## 常用命令速查

### 文档元信息

```latex
\settitle{标题}
\setauthor{作者}
\setdate{日期}
\makecover
```

### Callout（7 种）

```latex
\note{笔记}
	ip{技巧}
\info{信息}
\warning{警告}
\caution{注意}
\danger{危险}
	odo{待办}
```

### 代码块（推荐两种）

```latex
% 方式 A：推荐，用 codeblock 环境（更稳）
\begin{codeblock}[Python]{main.py}
def hello():
    return "Hello"
\end{codeblock}

% 方式 B：快捷命令
\code{Python}{main.py}{
def hello():
    return "Hello"
}
```

### 行内与组件命令

```latex
\inline{x = 10}
	erminal{ls -la}
\file{/path/to/file}
\shortcut{Ctrl + S}
\highlight{重点}
\emphasis{强调}
\definition{定义名}{定义内容}
\algorithm{算法描述}
```

---

## 文件结构（当前仓库）

```text
TexTemplate/
├── computer-notes.cls    # 样式类（核心）
├── example.tex           # 完整示例文档
├── README.md             # 合并后的唯一说明文档
├── ref/                  # 参考材料
└── tmp/                  # 临时文件
```

---

## 功能清单（已去除过时项）

- 中文友好：基于 `fontspec + xeCJK`
- 页面与标题：`book` 架构 + 4 层标题视觉
- 目录与书签：`hyperref + bookmark`
- 数学公式：`amsmath + amssymb + mathtools`
- Callout 系统：7 种提示框
- 代码系统：`codeblock` / `\code`，支持语法高亮与行号
- 常用组件：行内代码、快捷键、终端、定义框、算法框
- 页眉页脚：`fancyhdr` 科技简约风格

---

## 快速定制入口（QUICK-EDIT）

在 `computer-notes.cls` 中搜索下列标记：

- `QUICK-EDIT:TITLE-HIERARCHY`：标题层级
- `QUICK-EDIT:CHAPTER-LINE`：一级标题下方横线
- `QUICK-EDIT:SECTION-PADDING`：二级标题内边距
- `QUICK-EDIT:SUBSUBSECTION-LINE-COLOR`：四级标题竖线颜色
- `QUICK-EDIT:PAGE-MARGIN`：页边距
- `QUICK-EDIT:MAIN-FONT`：正文字号
- `QUICK-EDIT:CALLOUT-FONT`：Callout 字号
- `QUICK-EDIT:CALLOUT-COLOR`：Callout 配色
- `QUICK-EDIT:CODE-BLOCK`：代码块实现

---

## 常见问题

### Q1：中文乱码或编译失败

请确认使用 `xelatex`，不要使用 `pdflatex`。

### Q2：字体找不到

根据你本机字体调整 `computer-notes.cls` 字体配置。推荐优先安装常见中文字体（如思源系列）。

### Q3：目录没更新

连续编译两次：

```bash
xelatex example.tex
xelatex example.tex
```

### Q4：想调整页面密度

修改 `QUICK-EDIT:PAGE-MARGIN` 对应参数：

```latex
\def\cnMarginTop{2.2cm}
\def\cnMarginBottom{2.2cm}
\def\cnMarginLeft{2.2cm}
\def\cnMarginRight{2.2cm}
```

---

## 质量检查建议

- 编译 `example.tex` 并确认生成目录、书签、代码高亮
- 抽查 chapter/section/subsection/subsubsection 的样式与编号
- 抽查 7 种 Callout 与 `codeblock` 是否渲染正常

---

## 许可

免费使用、自由修改、欢迎分享。

如需继续维护，建议优先在 `computer-notes.cls` 的 QUICK-EDIT 标记附近调整参数，避免破坏整体风格一致性。

### computer-notes.cls 模块划分

| 部分 | 功能 |
|------|------|
| 第一部分 | 文档类基础配置 |
| 第二部分 | 宏包导入 (按功能分组) |
| 第三部分 | 全局参数定义 |
| 第四部分 | 页面几何配置 |
| 第五部分 | 四套字体系统 |
| 第六部分 | 标题样式 |
| 第七部分 | 页眉页脚 |
| 第八部分 | 正文与列表格式 |
| 第九部分 | 数学公式样式 |
| 第十部分 | 超链接与书签 |
| 第十一部分 | 封面与目录 |
| 第十二部分 | 7 种 Callout 框 |
| 第十三部分 | 代码块系统 |
| 第十四部分 | 行内代码与组件 |
| 第十五部分 | 其他实用命令 |

---

## 命名规范 (参考)

本模板遵守的命名规范：

```
\cn_fontsize_main         % 参数: 前缀 + 类型 + 名称
\cn_margin_left           % 参数: 前缀 + 类型 + 名称
color_accent              % 颜色: color_ + 描述
notebox                  % 环境: 类型 + box
\note{}, \tip{}, etc.    % 命令: 简洁英文
```

---

## 高级自定义

### 修改 Callout 边框宽度

编辑 `computer-notes.cls` 第十二部分，修改 `leftrule` 值：

```latex
leftrule = 6pt,  % 改成其他宽度
```

### 修改标题样式

编辑 `computer-notes.cls` 第六部分 `\titleformat` 命令。例如，移除装饰竖线：

```latex
\titleformat{\section}[hang]
  {\normalfont\sffamily\bfseries...}
  {}
  {0pt}
  {}  % 移除装饰逻辑
```

### 添加自定义命令

在文档开头（加载类之后）定义：

```latex
\documentclass{computer-notes}

\newcommand{\mycommand}[1]{
  \textbf{\textcolor{color_accent}{#1}}
}

\begin{document}
\mycommand{自定义命令}
\end{document}
```

---

## 许可与致谢

本模板基于 LaTeX 标准宏包（xeCJK、titlesec、fancyhdr、tcolorbox 等），参考了 elegantbook 等优秀模板的设计理念。

**免费使用、自由修改、欢迎fork与分享！**

---

## 反馈与改进

如发现 bug 或有功能建议，欢迎提出！

**最后祝你使用愉快！** 😊
