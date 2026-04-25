#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= 迭代器与生成器

迭代器和生成器是 Python 实现惰性求值和高效内存使用的核心机制。掌握它们是编写 Pythonic 代码的关键。

== 迭代协议

=== 可迭代对象 vs 迭代器

```python
# 可迭代对象（Iterable）
# 实现了 __iter__ 方法，返回迭代器
my_list = [1, 2, 3]
my_dict = {'a': 1, 'b': 2}
my_string = "hello"

# 检查是否可迭代
from collections.abc import Iterable
print(isinstance(my_list, Iterable))  # True

# 迭代器（Iterator）
# 实现了 __iter__ 和 __next__ 方法
iterator = iter(my_list)
print(next(iterator))  # 1
print(next(iterator))  # 2
print(next(iterator))  # 3
# print(next(iterator))  # StopIteration
```

#note[
  所有迭代器都是可迭代对象，但并非所有可迭代对象都是迭代器。
]

=== 手动实现迭代器

```python
class CountDown:
    """倒计时迭代器"""

    def __init__(self, start):
        self.start = start

    def __iter__(self):
        return self

    def __next__(self):
        if self.start <= 0:
            raise StopIteration
        current = self.start
        self.start -= 1
        return current

# 使用
for num in CountDown(5):
    print(num, end=' ')  # 5 4 3 2 1
```

=== 自定义可迭代对象

```python
class Fibonacci:
    """斐波那契数列可迭代对象"""

    def __init__(self, max_count=10):
        self.max_count = max_count

    def __iter__(self):
        return FibonacciIterator(self.max_count)

class FibonacciIterator:
    """斐波那契迭代器"""

    def __init__(self, max_count):
        self.max_count = max_count
        self.count = 0
        self.a, self.b = 0, 1

    def __iter__(self):
        return self

    def __next__(self):
        if self.count >= self.max_count:
            raise StopIteration

        result = self.a
        self.a, self.b = self.b, self.a + self.b
        self.count += 1
        return result

# 使用
for num in Fibonacci(10):
    print(num, end=' ')  # 0 1 1 2 3 5 8 13 21 34
```

#tip[
  将迭代逻辑分离到独立的迭代器类中，使代码更清晰、更可维护。
]

== 生成器函数

生成器是一种特殊的迭代器，使用 `yield` 关键字实现。

=== yield 基础

```python
def count_down(start):
    """倒计时生成器"""
    while start > 0:
        yield start
        start -= 1

# 使用
gen = count_down(5)
print(next(gen))  # 5
print(next(gen))  # 4

# for 循环自动处理 StopIteration
for num in count_down(5):
    print(num, end=' ')  # 5 4 3 2 1
```

#note[
  生成器函数调用时不会立即执行，而是返回一个生成器对象。每次调用 next() 时执行到下一个 yield。
]

=== 惰性求值

```python
def read_large_file(file_path):
    """逐行读取大文件，避免一次性加载到内存"""
    with open(file_path, 'r') as f:
        for line in f:
            yield line.strip()

# 使用
for line in read_large_file('huge_file.txt'):
    process(line)  # 逐行处理，内存占用极小

# 对比：传统方式会一次性加载整个文件
with open('huge_file.txt', 'r') as f:
    lines = f.readlines()  # 可能占用大量内存
```

#caution[
  生成器的惰性求值意味着数据只在需要时才生成，适合处理大数据流。
]

=== 无限序列

```python
def infinite_counter(start=0):
    """无限计数器"""
    current = start
    while True:
        yield current
        current += 1

# 使用（需要手动停止）
counter = infinite_counter(10)
for _ in range(5):
    print(next(counter), end=' ')  # 10 11 12 13 14

# 斐波那契无限序列
def fibonacci():
    a, b = 0, 1
    while True:
        yield a
        a, b = b, a + b

# 取前10个斐波那契数
fib = fibonacci()
for _ in range(10):
    print(next(fib), end=' ')  # 0 1 1 2 3 5 8 13 21 34
```

=== send() 和协程

```python
def accumulator():
    """累加器生成器"""
    total = 0
    while True:
        value = yield total
        if value is not None:
            total += value

# 使用
acc = accumulator()
next(acc)          # 启动生成器，输出 0
print(acc.send(10))  # 发送 10，输出 10
print(acc.send(20))  # 发送 20，输出 30
print(acc.send(30))  # 发送 30，输出 60

# 关闭生成器
acc.close()
```

#tip[
  `send()` 可以向生成器发送值，实现双向通信，这是协程的基础。
]

=== yield from

```python
def chain(*iterables):
    """链式迭代多个可迭代对象"""
    for iterable in iterables:
        yield from iterable

# 使用
result = list(chain([1, 2, 3], 'abc', [4, 5]))
print(result)  # [1, 2, 3, 'a', 'b', 'c', 4, 5]

# 递归生成器
def flatten(nested):
    """扁平化嵌套列表"""
    for item in nested:
        if isinstance(item, (list, tuple)):
            yield from flatten(item)
        else:
            yield item

nested = [1, [2, [3, 4]], [5, [6, [7]]]]
print(list(flatten(nested)))  # [1, 2, 3, 4, 5, 6, 7]
```

#note[
  `yield from` 简化了从子生成器中委托迭代的代码，是 Python 3.3+ 的特性。
]

== 生成器表达式

生成器表达式是列表推导式的惰性版本。

=== 基本语法

```python
# 列表推导式（立即计算，占用内存）
squares_list = [x**2 for x in range(1000000)]

# 生成器表达式（惰性计算，节省内存）
squares_gen = (x**2 for x in range(1000000))

# 逐个获取
print(next(squares_gen))  # 0
print(next(squares_gen))  # 1

# 求和（不需要创建中间列表）
total = sum(x**2 for x in range(1000000))
```

#caution[
  生成器只能遍历一次，遍历完后就 exhausted（耗尽）了。
]

=== 与列表推导式的对比

```python
import sys

# 内存占用对比
list_comp = [x**2 for x in range(10000)]
gen_exp = (x**2 for x in range(10000))

print(sys.getsizeof(list_comp))  # ~87624 bytes
print(sys.getsizeof(gen_exp))    # ~200 bytes

# 性能对比
import time

# 列表推导式
start = time.time()
sum([x**2 for x in range(1000000)])
print(f"List: {time.time() - start:.4f}s")

# 生成器表达式
start = time.time()
sum(x**2 for x in range(1000000))
print(f"Generator: {time.time() - start:.4f}s")

# 生成器通常更快，因为不需要创建中间列表
```

#tip[
  当只需要遍历一次或配合聚合函数（sum/min/max）使用时，优先选择生成器表达式。
]

=== 实际应用

```python
# 过滤大文件
with open('large_file.txt') as f:
    # 只处理包含 'error' 的行
    error_lines = (line for line in f if 'error' in line.lower())
    for line in error_lines:
        process_error(line)

# 管道式数据处理
data = range(1000)
even_squares = (x**2 for x in data if x % 2 == 0)
filtered = (x for x in even_squares if x > 100)
total = sum(filtered)

# 矩阵转置
matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
transposed = list(zip(*matrix))
# [(1, 4, 7), (2, 5, 8), (3, 6, 9)]
```

== itertools 模块

`itertools` 提供了高效的迭代工具，是 Python 标准库中的宝藏。

=== 无限迭代器

```python
import itertools

# count：无限计数
counter = itertools.count(10, 2)  # 从10开始，步长2
print([next(counter) for _ in range(5)])  # [10, 12, 14, 16, 18]

# cycle：无限循环
colors = itertools.cycle(['red', 'green', 'blue'])
print([next(colors) for _ in range(7)])
# ['red', 'green', 'blue', 'red', 'green', 'blue', 'red']

# repeat：重复元素
repeated = itertools.repeat('A', 5)
print(list(repeated))  # ['A', 'A', 'A', 'A', 'A']
```

#note[
  无限迭代器需要配合 islice 或其他限制方式使用，否则会无限循环。
]

=== 有限迭代器

```python
import itertools

# chain：链式连接
result = list(itertools.chain([1, 2], 'abc', [3, 4]))
# [1, 2, 'a', 'b', 'c', 3, 4]

# compress：根据选择器过滤
data = [1, 2, 3, 4, 5]
selectors = [True, False, True, False, True]
print(list(itertools.compress(data, selectors)))  # [1, 3, 5]

# dropwhile / takewhile
nums = [1, 3, 5, 7, 2, 4, 6]
print(list(itertools.dropwhile(lambda x: x < 5, nums)))  # [5, 7, 2, 4, 6]
print(list(itertools.takewhile(lambda x: x < 5, nums)))  # [1, 3]

# filterfalse：反向过滤
print(list(itertools.filterfalse(lambda x: x % 2 == 0, range(10))))
# [1, 3, 5, 7, 9]

# islice：切片
print(list(itertools.islice(range(100), 10, 20, 2)))  # [10, 12, 14, 16, 18]
```

=== 组合迭代器

```python
import itertools

# product：笛卡尔积
result = list(itertools.product('AB', '12'))
# [('A', '1'), ('A', '2'), ('B', '1'), ('B', '2')]

# permutations：排列
perms = list(itertools.permutations('ABC', 2))
# [('A', 'B'), ('A', 'C'), ('B', 'A'), ('B', 'C'), ('C', 'A'), ('C', 'B')]

# combinations：组合
combs = list(itertools.combinations('ABC', 2))
# [('A', 'B'), ('A', 'C'), ('B', 'C')]

# combinations_with_replacement：可重复组合
combs_rep = list(itertools.combinations_with_replacement('ABC', 2))
# [('A', 'A'), ('A', 'B'), ('A', 'C'), ('B', 'B'), ('B', 'C'), ('C', 'C')]
```

#tip[
  组合迭代器在解决排列组合问题时非常有用，比手写循环更高效。
]

=== 其他实用工具

```python
import itertools

# groupby：分组（需要先排序）
data = [
    {'name': 'Alice', 'age': 25},
    {'name': 'Bob', 'age': 30},
    {'name': 'Charlie', 'age': 25},
]

# 按年龄分组
data.sort(key=lambda x: x['age'])
for age, group in itertools.groupby(data, key=lambda x: x['age']):
    print(f"Age {age}: {[p['name'] for p in group]}")
# Age 25: ['Alice', 'Charlie']
# Age 30: ['Bob']

# starmap：解包参数映射
result = list(itertools.starmap(pow, [(2, 3), (3, 2), (4, 2)]))
# [8, 9, 16]

# tee：复制迭代器
iter1, iter2 = itertools.tee(range(5), 2)
print(list(iter1))  # [0, 1, 2, 3, 4]
print(list(iter2))  # [0, 1, 2, 3, 4]

# accumulate：累积计算
result = list(itertools.accumulate([1, 2, 3, 4, 5]))
# [1, 3, 6, 10, 15]  # 累积和

import operator
result = list(itertools.accumulate([1, 2, 3, 4, 5], operator.mul))
# [1, 2, 6, 24, 120]  # 累积乘积
```

=== 实战示例

```python
import itertools

# 示例1：生成所有可能的密码组合
def generate_passwords(chars, length):
    """生成指定长度的所有密码组合"""
    return itertools.product(chars, repeat=length)

passwords = generate_passwords('0123456789', 4)
for pwd in itertools.islice(passwords, 10):  # 只看前10个
    print(''.join(pwd))
# 0000, 0001, 0002, ...

# 示例2：滑动窗口
def sliding_window(iterable, n):
    """创建滑动窗口"""
    it = iter(iterable)
    window = tuple(itertools.islice(it, n))
    if len(window) == n:
        yield window
    for elem in it:
        window = window[1:] + (elem,)
        yield window

data = [1, 2, 3, 4, 5, 6]
for window in sliding_window(data, 3):
    print(window)
# (1, 2, 3), (2, 3, 4), (3, 4, 5), (4, 5, 6)

# 示例3：合并多个有序序列
def merge_sorted(*sorted_sequences):
    """合并多个已排序的序列"""
    return itertools.merge(*sorted_sequences)

merged = list(itertools.merge([1, 3, 5], [2, 4, 6], [0, 7, 8]))
print(merged)  # [0, 1, 2, 3, 4, 5, 6, 7, 8]
```

#fancy-divider

本章完

= 装饰器

= 描述符与元类

= 函数式编程
