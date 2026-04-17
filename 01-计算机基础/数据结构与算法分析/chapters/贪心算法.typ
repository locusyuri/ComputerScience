#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= 贪心算法

#note[
  贪心算法是一种在每一步选择中都采取当前最优（或最有利）的选择，从而希望导致结果是全局最优的算法。
]

== 贪心算法的基本思想

贪心算法通过*局部最优选择*来构造全局最优解。

=== 核心特征

==== 贪心选择性质

可以通过*局部最优选择*来构造全局最优解。

*特点*：

- 做出选择后，问题规模缩小
- 不需要回溯或重新考虑之前的选择
- 依赖于问题的特定结构

==== 最优子结构

一个问题的最优解包含其子问题的最优解。

*示例*：

- 最短路径：从A到C的最短路径经过B，则A→B和B→C也都是最短路径
- 最小生成树：去掉一条边后，剩余部分仍然是子图的最小生成树

=== 贪心 vs 动态规划

#tex-table(
  ("特性", "贪心算法", "动态规划"),
  ("选择方式", "局部最优", "全局最优"),
  ("子问题", "只解决一次", "可能重复解决"),
  ("回溯", "不需要", "需要（隐式）"),
  ("适用性", "特定问题", "更广泛"),
  ("效率", "通常更高", "可能较低"),
)

#tip[
  贪心算法比动态规划更高效，但适用范围更窄。只有当问题具有贪心选择性质时才能使用。
]

=== 贪心的局限性

*反例*：0/1背包问题

```cpp
// 物品：(重量, 价值)
// A: (10, 60), B: (20, 100), C: (30, 120)
// 背包容量：50

// 贪心策略（按价值/重量比）：
// A: 6.0, B: 5.0, C: 4.0
// 选择A + B = 60 + 100 = 160

// 最优解：B + C = 100 + 120 = 220
```

*原因*：贪心选择可能导致无法达到全局最优

== 贪心算法的正确性证明

证明贪心算法的正确性通常使用以下方法。

=== 交换论证法（Exchange Argument）

*核心思想*：假设存在一个最优解，通过交换操作将其转换为贪心解，且不降低解的质量。

*步骤*：

1. 假设存在最优解 $O$
2. 如果 $O$ 与贪心解 $G$ 不同，找到第一个不同的选择
3. 通过交换操作将 $O$ 转换为 $G$
4. 证明交换后解的质量不降低
5. 因此 $G$ 也是最优解

*示例*：活动选择问题

```cpp
// 按结束时间排序后，贪心选择最早结束的活动
// 证明：如果最优解选择了其他活动，可以交换为贪心选择
//       且不会减少可选择的活动数量
```

=== 数学归纳法

*核心思想*：证明贪心选择后，剩余子问题的最优解加上贪心选择构成原问题的最优解。

*步骤*：

1. *基准情况*：问题规模为1时，贪心选择显然最优
2. *归纳假设*：假设对于规模 $n-1$ 的问题，贪心算法得到最优解
3. *归纳步骤*：证明对于规模 $n$ 的问题，贪心选择 + 子问题最优解 = 原问题最优解

#note[
  交换论证法更直观，数学归纳法更严谨。实际应用中常结合使用。
]

== 区间类问题

区间问题是贪心算法的经典应用场景。

=== 活动选择问题

*问题*：从 $n$ 个活动中选择最多的互不冲突的活动。

*贪心策略*：按结束时间排序，选择最早结束且与已选活动不冲突的活动。

```cpp
struct Activity {
    int start, end;
};

int maxActivities(vector<Activity>& acts) {
    // 按结束时间排序
    sort(acts.begin(), acts.end(),
         [](const Activity& a, const Activity& b) {
             return a.end < b.end;
         });

    int count = 1;
    int lastEnd = acts[0].end;

    for (int i = 1; i < acts.size(); ++i) {
        if (acts[i].start >= lastEnd) {
            count++;
            lastEnd = acts[i].end;
        }
    }

    return count;
}
```

*时间复杂度*：$O(n log n)$（排序）

=== 区间调度

*问题*：给定多个区间，选择最少的点使得每个区间至少包含一个点。

*贪心策略*：按右端点排序，每次选择当前区间的右端点。

```cpp
int minPoints(vector<pair<int, int>>& intervals) {
    sort(intervals.begin(), intervals.end(),
         [](const pair<int,int>& a, const pair<int,int>& b) {
             return a.second < b.second;
         });

    int points = 1;
    int lastPoint = intervals[0].second;

    for (int i = 1; i < intervals.size(); ++i) {
        if (intervals[i].first > lastPoint) {
            points++;
            lastPoint = intervals[i].second;
        }
    }

    return points;
}
```

=== 区间覆盖

*问题*：用最少的区间覆盖目标区间 $[0, T]$。

*贪心策略*：每次选择能覆盖当前位置且右端点最远的区间。

== 背包类问题

=== 分数背包问题

*问题*：物品可以分割，求最大价值。

*贪心策略*：按单位重量价值排序，优先选择价值密度高的物品。

```cpp
struct Item {
    int weight;
    int value;
    double ratio() const {
        return (double)value / weight;
    }
};

double fractionalKnapsack(vector<Item>& items, int capacity) {
    // 按价值密度排序
    sort(items.begin(), items.end(),
         [](const Item& a, const Item& b) {
             return a.ratio() > b.ratio();
         });

    double totalValue = 0;
    int remaining = capacity;

    for (const auto& item : items) {
        if (remaining <= 0) break;

        if (item.weight <= remaining) {
            // 全部装入
            totalValue += item.value;
            remaining -= item.weight;
        } else {
            // 部分装入
            totalValue += item.ratio() * remaining;
            remaining = 0;
        }
    }

    return totalValue;
}
```

*时间复杂度*：$O(n log n)$

#note[
  分数背包可以用贪心，但0/1背包必须用动态规划。
]

== 哈夫曼编码

哈夫曼编码是贪心算法构造最优前缀码的经典应用。

=== 基本原理

*目标*：为字符集构造变长编码，使得平均编码长度最短。

*贪心策略*：每次合并频率最小的两个节点。

=== 构造过程

```cpp
struct HuffmanNode {
    char ch;
    int freq;
    HuffmanNode *left, *right;

    HuffmanNode(char c, int f) : ch(c), freq(f), left(nullptr), right(nullptr) {}
};

HuffmanNode* buildHuffmanTree(map<char, int>& freqMap) {
    // 最小堆
    auto cmp = [](HuffmanNode* a, HuffmanNode* b) {
        return a->freq > b->freq;
    };
    priority_queue<HuffmanNode*, vector<HuffmanNode*>, decltype(cmp)> pq(cmp);

    // 初始化
    for (auto& [ch, freq] : freqMap) {
        pq.push(new HuffmanNode(ch, freq));
    }

    // 贪心合并
    while (pq.size() > 1) {
        HuffmanNode* left = pq.top(); pq.pop();
        HuffmanNode* right = pq.top(); pq.pop();

        HuffmanNode* newNode = new HuffmanNode('\0', left->freq + right->freq);
        newNode->left = left;
        newNode->right = right;
        pq.push(newNode);
    }

    return pq.top();
}
```

*时间复杂度*：$O(n log n)$

=== 编码示例

```
字符: a(45), b(13), c(12), d(16), e(9), f(5)

哈夫曼树:
        100
       /   \
     a(45)  55
           /  \
         c(12)  43
               /  \
             b(13)  30
                   /  \
                 e(9) f(5)

d(16) 未显示，实际会更复杂

编码:
a: 0
b: 101
c: 100
d: 111
e: 1101
f: 1100
```

#tip[
  哈夫曼编码广泛应用于文件压缩（ZIP、GZIP）、图像压缩（JPEG）等。
]

== 其他经典贪心问题

=== 硬币找零

*问题*：用最少的硬币凑出指定金额。

*贪心策略*：优先使用面额最大的硬币。

```cpp
int minCoins(vector<int>& coins, int amount) {
    sort(coins.rbegin(), coins.rend()); // 降序

    int count = 0;
    for (int coin : coins) {
        count += amount / coin;
        amount %= coin;
    }

    return amount == 0 ? count : -1;
}
```

*注意*：仅当硬币面额满足特定条件时贪心才正确（如美分系统）。

=== 任务调度

*问题*：最大化完成任务的数量或总价值。

*贪心策略*：

- 最大化数量：按截止时间排序
- 最大化价值：按价值密度排序

#fancy-divider

本章介绍了贪心算法的基本思想、正确性证明方法以及经典应用。贪心算法虽然简单高效，但需要仔细验证其正确性，避免陷入局部最优的陷阱。
