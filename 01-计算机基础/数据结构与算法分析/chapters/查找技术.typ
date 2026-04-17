#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= 查找技术

查找（Searching）是在数据集合中寻找满足特定条件的数据元素的过程。查找算法的效率直接影响程序的性能。

#note[
  查找算法的核心评价指标是*平均查找长度*（ASL, Average Search Length），即查找成功或失败时需要进行的关键字比较次数的期望值。
]

== 基本概念

=== 查找表

查找表是由同一类型的数据元素（或记录）构成的集合。

*静态查找表*：只做查找操作，不改变表的内容

*动态查找表*：在查找过程中同时进行插入或删除操作

*多关键字查找*：数据可能存在多个关键字，查找操作需要指定查询条件

=== 关键字

关键字是数据元素中某个数据项的值，用以标识一个数据元素。

*主关键字*：可以唯一标识一个记录的关键字

*次关键字*：不能唯一标识记录的关键字

=== 平均查找长度（ASL）

ASL 是衡量查找算法效率的主要指标：

$A S L = sum_(i=1)^n p_i dot c_i$

其中：
- $n$：表中记录个数
- $p_i$：查找第 i 个记录的概率
- $c_i$：找到第 i 个记录所需的比较次数

#tip[
  通常假设查找每个记录的概率相等，即 $p_i = frac{1}{n}$。
]

== 静态查找

静态查找表在查找过程中不发生变化，适合使用以下算法。

=== 顺序查找

顺序查找是最基本的查找方法，从表的一端开始，逐个将记录的关键字与给定值进行比较。

==== 基本实现

```cpp
int sequentialSearch(vector<int>& arr, int target) {
    for (int i = 0; i < arr.size(); ++i) {
        if (arr[i] == target) {
            return i; // 找到，返回索引
        }
    }
    return -1; // 未找到
}
```

*时间复杂度*：

- 最好情况：$O(1)$（第一个元素就是目标）
- 最坏情况：$O(n)$（最后一个元素或不存在）
- 平均情况：$O(n)$

*ASL*：

- 查找成功：$A S L = (n+1)/(2)$
- 查找失败：$A S L = n$

==== 哨兵优化

通过在数组开头设置"哨兵"，可以减少每次循环中的边界检查。

```cpp
int sequentialSearchWithSentinel(vector<int>& arr, int target) {
    int n = arr.size();
    arr.insert(arr.begin(), target); // 在开头插入哨兵

    int i = n;
    while (arr[i] != target) {
        --i;
    }

    arr.erase(arr.begin()); // 恢复原数组
    return i == 0 ? -1 : i - 1; // i=0表示未找到
}
```

#note[
  哨兵优化虽然减少了比较次数，但需要修改原数组或使用额外空间，实际应用中需权衡利弊。
]

=== 折半查找（二分查找）

折半查找要求查找表必须是*有序*的，通过不断将查找区间缩小一半来提高效率。

==== 基本实现

```cpp
int binarySearch(vector<int>& arr, int target) {
    int left = 0, right = arr.size() - 1;

    while (left <= right) {
        int mid = left + (right - left) / 2; // 防止溢出

        if (arr[mid] == target) {
            return mid;
        } else if (arr[mid] < target) {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }

    return -1; // 未找到
}
```

*时间复杂度*：$O(log n)$

*ASL*：$A S L approx log_2(n+1) - 1$

#caution[
  计算 mid 时使用 `left + (right - left) / 2` 而非 `(left + right) / 2`，可以避免整数溢出。
]

==== 二分查找的变体

===== 查找第一个等于目标值的元素

```cpp
int findFirstEqual(vector<int>& arr, int target) {
    int left = 0, right = arr.size() - 1;
    int result = -1;

    while (left <= right) {
        int mid = left + (right - left) / 2;

        if (arr[mid] == target) {
            result = mid;
            right = mid - 1; // 继续向左查找
        } else if (arr[mid] < target) {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }

    return result;
}
```

===== 查找最后一个等于目标值的元素

```cpp
int findLastEqual(vector<int>& arr, int target) {
    int left = 0, right = arr.size() - 1;
    int result = -1;

    while (left <= right) {
        int mid = left + (right - left) / 2;

        if (arr[mid] == target) {
            result = mid;
            left = mid + 1; // 继续向右查找
        } else if (arr[mid] < target) {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }

    return result;
}
```

===== 查找第一个大于等于目标值的元素（下界）

```cpp
int lowerBound(vector<int>& arr, int target) {
    int left = 0, right = arr.size();

    while (left < right) {
        int mid = left + (right - left) / 2;

        if (arr[mid] < target) {
            left = mid + 1;
        } else {
            right = mid;
        }
    }

    return left; // 返回插入位置
}
```

===== 查找第一个大于目标值的元素（上界）

```cpp
int upperBound(vector<int>& arr, int target) {
    int left = 0, right = arr.size();

    while (left < right) {
        int mid = left + (right - left) / 2;

        if (arr[mid] <= target) {
            left = mid + 1;
        } else {
            right = mid;
        }
    }

    return left; // 返回插入位置
}
```

#tip[
  C++ STL 提供了 `lower_bound` 和 `upper_bound` 函数，可以直接使用。
]

==== 二分查找的应用

===== 二分答案

当问题的答案具有单调性时，可以通过二分查找来确定答案。

*典型问题*：

- 最小化最大值
- 最大化最小值
- 求满足条件的最小/最大值

*解题框架*：

```cpp
bool check(int mid) {
    // 判断mid是否满足条件
}

int binarySearchAnswer(int left, int right) {
    while (left < right) {
        int mid = left + (right - left) / 2;

        if (check(mid)) {
            right = mid; // 答案在左半部分
        } else {
            left = mid + 1; // 答案在右半部分
        }
    }

    return left;
}
```

=== 分块查找（索引顺序查找）

分块查找结合了顺序查找和折半查找的优点，将表分成若干块，块间有序，块内无序。

==== 算法思想

1. 建立索引表，记录每块的最大关键字和起始位置
2. 在索引表中用折半查找确定目标所在的块
3. 在块内用顺序查找找到目标

==== 性能分析

设表长为 $n$，分为 $b$ 块，每块 $s$ 个元素（$n = b times s$）：

- 索引表查找：$O(log b)$ 或 $O(b)$
- 块内查找：$O(s)$
- 总 ASL：$O(log b + s)$ 或 $O(b + s)$

当 $b = s = sqrt(n)$ 时，ASL 最小，为 $O(sqrt(n))$。

#note[
  分块查找适用于动态查找表，插入和删除操作比折半查找更方便。
]

=== 插值查找

插值查找是折半查找的改进，根据目标值在有序表中的可能位置进行调整。

==== 算法思想

将折半查找的中点计算公式：

$m i d = frac{l e f t + r i g h t}{2}$

改为：

$m i d = l e f t + frac{t a r g e t - a r r[l e f t]}{a r r[r i g h t] - a r r[l e f t]} dot (r i g h t - l e f t)$

==== 适用场景

- 表长较大
- 关键字分布比较均匀

*时间复杂度*：

- 平均情况：$O(log log n)$
- 最坏情况：$O(n)$（分布极不均匀时）

#caution[
  插值查找在关键字分布不均匀时性能可能退化，需谨慎使用。
]

=== 斐波那契查找

斐波那契查找利用斐波那契数列来分割查找区间，避免使用除法运算。

==== 算法思想

使用斐波那契数列 $F[k]$ 来分割区间，使得：

- 左子区间长度：$F[k-1] - 1$
- 右子区间长度：$F[k-2] - 1$

==== 特点

- 只使用加减法，不涉及乘除运算
- 在某些硬件平台上可能更快
- 实际应用较少

#tip[
  在实际开发中，折半查找已经足够高效且易于理解，推荐使用折半查找。
]

= 树形查找结构

树形查找结构利用树的层次组织数据，支持高效的动态查找、插入和删除操作。

#note[
  本章介绍常见的树形查找结构，包括二叉搜索树、平衡二叉树（AVL）、红黑树、B树/B+树、Trie树等。
]

== 二叉搜索树（BST）

二叉搜索树是一种特殊的二叉树，满足以下性质：

- 若左子树非空，则左子树上所有节点的值均小于根节点的值
- 若右子树非空，则右子树上所有节点的值均大于根节点的值
- 左右子树也分别是二叉搜索树

=== BST的基本操作

==== 查找

```cpp
TreeNode* searchBST(TreeNode* root, int val) {
    if (!root || root->val == val) {
        return root;
    }

    if (val < root->val) {
        return searchBST(root->left, val);
    } else {
        return searchBST(root->right, val);
    }
}
```

*时间复杂度*：

- 最好情况：$O(log n)$（平衡树）
- 最坏情况：$O(n)$（退化为链表）

==== 插入

```cpp
TreeNode* insertBST(TreeNode* root, int val) {
    if (!root) {
        return new TreeNode(val);
    }

    if (val < root->val) {
        root->left = insertBST(root->left, val);
    } else if (val > root->val) {
        root->right = insertBST(root->right, val);
    }

    return root;
}
```

==== 删除

删除操作分三种情况：

1. *叶子节点*：直接删除
2. *只有一个子节点*：用子节点替代
3. *有两个子节点*：用中序后继（右子树最小节点）替代

```cpp
TreeNode* deleteBST(TreeNode* root, int val) {
    if (!root) return nullptr;

    if (val < root->val) {
        root->left = deleteBST(root->left, val);
    } else if (val > root->val) {
        root->right = deleteBST(root->right, val);
    } else {
        // 找到要删除的节点
        if (!root->left) {
            TreeNode* temp = root->right;
            delete root;
            return temp;
        } else if (!root->right) {
            TreeNode* temp = root->left;
            delete root;
            return temp;
        } else {
            // 有两个子节点，找中序后继
            TreeNode* successor = findMin(root->right);
            root->val = successor->val;
            root->right = deleteBST(root->right, successor->val);
        }
    }

    return root;
}

TreeNode* findMin(TreeNode* node) {
    while (node->left) {
        node = node->left;
    }
    return node;
}
```

=== BST的性能分析

BST 的性能取决于树的形态：

- *最好情况*：完全平衡，高度为 $O(log n)$
- *最坏情况*：退化为链表，高度为 $O(n)$

#caution[
  BST 在插入顺序不利时会严重退化，实际应用中应使用平衡二叉搜索树。
]

=== BST的应用场景

- 教学演示：理解二叉搜索的基本原理
- 小规模数据：数据量小且随机插入时表现良好
- 其他平衡树的基础：AVL、红黑树等都是BST的改进版本

== 平衡二叉树（AVL树）

AVL树是一种自平衡的二叉搜索树，任意节点的左右子树高度差不超过 1。

=== AVL树的定义与平衡因子

*平衡因子* = 左子树高度 - 右子树高度

AVL树要求所有节点的平衡因子为 -1、0 或 1。

=== AVL树的旋转操作

当插入或删除节点导致树不平衡时，需要通过旋转来恢复平衡。

==== LL旋转（右旋）

```text
    z               y
   / \            /   \
  y   T4   =>   x      z
 / \            / \    / \
x   T3         T1 T2  T3 T4
/
T1
```

==== RR旋转（左旋）

```text
z                y
/ \             /   \
T1   y    =>   z      x
    / \       / \    / \
   T2   x    T1 T2  T3 T4
       / \
      T3 T4
```

==== LR旋转（先左后右）

先对左子节点进行RR旋转，再对根节点进行LL旋转。

==== RL旋转（先右后左）

先对右子节点进行LL旋转，再对根节点进行RR旋转。

=== AVL树的性能分析

- 查找、插入、删除的时间复杂度均为 $O(log n)$
- 保持严格平衡，查询效率高
- 插入和删除可能需要多次旋转

#note[
  AVL树适合读多写少的场景，如数据库索引。
]

== 红黑树

红黑树是一种近似平衡的二叉搜索树，通过颜色约束来保证平衡。

=== 红黑树的五条性质

1. 每个节点要么是红色，要么是黑色
2. 根节点是黑色
3. 每个叶子节点（NIL）是黑色
4. 如果一个节点是红色，则它的两个子节点都是黑色
5. 从任一节点到其每个叶子的所有简单路径都包含相同数目的黑色节点

=== 红黑树的性能特点

- 查找、插入、删除的时间复杂度均为 $O(log n)$
- 插入和删除最多只需要常数次旋转
- 比AVL树更宽松，适合频繁插入删除的场景

#tip[
  C++ STL 中的 `map` 和 `set`、Java 中的 `TreeMap` 和 `TreeSet` 都基于红黑树实现。
]

=== AVL vs 红黑树对比

#tex-table(
  ("特性", "AVL树", "红黑树"),
  ("平衡性", "严格平衡", "近似平衡"),
  ("查询效率", "更高", "稍低"),
  ("插入/删除", "可能需要多次旋转", "最多常数次旋转"),
  ("适用场景", "读多写少", "读写均衡"),
  ("实现难度", "较复杂", "相对简单"),
)

未完待续...

== B树与B+树

B树和B+树是多路平衡搜索树，专为磁盘存储设计。

=== B树的定义与性质

*m阶B树*的性质：

- 每个节点最多有 m 个子节点
- 除根节点外，每个节点至少有 $ceil(m/2)$ 个子节点
- 所有叶子节点在同一层
- 节点中的关键字按升序排列

=== B树的操作

B树支持查找、插入、删除操作，其中插入和删除可能涉及节点的*分裂*与*合并*。

*应用场景*：文件系统、数据库索引

=== B+树的结构特点

B+树是B树的变种，具有以下特点：

- 非叶子节点只存储索引，不存储数据
- 所有数据都存储在叶子节点
- 叶子节点之间用链表连接，便于范围查询

=== B+树的优势

- 更适合范围查询
- 磁盘I/O次数更少
- 遍历效率更高

#note[
  MySQL 的 InnoDB 存储引擎使用 B+树作为索引结构。
]

== Trie树（前缀树）

Trie树是一种用于字符串检索的多叉树结构。

=== Trie树的结构特点

- 根节点不包含字符
- 每条边代表一个字符
- 从根到某节点的路径上的字符连接起来，即为该节点对应的字符串
- 每个节点的所有子节点包含的字符都不相同

=== Trie树的基本操作

==== 插入

```cpp
struct TrieNode {
    TrieNode* children[26];
    bool isEnd;

    TrieNode() {
        for (int i = 0; i < 26; ++i) {
            children[i] = nullptr;
        }
        isEnd = false;
    }
};

void insert(TrieNode* root, string word) {
    TrieNode* node = root;
    for (char c : word) {
        int idx = c - 'a';
        if (!node->children[idx]) {
            node->children[idx] = new TrieNode();
        }
        node = node->children[idx];
    }
    node->isEnd = true;
}
```

==== 查找

```cpp
bool search(TrieNode* root, string word) {
    TrieNode* node = root;
    for (char c : word) {
        int idx = c - 'a';
        if (!node->children[idx]) {
            return false;
        }
        node = node->children[idx];
    }
    return node->isEnd;
}
```

=== Trie树的应用场景

- 自动补全
- 拼写检查
- IP路由表查找
- 词频统计

*时间复杂度*：$O(m)$，其中 m 是字符串长度

#tip[
  Trie树的空间消耗较大，可以使用压缩Trie（基数树）或双数组Trie来优化。
]

== 其他树形结构

=== 后缀树与后缀数组

后缀树是一种压缩Trie树，存储字符串的所有后缀。

*应用*：

- 字符串匹配
- 最长重复子串
- 最长公共子串

*后缀数组*：后缀树的数组实现，空间效率更高。

=== 线段树

线段树是一种二叉树，用于高效处理区间查询和更新。

*应用*：

- 区间求和
- 区间最值
- 区间更新

*时间复杂度*：查询和更新均为 $O(log n)$

=== 树状数组（Fenwick Tree）

树状数组是一种简洁的数据结构，用于维护前缀和。

*优势*：

- 代码简洁
- 常数小
- 空间效率高

*应用*：

- 前缀和查询
- 单点更新
- 逆序对计数

#fancy-divider

本章介绍了常见的树形查找结构。BST是基础，AVL和红黑树通过平衡机制保证性能，B树/B+树专为磁盘优化，Trie树用于字符串处理。不同的树适用于不同的场景，选择合适的树结构可以显著提升系统性能。



= 哈希表

哈希表通过哈希函数将关键字映射到表中的位置，实现快速查找。

#note[
  本章介绍哈希表的基本原理、Hash函数构造、冲突处理、性能分析以及工程应用。
]

== 散列表基本概念

=== 什么是散列表

散列表（Hash Table）是一种基于*键值对*（Key-Value）的数据结构，通过哈希函数将键映射到表中的位置，从而实现快速的插入、删除和查找操作。

=== 核心思想

1. *哈希函数*：将任意长度的键映射为固定范围的整数（哈希地址）
2. *冲突处理*：当多个键映射到同一位置时，采用特定策略解决
3. *装填因子*：衡量哈希表的拥挤程度，影响性能

=== 哈希表的特点

*优点*：

- 平均情况下，插入、删除、查找的时间复杂度为 $O(1)$
- 实现简单，应用广泛

*缺点*：

- 最坏情况下退化为 $O(n)$
- 不支持范围查询和排序
- 需要良好的哈希函数和冲突处理策略

未完待续...

== Hash函数构造方法

Hash函数的目标是将键均匀地分布到哈希表中，减少冲突。

=== 直接定址法

$h("key") = "key"$ 或 $h("key") = a * "key" + b$

*优点*：简单、无冲突

*缺点*：只适用于关键字分布连续的情况

=== 除留余数法

$h("key") = "key" mod p$，其中 $p <= m$（表长）

*优点*：最简单、最常用

*注意*：p 最好选择素数

#tip[
  除留余数法是最常用的哈希函数构造方法，实际应用中优先选择。
]

=== 其他构造方法

==== 数字分析法

抽取关键字中分布均匀的若干位作为哈希地址。

*适用场景*：关键字位数较多，且某些位分布均匀

==== 平方取中法

取关键字平方后的中间几位作为哈希地址。

*优点*：适用于关键字分布不均匀的情况

==== 折叠法

将关键字分割成位数相同的几部分，然后取叠加和作为哈希地址。

*适用场景*：关键字位数很多

==== 随机数法

$h("key") = "random"("key")$

*适用场景*：关键字长度不等

未完待续...

== 冲突处理：开放定址法

当发生冲突时，按照某种探测序列寻找下一个空闲位置。

=== 线性探测法

$h_i("key") = (h("key") + i) mod m$，$i = 1, 2, ..., m-1$

*优点*：实现简单

*缺点*：容易产生*聚集*现象

=== 二次探测法

$h_i("key") = (h("key") + i^2) mod m$ 或 $h_i("key") = (h("key") - i^2) mod m$

*优点*：减少了一次聚集

*缺点*：仍然可能存在二次聚集

=== 伪随机探测法

$h_i("key") = (h("key") + "pseudo_random"(i)) mod m$

*优点*：进一步减少聚集

未完待续...

== 冲突处理：链地址法与其他方法

=== 链地址法（拉链法）

将所有哈希地址相同的记录链接成一个单链表。

*优点*：

- 不会产生聚集
- 删除操作简单
- 装填因子可以大于1

*缺点*：

- 需要额外的指针空间
- 缓存友好性较差

#note[
  Java 的 `HashMap`、C++ 的 `unordered_map` 都使用链地址法处理冲突。
]

=== 再哈希法

当发生冲突时，使用另一个哈希函数计算新的地址。

*优点*：不易产生聚集

*缺点*：增加计算时间

=== 建立公共溢出区

将哈希表分为基本表和溢出表两部分，所有冲突的记录都放入溢出表。

未完待续...

== 性能分析与扩容策略

=== 装填因子与性能分析

哈希表的性能取决于*装填因子* $alpha$：

$alpha = frac{n}{m} = frac{"表中记录数"}{"哈希表长度"}$

*查找成功的平均查找长度*：

- 链地址法：$"ASL" approx 1 + frac{alpha}{2}$
- 线性探测法：$"ASL" approx frac{1}{2}(1 + frac{1}{1-alpha})$

*查找失败的平均查找长度*：

- 链地址法：$"ASL" approx alpha + e^{-alpha}$
- 线性探测法：$"ASL" approx frac{1}{2}(1 + frac{1}{(1-alpha)^2})$

#caution[
  装填因子越大，冲突概率越高，查找效率越低。一般建议 $alpha <= 0.75$。
]

=== 哈希表的扩容与Rehash

当装填因子超过阈值时，需要扩大哈希表容量并重新哈希所有元素。

*扩容策略*：

- 通常将表长扩大为原来的2倍
- 选择新的表长为素数
- 重新计算所有元素的哈希值并插入新表

*时间复杂度*：$O(n)$，但平摊到每次插入操作为 $O(1)$

未完待续...

== 一致性哈希算法

一致性哈希用于分布式缓存系统，解决节点增减时的数据迁移问题。

=== 核心思想

- 将哈希空间组织成一个环
- 节点和数据都映射到环上
- 数据存储在顺时针方向的第一个节点上

=== 优点

- 节点增减时，只有少量数据需要迁移
- 负载均衡效果好

#note[
  Redis集群、Memcached等分布式缓存系统都使用一致性哈希。
]

== 布隆过滤器

布隆过滤器是一种空间高效的概率型数据结构，用于判断元素是否在集合中。

=== 工作原理

- 使用多个哈希函数将元素映射到位数组的多个位置
- 查询时，检查所有对应位置是否都为1

=== 特点

- 可能存在误判（假阳性），但不会漏判（假阴性）
- 空间效率极高
- 不支持删除操作（可使用计数布隆过滤器解决）

=== 应用场景

- 网页去重
- 缓存穿透防护
- 垃圾邮件过滤

#tip[
  布隆过滤器的误判率可以通过调整位数组大小和哈希函数数量来控制。
]

== 工程应用

=== 数据库索引设计

哈希索引 vs B+树索引：

#tex-table(
  ("特性", "哈希索引", "B+树索引"),
  ("等值查询", "$O(1)$", "$O(log n)$"),
  ("范围查询", "不支持", "支持"),
  ("排序", "不支持", "支持"),
  ("最左前缀", "不支持", "支持"),
  ("空间占用", "较小", "较大"),
)

#note[
  MySQL 的 Memory 存储引擎支持哈希索引，InnoDB 支持自适应哈希索引。
]

=== 倒排索引与搜索引擎

倒排索引是搜索引擎的核心数据结构。

*结构*：

```
单词 -> [文档ID列表]
```

*应用*：

- 全文检索
- 关键词匹配
- 相关性排序

=== LRU缓存设计与实现

LRU（Least Recently Used）缓存淘汰最近最少使用的数据。

*实现方式*：

- 哈希表 + 双向链表
- 哈希表提供 $O(1)$ 查找
- 双向链表维护访问顺序

*时间复杂度*：

- 查找：$O(1)$
- 插入：$O(1)$
- 删除：$O(1)$

#fancy-divider

本章介绍了哈希表的基本原理、Hash函数构造、冲突处理策略、性能分析以及工程应用。哈希表作为一种高效的数据结构，在数据库、缓存、搜索引擎等领域有着广泛的应用。

== 查找算法比较与选择

=== 各种查找算法对比

#tex-table(
  ("算法", "平均时间复杂度", "是否需要有序", "适用场景"),
  ("顺序查找", "$O(n)$", "否", "小规模、无序数据"),
  ("折半查找", "$O(log n)$", "是", "静态有序表"),
  ("分块查找", "$O(sqrt(n))$", "块间有序", "动态查找表"),
  ("BST", "$O(log n)$~$O(n)$", "隐含有序", "动态查找"),
  ("AVL树", "$O(log n)$", "隐含有序", "读多写少"),
  ("红黑树", "$O(log n)$", "隐含有序", "频繁插入删除"),
  ("B+树", "$O(log n)$", "隐含有序", "磁盘存储、数据库"),
  ("哈希表", "$O(1)$", "否", "等值查询"),
  ("Trie树", "$O(m)$", "否", "字符串检索"),
)

=== 选择策略

==== 根据数据特点选择

- *数据量小*：顺序查找即可
- *数据有序*：折半查找
- *需要范围查询*：B+树、平衡二叉树
- *只需等值查询*：哈希表
- *字符串前缀匹配*：Trie树

==== 根据操作频率选择

- *查多改少*：AVL树、B+树
- *查改频繁*：红黑树、哈希表
- *动态插入删除*：平衡二叉树、哈希表

==== 根据存储介质选择

- *内存*：哈希表、平衡二叉树
- *磁盘*：B+树、B树

#fancy-divider

本章完
