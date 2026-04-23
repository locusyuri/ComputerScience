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
