#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= 树与二叉树基础

= 树的应用

#note[
  本章介绍树的经典应用，包括哈夫曼编码、并查集、堆等数据结构。
]

== 哈夫曼树与哈夫曼编码

哈夫曼树（Huffman Tree）是一种带权路径长度最短的二叉树，也称为最优二叉树。

=== 基本概念

*带权路径长度（WPL）*：

$"WPL" = sum_{i=1}^{n} w_i dot l_i$

其中 $w_i$ 是第 $i$ 个叶子节点的权值，$l_i$ 是从根到该叶子节点的路径长度。

=== 哈夫曼树的构造算法

1. 将 $n$ 个权值看作 $n$ 棵只有根节点的二叉树，构成森林 $F$
2. 从 $F$ 中选取两棵根节点权值最小的树作为左右子树，构造一棵新的二叉树
3. 新二叉树的根节点权值为左右子树根节点权值之和
4. 从 $F$ 中删除这两棵树，将新树加入 $F$
5. 重复步骤2-4，直到 $F$ 中只剩一棵树

=== 哈夫曼编码

哈夫曼编码是一种前缀编码，用于数据压缩。

*编码规则*：

- 从根到叶子节点的路径上，左分支标记为0，右分支标记为1
- 每个叶子节点对应的二进制串即为该字符的哈夫曼编码

*特点*：

- *前缀性质*：任一字符的编码都不是另一字符编码的前缀
- *最优性*：平均编码长度最短

=== 应用示例

```cpp
// 哈夫曼树节点
struct HuffmanNode {
    char ch;
    int freq;
    HuffmanNode *left, *right;

    HuffmanNode(char c, int f) : ch(c), freq(f), left(nullptr), right(nullptr) {}
};

// 比较函数（用于优先队列）
struct Compare {
    bool operator()(HuffmanNode* a, HuffmanNode* b) {
        return a->freq > b->freq;
    }
};

// 构建哈夫曼树
HuffmanNode* buildHuffmanTree(map<char, int>& freqMap) {
    priority_queue<HuffmanNode*, vector<HuffmanNode*>, Compare> pq;

    for (auto& [ch, freq] : freqMap) {
        pq.push(new HuffmanNode(ch, freq));
    }

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

#tip[
  哈夫曼编码广泛应用于文件压缩（如ZIP、GZIP）、图像压缩（如JPEG）等领域。
]

== 并查集（Union-Find）

并查集是一种树型数据结构，用于处理不相交集合的合并及查询问题。

=== 基本操作

==== 初始化（MakeSet）

```cpp
vector<int> parent, rank_;

void makeSet(int n) {
    parent.resize(n);
    rank_.resize(n, 0);
    for (int i = 0; i < n; ++i) {
        parent[i] = i;
    }
}
```

==== 查找（Find）

```cpp
int find(int x) {
    if (parent[x] != x) {
        parent[x] = find(parent[x]); // 路径压缩
    }
    return parent[x];
}
```

==== 合并（Union）

```cpp
void unionSets(int x, int y) {
    int rootX = find(x);
    int rootY = find(y);

    if (rootX == rootY) return;

    // 按秩合并
    if (rank_[rootX] < rank_[rootY]) {
        parent[rootX] = rootY;
    } else if (rank_[rootX] > rank_[rootY]) {
        parent[rootY] = rootX;
    } else {
        parent[rootY] = rootX;
        rank_[rootX]++;
    }
}
```

=== 优化技术

==== 路径压缩

在查找过程中，将路径上的所有节点直接连接到根节点。

*效果*：大幅降低树的高度，使后续查找更快

==== 按秩合并

总是将较矮的树连接到较高的树下。

*效果*：保持树的平衡，避免退化为链表

=== 时间复杂度

- *平摊时间复杂度*：$O(alpha(n))$，其中 $alpha$ 是反阿克曼函数
- *实际表现*：几乎为常数时间 $O(1)$

#note[
  并查集广泛应用于图的连通性判断、最小生成树（Kruskal算法）、社交网络分析等场景。
]

== 堆的结构与操作

堆（Heap）是一种完全二叉树，满足堆序性，常用于实现优先队列。

=== 堆的性质

==== 完全二叉树

堆是一棵完全二叉树，可以用数组高效表示。

==== 堆序性

- *最大堆*：父节点的值大于或等于子节点的值
- *最小堆*：父节点的值小于或等于子节点的值

=== 数组实现

假设堆使用数组 `arr[]` 表示，节点编号从 0 开始：

- 父节点索引：$"parent"(i) = (i - 1) / 2$
- 左子节点索引：$"left"(i) = 2 * i + 1$
- 右子节点索引：$"right"(i) = 2 * i + 2$

#note[
  数组实现避免了显式的指针操作，空间效率高，缓存友好性好。
]

=== 基本操作

==== 插入操作（上浮）

```cpp
void insert(vector<int>& heap, int val) {
    heap.push_back(val);
    int i = heap.size() - 1;

    // 上浮调整
    while (i > 0) {
        int parent = (i - 1) / 2;
        if (heap[i] < heap[parent]) { // 最小堆
            swap(heap[i], heap[parent]);
            i = parent;
        } else {
            break;
        }
    }
}
```

*时间复杂度*：$O(log n)$

==== 删除堆顶（下沉）

```cpp
int extractMin(vector<int>& heap) {
    if (heap.empty()) throw runtime_error("Heap is empty");

    int minVal = heap[0];
    heap[0] = heap.back();
    heap.pop_back();

    // 下沉调整
    int i = 0;
    int n = heap.size();

    while (true) {
        int left = 2 * i + 1;
        int right = 2 * i + 2;
        int smallest = i;

        if (left < n && heap[left] < heap[smallest]) {
            smallest = left;
        }
        if (right < n && heap[right] < heap[smallest]) {
            smallest = right;
        }

        if (smallest != i) {
            swap(heap[i], heap[smallest]);
            i = smallest;
        } else {
            break;
        }
    }

    return minVal;
}
```

*时间复杂度*：$O(log n)$

==== 建堆操作

```cpp
void heapify(vector<int>& arr, int n, int i) {
    int smallest = i;
    int left = 2 * i + 1;
    int right = 2 * i + 2;

    if (left < n && arr[left] < arr[smallest]) {
        smallest = left;
    }
    if (right < n && arr[right] < arr[smallest]) {
        smallest = right;
    }

    if (smallest != i) {
        swap(arr[i], arr[smallest]);
        heapify(arr, n, smallest);
    }
}

void buildHeap(vector<int>& arr) {
    int n = arr.size();

    // 从最后一个非叶子节点开始下沉
    for (int i = n / 2 - 1; i >= 0; --i) {
        heapify(arr, n, i);
    }
}
```

*时间复杂度*：$O(n)$（比逐个插入的 $O(n log n)$ 更优）

#tip[
  建堆操作的时间复杂度是 $O(n)$ 而非 $O(n log n)$，这是因为大部分节点位于树的底层，下沉操作的代价很小。
]

== 堆的变种与应用

=== 二项堆（Binomial Heap）

二项堆是由多棵二项树组成的森林，支持高效的合并操作。

*特点*：

- 合并操作：$O(log n)$
- 插入、删除最小值：$O(log n)$
- 减小键值：$O(log n)$

=== 斐波那契堆（Fibonacci Heap）

斐波那契堆是一种更复杂的堆结构，具有更好的平摊性能。

*特点*：

- 插入、合并、减小键值：$O(1)$ 平摊时间
- 删除最小值：$O(log n)$ 平摊时间

*应用*：

- Dijkstra最短路径算法
- Prim最小生成树算法

#caution[
  斐波那契堆虽然理论性能好，但常数因子大，实际应用中二项堆或普通二叉堆可能更高效。
]

=== 堆的应用场景

==== 优先队列

堆是优先队列的标准实现方式。

*应用*：

- 任务调度
- 事件驱动模拟
- 图算法（Dijkstra、Prim）

==== 堆排序

基于堆的排序算法，时间复杂度稳定为 $O(n log n)$。

==== Top K问题

使用大小为 $K$ 的最小堆可以高效找到最大的 $K$ 个元素。

*时间复杂度*：$O(n log k)$

#fancy-divider

本章介绍了树的经典应用：哈夫曼编码用于数据压缩，并查集用于集合合并与查询，堆用于优先队列和排序。这些数据结构在实际工程中有着广泛的应用。
