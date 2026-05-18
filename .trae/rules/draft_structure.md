---
name: draft_structure
description: CSNotes 注释目录（目录草稿）规范
---

## 注释目录（目录草稿）规范

### 位置

目录草稿位于 `main.typ` 文件中的注释区域。

### 格式

```typst
#part("主题名称")
// % Chapter 1: 章节名
// % Section 1.1: 节名
// % Section 1.2: 节名

#part("第二部分")
// % Chapter 2: 另一章节
// % Section 2.1: 节名
```

### 层级表示

- `// % Chapter X:` 表示 Chapter（二级）
- `// % Section X:` 表示 Section（三级）
- SubSection（四级及以下）不出现在目录草稿中

### 编写原则

1. **优先参考现有草稿**：如果 `main.typ` 中已有目录草稿，严格按其结构编写
2. **保持层级一致**：确保 Part → Chapter → Section 的逻辑递进关系清晰
3. **目录优化建议**：
   - 发现目录结构不合理时，先提出建议
   - 等待用户确认后再调整
   - 原则：合并过细的 Section，拆分过大的 Chapter

### 示例与设计思路

#### 通用技术栈示例
```typst
#part("基础篇")
// % Chapter 1: 概述
// % Section 1.1 定义
// % Section 1.2 特点
// % Section 1.3 应用场景

// % Chapter 2: 核心原理
// % Section 2.1 工作机制
// % Section 2.2 关键组件

#part("进阶篇")
// % Chapter 3: 高级特性
// % Section 3.1 配置选项
// % Section 3.2 最佳实践
```
