#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= 动态规划

动态规划（Dynamic Programming，简称 DP）是一种用于解决复杂优化问题的算法思想，它通过将问题分解为相互重叠的子问题，并存储子问题的解（避免重复计算）来高效解决问题。

#note[
  动态规划基于两个重要概念：*最优子结构*和*重叠子问题*。
]

== 基本概念

=== 核心思想

动态规划的核心在于以下两个关键性质：

- *最优子结构*: 一个问题的最优解包含其子问题的最优解。这意味着我们可以通过组合子问题的最优解来构造原问题的最优解。
- *重叠子问题*: 在递归求解过程中，相同的子问题会被多次计算。动态规划通过存储这些子问题的解（记忆化），避免了重复计算。

=== 基本步骤

解决动态规划问题通常遵循以下步骤:

+ *定义状态*：找出问题中的变量，用状态表示子问题的解
+ *确定状态转移方程*：建立不同状态之间的关系（递推公式）
+ *设置初始条件*：确定最简单子问题的解（边界条件）
+ *确定计算顺序*：自底向上或自顶向下地计算所有状态
+ *构造最优解*：通过记录的信息重建最优解

#tip[
  判断一个问题是否适合用动态规划解决：看它是否具有最优子结构和重叠子问题两个特征。
]

== 线性 DP

线性DP 是动态规划中最基础的一类，具有以下特点：

- 状态转移只依赖前面的有限状态（通常为前一个状态）
- 问题状态可以表示为一维数组
- 时间复杂度通常为 $O(n)$ 的问题

=== 经典问题

==== 最长递增子序列（LIS）

最长递增子序列（Longest Increasing Subsequence）问题是指在一个给定的整数序列 `nums` 中，找到最长的严格递增子序列的长度。

*状态定义*：设 `dp[i]` 表示以 `nums[i]` 结尾的最长递增子序列的长度。

*状态转移方程*：对于每个 `i`，遍历 `j` 从 `0` 到 `i-1`：如果 `nums[j] < nums[i]`，则更新 `dp[i]`：$d p[i] = max(d p[i], d p[j] + 1)$

*初始条件*：每个元素自身可以作为长度为 1 的递增子序列，因此 `dp[i] = 1` 对所有 `i`。

```cpp
int lengthOfLIS(vector<int>& nums) {
    if (nums.empty()) return 0;
    int n = nums.size();
    vector<int> dp(n, 1); // 初始化 dp 数组，长度为 1

    for (int i = 1; i < n; ++i) {
        for (int j = 0; j < i; ++j) {
            if (nums[j] < nums[i]) {
                dp[i] = max(dp[i], dp[j] + 1);
            }
        }
    }

    return *max_element(dp.begin(), dp.end()); // 返回最长递增子序列的长度
}
```

#note[
  该算法的时间复杂度为 $O(n^2)$。可以使用二分查找优化到 $O(n log n)$。
]

==== 最大子数组和（Kadane's Algorithm）

最大子数组和（Maximum Subarray Sum）问题是指在一个给定的整数数组 `nums` 中，找到一个连续子数组（至少包含一个元素），使得该子数组的和最大。

*状态定义*：设 `dp[i]` 表示以 `nums[i]` 结尾的最大子数组和。

*状态转移方程*：$d p[i] = max(n u m s[i], d p[i-1] + n u m s[i])$，即要么选择当前元素作为新的子数组开始，要么将当前元素加入到之前的子数组中。

*初始条件*：$d p[0] = n u m s[0]$。

```cpp
int maxSubArray(vector<int>& nums) {
    if (nums.empty()) return 0;
    int n = nums.size();
    vector<int> dp(n);
    dp[0] = nums[0];
    int maxSum = dp[0];

    for (int i = 1; i < n; ++i) {
        dp[i] = max(nums[i], dp[i - 1] + nums[i]);
        maxSum = max(maxSum, dp[i]);
    }

    return maxSum; // 返回最大子数组和
}
```

#tip[
  Kadane 算法可以进一步优化空间复杂度到 $O(1)$，只需要维护一个变量即可。
]

==== 打家劫舍（House Robber）

打家劫舍（House Robber）问题是指在一个给定的整数数组 `nums` 中，表示每个房屋中的金额，要求在不触动相邻房屋警报器的情况下，计算能够抢劫到的最高金额。

*状态定义*：设 `dp[i]` 表示抢劫到第 `i` 个房屋时能够获得的最高金额。

*状态转移方程*：$d p[i] = max(d p[i-1], d p[i-2] + n u m s[i])$，即要么不抢第 `i` 个房屋，金额为 `dp[i-1]`，要么抢第 `i` 个房屋，金额为 `dp[i-2] + nums[i]`。

*初始条件*：$d p[0] = n u m s[0]$，$d p[1] = max(n u m s[0], n u m s[1])$。

```cpp
int rob(vector<int>& nums) {
    if (nums.empty()) return 0;
    int n = nums.size();
    if (n == 1) return nums[0];
    
    vector<int> dp(n);
    dp[0] = nums[0];
    dp[1] = max(nums[0], nums[1]);

    for (int i = 2; i < n; ++i) {
        dp[i] = max(dp[i - 1], dp[i - 2] + nums[i]);
    }

    return dp[n - 1]; // 返回最高金额
}
```

==== 斐波那契数列

计算第 n 个斐波那契数：$F(0)=0, F(1)=1, F(n)=F(n-1)+F(n-2)$

*自顶向下（记忆化递归）*

```java
// 记忆化数组
private static Map<Integer, Integer> memo = new HashMap<>();

public static int fibonacci(int n) {
    // 边界条件
    if (n <= 1) {
        return n;
    }

    // 如果已经计算过，则直接返回
    if (memo.containsKey(n)) {
        return memo.get(n);
    }

    // 计算并存储结果
    int result = fibonacci(n - 1) + fibonacci(n - 2);
    memo.put(n, result);
    return result;
}
```

- 时间复杂度：$O(n)$（因为每个值只计算一次）
- 空间复杂度：$O(n)$（用于存储递归调用栈和记忆化数组）

*自底向上（迭代）*

```java
public static int fibonacci(int n) {
    // 边界条件
    if (n <= 1) {
        return n;
    }

    // 定义数组存储计算结果
    int[] dp = new int[n + 1];
    dp[0] = 0;
    dp[1] = 1;

    // 从第 2 个数开始迭代计算
    for (int i = 2; i <= n; i++) {
        dp[i] = dp[i - 1] + dp[i - 2];
    }

    // 返回第 n 个 Fibonacci 数
    return dp[n];
}
```

- 时间复杂度：$O(n)$（线性计算）
- 空间复杂度：$O(n)$（用于存储动态规划数组）

*空间优化*

```java
public static int fibonacci(int n) {
    // 边界条件
    if (n <= 1) {
        return n;
    }

    // 只保存最近两个数
    int prev1 = 0; // F(n-2)
    int prev2 = 1; // F(n-1)

    // 迭代计算
    for (int i = 2; i <= n; i++) {
        int current = prev1 + prev2; // 当前 Fibonacci 数
        prev1 = prev2; // 更新 F(n-2)
        prev2 = current; // 更新 F(n-1)
    }

    // 返回第 n 个 Fibonacci 数
    return prev2;
}
```

- 时间复杂度：$O(n)$（线性计算）
- 空间复杂度：$O(1)$（只存储两个数）

#note[
  斐波那契数列是理解动态规划的经典入门案例，展示了从递归到记忆化再到迭代的优化过程。
]

== 背包问题

背包问题是动态规划中的经典问题类型，具有重要的理论和实践价值。

=== 0-1 背包问题

给定一个容量为 `W` 的背包和 `n` 件物品，每件物品有重量 `wt[i]` 和价值 `val[i]`，我们需要选择一些物品装入背包，使得总价值最大化，同时总重量不超过 `W`。

==== 状态分析

状态是动态规划中用来描述子问题的变量。分析状态需要明确：

- *问题的规模*：选择前 i 个物品时，当前的背包容量为 w
- *状态的定义*：用 `dp[i][w]` 表示前 i 件物品在背包容量 w 下的最大价值
- *状态的范围*：
  - i 的范围是从 0 到 n
  - w 的范围是从 0 到 W

==== 状态转移方程

状态转移方程用于描述如何从一个状态转移到另一个状态。它的确定过程如下：

*决策分析*：对于第 i 件物品，我们有两种决策：

1. *不选择第 i 件物品*：当前的最大价值是不放第 i 件物品的情况，即：$d p[i][w]=d p[i-1][w]$
2. *选择第 i 件物品*：当前的最大价值是放第 i 件物品的情况。此时剩余背包容量为 `w-wt[i-1]`，背包中的价值增加了 `val[i-1]`，即：$d p[i][w]=d p[i-1][w-w t[i-1]]+v a l[i-1]$

*选择最大值*：在两种决策中，我们选择价值更大的决策：

$d p[i][w]=max(d p[i-1][w], d p[i-1][w-w t[i-1]]+v a l[i-1])$

*边界条件*：

- 如果没有物品（即 i = 0），最大价值为 0，即：$d p[0][w]=0 quad forall w$
- 如果背包容量为 0（即 w = 0），最大价值也为 0，即：$d p[i][0]=0 quad forall i$

==== 二维数组实现

```java
public static int knapsack(int[] wt, int[] val, int W) {
    int n = wt.length;
    int[][] dp = new int[n + 1][W + 1];

    for (int i = 1; i <= n; i++) {
        for (int w = 1; w <= W; w++) {
            if (wt[i - 1] <= w) {
                dp[i][w] = Math.max(dp[i - 1][w], dp[i - 1][w - wt[i - 1]] + val[i - 1]);
            } else {
                dp[i][w] = dp[i - 1][w];
            }
        }
    }

    return dp[n][W];
}
```

==== 一维数组优化（空间优化）

在常规的二维数组 `dp[i][w]` 中，当前状态只依赖上一行的状态，因此可以优化为一维数组 `dp[w]`：从容量 W 到 0 逆序更新，避免覆盖上一行的数据。

```java
public static int knapsackOptimized(int[] wt, int[] val, int W) {
    int n = wt.length;
    int[] dp = new int[W + 1];

    for (int i = 0; i < n; i++) {
        for (int w = W; w >= wt[i]; w--) {
            dp[w] = Math.max(dp[w], dp[w - wt[i]] + val[i]);
        }
    }

    return dp[W];
}
```

#tip[
  0-1 背包的一维优化关键在于*逆序遍历*容量，这样可以保证每个物品只被选择一次。
]

==== 完全背包与多重背包

*完全背包*：每种物品有无限个可用

- 状态转移方程类似，但遍历容量时需要*正序*遍历
- 代码只需将内层循环改为：`for (int w = wt[i]; w <= W; w++)`

*多重背包*：每种物品有有限个（数量为 `count[i]`）

- 可以将多重背包转化为 0-1 背包（二进制优化）
- 或者使用单调队列优化到 $O(n W)$

#caution[
  完全背包和 0-1 背包的唯一区别在于遍历顺序：完全背包正序，0-1 背包逆序。这是一个容易混淆的点。
]

== 区间 DP

区间DP是动态规划的一种重要类型，专门解决涉及区间操作的问题。

=== 核心思想

区间DP的核心思想包括：

- *状态定义*：$d p[i][j]$ 表示区间 $[i, j]$ 上的最优解
- *区间划分*：将大区间划分为两个或多个小区间求解
- *转移策略*：通过枚举分割点 $k$ 将区间分为 $[i, k]$ 和 $[k+1, j]$
- *合并子解*：将小区间的最优解合并得到大区间的解

=== 经典问题

==== 石子合并问题

有 N 堆石子排成一排，每堆石子有一定的数量。现要将 N 堆石子并成为一堆。合并的过程只能每次将相邻的两堆石子堆成一堆，每次合并花费的代价为这两堆石子的和，经过 N-1 次合并后成为一堆。求出总的代价最小值。

*状态定义*：$d p[i][j]$ 表示合并第 i 堆到第 j 堆石子的最小代价

*状态转移方程*：$d p[i][j] = min(d p[i][k] + d p[k+1][j] + s u m[i][j])$，其中 $i <= k < j$，$s u m[i][j]$ 表示第 i 堆到第 j 堆石子的总和

*初始条件*：$d p[i][i] = 0$（单堆石子不需要合并）

*计算顺序*：按区间长度从小到大计算

```cpp
int mergeStones(vector<int>& stones) {
    int n = stones.size();
    vector<vector<int>> dp(n, vector<int>(n, INT_MAX));
    vector<int> prefixSum(n + 1, 0);
    
    // 计算前缀和
    for (int i = 0; i < n; ++i) {
        prefixSum[i + 1] = prefixSum[i] + stones[i];
    }
    
    // 初始化：单堆石子代价为0
    for (int i = 0; i < n; ++i) {
        dp[i][i] = 0;
    }
    
    // 按区间长度从小到大计算
    for (int len = 2; len <= n; ++len) {
        for (int i = 0; i <= n - len; ++i) {
            int j = i + len - 1;
            int sum = prefixSum[j + 1] - prefixSum[i];
            
            for (int k = i; k < j; ++k) {
                dp[i][j] = min(dp[i][j], dp[i][k] + dp[k + 1][j] + sum);
            }
        }
    }
    
    return dp[0][n - 1];
}
```

#note[
  石子合并问题的时间复杂度为 $O(n^3)$，可以通过四边形不等式优化到 $O(n^2)$。
]

==== 最长回文子序列

给定一个字符串 s，找到其中最长的回文子序列的长度。

*状态定义*：$d p[i][j]$ 表示字符串 s 中从位置 i 到位置 j 的最长回文子序列长度

*状态转移方程*：

- 如果 $s[i] == s[j]$：$d p[i][j] = d p[i+1][j-1] + 2$
- 如果 $s[i] != s[j]$：$d p[i][j] = max(d p[i+1][j], d p[i][j-1])$

*初始条件*：$d p[i][i] = 1$（单个字符是回文）

```cpp
int longestPalindromeSubseq(string s) {
    int n = s.size();
    vector<vector<int>> dp(n, vector<int>(n, 0));
    
    // 单个字符的回文长度为1
    for (int i = 0; i < n; ++i) {
        dp[i][i] = 1;
    }
    
    // 按区间长度从小到大计算
    for (int len = 2; len <= n; ++len) {
        for (int i = 0; i <= n - len; ++i) {
            int j = i + len - 1;
            if (s[i] == s[j]) {
                dp[i][j] = dp[i + 1][j - 1] + 2;
            } else {
                dp[i][j] = max(dp[i + 1][j], dp[i][j - 1]);
            }
        }
    }
    
    return dp[0][n - 1];
}
```

=== 优化技巧

==== 四边形不等式优化

对于某些区间DP问题，如果满足四边形不等式条件，可以将时间复杂度从 $O(n^3)$ 优化到 $O(n^2)$。

*四边形不等式*：如果函数 $w(i,j)$ 满足：

$w(a,c) + w(b,d) <= w(a,d) + w(b,c) quad (a <= b <= c <= d)$

则可以使用四边形不等式优化。

#tip[
  四边形不等式优化的关键是证明决策单调性，即最优分割点随区间右端点增加而单调不减。
]

==== 环状结构处理（破环成链）

对于环形结构的区间DP问题，常用的技巧是*破环成链*：

- 将原数组复制一份接到末尾，形成长度为 $2n$ 的数组
- 在这个扩展的数组上进行区间DP
- 最终答案在所有长度为 $n$ 的区间中取最优值

== 树形 DP

树形动态规划是一种在树结构上进行的动态规划算法，它利用树的递归特性，通过深度优先遍历（DFS）自底向上或自顶向下地求解问题。

=== 特点

树形DP具有以下特点：

- *树形结构*：问题基于树或森林结构（无向无环图）
- *递归性质*：问题可以分解为子树上的子问题
- *最优子结构*：整体最优解包含子树最优解
- *无后效性*：当前决策只影响子树，不影响祖先节点

=== 经典问题

==== 树的直径

树的直径是指树上任意两点间的最长路径。

*解题思路*：

- 对每个节点，计算经过该节点的最长路径
- 最长路径 = 该节点到其子树中最深节点的距离 + 次深节点的距离
- 树的直径是所有节点中最长路径的最大值

```cpp
int diameter = 0;

int dfs(TreeNode* node) {
    if (!node) return 0;
    
    int leftDepth = dfs(node->left);
    int rightDepth = dfs(node->right);
    
    // 更新直径
    diameter = max(diameter, leftDepth + rightDepth);
    
    // 返回当前节点的深度
    return max(leftDepth, rightDepth) + 1;
}

int diameterOfBinaryTree(TreeNode* root) {
    dfs(root);
    return diameter;
}
```

==== 没有上司的舞会（最大独立集）

在一棵树中，选择一些节点使得任意两个被选节点不相邻，求选中节点权值和的最大值。

*状态定义*：

- $d p[u][0]$：不选择节点 u 时，以 u 为根的子树的最大权值和
- $d p[u][1]$：选择节点 u 时，以 u 为根的子树的最大权值和

*状态转移方程*：

- $d p[u][0] = sum(max(d p[v][0], d p[v][1]))$，其中 v 是 u 的子节点
- $d p[u][1] = w e i g h t[u] + sum(d p[v][0])$

*最终答案*：$max(d p[r o o t][0], d p[r o o t][1])$

```cpp
vector<vector<int>> adj;
vector<int> weight;
vector<vector<int>> dp;

void dfs(int u, int parent) {
    dp[u][0] = 0;
    dp[u][1] = weight[u];
    
    for (int v : adj[u]) {
        if (v == parent) continue;
        dfs(v, u);
        
        dp[u][0] += max(dp[v][0], dp[v][1]);
        dp[u][1] += dp[v][0];
    }
}

int maxIndependentSet(int n) {
    dp.resize(n, vector<int>(2, 0));
    dfs(0, -1);
    return max(dp[0][0], dp[0][1]);
}
```

#note[
  树形DP通常使用后序遍历（先处理子节点，再处理父节点），这保证了计算父节点时子节点的状态已经确定。
]

=== 高级技巧与优化

==== 换根DP（二次扫描）

换根DP用于解决*以每个节点为根*时的相关问题。基本思路：

1. *第一次DFS*：任选一个根，计算以该根为根的树的相关信息
2. *第二次DFS*：通过换根操作，快速计算以其他节点为根时的信息

*应用场景*：

- 树的重心
- 树上所有节点到其他节点的距离和
- 树的直径端点

#tip[
  换根DP的关键在于推导从一个根转移到相邻节点根时的状态变化公式。
]

==== 虚树优化

当树的节点很多，但只有少数关键点需要处理时，可以构建*虚树*：

- 只保留关键点和它们的最近公共祖先（LCA）
- 在虚树上进行DP，大幅减少计算量
- 时间复杂度从 $O(n)$ 降低到 $O(k log k)$，其中 k 是关键点数量

== 状态压缩 DP

状态压缩动态规划是一种高效处理组合优化问题的技术，特别适用于状态空间呈指数级增长的问题。

=== 基本概念

状态压缩DP的核心思想：

- *状态压缩*：使用整数的二进制位表示状态，每个位对应一个布尔值（0/1）
- *位运算*：使用位操作快速进行状态转移和状态检查
- *状态空间优化*：将指数级状态空间压缩到有限整数范围内

*使用场景*：

- 状态维度高但每个维度取值有限（通常为布尔值）
- 状态空间可达 $2^{20}$（约100万）以内
- 问题具有最优子结构和无后效性

*核心技巧*：

- 状态表示：$d p[s t a t e][*]$，其中 state 是整数表示的压缩状态
- 位运算操作：
  - 检查状态：`state & (1 << i)`
  - 设置状态：`state | (1 << i)`
  - 清除状态：`state & ~(1 << i)`
  - 状态交集：`state1 & state2`
  - 状态并集：`state1 | state2`

=== 经典问题

==== 旅行商问题（TSP）

旅行商问题：给定 n 个城市和城市之间的距离，求从起点出发，访问所有城市恰好一次并回到起点的最短路径。

*状态定义*：$d p[m a s k][i]$ 表示已访问城市集合为 mask，当前在城市 i 的最短路径长度

*状态转移方程*：$d p[m a s k][i] = min(d p[m a s k xor (1<<i)][j] + d i s t[j][i])$，其中 j 是 mask 中除 i 外的城市

*初始条件*：$d p[1][0] = 0$（从城市0出发）

*最终答案*：$min(d p[(1<<n)-1][i] + d i s t[i][0])$，其中 $i != 0$

```cpp
int tsp(vector<vector<int>>& dist) {
    int n = dist.size();
    int fullMask = (1 << n) - 1;
    vector<vector<int>> dp(fullMask + 1, vector<int>(n, INT_MAX));
    
    // 初始状态：从城市0出发
    dp[1][0] = 0;
    
    // 枚举所有状态
    for (int mask = 1; mask <= fullMask; ++mask) {
        for (int i = 0; i < n; ++i) {
            if (!(mask & (1 << i))) continue; // 城市i不在mask中
            if (dp[mask][i] == INT_MAX) continue;
            
            // 尝试前往未访问的城市
            for (int j = 0; j < n; ++j) {
                if (mask & (1 << j)) continue; // 城市j已访问
                int newMask = mask | (1 << j);
                dp[newMask][j] = min(dp[newMask][j], dp[mask][i] + dist[i][j]);
            }
        }
    }
    
    // 回到起点
    int ans = INT_MAX;
    for (int i = 1; i < n; ++i) {
        if (dp[fullMask][i] != INT_MAX) {
            ans = min(ans, dp[fullMask][i] + dist[i][0]);
        }
    }
    
    return ans;
}
```

#caution[
  TSP 问题的时间复杂度为 $O(2^n dot n^2)$，适用于 $n <= 20$ 的小规模问题。
]

==== 棋盘覆盖问题（多米诺骨牌）

用 $1 times 2$ 的多米诺骨牌覆盖 $n times m$ 的棋盘，求方案数。

*状态定义*：$d p[i][m a s k]$ 表示处理到第 i 行，当前行的覆盖状态为 mask 的方案数

*状态转移*：枚举下一行的所有合法状态，进行转移

#note[
  棋盘覆盖问题通常需要预处理所有合法状态和状态之间的转移关系。
]

=== 优化技巧

==== 滚动数组优化

如果状态转移只依赖于前一层的状态，可以使用滚动数组将空间复杂度从 $O(2^n)$ 降低到 $O(2^{n-1})$。

==== 状态子集枚举优化

对于某些问题，可以只枚举状态的子集，而不是所有状态，从而减少计算量。

*子集枚举技巧*：

```cpp
// 枚举 mask 的所有子集
for (int sub = mask; sub; sub = (sub - 1) & mask) {
    // 处理子集 sub
}
```

#tip[
  子集枚举的时间复杂度为 $O(3^n)$，比枚举所有状态对的 $O(4^n)$ 更优。
]

== 数位 DP

数位动态规划是解决与数字的数位相关问题的强大技术，特别适用于统计满足特定条件的数字数量、计算数字和等场景。

=== 基本概念

数位DP结合了动态规划和深度优先搜索的思想：

- *数位处理*：将数字按位分解（十进制或二进制）
- *状态压缩*：记录当前处理位置、是否受限、前导零状态等信息
- *记忆化搜索*：存储已计算状态避免重复计算

*适用场景*：

- 统计区间 $[A, B]$ 内满足特定条件的数字数量
- 计算数字的数位属性（和、乘积、特定模式等）
- 处理超大范围数字（$10^{18}$ 级别）

*关键技巧*：

- 状态表示：$d p[p o s][t i g h t][l e a d i n g\_z e r o][s t a t e]$
  - $p o s$：当前处理的位置（从高位到低位）
  - $t i g h t$：是否受限（当前位能否任意取值）
  - $l e a d i n g\_z e r o$：是否存在前导零
  - $s t a t e$：问题特定状态（如前几位值、和、乘积等）
- 位运算：高效处理二进制相关问题
- 前导零处理：区分真实 0 和前导 0

=== 经典问题

==== 统计不含连续1的二进制数

统计 $[0, n]$ 范围内，二进制表示中不含连续 1 的数字个数。

*状态定义*：$d p[p o s][p r e v\_o n e][t i g h t]$

- $p o s$：当前处理的位
- $p r e v\_o n e$：前一位是否为 1
- $t i g h t$：是否受限于 n 的对应位

*状态转移*：

- 如果前一位是 1，当前位只能填 0
- 如果前一位是 0，当前位可以填 0 或 1（需考虑 tight 限制）

```cpp
vector<vector<vector<int>>> memo;
string binary;

int dfs(int pos, bool prevOne, bool tight) {
    if (pos == binary.size()) return 1;
    if (!tight && memo[pos][prevOne][0] != -1) 
        return memo[pos][prevOne][0];
    if (tight && memo[pos][prevOne][1] != -1)
        return memo[pos][prevOne][1];
    
    int limit = tight ? (binary[pos] - '0') : 1;
    int result = 0;
    
    for (int digit = 0; digit <= limit; ++digit) {
        if (prevOne && digit == 1) continue; // 不能有连续的1
        result += dfs(pos + 1, digit == 1, tight && (digit == limit));
    }
    
    if (!tight) memo[pos][prevOne][0] = result;
    else memo[pos][prevOne][1] = result;
    
    return result;
}

int countNumbers(int n) {
    // 转换为二进制
    binary = "";
    while (n > 0) {
        binary = char('0' + (n % 2)) + binary;
        n /= 2;
    }
    if (binary.empty()) binary = "0";
    
    memo.assign(binary.size(), vector<vector<int>>(2, vector<int>(2, -1)));
    return dfs(0, false, true);
}
```

==== 统计区间内数位和等于 K 的数字个数

统计 $[A, B]$ 范围内，数位和等于 K 的数字个数。

*解题思路*：

- 转化为求 $[0, B]$ 和 $[0, A-1]$ 的结果之差
- 状态：$d p[p o s][s u m][t i g h t]$
- 转移：枚举当前位的数字（0-9），累加到 sum

#note[
  数位DP通常使用记忆化搜索实现，需要注意处理前导零和边界条件。
]

== DP 优化技巧总结

=== 空间优化

==== 滚动数组

当状态转移只依赖于前一层或前几个状态时，可以使用滚动数组减少空间复杂度。

*示例*：0-1 背包从 $O(n W)$ 优化到 $O(W)$

=== 时间优化

==== 单调队列优化

适用于状态转移方程形如：$d p[i] = min/max(d p[j] + f(i, j))$ 的问题。

*核心思想*：维护一个单调队列，快速找到最优的 j。

*时间复杂度*：从 $O(n^2)$ 优化到 $O(n)$

==== 斜率优化

适用于状态转移方程可以转化为斜率形式的问题。

*核心思想*：将状态看作平面上的点，通过维护凸包快速找到最优决策点。

*应用场景*：

- 任务调度问题
- 仓库建设问题

==== 决策单调性分治优化

如果决策点具有单调性（即 $o p t[i] <= o p t[i+1]$），可以使用分治优化。

*核心思想*：

- 对于区间 $[l, r]$，已知最优决策点在 $[o p t L, o p t R]$ 范围内
- 计算中间位置 $mid$ 的最优决策点 $o p t M i d$
- 递归处理 $[l, mid-1]$ 和 $[mid+1, r]$

*时间复杂度*：从 $O(n^2)$ 优化到 $O(n log n)$

#tip[
  掌握这些优化技巧需要在大量练习中积累经验，建议先从基础的线性DP和背包问题入手，逐步挑战更复杂的优化问题。
]

== 线性DP补充

=== 最长公共子序列（LCS）

给定两个字符串 text1 和 text2，返回这两个字符串的最长公共子序列的长度。

*状态定义*：$d p[i][j]$ 表示 text1 的前 i 个字符和 text2 的前 j 个字符的最长公共子序列长度

*状态转移方程*：

- 如果 $t e x t 1[i-1] == t e x t 2[j-1]$：$d p[i][j] = d p[i-1][j-1] + 1$
- 否则：$d p[i][j] = max(d p[i-1][j], d p[i][j-1])$

*初始条件*：$d p[0][j] = 0$，$d p[i][0] = 0$

```cpp
int longestCommonSubsequence(string text1, string text2) {
    int m = text1.size(), n = text2.size();
    vector<vector<int>> dp(m + 1, vector<int>(n + 1, 0));
    
    for (int i = 1; i <= m; ++i) {
        for (int j = 1; j <= n; ++j) {
            if (text1[i - 1] == text2[j - 1]) {
                dp[i][j] = dp[i - 1][j - 1] + 1;
            } else {
                dp[i][j] = max(dp[i - 1][j], dp[i][j - 1]);
            }
        }
    }
    
    return dp[m][n];
}
```

#note[
  LCS 问题是经典的二维 DP 问题，时间复杂度为 $O(m n)$。
]

=== 编辑距离（Edit Distance）

给定两个单词 word1 和 word2，计算出将 word1 转换成 word2 所使用的最少操作数。可以进行的操作有：插入一个字符、删除一个字符、替换一个字符。

*状态定义*：$d p[i][j]$ 表示将 word1 的前 i 个字符转换为 word2 的前 j 个字符所需的最少操作数

*状态转移方程*：

- 如果 $w o r d 1[i-1] == w o r d 2[j-1]$：$d p[i][j] = d p[i-1][j-1]$
- 否则：$d p[i][j] = min(d p[i-1][j] + 1, d p[i][j-1] + 1, d p[i-1][j-1] + 1)$
  - $d p[i-1][j] + 1$：删除操作
  - $d p[i][j-1] + 1$：插入操作
  - $d p[i-1][j-1] + 1$：替换操作

*初始条件*：$d p[i][0] = i$，$d p[0][j] = j$

```cpp
int minDistance(string word1, string word2) {
    int m = word1.size(), n = word2.size();
    vector<vector<int>> dp(m + 1, vector<int>(n + 1, 0));
    
    // 初始化边界
    for (int i = 0; i <= m; ++i) dp[i][0] = i;
    for (int j = 0; j <= n; ++j) dp[0][j] = j;
    
    for (int i = 1; i <= m; ++i) {
        for (int j = 1; j <= n; ++j) {
            if (word1[i - 1] == word2[j - 1]) {
                dp[i][j] = dp[i - 1][j - 1];
            } else {
                dp[i][j] = min({dp[i - 1][j] + 1,      // 删除
                               dp[i][j - 1] + 1,      // 插入
                               dp[i - 1][j - 1] + 1}); // 替换
            }
        }
    }
    
    return dp[m][n];
}
```

#tip[
  编辑距离是自然语言处理中的重要算法，用于拼写检查、DNA序列比对等场景。
]

=== 买股票的最佳时机系列

==== 买卖股票的最佳时机 I（只能交易一次）

*状态定义*：

- $d p[i][0]$：第 i 天不持有股票的最大利润
- $d p[i][1]$：第 i 天持有股票的最大利润

*状态转移方程*：

- $d p[i][0] = max(d p[i-1][0], d p[i-1][1] + p r i c e s[i])$
- $d p[i][1] = max(d p[i-1][1], -p r i c e s[i])$

```cpp
int maxProfit(vector<int>& prices) {
    int n = prices.size();
    if (n == 0) return 0;
    
    vector<vector<int>> dp(n, vector<int>(2, 0));
    dp[0][0] = 0;
    dp[0][1] = -prices[0];
    
    for (int i = 1; i < n; ++i) {
        dp[i][0] = max(dp[i - 1][0], dp[i - 1][1] + prices[i]);
        dp[i][1] = max(dp[i - 1][1], -prices[i]);
    }
    
    return dp[n - 1][0];
}
```

==== 买卖股票的最佳时机 II（无限次交易）

*状态转移方程*：

- $d p[i][0] = max(d p[i-1][0], d p[i-1][1] + p r i c e s[i])$
- $d p[i][1] = max(d p[i-1][1], d p[i-1][0] - p r i c e s[i])$

#note[
  与版本 I 的区别在于：买入时可以从之前的利润中扣除，而不是从 0 开始。
]

== 概率DP与期望DP

概率DP和期望DP是动态规划的重要分支，用于解决涉及随机性的问题。

=== 基本概念

*概率DP*：计算达到某种状态的概率

*期望DP*：计算达到某种状态的期望值（通常是步数、代价等）

*核心公式*：

- 期望的线性性：$E[X + Y] = E[X] + E[Y]$
- 全期望公式：$E[X] = sum(E[X|A_i] dot P(A_i))$

=== 经典问题

==== 掷骰子问题

有一个 n 面的骰子，问掷出所有面的期望次数是多少？

*状态定义*：$d p[i]$ 表示已经掷出 i 个不同面，还需要掷多少次才能掷出所有 n 个面的期望

*状态转移方程*：

$d p[i] = frac{i}{n} dot d p[i] + frac{n-i}{n} dot d p[i+1] + 1$

化简得：$d p[i] = d p[i+1] + frac{n}{n-i}$

*初始条件*：$d p[n] = 0$

*最终答案*：$d p[0]$

```cpp
double expectedRolls(int n) {
    vector<double> dp(n + 1, 0);
    dp[n] = 0;
    
    for (int i = n - 1; i >= 0; --i) {
        dp[i] = dp[i + 1] + (double)n / (n - i);
    }
    
    return dp[0];
}
```

#note[
  这个问题的答案是调和级数：$H_n = 1 + frac{1}{2} + frac{1}{3} + dots + frac{1}{n}$
]

==== 收集卡片问题

有 n 种卡片，每次随机获得一种，问收集齐所有卡片的期望次数。

这个问题与掷骰子问题本质相同，答案也是 $n dot H_n$。

=== 解题技巧

*逆向思维*：期望DP通常从目标状态逆向推导到初始状态

*状态设计*：

- 概率DP：状态通常表示“已经达到某种条件”
- 期望DP：状态通常表示“从当前状态到目标状态的期望步数”

*边界处理*：

- 概率DP：初始状态概率为 1，其他为 0
- 期望DP：目标状态的期望为 0

#caution[
  期望DP容易出现循环依赖，需要仔细设计状态转移顺序，或者使用高斯消元求解方程组。
]

== DP建模思路总结

=== 如何判断一个问题是否可以用DP解决

==== 关键特征

- *最优子结构*：问题的最优解包含子问题的最优解
- *重叠子问题*：相同的子问题会被多次计算
- *无后效性*：未来的决策只与当前状态有关，与如何到达当前状态无关

==== 识别信号

- 问题要求“最大值”、“最小值”、“方案数”
- 问题涉及“选择”或“不选择”
- 问题可以分解为规模更小的子问题
- 暴力递归存在大量重复计算

=== DP问题建模步骤

==== 第一步：确定状态

*思考方式*：

- 问题的变量有哪些？
- 哪些变量会影响最终结果？
- 如何用这些变量唯一标识一个子问题？

*常见状态类型*：

- 位置/索引：$d p[i]$、$d p[i][j]$
- 集合：$d p[m a s k]$（状压DP）
- 剩余容量：$d p[i][w]$（背包）
- 前缀/后缀：$d p[i]$ 表示前 i 个元素

==== 第二步：确定状态转移方程

*思考方式*：

- 当前状态可以由哪些状态转移而来？
- 每种转移的代价/收益是什么？
- 如何选择最优的转移？

*常见转移类型*：

- 线性转移：$d p[i]$ 从 $d p[i-1]$、$d p[i-2]$ 等转移
- 区间转移：$d p[i][j]$ 从 $d p[i][k]$ 和 $d p[k+1][j]$ 转移
- 集合转移：$d p[m a s k]$ 从 $d p[m a s k xor (1<<i)]$ 转移

==== 第三步：确定初始条件

*思考方式*：

- 最小子问题的解是什么？
- 边界情况如何处理？

*常见初始条件*：

- $d p[0] = 0$ 或 $d p[0] = 1$（取决于问题）
- $d p[i][i] = 0$（区间DP）
- $d p[0][w] = 0$（背包问题）

==== 第四步：确定计算顺序

*思考方式*：

- 计算 $d p[i]$ 时，它依赖的状态是否已经计算过？
- 应该从小到大还是从大到小枚举？

*常见顺序*：

- 线性DP：从小到大枚举 i
- 区间DP：按区间长度从小到大
- 树形DP：后序遍历（先子节点后父节点）
- 状压DP：按 mask 从小到大

=== 常见错误与调试技巧

==== 常见错误

- *状态定义不清*：导致转移方程难以推导
- *边界条件错误*：特别是 $d p[0]$ 的值
- *转移顺序错误*：依赖的状态还未计算
- *数组越界*：访问 $d p[-1]$ 或 $d p[n]$
- *初始化遗漏*：某些状态未正确初始化

==== 调试技巧

- *打印DP表*：观察中间状态是否符合预期
- *小规模测试*：用手工计算验证小数据的结果
- *对比暴力解*：用小数据对比DP和暴力解的结果
- *检查边界*：特别关注 $i=0$、$i=n-1$ 等边界情况

#tip[
  DP问题的难点不在于代码实现，而在于正确的状态定义和转移方程设计。多做题、多总结是提高DP能力的关键。
]

== DP问题分类速查

=== 按问题类型分类

#tex-table(
  ("类型", "典型问题", "状态维度"),
  ("线性DP", "LIS、LCS、编辑距离", "1D或2D"),
  ("背包DP", "0-1背包、完全背包", "2D"),
  ("区间DP", "石子合并、矩阵连乘", "2D"),
  ("树形DP", "树的直径、最大独立集", "树上DFS"),
  ("状压DP", "TSP、棋盘覆盖", "mask + 其他"),
  ("数位DP", "数字计数、数位统计", "pos + tight"),
  ("概率DP", "期望步数、概率计算", "视问题而定"),
)

=== 按优化技巧分类

#tex-table(
  ("优化方法", "适用场景", "复杂度改进"),
  ("滚动数组", "只依赖前一层", "$O(n) -> O(1)$空间"),
  ("单调队列", "滑动窗口最值", "$O(n^2) -> O(n)$"),
  ("斜率优化", "特定形式的转移", "$O(n^2) -> O(n)$"),
  ("四边形不等式", "区间DP", "$O(n^3) -> O(n^2)$"),
  ("决策单调性", "决策点单调", "$O(n^2) -> O(n log n)$"),
)

#fancy-divider

本章完

