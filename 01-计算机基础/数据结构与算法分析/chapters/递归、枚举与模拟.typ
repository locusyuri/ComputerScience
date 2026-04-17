#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= 递归、枚举与模拟

#note[
  本章介绍三种基础算法思想：递归、枚举和模拟。这些思想是许多高级算法的基础。
]

== 递归的基本概念与设计原则

递归是一种*自调用*的算法设计方法，通过将问题分解为更小的子问题来求解。

=== 递归的两个关键要素

==== 基准情况（Base Case）

基准情况是递归的*终止条件*，防止无限递归。

*示例*：

```cpp
int factorial(int n) {
    if (n <= 1) return 1; // 基准情况
    return n * factorial(n - 1);
}
```

==== 递归进展（Recursive Progress）

每次递归调用必须*向基准情况靠近*，确保最终能够终止。

*示例*：

```cpp
int fibonacci(int n) {
    if (n <= 1) return n; // 基准情况
    return fibonacci(n - 1) + fibonacci(n - 2); // 向基准情况靠近
}
```

=== 递归的设计原则

1. *明确基准情况*：确定何时停止递归
2. *缩小问题规模*：每次递归处理更小的子问题
3. *相信递归*：假设递归调用能正确解决子问题
4. *避免重复计算*：考虑使用记忆化优化

#tip[
  设计递归算法时，先想清楚基准情况和递归进展，再编写代码。
]

== 递归算法的执行过程与调用栈

=== 调用栈的工作原理

递归调用时，系统会为每次调用创建一个*栈帧*（Stack Frame），保存局部变量、参数和返回地址。

*示例*：计算 `factorial(4)` 的调用过程

```
factorial(4)
├─ factorial(3)
│  ├─ factorial(2)
│  │  ├─ factorial(1)  ← 基准情况，返回 1
│  │  └─ 返回 2 * 1 = 2
│  └─ 返回 3 * 2 = 6
└─ 返回 4 * 6 = 24
```

=== 递归深度与栈溢出

*问题*：递归过深会导致*栈溢出*（Stack Overflow）

```cpp
// 危险：可能导致栈溢出
void deepRecursion(int n) {
    if (n <= 0) return;
    deepRecursion(n - 1);
}

// 调用 deepRecursion(100000) 可能栈溢出
```

*解决方案*：

1. 限制递归深度
2. 转换为迭代
3. 使用尾递归优化

#caution[
  大多数系统的默认栈大小为 1-8 MB，递归深度通常限制在几千到几万层。
]

== 递归树与递归复杂度分析

=== 递归树方法

递归树是分析递归算法复杂度的直观工具。

*示例*：归并排序的递归树

```
        T(n)          ← 第0层：1个节点，代价 cn
       /    \
   T(n/2)  T(n/2)     ← 第1层：2个节点，代价 cn
   / \    / \
T(n/4)...            ← 第2层：4个节点，代价 cn
  ...
```

*总代价*：$T(n) = "cn" * log n = O(n log n)$

=== 主定理（Master Theorem）

对于形式为 $T(n) = a * T(n/b) + f(n)$ 的递归关系：

#tex-table(
  ("情况", "条件", "解"),
  ("情况1", "$f(n) = O(n^{log_b a - epsilon})$", "$T(n) = Theta(n^{log_b a})$"),
  ("情况2", "$f(n) = Theta(n^{log_b a})$", "$T(n) = Theta(n^{log_b a} log n)$"),
  ("情况3", "$f(n) = Omega(n^{log_b a + epsilon})$", "$T(n) = Theta(f(n))$"),
)

*示例*：

- 归并排序：$T(n) = 2T(n/2) + O(n)$ → $O(n log n)$
- 二分查找：$T(n) = T(n/2) + O(1)$ → $O(log n)$

== 尾递归优化与递归转迭代

=== 尾递归

尾递归是指递归调用是函数的*最后一个操作*。

*非尾递归*：

```cpp
int factorial(int n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1); // 乘法在递归调用之后
}
```

*尾递归*：

```cpp
int factorialTail(int n, int acc = 1) {
    if (n <= 1) return acc;
    return factorialTail(n - 1, n * acc); // 递归调用是最后一步
}
```

=== 尾递归优化

编译器可以将尾递归优化为*循环*，避免栈增长。

*优点*：

- 空间复杂度从 $O(n)$ 降为 $O(1)$
- 避免栈溢出

#note[
  C++编译器（如GCC、Clang）在优化模式下会自动进行尾递归优化。
]

=== 递归转迭代

任何递归都可以转换为迭代，使用*显式栈*模拟调用栈。

*示例*：二叉树前序遍历

```cpp
// 递归版本
void preorder(TreeNode* root) {
    if (!root) return;
    visit(root);
    preorder(root->left);
    preorder(root->right);
}

// 迭代版本
void preorderIterative(TreeNode* root) {
    stack<TreeNode*> stk;
    if (root) stk.push(root);

    while (!stk.empty()) {
        TreeNode* node = stk.top(); stk.pop();
        visit(node);
        if (node->right) stk.push(node->right);
        if (node->left) stk.push(node->left);
    }
}
```

== 记忆化搜索（Top-down DP）

记忆化搜索是*递归 + 缓存*的组合，避免重复计算子问题。

=== 基本原理

1. 使用递归自顶向下求解
2. 用哈希表或数组缓存已计算的结果
3. 再次遇到相同子问题时直接返回缓存值

=== 经典示例：斐波那契数列

*普通递归*：$O(2^n)$

```cpp
int fib(int n) {
    if (n <= 1) return n;
    return fib(n - 1) + fib(n - 2); // 大量重复计算
}
```

*记忆化搜索*：$O(n)$

```cpp
unordered_map<int, int> memo;

int fibMemo(int n) {
    if (n <= 1) return n;
    if (memo.count(n)) return memo[n]; // 查缓存
    return memo[n] = fibMemo(n - 1) + fibMemo(n - 2);
}
```

=== 应用场景

- 动态规划问题（Top-down方式）
- 有重叠子问题的递归
- 状态空间稀疏的问题

#tip[
  记忆化搜索的优点是只计算需要的状态，而DP会计算所有状态。对于状态空间稀疏的问题，记忆化搜索更高效。
]

== 枚举算法的设计与优化技巧

枚举（穷举）是一种*暴力搜索*方法，遍历所有可能的解空间。

=== 基本框架

```cpp
for (每个可能的选择1) {
    for (每个可能的选择2) {
        ...
            if (满足条件) {
                更新最优解
            }
    }
}
```

=== 优化技巧

==== 缩小搜索空间

通过问题分析排除不可能的情况。

*示例*：两数之和

```cpp
// 暴力枚举：O(n^2)
for (int i = 0; i < n; ++i) {
    for (int j = i + 1; j < n; ++j) {
        if (nums[i] + nums[j] == target) {
            return {i, j};
        }
    }
}

// 优化：使用哈希表 O(n)
unordered_map<int, int> map;
for (int i = 0; i < n; ++i) {
    int complement = target - nums[i];
    if (map.count(complement)) {
        return {map[complement], i};
    }
    map[nums[i]] = i;
}
```

==== 剪枝

提前终止不可能的分支。

*示例*：N皇后问题

```cpp
void solveNQueens(int row) {
    if (row == n) {
        count++;
        return;
    }

    for (int col = 0; col < n; ++col) {
        if (isValid(row, col)) { // 剪枝：检查是否冲突
            placeQueen(row, col);
            solveNQueens(row + 1);
            removeQueen(row, col);
        }
    }
}
```

==== 位运算优化

使用位运算加速枚举过程。

*示例*：子集枚举

```cpp
// 枚举集合 {0, 1, ..., n-1} 的所有子集
for (int mask = 0; mask < (1 << n); ++mask) {
    // mask 的二进制表示对应一个子集
    for (int i = 0; i < n; ++i) {
        if (mask & (1 << i)) {
            // 元素 i 在子集中
        }
    }
}
```

== 模拟算法的应用场景与实现要点

模拟算法是直接*按照题目描述*逐步执行，没有特定的优化技巧。

=== 适用场景

- 规则明确的流程模拟
- 游戏逻辑实现
- 系统行为仿真
- 复杂的状态转换

=== 实现要点

==== 清晰的状态表示

```cpp
struct GameState {
    int playerPos;
    int score;
    vector<bool> visited;
    // ...
};
```

==== 模块化设计

将复杂逻辑分解为小函数。

```cpp
void simulate() {
    initialize();
    while (!isGameOver()) {
        processInput();
        updateState();
        render();
    }
}
```

==== 边界条件处理

特别注意特殊情况。

*示例*：日期模拟

```cpp
void nextDay(int& year, int& month, int& day) {
    day++;

    // 处理月末
    if (day > daysInMonth(year, month)) {
        day = 1;
        month++;

        // 处理年末
        if (month > 12) {
            month = 1;
            year++;
        }
    }
}
```

=== 经典示例：约瑟夫环

```cpp
int josephus(int n, int k) {
    if (n == 1) return 0;
    return (josephus(n - 1, k) + k) % n;
}

// 迭代版本
int josephusIterative(int n, int k) {
    int result = 0;
    for (int i = 2; i <= n; ++i) {
        result = (result + k) % i;
    }
    return result;
}
```

#fancy-divider

本章介绍了三种基础算法思想：递归通过自调用分解问题，枚举通过遍历寻找解，模拟通过逐步执行还原过程。这些思想虽然简单，却是许多高级算法的基础。
