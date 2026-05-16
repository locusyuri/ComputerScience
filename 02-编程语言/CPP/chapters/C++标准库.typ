#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= STL容器

== 顺序容器

=== vector

动态数组是 `vector` 的核心特性，内存连续性使其支持 O(1) 随机访问

```cpp
std::vector<int> v;
v.reserve(100);           // 预先分配 capacity，避免多次扩容
v.emplace_back(1);         // 原地构造，避免拷贝
v.push_back(2);           // 拷贝或移动构造
```

`reserve()` 只改变容量不改变大小，`resize()` 同时改变大小

=== deque

分段连续结构，逻辑上连续但物理上不连续。头部插入 `push_front()` 效率高于 `vector`

```cpp
std::deque<int> d;
d.push_front(1);           // O(1) 头部插入
d.push_back(2);           // O(1) 尾部插入
```

deque 在插入元素时可能触发迭代器重置，但其分段特性避免了整体扩容

=== list

双向链表，`list` 在任意位置插入删除都是 O(1)，但不支持下标访问

```cpp
std::list<int> lst = {1, 2, 3};
lst.insert(next(lst.begin()), 10);  // 获取迭代器需要 O(n)
```

`forward_list` 是单向链表，更紧凑，`insert_after` 和 `erase_after` 操作更高效

=== array

固定大小数组，在栈上分配，无需动态内存管理

```cpp
std::array<int, 4> arr = {1, 2, 3, 4};  // 聚合初始化
arr.fill(0);                             // 全部填充为 0
```

== 关联容器

=== set / multiset

基于红黑树实现，元素自动排序。`set` 要求元素唯一，`multiset` 允许重复

```cpp
std::set<int> s = {3, 1, 4, 1, 5, 9};  // 自动排序：1, 3, 4, 5, 9
auto it = s.find(3);                    // O(log n) 查找
s.lower_bound(3);                       // 第一个不小于 3 的迭代器
s.upper_bound(3);                       // 第一个大于 3 的迭代器
```

=== map / multimap

键值对容器，`map` 键唯一，`multimap` 键可重复。支持下标访问（`map` 独有）

```cpp
std::map<std::string, int> m;
m["one"] = 1;                            // 下标访问，不存在则插入
m.emplace("two", 2);                     // 原地构造 pair
auto it = m.find("one");                 // 查找键
```

== 无序容器（C++11）

=== unordered_set / unordered_map

哈希表实现，平均 O(1) 查找和插入，但最坏情况 O(n)

```cpp
std::unordered_map<std::string, int> um;
um.reserve(1000);                        // 预分配桶数
um.max_load_factor(0.7);                 // 调整负载因子
um.rehash(100);                          // 重新分配桶数
```

自定义哈希函数和键相等函数：

```cpp
struct MyHash {
    size_t operator()(int v) const { return std::hash<int>{}(v); }
};
std::unordered_set<int, MyHash> hs;
```

=== 哈希函数与碰撞处理

标准库为内置类型提供 `std::hash`，自定义类型需特化或提供函数对象。哈希碰撞通过链地址法（separate chaining）处理

== 容器适配器

=== stack

后进先出（LIFO），默认基于 `deque` 实现，可指定 `vector` 或 `list`

```cpp
std::stack<int> s;
s.push(1);
s.emplace(2);
s.top();                                 // 访问栈顶
s.pop();                                 // 弹出栈顶
```

=== queue

先进先出（FIFO），默认基于 `deque` 实现

```cpp
std::queue<int> q;
q.push(1);
q.front();                               // 访问队首
q.back();                                // 访问队尾
```

=== priority_queue

基于堆结构实现，默认最大堆，可自定义比较器变为最小堆

```cpp
std::priority_queue<int> pq;             // 最大堆
std::priority_queue<int, std::vector<int>, std::greater<int>> min_pq;  // 最小堆
```

== 容器迭代器

=== 迭代器类型

| 类型 | 支持操作 | 容器示例 |
|------|---------|---------|
| Input/Output | `++`, `*` | - |
| Forward | `++`, 多次解引用 | `forward_list` |
| Bidirectional | `++`, `--` | `list`, `set`, `map` |
| RandomAccess | `++`, `--`, `+`, `-`, `[]` | `vector`, `deque` |
| Contiguous | 内存连续 | `vector`, `array`, `string` |

=== 迭代器失效

- 扩容失效（L1）：`vector`、`string` 扩容时，所有迭代器失效
- 删除失效（L2）：删除操作会使该位置之后的迭代器失效

```cpp
// 安全删除：使用 erase 返回值更新迭代器
for (auto it = v.begin(); it != v.end(); ) {
    if (*it % 2 == 0) {
        it = v.erase(it);  // erase 返回下一个有效迭代器
    } else {
        ++it;
    }
}
```

=== 反向迭代器

```cpp
std::vector<int> v = {1, 2, 3, 4, 5};
for (auto it = v.rbegin(); it != v.rend(); ++it) {
    // 反向遍历：5, 4, 3, 2, 1
}

auto it = v.rbegin();
auto base_it = it.base();  // 转换为正向迭代器，位置差一
```

= STL算法

= 智能指针与内存管理

= 常用库组件
