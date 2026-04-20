---
description: 根据 main.typ 中的目录草稿，为每个 Part 创建对应的章节文件并引入
---

# Python 笔记目录生成流程

## 任务说明

当用户要求为某个编程语言或技术栈生成笔记目录时，执行以下步骤：

## 执行步骤

### 1. 分析 main.typ 中的目录草稿

- 查找 `main.typ` 文件中注释形式的目录草稿（以 `//` 开头）
- 识别 Part、Chapter、Section 三级结构
- 确认每个 Part 包含哪些 Chapter

### 2. 为每个 Part 创建章节文件

**文件命名原则**：
- 简短、清晰、符合文件命名规范
- 不需要严格对应 Part 名称，可以简化
- 示例：
  - "Python 核心基础" → `Python基础.typ`
  - "标准库与常用工具" → `标准库.typ`
  - "工程化与最佳实践" → `工程化.typ`

**文件内容**：
```typst
#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= Chapter 1 标题

= Chapter 2 标题

= Chapter 3 标题
```

**注意事项**：
- 只写一级标题（`= Chapter 标题`），不写 Section
- 每个文件顶部必须引入模板（注意相对路径）
- 从 `chapters/` 目录向上三级到达模板目录

### 3. 在 main.typ 中添加 include 语句

在每个 `#part()` 后面添加对应的 `#include`：

```typst
#part("Part 名称")
#include "chapters/文件名.typ"
```

**格式要求**：
- Part 和 include 之间无空行
- 不同 Part 之间可以有空行分隔

### 4. 验证文件

- 检查所有创建的文件是否有语法错误
- 确认相对路径正确
- 确认 include 语句已添加

## 示例

假设 main.typ 中有以下目录草稿：

```typst
// Part 1：Python 核心基础
// Chapter 1：入门与环境搭建
// Chapter 2：基础语法

// Part 2：高级特性
// Chapter 1：装饰器
// Chapter 2：生成器
```

则执行：

1. 创建 `chapters/Python基础.typ`：
```typst
#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= 入门与环境搭建

= 基础语法
```

2. 创建 `chapters/高级特性.typ`：
```typst
#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= 装饰器

= 生成器
```

3. 更新 main.typ：
```typst
#part("Python 核心基础")
#include "chapters/Python基础.typ"

#part("高级特性")
#include "chapters/高级特性.typ"
```

## 关键原则
（除非用户有特殊要求）
1. **一个 Part 一个文件**：每个 Part 对应一个 `.typ` 文件 
2. **只写 Chapter 标题**：文件中只包含一级标题（`= Chapter`）
3. **相对路径正确**：模板引用使用 `../../../99-索引与模板/TypstTemplate/computer-notes.typ`
4. **文件名简洁**：不需要完全对应 Part 名称，简短清晰即可
5. **先创建文件，再更新 main**：确保所有文件存在后再添加 include
