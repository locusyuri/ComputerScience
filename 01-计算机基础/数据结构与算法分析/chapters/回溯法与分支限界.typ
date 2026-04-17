#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= 回溯法与分支限界

#note[
  回溯法和分支限界都是系统搜索解空间的方法，用于解决组合优化问题。
]

== 回溯法的基本思想

回溯法是一种*系统性搜索*解空间的方法，通过深度优先搜索和剪枝来寻找问题的解。

=== 解空间树

回溯法将问题的解空间组织成*树形结构*。

==== 子集树

当问题是从 $n$ 个元素中选择子集时，解空间是子集树。

*特点*：

- 树的高度为 $n$
- 每个节点有两个分支（选/不选）
- 叶子节点数为 $2^n$

*示例*：0/1背包、子集和问题

==== 排列树

当问题是求 $n$ 个元素的排列时，解空间是排列树。

*特点*：

- 树的高度为 $n$
- 第 $i$ 层有 $n-i+1$ 个分支
- 叶子节点数为 $n!$

*示例*：旅行商问题、全排列

=== 约束函数与限界函数

==== 约束函数（Constraint Function）

判断当前部分解是否满足问题的*约束条件*。

*作用*：剪去不满足约束的子树

*示例*：N皇后问题中，检查新放置的皇后是否与已有皇后冲突

==== 限界函数（Bound Function）

判断当前部分解是否可能达到*最优解*。

*作用*：剪去不可能产生更优解的子树

*示例*：0/1背包中，如果当前价值 + 剩余最大可能价值 < 已知最优值，则剪枝

== 回溯法的框架与剪枝技巧

=== 回溯法通用框架

```cpp
void backtrack(int level) {
    if (level > n) {
        // 找到完整解，处理结果
        processSolution();
        return;
    }

    for (每个可能的选择) {
        if (约束函数(level, 选择)) {  // 剪枝
            做出选择;
            backtrack(level + 1);
            撤销选择;  // 回溯
        }
    }
}
```

=== 剪枝技巧

==== 可行性剪枝

提前判断当前路径是否可行。

*示例*：N皇后中，检查新位置是否与已有皇后冲突

==== 最优性剪枝

如果当前解已经不如已知最优解，则剪枝。

*示例*：TSP中，如果当前路径长度已经超过已知最短路径，则停止搜索

==== 对称性剪枝

利用问题的对称性减少搜索空间。

*示例*：组合问题中，规定元素按顺序选择，避免重复

#tip[
  好的剪枝策略可以将指数级复杂度降低几个数量级。
]

== 经典回溯问题

=== N皇后问题

*问题*：在 $n * n$ 棋盘上放置 $n$ 个皇后，使得它们互不攻击。

```cpp
vector<vector<string>> solveNQueens(int n) {
    vector<vector<string>> results;
    vector<string> board(n, string(n, '.'));
    vector<bool> cols(n), diag1(2*n-1), diag2(2*n-1);

    function<void(int)> backtrack = [&](int row) {
        if (row == n) {
            results.push_back(board);
            return;
        }

        for (int col = 0; col < n; ++col) {
            int d1 = row - col + n - 1;
            int d2 = row + col;

            if (cols[col] || diag1[d1] || diag2[d2]) continue;

            // 放置皇后
            board[row][col] = 'Q';
            cols[col] = diag1[d1] = diag2[d2] = true;

            backtrack(row + 1);

            // 回溯
            board[row][col] = '.';
            cols[col] = diag1[d1] = diag2[d2] = false;
        }
    };

    backtrack(0);
    return results;
}
```

*时间复杂度*：$O(n!)$（最坏情况）

=== 数独求解

*问题*：填充 $9 * 9$ 数独网格。

```cpp
bool solveSudoku(vector<vector<char>>& board) {
    for (int i = 0; i < 9; ++i) {
        for (int j = 0; j < 9; ++j) {
            if (board[i][j] == '.') {
                for (char c = '1'; c <= '9'; ++c) {
                    if (isValid(board, i, j, c)) {
                        board[i][j] = c;
                        if (solveSudoku(board)) return true;
                        board[i][j] = '.';  // 回溯
                    }
                }
                return false;
            }
        }
    }
    return true;
}
```

=== 图的m着色问题

*问题*：用 $m$ 种颜色给图的顶点着色，相邻顶点颜色不同。

```cpp
bool graphColoring(vector<vector<int>>& graph, int m) {
    int n = graph.size();
    vector<int> color(n, 0);

    function<bool(int)> backtrack = [&](int v) {
        if (v == n) return true;

        for (int c = 1; c <= m; ++c) {
            if (isSafe(graph, color, v, c)) {
                color[v] = c;
                if (backtrack(v + 1)) return true;
                color[v] = 0;  // 回溯
            }
        }
        return false;
    };

    return backtrack(0);
}
```

== 子集与排列问题

=== 子集和问题

*问题*：从数组中选择若干元素，使得它们的和等于目标值。

```cpp
vector<vector<int>> subsetSum(vector<int>& nums, int target) {
    vector<vector<int>> results;
    vector<int> current;

    function<void(int, int)> backtrack = [&](int start, int sum) {
        if (sum == target) {
            results.push_back(current);
            return;
        }

        for (int i = start; i < nums.size(); ++i) {
            if (sum + nums[i] > target) continue;  // 剪枝

            current.push_back(nums[i]);
            backtrack(i + 1, sum + nums[i]);
            current.pop_back();  // 回溯
        }
    };

    sort(nums.begin(), nums.end());
    backtrack(0, 0);
    return results;
}
```

=== 全排列

*问题*：生成数组的所有排列。

```cpp
vector<vector<int>> permute(vector<int>& nums) {
    vector<vector<int>> results;
    vector<bool> used(nums.size(), false);
    vector<int> current;

    function<void()> backtrack = [&]() {
        if (current.size() == nums.size()) {
            results.push_back(current);
            return;
        }

        for (int i = 0; i < nums.size(); ++i) {
            if (used[i]) continue;

            used[i] = true;
            current.push_back(nums[i]);
            backtrack();
            current.pop_back();
            used[i] = false;  // 回溯
        }
    };

    backtrack();
    return results;
}
```

=== 组合问题

*问题*：从 $n$ 个数中选择 $k$ 个数的所有组合。

```cpp
vector<vector<int>> combine(int n, int k) {
    vector<vector<int>> results;
    vector<int> current;

    function<void(int)> backtrack = [&](int start) {
        if (current.size() == k) {
            results.push_back(current);
            return;
        }

        for (int i = start; i <= n; ++i) {
            current.push_back(i);
            backtrack(i + 1);
            current.pop_back();  // 回溯
        }
    };

    backtrack(1);
    return results;
}
```

== 分支限界法的基本概念

分支限界法是另一种系统搜索解空间的方法，使用*广度优先*或*最佳优先*策略。

=== 与回溯法的区别

#tex-table(
  ("特性", "回溯法", "分支限界"),
  ("搜索策略", "深度优先", "广度优先/最佳优先"),
  ("存储结构", "栈（递归）", "队列/优先队列"),
  ("求解目标", "所有解/一个解", "最优解"),
  ("剪枝方式", "约束函数", "约束+限界函数"),
)

=== FIFO分支限界

使用*队列*实现广度优先搜索。

*特点*：

- 按层次扩展节点
- 保证找到最短路径（如果存在）
- 空间复杂度较高

=== 优先队列式分支限界（LC分支限界）

使用*优先队列*，每次扩展最有希望的节点。

*特点*：

- 使用限界函数评估节点
- 更快找到最优解
- 需要设计好的估价函数

== 分支限界的应用

=== 0/1背包问题

*问题*：从 $n$ 个物品中选择，使得总重量不超过容量，总价值最大。

*分支限界策略*：

1. 按单位价值排序
2. 使用优先队列，优先级 = 当前价值 + 剩余最大可能价值
3. 剪枝：如果优先级 < 已知最优值，则不扩展

```cpp
struct Node {
    int level;      // 当前层
    int profit;     // 当前价值
    int weight;     // 当前重量
    double bound;   // 上界
};

double calculateBound(Node u, int n, int W, vector<pair<int,int>>& items) {
    if (u.weight >= W) return 0;

    double profitBound = u.profit;
    int j = u.level + 1;
    int totWeight = u.weight;

    while (j < n && totWeight + items[j].first <= W) {
        totWeight += items[j].first;
        profitBound += items[j].second;
        j++;
    }

    if (j < n) {
        profitBound += (W - totWeight) *
                      ((double)items[j].second / items[j].first);
    }

    return profitBound;
}

int knapsackBranchBound(int W, vector<pair<int,int>>& items) {
    int n = items.size();
    sort(items.begin(), items.end(),
         [](const pair<int,int>& a, const pair<int,int>& b) {
             return (double)a.second/a.first > (double)b.second/b.first;
         });

    priority_queue<Node> pq;
    Node u, v;
    u.level = -1; u.profit = 0; u.weight = 0;
    u.bound = calculateBound(u, n, W, items);
    pq.push(u);

    int maxProfit = 0;

    while (!pq.empty()) {
        u = pq.top(); pq.pop();

        if (u.bound <= maxProfit) continue;

        // 扩展左子节点（选择当前物品）
        v.level = u.level + 1;
        v.weight = u.weight + items[v.level].first;
        v.profit = u.profit + items[v.level].second;

        if (v.weight <= W && v.profit > maxProfit) {
            maxProfit = v.profit;
        }

        v.bound = calculateBound(v, n, W, items);
        if (v.bound > maxProfit) {
            pq.push(v);
        }

        // 扩展右子节点（不选择当前物品）
        v.level = u.level + 1;
        v.weight = u.weight;
        v.profit = u.profit;
        v.bound = calculateBound(v, n, W, items);
        if (v.bound > maxProfit) {
            pq.push(v);
        }
    }

    return maxProfit;
}
```

=== 旅行商问题（TSP）

*问题*：找到访问所有城市并返回起点的最短路径。

*分支限界策略*：

1. 使用邻接矩阵表示图
2. 限界函数 = 当前路径长度 + 最小生成树下界
3. 优先队列按路径长度排序

#note[
  TSP是NP-hard问题，分支限界可以在合理时间内找到中小规模问题的最优解。
]

== 回溯法与分支限界的比较

=== 选择策略

*使用回溯法*：

- 需要找到所有解
- 解空间较小
- 约束条件复杂

*使用分支限界*：

- 只需要最优解
- 可以设计有效的限界函数
- 解空间较大

=== 性能对比

#tex-table(
  ("方面", "回溯法", "分支限界"),
  ("时间复杂度", "指数级", "指数级（但通常更快）"),
  ("空间复杂度", "$O(n)$", "$O(2^n)$（最坏）"),
  ("实现难度", "较简单", "较复杂"),
  ("适用场景", "约束满足", "优化问题"),
)

#fancy-divider

本章介绍了回溯法和分支限界两种系统搜索方法。回溯法适合寻找所有解，分支限界适合寻找最优解。选择合适的算法取决于具体问题的特点。
