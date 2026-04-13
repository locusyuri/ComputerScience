// ╔════════════════════════════════════════════════════════════════════╗
// ║                                                                    ║
// ║             COMPUTER SCIENCE NOTES Typst 示例文档                   ║
// ║                      完整功能演示                                  ║
// ║                                                                    ║
// ║   编译: typst compile example.typ                                  ║
// ║   预览: typst watch example.typ                                    ║
// ║                                                                    ║
// ╚════════════════════════════════════════════════════════════════════╝

// 导入样式文件
#import "../TypstTemplate/computer-notes.typ": *


// ── 文档元信息 ──
#set document(
  title: "计算机科学笔记示例",
  author: "Violet",
  date: datetime.today(),
)

// 应用全局样式
#show: apply-style


// ══════════════════════════════════════════════════════════════════════
// 封面
// ══════════════════════════════════════════════════════════════════════

#make-cover(
  "计算机科学笔记示例",
  "Violet",
  date: datetime.today().display(),
)

// 目录
#make-outline(depth: 3)


// ══════════════════════════════════════════════════════════════════════
// 第一部分：模板基础与排版
// ══════════════════════════════════════════════════════════════════════

#part("第一部分：模板基础与排版")


// ── Chapter 1: 模板概述 ──
= 模板概述

== 设计目标

本模板旨在为计算机科学课程笔记提供一套统一、美观、易用的排版方案。模板集成了常见的排版需求，包括多级标题、代码高亮、提示框、表格和数学公式等，让笔记作者能够专注于内容创作，而非格式调整。

#note[
  本模板基于 Typst 构建，相较于 LaTeX，Typst 具有编译速度快、语法简洁、学习曲线平缓等优势。
]

模板的核心设计原则：

- #emphasis[一致性]：所有组件共享统一的配色方案和字体设置
- #emphasis[可复用性]：组件化设计便于在不同文档中重复使用
- #emphasis[语义化]：通过颜色和样式区分不同类型的内容


// ── Chapter 2: 标题层级 ──
= 标题层级

本模板提供了七级标题体系，每一级都有独特的视觉样式：

== 二级标题（Section）

二级标题用于划分文档的主要章节，样式为主题色背景的胶囊形状。

=== 三级标题（Subsection）

三级标题用于组织章节内的主要内容，样式为蓝色编号前缀。

==== 四级标题（Sub-subsection）

四级标题用于细分小节，左侧带有蓝色竖线装饰。

===== 五级标题（Paragraph）

五级标题用于标记独立的知识点，绿色加粗样式便于识别重点。

====== 六级标题（Subparagraph）

六级标题用于进一步细化内容，绿色常规样式。

#tip[
  建议实际使用时，最多使用到四级标题。过深的层级结构会增加阅读负担。
]


// ── Chapter 3: 文本样式 ──
= 文本样式

=== 行内强调

模板提供了多种行内强调方式：

- #emphasis[强调文字]：使用主题色和圆体字体，适合突出重点
- #emphasis[高亮文字]：带浅色背景，适合标记关键术语
- #file[src/main/App.java]：文件路径专用样式
- #shortcut[Ctrl + C]：模拟键盘按键

#warning[
  行内强调应适度使用，过多的强调会削弱其效果。建议每个段落不超过 2-3 处强调。
]

=== 数学公式

模板支持完整的数学公式排版：

集合框架的时间复杂度分析中，哈希表的查找复杂度接近 $O(1)$，而红黑树则为 $O(log n)$。

#set math.equation(numbering: "(1)")
$
  T(n) = T(n/2) + O(1) quad => quad T(n) = O(log n)
$

负载因子的定义：
$
  alpha = (n)/(m) = ("元素数量") / ("桶数量")
$

#fancy-divider


// ══════════════════════════════════════════════════════════════════════
// 第二部分：列表与表格
// ══════════════════════════════════════════════════════════════════════

#part("第二部分：列表与表格")


// ── Chapter 4: 列表样式 ──
= 列表样式

== 无序列表

一级无序列表用于罗列并列的要点：

- 数据结构是计算机科学的基础
- 算法设计需要考虑时间复杂度和空间复杂度
- 代码实现应当注重可读性和可维护性

二级列表适合展开说明：

- 函数式编程范式
  - 纯函数：不依赖外部状态
  - 不可变性：避免副作用
- 面向对象编程范式
  - 封装：隐藏实现细节
  - 继承：复用代码结构
  - 多态：统一接口多种实现

== 有序列表

有序列表适合表达步骤或流程：

+ 分析问题需求
+ 设计数据结构和算法
+ 编写代码实现
+ 编写单元测试
+ 优化性能

== Checklist 复选列表

Checklist 适合标记待办事项：

- [x] 完成模板基础功能
- [x] 实现代码高亮
- [ ] 添加更多代码语言支持
- [ ] 优化提示框样式
- [/] 完善示例文档
- [-] 移除废弃功能
- [\>] 向右箭头，表示下一步或前进
- [\<] 日历图标，表示日期或时间相关
- [\?] 问号，表示不确定或需要进一步调查
- [\!] 感叹号，表示重要或需要注意
- [\*] 星号，表示重点或收藏
- ["] 引号，表示引用或强调
- [l] 定位图标，表示位置相关
- [b] 书签图标，表示参考资料或链接
- [i] 信息图标，表示提示或说明
- [S] 钱袋图标，表示成本或预算
- [I] 灯泡图标，表示创意或建议
- [p] 赞图标，表示优点、认可或推荐
- [c] 踩图标，表示缺点、反对或不推荐
- [f] 火焰图标，表示热门或高优先级
- [k] 钥匙图标，表示关键点或解决方案
- [w] 奖杯图标，表示成就或完成
- [u] 向上箭头，表示提升或改进
- [d] 向下箭头，表示降低或放弃


== 树形列表

树形列表适合展示层次结构：

#v(0.3em)
#[
  #set list(marker: tree-marker)
  #show: tree-list
  - 算法分类
    - 排序算法
      - 比较排序
        - 快速排序
        - 归并排序
        - 堆排序
      - 非比较排序
        - 计数排序
        - 基数排序
    - 搜索算法
      - 二分查找
      - 哈希查找
    - 图算法
      - BFS
      - DFS
      - Dijkstra
]
#v(0.3em)

== 圆圈连接线列表

#circle-line-enum[
  + 分析问题规模，确定算法复杂度要求
    - 数据量大小
    - 实时性要求
  + 选择合适的数据结构
  + 设计算法逻辑
    + 编写伪代码
    + 验证边界条件
  + 实现并测试
]


// ── Chapter 5: 表格 ──
= 表格

== 快速表格

使用 `#plain-table` 创建无样式表格：
#plain-table(
  ("列1", "列2", "列3"),
  ("数据1", "数据2", "数据3"),
  ("数据4", "数据5", "数据6"),
  ("Data7", "Data8", "Data9"),
  ("Data10", "数据11", "Data12"),
)

使用 `#tex-table` 快速创建 tex 风格的表格：

#tex-table(
  ("语言", "特点", "典型应用"),
  ("Python", "简洁易学", "数据分析、AI"),
  ("Java", "跨平台、企业级", "后端开发"),
  ("JavaScript", "前端必备", "Web开发"),
  ("Rust", "安全高性能", "系统编程"),
)


== 复杂表格

复杂功能 (如单元格合并) 需要调用 `#table` 实现:

#align(center)[
  #table(
    columns: 4,
    align: center + horizon,
    stroke: color-border-light,
    fill: (col, row) => {
      if row < 2 { color-accent.lighten(85%) }
      else { white }
    },
    /* --- header --- */
    table.cell(rowspan: 2)[*姓名*], table.cell(colspan: 2)[*成绩*], table.cell(rowspan: 2)[*总分*],
    /* -------------- */
    /* --- sub-header --- */
    [*平时*], [*期末*],
    /* ----------------- */
    [张三], [85], [92], [177],
    [李四], [78], [88], [166],
    [王五], [90], [95], [185],
    [赵六], [82], [79], [161],
  )
]


// ══════════════════════════════════════════════════════════════════════
// 第三部分：提示框与代码
// ══════════════════════════════════════════════════════════════════════

#part("第三部分：提示框与代码")


// ── Chapter 6: 提示框 ──
= 提示框

== 提示框系统

模板内置了七种提示框，适用于不同的语义场景：

#note[
  笔记框用于补充说明、背景知识或记忆要点。本模板使用霞鹜文楷作为主要中文字体。添加更多文字以测试多行内容的显示效果和自动换行功能。
]

#tip[
  技巧框用于分享实践经验、优化建议或操作捷径。例如，使用 #shortcut[Alt + Tab] 快速切换窗口。
]

#info[
  信息框用于通用说明或背景知识。测试长内容时的自动换行效果。
]

#warning[
  警告框用于提醒可能出错或需要谨慎处理的情况。例如，删除操作不可恢复。
]

#caution[
  注意框用于强调容易忽略但影响较大的细节。如版本兼容性、数据迁移风险等。
]

#danger[
  危险框用于标记高风险操作或明确禁止的行为。执行前请务必确认后果。
]

#todo[
  待办框用于标记后续需要补充或完善的内容。可配合 Checklist 使用。
]

== 提示框使用建议

#tip[
  - 每种提示框的语义应当保持一致，不要混用
  - 避免在单个页面中使用过多提示框
  - 提示框内容应简洁明了，一针见血
]


// ── Chapter 7: 代码块 ──
= 代码块

== 基础代码块

模板使用 Codly 包实现代码语法高亮，支持 30+ 编程语言：

=== Java 示例

```java
import java.util.*;

public class QuickSort {
    public static void sort(int[] arr, int low, int high) {
        if (low < high) {
            int pi = partition(arr, low, high);
            sort(arr, low, pi - 1);
            sort(arr, pi + 1, high);
        }
    }
    
    private static int partition(int[] arr, int low, int high) {
        int pivot = arr[high];
        int i = low - 1;
        for (int j = low; j < high; j++) {
            if (arr[j] < pivot) {
                i++;
                swap(arr, i, j);
            }
        }
        swap(arr, i + 1, high);
        return i + 1;
    }
}
```

=== Python 示例

```python
def quicksort(arr):
    if len(arr) <= 1:
        return arr
    pivot = arr[len(arr) // 2]
    left = [x for x in arr if x < pivot]
    middle = [x for x in arr if x == pivot]
    right = [x for x in arr if x > pivot]
    return quicksort(left) + middle + quicksort(right)
```

=== JavaScript 示例

```javascript
const quicksort = (arr) => {
  if (arr.length <= 1) return arr;
  const pivot = arr[Math.floor(arr.length / 2)];
  const left = arr.filter(x => x < pivot);
  const middle = arr.filter(x => x === pivot);
  const right = arr.filter(x => x > pivot);
  return [...quicksort(left), ...middle, ...quicksort(right)];
};
```

=== Rust 示例

```rust
fn quicksort<T: Ord + Clone>(arr: &[T]) -> Vec<T> {
    if arr.len() <= 1 {
        return arr.to_vec();
    }
    let pivot = arr[arr.len() / 2].clone();
    let left: Vec<T> = arr.iter().filter(|x| **x < pivot).cloned().collect();
    let middle: Vec<T> = arr.iter().filter(|x| **x == pivot).cloned().collect();
    let right: Vec<T> = arr.iter().filter(|x| **x > pivot).cloned().collect();
    
    let mut result = quicksort(&left);
    result.extend(middle);
    result.extend(quicksort(&right));
    result
}
```

== 配置与标记语言

=== JSON 配置

```json
{
  "name": "computer-notes",
  "version": "1.0.0",
  "author": "Violet",
  "features": {
    "syntax-highlight": true,
    "auto-toc": true,
    "multiple-themes": false
  }
}
```

=== YAML 配置

```yaml
database:
  host: localhost
  port: 5432
  name: myapp
  
logging:
  level: info
  format: json
```

=== Dockerfile

```dockerfile
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

== 终端命令

终端样式适合展示命令行操作：

#terminal[git status]

#terminal[git commit -m "feat: add quicksort implementation"]

#terminal[docker compose up -d --build]


// ── Chapter 8: 算法与流程 ──
= 算法与流程

== 算法伪代码

#algorithm[
  快速排序算法：
  - 输入：数组 arr，左边界 low，右边界 high
  - 如果 low < high：
    - 选取基准元素 pivot = arr[high]
    - 划分：小于 pivot 的放左边，大于的放右边
    - 递归排序左右两部分
  - 输出：已排序的数组
]

== 综合示例

下面用一个小主题串起多个组件：

=== 选择排序的原则

在选择集合类型时，需要综合考虑以下因素：

#tex-table(
  ("场景", "推荐数据结构", "原因"),
  ("快速查找", "HashMap", "O(1) 时间复杂度"),
  ("有序遍历", "TreeMap", "自动维护顺序"),
  ("频繁插入删除", "LinkedList", "O(1) 操作"),
  ("去重计数", "HashSet", "自动去重"),
)

#warning[
  不要过早优化。在没有性能问题的情况下，应该优先选择实现简单、易于维护的数据结构。
]

具体选择时：

- 如果强调随机访问，优先考虑 *ArrayList* 或 *HashMap*
- 如果强调元素顺序，优先考虑 *TreeMap* 或 *LinkedList*
- 如果强调并发安全，优先考虑 *ConcurrentHashMap*

#emphasis[核心原则：根据实际需求选择最合适的数据结构，而非追求"最优"解决方案。]


// ══════════════════════════════════════════════════════════════════════
// 附录
// ══════════════════════════════════════════════════════════════════════

#part("附录")

// ── 附录 A: 样式速查 ──
= 样式速查

== 可用命令

#tex-table(
  ("命令", "用途", "示例"),
  (file("path"), "文件路径", file("src/main/App.java")),
  (emphasis[text], "高亮文字", emphasis[重点]),
  (emphasis("text"), "强调文字", emphasis("关键点")),
  (shortcut("keys"), "快捷键", shortcut("Ctrl + S")),
)

== 提示框类型

- #note[#text(size: 9pt)[`#note[内容]`: 笔记]]
- #tip[#text(size: 9pt)[`#tip[内容]`: 技巧]]
- #info[#text(size: 9pt)[`#info[内容]`: 信息]]
- #warning[#text(size: 9pt)[`#warning[内容]`: 警告]]
- #caution[#text(size: 9pt)[`#caution[内容]`: 注意]]
- #danger[#text(size: 9pt)[`#danger[内容]`: 危险]]
- #todo[#text(size: 9pt)[`#todo[内容]`: 待办]]

== 快捷键说明

- 编译文档：#shortcut[Ctrl + Shift + B]
- 预览文档：#shortcut[Ctrl + Shift + P]
- 格式化代码：#shortcut[Shift + Alt + F]


// ── 附录 B: 更新日志 ──
= 更新日志

== v1.0.0 (2026-04-05)

- 初始版本发布
- 实现七级标题体系
- 集成 Codly 代码高亮
- 添加七种提示框
- 支持表格
- 实现树形列表和圆圈连接线列表

#fancy-divider

本文档完
