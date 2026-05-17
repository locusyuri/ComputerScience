#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= 字符串处理

字符串是Java中最常用的数据类型之一。Java提供了丰富的API来处理字符串，包括不可变的 `String`、可变的 `StringBuilder` 和 `StringBuffer`，以及强大的正则表达式支持。

#note[
  Java字符串的核心特性是*不可变性*（Immutability）。一旦创建，String对象的内容就不能被修改。这个设计带来了线程安全、缓存友好等优势，但也需要注意性能问题。
]

== String类详解

=== 字符串的不可变性

String对象一旦创建，其内容就不能改变：

```java
String s = "Hello";
s.concat(" World"); // 返回新字符串，s本身不变
System.out.println(s); // 输出: Hello

String t = s.concat(" World"); // 需要接收返回值
System.out.println(t); // 输出: Hello World
```

*为什么设计为不可变*：

1. *安全性*：防止恶意代码修改字符串
2. *线程安全*：多个线程可以安全共享
3. *缓存哈希码*：提高HashMap等集合的性能
4. *字符串常量池*：节省内存

#caution[
  频繁拼接字符串时，不要使用String的 `+` 或 `concat()`，应该使用StringBuilder。
]

=== 字符串常量池

JVM维护一个字符串常量池，用于存储字符串字面量：

```java
String s1 = "Hello"; // 从常量池获取
String s2 = "Hello"; // 从常量池获取同一个对象
String s3 = new String("Hello"); // 在堆上创建新对象

System.out.println(s1 == s2);    // true (同一引用)
System.out.println(s1 == s3);    // false (不同对象)
System.out.println(s1.equals(s3)); // true (内容相同)
```

*intern()方法*：

```java
String s4 = new String("World").intern();
String s5 = "World";
System.out.println(s4 == s5); // true (都指向常量池)
```

#tip[
  使用 `equals()` 比较字符串内容，使用 `==` 比较引用。大多数情况下应该使用 `equals()`。
]

=== 常用方法

==== 基本信息

```java
String str = "Hello, World!";

// 长度
int len = str.length(); // 13

// 是否为空
boolean empty = str.isEmpty(); // false
boolean blank = str.isBlank(); // false (Java 11+, 忽略空白字符)

// 字符访问
char c = str.charAt(0); // 'H'
```

==== 查找与判断

```java
String str = "Hello, World!";

// 包含
boolean contains = str.contains("World"); // true

// 前缀/后缀
boolean startsWith = str.startsWith("Hello"); // true
boolean endsWith = str.endsWith("!");         // true

// 位置
int index = str.indexOf("World");    // 7
int lastIndex = str.lastIndexOf("o"); // 8

// 判断
boolean isDigit = Character.isDigit('5');   // true
boolean isLetter = Character.isLetter('a'); // true
```

==== 截取与分割

```java
String str = "Hello, World!";

// 截取子串
String sub1 = str.substring(7);      // "World!"
String sub2 = str.substring(0, 5);   // "Hello"

// 分割
String[] parts = "apple,banana,cherry".split(",");
// ["apple", "banana", "cherry"]

// 限制分割次数
String[] limited = "a,b,c,d".split(",", 2);
// ["a", "b,c,d"]
```

#note[
  `split()` 的参数是正则表达式，特殊字符需要转义，如 `split("\\.")` 分割点号。
]

==== 替换

```java
String str = "Hello, World!";

// 替换所有
String replaced = str.replace("l", "L");
// "HeLLo, WorLd!"

// 替换第一个
String firstReplaced = str.replaceFirst("l", "L");
// "HeLlo, World!"

// 正则替换
String regexReplaced = str.replaceAll("[aeiou]", "*");
// "H*ll*, W*rld!"
```

==== 大小写转换

```java
String str = "Hello, World!";

String upper = str.toUpperCase();   // "HELLO, WORLD!"
String lower = str.toLowerCase();   // "hello, world!"

// 区域敏感的大小写转换
String turkish = "TITLE".toLowerCase(Locale.forLanguageTag("tr"));
// 土耳其语的'I'小写是'ı'（无点）
```

==== 修剪空白

```java
String str = "  Hello, World!  ";

String trimmed = str.trim();        // "Hello, World!" (去除首尾空白)
String stripped = str.strip();      // "Hello, World!" (Java 11+, Unicode感知)
String leftStripped = str.stripLeading();  // "Hello, World!  "
String rightStripped = str.stripTrailing(); // "  Hello, World!"
```

#tip[
  推荐使用 `strip()` 系列方法，它们能正确处理Unicode空白字符，而 `trim()` 只能处理ASCII空白。
]

==== 连接与格式化

```java
// 连接
String joined = String.join(", ", "apple", "banana", "cherry");
// "apple, banana, cherry"

// 格式化
String formatted = String.format("%s is %d years old", "Alice", 30);
// "Alice is 30 years old"

// 文本块 (Java 15+)
String html = """
    <html>
        <body>
            <p>Hello, World!</p>
        </body>
    </html>
    """;
```

=== String vs StringBuilder vs StringBuffer

#tex-table(
  ("特性", "String", "StringBuilder", "StringBuffer"),
  ("可变性", "不可变", "可变", "可变"),
  ("线程安全", "是", "否", "是"),
  ("性能", "低（频繁修改）", "高", "中"),
  ("适用场景", "不常修改", "单线程频繁修改", "多线程频繁修改"),
  ("同步", "N/A", "不同步", "同步"),
)

== StringBuilder与StringBuffer

=== StringBuilder（推荐）

StringBuilder是可变的字符序列，适合频繁修改字符串的场景。

==== 基本用法

```java
StringBuilder sb = new StringBuilder();

// 追加
sb.append("Hello");
sb.append(", ");
sb.append("World");
sb.append("!");

String result = sb.toString(); // "Hello, World!"
```

==== 链式调用

```java
StringBuilder sb = new StringBuilder()
    .append("Hello")
    .append(", ")
    .append("World")
    .append("!");

System.out.println(sb.toString());
```

==== 插入与删除

```java
StringBuilder sb = new StringBuilder("Hello World");

// 插入
sb.insert(5, ","); // "Hello, World"

// 删除
sb.delete(5, 7);   // "HelloWorld"
sb.deleteCharAt(5); // "Helloorld"

// 替换
sb.replace(5, 6, ", W"); // "Hello, World"
```

==== 反转

```java
StringBuilder sb = new StringBuilder("Hello");
sb.reverse(); // "olleH"
```

==== 容量管理

```java
StringBuilder sb = new StringBuilder();
System.out.println(sb.capacity()); // 16 (默认)

sb.ensureCapacity(100); // 预分配容量
System.out.println(sb.capacity()); // 至少100

//  trimToSize - 调整容量到实际大小
sb.trimToSize();
```

#tip[
  如果知道最终字符串的大致长度，可以在构造时指定初始容量，避免频繁扩容：
  `new StringBuilder(256)`
]

=== StringBuffer（线程安全）

StringBuffer与StringBuilder API完全相同，但所有方法都是同步的：

```java
StringBuffer sb = new StringBuffer();
sb.append("Hello"); // 线程安全
```

*何时使用*：

- 多线程环境共享StringBuilder
- 否则优先使用StringBuilder（性能更好）

#note[
  在现代Java应用中，很少直接使用StringBuffer。如果需要线程安全，通常使用其他并发机制。
]

=== 性能对比

```java
// 测试100000次字符串拼接
long start, end;

// String concatenation
start = System.currentTimeMillis();
String s = "";
for (int i = 0; i < 100000; i++) {
    s += "a";
}
end = System.currentTimeMillis();
System.out.println("String: " + (end - start) + "ms"); // ~5000ms

// StringBuilder
start = System.currentTimeMillis();
StringBuilder sb = new StringBuilder();
for (int i = 0; i < 100000; i++) {
    sb.append("a");
}
end = System.currentTimeMillis();
System.out.println("StringBuilder: " + (end - start) + "ms"); // ~5ms
```

*性能差异*：**StringBuilder比String快1000倍以上**

#caution[
  在循环中拼接字符串时，永远不要使用 `+=`，必须使用StringBuilder。
]

== 正则表达式

Java通过 `java.util.regex` 包提供强大的正则表达式支持。

=== Pattern和Matcher

```java
import java.util.regex.*;

// 编译正则表达式
Pattern pattern = Pattern.compile("\\d+");

// 创建匹配器
Matcher matcher = pattern.matcher("abc123def456");

// 查找所有匹配
while (matcher.find()) {
    System.out.println(matcher.group());
}
// 输出:
// 123
// 456
```

=== 常用方法

==== matches() - 完全匹配

```java
boolean match = Pattern.matches("\\d+", "123");     // true
boolean noMatch = Pattern.matches("\\d+", "123a");  // false
```

==== find() - 查找子串

```java
Pattern pattern = Pattern.compile("\\w+");
Matcher matcher = pattern.matcher("Hello World 123");

while (matcher.find()) {
    System.out.println(matcher.group());
}
// 输出:
// Hello
// World
// 123
```

==== replaceAll() / replaceFirst()

```java
String text = "The year is 2024 and month is 03";

// 替换所有数字
String replaced = text.replaceAll("\\d+", "*");
// "The year is * and month is *"

// 替换第一个
String firstReplaced = text.replaceFirst("\\d+", "****");
// "The year is **** and month is 03"
```

==== split() - 分割

```java
String[] parts = "apple,banana,cherry".split(",");
// ["apple", "banana", "cherry"]

// 使用正则分割
String[] words = "one1two2three".split("\\d+");
// ["one", "two", "three"]
```

=== 分组捕获

```java
String email = "user@example.com";
Pattern pattern = Pattern.compile("(\\w+)@(\\w+)\\.(\\w+)");
Matcher matcher = pattern.matcher(email);

if (matcher.matches()) {
    System.out.println("Full match: " + matcher.group(0));   // user@example.com
    System.out.println("Username: " + matcher.group(1));     // user
    System.out.println("Domain: " + matcher.group(2));       // example
    System.out.println("TLD: " + matcher.group(3));          // com
}
```

=== 命名分组（Java 7+）

```java
Pattern pattern = Pattern.compile("(?<username>\\w+)@(?<domain>\\w+)\\.(?<tld>\\w+)");
Matcher matcher = pattern.matcher("user@example.com");

if (matcher.matches()) {
    System.out.println(matcher.group("username")); // user
    System.out.println(matcher.group("domain"));   // example
    System.out.println(matcher.group("tld"));      // com
}
```

#tip[
  命名分组使正则表达式更易读和维护，推荐使用。
]

=== 常用正则模式

==== 验证邮箱

```java
String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
boolean isValid = email.matches(emailRegex);
```

==== 验证手机号（中国）

```java
String phoneRegex = "^1[3-9]\\d{9}$";
boolean isValid = phone.matches(phoneRegex);
```

==== 验证身份证号

```java
String idRegex = "^\\d{17}[\\dXx]$";
boolean isValid = idCard.matches(idRegex);
```

==== 提取URL

```java
String urlRegex = "https?://[^\\s]+";
Pattern pattern = Pattern.compile(urlRegex);
Matcher matcher = pattern.matcher(text);

while (matcher.find()) {
    System.out.println(matcher.group());
}
```

=== 正则表达式语法速查

#tex-table(
  ("元字符", "含义", "示例"),
  ("`.`", "任意字符", "`a.c` 匹配 abc, a1c"),
  ("`\\d`", "数字", "`\\d+` 匹配 123"),
  ("`\\w`", "单词字符", "`\\w+` 匹配 hello"),
  ("`\\s`", "空白字符", "`\\s+` 匹配空格"),
  ("`*`", "0次或多次", "`ab*c` 匹配 ac, abc, abbc"),
  ("`+`", "1次或多次", "`ab+c` 匹配 abc, abbc"),
  ("`?`", "0次或1次", "`ab?c` 匹配 ac, abc"),
  ("`{n}`", "恰好n次", "`a{3}` 匹配 aaa"),
  ("`{n,m}`", "n到m次", "`a{2,4}` 匹配 aa, aaa, aaaa"),
  ("`^`", "行首", "`^Hello` 匹配行首的Hello"),
  ("`$`", "行尾", "`World$` 匹配行尾的World"),
  ("`[...]`", "字符集", "`[aeiou]` 匹配元音字母"),
  ("`[^...]`", "否定字符集", "`[^0-9]` 匹配非数字"),
  ("`|`", "或", "`cat|dog` 匹配 cat 或 dog"),
  ("`(...)`", "分组", "`(ab)+` 匹配 ab, abab"),
)

#note[
  在Java字符串中，反斜杠需要转义，所以 `\\d` 写成 `"\\\\d"`。
]

=== 性能优化

==== 预编译Pattern

```java
// 错误：每次循环都编译正则
for (String text : texts) {
    boolean match = text.matches("\\d+"); // 慢！
}

// 正确：预编译Pattern
Pattern pattern = Pattern.compile("\\d+");
for (String text : texts) {
    Matcher matcher = pattern.matcher(text);
    boolean match = matcher.matches(); // 快！
}
```

*原因*：`Pattern.compile()` 开销较大，应该复用。

==== 使用String的便捷方法

对于简单场景，可以直接使用String的方法：

```java
// 这些方法内部会编译Pattern，适合偶尔使用
"123".matches("\\d+");
"hello".replaceAll("l", "L");
"a,b,c".split(",");
```

#tip[
  如果正则表达式会被多次使用，一定要预编译Pattern并复用。
]

== 编码与字符集

=== UTF-8编码

Java内部使用UTF-16编码，但外部交互常用UTF-8：

```java
String str = "你好世界";

// 转换为UTF-8字节数组
byte[] utf8Bytes = str.getBytes(StandardCharsets.UTF_8);

// 从UTF-8字节数组恢复字符串
String restored = new String(utf8Bytes, StandardCharsets.UTF_8);
```

#caution[
  始终显式指定字符集，不要使用平台默认编码，以避免跨平台问题。
]

=== 常见字符集问题

==== 乱码原因

1. 读取时使用错误的字符集
2. 写入时使用错误的字符集
3. 传输过程中编码丢失

==== 解决方案

```java
// 读取文件时指定编码
BufferedReader reader = new BufferedReader(
    new InputStreamReader(
        new FileInputStream("file.txt"),
        StandardCharsets.UTF_8
    )
);

// 写入文件时指定编码
BufferedWriter writer = new BufferedWriter(
    new OutputStreamWriter(
        new FileOutputStream("file.txt"),
        StandardCharsets.UTF_8
    )
);
```

== 高级字符串处理

=== StringJoiner（Java 8+）

更优雅的字符串连接：

```java
// 基本用法
StringJoiner joiner = new StringJoiner(", ");
joiner.add("apple");
joiner.add("banana");
joiner.add("cherry");
System.out.println(joiner.toString()); // "apple, banana, cherry"

// 带前后缀
StringJoiner fancyJoiner = new StringJoiner(", ", "[", "]");
fancyJoiner.add("apple").add("banana");
System.out.println(fancyJoiner); // "[apple, banana]"
```

=== Stream API处理字符串（Java 8+）

```java
List<String> words = Arrays.asList("apple", "banana", "cherry");

// 连接
String joined = words.stream()
    .collect(Collectors.joining(", "));
// "apple, banana, cherry"

// 过滤并连接
String filtered = words.stream()
    .filter(w -> w.length() > 5)
    .collect(Collectors.joining(", "));
// "banana, cherry"

// 转换并连接
String transformed = words.stream()
    .map(String::toUpperCase)
    .collect(Collectors.joining(" | "));
// "APPLE | BANANA | CHERRY"
```

=== Text Blocks（Java 15+）

多行字符串字面量：

```java
// 传统方式
String json = "{\n" +
              "  \"name\": \"Alice\",\n" +
              "  \"age\": 30\n" +
              "}";

// Text Block
String jsonBlock = """
    {
      "name": "Alice",
      "age": 30
    }
    """;
```

*优势*：

- 无需转义引号和换行
- 代码更清晰
- 适合SQL、JSON、HTML等多行文本

#tip[
  Text Blocks会自动去除每行共同的缩进，保持代码整洁。
]

=== 字符串国际化

```java
// 资源束
ResourceBundle bundle = ResourceBundle.getBundle("messages", Locale.CHINA);
String greeting = bundle.getString("greeting"); // "你好"

// 格式化
String message = MessageFormat.format(
    "{0}, 欢迎！您有 {1} 条消息",
    "张三",
    5
);
// "张三, 欢迎！您有 5 条消息"
```

== 性能最佳实践

=== 1. 避免在循环中使用字符串拼接

```java
// 错误
String result = "";
for (int i = 0; i < 10000; i++) {
    result += i; // 每次都创建新对象
}

// 正确
StringBuilder sb = new StringBuilder();
for (int i = 0; i < 10000; i++) {
    sb.append(i);
}
String result = sb.toString();
```

=== 2. 使用String.intern()谨慎

```java
// 仅在字符串重复率很高时使用
String s = computeExpensiveString().intern();
```

#caution[
  `intern()` 会将字符串放入常量池，可能导致内存泄漏。只在必要时使用。
]

=== 3. 预分配StringBuilder容量

```java
// 如果知道大致长度
StringBuilder sb = new StringBuilder(1024);
```

=== 4. 使用char[]处理大量字符

```java
// 对于极端性能敏感的场景
char[] chars = new char[1000000];
// 直接操作字符数组
```

=== 5. 合理使用substring

```java
// Java 7+ substring会复制字符数组
String sub = largeString.substring(0, 10);
// 如果不需要原字符串，考虑及时释放引用
largeString = null;
```

== 常见陷阱

=== 陷阱1：null检查

```java
String s = null;
// s.length(); // NullPointerException!

// 安全的方式
if (s != null && !s.isEmpty()) {
    // 处理
}

// 或使用Objects
if (Objects.nonNull(s) && !s.isBlank()) {
    // 处理
}
```

=== 陷阱2：equals vs ==

```java
String s1 = new String("hello");
String s2 = new String("hello");

System.out.println(s1 == s2);      // false (不同对象)
System.out.println(s1.equals(s2)); // true (相同内容)
```

#tip[
  永远使用 `equals()` 比较字符串内容，除非你明确需要比较引用。
]

=== 陷阱3：split的正则特性

```java
"a.b.c".split(".");    // [] (.是正则元字符)
"a.b.c".split("\\.");  // ["a", "b", "c"] (正确)
```

=== 陷阱4：trim vs strip

```java
String s = "\u3000hello\u3000"; // 全角空格
System.out.println(s.trim().length());   // 7 (未去除)
System.out.println(s.strip().length());  // 5 (已去除)
```

#note[
  `strip()` 是Java 11引入的，能正确处理Unicode空白字符，推荐使用。
]

== 总结

Java字符串处理的核心要点：

- *String不可变*：线程安全，但频繁修改性能差
- *StringBuilder*：单线程高性能字符串构建
- *StringBuffer*：线程安全的字符串构建（较少使用）
- *正则表达式*：强大的模式匹配工具，注意预编译优化
- *编码处理*：始终显式指定字符集，避免乱码
- *现代特性*：Text Blocks、StringJoiner、Stream API提升开发效率

#fancy-divider

掌握字符串处理是Java编程的基础，下一章将探讨*集合框架*的使用。

= 集合框架


== 集合类概述

Java 集合框架用于统一管理数据集合，核心目标是：统一操作接口、屏蔽底层实现差异、提供可组合的遍历与算法能力。

#figure(
  image("../img/img.png"),
)

=== 分类与定位

- 单列集合：以 `Collection` 为根（如 `List`、`Set`）
- 双列集合：以 `Map` 为根（键值对结构）

=== 常见实现类速览

#tex-table(
  ("实现类", "底层结构", "核心特点", "典型场景"),
  ("ArrayList", "动态数组", "随机访问快，尾插高效", "读多写少"),
  ("LinkedList", "双向链表", "中间插删更友好", "频繁插删"),
  ("HashSet", "哈希表", "去重快、通常无序", "成员判重"),
  ("TreeSet", "红黑树", "自动排序", "有序去重"),
  ("HashMap", "哈希表", "查询快", "通用键值存储"),
  ("TreeMap", "红黑树", "按键有序", "范围查询"),
)

#note[
  `List` 与 `Set` 的关键区别：
  - `List`：有序、可重复、可按索引访问
  - `Set`：元素唯一、通常不按索引访问
]


== List 接口与实现
在 Java 集合框架中，`List` 接口继承自 `Collection` 接口，代表一个有序、可重复的集合（也称为序列）。核心特性包括：

- 有序性：元素按照插入顺序存储，可通过整数索引精确访问
- 可重复性：允许存储多个相同的元素
- 索引访问：提供 `get(int index)`、`set(int index, E element)` 等方法

`List` 接口的主要实现类包括：`ArrayList`、`LinkedList`、`Vector`、`Stack` 以及并发包下的 `CopyOnWriteArrayList`。

🧱 类图与继承体系:
```text
Iterable (接口)
    │
    └── Collection (接口)
            │
            └── List (接口)
                    │
                    ├── AbstractList (抽象类)
                    │       │
                    │       ├── ArrayList (类)          // JDK 1.2
                    │       ├── AbstractSequentialList (抽象类)
                    │       │       └── LinkedList (类) // JDK 1.2
                    │       └── Vector (类)             // JDK 1.0
                    │               └── Stack (类)      // JDK 1.0
                    │
                    └── CopyOnWriteArrayList (类)        // JDK 1.5 (java.util.concurrent)
```
#note[
  - `AbstractList` 实现了 `List` 接口中除 `size()` 和 `get(int)` 之外的大部分方法
  - `AbstractSequentialList` 专为链表结构优化，`LinkedList` 继承自它
]

=== 通用方法
`List` 接口继承自 `Collection`，除了拥有 `Collection` 的所有方法外，还增加了一组基于索引位置的操作方法。以下按功能分类列出常用通用方法（所有 `List` 实现类均支持）。

==== 添加元素
#tex-table(
  ("方法", "作用", "备注"),
  (`boolean add(E e)`, "末尾添加元素", [总是返回 `true` (符合 `Collection` 接口规范)]),
  (
    `boolean add(int index, E e)`,
    "指定索引插入元素, 后续元素后移1位",
    "如果索引超出范围，会抛出 `IndexOutOfBoundsException`",
  ),
  (`boolean addAll(int index, Collection<? extends E> c)`, "在指定索引插入所有元素", "返回是否成功插入所有元素"),
  (`boolean addAll(Collection<? extends E> c)`, "末尾添加所有元素", "返回是否成功添加所有元素"),
)

==== 删除元素
#tex-table(
  ("方法", "作用", "备注"),
  (`boolean remove(int index)`, "按索引删除元素", "返回是否成功删除"),
  (`boolean remove(Object o)`, "根据元素删除", "返回是否成功删除"),
  (`boolean removeAll(Collection<?> c)`, "删除所有匹配元素", "返回是否成功删除所有匹配元素"),
  (`boolean retainAll(Collection<?> c)`, "保留所有匹配元素", "返回是否成功保留所有匹配元素"),
)

==== 获取/查询元素
#tex-table(
  ("方法", "作用", "备注"),
  (`E get(int index)`, "按索引读取元素", "随机访问"),
  (`E set(int index, E e)`, "替换元素", "返回旧值"),
  (`boolean contains(Object o)`, "判断是否包含元素", "返回是否包含"),
  (`boolean containsAll(Collection<?> c)`, "判断是否包含所有元素", "返回是否包含所有元素"),
)

==== 修改元素
#tex-table(
  ("方法", "作用", "备注"),
  (`E set(int index, E e)`, "替换元素", "返回旧值"),
)

==== 遍历/视图/排序（Java 8+）
#tex-table(
  ("方法", "作用", "备注"),
  (`Stream<E> stream()`, "返回流", "按元素顺序遍历"),
  (`Stream<E> parallelStream()`, "返回并行流", "并行遍历"),
  (`boolean sort(Comparator<? super E> comparator)`, "按比较器排序", "修改原列表"),
)

==== 其他批量操作
#tex-table(
  ("方法", "作用", "备注"),
  (`boolean isEmpty()`, "判断是否为空", "返回是否为空"),
  (`boolean clear()`, "清空列表", "返回是否成功清空"),
)


#note[
  - 索引越界：所有带 `index` 参数的方法，若 `index < 0` 或 `index >= size()`，会抛出 `IndexOutOfBoundsException`。
  - `subList` 视图特性：返回的是原列表的视图，对子列表的修改（增、删、改）会直接反映到原列表。反之，原列表结构改变后，子列表会变得不可用（抛出 `ConcurrentModificationException`）。
  - `equals` 方法：`indexOf`、`contains`、`remove(Object)` 等依赖元素的 equals 方法进行比较，自定义对象需正确重写 equals 和 hashCode。
  - `remove(int) vs remove(Object)`：若传入的是 `int` 字面量，优先匹配 `remove(int)`；若要删除值为整数的 `Integer` 对象，需强制转换：`list.remove((Integer) 42)`。
  - `List` 的相等判断：两个 `List` 对象相等，当且仅当它们元素数量相同，且对应位置的元素 equals 比较都为 `true`。
]


=== ArrayList

`ArrayList` 底层是动态数组，特点是读取快、扩容有成本。

1. 随机访问 $O(1)$
2. 末尾追加均摊 $O(1)$
3. 中间插删通常 $O(n)$（涉及元素搬移）

```java
List<String> names = new ArrayList<>();
names.add("Alice");
names.add("Bob");
names.add(1, "Tom");
System.out.println(names.get(0));
System.out.println(names);
```

=== LinkedList

`LinkedList` 底层是双向链表，支持头尾快速操作，也实现了 `Deque`。

1. 头尾插删效率高
2. 中间插删更友好（定位后修改链接）
3. 按索引随机访问慢（需要遍历）

```java
LinkedList<Integer> queue = new LinkedList<>();
queue.addLast(10);
queue.addLast(20);
queue.addFirst(5);
System.out.println(queue.removeFirst());
System.out.println(queue);
```

=== Vector 与 Stack

`Vector` 是早期线程安全动态数组实现，整体性能通常不如 `ArrayList`。`Stack` 基于 `Vector`，遵循 LIFO。

#tip[
  新代码中栈结构优先考虑 `ArrayDeque`，通常更轻量、性能更好。
]

=== ArrayList 与 LinkedList 对比

#tex-table(
  ("对比项", "ArrayList", "LinkedList"),
  ("底层结构", "动态数组", "双向链表"),
  ("随机访问", "快（O(1)）", "慢（O(n)）"),
  ("中间插删", "慢（搬移元素）", "相对更合适"),
  ("内存特性", "连续空间，缓存友好", "节点额外指针开销"),
  ("典型场景", "读多写少", "频繁插删"),
)


== Set 接口与实现

`Set` 的核心语义是“不重复”。重复判定依赖 `equals()` 与 `hashCode()`（哈希实现）或比较器（有序树实现）。

=== HashSet

基于哈希表，通常无序，查找/插入/删除平均接近 $O(1)$。

=== LinkedHashSet

在哈希结构上维护插入顺序，适合“去重 + 保序”。

=== TreeSet

基于红黑树，自动排序，复杂度通常 $O(log n)$。

==== TreeSet 常用有序方法

#tex-table(
  ("方法", "作用"),
  ("first() / last()", "取首尾元素"),
  ("pollFirst() / pollLast()", "取并删首尾元素"),
  ("headSet(to)", "小于 to 的子集"),
  ("subSet(from, to)", "区间子集"),
  ("tailSet(from)", "大于等于 from 的子集"),
)

=== Set 实现对比

#tex-table(
  ("实现", "有序性", "复杂度", "null", "场景"),
  ("HashSet", "通常无序", "平均 O(1)", "支持", "快速去重"),
  ("LinkedHashSet", "按插入顺序", "平均 O(1)", "支持", "去重并保序"),
  ("TreeSet", "按比较规则", "O(log n)", "默认不支持（依赖比较器）", "有序集合"),
)


== Map 接口与实现

`Map` 保存键值映射，键唯一，值可重复。

=== Map 常用方法

#tex-table(
  ("方法", "作用"),
  ("put", "新增/覆盖键值"),
  ("get", "按 key 查 value"),
  ("remove", "删除映射"),
  ("containsKey", "是否存在 key"),
  ("entrySet", "遍历键值对"),
)

=== HashMap

`HashMap` 是最常用实现，JDK 8 起底层可概括为“数组 + 链表 + 红黑树”。

==== 关键参数

#tex-table(
  ("参数", "默认值", "说明"),
  ("initialCapacity", "16", "初始桶数量（2 的幂）"),
  ("loadFactor", "0.75", "触发扩容阈值比例"),
  ("TREEIFY_THRESHOLD", "8", "链表树化阈值"),
  ("UNTREEIFY_THRESHOLD", "6", "树退化阈值"),
  ("MIN_TREEIFY_CAPACITY", "64", "最小树化容量"),
)

==== put 流程（简化）

1. 计算 key 哈希并定位桶
2. 桶为空则直接插入
3. 桶非空则处理冲突（链表/树）
4. 超阈值触发扩容或树化

```java
Map<String, Integer> scores = new HashMap<>();
scores.put("Java", 95);
scores.put("Python", 92);
scores.put(null, 100);
System.out.println(scores.get("Java"));
```

#warning[
  作为 key 的自定义对象，必须正确重写 `equals()` 与 `hashCode()`，否则可能出现“放得进去、取不出来”。
]

==== 图示占位：HashMap 底层结构

#info[
  图示占位：这里应有“HashMap 数组-桶-链表-红黑树结构图”。
]

=== LinkedHashMap

在 HashMap 基础上维护双向链表，支持插入顺序或访问顺序。

```java
Map<Integer, String> cache = new LinkedHashMap<>(4, 0.75f, true) {
		@Override
		protected boolean removeEldestEntry(Map.Entry<Integer, String> eldest) {
				return size() > 3;
		}
};
```

==== 图示占位：LRU 访问顺序

#info[
  图示占位：这里应有“LinkedHashMap(accessOrder=true) 的 LRU 淘汰示意图”。
]

=== TreeMap

基于红黑树，按 key 有序，范围查询友好，复杂度通常 `O(log n)`。

=== HashMap 1.7 vs 1.8（面试高频）

#tex-table(
  ("维度", "JDK 1.7", "JDK 1.8"),
  ("结构", "数组+链表", "数组+链表+红黑树"),
  ("插入", "头插法", "尾插法"),
  ("扩容迁移", "重新计算更重", "迁移路径优化"),
  ("并发风险", "可能出现环链死循环", "修复环链问题但仍非线程安全"),
)


== ConcurrentHashMap 原理

=== 为什么 HashMap 不能直接并发用

1. 并发写可能数据覆盖
2. 历史版本扩容存在环链风险
3. 复合操作（先判再改）非原子

=== JDK 1.7 与 1.8 的并发实现差异

#tex-table(
  ("版本", "核心机制", "锁粒度", "特点"),
  ("JDK 1.7", "Segment 分段锁", "段级", "并发度受段数影响"),
  ("JDK 1.8", "CAS + synchronized", "桶级", "并发度更高"),
)

=== 选型建议

- 高并发键值存储优先 `ConcurrentHashMap`
- 读多写少列表可考虑 `CopyOnWriteArrayList`


== 集合遍历与 fail-fast

=== Iterator / ListIterator / Spliterator

#tex-table(
  ("接口", "能力", "典型场景"),
  ("Iterator", "单向遍历 + 删除当前", "通用遍历"),
  ("ListIterator", "双向遍历 + 就地增删改", "List 增强遍历"),
  ("Spliterator", "可拆分遍历", "Stream 并行支撑"),
)

=== fail-fast 机制

普通集合迭代器通常会在检测到结构性并发修改时抛 `ConcurrentModificationException`。

```java
List<Integer> list = new ArrayList<>(List.of(1, 2, 3));
for (Integer x : list) {
		if (x == 2) {
				list.remove(x); // 可能触发 ConcurrentModificationException
		}
}
```

#note[
  fail-fast 是“尽早暴露误用”的机制，不等价于线程安全保障。
]

=== 安全修改建议

1. 遍历中删除优先 `Iterator.remove()`
2. 条件删除优先 `removeIf()`
3. 并发场景改用并发容器


== 多线程集合类

=== 并发集合速查

#tex-table(
  ("集合", "特点", "适用场景"),
  ("ConcurrentHashMap", "高并发键值读写", "缓存、路由表"),
  ("CopyOnWriteArrayList", "读无锁，写复制", "读多写少配置"),
  ("ConcurrentSkipListMap", "并发有序映射", "有序并发访问"),
  ("LinkedBlockingQueue", "阻塞 FIFO", "生产者-消费者"),
  ("ArrayBlockingQueue", "有界阻塞队列", "限流缓冲"),
)

=== 普通集合 vs 并发集合

#tex-table(
  ("场景", "推荐"),
  ("单线程", "ArrayList / HashMap"),
  ("高并发读写", "ConcurrentHashMap"),
  ("读多写少", "CopyOnWriteArrayList"),
  ("任务队列", "BlockingQueue 系列"),
)


== 深拷贝

=== 深拷贝与浅拷贝

- 浅拷贝：复制外层对象，内部引用共享
- 深拷贝：递归复制内部引用对象

=== 常见实现方式

==== 构造函数复制

优点是可控、类型安全；缺点是对象层级深时代码冗长。

==== clone() 重写

需实现 `Cloneable`，并在引用字段上继续深拷贝。

==== 序列化/反序列化复制

可借助 Commons Lang、Gson、Jackson 等，开发效率高，但需关注性能与类型约束。

#tex-table(
  ("方式", "优点", "缺点", "适用"),
  ("构造函数", "显式可控", "模板代码多", "小中型对象"),
  ("clone", "JDK 原生", "易误用浅拷贝", "中等复杂度"),
  ("序列化", "实现快", "性能开销较大", "工具化场景"),
)


== 补充说明

=== 正确重写 equals 与 hashCode

放入哈希集合（`HashSet`/`HashMap`）的自定义对象，必须满足：

1. `equals` 相等的对象，`hashCode` 必须相等
2. 同一次运行期间，不变字段对应的 `hashCode` 应保持稳定

```java
public class Person {
		private String name;
		private int age;

		@Override
		public boolean equals(Object o) {
				if (this == o) return true;
				if (o == null || getClass() != o.getClass()) return false;
				Person p = (Person) o;
				return age == p.age && Objects.equals(name, p.name);
		}

		@Override
		public int hashCode() {
				return Objects.hash(name, age);
		}
}
```

=== 集合选型经验法则

#tex-table(
  ("需求", "首选"),
  ("按索引随机访问", "ArrayList"),
  ("频繁头尾操作", "ArrayDeque / LinkedList"),
  ("快速去重", "HashSet"),
  ("去重并保序", "LinkedHashSet"),
  ("有序键值查询", "TreeMap"),
  ("高并发键值", "ConcurrentHashMap"),
)

=== 时间复杂度参考

#tex-table(
  ("操作", "ArrayList", "LinkedList", "HashMap", "TreeMap"),
  ("添加", "均摊 O(1)", "O(1)", "平均 O(1)", "O(log n)"),
  ("删除", "O(n)", "按索引/值通常 O(n)", "平均 O(1)", "O(log n)"),
  ("查找", "O(1) 按索引", "O(n)", "平均 O(1)", "O(log n)"),
)

=== 不可变集合与只读视图

很多同学会把“不可变集合”和“只读视图”混为一谈，二者并不等价：

1. `List.of()` / `Set.of()` / `Map.of()` 返回真正不可变集合
2. `Collections.unmodifiableList(x)` 返回的是“只读视图”，底层 `x` 变了，视图也会变

```java
List<String> src = new ArrayList<>(List.of("A", "B"));
List<String> view = Collections.unmodifiableList(src);
src.add("C");
System.out.println(view); // [A, B, C]

List<String> imm = List.of("X", "Y");
// imm.add("Z"); // UnsupportedOperationException
```

#warning[
  对外暴露集合时，若要求“状态绝对不可被修改”，优先返回拷贝后的不可变集合，而不是只读视图。
]

=== Map 遍历性能建议

遍历 `Map` 时通常优先 `entrySet()`，避免“先遍历 key 再 get(value)”的重复查找开销。

```java
// 推荐
for (Map.Entry<String, Integer> e : map.entrySet()) {
	String k = e.getKey();
	Integer v = e.getValue();
}

// 次优（会重复哈希查找）
for (String k : map.keySet()) {
	Integer v = map.get(k);
}
```

=== 常见易错点清单

1. 在 `for-each` 中直接调用集合自身 `remove()`，触发 `ConcurrentModificationException`
2. 自定义对象做 `HashMap` key 却未同时重写 `equals/hashCode`
3. 误把 `LinkedList` 当作高性能随机访问容器
4. 并发场景继续使用 `HashMap` / `ArrayList` 做共享可变状态
5. 误以为 `unmodifiable*` 返回的是“深层不可变对象”


== 总结

掌握集合框架的关键不是背类名，而是理解这几个维度：

1. 底层结构（数组/链表/哈希/树/跳表）
2. 复杂度特征（时间与空间）
3. 语义特征（有序、可重复、null 支持）
4. 并发特征（线程安全与迭代一致性）

#emphasis[一句话：先看访问模式，再选数据结构，最后看并发与可维护性。]


= 异常处理

== 异常概述

Java 中的异常处理机制与 C\# 的核心思想类似，都是通过 `try-catch-finally` 捕获和处理运行问题。但 Java 在类型体系上更严格，尤其是“受检异常”会被编译器强制检查。

=== 基本语法结构

```java
try {
	// 需要进行异常捕获的代码块
} catch (Exception ex) {
	// 捕获异常信息；可定义多个 catch，分别处理不同异常
} finally {
	// 无论是否发生异常，都会尝试执行
}
```

=== 异常体系速览

异常根类型是 `java.lang.Throwable`，其下分为两条主线：

- `Error`：系统级严重错误，通常不建议业务代码处理
- `Exception`：程序可处理异常

`Exception` 下又分为：

- `RuntimeException` 及其子类：非检查性异常（unchecked）
- 其他 `Exception` 子类：检查性异常（checked）

#note[
  Java 的核心设计是：可预期且可恢复的问题，尽量在编译期逼迫开发者显式处理。
]

=== 常见异常一览

==== 非检查性异常（RuntimeException）

#tex-table(
  ("异常", "描述"),
  ("ArithmeticException", "整数除零等算术非法操作"),
  ("ArrayIndexOutOfBoundsException", "数组下标越界"),
  ("ClassCastException", "类型强转失败"),
  ("IllegalArgumentException", "传入参数不合法"),
  ("IllegalStateException", "对象状态不符合当前操作要求"),
  ("NegativeArraySizeException", "创建了负长度数组"),
  ("NullPointerException", "在需要对象处使用了 null"),
  ("NumberFormatException", "字符串无法转换为数值"),
  ("UnsupportedOperationException", "调用了不支持的操作"),
)

==== 检查性异常（Checked Exception）

#tex-table(
  ("异常", "描述"),
  ("ClassNotFoundException", "动态加载类时未找到目标类"),
  ("CloneNotSupportedException", "对象未实现 Cloneable 却调用 clone"),
  ("IllegalAccessException", "访问权限不满足"),
  ("InstantiationException", "试图实例化抽象类/接口"),
  ("InterruptedException", "线程被中断"),
  ("NoSuchFieldException", "反射访问字段不存在"),
  ("NoSuchMethodException", "反射访问方法不存在"),
)

=== Throwable 常用方法

#tex-table(
  ("方法", "说明"),
  ("getMessage()", "返回异常简要描述信息"),
  ("getCause()", "返回导致当前异常的根因异常"),
  ("toString()", "返回异常类型 + 消息"),
  ("printStackTrace()", "打印完整堆栈"),
  ("getStackTrace()", "返回堆栈数组供程序分析"),
  ("fillInStackTrace()", "填充当前堆栈信息"),
)


== 异常类型与层次结构

=== Throwable / Error / Exception

`Throwable` 是“可被抛出对象”的统一抽象。只有 `Throwable` 或其子类实例，才可以被 `throw` 抛出。

==== 系统错误（Error）

`Error` 一般由 JVM 抛出，表示严重运行问题。常见如：

#tex-table(
  ("类", "可能原因"),
  ("LinkageError", "类依赖在编译后发生不兼容变更"),
  ("VirtualMachineError", "JVM 运行资源不足或内部错误"),
  ("OutOfMemoryError", "内存耗尽"),
  ("NoClassDefFoundError", "类加载失败"),
  ("StackOverflowError", "递归过深导致栈溢出"),
)

#warning[
  Error 通常不属于可恢复业务异常。生产系统应以“告警 + 降级 + 保护性终止”为主，而不是继续执行业务逻辑。
]

==== 运行时异常（RuntimeException）

运行时异常通常反映程序逻辑错误，编译器不会强制捕获或声明。

- 常见场景：空引用访问、参数不合法、数组越界、类型转换失败
- 处理策略：优先修复根因，必要时在边界层统一兜底

==== 编译时异常（Checked Exception）

除 `RuntimeException` 及其子类外，大多数 `Exception` 都是受检异常，必须显式处理：

1. 使用 `try-catch` 捕获
2. 或在方法签名中用 `throws` 继续上抛

#tip[
  “可恢复并可预期”的问题，适合用 checked exception；“编程错误”通常属于 unchecked exception。
]


== 异常处理机制

=== 声明异常（throws）

方法可在签名中声明可能抛出的受检异常：

```java
public void readFile() throws IOException {
	// ...
}

public void process() throws IOException, SQLException {
	// ...
}
```

==== 重写方法时的 throws 规则

1. 子类重写方法抛出的受检异常，不能比父类更宽
2. 可以抛出父类已声明异常的子类
3. 父类方法未声明受检异常时，子类不能新增受检异常声明

=== 抛出异常（throw）

在检测到非法状态时主动抛出异常：

```java
if (age < 0) {
	throw new IllegalArgumentException("年龄不能为负数");
}
```

==== throw 与 throws 区别

- `throw`：抛出一个具体异常对象
- `throws`：声明方法可能抛出的异常类型

=== 捕获异常（try-catch-finally）

推荐按“最具体异常到最通用异常”的顺序编写多重 catch：

```java
try {
	String s = args[0];
	int n = Integer.parseInt(s);
	int r = 10 / n;
} catch (ArrayIndexOutOfBoundsException e) {
	System.out.println("缺少参数");
} catch (NumberFormatException e) {
	System.out.println("参数必须是数字");
} catch (ArithmeticException e) {
	System.out.println("除数不能为零");
} catch (Exception e) {
	System.out.println("未知错误: " + e.getMessage());
} finally {
	System.out.println("资源收尾");
}
```

==== finally 执行时机

1. try 正常结束后执行 finally
2. try 抛异常并被 catch 处理后执行 finally
3. try 抛异常未被当前方法处理，也会先执行 finally 再向上抛
4. try/catch 中出现 return，finally 仍会在方法返回前执行

==== return 与 finally 的交互

```java
public static int test1() {
	try {
		return 1;
	} finally {
		System.out.println("finally");
	}
}

public static int test2() {
	try {
		return 1;
	} finally {
		return 2; // 会覆盖 try 中的返回值（不推荐）
	}
}
```

#danger[
  不建议在 finally 中写 return。它会覆盖原返回值，甚至吞掉原始异常，导致排障困难。
]

==== finally 可能不执行的极端情况

- 调用 `System.exit()` 直接终止 JVM
- JVM 崩溃或严重错误导致进程中止
- 线程被强制终止（历史 API，如 `Thread.stop()`）

=== try-with-resources（Java 7+）

对于实现 `AutoCloseable` 的资源，优先使用自动关闭语法：

```java
try (BufferedReader br = new BufferedReader(new FileReader("file.txt"))) {
	String line = br.readLine();
	System.out.println(line);
} catch (IOException e) {
	e.printStackTrace();
}
```

==== suppressed 异常说明（易忽略）

当 `try` 块和资源关闭过程都抛异常时：

1. 主异常通常是 `try` 块中的异常
2. 关闭资源时产生的异常会被放入 `getSuppressed()`

```java
try (MyResource r = new MyResource()) {
	throw new RuntimeException("主异常");
} catch (Exception e) {
	System.out.println(e.getMessage()); // 主异常
	for (Throwable s : e.getSuppressed()) {
		System.out.println("suppressed: " + s.getMessage());
	}
}
```

#note[
  排查线上问题时，不要只看 `getMessage()`；应同时检查 `getCause()` 与 `getSuppressed()`，否则可能漏掉资源关闭阶段的关键异常。
]


== 自定义异常

=== 何时使用自定义异常

当内置异常无法准确表达业务语义时，应定义业务异常类。例如：订单状态非法、余额不足、重复提交。

=== 自定义异常示例

```java
public class MyException extends Exception {
	public MyException(String message) {
		super(message);
	}
}

try {
	int a = -1;
	if (a < 0) throw new MyException("a 不能小于 0");
	int[] array = new int[a];
} catch (MyException e) {
	System.out.println(e.getMessage());
} finally {
	System.out.println("异常捕获结束");
}
```

==== 命名与设计建议

1. 异常类名统一以 `Exception` 结尾
2. 需强制调用方处理时继承 `Exception`
3. 业务运行时错误可继承 `RuntimeException`
4. 保留异常链，优先使用带 cause 的构造方法


== 最佳实践与反模式

=== 推荐实践

1. 只捕获你能处理的异常
2. 不要吞异常；至少记录日志
3. 保留异常链，不要丢失原始堆栈
4. 优先用具体异常类型，而不是泛化到 `Exception`
5. 资源释放优先使用 try-with-resources

==== InterruptedException 处理规范

对于 `InterruptedException`，常见正确姿势是“恢复中断标记”或“继续向上抛出”：

```java
try {
	Thread.sleep(1000);
} catch (InterruptedException e) {
	Thread.currentThread().interrupt(); // 恢复中断标记
	throw new RuntimeException("线程被中断", e);
}
```

#warning[
  不要简单吞掉 `InterruptedException`。这会破坏线程协作协议，导致线程池任务无法按预期停止。
]

==== 异常日志建议

记录异常时应包含：

1. 业务上下文（请求 ID、用户 ID、关键参数）
2. 异常类型 + 异常消息 + 完整堆栈
3. 关键分支状态（重试次数、远端响应码）

并避免：

- 只打印 `e.getMessage()` 不打印堆栈
- 重复多层打印同一异常造成日志噪声
- 将密码、令牌等敏感信息写入日志

==== 分层异常转换（Service / Controller）

推荐在分层架构中做“边界转换”：

1. DAO 层抛技术异常（SQL/IO）
2. Service 层转换为业务异常并补充语义
3. Controller 层统一映射为错误码与对外响应

```java
try {
	userRepository.save(user);
} catch (SQLException e) {
	throw new UserOperationException("用户保存失败", e);
}
```

#tip[
  统一异常映射（例如 Web 全局异常处理器）能显著提升接口一致性，减少散落在控制器中的重复 `try-catch`。
]

=== 反模式示例

```java
// 反模式：吞异常
try {
	doSomething();
} catch (Exception e) {
	// nothing
}

// 反模式：抛新异常但丢失原始堆栈
try {
	doSomething();
} catch (IOException e) {
	throw new RuntimeException(e.getMessage());
}

// 正确：保留 cause
try {
	doSomething();
} catch (IOException e) {
	throw new RuntimeException("处理失败", e);
}
```


== 面试与实战高频

=== Checked vs Unchecked

#tex-table(
  ("维度", "Checked Exception", "Unchecked Exception"),
  ("编译器检查", "强制检查", "不强制检查"),
  ("处理要求", "必须捕获或声明", "可自行选择"),
  ("典型类型", "IOException、SQLException", "NullPointerException、IllegalArgumentException"),
  ("设计意图", "可恢复、可预期问题", "编程错误或非法状态"),
)

=== 高频问答

==== try 里 return，finally 会执行吗

会执行。finally 在方法真正返回前执行。

==== try/catch/finally 都有 return，最终返回哪个

finally 中的 return 会覆盖前面的返回值。

==== finally 中修改变量为何有时生效有时不生效

- 基本类型：return 时值已拷贝，finally 修改通常不影响返回
- 引用类型：return 的是引用，finally 修改对象内容通常可见

#tip[
  生产代码里尽量避免在 finally 中修改返回路径。可读性差、风险高、容易引入隐蔽 bug。
]


= 日期时间 API

Java 8 引入了全新的 `java.time` 包，解决了旧版 Date/Calendar 的诸多问题。Kotlin 在此基础上提供了更简洁的扩展函数。

== 旧版 Date/Calendar 缺陷与基础用法

=== java.util.Date 的问题

```java
import java.util.Date;

// 创建日期
Date date = new Date();  // 当前时间
Date specificDate = new Date(123, 5, 15);  // 2023年6月15日（月份从0开始！）

// 获取时间戳
long timestamp = date.getTime();

// 格式化
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String formatted = sdf.format(date);

// 解析
Date parsed = sdf.parse("2023-06-15 10:30:00");
```

*主要缺陷*：

#tex-table(
  ("问题", "说明"),
  ("可变性", "Date 是可变对象，线程不安全"),
  ("月份从0开始", "0表示1月，容易混淆"),
  ("年份从1900开始", "需要手动加减1900"),
  ("时区处理差", "需要配合 TimeZone 使用"),
  ("命名混乱", "java.sql.Date 继承 java.util.Date，但行为不同"),
  ("格式化线程不安全", "SimpleDateFormat 不是线程安全的"),
)

#caution[
  旧版 Date API 存在严重设计缺陷，Java 8+ 应使用 java.time 包。
]

=== Calendar 的使用

```java
import java.util.Calendar;
import java.util.GregorianCalendar;

// 创建 Calendar
Calendar calendar = Calendar.getInstance();
calendar.set(2023, Calendar.JUNE, 15, 10, 30, 0);

// 获取字段
int year = calendar.get(Calendar.YEAR);
int month = calendar.get(Calendar.MONTH);  // 仍然是 0-11
int day = calendar.get(Calendar.DAY_OF_MONTH);

// 日期计算
calendar.add(Calendar.DAY_OF_MONTH, 7);  // 加7天
calendar.add(Calendar.MONTH, -1);        // 减1个月

// 转换为 Date
Date date = calendar.getTime();
```

*Calendar 的问题*：

- API 复杂，不够直观
- 月份仍然从0开始
- 可变对象，线程不安全
- 性能较差

== Java java.time 包

Java 8 引入的 `java.time` 包基于 ISO-8601 标准，由 Joda-Time 作者设计。

=== 核心类

==== LocalDate（日期）

```java
import java.time.LocalDate;
import java.time.Month;

// 创建
LocalDate today = LocalDate.now();
LocalDate date = LocalDate.of(2023, 6, 15);
LocalDate date2 = LocalDate.of(2023, Month.JUNE, 15);
LocalDate parsed = LocalDate.parse("2023-06-15");

// 获取字段
int year = date.getYear();           // 2023
Month month = date.getMonth();       // JUNE
int day = date.getDayOfMonth();      // 15
DayOfWeek dow = date.getDayOfWeek(); // FRIDAY

// 日期计算
LocalDate tomorrow = today.plusDays(1);
LocalDate nextWeek = today.plusWeeks(1);
LocalDate nextMonth = today.plusMonths(1);
LocalDate lastYear = today.minusYears(1);

// 比较
boolean isBefore = date.isBefore(today);
boolean isAfter = date.isAfter(today);
boolean isEqual = date.isEqual(LocalDate.of(2023, 6, 15));
```

==== LocalTime（时间）

```java
import java.time.LocalTime;

// 创建
LocalTime now = LocalTime.now();
LocalTime time = LocalTime.of(14, 30, 0);  // 14:30:00
LocalTime parsed = LocalTime.parse("14:30:00");

// 获取字段
int hour = time.getHour();     // 14
int minute = time.getMinute(); // 30
int second = time.getSecond(); // 0

// 时间计算
LocalTime later = time.plusHours(2);
LocalTime earlier = time.minusMinutes(30);
```

==== LocalDateTime（日期时间）

```java
import java.time.LocalDateTime;

// 创建
LocalDateTime now = LocalDateTime.now();
LocalDateTime dt = LocalDateTime.of(2023, 6, 15, 14, 30, 0);
LocalDateTime fromParts = LocalDateTime.of(
    LocalDate.of(2023, 6, 15),
    LocalTime.of(14, 30)
);

// 转换
LocalDate date = dt.toLocalDate();
LocalTime time = dt.toLocalTime();

// 组合
LocalDateTime combined = date.atTime(14, 30);
```

==== Instant（时间戳）

```java
import java.time.Instant;

// 创建
Instant now = Instant.now();
Instant fromEpoch = Instant.ofEpochSecond(1234567890);
Instant fromMillis = Instant.ofEpochMilli(1234567890000L);

// 获取时间戳
long epochSecond = now.getEpochSecond();
long epochMilli = now.toEpochMilli();

// 计算
Instant later = now.plusSeconds(60);
Duration duration = Duration.between(now, later);
```

#tip[
  Instant 用于机器时间（UTC），LocalDateTime 用于人类时间（无时区）。
]

=== 格式化与解析

==== DateTimeFormatter

```java
import java.time.format.DateTimeFormatter;
import java.time.format.FormatStyle;

// 预定义格式
DateTimeFormatter isoDate = DateTimeFormatter.ISO_LOCAL_DATE;
DateTimeFormatter isoDateTime = DateTimeFormatter.ISO_LOCAL_DATE_TIME;

// 自定义格式
DateTimeFormatter custom = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
DateTimeFormatter chinese = DateTimeFormatter.ofPattern("yyyy年MM月dd日");

// 本地化格式
DateTimeFormatter localized = DateTimeFormatter.ofLocalizedDateTime(
    FormatStyle.LONG
).withLocale(Locale.CHINA);

// 格式化
LocalDateTime dt = LocalDateTime.of(2023, 6, 15, 14, 30, 0);
String formatted = dt.format(custom);  // "2023-06-15 14:30:00"

// 解析
LocalDateTime parsed = LocalDateTime.parse("2023-06-15 14:30:00", custom);
```

*常用格式模式*：

#tex-table(
  ("模式", "含义", "示例"),
  ("yyyy", "四位年份", "2023"),
  ("MM", "两位月份", "06"),
  ("dd", "两位日期", "15"),
  ("HH", "24小时制", "14"),
  ("mm", "分钟", "30"),
  ("ss", "秒", "00"),
  ("EEE", "星期缩写", "Fri"),
  ("EEEE", "星期全称", "Friday"),
)

#note[
  DateTimeFormatter 是不可变且线程安全的，可以安全地在多线程环境中共享。
]

=== 时间计算

==== Period（日期间隔）

```java
import java.time.Period;

LocalDate start = LocalDate.of(2023, 1, 1);
LocalDate end = LocalDate.of(2023, 6, 15);

Period period = Period.between(start, end);
System.out.println(period.getYears());   // 0
System.out.println(period.getMonths());  // 5
System.out.println(period.getDays());    // 14

// 创建 Period
Period oneMonth = Period.ofMonths(1);
Period twoWeeks = Period.ofWeeks(2);

// 应用
LocalDate later = start.plus(oneMonth);
```

==== Duration（时间间隔）

```java
import java.time.Duration;

LocalTime start = LocalTime.of(9, 0);
LocalTime end = LocalTime.of(17, 30);

Duration duration = Duration.between(start, end);
System.out.println(duration.toHours());      // 8
System.out.println(duration.toMinutes());    // 510
System.out.println(duration.getSeconds());   // 30600

// 创建 Duration
Duration oneHour = Duration.ofHours(1);
Duration thirtyMinutes = Duration.ofMinutes(30);

// 应用
LocalTime later = start.plus(oneHour);
```

==== ChronoUnit

```java
import java.time.temporal.ChronoUnit;

LocalDate start = LocalDate.of(2023, 1, 1);
LocalDate end = LocalDate.of(2023, 6, 15);

long days = ChronoUnit.DAYS.between(start, end);      // 165
long weeks = ChronoUnit.WEEKS.between(start, end);    // 23
long months = ChronoUnit.MONTHS.between(start, end);  // 5
```

=== 时区处理

==== ZoneId（时区）

```java
import java.time.ZoneId;
import java.time.ZonedDateTime;

// 获取时区
ZoneId shanghai = ZoneId.of("Asia/Shanghai");
ZoneId utc = ZoneId.of("UTC");
ZoneId systemDefault = ZoneId.systemDefault();

// 所有可用时区
Set<String> zoneIds = ZoneId.getAvailableZoneIds();
```

==== ZonedDateTime（带时区的日期时间）

```java
import java.time.ZonedDateTime;

// 创建
ZonedDateTime now = ZonedDateTime.now();
ZonedDateTime shanghaiTime = ZonedDateTime.now(ZoneId.of("Asia/Shanghai"));
ZonedDateTime specific = ZonedDateTime.of(
    LocalDateTime.of(2023, 6, 15, 14, 30),
    ZoneId.of("Asia/Shanghai")
);

// 时区转换
ZonedDateTime nyTime = shanghaiTime.withZoneSameInstant(
    ZoneId.of("America/New_York")
);

// 获取偏移量
ZoneOffset offset = shanghaiTime.getOffset();  // +08:00
```

==== OffsetDateTime（带偏移量的日期时间）

```java
import java.time.OffsetDateTime;
import java.time.ZoneOffset;

// 创建
OffsetDateTime now = OffsetDateTime.now();
OffsetDateTime withOffset = OffsetDateTime.of(
    LocalDateTime.of(2023, 6, 15, 14, 30),
    ZoneOffset.of("+08:00")
);

// 转换
OffsetDateTime utc = withOffset.withOffsetSameInstant(ZoneOffset.UTC);
```

#tip[
  - 使用 `ZonedDateTime` 处理需要时区信息的场景
  - 使用 `OffsetDateTime` 处理只需要 UTC 偏移的场景
  - 使用 `LocalDateTime` 处理不需要时区的场景（如生日、会议时间）
]

==== Daylight Saving Time（夏令时）

```java
// 自动处理夏令时
ZonedDateTime beforeDST = ZonedDateTime.of(
    LocalDateTime.of(2023, 3, 12, 1, 30),
    ZoneId.of("America/New_York")
);

ZonedDateTime afterDST = beforeDST.plusHours(1);
// 自动跳过 2:00-3:00，结果为 3:30
```

== Kotlin 日期时间扩展函数与简化用法

Kotlin 通过扩展函数让 java.time API 更加简洁。

=== 创建日期时间

```kotlin
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.LocalTime

// 使用扩展函数
val today = LocalDate.now()
val date = LocalDate.of(2023, 6, 15)

// Kotlin 风格（需要导入扩展）
val date2 = 2023 to 6 to 15  // 假设有扩展函数
```

=== 日期计算简化

```kotlin
import java.time.Period
import java.time.Duration

val today = LocalDate.now()

// 链式调用
val tomorrow = today.plusDays(1)
val nextWeek = today.plusWeeks(1)
val nextMonth = today.plusMonths(1)

// 使用 Period
val period = Period.ofDays(7)
val later = today.plus(period)

// Duration
val now = LocalDateTime.now()
val oneHourLater = now.plusHours(1)
val duration = Duration.ofMinutes(30)
val later2 = now.plus(duration)
```

=== 格式化简化

```kotlin
import java.time.format.DateTimeFormatter

val dt = LocalDateTime.of(2023, 6, 15, 14, 30, 0)

// 自定义格式
val formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")
val formatted = dt.format(formatter)

// 解析
val parsed = LocalDateTime.parse("2023-06-15 14:30:00", formatter)

// Kotlin 扩展（假设）
val formatted2 = dt.toString("yyyy-MM-dd")  // 如果有扩展函数
```

=== 字符串插值

```kotlin
val date = LocalDate.of(2023, 6, 15)
val time = LocalTime.of(14, 30)

// 字符串模板
println("Date: $date, Time: $time")
// 输出：Date: 2023-06-15, Time: 14:30

// 自定义格式
val formatter = DateTimeFormatter.ofPattern("yyyy年MM月dd日")
println("Today is ${date.format(formatter)}")
```

=== 范围操作

```kotlin
val start = LocalDate.of(2023, 1, 1)
val end = LocalDate.of(2023, 1, 10)

// 遍历日期范围
var current = start
while (!current.isAfter(end)) {
    println(current)
    current = current.plusDays(1)
}

// 或使用 generateSequence
generateSequence(start) { it.plusDays(1) }
    .takeWhile { !it.isAfter(end) }
    .forEach { println(it) }
```

=== Kotlin 专属扩展库

推荐使用第三方库增强 Kotlin 日期时间体验：

==== kotlinx-datetime

```kotlin
import kotlinx.datetime.*

// 创建
val clock = Clock.System
val now = clock.now()  // Instant

val date = LocalDate(2023, 6, 15)
val time = LocalTime(14, 30, 0)
val dateTime = LocalDateTime(2023, 6, 15, 14, 30, 0)

// 计算
val tomorrow = date.plus(1, DateTimeUnit.DAY)
val nextWeek = date.plus(7, DateTimeUnit.DAY)

// 格式化
val formatter = DateTimeFormat {
    date(LocalDate.Formats.ISO)
}
println(dateTime.format(formatter))
```

#tip[
  kotlinx-datetime 是 JetBrains 官方的跨平台日期时间库，推荐在 Kotlin Multiplatform 项目中使用。
]

== 两者互操作兼容

=== Java 调用 Kotlin

```kotlin
// Kotlin 代码
object DateUtils {
    @JvmStatic
    fun formatNow(pattern: String): String {
        return LocalDateTime.now()
            .format(DateTimeFormatter.ofPattern(pattern))
    }

    @JvmStatic
    fun parseDate(dateStr: String): LocalDate {
        return LocalDate.parse(dateStr)
    }
}
```

```java
// Java 调用
String formatted = DateUtils.formatNow("yyyy-MM-dd");
LocalDate date = DateUtils.parseDate("2023-06-15");
```

=== Kotlin 调用 Java

```java
// Java 代码
public class JavaDateHelper {
    public static LocalDateTime getNow() {
        return LocalDateTime.now();
    }

    public static String format(LocalDateTime dt, String pattern) {
        return dt.format(DateTimeFormatter.ofPattern(pattern));
    }
}
```

```kotlin
// Kotlin 调用
val now = JavaDateHelper.getNow()
val formatted = JavaDateHelper.format(now, "yyyy-MM-dd")
```

=== 类型映射

#tex-table(
  ("Java 类型", "Kotlin 类型", "说明"),
  ("LocalDate", "LocalDate", "完全兼容"),
  ("LocalTime", "LocalTime", "完全兼容"),
  ("LocalDateTime", "LocalDateTime", "完全兼容"),
  ("ZonedDateTime", "ZonedDateTime", "完全兼容"),
  ("Instant", "Instant", "完全兼容"),
  ("Duration", "Duration", "完全兼容"),
  ("Period", "Period", "完全兼容"),
  ("DateTimeFormatter", "DateTimeFormatter", "完全兼容"),
)

#note[
  java.time 包的类在 Java 和 Kotlin 中完全兼容，无需特殊转换。
]

=== 最佳实践

1. *优先使用 java.time*：
  ```kotlin
  // ✅ 推荐
  val date = LocalDate.now()

  // ❌ 避免
  val date = Date()
  ```

2. *选择合适的类型*：
  - 只需日期：`LocalDate`
  - 只需时间：`LocalTime`
  - 日期+时间（无时区）：`LocalDateTime`
  - 需要时区：`ZonedDateTime`
  - 时间戳：`Instant`

3. *不可变性*：
  ```kotlin
  // java.time 类都是不可变的
  val date = LocalDate.of(2023, 6, 15)
  val newDate = date.plusDays(1)  // 返回新对象，原对象不变
  ```

4. *线程安全*：
  ```kotlin
  // DateTimeFormatter 是线程安全的，可以共享
  private val formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd")
  ```

5. *时区处理*：
  ```kotlin
  // 明确指定时区
  val now = ZonedDateTime.now(ZoneId.of("Asia/Shanghai"))

  // 避免使用默认时区
  val now2 = ZonedDateTime.now()  // 依赖系统时区
  ```

#fancy-divider

本章完

