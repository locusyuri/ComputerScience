#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= 集合框架


== 集合类概述

Java 集合框架用于统一管理数据集合，核心目标是：统一操作接口、屏蔽底层实现差异、提供可组合的遍历与算法能力。

#info[
	图示占位：这里应有“Java 集合框架概览图（Collection / List / Set / Map 及常见实现类）”。
]

=== 分类与定位

- 单列集合：以 `Collection` 为根（如 `List`、`Set`）
- 双列集合：以 `Map` 为根（键值对结构）

=== 常见实现类速览

#tex-table(
	("实现类", "底层结构", "核心特点", "典型场景"),
	("ArrayList", "动态数组", "随机访问快，尾插高效", "读多写少"),
	("LinkedList", "双向链表", "中间插删更友好", "频繁插删"),
	("HashSet", "哈希表", "去重快、通常无序", "成员判重"),
	("TreeSet", "红黑树", "自动排序", "有序去重"),
	("HashMap", "哈希表", "查询快", "通用键值存储"),
	("TreeMap", "红黑树", "按键有序", "范围查询"),
)

#note[
	`List` 与 `Set` 的关键区别：
	- `List`：有序、可重复、可按索引访问
	- `Set`：元素唯一、通常不按索引访问
]


== List 接口与实现

=== List 接口特点

`List` 是有序集合，允许重复元素，支持按索引访问。

#tex-table(
	("方法", "作用", "备注"),
	("add(E e)", "末尾添加元素", "可重复"),
	("get(int index)", "按索引读取", "随机访问"),
	("set(int index, E e)", "替换元素", "返回旧值"),
	("remove(int index)", "按索引删除", "后续元素前移"),
	("subList(int from, int to)", "截取子列表", "左闭右开"),
)

==== Collection 基础方法（父接口）

#tex-table(
	("方法", "描述", "注意点"),
	("add", "添加元素", "返回是否成功"),
	("remove", "删除匹配元素", "通常删首个匹配"),
	("contains", "是否包含元素", "依赖 equals"),
	("size", "元素个数", ""),
	("iterator", "获取迭代器", "遍历入口"),
	("toArray", "转数组", ""),
)

=== ArrayList

`ArrayList` 底层是动态数组，特点是读取快、扩容有成本。

==== 核心特征

1. 随机访问 `O(1)`
2. 末尾追加均摊 `O(1)`
3. 中间插删通常 `O(n)`（涉及元素搬移）

```java
List<String> names = new ArrayList<>();
names.add("Alice");
names.add("Bob");
names.add(1, "Tom");
System.out.println(names.get(0));
System.out.println(names);
```

=== LinkedList

`LinkedList` 底层是双向链表，支持头尾快速操作，也实现了 `Deque`。

==== 核心特征

1. 头尾插删效率高
2. 中间插删更友好（定位后修改链接）
3. 按索引随机访问慢（需要遍历）

```java
LinkedList<Integer> queue = new LinkedList<>();
queue.addLast(10);
queue.addLast(20);
queue.addFirst(5);
System.out.println(queue.removeFirst());
System.out.println(queue);
```

=== Vector 与 Stack

`Vector` 是早期线程安全动态数组实现，整体性能通常不如 `ArrayList`。`Stack` 基于 `Vector`，遵循 LIFO。

#tip[
	新代码中栈结构优先考虑 `ArrayDeque`，通常更轻量、性能更好。
]

=== ArrayList 与 LinkedList 对比

#tex-table(
	("对比项", "ArrayList", "LinkedList"),
	("底层结构", "动态数组", "双向链表"),
	("随机访问", "快（O(1)）", "慢（O(n)）"),
	("中间插删", "慢（搬移元素）", "相对更合适"),
	("内存特性", "连续空间，缓存友好", "节点额外指针开销"),
	("典型场景", "读多写少", "频繁插删"),
)


== Set 接口与实现

`Set` 的核心语义是“不重复”。重复判定依赖 `equals()` 与 `hashCode()`（哈希实现）或比较器（有序树实现）。

=== HashSet

基于哈希表，通常无序，查找/插入/删除平均接近 `O(1)`。

=== LinkedHashSet

在哈希结构上维护插入顺序，适合“去重 + 保序”。

=== TreeSet

基于红黑树，自动排序，复杂度通常 `O(log n)`。

==== TreeSet 常用有序方法

#tex-table(
	("方法", "作用"),
	("first() / last()", "取首尾元素"),
	("pollFirst() / pollLast()", "取并删首尾元素"),
	("headSet(to)", "小于 to 的子集"),
	("subSet(from, to)", "区间子集"),
	("tailSet(from)", "大于等于 from 的子集"),
)

=== Set 实现对比

#tex-table(
	("实现", "有序性", "复杂度", "null", "场景"),
	("HashSet", "通常无序", "平均 O(1)", "支持", "快速去重"),
	("LinkedHashSet", "按插入顺序", "平均 O(1)", "支持", "去重并保序"),
	("TreeSet", "按比较规则", "O(log n)", "默认不支持（依赖比较器）", "有序集合"),
)


== Map 接口与实现

`Map` 保存键值映射，键唯一，值可重复。

=== Map 常用方法

#tex-table(
	("方法", "作用"),
	("put", "新增/覆盖键值"),
	("get", "按 key 查 value"),
	("remove", "删除映射"),
	("containsKey", "是否存在 key"),
	("entrySet", "遍历键值对"),
)

=== HashMap

`HashMap` 是最常用实现，JDK 8 起底层可概括为“数组 + 链表 + 红黑树”。

==== 关键参数

#tex-table(
	("参数", "默认值", "说明"),
	("initialCapacity", "16", "初始桶数量（2 的幂）"),
	("loadFactor", "0.75", "触发扩容阈值比例"),
	("TREEIFY_THRESHOLD", "8", "链表树化阈值"),
	("UNTREEIFY_THRESHOLD", "6", "树退化阈值"),
	("MIN_TREEIFY_CAPACITY", "64", "最小树化容量"),
)

==== put 流程（简化）

1. 计算 key 哈希并定位桶
2. 桶为空则直接插入
3. 桶非空则处理冲突（链表/树）
4. 超阈值触发扩容或树化

```java
Map<String, Integer> scores = new HashMap<>();
scores.put("Java", 95);
scores.put("Python", 92);
scores.put(null, 100);
System.out.println(scores.get("Java"));
```

#warning[
	作为 key 的自定义对象，必须正确重写 `equals()` 与 `hashCode()`，否则可能出现“放得进去、取不出来”。
]

==== 图示占位：HashMap 底层结构

#info[
	图示占位：这里应有“HashMap 数组-桶-链表-红黑树结构图”。
]

=== LinkedHashMap

在 HashMap 基础上维护双向链表，支持插入顺序或访问顺序。

```java
Map<Integer, String> cache = new LinkedHashMap<>(4, 0.75f, true) {
		@Override
		protected boolean removeEldestEntry(Map.Entry<Integer, String> eldest) {
				return size() > 3;
		}
};
```

==== 图示占位：LRU 访问顺序

#info[
	图示占位：这里应有“LinkedHashMap(accessOrder=true) 的 LRU 淘汰示意图”。
]

=== TreeMap

基于红黑树，按 key 有序，范围查询友好，复杂度通常 `O(log n)`。

=== HashMap 1.7 vs 1.8（面试高频）

#tex-table(
	("维度", "JDK 1.7", "JDK 1.8"),
	("结构", "数组+链表", "数组+链表+红黑树"),
	("插入", "头插法", "尾插法"),
	("扩容迁移", "重新计算更重", "迁移路径优化"),
	("并发风险", "可能出现环链死循环", "修复环链问题但仍非线程安全"),
)


== ConcurrentHashMap 原理

=== 为什么 HashMap 不能直接并发用

1. 并发写可能数据覆盖
2. 历史版本扩容存在环链风险
3. 复合操作（先判再改）非原子

=== JDK 1.7 与 1.8 的并发实现差异

#tex-table(
	("版本", "核心机制", "锁粒度", "特点"),
	("JDK 1.7", "Segment 分段锁", "段级", "并发度受段数影响"),
	("JDK 1.8", "CAS + synchronized", "桶级", "并发度更高"),
)

=== 选型建议

- 高并发键值存储优先 `ConcurrentHashMap`
- 读多写少列表可考虑 `CopyOnWriteArrayList`


== 集合遍历与 fail-fast

=== Iterator / ListIterator / Spliterator

#tex-table(
	("接口", "能力", "典型场景"),
	("Iterator", "单向遍历 + 删除当前", "通用遍历"),
	("ListIterator", "双向遍历 + 就地增删改", "List 增强遍历"),
	("Spliterator", "可拆分遍历", "Stream 并行支撑"),
)

=== fail-fast 机制

普通集合迭代器通常会在检测到结构性并发修改时抛 `ConcurrentModificationException`。

```java
List<Integer> list = new ArrayList<>(List.of(1, 2, 3));
for (Integer x : list) {
		if (x == 2) {
				list.remove(x); // 可能触发 ConcurrentModificationException
		}
}
```

#note[
	fail-fast 是“尽早暴露误用”的机制，不等价于线程安全保障。
]

=== 安全修改建议

1. 遍历中删除优先 `Iterator.remove()`
2. 条件删除优先 `removeIf()`
3. 并发场景改用并发容器


== 多线程集合类

=== 并发集合速查

#tex-table(
	("集合", "特点", "适用场景"),
	("ConcurrentHashMap", "高并发键值读写", "缓存、路由表"),
	("CopyOnWriteArrayList", "读无锁，写复制", "读多写少配置"),
	("ConcurrentSkipListMap", "并发有序映射", "有序并发访问"),
	("LinkedBlockingQueue", "阻塞 FIFO", "生产者-消费者"),
	("ArrayBlockingQueue", "有界阻塞队列", "限流缓冲"),
)

=== 普通集合 vs 并发集合

#tex-table(
	("场景", "推荐"),
	("单线程", "ArrayList / HashMap"),
	("高并发读写", "ConcurrentHashMap"),
	("读多写少", "CopyOnWriteArrayList"),
	("任务队列", "BlockingQueue 系列"),
)


== 深拷贝

=== 深拷贝与浅拷贝

- 浅拷贝：复制外层对象，内部引用共享
- 深拷贝：递归复制内部引用对象

=== 常见实现方式

==== 构造函数复制

优点是可控、类型安全；缺点是对象层级深时代码冗长。

==== clone() 重写

需实现 `Cloneable`，并在引用字段上继续深拷贝。

==== 序列化/反序列化复制

可借助 Commons Lang、Gson、Jackson 等，开发效率高，但需关注性能与类型约束。

#tex-table(
	("方式", "优点", "缺点", "适用"),
	("构造函数", "显式可控", "模板代码多", "小中型对象"),
	("clone", "JDK 原生", "易误用浅拷贝", "中等复杂度"),
	("序列化", "实现快", "性能开销较大", "工具化场景"),
)


== 补充说明

=== 正确重写 equals 与 hashCode

放入哈希集合（`HashSet`/`HashMap`）的自定义对象，必须满足：

1. `equals` 相等的对象，`hashCode` 必须相等
2. 同一次运行期间，不变字段对应的 `hashCode` 应保持稳定

```java
public class Person {
		private String name;
		private int age;

		@Override
		public boolean equals(Object o) {
				if (this == o) return true;
				if (o == null || getClass() != o.getClass()) return false;
				Person p = (Person) o;
				return age == p.age && Objects.equals(name, p.name);
		}

		@Override
		public int hashCode() {
				return Objects.hash(name, age);
		}
}
```

=== 集合选型经验法则

#tex-table(
	("需求", "首选"),
	("按索引随机访问", "ArrayList"),
	("频繁头尾操作", "ArrayDeque / LinkedList"),
	("快速去重", "HashSet"),
	("去重并保序", "LinkedHashSet"),
	("有序键值查询", "TreeMap"),
	("高并发键值", "ConcurrentHashMap"),
)

=== 时间复杂度参考

#tex-table(
	("操作", "ArrayList", "LinkedList", "HashMap", "TreeMap"),
	("添加", "均摊 O(1)", "O(1)", "平均 O(1)", "O(log n)"),
	("删除", "O(n)", "按索引/值通常 O(n)", "平均 O(1)", "O(log n)"),
	("查找", "O(1) 按索引", "O(n)", "平均 O(1)", "O(log n)"),
)

=== 不可变集合与只读视图

很多同学会把“不可变集合”和“只读视图”混为一谈，二者并不等价：

1. `List.of()` / `Set.of()` / `Map.of()` 返回真正不可变集合
2. `Collections.unmodifiableList(x)` 返回的是“只读视图”，底层 `x` 变了，视图也会变

```java
List<String> src = new ArrayList<>(List.of("A", "B"));
List<String> view = Collections.unmodifiableList(src);
src.add("C");
System.out.println(view); // [A, B, C]

List<String> imm = List.of("X", "Y");
// imm.add("Z"); // UnsupportedOperationException
```

#warning[
	对外暴露集合时，若要求“状态绝对不可被修改”，优先返回拷贝后的不可变集合，而不是只读视图。
]

=== Map 遍历性能建议

遍历 `Map` 时通常优先 `entrySet()`，避免“先遍历 key 再 get(value)”的重复查找开销。

```java
// 推荐
for (Map.Entry<String, Integer> e : map.entrySet()) {
	String k = e.getKey();
	Integer v = e.getValue();
}

// 次优（会重复哈希查找）
for (String k : map.keySet()) {
	Integer v = map.get(k);
}
```

=== 常见易错点清单

1. 在 `for-each` 中直接调用集合自身 `remove()`，触发 `ConcurrentModificationException`
2. 自定义对象做 `HashMap` key 却未同时重写 `equals/hashCode`
3. 误把 `LinkedList` 当作高性能随机访问容器
4. 并发场景继续使用 `HashMap` / `ArrayList` 做共享可变状态
5. 误以为 `unmodifiable*` 返回的是“深层不可变对象”


== 总结

掌握集合框架的关键不是背类名，而是理解这几个维度：

1. 底层结构（数组/链表/哈希/树/跳表）
2. 复杂度特征（时间与空间）
3. 语义特征（有序、可重复、null 支持）
4. 并发特征（线程安全与迭代一致性）

#emphasis[一句话：先看访问模式，再选数据结构，最后看并发与可维护性。]
