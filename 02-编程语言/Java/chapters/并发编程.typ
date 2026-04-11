#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= 并发基础与问题模型

== 进程与线程、并发 vs 并行

=== 进程与线程的区别

进程和线程是操作系统调度的基本单位，但二者在资源和隔离性上存在本质差异：

- *进程 (Process)*：操作系统分配资源的基本单位，拥有独立的地址空间（堆、方法区）、文件句柄和信号量。进程间通信（IPC）需要借助管道、消息队列、共享内存等机制。
- *线程 (Thread)*：CPU 调度的最小单位，同一进程内的线程共享堆内存和方法区，但每个线程拥有独立的程序计数器（PC）、虚拟机栈和本地方法栈。

#tex-table(
  ("维度", "进程", "线程"),
  ("资源拥有", "独立地址空间", "共享进程资源"),
  ("通信方式", "IPC 机制", "直接读写共享变量"),
  ("开销", "创建/切换成本高", "创建/切换成本低"),
  ("隔离性", "进程间隔离", "线程间不隔离"),
)

=== 并发与并行的区分

- *并发 (Concurrency)*：逻辑上的同时发生。多个任务在同一个时间段内交替执行，通过 CPU 时间片轮转实现。单核 CPU 即可实现并发。
- *并行 (Parallelism)*：物理上的同时发生。多个任务在同一时刻真正同时执行，需要多核 CPU 支持。

#tip[
  并发关注的是任务调度的结构（设计层面），并行关注的是任务执行的物理方式（实现层面）。高并发通常需要良好的并行能力作为支撑。
]

=== 上下文切换的成本

当 CPU 在不同线程间切换时，需要保存当前线程的上下文（寄存器、程序计数器、栈指针等）并加载新线程的上下文。

#plain-table(
  ("成本类型", "说明"),
  ("CPU 时间", "每次切换需要数百到数千个 CPU 时钟周期"),
  ("缓存失效", "线程切换导致 L1/L2/L3 缓存命中率下降"),
  ("调度延迟", "内核调度器介入带来的延迟"),
)

#warning[
  线程并非越多越好。过多的线程会导致频繁的上下文切换，反而降低系统吞吐量。线程数的设置需要根据任务类型（CPU 密集型 vs IO 密集型）和硬件配置来权衡。
]

== Java 线程生命周期与操作

=== 线程状态流转

Java 线程的生命周期由 `java.lang.Thread.State` 枚举定义：

#tex-table(
  ("状态", "JVM 状态", "操作系统状态", "说明"),
  ("NEW", "NEW", "初始", "线程已创建但未调用 `start()`"),
  ("RUNNABLE", "RUNNABLE", "Ready / Running", "可运行状态，可能正在等待 CPU 或正在执行"),
  ("BLOCKED", "BLOCKED", "Blocked", "等待获取监视器锁（synchronized）"),
  ("WAITING", "WAITING", "Waiting", "无限期等待，需其他线程显式唤醒（`wait()`、`join()`、`LockSupport.park()`）"),
  ("TIMED_WAITING", "TIMED_WAITING", "Timed Waiting", "限期等待（`sleep(ms)`、`wait(ms)`、`join(ms)`、`LockSupport.parkNanos()`）"),
  ("TERMINATED", "TERMINATED", "Terminated", "线程执行完毕或抛出未捕获异常"),
)

=== 线程创建方式

Java 中创建线程有三种主流方式：

==== 继承 Thread 类

```java
public class MyThread extends Thread {
    @Override
    public void run() {
        System.out.println("Thread running: " + Thread.currentThread().getName());
    }
}

// 使用
new MyThread().start();
```

==== 实现 Runnable 接口（推荐）

```java
public class MyRunnable implements Runnable {
    @Override
    public void run() {
        System.out.println("Runnable running: " + Thread.currentThread().getName());
    }
}

// 使用
new Thread(new MyRunnable(), "MyThread").start();

// Lambda 简化（Java 8+）
new Thread(() -> System.out.println("Lambda thread"), "LambdaThread").start();
```

==== 实现 Callable 接口

```java
public class MyCallable implements Callable<Integer> {
    @Override
    public Integer call() throws Exception {
        return 42;
    }
}

// 使用（需配合 FutureTask）
FutureTask<Integer> task = new FutureTask<>(new MyCallable());
new Thread(task).start();
Integer result = task.get(); // 阻塞等待结果
```

#note[
  推荐使用 `Runnable` 接口，因为 Java 不支持多继承，继承 `Thread` 会导致该类无法继承其他类。而 `Runnable` 接口还可以配合线程池、CompletableFuture 等使用。
]

=== 守护线程

守护线程（Daemon Thread）为用户线程提供服务。当 JVM 中所有用户线程都结束时，守护线程会自动终止，JVM 也会随之退出。

```java
Thread daemonThread = new Thread(() -> {
    while (true) {
        // 后台任务
    }
});
daemonThread.setDaemon(true);
daemonThread.start();
```

#tip[
  典型的守护线程：Java 垃圾回收线程（GC）、定时调度线程等。设置守护线程时应在 `start()` 之前调用 `setDaemon(true)`。
]

=== 线程中断机制

中断是 Java 线程间协作的一种方式，而非强制终止。正确的中断处理流程：

```java
public class InterruptExample implements Runnable {
    @Override
    public void run() {
        while (!Thread.currentThread().isInterrupted()) {
            try {
                // 业务逻辑
                Thread.sleep(100);
            } catch (InterruptedException e) {
                // 收到中断信号后，应退出循环或向上传播
                Thread.currentThread().interrupt();
                break;
            }
        }
    }
}
```

#caution[
  不要在 `run()` 方法中捕获 `InterruptedException` 后什么都不做，这会清除中断状态。正确的做法是：1) 重新设置中断状态 `Thread.currentThread().interrupt()`；2) 退出循环或向上传播异常。
]

== 并发核心问题：三性模型

在应用层面，并发编程面临三个核心问题，理解它们是编写线程安全代码的基础。

=== 原子性 (Atomicity)

原子性指一个或多个操作在执行过程中不会被其他线程干扰，要么全部执行成功，要么全部不执行。

- *基本类型读写*：除 `long` 和 `double` 外的赋值操作是原子的。
- *复合操作*：`i++`、`count = count + 1` 等不是原子操作。

#algorithm[
  原子性问题的典型案例：
  - 线程 A 读取 count = 5
  - 线程 B 读取 count = 5
  - 线程 A 计算 5 + 1 = 6，写回
  - 线程 B 计算 5 + 1 = 6，写回
  - 期望结果：7，实际结果：6（丢失了一次更新）
]

=== 可见性 (Visibility)

可见性问题指一个线程对共享变量的修改，其他线程能否立即看到。

- *成因*：CPU 多级缓存导致。每个 CPU 核心有自己的 L1/L2/L3 缓存，线程可能读取到缓存中的旧值而非主存中的最新值。

#warning[
  即使在单核 CPU 上，也存在可见性问题（由于编译器和 CPU 的指令重排序）。多核 CPU 下问题更加突出。
]

=== 有序性 (Ordering)

程序代码的执行顺序应当与代码书写顺序一致，但由于编译器和处理器的优化，会发生指令重排序。

- *编译重排序*：编译器在不改变单线程语义的前提下调整指令顺序。
- *指令重排序*：处理器采用指令级并行技术（ILP）优化执行顺序。
- *内存重排序*：由于 CPU 缓存一致性协议导致看起来"顺序错乱"的内存访问。

#note[
  Java 内存模型 (JMM) 和 Happens-Before 规则的深入内容将在 Part 6: JVM 底层原理中详细讲解。本节聚焦于应用层的直观理解。
]

= 线程安全与同步机制

当多个线程同时访问同一可变状态时，如果不进行适当同步，就会产生线程安全问题。

== synchronized 与 Lock

=== synchronized 关键字

`synchronized` 是 Java 内置的同步机制，基于对象的监视器锁（Monitor Lock）实现。

==== 三种使用形式

```java
// 1. 修饰实例方法（锁定当前实例对象）
public synchronized void method() {
    // 同一时刻只有一个线程能执行此方法
}

// 2. 修饰静态方法（锁定当前类的 Class 对象）
public static synchronized void staticMethod() {
    // 同一时刻只有一个线程能执行此方法
}

// 3. 修饰代码块（锁定指定对象）
public void blockMethod() {
    synchronized (this) {
        // 锁定当前实例
    }
    synchronized (Lock.class) {
        // 锁定 Class 对象
    }
}
```

==== 锁的升级过程

#tex-table(
  ("阶段", "锁类型", "特点"),
  ("无锁", "偏向锁", "首次获取时记录线程 ID，后续进入同步块无需任何同步"),
  ("偏向锁", "轻量级锁", "有其他线程竞争时升级，CAS 自旋争取"),
  ("轻量级锁", "重量级锁", "自旋失败后升级，阻塞等待"),
)

#tip[
  偏向锁在 Java 15+ 已被废弃，默认关闭。日常开发中无需过度关注锁升级细节，理解 `synchronized` 的基本语义即可。
]

=== Lock 接口

`java.util.concurrent.locks.Lock` 提供了比 `synchronized` 更灵活的锁操作。

```java
Lock lock = new ReentrantLock();
lock.lock();
try {
    // 临界区代码
} finally {
    lock.unlock(); // 必须在 finally 中释放
}
```

==== ReentrantLock 特性

- *可重入*：同一线程可以多次获取同一把锁。
- *公平/非公平*：公平锁按等待顺序获取，非公平锁允许插队（默认）。
- *尝试获取锁*：`tryLock()`、`tryLock(timeout)`。
- *条件变量*：`newCondition()` 创建多个条件等待集。

```java
ReentrantLock lock = new ReentrantLock(true); // 公平锁
Condition condition = lock.newCondition();

// 等待条件
lock.lock();
try {
    while (!conditionMet) {
        condition.await(); // 释放锁并等待
    }
} finally {
    lock.unlock();
}

// 唤醒条件
lock.lock();
try {
    conditionMet = true;
    condition.signalAll();
} finally {
    lock.unlock();
}
```

#caution[
  使用 `Lock` 时必须确保在 `finally` 块中释放锁，否则如果临界区抛出异常，锁将永远无法释放，导致死锁。
]

=== volatile 关键字

`volatile` 是轻量级的同步机制，保证可见性和有序性，但不保证原子性。

```java
volatile boolean flag = false;

// 线程 A
flag = true;

// 线程 B
while (!flag) {
    // 能立即看到 flag 的变化
}
```

#note[
  `volatile` 的实现原理：写入时立即刷新到主存，读取时从主存获取。禁止指令重排序（通过内存屏障实现）。
]

=== Happens-Before 规则

Happens-Before 是 Java 内存模型（JMM）定义的操作偏序关系，是判断并发安全性的理论依据。

#tex-table(
  ("规则", "含义"),
  ("程序顺序规则", "同一线程中，前面的操作 happens-before 后面的操作"),
  ("监视器锁规则", "解锁 happens-before 后续的加锁"),
  ("volatile 变量规则", "写 happens-before 后续的读"),
  ("线程启动规则", "Thread.start() happens-before 被启动线程的任何操作"),
  ("线程终止规则", "线程的所有操作 happens-before 其他线程检测到该线程终止"),
  ("传递性", "A happens-before B，B happens-before C，则 A happens-before C"),
)

#warning[
  理解 Happens-Before 规则是分析并发代码正确性的关键。很多"看起来正确"的并发代码实际上存在问题，需要通过这些规则来验证。
]

== CAS 与原子类

=== CAS 原理

CAS（Compare-And-Swap）是一种无锁算法，通过硬件指令实现原子操作。

```java
// 伪代码
boolean compareAndSwap(Object obj, long offset, Object expected, Object newValue) {
    Object current = obj.get(offset); // 读取当前值
    if (current == expected) {
        obj.set(offset, newValue); // 如果相等则更新
        return true;
    }
    return false;
}
```

CAS 包含三个操作数：内存位置（V）、预期原值（A）和新值（B）。只有当 V 的值等于 A 时，才将 V 的值更新为 B。

==== CAS 的问题

- *ABA 问题*：值从 A 变为 B 再变回 A，CAS 无法检测。
- *循环开销*：自旋 CAS 如果长时间不成功，会占用 CPU。
- *只能保证一个变量*：无法对多个变量进行原子操作。

=== 原子类 (java.util.concurrent.atomic)

Java 提供了一系列原子类，基于 CAS 实现了高效的原子操作。

==== 原子整数

```java
AtomicInteger counter = new AtomicInteger(0);

// 原子递增
counter.incrementAndGet(); // ++i，返回新值
counter.getAndIncrement(); // i++，返回旧值
counter.addAndGet(5);     // i += 5

// CAS 更新
counter.compareAndSet(10, 20); // 如果当前值是 10，则更新为 20

// 原子更新
counter.updateAndGet(x -> x * 2); // 函数式更新
```

==== 原子引用

```java
AtomicReference<User> userRef = new AtomicReference<>(new User("Alice"));

// 原子替换
userRef.set(new User("Bob"));

// CAS 更新
userRef.compareAndSet(oldUser, newUser);

// 函数式更新
userRef.updateAndGet(u -> new User(u.name.toUpperCase()));
```

==== ABA 问题解决

```java
// 使用 AtomicStampedReference 添加版本号
AtomicStampedReference<Integer> ref = new AtomicStampedReference<>(100, 0);

int stamp = ref.getStamp();
ref.compareAndSet(100, 101, stamp, stamp + 1);

// 或使用 AtomicMarkableReference（布尔标记）
AtomicMarkableReference<Integer> ref2 = new AtomicMarkableReference<>(100, false);
```

#tip[
  原子类适合在低并发场景下替代锁，实现简单且性能优秀。但在高并发、竞争激烈的场景下，需要评估自旋带来的 CPU 消耗。
]

== 线程安全集合与并发容器

Java 并发包（java.util.concurrent）提供了多种线程安全的集合类，适用于不同场景。

=== ConcurrentHashMap

并发哈希表是使用最广泛的并发容器，采用分段锁（Java 7）或 CAS + synchronized（Java 8+）实现。

```java
ConcurrentHashMap<String, Integer> map = new ConcurrentHashMap<>();

// 原子操作
map.putIfAbsent("key", 1); // 仅当 key 不存在时插入
map.computeIfAbsent("key", k -> computeValue(k)); // 原子计算并插入
map.merge("key", 1, Integer::sum); // 原子合并

// 批量操作（弱一致性）
map.forEach(1, (k, v) -> System.out.println(k + ":" + v));
map.keys(); // 返回迭代器
```

#tex-table(
  ("操作", "普通 HashMap", "ConcurrentHashMap"),
  ("线程安全", "否", "是"),
  ("null 键/值", "允许", "不允许"),
  ("迭代器", "fail-fast", "弱一致性"),
  ("锁粒度", "全局锁", "分段锁/CAS"),
)

=== CopyOnWrite 系列

==== CopyOnWriteArrayList

写时复制机制：每次修改操作都会创建底层数组的新副本。

```java
CopyOnWriteArrayList<String> list = new CopyOnWriteArrayList<>();

list.add("element"); // 每次添加都复制整个数组
list.remove("element");
list.get(0); // 读操作无需加锁
```

#note[
  适合读多写少的场景（如监听器列表、配置信息）。写操作开销大，不适合频繁修改的数据。
]

==== CopyOnWriteArraySet

基于 `CopyOnWriteArrayList` 实现的线程安全 Set。

```java
CopyOnWriteArraySet<String> set = new CopyOnWriteArraySet<>();
```

=== 其他并发容器

#tex-table(
  ("容器", "特点", "适用场景"),
  ("ConcurrentLinkedQueue", "无界、非阻塞队列", "高并发队列操作"),
  ("LinkedBlockingQueue", "可选有界、阻塞队列", "生产者-消费者模式"),
  ("ArrayBlockingQueue", "有界、阻塞队列", "需要容量限制的场景"),
  ("ConcurrentSkipListMap", "线程安全跳表实现", "需要有序且线程安全的 Map"),
  ("ConcurrentSkipListSet", "线程安全跳表实现", "需要有序且线程安全的 Set"),
)

#warning[
  切勿在遍历并发容器时使用普通的 for-each 或迭代器进行修改。应当使用容器自身提供的原子操作（如 `forEach`、`computeIfAbsent` 等）。
]

= 并发协作与线程池

= Kotlin 协程基础

= 协程进阶与异步流

= 并发诊断与综合实战