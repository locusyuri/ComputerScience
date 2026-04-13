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

