#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= Python 入门与环境搭建

= 基础语法

= 数据结构基础

Python 提供了丰富的内置数据结构，包括列表、元组、字典和集合。掌握这些数据结构是 Python 编程的基础。

== 列表（List）

列表是 Python 中最常用的可变序列类型。

=== 创建与初始化

```python
# 基本创建
fruits = ['apple', 'banana', 'cherry']
numbers = [1, 2, 3, 4, 5]
mixed = [1, 'hello', 3.14, True]

# 空列表
empty = []
empty = list()

# 列表推导式
squares = [x**2 for x in range(10)]
evens = [x for x in range(20) if x % 2 == 0]

# 嵌套列表
matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
]
```

#tip[
  列表推导式比传统循环更简洁、更高效，是 Python 的标志性特性。
]

=== 切片操作

```python
numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

# 基本切片
print(numbers[2:5])     # [2, 3, 4]
print(numbers[:3])      # [0, 1, 2]
print(numbers[7:])      # [7, 8, 9]

# 步长
print(numbers[::2])     # [0, 2, 4, 6, 8]
print(numbers[1::2])    # [1, 3, 5, 7, 9]

# 负数索引
print(numbers[-1])      # 9
print(numbers[-3:])     # [7, 8, 9]

# 反转列表
print(numbers[::-1])    # [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

# 切片赋值
numbers[2:5] = [20, 30, 40]
print(numbers)          # [0, 1, 20, 30, 40, 5, 6, 7, 8, 9]
```

#note[
  切片返回新列表，不会修改原列表。切片赋值可以修改原列表。
]

=== 常用方法

```python
fruits = ['apple', 'banana']

# 添加元素
fruits.append('cherry')           # 末尾添加
fruits.insert(0, 'orange')        # 指定位置插入
fruits.extend(['grape', 'melon']) # 扩展列表

# 删除元素
fruits.remove('banana')           # 删除指定值
popped = fruits.pop()             # 删除并返回最后一个
popped = fruits.pop(0)            # 删除并返回指定位置
del fruits[1]                     # 删除指定索引

# 查找
index = fruits.index('apple')     # 查找索引
count = fruits.count('apple')     # 统计出现次数

# 排序
numbers = [3, 1, 4, 1, 5, 9, 2, 6]
numbers.sort()                    # 原地排序
numbers.sort(reverse=True)        # 降序
sorted_numbers = sorted(numbers)  # 返回新列表

# 其他
fruits.reverse()                  # 反转列表
fruits.clear()                    # 清空列表
copied = fruits.copy()            # 浅拷贝
```

#caution[
  `sort()` 是原地排序，返回 None；`sorted()` 返回新列表，不修改原列表。
]

=== 列表推导式进阶

```python
# 基本推导式
squares = [x**2 for x in range(10)]

# 带条件
evens = [x for x in range(20) if x % 2 == 0]

# 嵌套推导式
pairs = [(x, y) for x in range(3) for y in range(3)]

# 条件表达式
labels = ['even' if x % 2 == 0 else 'odd' for x in range(10)]

# 处理嵌套列表
matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
flattened = [num for row in matrix for num in row]
# [1, 2, 3, 4, 5, 6, 7, 8, 9]

# 实际应用：过滤和转换
words = ['hello', 'world', 'python', 'programming']
upper_words = [w.upper() for w in words if len(w) > 5]
# ['PYTHON', 'PROGRAMMING']
```

#tip[
  复杂的推导式会降低可读性，此时应使用传统循环。
]

== 元组（Tuple）

元组是不可变的序列类型，适合存储固定数据。

=== 创建与特性

```python
# 基本创建
point = (3, 4)
color = ('red', 'green', 'blue')
single = (42,)  # 单元素元组需要逗号
empty = ()

# 不使用括号
point = 3, 4

# 不可变性
t = (1, 2, 3)
# t[0] = 10  # TypeError: 不支持赋值

# 但可以包含可变对象
t = ([1, 2], [3, 4])
t[0].append(3)  # 可以修改列表内容
print(t)  # ([1, 2, 3], [3, 4])
```

#note[
  元组的不可变性使其可以作为字典的键，而列表不行。
]

=== 解包赋值

```python
# 基本解包
point = (3, 4)
x, y = point
print(x, y)  # 3 4

# 交换变量
a, b = 1, 2
a, b = b, a  # Pythonic 的交换方式

# 星号解包
first, *middle, last = [1, 2, 3, 4, 5]
print(first)   # 1
print(middle)  # [2, 3, 4]
print(last)    # 5

# 函数返回多值
def get_name_age():
    return 'Alice', 25

name, age = get_name_age()

# 嵌套解包
nested = (1, (2, 3), 4)
a, (b, c), d = nested
```

#tip[
  解包赋值让代码更简洁，是 Python 的重要特性。
]

=== 命名元组

```python
from collections import namedtuple

# 定义命名元组
Point = namedtuple('Point', ['x', 'y'])
Color = namedtuple('Color', ['red', 'green', 'blue'])

# 创建实例
p = Point(3, 4)
c = Color(255, 128, 0)

# 访问字段
print(p.x, p.y)       # 3 4
print(c.red)          # 255

# 仍然支持索引
print(p[0], p[1])     # 3 4

# 转换为字典
print(p._asdict())    # {'x': 3, 'y': 4}

# 替换字段（返回新元组）
p2 = p._replace(x=10)
print(p2)             # Point(x=10, y=4)

# 从字典创建
data = {'x': 5, 'y': 10}
p3 = Point(**data)
```

#note[
  命名元组比普通元组更具可读性，比字典更轻量，适合表示简单记录。
]

== 字典（Dict）

字典是键值对集合，提供 O(1) 的查找性能。

=== 创建与基本操作

```python
# 基本创建
student = {
    'name': 'Alice',
    'age': 20,
    'major': 'Computer Science'
}

# 空字典
empty = {}
empty = dict()

# 从键值对创建
student = dict(name='Alice', age=20, major='CS')

# 从列表创建
pairs = [('name', 'Alice'), ('age', 20)]
student = dict(pairs)

# 访问值
print(student['name'])        # Alice
print(student.get('age'))     # 20
print(student.get('grade', 'N/A'))  # N/A（默认值）

# 修改和添加
student['age'] = 21
student['grade'] = 'A'

# 删除
del student['grade']
age = student.pop('age')
last_item = student.popitem()  # 删除最后一项
```

#caution[
  访问不存在的键会抛出 KeyError，建议使用 `get()` 方法提供默认值。
]

=== 字典推导式

```python
# 基本推导式
squares = {x: x**2 for x in range(5)}
# {0: 0, 1: 1, 2: 4, 3: 9, 4: 16}

# 带条件
even_squares = {x: x**2 for x in range(10) if x % 2 == 0}

# 键值转换
original = {'a': 1, 'b': 2, 'c': 3}
reversed_dict = {v: k for k, v in original.items()}
# {1: 'a', 2: 'b', 3: 'c'}

# 实际应用：统计词频
words = ['apple', 'banana', 'apple', 'cherry', 'banana', 'apple']
word_count = {word: words.count(word) for word in set(words)}
# {'apple': 3, 'banana': 2, 'cherry': 1}
```

=== defaultdict 和 OrderedDict

```python
from collections import defaultdict, OrderedDict

# defaultdict：自动初始化缺失键
word_count = defaultdict(int)
for word in ['apple', 'banana', 'apple']:
    word_count[word] += 1
print(word_count)  # defaultdict(<class 'int'>, {'apple': 2, 'banana': 1})

# 其他类型的 defaultdict
list_dict = defaultdict(list)
list_dict['fruits'].append('apple')
list_dict['fruits'].append('banana')

set_dict = defaultdict(set)
set_dict['tags'].add('python')
set_dict['tags'].add('programming')

# OrderedDict：保持插入顺序（Python 3.7+ 普通字典也保持顺序）
od = OrderedDict()
od['first'] = 1
od['second'] = 2
od['third'] = 3

# 移动到末尾
od.move_to_end('first')

# 弹出第一项
od.popitem(last=False)
```

#tip[
  Python 3.7+ 中，普通字典已经保持插入顺序，OrderedDict 主要用于需要顺序敏感操作的场景。
]

=== 字典常用方法

```python
student = {'name': 'Alice', 'age': 20, 'major': 'CS'}

# 遍历
for key in student:
    print(key, student[key])

for key, value in student.items():
    print(f'{key}: {value}')

# 合并字典（Python 3.9+）
dict1 = {'a': 1, 'b': 2}
dict2 = {'c': 3, 'd': 4}
merged = dict1 | dict2

# 旧版本合并
merged = {**dict1, **dict2}
merged = dict1.copy()
merged.update(dict2)

# 其他方法
keys = student.keys()
values = student.values()
items = student.items()

exists = 'name' in student  # True
size = len(student)         # 3
```

== 集合（Set）

集合是无序的不重复元素集合，支持数学集合运算。

=== 创建与基本操作

```python
# 基本创建
fruits = {'apple', 'banana', 'cherry'}
numbers = set([1, 2, 3, 4, 5])
empty = set()  # 注意：{} 是空字典

# 添加和删除
fruits.add('orange')
fruits.remove('banana')      # 不存在会报错
fruits.discard('grape')      # 不存在不报错
popped = fruits.pop()        # 随机删除一个

# 集合推导式
squares = {x**2 for x in range(10)}
unique_lengths = {len(word) for word in ['hello', 'world', 'python']}
```

#note[
  集合常用于去重和 membership test（成员测试），后者时间复杂度为 O(1)。
]

=== 集合运算

```python
A = {1, 2, 3, 4, 5}
B = {4, 5, 6, 7, 8}

# 并集
print(A | B)              # {1, 2, 3, 4, 5, 6, 7, 8}
print(A.union(B))

# 交集
print(A & B)              # {4, 5}
print(A.intersection(B))

# 差集
print(A - B)              # {1, 2, 3}
print(A.difference(B))

# 对称差集
print(A ^ B)              # {1, 2, 3, 6, 7, 8}
print(A.symmetric_difference(B))

# 子集和超集
C = {1, 2, 3}
print(C < A)              # True（C 是 A 的子集）
print(A > C)              # True（A 是 C 的超集）
print(C <= A)             # True（C 是 A 的子集或相等）

# 不相交
D = {6, 7, 8}
print(A.isdisjoint(D))    # True
```

#tip[
  集合运算在处理数据去重、查找共同元素等场景非常有用。
]

=== frozenset

```python
# frozenset 是不可变集合
frozen = frozenset([1, 2, 3, 4, 5])

# 可以作为字典的键
mapping = {frozenset([1, 2]): 'pair', frozenset([3, 4, 5]): 'triple'}

# 可以作为集合的元素
outer = {frozenset([1, 2]), frozenset([3, 4])}

# 不可修改
# frozen.add(6)  # AttributeError
```

#note[
  frozenset 的不可变性使其可以哈希，因此可以作为字典的键或其他集合的元素。
]

== 字符串高级操作

=== split 和 join

```python
# split：分割字符串
text = "apple,banana,cherry"
fruits = text.split(',')
# ['apple', 'banana', 'cherry']

# 限制分割次数
path = "/usr/local/bin/python"
parts = path.split('/', 2)
# ['', 'usr', 'local/bin/python']

# rsplit：从右边分割
filename = "archive.tar.gz"
name, ext = filename.rsplit('.', 1)
# name='archive.tar', ext='gz'

# splitlines：按行分割
multiline = "line1\nline2\nline3"
lines = multiline.splitlines()
# ['line1', 'line2', 'line3']

# join：连接字符串
fruits = ['apple', 'banana', 'cherry']
text = ', '.join(fruits)
# 'apple, banana, cherry'

# 实际应用：CSV 处理
csv_line = ','.join(['Alice', '25', 'Engineer'])
fields = csv_line.split(',')
```

=== 正则表达式

```python
import re

# 基本匹配
pattern = r'\d{3}-\d{4}'
text = 'Phone: 123-4567'
match = re.search(pattern, text)
if match:
    print(match.group())  # 123-4567

# 查找所有匹配
emails = re.findall(r'[\w.]+@[\w.]+', 'Contact: alice@example.com, bob@test.org')
# ['alice@example.com', 'bob@test.org']

# 替换
phone = re.sub(r'\d{3}-\d{4}', '***-****', 'Call 123-4567 or 890-1234')
# 'Call ***-**** or ***-****'

# 分组
pattern = r'(\d{4})-(\d{2})-(\d{2})'
text = 'Date: 2024-01-15'
match = re.search(pattern, text)
if match:
    year, month, day = match.groups()
    print(f'{year}年{month}月{day}日')

# 编译正则（提高性能）
pattern = re.compile(r'\d+')
numbers = pattern.findall('There are 123 apples and 456 oranges')
# ['123', '456']

# 常用模式
patterns = {
    'email': r'[\w.-]+@[\w.-]+\.\w+',
    'phone': r'\d{3}-\d{4}|\d{11}',
    'url': r'https?://[\w./-]+',
    'ip': r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}',
    'date': r'\d{4}-\d{2}-\d{2}',
}
```

#caution[
  使用原始字符串（r''）定义正则表达式，避免转义字符问题。
]

=== 文本处理技巧

```python
# 大小写转换
text = "Hello World"
print(text.lower())       # hello world
print(text.upper())       # HELLO WORLD
print(text.title())       # Hello World
print(text.capitalize())  # Hello world
print(text.swapcase())    # hELLO wORLD

# 去除空白
text = "  hello  \n"
print(text.strip())       # hello
print(text.lstrip())      # hello  \n
print(text.rstrip())      #   hello

# 填充和对齐
text = "Python"
print(text.center(20, '-'))   # -------Python-------
print(text.ljust(20, '-'))    # Python--------------
print(text.rjust(20, '-'))    # --------------Python
print(text.zfill(10))         # 0000Python

# 查找和替换
text = "Hello World"
print(text.find('World'))     # 6（找不到返回-1）
print(text.index('World'))    # 6（找不到抛出异常）
print(text.replace('World', 'Python'))  # Hello Python
print(text.replace('l', 'L', 1))        # HeLlo World

# 判断方法
text = "Hello123"
print(text.isalpha())    # False
print(text.isdigit())    # False
print(text.isalnum())    # True
print(text.startswith('Hello'))  # True
print(text.endswith('123'))      # True

# 格式化字符串
name = 'Alice'
age = 25
# f-string（推荐）
print(f'{name} is {age} years old')
# format 方法
print('{} is {} years old'.format(name, age))
# % 格式化（旧式）
print('%s is %d years old' % (name, age))
```

#tip[
  f-string（Python 3.6+）是最快、最可读的字符串格式化方式。
]

=== 实战：文本处理示例

```python
import re
from collections import Counter

# 词频统计
def word_frequency(text):
    # 转换为小写并提取单词
    words = re.findall(r'\b[a-zA-Z]+\b', text.lower())
    return Counter(words)

text = "Python is great. Python is easy. Python is powerful."
freq = word_frequency(text)
print(freq.most_common(3))
# [('python', 3), ('is', 3), ('great', 1)]

# 验证邮箱格式
def validate_email(email):
    pattern = r'^[\w.-]+@[\w.-]+\.\w+$'
    return bool(re.match(pattern, email))

print(validate_email('alice@example.com'))  # True
print(validate_email('invalid@email'))      # False

# 提取 URL
def extract_urls(text):
    pattern = r'https?://[\w./-]+'
    return re.findall(pattern, text)

text = "Visit https://python.org or http://example.com"
urls = extract_urls(text)
print(urls)  # ['https://python.org', 'http://example.com']
```

#fancy-divider

本章完

= 函数与模块化

= 面向对象编程（OOP）

= 异常处理
