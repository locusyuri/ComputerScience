#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= Java & Kotlin 入门与环境搭建

= 基础语法

本章介绍 Java 和 Kotlin 的基础语法，包括标识符、变量、数据类型、运算符和流程控制。通过对比两种语言，帮助你理解它们的设计哲学和最佳实践。

== 标识符、注释与编码规范

=== 标识符命名规则

*Java 标识符规则*：

- 由字母、数字、下划线 `_`、美元符号 `$` 组成
- 不能以数字开头
- 区分大小写
- 不能使用关键字（如 `class`、`public`）

*Kotlin 标识符规则*：

- 与 Java 基本相同
- 支持反引号包裹的关键字作为标识符：`` `class` ``
- 推荐使用驼峰命名法

*命名约定*：

#tex-table(
  ("类型", "Java", "Kotlin"),
  ("类/接口", "PascalCase", "PascalCase"),
  ("方法/函数", "camelCase", "camelCase"),
  ("变量", "camelCase", "camelCase"),
  ("常量", "UPPER_SNAKE_CASE", "val 用 camelCase"),
  ("包名", "全小写", "全小写"),
)

=== 注释

==== 单行注释

```java
// Java 单行注释
```

```kotlin
// Kotlin 单行注释
```

==== 多行注释

```java
/*
 * Java 多行注释
 * 可以跨越多行
 */
```

```kotlin
/*
 * Kotlin 多行注释
 * 同样支持嵌套：/* 嵌套 */
 */
```

==== 文档注释

```java
/**
 * Java 文档注释
 * @param name 参数说明
 * @return 返回值说明
 */
public String greet(String name) {
    return "Hello, " + name;
}
```

```kotlin
/**
 * Kotlin 文档注释
 * @param name 参数说明
 * @return 返回值说明
 */
fun greet(name: String): String {
    return "Hello, $name"
}
```

#tip[
  使用 Javadoc/KDoc 为公共 API 编写文档注释，IDE 会自动提取生成 API 文档。
]

=== 编码规范

*通用原则*：

- 使用 UTF-8 编码
- 缩进使用 4 个空格（不用 Tab）
- 每行不超过 120 字符
- 大括号风格：K&R 风格（左括号不换行）

*Java 规范*：

- 遵循 Oracle Code Conventions
- 使用 Checkstyle 或 SpotBugs 检查

*Kotlin 规范*：

- 遵循 Kotlin Coding Conventions
- 使用 ktlint 或 detekt 检查

== 变量与数据类型

=== Java 变量声明

```java
// 基本类型（值类型）
int age = 25;
double price = 99.99;
boolean isActive = true;
char grade = 'A';

// 引用类型
String name = "Alice";
Object obj = new Object();

// 常量
final int MAX_SIZE = 100;
```

=== Kotlin 变量声明

```kotlin
// 不可变变量（推荐）
val name: String = "Alice"
val age = 25  // 类型推断

// 可变变量
var count: Int = 0
var message = "Hello"  // 类型推断

// 延迟初始化
lateinit var config: Configuration

// 懒加载
val dbConnection by lazy { connectToDatabase() }
```

#note[
  Kotlin 推荐使用 `val` 而非 `var`，优先使用不可变变量，提高代码安全性。
]

=== 基本数据类型

==== Java 基本类型

#tex-table(
  ("类型", "大小", "范围", "默认值"),
  ("byte", "8位", "-128 ~ 127", "0"),
  ("short", "16位", "-32768 ~ 32767", "0"),
  ("int", "32位", "-2^31 ~ 2^31-1", "0"),
  ("long", "64位", "-2^63 ~ 2^63-1", "0L"),
  ("float", "32位", "IEEE 754", "0.0f"),
  ("double", "64位", "IEEE 754", "0.0d"),
  ("boolean", "1位", "true/false", "false"),
  ("char", "16位", "Unicode", "'\\u0000'"),
)

==== Kotlin 基本类型

Kotlin 没有基本类型和包装类型的区分，统一为对象：

```kotlin
val i: Int = 42
val l: Long = 42L
val d: Double = 3.14
val f: Float = 3.14f
val b: Boolean = true
val c: Char = 'A'
val s: Short = 100
val by: Byte = 10
```

#tip[
  Kotlin 编译器会在 JVM 字节码层面优化为基本类型，性能与 Java 相同。
]

=== 类型推断

*Java 10+*：

```java
var name = "Alice";  // 推断为 String
var list = new ArrayList<String>();  // 推断为 ArrayList<String>
var map = Map.of("key", "value");  // 推断为 Map<String, String>
```

*Kotlin*：

```kotlin
val name = "Alice"  // 推断为 String
val list = mutableListOf<String>()  // 推断为 MutableList<String>
val map = mapOf("key" to "value")  // 推断为 Map<String, String>
```

#caution[
  类型推断虽然方便，但在复杂表达式中应显式声明类型，提高可读性。
]

=== 类型转换

==== Java 类型转换

```java
// 自动转换（隐式）
int i = 100;
long l = i;  // int → long

// 强制转换（显式）
double d = 3.14;
int i2 = (int) d;  // double → int，丢失精度

// 包装类型转换
Integer integer = 100;
int primitive = integer.intValue();  // 拆箱
Integer boxed = Integer.valueOf(primitive);  // 装箱
```

==== Kotlin 类型转换

```kotlin
// 显式转换（无隐式转换）
val i: Int = 100
val l: Long = i.toLong()  // 必须显式转换

val d: Double = 3.14
val i2: Int = d.toInt()  // 可能丢失精度

// 安全转换
val str: String? = "123"
val num: Int? = str?.toIntOrNull()  // 转换失败返回 null
```

#note[
  Kotlin 禁止隐式数值转换，避免意外的精度丢失，提高代码安全性。
]

== 空安全体系

空安全是 Kotlin 的核心特性之一，在编译期防止空指针异常。

=== Java 的空值处理

```java
// Java 中任何引用类型都可能为 null
String name = getName();  // 可能返回 null

// 需要手动检查
if (name != null) {
    System.out.println(name.length());
} else {
    System.out.println(0);
}

// 或使用 Optional（Java 8+）
Optional<String> optName = Optional.ofNullable(getName());
int length = optName.map(String::length).orElse(0);
```

#caution[
  Java 的 NullPointerException 是最常见的运行时异常，需要在运行时才能发现。
]

=== Kotlin 的可空类型

```kotlin
// 非空类型（默认）
val name: String = "Alice"  // 不能为 null

// 可空类型（加 ?）
val nullableName: String? = null  // 可以为 null

// 编译期检查
nullableName.length  // ❌ 编译错误：可能为 null
nullableName?.length  // ✅ 安全调用，返回 Int?
```

=== 空安全操作符

==== 安全调用符 `?.`

```kotlin
val length = name?.length  // 如果 name 为 null，返回 null

// 链式调用
val city = user?.address?.city  // 任一环节为 null，结果为 null
```

==== Elvis 运算符 `?:`

```kotlin
// 提供默认值
val length = name?.length ?: 0  // 如果为 null，使用 0

// 抛出异常
val value = config ?: throw IllegalStateException("Config is null")

// 返回
fun getName(): String {
    return cachedName ?: loadFromDatabase() ?: "Unknown"
}
```

==== 非空断言 `!!`

```kotlin
val length = name!!.length  // 强制认为不为 null

// ⚠️ 如果 name 为 null，抛出 NullPointerException
```

#caution[
  尽量避免使用 `!!`，它破坏了空安全性。优先使用 `?.` 和 `?:`。
]

==== 安全转换 `as?`

```kotlin
val obj: Any = "Hello"
val str: String? = obj as? String  // 转换失败返回 null，而非异常
```

=== Let 作用域函数

```kotlin
// 仅在非空时执行
name?.let {
    println(it.length)  // it 是非空的 name
    println(it.uppercase())
}

// 等价于
if (name != null) {
    println(name.length)
    println(name.uppercase())
}
```

#tip[
  Kotlin 的空安全机制将 NPE 从运行时错误转变为编译时错误，大幅减少 bug。
]

== 运算符与表达式

=== 算术运算符

```java
// Java
int sum = a + b;
int diff = a - b;
int product = a * b;
int quotient = a / b;
int remainder = a % b;
```

```kotlin
// Kotlin（相同）
val sum = a + b
val diff = a - b
val product = a * b
val quotient = a / b
val remainder = a % b
```

=== 比较运算符

*Java*：

```java
boolean eq = (a == b);      // 基本类型比较值，引用类型比较地址
boolean ne = (a != b);
boolean gt = (a > b);
boolean lt = (a < b);
boolean ge = (a >= b);
boolean le = (a <= b);

// 对象比较
boolean same = str1.equals(str2);  // 内容比较
```

*Kotlin*：

```kotlin
val eq = (a == b)   // 调用 equals()
val ne = (a != b)   // 调用 !equals()
val gt = (a > b)
val lt = (a < b)
val ge = (a >= b)
val le = (a <= b)

// 引用比较
val sameRef = (a === b)   // 引用相等
val diffRef = (a !== b)   // 引用不等
```

#note[
  Kotlin 的 `==` 调用 `equals()`，`===` 比较引用，语义更清晰。
]

=== 逻辑运算符

```java
// Java
boolean and = (a && b);   // 短路与
boolean or = (a || b);    // 短路或
boolean not = !a;         // 非
```

```kotlin
// Kotlin（相同）
val and = (a && b)
val or = (a || b)
val not = !a
```

=== 赋值运算符

```java
// Java
a += b;   // a = a + b
a -= b;
a *= b;
a /= b;
a %= b;
```

```kotlin
// Kotlin（相同）
a += b
a -= b
a *= b
a /= b
a %= b
```

=== 其他运算符

==== 三元运算符

*Java*：

```java
String result = (score >= 60) ? "Pass" : "Fail";
```

*Kotlin*：

```kotlin
// if 表达式（替代三元运算符）
val result = if (score >= 60) "Pass" else "Fail"
```

#tip[
  Kotlin 的 `if` 是表达式而非语句，可以返回值，更加灵活。
]

==== instanceof / is

*Java*：

```java
if (obj instanceof String) {
    String str = (String) obj;  // 需要手动转换
    System.out.println(str.length());
}

// Java 14+ 模式匹配
if (obj instanceof String str) {
    System.out.println(str.length());  // 自动转换
}
```

*Kotlin*：

```kotlin
if (obj is String) {
    println(obj.length)  // 智能转换，无需手动 cast
}

// when 表达式
when (obj) {
    is String -> println(obj.length)
    is Int -> println(obj.toDouble())
    else -> println("Unknown")
}
```

== 流程控制

=== 条件分支

==== if-else

*Java*：

```java
if (score >= 90) {
    grade = "A";
} else if (score >= 80) {
    grade = "B";
} else if (score >= 70) {
    grade = "C";
} else {
    grade = "F";
}
```

*Kotlin*：

```kotlin
// if 表达式
val grade = if (score >= 90) {
    "A"
} else if (score >= 80) {
    "B"
} else if (score >= 70) {
    "C"
} else {
    "F"
}
```

==== when 表达式（Kotlin 特色）

```kotlin
val grade = when (score) {
    in 90..100 -> "A"
    in 80..89 -> "B"
    in 70..79 -> "C"
    in 60..69 -> "D"
    else -> "F"
}

// 无参数的 when
when {
    score >= 90 -> "A"
    score >= 80 -> "B"
    score >= 70 -> "C"
    else -> "F"
}

// 多值匹配
when (day) {
    1, 2, 3, 4, 5 -> "Weekday"
    6, 7 -> "Weekend"
    else -> "Invalid"
}
```

#tip[
  Kotlin 的 `when` 比 Java 的 `switch` 更强大，支持范围、类型、条件等多种匹配方式。
]

=== 循环结构

==== for 循环

*Java*：

```java
// 传统 for
for (int i = 0; i < 10; i++) {
    System.out.println(i);
}

// 增强 for
for (String item : items) {
    System.out.println(item);
}

// 带索引
for (int i = 0; i < items.length; i++) {
    System.out.println(i + ": " + items[i]);
}
```

*Kotlin*：

```kotlin
// 范围迭代
for (i in 0..9) {
    println(i)
}

// 步进
for (i in 0 until 10 step 2) {
    println(i)  // 0, 2, 4, 6, 8
}

// 倒序
for (i in 10 downTo 1) {
    println(i)
}

// 遍历集合
for (item in items) {
    println(item)
}

// 带索引
for ((index, item) in items.withIndex()) {
    println("$index: $item")
}
```

==== while 循环

*Java 和 Kotlin 相同*：

```java
while (condition) {
    // 循环体
}

do {
    // 循环体
} while (condition);
```

==== 跳转表达式

*Java*：

```java
break;       // 跳出循环
continue;    // 跳过本次迭代
return;      // 返回
```

*Kotlin*：

```kotlin
break        // 跳出循环
continue     // 跳过本次迭代
return       // 返回

// 标签跳转
outer@ for (i in 1..10) {
    for (j in 1..10) {
        if (condition) break@outer  // 跳出外层循环
    }
}
```

#fancy-divider

本章完


= 数组与基础数据结构

= 函数（方法）与代码复用

= 面向对象编程（OOP）核心
