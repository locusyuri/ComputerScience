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

=== 变量声明与可变性

==== 变量声明

在 Java 语言中，所有的变量在使用前必须声明。声明变量的基本格式如下：
```java
type identifier [ = value][, identifier [= value] ...] ;

/*
 * 具体示例如下
 */

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

而在 Kotlin 中，变量的声明格式如下：

```kotlin
val/var identifier [ = value][, identifier [= value] ...] ;

/*
 * 具体示例如下
 */

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
  `val` 用于声明不可变变量，`var` 用于声明可变变量。
  Kotlin 推荐使用 `var`，优先使用不可变变量，提高代码安全性。
]

==== 变量的可变性
可变性可以分为两个层次：
- 变量本身的可变性：变量是否可以被重新赋值（指向不同的对象或值）。
- 对象内容的可变性：变量所引用的对象内部状态是否可以被修改。

Java 使用 `final` 关键字修饰变量，表示变量引用不可变（即不可重新赋值），但对象内容是否可变取决于对象本身的实现。

```java
final int a = 10;
// a = 20;  // 编译错误：不能重新赋值

final List<String> list = new ArrayList<>();
list.add("item");        // 允许！对象内容可改
// list = new ArrayList<>(); // 编译错误：不能重新指向新对象
```
对于基本类型，final 等同于值不可变。对于引用类型，final 只保证引用不变，不保证对象不变。

要创建不可变的对象，需要类自己设计：所有字段 final、不提供修改方法、防御性拷贝等，例如 String、Integer 等包装类、LocalDate。

在 Kotlin 中，可变性有明确的区分：
- val：只读引用（不可重新赋值），相当于 Java 的 final。
- var：可变引用（可重新赋值）。

```kotlin
val a = 10
// a = 20  // 编译错误

var b = 10
b = 20     // 允许

val list = mutableListOf(1,2,3)
list.add(4)  // 允许：对象内容可改
// list = anotherList // 不允许
```

Kotlin 还提供了不可变集合接口（`List<T>`、`Set<T>`、`Map<K,V>`），它们只提供只读操作，没有修改方法。但注意这些接口通常指向可变集合的只读视图，底层仍可能被修改：

```kotlin
val readOnlyList: List<Int> = listOf(1,2,3)
// readOnlyList.add(4) // 编译错误
```
要创建真正不可变的数据类，可以用 `data class` 配合 `val` 属性，并确保属性类型本身也是不可变的。

==== 常量
常量通常有两种区分：
#tex-table(
  ([类型], [特点], [分配位置], [内联行为]),
  ([编译期常量], [值在编译时就完全确定，直接嵌入引用处], [无独立存储（或被内联）], [会被内联到使用处]),
  ([运行时常量], [值在运行时才能确定（如 `new Date()`），但一旦赋值不可变], [有独立内存], [不内联，通过字段访问]),
)

#tip[
  编译期常量会被内联。如果你修改了一个编译期常量的值，但依赖它的模块没有重新编译，它们还会使用旧的常量值（导致不一致）。运行时常量则不会内联，总是读取当前值。
]

Java 用 `static final` 修饰符来表示常量（通常还加上 `public`）。

- *编译期常量*：当修饰的变量为基本类型或 String 时，编译器会将这些常量的值内联到所有引用的地方。例如 `if (x > Constants.MAX_SIZE)` 会直接变成 `if (x > 100)`。注意：如果修改 `Constants.MAX_SIZE` 但未重新编译所有依赖类，会出现不一致问题。
```java
public class Constants {
    public static final int MAX_SIZE = 100;          // 编译期常量
    public static final String APP_NAME = "MyApp";   // 编译期常量
    public static final double PI = 3.1415926;       // 编译期常量
}
```
- *运行时常量*：当修饰的变量为引用类型时，值在运行时确定，但仍不可修改（`final` 保证引用不变，但对象内容可能变，不过通常我们要求对象本身也是不可变的才是真正常量）。它不会被内联，通过字段访问（`Constants.CREATED_DATE`）。
```java
public static final LocalDate CREATED_DATE = LocalDate.now();   // 运行时常量
public static final Random RANDOM = new Random();               // 引用类型常量
```

#note[
  静态导入：
  ```java
  import static Constants.MAX_SIZE;
  // 直接使用 MAX_SIZE，不需要 Constants. 前缀
  ```
]

#v(0.5em)
Kotlin 有更丰富的常量定义方式，包括 val（只读属性）、const val（编译期常量）以及顶层属性。

===== val —— 只读属性（运行时常量）

```
val maxSize = 100               // 运行时才确定（实际也是静态内联？不，这是属性）
val appName = "MyApp"          // String，但仍是运行时常量
val createdAt = LocalDate.now()
```
- `val` 表示只读，相当于 Java 中带 `getter` 的 `final` 字段（背后是私有字段 + `getter` 方法）。
- 不是编译期常量。即使赋值为字面量，访问 `maxSize` 仍然通过 `getter` 调用，不会内联。
- 在字节码中，顶层 `val` 对应 `private static final` 字段 + `public static final` `getter` 方法。

验证内联：
```kotlin
// 文件 Constants.kt
val MAX = 100

// 使用处
if (x > MAX) { ... }
```
反编译 Java 看到：`if (x > ConstantsKt.getMAX()) { ... }`，不是直接比较 100。

===== const val —— 真正的编译期常量
```kotlin
const val MAX_SIZE = 100
const val APP_NAME = "MyApp"
```
约束：
- 必须位于顶层或 object 内部，或伴生对象（`companion object`）内部。
- 只能修饰基本类型或 `String`。
- 初始值必须是编译期已知的常量表达式（字面量、其他 `const val` 运算等）。

效果：
- 等同于 Java 的 `public static final`。
- 使用时会被内联（值直接嵌入字节码）。
- 在字节码中生成一个真正的静态字段（无 `getter` 方法）。

```
// 声明
const val PI = 3.14159

// 使用
val area = radius * radius * PI
```
反编译 Java 后：`double area = radius * radius * 3.14159;` 没有字段访问。

===== 伴生对象（companion object）中的常量
```kotlin
class MyClass {
    companion object {
        const val CONSTANT = 123          // 相当于 Java 的静态常量
        val NON_CONST = 456               // 仍然通过 getter 访问
    }
}
```
- `const val` 在伴生对象中会被编译为 `public static final` 字段，可以直接通过 `MyClass.CONSTANT` 访问（Java 中也能访问）。
- `val` 在伴生对象中生成静态 getter，通过 `MyClass.Companion.getNON_CONST()` 访问（Java 中需写 `MyClass.Companion.getNON_CONST()`，除非加上 `@JvmStatic`）。

===== `@JvmField` 和 `@JvmStatic` 注解
`@JvmField` 注解用于在伴生对象中声明 `const val`，确保在字节码中生成 `public static final` 字段。

`@JvmStatic` 注解用于在伴生对象中声明 `val`，确保在字节码中生成 `public static final` `getter` 方法。

=== 两种数据类型
在编程语言中，变量往往可以分为值类型（基本类型）和引用类型。
+ *值类型*：变量直接包含数据。赋值时复制数据。修改一个变量不会影响另一个。例如 C\# 的   `struct`、Java 的 `int`、Python 的 `int`（不可变对象，表现似值）。
+ *引用类型*：变量包含指向数据的地址。赋值时复制引用（地址），而不是复制对象本身。多个变量可以指向同一个对象，通过一个变量修改对象内容，另一个变量也能看到变化。


程序运行时，内存可以粗分为两个区域：
+ *栈（Stack）*：存储变量本身。对于基本类型（数值、布尔等），变量直接存储值；对于引用类型，变量存储内存地址（指向堆中的对象）。
+ *堆（Heap）*：存储对象实例。引用类型的实际数据放在堆中，栈上的变量只是保存一个地址（“引用”）。

#note[
  栈是一块连续的内存区域，由 CPU 的栈指针（SP） 直接管理。
  - 分配和释放：只需移动栈指针（如 sub rsp, 32 分配，add rsp, 32 释放），一条指令即可完成，比堆快几个数量级。
  - 访问速度：栈内存的访问通常比堆更缓存友好。因为栈空间是连续的，且遵循 LIFO（后进先出），CPU 预取命中率高。另外栈地址往往在 L1/L2 缓存中热度更高。
  - 生命周期：变量作用域结束自动释放（编译器插入指令），无需垃圾回收或手动 free。
  - 限制：大小固定（通常 1~8 MB），超出导致栈溢出（stack overflow）。

  堆是一块由内存分配器（malloc/new 底层）管理的松散内存区域，地址不连续（可连续分配，但释放后会产生碎片）。
  - 分配：需要搜索空闲链表、分割、合并等操作，涉及系统调用（如 brk 或 mmap），开销大。
  - 释放：需要显式 free/delete 或由 GC 代为回收，GC 还会引入 STW 暂停。
  - 访问速度：堆对象可能散布在不同内存页，增加 CPU 缓存 miss 概率。
  - 优势：空间大（可达物理内存上限），对象生命周期可超越函数作用域。
]



Java 中值类型（基本类型）有以下八种：`byte`、`short`、`int`、`long`、`float`、`double`、`boolean`、`char`。

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


引用类型有：`String`、`Object`、`Map`、`List`、`Set`、`Enum`、`Class`、`Interface`。引用类型的默认值为 `null`。

=== 基本类型详解
==== 数字
==== 布尔
==== 字符
==== 基本类型的包装类
===== Java 包装类
Java 的基本类型（`int`, `double`, `boolean` 等）不是对象，无法直接参与泛型、不能放在集合中（如 `ArrayList<int>` 非法），也不能调用方法。包装类将这些基本类型“包装”成对象，使它们融入面向对象体系。

将基本类型转换为包装类称为装箱（Boxing），或从包装类转换为基本类型，称为拆箱（Unboxing）。频繁装箱/拆箱会创建大量临时对象，增加 GC 压力，在热点代码路径中应避免。

从 Java 5 开始，编译器自动在基本类型和包装类之间转换。
```java
Integer i = 42;          // 自动装箱：int → Integer
int j = i;               // 自动拆箱：Integer → int
```
底层实现：编译后实际调用 `Integer.valueOf(42)` 和 `i.intValue()`。

#tex-table(
  ([基本类型], [包装类], [装箱], [拆箱]),
  ("byte", "Byte", [`Byte.valueOf((byte) 10)`], [`byte b = byteValue.intValue()`]),
  ("short", "Short", [`Short.valueOf((short) 10)`], [`short s = shortValue.intValue()`]),
  ("int", "Integer", [`Integer.valueOf(10)`], [`int i = intValueValue.intValue()`]),
  ("long", "Long", [`Long.valueOf(10)`], [`long l = longValue.longValue()`]),
  ("float", "Float", [`Float.valueOf(10.0f)`], [`float f = floatValueValue.floatValue()`]),
  ("double", "Double", [`Double.valueOf(10.0)`], [`double d = doubleValue.doubleValue()`]),
  ("boolean", "Boolean", [`Boolean.valueOf(true)`], [`boolean b = booleanValue.booleanValue()`]),
  ("char", "Character", [`Character.valueOf('a')`], [`char c = characterValue.charValue()`]),
)


Java 对部分包装类提供了缓存，复用常用对象。

#tex-table(
  ([包装类], [缓存范围], [说明]),
  [`Inte`],
)

#caution[
  `==` 比较两个包装类对象时，比较的是引用（除非一个基本类型另一个包装类，则拆箱后比较值），应该用 `equals()`。
  ```
  Integer a = 100;
  Integer b = 100;
  System.out.println(a == b);   // true（因为缓存）
  Integer c = 200;
  Integer d = 200;
  System.out.println(c == d);   // false（超出缓存范围）
  ```
]


===== Kotlin 包装类




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

=== 深拷贝与浅拷贝
- *浅拷贝 (Shallow Copy)*：只复制对象本身，如果对象内部有字段引用其他对象，则只复制引用（地址），不复制引用的对象。结果：原对象和副本共享内部的子对象。
- *深拷贝 (Deep Copy)*：复制对象本身，并递归复制对象内部所有引用的对象，形成完全独立的副本。

Java 中所有类都继承 `Object.clone()`，默认是浅拷贝。要实现深拷贝需自行处理。
```java
class Address {
    String city;
    Address(String city) { this.city = city; }
}

class Person implements Cloneable {
    String name;
    Address addr;

    // 浅拷贝：默认实现
    @Override
    protected Object clone() throws CloneNotSupportedException {
        return super.clone();  // 只复制 addr 引用
    }

    // 深拷贝：手动复制 addr
    public Person deepCopy() {
        Person p = new Person();
        p.name = this.name;
        p.addr = new Address(this.addr.city);  // 新建 Address
        return p;
    }
}

// 使用
Person p1 = new Person();
p1.addr = new Address("北京");
Person p2 = (Person) p1.clone();   // 浅拷贝
p2.addr.city = "上海";
System.out.println(p1.addr.city);  // 输出 "上海" —— 被影响了
```


== 空安全体系

空安全是 Kotlin 的核心特性之一，在编译期防止空指针异常。


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


```kotlin
// 非空类型（默认）
val name: String = "Alice"  // 不能为 null

// 可空类型（加 ?）
val nullableName: String? = null  // 可以为 null

// 编译期检查
nullableName.length  // ❌ 编译错误：可能为 null
nullableName?.length  // ✅ 安全调用，返回 Int?
```

Kotlin 提供了多个空安全操作符，用于安全地处理可能为 null 的引用类型。

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

#todo[
  数组与基础数据结构章节待补充。
]

#fancy-divider

= 函数（方法）与代码复用

函数（或方法）是代码复用的基本单元。本章详细讲解 Java 方法的定义、调用、参数传递机制、重载、递归和可变参数，并对比 Kotlin 函数的特性与优势。

== Java 方法

=== 方法定义与调用
Java方法是语句的集合，它们在一起执行一个功能。

- 方法是解决一类问题的步骤的有序组合
- 方法可以包含于类或对象中
- 方法在程序中被创建，在其他地方被引用

*基本语法*：

```java
[访问修饰符] [static] [final] 返回值类型 方法名(参数列表) {
    // 方法体
    return 返回值;  // 如果返回值类型不是 void
}
```

#tip[
  方法名应符合驼峰命名法（camelCase），例如 `add`、`multiply`、`printResult` 等。
]

*示例*：

```java
public class MathUtils {
    // 静态方法
    public static int add(int a, int b) {
        return a + b;
    }

    // 实例方法
    public int multiply(int a, int b) {
        return a * b;
    }
}

// 调用方式
int sum = MathUtils.add(3, 5);         // 静态方法调用
MathUtils utils = new MathUtils();
int product = utils.multiply(3, 5);    // 实例方法调用
utils.printResult(product);
```


使用提前 `return` 可以减少代码嵌套层级，提高可读性（称为"卫语句"Guard Clause 模式）。

*使用场景*：
1. 参数校验失败时提前返回，避免嵌套过深
2. 条件分支中某些路径无需后续处理
3. 构造器中提前结束对象初始化（构造器没有返回值，只能用 `return;`）

```java
    // void 方法（无返回值）
    public void printResult(int result) {
        if (result < 0) {
            System.out.println("非法输入");
            return;  // 提前结束方法，不带返回值
        }
        System.out.println("结果: " + result);
    }

    // 参数校验：无效时提前返回
    public void processData(int[] data) {
        if (data == null || data.length == 0) {
            System.out.println("数据为空，无需处理");
            return;  // 提前结束方法
        }
        // 正常处理逻辑
        for (int i = 0; i < data.length; i++) {
            data[i] *= 2;
        }
        System.out.println("处理完成，共 " + data.length + " 条数据");
    }
```


=== 参数传递：值传递

Java 严格采用值传递（pass-by-value）。理解这一点对掌握 Java 方法调用机制至关重要：

```java
public class PassByValue {
    // 基本数据类型：传递的是值的副本
    public static void modifyPrimitive(int value) {
        value = 100;  // 修改不影响原始值
    }

    // 对象类型：传递的是对象引用的副本
    public static void modifyReference(List<String> list) {
        list.add("new item");  // 可以修改对象内部状态
        list = new ArrayList<>();  // 但不影响外部引用
    }

    public static void main(String[] args) {
        // 示例 1：基本数据类型
        int num = 10;
        modifyPrimitive(num);
        System.out.println(num);  // 输出 10（未改变）

        // 示例 2：对象引用
        List<String> items = new ArrayList<>();
        items.add("original");
        modifyReference(items);
        System.out.println(items);  // 输出 [original, new item]
    }
}
```

*关键点*：
1. 对于基本数据类型，传递的是值的*副本*，方法内修改不影响原变量
2. 对于对象引用，传递的是引用地址的*副本*，方法内可以修改对象内部状态
3. 重新赋值引用（如 `list = new ArrayList<>()`）只影响副本，不影响外部引用

不同于 Java，C++ 和 C\# 支持真正意义上的引用传递。在这些语言中，方法可以修改对象的内部状态，而不会影响外部引用。
```cpp
// C++ 引用传递
void changeRef(int*& p) {  // p 是实参指针的别名
    p = new int(100);
}

int main() {
    int* ptr = new int(10);
    changeRef(ptr);
    cout << *ptr;  // 输出 100 —— 实参 ptr 已被改变
}
```

```csharp
// C# 引用传递
void ChangeRef(ref List<int> list) {
    list = new List<int>();  // 实参 list 会被改为新对象
}

var myList = new List<int> { 1, 2, 3 };
ChangeRef(ref myList);
Console.WriteLine(myList.Count); // 输出 0，因为实参指向了新对象
```

#tip[
  几乎所有主流语言（除 C++ 真引用传递、C\# `ref`/`out`、Rust 借用外）采用 “传递引用的副本”。这意味着：形参和实参指向同一对象（共享对象），但形参本身是实参的副本，因此对形参重新赋值不会改变实参的指向。
]

=== 方法重载

方法重载（overload）允许在同一个类中定义多个同名方法，只要它们的参数列表不同：

```java
public class Calculator {
    // 重载：参数类型不同
    public int add(int a, int b) {
        return a + b;
    }

    public double add(double a, double b) {
        return a + b;
    }

    // 重载：参数个数不同
    public int add(int a, int b, int c) {
        return a + b + c;
    }

    // 重载：参数顺序不同
    public String concat(String a, int b) {
        return a + b;
    }

    public String concat(int a, String b) {
        return a + b;
    }

    // ⚠️ 返回值类型不同不能作为重载依据（编译错误）
    // public double add(int a, int b) { return a + b; } // ❌ 编译错误
}

// 编译器根据参数类型和数量选择合适的方法
Calculator calc = new Calculator();
calc.add(1, 2);          // 调用 add(int, int)
calc.add(1.0, 2.0);      // 调用 add(double, double)
calc.add(1, 2, 3);       // 调用 add(int, int, int)
```

*重载规则*：
1. 必须在同一个类中
2. 方法名必须相同
3. 参数列表必须不同（类型、数量、顺序）
4. 返回值类型可以相同也可以不同，但*不能仅靠返回值类型不同*构成重载
5. 访问修饰符可以不同




=== 递归

递归是函数直接或间接调用自身的技术，常用于解决分治问题：

```java
public class RecursionExamples {
    // 阶乘：n! = n × (n-1) × ... × 1
    public static int factorial(int n) {
        if (n <= 1) return 1;        // 基准情形
        return n * factorial(n - 1);  // 递归调用
    }

    // 斐波那契数列：F(n) = F(n-1) + F(n-2)
    public static int fibonacci(int n) {
        if (n <= 1) return n;
        return fibonacci(n - 1) + fibonacci(n - 2);
    }

    // 汉诺塔问题
    public static void hanoi(int n, char from, char to, char aux) {
        if (n == 1) {
            System.out.println("移动盘子 1 从 " + from + " 到 " + to);
            return;
        }
        hanoi(n - 1, from, aux, to);
        System.out.println("移动盘子 " + n + " 从 " + from + " 到 " + to);
        hanoi(n - 1, aux, to, from);
    }

    // 递归求数组最大值（分治思想）
    public static int findMax(int[] arr, int start, int end) {
        if (start == end) return arr[start];
        int mid = (start + end) / 2;
        int leftMax = findMax(arr, start, mid);
        int rightMax = findMax(arr, mid + 1, end);
        return Math.max(leftMax, rightMax);
    }
}
```

*递归三要素*：
1. 基准情形：递归何时结束，避免无限递归
2. 递归情形：如何将问题分解为更小的子问题
3. 向前推进：每次递归调用都应向基准情形靠近

=== 可变参数
JDK 1.5 开始，Java支持传递*同类型*的可变参数（varargs）给一个方法。

```java
public class VarargsExamples {
    // 基本语法：类型... 参数名
    public static int sum(int... numbers) {
        int total = 0;
        for (int num : numbers) {
            total += num;
        }
        return total;
    }

    // 可变参数必须是最后一个参数
    public static void printInfo(String message, int... values) {
        System.out.print(message + ": ");
        for (int v : values) {
            System.out.print(v + " ");
        }
        System.out.println();
    }

    // 可变参数的本质是数组
    public static void process(String... args) {
        // args 实际上是一个 String[] 数组
        for (int i = 0; i < args.length; i++) {
            System.out.println("args[" + i + "] = " + args[i]);
        }
    }

    // 注意事项：避免歧义
    // public static void ambiguous(String... strs) {}  // ✓
    // public static void ambiguous(String[] strs) {}   // ❌ 编译错误，与上面冲突

    public static void main(String[] args) {
        System.out.println(sum(1, 2, 3));         // 输出 6
        System.out.println(sum(1, 2, 3, 4, 5));   // 输出 15
        System.out.println(sum());                // 输出 0（空数组）

        printInfo("测试", 10, 20, 30);           // 测试: 10 20 30
        process("A", "B", "C");                  // 输出三个参数
    }
}
```

*可变参数特点*：
1. 语法：`类型... 参数名`
2. 必须是参数列表的最后一个参数
3. 在方法内部当作数组使用
4. 可以传递 0 个或多个参数
5. 不能与数组参数构成重载（两者在底层相同）

=== 变量作用域
变量的范围是程序中该变量可以被引用的部分。方法内定义的变量被称为局部变量。局部变量的作用范围从声明开始，直到包含它的块结束。局部变量必须声明才可以使用。

方法的参数范围涵盖整个方法。参数实际上是一个局部变量。for循环的初始化部分声明的变量，其作用范围在整个循环。但循环体内声明的变量其适用范围是从它声明到循环体结束。它包含如下所示的变量声明：

#figure(
  image("..\img\scope.jpg", width: 80%),
)

你可以在一个方法里，不同的非嵌套块中多次声明一个具有相同的名称局部变量，但你不能在嵌套块内两次声明局部变量。



== Kotlin 函数

#todo[
  Kotlin 函数章节待补充，内容包括：
  1. 函数定义：顶级函数、成员函数、局部函数
  2. 默认参数与命名参数
  3. 扩展函数
  4. 中缀函数（infix）
  5. 内联函数
  6. Lambda 表达式与高阶函数
]

== 代码块与执行顺序

#todo[
  代码块与执行顺序章节待补充，内容包括：
  1. Java 静态代码块、构造代码块、实例初始化顺序
  2. Kotlin init 初始化块、伴生对象初始化
  3. 两种语言初始化顺序对比
]

== 函数设计基础规范

#todo[
  函数设计基础规范章节待补充，内容包括：
  1. 函数长度控制（单一职责原则）
  2. 参数设计与默认值策略
  3. 返回值设计（Optional、异常 vs 返回码）
  4. 文档注释规范（Javadoc、KDoc）
  5. 测试友好性设计
]

#fancy-divider

= 面向对象编程（OOP）核心

面向对象编程是 Java 和 Kotlin 的核心范式。本章深入讲解类、对象、继承、多态等 OOP 核心概念，并对比两种语言的实现差异。

== 类与对象

=== Java 类定义

```java
public class Person {
    // 字段
    private String name;
    private int age;

    // 构造器
    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }

    // 方法
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return "Person{name='" + name + "', age=" + age + "}";
    }
}

// 创建对象
Person person = new Person("Alice", 25);
```

=== Kotlin 类定义

```kotlin
class Person(val name: String, var age: Int) {
    // 主构造器直接在类声明中

    // 次构造器
    constructor(name: String) : this(name, 0)

    // 方法
    fun greet(): String {
        return "Hello, I'm $name"
    }

    override fun toString(): String {
        return "Person(name='$name', age=$age)"
    }
}

// 创建对象（无需 new）
val person = Person("Alice", 25)
```

#tip[
  Kotlin 的主构造器语法更简洁，减少了样板代码。
]

=== 封装

*Java 访问修饰符*：

#tex-table(
  ("修饰符", "同类", "同包", "子类", "其他"),
  ("private", "✓", "✗", "✗", "✗"),
  ("默认", "✓", "✓", "✗", "✗"),
  ("protected", "✓", "✓", "✓", "✗"),
  ("public", "✓", "✓", "✓", "✓"),
)

*Kotlin 访问修饰符*：

#tex-table(
  ("修饰符", "同类", "同模块", "子类", "其他"),
  ("private", "✓", "✗", "✗", "✗"),
  ("internal", "✓", "✓", "✗", "✗"),
  ("protected", "✓", "✗", "✓", "✗"),
  ("public", "✓", "✓", "✓", "✓"),
)

#note[
  Kotlin 默认是 public，且没有包级私有，而是模块级私有（internal）。
]

=== this 关键字

*Java*：

```java
public class Person {
    private String name;

    public Person(String name) {
        this.name = name;  // 区分参数和字段
    }

    public Person getThis() {
        return this;  // 引用当前对象
    }
}
```

*Kotlin*：

```kotlin
class Person(private val name: String) {
    fun greet() {
        println("Hello, I'm $name")  // 通常不需要 this
    }

    fun getThis(): Person {
        return this  // 显式引用
    }

    // 标签 this
    inner class Inner {
        fun printOuter() {
            println(this@Person.name)  // 引用外部类的 name
        }
    }
}
```

== 静态特性

=== Java static 成员

```java
public class MathUtils {
    // 静态字段
    public static final double PI = 3.14159;

    // 静态方法
    public static int add(int a, int b) {
        return a + b;
    }

    // 静态代码块
    static {
        System.out.println("Class loaded");
    }
}

// 调用
int sum = MathUtils.add(1, 2);
```

=== Kotlin object 单例

```kotlin
// 对象声明（单例）
object MathUtils {
    const val PI = 3.14159

    fun add(a: Int, b: Int): Int {
        return a + b
    }
}

// 调用
val sum = MathUtils.add(1, 2)
```

=== Kotlin 伴生对象

```kotlin
class Person(val name: String) {
    companion object {
        const val SPECIES = "Homo Sapiens"

        fun createAnonymous(): Person {
            return Person("Anonymous")
        }
    }
}

// 调用（类似 Java 静态）
val person = Person.createAnonymous()
println(Person.SPECIES)
```

#tip[
  Kotlin 用 `companion object` 替代 Java 的 static，更符合面向对象思想。
]

=== `@JvmStatic` 注解

```kotlin
class Utils {
    companion object {
        @JvmStatic
        fun helper() {
            println("Called from Java as Utils.helper()")
        }
    }
}
```

#note[
  使用 `@JvmStatic` 可以让 Java 代码像调用静态方法一样调用 Kotlin 伴生对象的方法。
]

== 继承与多态

=== Java 继承

```java
// 父类
public class Animal {
    protected String name;

    public Animal(String name) {
        this.name = name;
    }

    public void speak() {
        System.out.println("...");
    }
}

// 子类
public class Dog extends Animal {
    public Dog(String name) {
        super(name);  // 调用父类构造器
    }

    @Override
    public void speak() {
        System.out.println(name + " says: Woof!");
    }
}

// 多态
Animal animal = new Dog("Buddy");
animal.speak();  // 输出：Buddy says: Woof!
```

=== Kotlin 继承

```kotlin
// 父类（需要 open 关键字）
open class Animal(val name: String) {
    open fun speak() {
        println("...")
    }
}

// 子类
class Dog(name: String) : Animal(name) {
    override fun speak() {
        println("$name says: Woof!")
    }
}

// 多态
val animal: Animal = Dog("Buddy")
animal.speak()  // 输出：Buddy says: Woof!
```

#caution[
  Kotlin 类和成员默认是 final 的，必须显式使用 `open` 才能被继承或重写。这避免了意外的继承。
]

=== super 关键字

*Java*：

```java
public class Cat extends Animal {
    @Override
    public void speak() {
        super.speak();  // 调用父类方法
        System.out.println(name + " says: Meow!");
    }
}
```

*Kotlin*：

```kotlin
class Cat(name: String) : Animal(name) {
    override fun speak() {
        super.speak()  // 调用父类方法
        println("$name says: Meow!")
    }
}
```

=== 向上转型与向下转型

*Java*：

```java
// 向上转型（自动）
Animal animal = new Dog("Buddy");

// 向下转型（需要检查）
if (animal instanceof Dog) {
    Dog dog = (Dog) animal;
    // 使用 dog
}
```

*Kotlin*：

```kotlin
// 向上转型（自动）
val animal: Animal = Dog("Buddy")

// 智能转换
if (animal is Dog) {
    println(animal.name)  // 自动转换为 Dog
}

// 安全转换
val dog = animal as? Dog
```

== 抽象类与接口

=== Java 抽象类

```java
public abstract class Shape {
    protected String color;

    public Shape(String color) {
        this.color = color;
    }

    // 抽象方法
    public abstract double area();

    // 具体方法
    public void display() {
        System.out.println("Color: " + color + ", Area: " + area());
    }
}

public class Circle extends Shape {
    private double radius;

    public Circle(String color, double radius) {
        super(color);
        this.radius = radius;
    }

    @Override
    public double area() {
        return Math.PI * radius * radius;
    }
}
```

=== Kotlin 抽象类

```kotlin
abstract class Shape(val color: String) {
    // 抽象方法
    abstract fun area(): Double

    // 具体方法
    fun display() {
        println("Color: $color, Area: ${area()}")
    }
}

class Circle(val radius: Double, color: String) : Shape(color) {
    override fun area(): Double {
        return Math.PI * radius * radius
    }
}
```

=== Java 接口

```java
// Java 8+ 接口可以有默认方法
public interface Drawable {
    void draw();  // 抽象方法

    default void erase() {
        System.out.println("Erasing...");
    }

    static void info() {
        System.out.println("Drawable interface");
    }
}

public class Rectangle implements Drawable {
    @Override
    public void draw() {
        System.out.println("Drawing rectangle");
    }
}
```

=== Kotlin 接口

```kotlin
interface Drawable {
    fun draw()  // 抽象方法

    fun erase() {  // 默认实现
        println("Erasing...")
    }

    companion object {
        fun info() {
            println("Drawable interface")
        }
    }
}

class Rectangle : Drawable {
    override fun draw() {
        println("Drawing rectangle")
    }
}
```

#tip[
  Kotlin 接口不能有状态（不能有字段），这与 Java 8+ 一致。
]

=== 函数式接口

*Java*：

```java
@FunctionalInterface
public interface Calculator {
    int calculate(int a, int b);
}

// Lambda 表达式
Calculator add = (a, b) -> a + b;
```

*Kotlin*：

```kotlin
// 函数类型（更灵活）
val add: (Int, Int) -> Int = { a, b -> a + b }

// SAM 转换（Java 接口）
val runnable = Runnable { println("Running") }
```

== Kotlin 专属 OOP 特性

=== 数据类（data class）

```kotlin
data class User(val id: Int, val name: String, val email: String)

// 自动生成：equals(), hashCode(), toString(), copy(), componentN()
val user1 = User(1, "Alice", "alice@example.com")
val user2 = user1.copy(email = "new@example.com")  // 复制并修改

// 解构
val (id, name, email) = user1
```

*等价 Java*：

```java
// 需要手动编写或使用 Lombok
public class User {
    private final int id;
    private final String name;
    private final String email;

    // 构造器、getter、equals、hashCode、toString...
}
```

#tip[
  数据类大幅减少样板代码，是 Kotlin 最受欢迎的特性之一。
]

=== 密封类（sealed class）

```kotlin
sealed class Result {
    data class Success(val data: String) : Result()
    data class Error(val message: String) : Result()
    object Loading : Result()
}

// when 表达式 exhaustive
fun handleResult(result: Result): String {
    return when (result) {
        is Result.Success -> "Data: ${result.data}"
        is Result.Error -> "Error: ${result.message}"
        Result.Loading -> "Loading..."
    }
}
```

#note[
  密封类限制了继承层次，编译器可以检查 when 是否 exhaustive，避免遗漏分支。
]

=== 枚举类（enum class）

```kotlin
enum class Color(val rgb: Int) {
    RED(0xFF0000),
    GREEN(0x00FF00),
    BLUE(0x0000FF);

    fun toHex(): String {
        return String.format("#%06X", rgb)
    }
}

// 使用
val color = Color.RED
println(color.toHex())  // #FF0000
```

=== 内联类（inline class / value class）

```kotlin
@JvmInline
value class Password(val value: String)

fun login(password: Password) {
    // 编译后直接传递 String，无额外对象开销
}

val pwd = Password("secret")
login(pwd)
```

#tip[
  内联类在编译后被擦除，提供类型安全但无运行时开销。
]

== 内部类、包机制与访问控制

=== 内部类

*Java*：

```java
public class Outer {
    private String outerField = "Outer";

    // 内部类（持有外部类引用）
    public class Inner {
        public void accessOuter() {
            System.out.println(outerField);  // 可以访问
        }
    }

    // 静态嵌套类
    public static class StaticNested {
        // 不能访问外部类实例成员
    }
}
```

*Kotlin*：

```kotlin
class Outer {
    private val outerField = "Outer"

    // 内部类（需要 inner 关键字）
    inner class Inner {
        fun accessOuter() {
            println(outerField)  // 可以访问
        }
    }

    // 嵌套类（默认，不持有外部类引用）
    class Nested {
        // 不能访问外部类实例成员
    }
}
```

#note[
  Kotlin 默认嵌套类是静态的，需要用 `inner` 关键字才能访问外部类成员，这与 Java 相反。
]

=== 包机制

*Java*：

```java
package com.example.app;

import java.util.List;
import java.util.ArrayList;

public class MyClass {
    // ...
}
```

*Kotlin*：

```kotlin
package com.example.app

import java.util.List
import java.util.ArrayList

class MyClass {
    // ...
}
```

=== 访问控制总结

#tex-table(
  ("特性", "Java", "Kotlin"),
  ("默认可见性", "包私有", "public"),
  ("模块级私有", "✗", "internal"),
  ("继承控制", "默认允许", "默认禁止（需 open）"),
  ("内部类", "默认持有引用", "默认不持有（需 inner）"),
)

== Object 类与 Any 类

=== Java Object 核心方法

```java
public class MyClass {
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        MyClass other = (MyClass) obj;
        return field.equals(other.field);
    }

    @Override
    public int hashCode() {
        return Objects.hash(field);
    }

    @Override
    public String toString() {
        return "MyClass{field='" + field + "'}";
    }

    @Override
    protected Object clone() throws CloneNotSupportedException {
        return super.clone();
    }
}
```

*Object 常用方法*：

- `equals()`：对象相等性
- `hashCode()`：哈希码
- `toString()`：字符串表示
- `getClass()`：获取 Class 对象
- `clone()`：克隆对象
- `finalize()`：垃圾回收前调用（已废弃）

=== Kotlin Any 类

```kotlin
class MyClass(val field: String) {
    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (other !is MyClass) return false
        return field == other.field
    }

    override fun hashCode(): Int {
        return field.hashCode()
    }

    override fun toString(): String {
        return "MyClass(field='$field')"
    }
}
```

*Any vs Object*：

#tex-table(
  ("方法", "Java Object", "Kotlin Any"),
  ("equals", "✓", "✓"),
  ("hashCode", "✓", "✓"),
  ("toString", "✓", "✓"),
  ("getClass", "✓", "::class"),
  ("clone", "✓", "✗"),
  ("finalize", "✓", "✗"),
  ("wait/notify", "✓", "✗"),
)

#note[
  Kotlin 的 Any 更精简，移除了不推荐使用的 finalize 和线程相关的 wait/notify。
]

=== Java 与 Kotlin 互操作

```kotlin
// Kotlin 调用 Java Object 方法
val obj: Any = "Hello"
println(obj.javaClass)  // 获取 Java Class

// Java 调用 Kotlin Any
Object obj = "Hello";
System.out.println(obj.getClass());
```

#fancy-divider

本章完
