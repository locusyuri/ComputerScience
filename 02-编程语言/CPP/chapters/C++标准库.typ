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

| 纯算法 | 优点 | 缺点 |
|--------|------|------|
| 快速排序 | 平均 $O("n log n")$，缓存友好 | 最坏 $O("n"^2)$，不稳定 |
| 堆排序 | 最坏 $O("n log n")$，稳定 | 缓存不友好，交换次数多 |
| 插入排序 | 对有序数据 $O(n)$，小规模高效 | 最坏 $O("n"^2)$ |

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

| 算法 | 稳定性 | 时间复杂度 | 适用场景 |
|------|--------|-----------|---------|
| `sort` | 不稳定 | O(n log n) | 通用排序，不关心稳定性 |
| `stable_sort` | 稳定 | O(n log² n) | 需要保持相等元素顺序 |
| `partial_sort` | - | O(n log k) | 只需要前 k 个有序元素 |
| `nth_element` | - | O(n) | 找中位数、分位数 |

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
