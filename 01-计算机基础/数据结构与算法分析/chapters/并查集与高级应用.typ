#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= 并查集与高级应用

#note[
  并查集（Union-Find）是一种树型数据结构，用于处理不相交集合的合并及查询问题。
]

== 并查集的基本操作与优化

并查集支持两种基本操作：*查找*（Find）和*合并*（Union）。

=== 基本实现

```cpp
class UnionFind {
    vector<int> parent;

public:
    UnionFind(int n) : parent(n) {
        for (int i = 0; i < n; ++i) {
            parent[i] = i;
        }
    }

    // 查找根节点
    int find(int x) {
        if (parent[x] != x) {
            parent[x] = find(parent[x]);
        }
        return parent[x];
    }

    // 合并两个集合
    void unite(int x, int y) {
        int rootX = find(x);
        int rootY = find(y);
        if (rootX != rootY) {
            parent[rootX] = rootY;
        }
    }

    // 判断是否在同一集合
    bool connected(int x, int y) {
        return find(x) == find(y);
    }
};
```

=== 路径压缩优化

在查找过程中，将路径上的所有节点直接连接到根节点。

*效果*：

- 降低树的高度
- 加速后续查找操作

```cpp
int find(int x) {
    if (parent[x] != x) {
        parent[x] = find(parent[x]); // 路径压缩
    }
    return parent[x];
}
```

*图示*：

```
查找前:          查找后:
    1              1
   / \            /|\
  2   3    →    2 3 4
 /
4
```

=== 按秩合并优化

合并时，将较矮的树连接到较高的树上。

==== 按深度合并

```cpp
class UnionFind {
    vector<int> parent, rank;

public:
    UnionFind(int n) : parent(n), rank(n, 0) {
        iota(parent.begin(), parent.end(), 0);
    }

    int find(int x) {
        if (parent[x] != x) {
            parent[x] = find(parent[x]);
        }
        return parent[x];
    }

    void unite(int x, int y) {
        int rootX = find(x);
        int rootY = find(y);
        if (rootX == rootY) return;

        // 按深度合并
        if (rank[rootX] < rank[rootY]) {
            parent[rootX] = rootY;
        } else if (rank[rootX] > rank[rootY]) {
            parent[rootY] = rootX;
        } else {
            parent[rootY] = rootX;
            rank[rootX]++;
        }
    }
};
```

==== 按大小合并

```cpp
class UnionFind {
    vector<int> parent, size;

public:
    UnionFind(int n) : parent(n), size(n, 1) {
        iota(parent.begin(), parent.end(), 0);
    }

    void unite(int x, int y) {
        int rootX = find(x);
        int rootY = find(y);
        if (rootX == rootY) return;

        // 按大小合并，小树连到大树
        if (size[rootX] < size[rootY]) {
            swap(rootX, rootY);
        }
        parent[rootY] = rootX;
        size[rootX] += size[rootY];
    }

    int getSize(int x) {
        return size[find(x)];
    }
};
```

#tip[
  路径压缩 + 按秩合并可以使并查集的操作接近常数时间复杂度。
]

== 并查集的复杂度分析

并查集的时间复杂度分析涉及*阿克曼函数的反函数* $alpha(n)$。

=== 阿克曼函数

阿克曼函数 $A(m, n)$ 是一个增长极快的递归函数：

```
A(0, n) = n + 1
A(m, 0) = A(m-1, 1)
A(m, n) = A(m-1, A(m, n-1))
```

=== 反阿克曼函数 $alpha(n)$

$alpha(n)$ 是阿克曼函数的反函数，增长极其缓慢。

*数值示例*：

#tex-table(
  ("$n$", "$alpha(n)$"),
  ("$10^5$", "$<= 4$"),
  ("$10^{100}$", "$<= 4$"),
  ("宇宙原子数 $\\approx 10^{80}$", "$<= 4$"),
)

#note[
  对于任何实际应用场景，$alpha(n) <= 4$，因此可以认为并查集操作是常数时间的。
]

=== 复杂度结论

使用路径压缩和按秩合并的并查集：

- *单次操作*：$O(alpha(n))$
- *$m$ 次操作*：$O(m * alpha(n))$
- *实际性能*：接近 $O(1)$

== 带权并查集

带权并查集在维护集合关系的同时，还维护节点到根节点的*额外信息*。

=== 基本原理

除了 parent 数组，额外维护一个 weight 数组，记录节点到父节点的权重。

```cpp
class WeightedUnionFind {
    vector<int> parent;
    vector<double> weight; // 节点到父节点的权重

public:
    WeightedUnionFind(int n) : parent(n), weight(n, 1.0) {
        iota(parent.begin(), parent.end(), 0);
    }

    pair<int, double> find(int x) {
        if (parent[x] != x) {
            auto [root, w] = find(parent[x]);
            weight[x] *= w; // 路径压缩时更新权重
            parent[x] = root;
        }
        return {parent[x], weight[x]};
    }

    void unite(int x, int y, double ratio) {
        auto [rootX, wx] = find(x);
        auto [rootY, wy] = find(y);
        if (rootX == rootY) return;

        // x / y = ratio
        // weight[x] * ? = weight[y] * ratio
        parent[rootX] = rootY;
        weight[rootX] = wy * ratio / wx;
    }
};
```

=== 应用示例：除法求值

*问题*：给定方程式 `a/b = 2.0, b/c = 3.0`，求 `a/c`。

```cpp
vector<double> calcEquation(
    vector<vector<string>>& equations,
    vector<double>& values,
    vector<vector<string>>& queries
) {
    unordered_map<string, pair<string, double>> parent;

    function<pair<string, double>(string)> find = [&](string x) {
        if (!parent.count(x)) {
            parent[x] = {x, 1.0};
        }
        if (parent[x].first != x) {
            auto [root, w] = find(parent[x].first);
            parent[x] = {root, parent[x].second * w};
        }
        return parent[x];
    };

    // 构建并查集
    for (int i = 0; i < equations.size(); ++i) {
        auto [rootA, wa] = find(equations[i][0]);
        auto [rootB, wb] = find(equations[i][1]);
        if (rootA != rootB) {
            parent[rootA] = {rootB, wb * values[i] / wa};
        }
    }

    // 查询
    vector<double> results;
    for (auto& q : queries) {
        if (!parent.count(q[0]) || !parent.count(q[1])) {
            results.push_back(-1.0);
            continue;
        }
        auto [rootA, wa] = find(q[0]);
        auto [rootB, wb] = find(q[1]);
        if (rootA != rootB) {
            results.push_back(-1.0);
        } else {
            results.push_back(wa / wb);
        }
    }

    return results;
}
```

== 扩展域并查集

扩展域并查集（种类并查集）用于处理*多种关系*的问题。

=== 基本原理

将每个元素拆分为多个“域”，每个域代表一种状态或关系。

*示例*：食物链问题

有三种动物 A、B、C，A吃B，B吃C，C吃A。给定一些关系，判断是否矛盾。

```cpp
class ExtendedUnionFind {
    vector<int> parent;
    int n;

public:
    // 每个动物有3个域：自己、猎物、天敌
    ExtendedUnionFind(int n) : n(n), parent(3 * n) {
        iota(parent.begin(), parent.end(), 0);
    }

    int find(int x) {
        if (parent[x] != x) {
            parent[x] = find(parent[x]);
        }
        return parent[x];
    }

    void unite(int x, int y) {
        parent[find(x)] = find(y);
    }

    bool connected(int x, int y) {
        return find(x) == find(y);
    }
};

// 使用示例
int solveFoodChain(int n, vector<vector<int>>& relations) {
    ExtendedUnionFind uf(n);
    int contradictions = 0;

    for (auto& rel : relations) {
        int type = rel[0], x = rel[1] - 1, y = rel[2] - 1;

        if (x >= n || y >= n) {
            contradictions++;
            continue;
        }

        if (type == 1) { // x和y同类
            if (uf.connected(x, y + n) || uf.connected(x, y + 2*n)) {
                contradictions++; // 矛盾
            } else {
                uf.unite(x, y);
                uf.unite(x + n, y + n);
                uf.unite(x + 2*n, y + 2*n);
            }
        } else { // x吃y
            if (uf.connected(x, y) || uf.connected(x, y + 2*n)) {
                contradictions++; // 矛盾
            } else {
                uf.unite(x, y + n);     // x的猎物和y同类
                uf.unite(x + n, y + 2*n); // x的天敌和y的猎物同类
                uf.unite(x + 2*n, y);   // x和y的天敌同类
            }
        }
    }

    return contradictions;
}
```

== 可撤销并查集

可撤销并查集支持*回退*之前的合并操作，常用于分治算法。

=== 基本原理

使用*栈*记录每次合并操作，支持撤销。

*注意*：不能使用路径压缩（会破坏树结构），只能使用按秩合并。

```cpp
class UndoableUnionFind {
    vector<int> parent, rank;
    stack<pair<int, int>> history; // 记录历史操作

public:
    UndoableUnionFind(int n) : parent(n), rank(n, 0) {
        iota(parent.begin(), parent.end(), 0);
    }

    int find(int x) {
        while (parent[x] != x) {
            x = parent[x];
        }
        return x;
    }

    bool unite(int x, int y) {
        x = find(x);
        y = find(y);
        if (x == y) {
            history.push({-1, -1}); // 标记无效操作
            return false;
        }

        // 按秩合并
        if (rank[x] < rank[y]) swap(x, y);
        history.push({y, rank[x]}); // 记录被合并的根和原秩
        parent[y] = x;

        if (rank[x] == rank[y]) {
            rank[x]++;
        }

        return true;
    }

    void undo() {
        auto [y, oldRank] = history.top();
        history.pop();

        if (y == -1) return; // 无效操作

        int x = parent[y];
        parent[y] = y; // 恢复
        rank[x] = oldRank;
    }

    int snapshot() {
        return history.size();
    }

    void rollback(int snap) {
        while ((int)history.size() > snap) {
            undo();
        }
    }
};
```

=== 应用场景

- CDQ分治
- 离线图论问题
- 需要回溯的动态连通性问题

#note[
  可撤销并查集的时间复杂度为 $O(log n)$，比带路径压缩的并查集慢，但支持回退。
]

== 并查集的应用

=== 连通性问题

判断图中两个节点是否连通。

```cpp
vector<bool> checkConnectivity(
    int n,
    vector<vector<int>>& edges,
    vector<vector<int>>& queries
) {
    UnionFind uf(n);

    for (auto& edge : edges) {
        uf.unite(edge[0], edge[1]);
    }

    vector<bool> results;
    for (auto& q : queries) {
        results.push_back(uf.connected(q[0], q[1]));
    }

    return results;
}
```

=== Kruskal算法求最小生成树

```cpp
int kruskal(int n, vector<vector<int>>& edges) {
    // 按权重排序
    sort(edges.begin(), edges.end(),
         [](const vector<int>& a, const vector<int>& b) {
             return a[2] < b[2];
         });

    UnionFind uf(n);
    int mstWeight = 0;
    int edgeCount = 0;

    for (auto& edge : edges) {
        int u = edge[0], v = edge[1], w = edge[2];
        if (!uf.connected(u, v)) {
            uf.unite(u, v);
            mstWeight += w;
            edgeCount++;
            if (edgeCount == n - 1) break;
        }
    }

    return edgeCount == n - 1 ? mstWeight : -1;
}
```

=== 等价类划分

将具有等价关系的元素分组。

*示例*：朋友圈问题

```cpp
int findCircleNum(vector<vector<int>>& isConnected) {
    int n = isConnected.size();
    UnionFind uf(n);

    for (int i = 0; i < n; ++i) {
        for (int j = i + 1; j < n; ++j) {
            if (isConnected[i][j]) {
                uf.unite(i, j);
            }
        }
    }

    // 统计根节点数量
    int circles = 0;
    for (int i = 0; i < n; ++i) {
        if (uf.find(i) == i) circles++;
    }

    return circles;
}
```

#fancy-divider

本章介绍了并查集的基本操作、优化技术以及各种高级变体。并查集虽然简单，但通过不同的优化和扩展，可以解决许多复杂的问题。
