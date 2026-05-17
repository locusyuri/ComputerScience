#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= STL容器

== 概述

*C++ STL 容器有以下重要特点：*
- *索引从 0 开始*：第一个元素是 `nums[0]`，最后一个是 `nums[nums.size() - 1]`
- *`[]` 不做边界检查*：访问越界会导致未定义行为
- *`at()` 会做边界检查*：越界会抛出 `std::out_of_range` 异常，更安全
- *迭代器遍历*：除了索引，还可以用迭代器遍历容器

== 顺序容器

=== vector

动态数组是 `vector` 的核心特性，内存连续性使其支持 $O(1)$ 随机访问

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

#tex-table(
  ([类型], [支持操作], [容器示例]),
  ([Input/Output], [`++`, `*`], [-]),
  ([Forward], [`++`, 多次解引用], [`forward_list`]),
  ([Bidirectional], [`++`, `--`], [`list`, `set`, `map`]),
  ([RandomAccess], [`++`, `--`, `+`, `-`, `[]`], [`vector`, `deque`]),
  ([Contiguous], [内存连续], [`vector`, `array`, `string`]),
)

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

== 通用操作

下面的操作*适用于所有 STL 容器*：

#tex-table(
  ([方法], [功能], [示例]),
  ([构造函数], [创建容器], [`vector<int> v;`]),
  ([`size()`], [返回元素数量], [`v.size();`]),
  ([`empty()`], [判断容器是否为空], [`if (v.empty()) ...`]),
  ([`clear()`], [清空所有元素], [`v.clear();`]),
  ([迭代器操作], [遍历元素], [`for (auto it = v.begin(); ...)`]),
  ([`swap(c2)`], [交换两个容器内容], [`v1.swap(v2);`]),
  ([比较运算符], [`==`, `!=`, `<` 等], [`if (v1 == v2) ...`]),
)

```cpp
#include <vector>
#include <list>
#include <set>
#include <iostream>

// 1. 构造函数
std::vector<int> v1;                // 空容器
std::vector<int> v2(5);             // 5 个默认值元素
std::vector<int> v3{1, 2, 3, 4, 5}; // 初始化列表

// 2. size()：返回元素数量
std::cout << "Size: " << v3.size() << std::endl;  // 输出：5

// 3. empty()：判断容器是否为空
if (v1.empty()) {
    std::cout << "v1 is empty" << std::endl;
}

// 4. clear()：清空所有元素
v3.clear();
std::cout << "After clear, size: " << v3.size() << std::endl;  // 输出：0

// 5. 迭代器遍历
std::list<int> lst{10, 20, 30};
for (auto it = lst.begin(); it != lst.end(); ++it) {
    std::cout << *it << " ";
}
// 范围 for 循环（C++11）
for (int x : lst) {
    std::cout << x << " ";
}

// 6. swap()：交换两个容器内容
std::vector<int> a{1, 2, 3};
std::vector<int> b{4, 5, 6};
a.swap(b);  // a = {4,5,6}, b = {1,2,3}

// 7. 比较运算符
if (a == b) {
    std::cout << "a and b are equal" << std::endl;
} else if (a < b) {
    std::cout << "a is less than b" << std::endl;
}
```



=== 序列容器专用接口

#tex-table(
  ([方法], [功能], [支持容器]),
  ([`front()`], [访问首元素], [除 `array` 外所有]),
  ([`back()`], [访问尾元素], [除 `forward_list` 外]),
  ([`push_back(x)`], [尾部插入元素], [除 `array`/`forward_list` 外]),
  ([`pop_back()`], [删除尾部元素], [除 `array`/`forward_list` 外]),
  ([`insert(pos, x)`], [指定位置插入], [所有序列容器]),
  ([`erase(pos)`], [删除指定元素], [所有序列容器]),
  ([`[]` 和 `at(i)`], [随机访问元素], [`vector`/`deque`/`array`]),
)

```cpp
// 序列容器专用接口示例
#include <vector>
#include <deque>
#include <list>
#include <array>
#include <forward_list>
#include <iostream>

// 1. front()：访问首元素
std::vector<int> vec{1, 2, 3, 4, 5};
std::cout << "vec.front() = " << vec.front() << std::endl;  // 输出：1

std::list<int> lst{10, 20, 30};
std::cout << "lst.front() = " << lst.front() << std::endl;  // 输出：10

// 2. back()：访问尾元素（forward_list 不支持）
std::deque<int> dq{100, 200, 300};
std::cout << "dq.back() = " << dq.back() << std::endl;  // 输出：300

// 3. push_back()：尾部插入元素
vec.push_back(6);           // vec = {1,2,3,4,5,6}
dq.push_back(400);          // dq = {100,200,300,400}
lst.push_back(40);          // lst = {10,20,30,40}

// 4. pop_back()：删除尾部元素
vec.pop_back();             // vec = {1,2,3,4,5}
dq.pop_back();             // dq = {100,200,300}

// 5. insert()：指定位置插入
auto insert_it = vec.insert(vec.begin() + 2, 99);  // 在索引 2 处插入 99
// vec = {1,2,99,3,4,5}

lst.insert(std::next(lst.begin(), 1), 15);  // 在第2个位置插入 15
// lst = {10,15,20,30,40}

// 6. erase()：删除指定元素
auto erase_it = vec.erase(vec.begin() + 2);  // 删除索引 2 的元素
// vec = {1,2,3,4,5}

lst.erase(std::next(lst.begin(), 1));  // 删除第2个元素
// lst = {10,20,30,40}

// 7. [] 和 at()：随机访问（仅 vector/deque/array）
std::array<int, 5> arr{1, 2, 3, 4, 5};
std::cout << "arr[2] = " << arr[2] << std::endl;       // 输出：3（无边界检查）
std::cout << "arr.at(3) = " << arr.at(3) << std::endl; // 输出：4（有边界检查）

vec[0] = 100;              // 修改第一个元素
try {
    vec.at(10) = 0;        // 抛出 std::out_of_range 异常
} catch (const std::out_of_range& e) {
    std::cout << "Out of range: " << e.what() << std::endl;
}

// 8. deque 专用：push_front() / pop_front()
dq.push_front(50);         // dq = {50,100,200,300}
dq.pop_front();            // dq = {100,200,300}

// 9. list/forward_list 专用操作
std::list<int> lst1{1, 2, 3};
std::list<int> lst2{4, 5, 6};

// splice：移动元素
lst1.splice(lst1.end(), lst2);  // lst1 = {1,2,3,4,5,6}, lst2 为空

// merge：合并两个有序链表（需先排序）
std::list<int> a{1, 3, 5};
std::list<int> b{2, 4, 6};
a.merge(b);  // a = {1,2,3,4,5,6}, b 为空

// remove：删除指定值的所有元素
a.remove(3);  // a = {1,2,4,5,6}
```

*特殊操作：*
- `list`/`forward_list`：`splice()`、`merge()`、`remove()`
- `deque`：`push_front()`、`pop_front()`

=== 关联容器专用接口

#tex-table(
  ([方法], [功能], [示例]),
  ([`find(key)`], [查找元素], [`auto it = s.find(42);`]),
  ([`count(key)`], [统计 key 出现次数], [`if (m.count("id") > 0) ...`]),
  ([`lower_bound(k)`], [返回第一个 ≥key 的位置], [有序容器专用]),
  ([`upper_bound(k)`], [返回第一个 >key 的位置], [有序容器专用]),
  ([`equal_range(k)`], [返回 key 的区间范围], [有序容器专用]),
)

以下是常用接口的详细示例：

```cpp
#include <set>
#include <map>
#include <iostream>

// set 的查找操作
std::set<int> s = {1, 3, 5, 7, 9};

// find(key)：查找等于 key 的元素
// - 找到：返回指向该元素的迭代器，通过 *it 解引用获取元素值
// - 没找到：返回容器的 end() 迭代器（尾后迭代器，表示无效位置）
auto it = s.find(5);
if (it != s.end()) {           // 判断是否找到
    std::cout << "Found: " << *it << std::endl;  // 解引用迭代器获取元素，输出: Found: 5
} else {
    std::cout << "Not found" << std::endl;
}

// count(key)：统计 key 出现次数（set 中只能是 0 或 1）
if (s.count(3)) {
    std::cout << "3 exists in set" << std::endl;
}

// lower_bound(k)：返回第一个 ≥key 的位置
auto lb = s.lower_bound(4);  // 指向 5
std::cout << "First >= 4: " << *lb << std::endl;  // 输出: 5

// upper_bound(k)：返回第一个 >key 的位置
auto ub = s.upper_bound(5);  // 指向 7
std::cout << "First > 5: " << *ub << std::endl;    // 输出: 7

// equal_range(k)：返回 key 的区间 [lower_bound, upper_bound)
auto range = s.equal_range(5);
for (auto it = range.first; it != range.second; ++it) {
    std::cout << *it << " ";  // 输出: 5
}
```

*multiset 的范围查找：*

```cpp
std::multiset<int> ms = {1, 2, 2, 2, 3};

// 在 multiset 中查找所有等于 2 的元素
auto range = ms.equal_range(2);
for (auto it = range.first; it != range.second; ++it) {
    std::cout << *it << " ";  // 输出: 2 2 2
}
```

*`map`/`unordered_map` 特有操作：*

```cpp
#include <map>
#include <unordered_map>

std::map<std::string, int> m;

// 下标访问：不存在则插入默认值
m["one"] = 1;              // 插入 {"one", 1}
int val = m["two"];        // 插入 {"two", 0}，返回 0

// emplace：直接构造元素，避免拷贝
m.emplace("three", 3);     // 构造 pair<const string, int>

// insert：插入 pair
m.insert({"four", 4});

// 遍历 map
for (const auto& pair : m) {
    std::cout << pair.first << ": " << pair.second << std::endl;
}

// 结构化绑定（C++17）
for (const auto& [key, value] : m) {
    std::cout << key << ": " << value << std::endl;
}
```

=== 无序容器专用接口

#tex-table(
  ([方法], [功能]),
  ([`bucket_count()`], [返回桶数量]),
  ([`load_factor()`], [返回负载因子（元素数/桶数）]),
  ([`rehash(n)`], [设置桶数量为 n]),
  ([`reserve(n)`], [预留至少 n 个元素的空间]),
)

无序容器基于哈希表实现，提供了桶管理和负载因子相关的操作：

```cpp
#include <unordered_set>
#include <unordered_map>
#include <iostream>

// unordered_set 的基本操作
std::unordered_set<int> us = {10, 20, 30, 40, 50};

// bucket_count()：返回桶数量
std::cout << "Bucket count: " << us.bucket_count() << std::endl;

// load_factor()：返回负载因子（元素数/桶数）
std::cout << "Load factor: " << us.load_factor() << std::endl;

// max_load_factor()：返回/设置最大负载因子
std::cout << "Max load factor: " << us.max_load_factor() << std::endl;
us.max_load_factor(0.7);  // 设置最大负载因子为 0.7

// rehash(n)：重新分配桶数量为 n
us.rehash(100);
std::cout << "After rehash, bucket count: " << us.bucket_count() << std::endl;

// reserve(n)：预留至少 n 个元素的空间（会自动计算所需桶数）
us.reserve(1000);
```

*桶操作示例：*

```cpp
// bucket(key)：返回 key 所在的桶索引
size_t bucket_idx = us.bucket(30);
std::cout << "30 is in bucket: " << bucket_idx << std::endl;

// bucket_size(n)：返回第 n 个桶中的元素数量
std::cout << "Bucket " << bucket_idx << " size: " << us.bucket_size(bucket_idx) << std::endl;
```

*unordered_map 的哈希策略调整：*

```cpp
std::unordered_map<std::string, int> um;

// 预分配桶数，避免频繁扩容
um.reserve(1000);

// 调整负载因子平衡性能与内存
um.max_load_factor(0.8);

// 插入大量元素
for (int i = 0; i < 500; ++i) {
    um["key" + std::to_string(i)] = i;
}

std::cout << "Elements: " << um.size() << std::endl;
std::cout << "Buckets: " << um.bucket_count() << std::endl;
std::cout << "Load factor: " << um.load_factor() << std::endl;
```

*性能提示：*
- 合理设置 `reserve()` 可减少哈希表扩容次数
- 负载因子越小，哈希碰撞概率越低，但内存占用越大
- 默认最大负载因子通常为 1.0，可根据场景调整

== 容器选择指南

#tex-table(
  ([容器], [适用场景]),
  ([`vector`], [需要动态调整大小的数组，频繁随机访问元素]),
  ([`deque`], [需要在两端频繁插入和删除元素的场景]),
  ([`list`], [需要频繁插入和删除元素，但不需要随机访问的场景]),
  ([`forward_list`], [需要节省内存空间的单向链表场景]),
  ([`array`], [大小固定且已知的数组场景]),
  ([`set`], [需要存储唯一元素并进行排序的场景]),
  ([`multiset`], [需要存储重复元素并进行排序的场景]),
  ([`map`], [需要存储键值对并通过键快速查找值的场景]),
  ([`multimap`], [需要存储键值对，允许一个键映射到多个值的场景]),
  ([`unordered_set`], [需要快速查找唯一元素的场景]),
  ([`unordered_multiset`], [需要快速查找重复元素的场景]),
  ([`unordered_map`], [需要快速查找键值对的场景]),
  ([`unordered_multimap`], [需要快速查找键值对，允许一个键映射到多个值的场景]),
)

== Java 集合框架 vs C++ STL 容器

#plain-table(
  ([维度], [Java 集合框架 (JCF)], [C++ STL 容器]),
  ([核心理念], [面向对象 OOP], [泛型编程 GP]),
  ([基础架构], [基于接口和类的继承], [基于模板和值语义]),
  ([多态实现], [运行时多态（接口 `Collection`、`Map`）], [编译时多态（模板机制）]),
  ([内存管理], [GC 自动管理], [RAII 手工管理]),
  ([异常机制], [统一异常处理], [不强制异常]),
)

*C++ STL 容器设计特点：*
- *零继承关系*：通过模板和命名约定统一接口
- *迭代器统一访问*：所有容器使用相同的遍历方式
- *内存管理分离*：通过 allocator 模板参数控制内存分配
- *异常安全*：大多数操作提供基本异常保证

```cpp
// 泛型遍历示例
template<typename Container>
void print(const Container& c) {
    for (auto it = c.begin(); it != c.end(); ++it)
        std::cout << *it << " ";
}
```

= STL算法

== 算法分类概述

STL 算法根据是否修改元素可分为三大类：

- *非修改式算法*：不修改容器元素，仅读取或查找
- *修改式算法*：修改容器元素值或顺序
- *排序与关联算法*：排序、二分查找、集合操作

所有算法均定义在 `<algorithm>` 头文件中。

== 非修改式算法

=== 查找算法

```cpp
std::vector<int> v = {1, 2, 3, 4, 5, 3};

// find：查找第一个等于值的元素
auto it = std::find(v.begin(), v.end(), 3);  // 指向第一个 3

// find_if：查找第一个满足条件的元素
auto even = std::find_if(v.begin(), v.end(), [](int x) { return x % 2 == 0; });

// find_if_not：查找第一个不满足条件的元素
auto odd = std::find_if_not(v.begin(), v.end(), [](int x) { return x % 2 == 0; });
```

=== 计数算法

```cpp
// count：统计等于值的元素个数
int cnt = std::count(v.begin(), v.end(), 3);  // 返回 2

// count_if：统计满足条件的元素个数
int even_cnt = std::count_if(v.begin(), v.end(), [](int x) { return x % 2 == 0; });
```

=== 遍历算法

```cpp
// for_each：对每个元素执行操作
std::for_each(v.begin(), v.end(), [](int& x) { x *= 2; });

// all_of：所有元素满足条件返回 true
bool all_positive = std::all_of(v.begin(), v.end(), [](int x) { return x > 0; });

// any_of：任一元素满足条件返回 true
bool has_even = std::any_of(v.begin(), v.end(), [](int x) { return x % 2 == 0; });

// none_of：所有元素都不满足条件返回 true
bool no_negative = std::none_of(v.begin(), v.end(), [](int x) { return x < 0; });
```

=== 搜索子序列

```cpp
std::vector<int> pattern = {2, 3};

// search：在序列中查找子序列
auto pos = std::search(v.begin(), v.end(), pattern.begin(), pattern.end());

// search_n：查找连续 n 个满足条件的元素
auto three_consecutive = std::search_n(v.begin(), v.end(), 3, 1);
```


== 修改式算法

=== 变换算法

```cpp
std::vector<int> src = {1, 2, 3, 4};
std::vector<int> dst(4);

// transform：对元素进行变换并存储到另一个序列
std::transform(src.begin(), src.end(), dst.begin(), [](int x) { return x * x; });

// replace：替换等于值的元素
std::replace(v.begin(), v.end(), 3, 0);

// replace_if：替换满足条件的元素
std::replace_if(v.begin(), v.end(), [](int x) { return x < 0; }, 0);
```

=== 复制与移动

```cpp
// copy：复制元素到目标序列
std::copy(src.begin(), src.end(), std::back_inserter(dst));

// copy_if：复制满足条件的元素
std::copy_if(src.begin(), src.end(), std::back_inserter(dst),
             [](int x) { return x % 2 == 0; });

// move：移动元素（C++11）
std::vector<std::string> src_str = {"a", "b", "c"};
std::vector<std::string> dst_str;
std::move(src_str.begin(), src_str.end(), std::back_inserter(dst_str));
```

=== 填充与生成

```cpp
// fill：填充指定值
std::fill(v.begin(), v.end(), 0);

// fill_n：填充前 n 个元素
std::fill_n(v.begin(), 3, 1);

// generate：用生成器填充
int i = 0;
std::generate(v.begin(), v.end(), [&i]() { return ++i; });

// generate_n：生成前 n 个元素
std::generate_n(std::back_inserter(v), 5, []() { return rand() % 100; });
```

=== 删除算法

```cpp
// remove：移除等于值的元素（实际不删除，返回新末尾）
auto new_end = std::remove(v.begin(), v.end(), 3);
v.erase(new_end, v.end());  // 真正删除

// remove_if：移除满足条件的元素
auto new_end = std::remove_if(v.begin(), v.end(), [](int x) { return x % 2 == 0; });
v.erase(new_end, v.end());

// unique：移除连续重复元素
std::sort(v.begin(), v.end());
auto new_end = std::unique(v.begin(), v.end());
v.erase(new_end, v.end());
```

== 排序与搜索算法

=== 排序算法

排序算法是 STL 中最常用的算法之一，掌握它们的区别和适用场景至关重要。

==== std::sort

`std::sort` 是 STL 中最常用的排序函数，用于对指定范围内的元素进行排序。

===== 函数签名与重载

`std::sort` 提供三个重载版本：

```cpp
// 1. 使用默认比较器（operator<），升序排列
template<class RandomIt>
void sort(RandomIt first, RandomIt last);

// 2. 使用自定义比较器
template<class RandomIt, class Compare>
void sort(RandomIt first, RandomIt last, Compare comp);

// 3. C++20 起：使用默认比较器，指定执行策略
template<class ExecutionPolicy, class RandomIt>
void sort(ExecutionPolicy&& policy, RandomIt first, RandomIt last);

// 4. C++20 起：使用自定义比较器 + 执行策略
template<class ExecutionPolicy, class RandomIt, class Compare>
void sort(ExecutionPolicy&& policy, RandomIt first, RandomIt last, Compare comp);
```

*执行策略*（C++17/20）：
- `std::execution::seq`：顺序执行
- `std::execution::par`：并行执行
- `std::execution::par_unseq`：并行且向量化

```cpp
#include <execution>

std::vector<int> v = {3, 1, 4, 1, 5, 9, 2, 6};

// C++17 并行排序（多核加速）
std::sort(std::execution::par, v.begin(), v.end());
```

===== 迭代器要求

`std::sort` 要求 RandomAccessIterator（随机访问迭代器），这是最高级的迭代器类型。

*支持的容器*：
- `std::vector`
- `std::deque`
- `std::array`
- 普通数组（通过指针）

*不支持*：
- `std::list`（双向迭代器，不支持随机访问）
- `std::set`、`std::map`（关联容器，本身有序）
- `std::forward_list`（单向迭代器）

```cpp
// ✅ 支持的用法
std::vector<int> v = {3, 1, 4};
std::sort(v.begin(), v.end());

int arr[] = {3, 1, 4};
std::sort(std::begin(arr), std::end(arr));

// ❌ 不支持的用法
std::list<int> lst = {3, 1, 4};
std::sort(lst.begin(), lst.end());  // 编译错误！
// 正确做法：lst.sort()（list 自带的成员函数）
```

===== 底层算法：内省排序（Introsort）

`std::sort` 的底层实现采用*内省排序*（Introsort），这是一种混合排序算法，结合了多种排序算法的优点。

*算法流程*：

```
内省排序
├── 阶段 1：快速排序（Quick Sort）
│   └── 当递归深度 < 2 × log₂n 时使用
├── 阶段 2：堆排序（Heap Sort）
│   └── 当递归深度超过阈值时切换，避免最坏情况
└── 阶段 3：插入排序（Insertion Sort）
    └── 当分区大小 ≤ 16 时使用，优化小规模数据
```

*为什么选择内省排序？*

#tex-table(
  ([纯算法], [优点], [缺点]),
  ([快速排序], [平均 $O(n log n)$，缓存友好], [最坏 $O(n^2)$，不稳定]),
  ([堆排序], [最坏 $O(n log n)$，稳定], [缓存不友好，交换次数多]),
  ([插入排序], [对有序数据 $O(n)$，小规模高效], [最坏 $O(n^2)$]),
)

内省排序综合了快速排序的平均性能和堆排序的最坏情况保障。

===== 比较器（Compare）

比较器可以是函数指针、函数对象或 Lambda 表达式。

*返回类型要求*：`bool comp(const T& a, const T& b)`
- 返回 `true` 表示 `a` 应排在 `b` 之前

*常用比较器*：

```cpp
std::vector<int> v = {3, 1, 4, 1, 5};

// 1. std::greater（降序）
std::sort(v.begin(), v.end(), std::greater<int>());
// 结果：{5, 4, 3, 1, 1}

// 2. std::less（显式升序，默认）
std::sort(v.begin(), v.end(), std::less<int>());
// 结果：{1, 1, 3, 4, 5}

// 3. Lambda 表达式
std::sort(v.begin(), v.end(), [](int a, int b) { return a > b; });
// 结果：{5, 4, 3, 1, 1}

// 4. 自定义结构（按绝对值排序）
std::vector<int> nums = {-3, 1, -4, 1, -5, 9, 2, -6};
std::sort(nums.begin(), nums.end(),
          [](int a, int b) { return std::abs(a) < std::abs(b); });
// 结果：{1, 1, 2, -3, -4, -5, -6, 9}
```

*稳定排序需求*：若需要保持相等元素顺序，应使用 `std::stable_sort`。

===== 复杂度分析

- *时间复杂度*：平均 $O("n log n")$，最坏 $O("n log n")$
- *空间复杂度*：$O("log n")$（递归调用栈）
- *交换次数*：约 $n log n$ 次

```cpp
// 验证复杂度：对不同规模数据计时
std::vector<int> v(1000000);
// 填充随机数据...
auto start = std::chrono::high_resolution_clock::now();
std::sort(v.begin(), v.end());
auto end = std::chrono::high_resolution_clock::now();
// n = 10⁶ 时，约 100-200ms（取决于硬件）
```

===== 注意事项

1. *就地排序*：直接修改原序列，不返回新容器

2. *不稳定*：相等元素的相对顺序可能改变
  ```cpp
  std::vector<std::pair<int, std::string>> v = {
      {1, "a"}, {2, "b"}, {1, "c"}
  };
  std::sort(v.begin(), v.end(),
            [](auto& a, auto& b) { return a.first < b.first; });
  // 结果可能是：{1, "c"}, {1, "a"}, {2, "b"}
  // 或：{1, "a"}, {1, "c"}, {2, "b"}
  ```

3. *要求可交换*：元素类型必须满足 `MoveConstructible` 和 `MoveAssignable`

4. *异常安全*：C++11 起，要求比较器不抛出异常

==== std::stable_sort

`std::stable_sort` 保证*稳定排序*，即相等元素的相对顺序保持不变。

*特点：*
- *稳定排序*：保持相等元素的原始顺序
- *时间复杂度*：`O(n log² n)`，若有足够额外内存则 `O(n log n)`
- *适用场景*：需要保持原有顺序的排序场景

```cpp
std::vector<std::pair<int, std::string>> data = {
    {2, "apple"}, {1, "banana"}, {2, "cherry"}, {1, "date"}
};

// 按第一个元素排序，保持相等元素的相对顺序
std::stable_sort(data.begin(), data.end(),
                 [](const auto& a, const auto& b) { return a.first < b.first; });
// 结果：{{1, "banana"}, {1, "date"}, {2, "apple"}, {2, "cherry"}}
// "banana" 在 "date" 之前，"apple" 在 "cherry" 之前，保持原始顺序
```

==== std::partial_sort

`std::partial_sort` 只对序列的前 `n` 个元素进行排序，其余元素位置不确定。

*特点：*
- *部分排序*：只保证前 n 个元素有序且为最小的 n 个元素
- *时间复杂度*：`O(n log k)`，其中 k 是需要排序的元素数量
- *适用场景*：只关心前几名的场景（如取 Top K）

```cpp
std::vector<int> nums = {3, 1, 4, 1, 5, 9, 2, 6};

// 将最小的 3 个元素排序放到前 3 个位置
std::partial_sort(nums.begin(), nums.begin() + 3, nums.end());
// 结果：{1, 1, 2, 4, 5, 9, 3, 6}
// 前 3 个元素是最小的且有序，后面元素顺序不确定
```

==== std::nth_element

`std::nth_element` 使第 n 个位置的元素处于"正确"位置（即排序后该位置应有的元素）。

*特点：*
- *选择算法*：第 n 个元素左边都 ≤ 它，右边都 ≥ 它
- *时间复杂度*：平均 `O(n)`
- *适用场景*：快速找到中位数或分位数

```cpp
std::vector<int> nums = {3, 1, 4, 1, 5, 9, 2, 6};

// 使第 2 个位置（0-based）的元素处于正确位置
std::nth_element(nums.begin(), nums.begin() + 2, nums.end());
// 结果：{1, 1, 2, 3, 5, 9, 4, 6}
// nums[2] = 2 是第 3 小的元素，左边都 ≤ 2，右边都 ≥ 2

// 找到中位数
std::nth_element(nums.begin(), nums.begin() + nums.size()/2, nums.end());
int median = nums[nums.size()/2];
```

==== 排序算法对比

#tex-table(
  ([算法], [稳定性], [时间复杂度], [适用场景]),
  ([`sort`], [不稳定], [$O(n log n)$], [通用排序，不关心稳定性]),
  ([`stable_sort`], [稳定], [$O(n log n)$], [需要保持相等元素顺序]),
  ([`partial_sort`], [-], [$O(n log k)$], [只需要前 k 个有序元素]),
  ([`nth_element`], [-], [$O(n)$], [找中位数、分位数]),
)

*选择建议：*
- 一般情况用 `std::sort`
- 需要稳定排序用 `std::stable_sort`
- 只需要前几名用 `std::partial_sort`
- 找中位数或分位数用 `std::nth_element`（效率最高）

=== 二分查找（要求序列已排序）

```cpp
std::vector<int> sorted = {1, 2, 3, 4, 5, 6, 7};

// binary_search：判断元素是否存在
bool found = std::binary_search(sorted.begin(), sorted.end(), 4);

// lower_bound：返回第一个 >= 值的位置
auto lb = std::lower_bound(sorted.begin(), sorted.end(), 4);

// upper_bound：返回第一个 > 值的位置
auto ub = std::upper_bound(sorted.begin(), sorted.end(), 4);

// equal_range：返回等于值的范围 [lower_bound, upper_bound)
auto range = std::equal_range(sorted.begin(), sorted.end(), 4);
```

=== 集合操作（要求序列已排序）

```cpp
std::vector<int> a = {1, 2, 3, 4, 5};
std::vector<int> b = {4, 5, 6, 7, 8};
std::vector<int> result;

// merge：合并两个有序序列
std::merge(a.begin(), a.end(), b.begin(), b.end(), std::back_inserter(result));

// set_union：求并集
std::set_union(a.begin(), a.end(), b.begin(), b.end(), std::back_inserter(result));

// set_intersection：求交集
std::set_intersection(a.begin(), a.end(), b.begin(), b.end(), std::back_inserter(result));

// set_difference：求差集
std::set_difference(a.begin(), a.end(), b.begin(), b.end(), std::back_inserter(result));
```

== 数值算法

数值算法定义在 `<numeric>` 头文件中。

=== 累加与内积

```cpp
std::vector<int> nums = {1, 2, 3, 4, 5};

// accumulate：累加求和
int sum = std::accumulate(nums.begin(), nums.end(), 0);  // 初始值为 0

// accumulate with custom operation
int product = std::accumulate(nums.begin(), nums.end(), 1, std::multiplies<int>());

// inner_product：内积（点积）
std::vector<int> a = {1, 2, 3};
std::vector<int> b = {4, 5, 6};
int dot = std::inner_product(a.begin(), a.end(), b.begin(), 0);  // 1*4 + 2*5 + 3*6 = 32
```

=== 前缀和与相邻差

```cpp
std::vector<int> v = {1, 2, 3, 4, 5};
std::vector<int> result(v.size());

// partial_sum：前缀和
std::partial_sum(v.begin(), v.end(), result.begin());  // {1, 3, 6, 10, 15}

// adjacent_difference：相邻元素差
std::adjacent_difference(v.begin(), v.end(), result.begin());  // {1, 1, 1, 1, 1}
```

== C++20 范围接口（Ranges）

C++20 引入了范围概念，简化算法调用：

```cpp
#include <ranges>

std::vector<int> nums = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};

// 范围适配器
auto even_squares = nums | std::views::filter([](int x) { return x % 2 == 0; })
                         | std::views::transform([](int x) { return x * x; });

// 范围算法（C++20）
std::ranges::sort(nums);
std::ranges::for_each(nums, [](int x) { std::cout << x << ' '; });
```

常用范围适配器：
- `views::filter`：过滤元素
- `views::transform`：变换元素
- `views::take`：取前 n 个元素
- `views::drop`：跳过前 n 个元素
- `views::reverse`：反转序列
- `views::split`：分割序列

= 智能指针与内存管理

= 常用库组件
