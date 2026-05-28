name: template-usage
description: 本技能文件基于 `99-索引与模板/TypstTemplate/computer-notes.typ` 的实现，列出模板的主要 API、使用示例与注意事项。
---


## 1. 模板导入与初始化

本技能基于 `computer-notes.typ` 的实际实现（见 `99-索引与模板/TypstTemplate/computer-notes.typ`）。入口文件（常为 `initial.typ` 或 `main.typ`）应按下列方式导入并调用模板：

```typst
#import "../../TypstTemplate/computer-notes.typ": *

#set document(
  title: "Document Title",
  author: "Violet",
  date: datetime.today(),
)

#show: apply-style
```

- 在 `chapters/` 子目录中的文件，导入路径一般需要再上一级：`../../../TypstTemplate/computer-notes.typ`。
- `#show: apply-style` 是模板提供的入口（模板定义 `apply-style(doc)` 并返回 `doc`），负责页面设置、标题渲染、页眉/页脚与计数器逻辑，必须保留。

---

## 2. 封面与目录（常用宏）

- `#make-cover(title, author, date: none)`：生成居中封面页，包含标题、作者与可选日期。例如：

```typst
#make-cover("Subject Name", "Violet", date: datetime.today().display())
```

- `#make-outline(depth)`：生成主目录页，`depth` 指定显示层级（如 `#make-outline(3)`）。
- `#part(title)`：生成单独的 Part 起始页，模板自动维护 `part-state`、`part-counter` 与右侧小目录（通常不需手动管理状态变量）。

---

## 3. 章节组织与包含规则

- 推荐结构：

```
Subject/
  initial.typ   # 入口（导入模板并调用 apply-style）
  references.bib
  img/
  chapters/
    chapter1.typ
```

- 章节文件以 `= Chapter Title` 开头，通过入口文件 `#include "chapters/xxx.typ"` 引入；不要单独编译章节文件，始终以入口编译。

---

## 4. 模板提供的常用组件（快速参考）

- Callout（提示）：`#note(...)`, `#tip(...)`, `#info(...)`, `#warning(...)`, `#caution(...)`, `#danger(...)`, `#todo(...)`。
- 算法框：`#algorithm(body)`，会渲染带标题的算法区块并使用主题色边框。
- 代码与终端：`#codeblock(lang, code)`（后备）和 `#terminal(command)`（深色终端样式）。模板优先使用 `codly` 美化代码块。
- 表格：`#tex-table(..rows)`（学术风格、仅横线）与 `#plain-table(..rows)`（完整网格），`#let default-table-style` 提供默认样式配置。
- 行内工具：`#file(path)`, `#emphasis(body)`, `#shortcut(keys)`, `#highlight[...]` 等。

这些都是 `computer-notes.typ` 中定义的 `#let`/`#show` 辅助宏，直接在笔记中调用。

---

## 5. 标题、编号与分页行为

- 模板定制了 `heading` 的显示：Level 1（Chapter）默认不显示编号并触发分页与计数器重置；Level 2/3 等显示局部编号（模板中由 `set heading(numbering: ...)` 控制）。
- 在 Chapter 开始时模板会重置 `figure/table/math.equation` 等计数器，确保图表与公式编号从 1 开始。

---

## 6. 表格、公式与数学渲染要点

- 含数学公式的表格单元格请使用中括号 `[...]` 包裹以保证正确渲染。
- 公式编号使用 `#eq[...]`，模板将编号格式为 `(章号.公式序号)`。
- 注意 Typst 的语法陷阱（裸下标、多字母变量等），参见 `typst-writing-conventions` 技能以获取更详细的写作规则。

---

## 7. 外部包与增强功能

- 如需使用额外包（例如 `@preview/xarrow`），请在章节文件顶部 `#import` 并以入口文件从仓库根目录编译。

---

## 8. 编译与校验建议

从仓库根目录运行：

```bash
typst compile "<path-to-initial.typ>" "<output.pdf>" --root .
```

- 使用 `--root .` 以允许模板跨目录读取资源。
- 若遇到 `cannot read file outside of project root`，确认当前工作目录为仓库根并传入 `--root .`。
- 首次编译可能因外部包下载而稍慢，确保联网或使用本地缓存。

---

## 9. 禁止与注意事项（必须遵守）

1. **不要修改** `99-索引与模板/TypstTemplate/computer-notes.typ` 的公共接口名称（如 `apply-style`、`make-cover` 等）。
2. **不要** 在笔记目录外创建包装目录（例如 `src/`、`content/`）。
3. **不要** 手动管理定理/图表/公式的编号（模板在 Chapter 开始时重置计数器）。
4. 始终在入口文件调用 `#show: apply-style`，不要直接编译章节文件。

如需更深更细的写作规则（数学风格、公式书写、下标处理等），请参阅 `typst-writing-conventions` 技能文件。

---

*** End Patch
