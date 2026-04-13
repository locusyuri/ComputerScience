#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= 正则表达式

正则表达式（Regular Expression，简称Regex）是一种强大的文本模式匹配工具，用于搜索、替换、验证和提取字符串中的特定模式。它被广泛应用于编程语言、文本编辑器、数据库和命令行工具中。

#note[
  正则表达式的核心理念是*用简洁的模式描述复杂的文本规则*。虽然学习曲线较陡，但一旦掌握，将成为处理文本的利器。
]

== 基础概念

=== 什么是正则表达式

正则表达式是由普通字符和特殊字符（元字符）组成的模式字符串。

*应用场景*：

- 数据验证（邮箱、手机号、身份证号）
- 文本搜索和替换
- 信息提取（从日志中提取IP地址）
- 数据清洗（去除HTML标签）
- 语法高亮

=== 正则引擎

不同的语言和工具使用不同的正则引擎：

#tex-table(
  ("引擎类型", "特点", "代表实现"),
  ("DFA", "速度快，不支持回溯", "grep, awk"),
  ("NFA", "功能强大，支持回溯", "Perl, Python, Java"),
  ("POSIX NFA", "标准兼容性好", "Unix工具"),
  ("PCRE", "功能最丰富", "PHP, Apache"),
)

#tip[
  大多数现代编程语言使用NFA引擎，支持更复杂的特性，但需要注意性能问题。
]

== 基本语法

=== 普通字符

大多数字母和数字都是普通字符，直接匹配自身：

```text
abc    匹配 "abc"
123    匹配 "123"
Hello  匹配 "Hello"
```

=== 元字符

元字符在正则中有特殊含义，需要转义才能匹配字面值。

==== 单个字符匹配

#tex-table(
  ("元字符", "含义", "示例", "匹配"),
  ("`.`", "任意字符（除换行）", "`a.c`", "`abc`, `a1c`, `a c`"),
  ("`\\d`", "数字", "`\\d`", "`0-9`"),
  ("`\\D`", "非数字", "`\\D`", "`a, @, 空格`"),
  ("`\\w`", "单词字符", "`\\w`", "`a-z, A-Z, 0-9, _`"),
  ("`\\W`", "非单词字符", "`\\W`", "`@, #, 空格`"),
  ("`\\s`", "空白字符", "`\\s`", "`空格, tab, 换行`"),
  ("`\\S`", "非空白字符", "`\\S`", "`a, 1, @`"),
)

#caution[
  在不同语言中，反斜杠的转义层级不同。例如在Java中，`\\d` 需要写成 `"\\\\d"`（两次转义）。
]

==== 字符集

```text
[aeiou]     匹配任意元音字母
[0-9]       匹配任意数字（等同于 \\d）
[a-zA-Z]    匹配任意字母
[^0-9]      匹配非数字（^在开头表示否定）
[abc^]      匹配 a, b, c, ^ （^不在开头就是普通字符）
```

==== 量词

#tex-table(
  ("量词", "含义", "示例", "匹配次数"),
  ("`*`", "0次或多次", "`ab*c`", "`ac, abc, abbc, abbbc...`"),
  ("`+`", "1次或多次", "`ab+c`", "`abc, abbc, abbbc...`"),
  ("`?`", "0次或1次", "`ab?c`", "`ac, abc`"),
  ("`{n}`", "恰好n次", "`a{3}`", "`aaa`"),
  ("`{n,}`", "至少n次", "`a{2,}`", "`aa, aaa, aaaa...`"),
  ("`{n,m}`", "n到m次", "`a{2,4}`", "`aa, aaa, aaaa`"),
)

==== 贪婪 vs 懒惰

*贪婪模式*（默认）：尽可能多匹配

```text
.*     匹配尽可能多的字符
.+     匹配尽可能多的字符
.{2,5} 匹配2到5个，优先5个
```

*懒惰模式*（加`?`）：尽可能少匹配

```text
.*?    匹配尽可能少的字符
.+?    匹配尽可能少的字符
.{2,5}? 匹配2到5个，优先2个
```

*示例*：

```text
文本: <div>hello</div><div>world</div>

贪婪: <div>.*</div>   匹配: <div>hello</div><div>world</div>
懒惰: <div>.*?</div>  匹配: <div>hello</div> 和 <div>world</div>
```

#tip[
  提取HTML标签内容时，通常使用懒惰模式，避免匹配过多内容。
]

==== 锚点

#tex-table(
  ("锚点", "含义", "示例"),
  ("`^`", "字符串开头", "`^Hello` 匹配以Hello开头的字符串"),
  ("`$`", "字符串结尾", "`World$` 匹配以World结尾的字符串"),
  ("`\\b`", "单词边界", "`\\bcat\\b` 匹配独立的cat"),
  ("`\\B`", "非单词边界", "`\\Bcat\\B` 匹配embedded中的cat"),
)

*注意*：在多行模式下，`^` 和 `$` 匹配每行的开头和结尾。

==== 分组与捕获

```text
(...)      捕获分组
(?:...)    非捕获分组
(?P<name>...) 命名分组（Python等）
(?<name>...)  命名分组（.NET, Java）
```

*示例*：

```text
(\\d{4})-(\\d{2})-(\\d{2})  匹配日期并捕获年月日

分组1: 年
分组2: 月
分组3: 日
```

==== 反向引用

```text
(\\w+)\\s+\\1    匹配重复的单词，如 "hello hello"

\\1 引用第一个分组
\\2 引用第二个分组
```

==== 选择（或）

```text
cat|dog      匹配 cat 或 dog
(red|blue)   匹配 red 或 blue
```

== 高级特性

=== 零宽断言（Lookaround）

零宽断言不消耗字符，只判断位置。

==== 先行断言（Lookahead）

*肯定先行* `(?=...)`：后面必须匹配

```text
\\d+(?=px)    匹配后面跟着px的数字
              "100px" 匹配 "100"
              "100em" 不匹配
```

*否定先行* `(?!...)`：后面不能匹配

```text
\\d+(?!px)    匹配后面不跟px的数字
              "100em" 匹配 "100"
              "100px" 不匹配
```

==== 后行断言（Lookbehind）

*肯定后行* `(?<=...)`：前面必须匹配

```text
(?<=\\$)\\d+  匹配$后面的数字
              "$100" 匹配 "100"
              "€100" 不匹配
```

*否定后行* `(?<!...)`：前面不能匹配

```text
(?<!\\$)\\d+  匹配$前面的数字
              "€100" 匹配 "100"
              "$100" 不匹配
```

#note[
  并非所有正则引擎都支持后行断言。JavaScript在ES2018之前不支持，Python和Java支持。
]

=== 条件表达式

```text
(?(condition)yes|no)

如果condition匹配，则尝试yes，否则尝试no
```

*示例*：

```text
(<)?\\w+(?(1)>)

如果有左尖括号，必须有右尖括号
匹配: <tag>, tag
不匹配: <tag, tag>
```

=== 原子分组

```text
(?>...)

一旦匹配成功，不回溯
```

*用途*：优化性能，防止灾难性回溯

```text
(?>a+)b

对 "aaaaaab" 快速失败，而不是尝试所有可能
```

=== 递归匹配

某些引擎（PCRE）支持递归：

```text
(\\((?:[^()]*|(?R))*\\))

匹配平衡的括号
匹配: ((())), (a(b)c)
```

#caution[
  递归匹配功能强大但复杂，且不是所有引擎都支持。对于嵌套结构，建议使用专门的解析器。
]

== 常用正则模式

=== 数据验证

==== 邮箱地址

```text
^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$

解释:
^           开头
[A-Za-z0-9._%+-]+  用户名（允许字母、数字、特定符号）
@           @符号
[A-Za-z0-9.-]+     域名
\\.          点号
[A-Za-z]{2,} 顶级域名（至少2个字母）
$           结尾
```

#note[
  这个正则能覆盖大部分常见邮箱，但不符合RFC 5322完整规范。生产环境建议使用专门的验证库。
]

==== 手机号码（中国）

```text
^1[3-9]\\d{9}$

解释:
^        开头
1        以1开头
[3-9]    第二位是3-9
\\d{9}   后面9位数字
$        结尾
```

==== 身份证号（中国）

```text
^\\d{17}[\\dXx]$

解释:
^         开头
\\d{17}   17位数字
[\\dXx]   最后一位是数字或X/x
$         结尾
```

#tip[
  实际应用中还需要校验校验码和地区编码，仅靠正则不够。
]

==== URL

```text
^https?:\\/\\/[^\\s]+$

或者更严格的版本:
^https?:\\/\\/[a-zA-Z0-9.-]+(:\\d+)?(\\/[a-zA-Z0-9._~:\\/?#\[\]@!$&'()*+,;=-]*)?$
```

==== IPv4地址

```text
^(?:(?:25[0-5]|2[0-4]\\d|[01]?\\d\\d?)\\.){3}(?:25[0-5]|2[0-4]\\d|[01]?\\d\\d?)$

解释:
25[0-5]      250-255
2[0-4]\\d    200-249
[01]?\\d\\d? 0-199
\\.          点号
重复3次 + 最后一段
```

#caution[
  IP地址的正则很复杂，建议使用专门的验证函数。
]

=== 文本提取

==== HTML标签内容

```text
<([a-zA-Z][a-zA-Z0-9]*)[^>]*>(.*?)<\\/\\1>

捕获组1: 标签名
捕获组2: 标签内容
```

#note[
  解析HTML建议使用专门的解析器（如Jsoup、BeautifulSoup），正则只能处理简单场景。
]

==== 日志中的IP地址

```text
\\b(?:\\d{1,3}\\.){3}\\d{1,3}\\b
```

==== JSON值提取

```text
"key"\\s*:\\s*"([^"]*)"

捕获组1: key对应的值
```

=== 数据清洗

==== 去除HTML标签

```text
<[^>]+>

替换为空字符串
```

==== 去除多余空白

```text
\\s+

替换为单个空格
```

==== 提取电话号码

```text
\\b\\d{3}[-.]?\\d{3}[-.]?\\d{4}\\b

匹配: 123-456-7890, 123.456.7890, 1234567890
```

== 各语言中的使用

=== Python

```python
import re

# 编译正则
pattern = re.compile(r'\\d+')

# 查找所有匹配
matches = pattern.findall('abc123def456')
# ['123', '456']

# 搜索第一个匹配
match = pattern.search('abc123def')
if match:
    print(match.group())  # '123'

# 替换
result = pattern.sub('*', 'abc123def456')
# 'abc*def*'

# 分割
parts = re.split(r'\\d+', 'abc123def456ghi')
# ['abc', 'def', 'ghi']

# 命名分组
pattern = re.compile(r'(?P<year>\\d{4})-(?P<month>\\d{2})-(?P<day>\\d{2})')
match = pattern.match('2024-01-15')
print(match.group('year'))   # '2024'
print(match.group('month'))  # '01'
```

#tip[
  Python中使用原始字符串 `r'...'` 可以避免反斜杠转义问题。
]

=== JavaScript

```javascript
// 创建正则
const pattern = /\\d+/g;

// 测试
pattern.test('abc123');  // true

// 匹配
'abc123def456'.match(/\\d+/g);  // ['123', '456']

// 搜索
const match = /\\d+/.exec('abc123def');
console.log(match[0]);  // '123'

// 替换
'abc123def456'.replace(/\\d+/g, '*');  // 'abc*def*'

// 分割
'abc123def456'.split(/\\d+/);  // ['abc', 'def', '']

// 命名分组（ES2018+）
const datePattern = /(?<year>\\d{4})-(?<month>\\d{2})-(?<day>\\d{2})/;
const match = datePattern.exec('2024-01-15');
console.log(match.groups.year);   // '2024'
```

=== Java

```java
import java.util.regex.*;

// 编译正则（推荐复用）
Pattern pattern = Pattern.compile("\\\\d+");

// 完全匹配
boolean match = Pattern.matches("\\\\d+", "123");  // true

// 查找
Matcher matcher = pattern.matcher("abc123def456");
while (matcher.find()) {
    System.out.println(matcher.group());  // 123, 456
}

// 替换
String result = "abc123def456".replaceAll("\\\\d+", "*");
// "abc*def*"

// 分割
String[] parts = "abc123def456".split("\\\\d+");
// ["abc", "def", ""]

// 命名分组
Pattern datePattern = Pattern.compile(
    "(?<year>\\\\d{4})-(?<month>\\\\d{2})-(?<day>\\\\d{2})"
);
Matcher dateMatcher = datePattern.matcher("2024-01-15");
if (dateMatcher.matches()) {
    System.out.println(dateMatcher.group("year"));   // "2024"
    System.out.println(dateMatcher.group("month"));  // "01"
}
```

#caution[
  Java中反斜杠需要两次转义：`\\\\d` 表示正则中的 `\\d`。
]

=== C\#

```csharp
using System.Text.RegularExpressions;

// 创建正则
var pattern = new Regex(@"\\d+");

// 匹配
var matches = pattern.Matches("abc123def456");
foreach (Match match in matches)
{
    Console.WriteLine(match.Value);  // 123, 456
}

// 替换
string result = Regex.Replace("abc123def456", @"\\d+", "*");
// "abc*def*"

// 命名分组
var datePattern = new Regex(@"(?<year>\\d{4})-(?<month>\\d{2})-(?<day>\\d{2})");
var match = datePattern.Match("2024-01-15");
Console.WriteLine(match.Groups["year"].Value);   // "2024"
```

#tip[
  C\#中使用逐字字符串 `@"..."` 可以避免反斜杠转义。
]

== 性能优化

=== 预编译正则

```python
# 错误：每次循环都编译
for text in texts:
    re.match(r'\\d+', text)  # 慢！

# 正确：预编译
pattern = re.compile(r'\\d+')
for text in texts:
    pattern.match(text)  # 快！
```

==== 避免灾难性回溯

*问题示例*：

```text
(a+)+b

对 "aaaaaaaaaac" 会导致指数级回溯
```

*解决方案*：

```text
# 使用原子分组
(?>a+)b

# 或使用占有量词（PCRE）
a++b

# 或重写正则
a+b
```

#caution[
  灾难性回溯会导致正则匹配非常慢甚至卡死。测试时要包含失败的情况。
]

=== 简化正则

```text
# 冗余
[a-zA-Z0-9_]

# 简化
\\w
```

=== 使用具体字符集

```text
# 慢：过于宽泛
.*

# 快：具体明确
[^,]*
```

=== 锚定正则

```text
# 慢：需要尝试每个位置
\\d+

# 快：从开头匹配
^\\d+
```

== 调试技巧

=== 在线测试工具

- *Regex101*: https://regex101.com/ （支持多种语言）
- *RegExr*: https://regexr.com/
- *Debuggex*: https://www.debuggex.com/ （可视化）

=== 分步构建

1. 从简单的模式开始
2. 逐步添加复杂性
3. 每一步都测试
4. 使用注释说明各部分

```python
# 良好的实践
email_pattern = re.compile(r'''
    ^                   # 开头
    [A-Za-z0-9._%+-]+   # 用户名
    @                   # @符号
    [A-Za-z0-9.-]+      # 域名
    \\.                  # 点号
    [A-Za-z]{2,}        # 顶级域名
    $                   # 结尾
''', re.VERBOSE)
```

#tip[
  使用 `re.VERBOSE` 标志可以在Python中编写带注释的多行正则。
]

=== 单元测试

```python
import unittest

class TestEmailRegex(unittest.TestCase):
    def setUp(self):
        self.pattern = re.compile(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$')

    def test_valid_emails(self):
        valid = ['user@example.com', 'test.user@domain.org']
        for email in valid:
            self.assertTrue(self.pattern.match(email))

    def test_invalid_emails(self):
        invalid = ['@example.com', 'user@', 'user@.com']
        for email in invalid:
            self.assertFalse(self.pattern.match(email))

if __name__ == '__main__':
    unittest.main()
```

== 最佳实践总结

=== 何时使用正则

*适合*：

- 简单的模式匹配
- 数据验证
- 文本提取
- 批量替换

*不适合*：

- 解析HTML/XML（使用解析器）
- 解析JSON（使用JSON库）
- 复杂的嵌套结构
- 需要语法规则的场景

#note[
  正则不是万能的。对于结构化数据，使用专门的解析器更可靠。
]

=== 代码可读性

```python
# 不好：难以理解
pattern = re.compile(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)[A-Za-z\\d]{8,}$')

# 好：分解并注释
password_pattern = re.compile(r'''
    ^                   # 开头
    (?=.*[A-Z])         # 至少一个大写字母
    (?=.*[a-z])         # 至少一个小写字母
    (?=.*\\d)           # 至少一个数字
    [A-Za-z\\d]{8,}     # 至少8个字符
    $                   # 结尾
''', re.VERBOSE)
```

=== 性能考虑

- 预编译正则并复用
- 避免嵌套量词
- 使用具体字符集
- 适当使用锚点
- 测试边界情况

=== 跨平台兼容性

- 注意不同语言的转义规则
- 测试不同引擎的行为差异
- 使用标准特性，避免引擎特有功能

#fancy-divider

本章完
