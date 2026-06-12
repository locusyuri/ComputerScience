---
name: computer-notes_components
description:  computer-notes 模板常用组件用法
---

## computer-notes 模板常用组件
更多请参考 `99-索引与模板/TypstTemplate/example.typ`。

### 表格

- 水平线表格：`#tex-table(...)`
- 完整网格表格 `#plain-table(...)`
- **严禁使用 Markdown 表格语法** `| xxx |`

格式示例：
```typst
#tex-table(
  ([表头1], [表头2], [表头3]),
  ([数据1], [数据2], [数据3]),
  ([数据4], [数据5], [数据6]),
)
```

### 提示框

- `#note[]`、`#tip[]`
- `#warning[]`、`#caution[]`、`#danger[]`
- `#info[]`、`#todo[]`

### 其他组件

- **终端命令**：`#terminal[命令]`
- **分隔线**：`#fancy-divider`