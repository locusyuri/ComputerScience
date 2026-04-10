#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *


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
