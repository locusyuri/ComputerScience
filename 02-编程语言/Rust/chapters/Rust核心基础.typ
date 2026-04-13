#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= Rust 入门与环境搭建

= 基础语法与数据类型

Rust是一门系统级编程语言，强调安全性、并发性和性能。它没有垃圾回收器，通过所有权系统在编译时保证内存安全。

#note[
  Rust的核心理念是*零成本抽象*：你只需要为使用的特性付出代价，而且不能比手写的C/C++代码更慢。
]

== 变量与可变性

Rust的变量默认是不可变的（immutable），这是其安全性的基石之一。

=== 不可变变量

```rust
fn main() {
    let x = 5;
    println!("x = {}", x);

    // 以下代码会编译错误
    // x = 6; // error[E0384]: cannot assign twice to immutable variable `x`
}
```

*特点*：

- 使用 `let` 关键字声明
- 默认不可变
- 编译器保证不会被意外修改
- 有助于并发安全

#tip[
  Rust鼓励不可变性，这可以减少bug并提高代码的可读性和可维护性。
]

=== 可变变量

使用 `mut` 关键字声明可变变量：

```rust
fn main() {
    let mut x = 5;
    println!("x = {}", x);

    x = 6; // 正确：x是可变的
    println!("x = {}", x);
}
```

*注意*：

- 必须显式使用 `mut`
- 只能在同一作用域内修改
- 可变引用有严格限制（后续章节详述）

=== 常量

常量使用 `const` 关键字声明，与变量有重要区别：

```rust
const MAX_POINTS: u32 = 100_000;
const SECONDS_PER_DAY: u32 = 86_400;
```

*常量的特点*：

- 必须标注类型
- 只能设置为常量表达式（不能在运行时计算）
- 可以在任何作用域声明，包括全局
- 命名约定：全大写，下划线分隔
- 不能使用 `mut`

*常量 vs 不可变变量*：

#tex-table(
  ("特性", "常量 (const)", "不可变变量 (let)"),
  ("关键字", "const", "let"),
  ("类型标注", "必须", "可选（类型推断）"),
  ("赋值", "常量表达式", "任意表达式"),
  ("作用域", "全局可用", "当前作用域"),
  ("可变性", "永远不可变", "可用mut变为可变"),
  ("内存位置", "可能嵌入代码", "栈上分配"),
)

#caution[
  不要混淆常量和不可变变量。常量用于真正的编译时常量，而不可变变量用于运行时的值。
]

=== 变量遮蔽（Shadowing）

Rust允许用相同的名称声明新变量，这会“遮蔽”之前的变量：

```rust
fn main() {
    let x = 5;
    let x = x + 1; // 遮蔽了之前的x
    let x = x * 2; // 再次遮蔽

    println!("x = {}", x); // 输出: x = 12
}
```

*遮蔽的特点*：

- 可以改变类型
- 可以改变可变性
- 之前的变量仍然存在，只是无法访问
- 不同于可变变量，遮蔽创建了一个全新的变量

```rust
fn main() {
    let spaces = "   ";
    let spaces = spaces.len(); // 从&str变为usize

    println!("spaces length = {}", spaces); // 输出: 3
}
```

#tip[
  遮蔽比可变变量更安全，因为它创建了新值而不是修改旧值。适合转换数据的场景。
]

== 标量类型

标量类型代表单个值。Rust有四种基本标量类型。

=== 整数类型

==== 有符号整数

- `i8`: 8位，范围 -128 到 127
- `i16`: 16位，范围 -32,768 到 32,767
- `i32`: 32位，范围约 -21亿 到 21亿（默认）
- `i64`: 64位
- `i128`: 128位
- `isize`: 指针大小（取决于架构）

==== 无符号整数

- `u8`: 8位，范围 0 到 255
- `u16`: 16位
- `u32`: 32位
- `u64`: 64位
- `u128`: 128位
- `usize`: 指针大小（常用于索引）

```rust
fn main() {
    let decimal = 98_222;      // 十进制
    let hex = 0xff;            // 十六进制
    let octal = 0o77;          // 八进制
    let binary = 0b1111_0000;  // 二进制
    let byte = b'A';           // 字节 (u8 only)

    println!("decimal: {}, hex: {}, octal: {}, binary: {}, byte: {}",
             decimal, hex, octal, binary, byte);
}
```

*数字字面量*：

- 可以使用下划线提高可读性：`1_000_000`
- 可以指定类型后缀：`57u8`, `3.14f64`

#note[
  `i32` 是Rust的默认整数类型，即使在64位系统上也是如此。它在大多数情况下提供了性能和范围的平衡。
]

==== 整数溢出

Rust在调试模式下检查整数溢出，在发布模式下进行回绕（wrapping）：

```rust
fn main() {
    let x: u8 = 255;
    // let y = x + 1; // 调试模式: panic! 发布模式: y = 0
}
```

*处理方式*：

- `wrapping_add()`: 始终回绕
- `checked_add()`: 返回 `Option`
- `overflowing_add()`: 返回值和溢出标志
- `saturating_add()`: 饱和到最大值

```rust
fn main() {
    let x: u8 = 255;

    println!("wrapping: {}", x.wrapping_add(1));      // 0
    println!("checked: {:?}", x.checked_add(1));       // None
    println!("saturating: {}", x.saturating_add(1));   // 255
}
```

=== 浮点类型

Rust有两种浮点类型：

- `f32`: 32位单精度
- `f64`: 64位双精度（默认）

```rust
fn main() {
    let x = 2.0;      // f64
    let y: f32 = 3.0; // f32

    println!("x = {}, y = {}", x, y);
}
```

*浮点运算*：

```rust
fn main() {
    let sum = 5.0 + 10.0;
    let difference = 95.5 - 4.3;
    let product = 4.0 * 30.0;
    let quotient = 56.7 / 32.2;
    let remainder = 43 % 5; // 整数取模

    println!("sum={}, diff={}, prod={}, quot={}, rem={}",
             sum, difference, product, quotient, remainder);
}
```

#caution[
  浮点数不遵循结合律和分配律！`(a + b) + c` 可能不等于 `a + (b + c)`。不要直接用 `==` 比较浮点数。
]

=== 布尔类型

布尔类型 `bool` 有两个可能的值：`true` 和 `false`。

```rust
fn main() {
    let t = true;
    let f: bool = false;

    if t {
        println!("t is true");
    }
}
```

*布尔运算*：

```rust
fn main() {
    let a = true;
    let b = false;

    println!("a && b = {}", a && b); // AND
    println!("a || b = {}", a || b); // OR
    println!("!a = {}", !a);         // NOT
}
```

#note[
  Rust的布尔类型占用1个字节，不是1个bit。这是为了内存对齐和访问效率。
]

=== 字符类型

`char` 类型表示一个Unicode标量值，占用4个字节。

```rust
fn main() {
    let c = 'z';
    let z: char = 'ℤ';
    let heart_eyed_cat = '😻';

    println!("c={}, z={}, cat={}", c, z, heart_eyed_cat);
}
```

*特点*：

- 用单引号 `'` 包围
- Unicode标量值（U+0000 到 U+D7FF，U+E000 到 U+10FFFF）
- 不只是ASCII，支持全球语言
- 占用4字节（32位）

```rust
fn main() {
    // 转义字符
    let newline = '\n';
    let tab = '\t';
    let backslash = '\\';
    let quote = '\'';

    // Unicode转义
    let heart = '\u{2764}'; // ❤

    println!("newline, tab, backslash, quote, heart");
}
```

#note[
  `char` 和字符串切片 `&str` 不同。`char` 是单个Unicode标量值，而字符串是UTF-8编码的字节序列。
]

== 复合类型

复合类型可以将多个值组合成一个类型。Rust有两个原始的复合类型：元组和数组。

=== 元组（Tuple）

元组是将#emphasis[多个类型的值组合成一个复合类型]的一般方式。

==== 基本用法

```rust
fn main() {
    let tup: (i32, f64, u8) = (500, 6.4, 1);

    // 解构元组
    let (x, y, z) = tup;
    println!("x={}, y={}, z={}", x, y, z);

    // 通过索引访问
    let five_hundred = tup.0;
    let six_point_four = tup.1;
    let one = tup.2;
}
```

*特点*：

- 长度固定
- 可以包含不同类型的值
- 通过模式匹配解构
- 通过点号加索引访问（`.0`, `.1`, `.2`）

==== 空元组

```rust
fn main() {
    let unit: () = ();
    println!("unit tuple: {:?}", unit);
}
```

空元组 `()` 也称为单元类型，表示没有值。函数的返回值如果是 `()`，通常省略不写。

==== 元组作为返回值

```rust
fn calculate_stats(numbers: &[i32]) -> (i32, i32, f64) {
    let min = *numbers.iter().min().unwrap();
    let max = *numbers.iter().max().unwrap();
    let avg = numbers.iter().sum::<i32>() as f64 / numbers.len() as f64;

    (min, max, avg)
}

fn main() {
    let nums = vec![1, 2, 3, 4, 5];
    let (min, max, avg) = calculate_stats(&nums);

    println!("min={}, max={}, avg={}", min, max, avg);
}
```

#tip[
  当函数需要返回多个值时，元组是一个简单有效的选择。但对于复杂的数据结构，建议使用结构体。
]

=== 数组（Array）

数组是#emphasis("相同类型元素的固定长度集合")。

==== 基本用法

```rust
fn main() {
    let months = ["January", "February", "March",
                  "April", "May", "June",
                  "July", "August", "September",
                  "October", "November", "December"];

    let first = months[0];
    let last = months[11];

    println!("First: {}, Last: {}", first, last);
}
```

*特点*：

- 长度固定（编译时确定）
- 所有元素类型相同
- 存储在栈上
- 通过索引访问（从0开始）

==== 数组类型标注

```rust
fn main() {
    let a: [i32; 5] = [1, 2, 3, 4, 5];

    // 初始化所有元素为相同值
    let b = [3; 5]; // 等同于 [3, 3, 3, 3, 3]

    println!("a={:?}, b={:?}", a, b);
}
```

类型格式：`[类型; 长度]`

==== 数组访问与安全

```rust
fn main() {
    let a = [1, 2, 3, 4, 5];

    let index = 10;
    let element = a[index]; // panic: index out of bounds
}
```

#caution[
  Rust在运行时检查数组访问边界。如果索引超出范围，程序会panic而不是访问非法内存。这保证了内存安全，但会带来轻微的性能开销。
]

==== 数组 vs Vec

#tex-table(
  ("特性", "数组 [T; N]", "Vec<T>"),
  ("长度", "固定（编译时）", "动态（运行时）"),
  ("内存位置", "栈", "堆"),
  ("性能", "更快", "稍慢"),
  ("灵活性", "低", "高"),
  ("适用场景", "已知大小", "未知或变化大小"),
)

#tip[
  当你确定元素数量不会改变时，使用数组。否则，使用 `Vec<T>`（向量），它是可增长的数组。
]

== 注释

良好的注释是高质量代码的重要组成部分。

=== 行注释

使用 `//` 添加行注释：

```rust
fn main() {
    // 这是一个行注释
    let x = 5; // 这也是注释

    // 多行注释
    // 可以这样写
    // 每一行都用 //
}
```

=== 块注释

使用 `/* */` 添加块注释：

```rust
fn main() {
    /*
     * 这是一个块注释
     * 可以跨越多行
     * 适合较长的说明
     */
    let x = 5;

    /* 也可以这样写短注释 */
}
```

#note[
  Rust支持嵌套块注释：`/* outer /* inner */ outer */`。这在C/C++中是不支持的。
]

=== 文档注释

文档注释以 `///` 或 `//!` 开头，会被 `cargo doc` 工具提取生成HTML文档。

==== 行文档注释（\/\/\/）

用于注释紧随其后的项：

```rust
/// 计算两个数的和
///
/// # Examples
///
/// \`\`\`
/// let result = add(2, 3);
/// assert_eq!(result, 5);
/// \`\`\`
fn add(a: i32, b: i32) -> i32 {
    a + b
}
```

==== 块文档注释（\/\*\*\/）

```rust
/**
 * 计算两个数的乘积
 *
 * # Arguments
 *
 * * `a` - 第一个数
 * * `b` - 第二个数
 *
 * # Returns
 *
 * 两数的乘积
 */
fn multiply(a: i32, b: i32) -> i32 {
    a \* b
}
```

==== 模块文档注释（\/\/\!）

用于注释包含它的项（通常是模块或crate）：

```rust
//! # My Crate
//!
//! `my_crate` is a collection of utilities for performing calculations.

/// Add two numbers
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}
```

=== 文档注释的Markdown特性

文档注释支持Markdown格式:

```rust
/// # Summary
///
/// A brief description of the function.
///
/// # Arguments
///
/// * `name` - The name of the person
/// * `age` - The age of the person
///
/// # Returns
///
/// A greeting string
///
/// # Examples
///
/// \`\`\`
/// let greeting = greet("Alice", 30);
/// assert_eq!(greeting, "Hello, Alice! You are 30 years old.");
/// \`\`\`
///
/// # Panics
///
/// Panics if `name` is empty.
///
/// # Errors
///
/// Returns an error if `age` is negative.
///
/// # Safety
///
/// This function is safe to call.
fn greet(name: &str, age: u32) -> String {
    format!("Hello, {}! You are {} years old.", name, age)
}
```

*常用的文档标记*：

- `# Examples`: 代码示例（会被测试）
- `# Panics`: 说明panic条件
- `# Errors`: 说明返回的错误
- `# Safety`: 说明不安全操作的前提条件
- `# Arguments`: 参数说明

#tip[
  经常运行 `cargo doc --open` 来查看生成的文档。良好的文档注释可以自动生成专业的API文档。
]

== 格式化输出

Rust提供了强大的格式化输出功能，主要通过 `println!`、`format!` 等宏实现。

=== println! & print!

```rust
fn main() {
let name = "Alice";
let age = 30;

println!("Hello, {}! You are {} years old.", name, age);
}
```

*特点*：

- 自动添加换行符
- 支持多个占位符 `{}`
- 类型安全（编译时检查）


```rust
fn main() {
print!("This is on the same line");
print!(" and this too.\n");
}
```

#note[
    *区别*：`print!` 不自动添加换行符。
]


=== eprintln! 和 eprint!

输出到标准错误流：

```rust
fn main() {
eprintln!("Error: something went wrong!");
}
```

*用途*：错误信息和诊断信息应该输出到stderr。

=== 格式化占位符

==== 基本占位符

```rust
fn main() {
let x = 42;

// 使用 {} 进行默认格式化
println!("Value: {}", x);
}
```

*常用格式化trait*：

- `Display` (`{}`): 用户友好的输出，需手动实现
- `Debug` (`{:?}`): 开发者调试输出，可自动派生
- `Pretty Debug` (`{:#?}`): 美化Debug格式，多行输出

#note[
  在Typst文档中，包含复杂格式化字符串的Rust代码可能需要特殊处理。实际使用时请参考Rust官方文档。
]

==== 位置参数

```rust
fn main() {
    println!("{0} {1} {0}", "hello", "world");
    // 输出: hello world hello
}
```

==== 命名参数

```rust
fn main() {
println!("{greeting}, {name}!", greeting = "Hello", name = "Alice");
}
```

==== 格式化选项

===== 宽度

*对齐选项*：

- `{:>5}`: 右对齐，宽度5
- `{:<5}`: 左对齐，宽度5
- `{:^5}`: 居中，宽度5
- `{:*^5}`: 使用`*`填充，居中对齐

```rust
fn main() {
let text = "hi";
println!("Aligned text example");
}
```

===== 精度

```rust
fn main() {
let pi = 3.14159265359;
println!("{:.2}", pi);  // 3.14
println!("{:.4}", pi);  // 3.1416
}
```

===== 进制

```rust
fn main() {
let x = 42;
println!("Decimal: {}", x);    // 42
println!("Binary: {:b}", x);   // 101010
println!("Octal: {:o}", x);    // 52
println!("Hex: {:x}", x);      // 2a
println!("HEX: {:X}", x);      // 2A
}
```

===== 指针地址

```rust
fn main() {
let x = 42;
let ptr = &x;
println!("Pointer: {:p}", ptr);
}
```

=== format! 宏

`format!` 返回格式化的字符串，而不是直接输出：

```rust
fn main() {
let name = "Alice";
let age = 30;

let message = format!("{} is {} years old", name, age);
println!("{}", message);
}
```

*用途*：

- 构建字符串
- 日志记录
- 错误消息

=== Display & Debug

Rust有两个主要的格式化trait：

==== Display（{}）

面向用户的格式化，需要手动实现：

```rust
use std::fmt;

struct Point {
x: f64,
y: f64,
}

impl fmt::Display for Point {
fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
write!(f, "({}, {})", self.x, self.y)
}
}

fn main() {
let p = Point { x: 1.0, y: 2.0 };
// 使用 {} 占位符
println!("Point: {}", p);
}
```

==== Debug（{:?}）

面向开发者的调试格式化，可以自动派生：

```rust
#[derive(Debug)]
struct Point {
x: f64,
y: f64,
}

fn main() {
let p = Point { x: 1.0, y: 2.0 };
// 使用 {:?} 进行Debug格式化
println!("Debug output available");
}
```

#tip[
  对于自定义类型，优先实现 `Debug`（使用 `#[derive(Debug)]`）。如果需要用户友好的输出，再实现 `Display`。
]

=== 常见格式化示例

```rust
fn main() {
    // 百分比
    let percentage = 0.95 \* 100.0;
    println!("Percentage: {:.1}%", percentage);

    // 科学计数法
    println!("Scientific: {:e}", 1000000.0);

    // 填充零
    println!("Zero padded: {:0>5}", 42);

    // 截断字符串
    println!("Truncated: {:.3}", "hello");

    // 布尔值
    println!("{}", true);
    println!("{}", false);
}
```

== 类型转换

Rust提供了多种类型转换机制。

=== 隐式转换（Coercion）

某些情况下Rust会自动转换类型：

```rust
fn main() {
    let x: i32 = 5;
    let y: i64 = x as i64; // 需要显式转换
}
```

#caution[
  Rust几乎没有隐式数值类型转换。这与C/C++不同，有助于避免意外的精度丢失。
]

=== 显式转换（as）

使用 `as` 关键字进行基本类型转换：

```rust
fn main() {
    let decimal = 65.4321_f32;

    // 转换为整数（截断）
    let integer = decimal as u8;
    println!("{} -> {}", decimal, integer); // 65.4321 -> 65

    // 字符转换
    let character = integer as char;
    println!("{} -> {}", integer, character); // 65 -> A

    // 不同类型整数转换
    let a: u8 = 200;
    let b: u16 = a as u16;
    let c: i32 = a as i32;
}
```

*注意事项*：

- 浮点转整数会截断小数部分
- 大值转小类型会溢出（回绕）
- 负数转无符号类型会产生大正数

```rust
fn main() {
    let large_number: i32 = 1000;
    let small_number = large_number as u8; // 溢出: 1000 % 256 = 232
    println!("{} -> {}", large_number, small_number);
}
```

=== TryFrom 和 TryInto

安全的转换方式，返回 `Result`：

```rust
use std::convert::TryFrom;
use std::convert::TryInto;

fn main() {
    let big_number: i64 = 1000;

    // TryFrom - 尝试转换
    let result = u8::try_from(big_number);

    match result {
        Ok(value) => println!("Success: {}", value),
        Err(_) => println!("Conversion failed"),
    }

    // TryInto - 另一种方式
    let converted: Result<u8, _> = big_number.try_into();

    if let Ok(value) = converted {
        println!("Converted: {}", value);
    }
}
```

#tip[
  优先使用 `TryFrom`/`TryInto` 进行可能失败的转换，它们更安全且符合Rust的错误处理哲学。
]

=== From 和 Into

无失败的转换，自动实现：

```rust
fn main() {
    let my_str = "hello";

    // Into
    let my_string: String = my_str.into();

    // From（等价）
    let my_string2 = String::from(my_str);
}
```

*规则*：如果实现了 `From<T> for U`，则自动实现 `Into<U> for T`。

== 总结

本节介绍了Rust的基础语法和数据类型：

- *变量与可变性*：默认不可变，使用 `mut` 声明可变变量，`const` 声明常量
- *标量类型*：整数、浮点数、布尔、字符
- *复合类型*：元组和数组
- *注释*：行注释、块注释、文档注释
- *格式化输出*：`println!`、`format!`、格式化选项
- *类型转换*：`as`、`TryFrom`、`From`

#fancy-divider

下一节将深入探讨Rust最核心的概念：*所有权与借用机制*。

= 所有权与借用机制

所有权（Ownership）是Rust最独特和最重要的特性，它使Rust能够在没有垃圾回收器的情况下保证内存安全。理解所有权是掌握Rust的关键。

#note[
  所有权的规则在编译时检查，因此不会带来运行时开销。这是Rust零成本抽象的核心体现。
]

== 所有权规则

Rust的所有权系统基于三条简单但强大的规则：

1. #emphasis("Rust中的每个值都有一个变量，称为其所有者")
2. #emphasis("一次只能有一个所有者")
3. #emphasis("当所有者离开作用域时，值将被丢弃")

```rust
fn main() {
    // 规则1: s是String值的所有者
    let s = String::from("hello");

    // 规则2: s是唯一的所有者
    // let t = s; // 如果这样做，s不再有效

    // 规则3: 当main函数结束时，s被丢弃
} // s在这里离开作用域，内存被释放
```

== 栈与堆

理解所有权需要先了解内存管理的基础：栈和堆。

=== 栈（Stack）

*特点*：

- 后进先出（LIFO）
- 所有数据必须有已知的大小
- 分配和释放非常快
- 存储在栈上的数据是"拥有"的

```rust
fn main() {
    // 这些类型大小已知，存储在栈上
    let x = 5;          // i32, 4字节
    let y = true;       // bool, 1字节
    let z = (1, 2);     // (i32, i32), 8字节
} // 按相反顺序释放：z, y, x
```

=== 堆（Heap）

*特点*：

- 组织性较差
- 分配时需要查找足够大的空间
- 比栈慢
- 需要手动管理或使用垃圾回收

```rust
fn main() {
    // String数据存储在堆上
    let s = String::from("hello");
    // s本身在栈上（指针、长度、容量）
    // 实际字符串数据在堆上
}
```

=== 栈 vs 堆对比

#tex-table(
  ("特性", "栈", "堆"),
  ("速度", "快", "慢"),
  ("大小", "固定、已知", "动态、未知"),
  ("访问", "直接", "通过指针"),
  ("管理", "自动", "需要跟踪"),
  ("典型类型", "整数、布尔、元组", "String、Vec、Box"),
)

#tip[
  Rust通过所有权系统在编译时跟踪堆上数据的生命周期，无需垃圾回收器。
]

== 移动语义（Move）

当一个值被赋值给另一个变量或传递给函数时，所有权会转移。

=== 基本移动

```rust
fn main() {
    let s1 = String::from("hello");
    let s2 = s1; // s1的所有权移动到s2

    // println!("{}", s1); // 错误！s1不再有效
    println!("{}", s2); // 正确
} // 只有s2被释放，s1已经无效
```

*发生了什么*：

```
Before: s1 -> [heap data "hello"]
After:  s2 -> [heap data "hello"]
        s1 -> (invalid)
```

#caution[
  这与C++不同！C++会进行深拷贝，而Rust只复制栈上的指针、长度和容量，不复制堆上的数据。这避免了双重释放问题。
]

=== 为什么不是拷贝？

对于复杂类型（如String），Rust选择移动而非拷贝的原因：

1. *性能*：避免昂贵的堆内存复制
2. *安全*：防止双重释放（double free）
3. *明确*：清楚地表明所有权转移

```rust
fn main() {
    let s1 = String::from("hello");
    let s2 = s1.clone(); // 显式克隆，深拷贝

    println!("s1={}, s2={}", s1, s2); // 都有效
}
```

#tip[
  如果需要保留原值，使用 `.clone()` 方法进行深拷贝。但要注意性能开销。
]

=== 仅限栈的类型（Copy trait）

某些简单类型实现了 `Copy` trait，它们的行为不同：

```rust
fn main() {
    let x = 5;
    let y = x; // x仍然有效，因为i32实现了Copy

    println!("x={}, y={}", x, y); // 都有效
}
```

*实现Copy的类型*：

- 所有整数类型（`i32`, `u64`等）
- 布尔类型（`bool`）
- 浮点类型（`f64`, `f32`）
- 字符类型（`char`）
- 元组（仅当所有元素都实现Copy时）

*不实现Copy的类型*：

- `String`
- `Vec<T>`
- `Box<T>`
- 任何包含上述类型的结构体

#note[
  Copy和Move的区别：Copy类型赋值后原值仍有效，Move类型赋值后原值失效。
]

== 函数与所有权

将值传递给函数也会发生移动或拷贝。

=== 参数传递

```rust
fn main() {
    let s = String::from("hello");

    takes_ownership(s); // s的所有权移动到函数中

    // println!("{}", s); // 错误！s不再有效

    let x = 5;

    makes_copy(x); // x被拷贝到函数中

    println!("{}", x); // 正确，x仍然有效
}

fn takes_ownership(some_string: String) {
    println!("{}", some_string);
} // some_string在这里离开作用域并被释放

fn makes_copy(some_integer: i32) {
    println!("{}", some_integer);
} // some_integer是Copy类型，不影响原值
```

=== 返回值与所有权

函数也可以返回所有权：

```rust
fn main() {
    let s1 = gives_ownership(); // 接收所有权

    let s2 = String::from("hello");
    let s3 = takes_and_gives_back(s2); // s2移动进去，s3接收返回

    // println!("{}", s2); // 错误！s2已移动
    println!("s1={}, s3={}", s1, s3);
}

fn gives_ownership() -> String {
    let some_string = String::from("yours");
    some_string // 返回，所有权转移到调用者
}

fn takes_and_gives_back(a_string: String) -> String {
    a_string // 返回，所有权转移回调用者
}
```

#tip[
  这种模式很繁琐！每次都需要转移和返回所有权。这就是为什么我们需要*引用和借用*。
]

== 引用与借用

引用允许你使用值而不获取所有权。

=== 不可变引用

```rust
fn main() {
    let s1 = String::from("hello");

    let len = calculate_length(&s1); // 借用s1，不获取所有权

    println!("The length of '{}' is {}.", s1, len); // s1仍然有效
}

fn calculate_length(s: &String) -> usize { // s是对String的引用
    s.len()
} // s离开作用域，但它不拥有数据，所以不释放
```

*关键概念*：

- `&s1`: 创建对s1的引用
- `&String`: 参数类型是String的引用
- *借用（Borrowing）*: 临时使用值，不获取所有权

=== 引用规则

Rust对引用有严格的规则：

==== 规则1：可变引用限制

#emphasis("在同一时间，你只能有一个可变引用")：

```rust
fn main() {
    let mut s = String::from("hello");

    let r1 = &mut s;
    // let r2 = &mut s; // 错误！不能同时有多个可变引用

    r1.push_str(", world");
    println!("{}", r1);
} // r1在这里离开作用域，可以创建新的可变引用
```

#caution[
  这个限制防止了数据竞争（data race）。数据竞争会导致未定义行为，是许多bug的根源。
]

==== 规则2：不可变和可变引用不能共存

#emphasis("当你有不可变引用时，不能有可变引用")：

```rust
fn main() {
    let mut s = String::from("hello");

    let r1 = &s; // 没问题
    let r2 = &s; // 没问题，多个不可变引用可以共存
    // let r3 = &mut s; // 错误！不能在有不可变引用时创建可变引用

    println!("{} and {}", r1, r2);
    // r1和r2不再使用后，可以创建可变引用
    let r3 = &mut s; // 没问题
    println!("{}", r3);
}
```

*原因*：如果有不可变引用正在读取数据，同时有可变引用在修改数据，会导致数据不一致。

==== 规则3：引用必须始终有效

#emphasis("dangling reference（悬垂引用）是不允许的")：

```rust
// fn dangle() -> &String { // 错误！返回悬垂引用
//     let s = String::from("hello");
//     &s
// } // s在这里离开作用域并被释放，返回的引用指向无效内存

fn no_dangle() -> String {
    let s = String::from("hello");
    s // 返回所有权，而不是引用
}
```

#note[
  Rust的借用检查器在编译时确保引用始终有效，防止了悬垂引用问题。
]

=== 可变引用

```rust
fn main() {
    let mut s = String::from("hello");

    change(&mut s);

    println!("{}", s); // 输出: hello, world
}

fn change(some_string: &mut String) {
    some_string.push_str(", world");
}
```

*注意*：

- `let mut s`: s必须是可变的
- `&mut s`: 创建可变引用
- `&mut String`: 参数类型是可变引用

== 切片（Slices）

切片是一种特殊的引用，它不拥有数据，而是引用集合的一部分。

=== 字符串切片

```rust
fn main() {
    let s = String::from("hello world");

    let hello = &s[0..5];   // "hello"
    let world = &s[6..11];  // "world"

    println!("{} {}", hello, world);
}
```

*语法*：`&s[start..end]`

- `start`: 起始索引（包含）
- `end`: 结束索引（不包含）

==== 简化语法

```rust
fn main() {
    let s = String::from("hello world");

    let slice1 = &s[0..2];  // "he"
    let slice2 = &s[..2];   // "he" (省略起始，默认为0)

    let slice3 = &s[3..5];  // "lo"
    let slice4 = &s[3..];   // "lo world" (省略结束，默认为末尾)

    let slice5 = &s[..];    // 整个字符串
}
```

==== 字符串切片的类型

字符串切片的类型是 `&str`：

```rust
fn main() {
    let s = String::from("hello world");
    let word = first_word(&s);

    println!("First word: {}", word);
}

fn first_word(s: &String) -> &str {
    let bytes = s.as_bytes();

    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return &s[0..i];
        }
    }

    &s[..]
}
```

#tip[
  推荐使用 `&str` 作为函数参数类型，而不是 `&String`。这样函数可以接受String切片和字符串字面量。
]

==== 字符串字面量就是切片

```rust
fn main() {
    let s = "Hello, world!"; // s的类型是 &str

    // 字符串字面量直接存储在程序的二进制文件中
    // 它是不可变的，并且是切片类型
}
```

=== 数组切片

```rust
fn main() {
    let a = [1, 2, 3, 4, 5];

    let slice = &a[1..3]; // &[i32], 包含 [2, 3]

    println!("{:?}", slice);
}

fn first_element(arr: &[i32]) -> Option<&i32> {
    arr.get(0)
}
```

*数组切片的类型*：`&[T]`

== 所有权实践示例

=== 示例1：处理用户输入

```rust
fn main() {
    let input = String::from("  hello world  ");

    // 不需要所有权，使用引用
    let trimmed = trim_whitespace(&input);
    println!("Trimmed: '{}'", trimmed);

    // 仍然可以使用input
    println!("Original: '{}'", input);
}

fn trim_whitespace(s: &str) -> &str {
    s.trim()
}
```

=== 示例2：构建字符串

```rust
fn main() {
    let mut result = String::new();

    append_greeting(&mut result, "Alice");
    append_greeting(&mut result, "Bob");

    println!("{}", result);
}

fn append_greeting(buffer: &mut String, name: &str) {
    buffer.push_str("Hello, ");
    buffer.push_str(name);
    buffer.push('\n');
}
```

=== 示例3：返回数据

```rust
fn main() {
    // 方式1：返回所有权
    let s1 = create_message();
    println!("{}", s1);

    // 方式2：使用可变引用
    let mut s2 = String::new();
    build_message(&mut s2);
    println!("{}", s2);
}

fn create_message() -> String {
    String::from("Hello from function")
}

fn build_message(buffer: &mut String) {
    buffer.push_str("Hello from mutable ref");
}
```

#tip[
  选择哪种方式取决于具体情况：
  - 如果函数创建新数据，返回所有权
  - 如果函数修改现有数据，使用可变引用
  - 如果函数只读取数据，使用不可变引用
]

== 常见错误与解决

=== 错误1：使用已移动的值

```rust
fn main() {
    let s = String::from("hello");
    let t = s; // s移动给t

    // println!("{}", s); // error[E0382]: borrow of moved value
}
```

*解决*：

```rust
fn main() {
    let s = String::from("hello");
    let t = s.clone(); // 克隆，s仍然有效

    println!("s={}, t={}", s, t);
}
```

=== 错误2：同时存在可变和不可变引用

```rust
fn main() {
    let mut s = String::from("hello");

    let r1 = &s;
    let r2 = &s;
    // let r3 = &mut s; // error[E0502]: cannot borrow as mutable

    println!("{} and {}", r1, r2);
    // 现在可以创建可变引用
    let r3 = &mut s;
    println!("{}", r3);
}
```

*解决*：确保不可变引用不再使用后，再创建可变引用。

=== 错误3：返回局部变量的引用

```rust
// fn returns_reference() -> &String {
//     let s = String::from("hello");
//     &s // error[E0106]: missing lifetime specifier
// }
```

*解决*：

```rust
fn returns_owned() -> String {
    let s = String::from("hello");
    s // 返回所有权
}
```

== 总结

所有权和借用是Rust最核心的概念：

- *所有权*：每个值都有唯一的所有者，所有者离开作用域时值被释放
- *移动*：赋值和传参时转移所有权，避免双重释放
- *Copy*：简单类型自动拷贝，不涉及所有权转移
- *引用*：允许借用值而不获取所有权
- *借用规则*：
  - 任意时刻要么有一个可变引用，要么有多个不可变引用
  - 引用必须始终有效
- *切片*：引用集合的一部分，类型是 `&[T]` 或 `&str`

#fancy-divider

掌握所有权和借用是成为Rust程序员的关键。下一章将深入探讨*结构体、枚举和模式匹配*。

