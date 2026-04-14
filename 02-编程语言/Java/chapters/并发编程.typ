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
  (
    "TIMED_WAITING",
    "TIMED_WAITING",
    "Timed Waiting",
    "限期等待（`sleep(ms)`、`wait(ms)`、`join(ms)`、`LockSupport.parkNanos()`）",
  ),
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

在实际应用中，线程之间需要协作完成任务，而线程池则是管理线程资源的核心机制。本章深入探讨线程通信、线程池原理和JUC工具类。

#note[
  线程池的核心理念是*资源复用*和*任务解耦*，避免频繁创建销毁线程的开销，提高系统性能和稳定性。
]

== 线程通信

线程通信是多线程协作的基础，Java提供了多种机制。

=== wait/notify机制

基于Object类的wait()和notify()方法实现线程间通信。

==== 基本原理

```java
public class WaitNotifyExample {
    private final Object lock = new Object();
    private boolean condition = false;

    public void waitForCondition() throws InterruptedException {
        synchronized (lock) {
            while (!condition) {  // 必须用while，不能用if
                System.out.println(Thread.currentThread().getName() + " waiting...");
                lock.wait();  // 释放锁，进入等待队列
            }
            System.out.println(Thread.currentThread().getName() + " notified!");
        }
    }

    public void setCondition() {
        synchronized (lock) {
            condition = true;
            lock.notify();  // 唤醒一个等待线程
            // lock.notifyAll();  // 唤醒所有等待线程
        }
    }
}
```

*关键点*：

1. *必须在synchronized块中调用*
2. *使用while循环检查条件*（防止虚假唤醒）
3. *wait()释放锁*，其他线程可以获取锁
4. *notify()不立即释放锁*，要等synchronized块执行完

#caution[
  永远使用while循环而不是if来检查条件，因为存在虚假唤醒（Spurious Wakeup）的可能。
]

==== 生产者-消费者模型

```java
public class ProducerConsumer {
    private final Queue<Integer> buffer = new LinkedList<>();
    private final int capacity = 10;

    public void produce() throws InterruptedException {
        int value = 0;
        while (true) {
            synchronized (this) {
                // 缓冲区满，等待
                while (buffer.size() == capacity) {
                    System.out.println("Buffer full, producer waiting...");
                    wait();
                }

                // 生产数据
                buffer.add(value);
                System.out.println("Produced: " + value);
                value++;

                // 通知消费者
                notifyAll();
            }

            Thread.sleep(100);  // 模拟生产时间
        }
    }

    public void consume() throws InterruptedException {
        while (true) {
            synchronized (this) {
                // 缓冲区空，等待
                while (buffer.isEmpty()) {
                    System.out.println("Buffer empty, consumer waiting...");
                    wait();
                }

                // 消费数据
                int value = buffer.poll();
                System.out.println("Consumed: " + value);

                // 通知生产者
                notifyAll();
            }

            Thread.sleep(150);  // 模拟消费时间
        }
    }
}
```

#tip[
  生产者-消费者模式是经典的并发模式，实现了生产和消费的解耦。
]

=== Condition接口

Condition提供了更灵活的线程等待/通知机制。

==== 基本用法

```java
import java.util.concurrent.locks.*;

public class ConditionExample {
    private final ReentrantLock lock = new ReentrantLock();
    private final Condition notFull = lock.newCondition();
    private final Condition notEmpty = lock.newCondition();
    private final Queue<Integer> buffer = new LinkedList<>();
    private final int capacity = 10;

    public void produce(int value) throws InterruptedException {
        lock.lock();
        try {
            while (buffer.size() == capacity) {
                System.out.println("Buffer full, waiting...");
                notFull.await();  // 在notFull条件上等待
            }

            buffer.add(value);
            System.out.println("Produced: " + value);

            notEmpty.signal();  // 通知notEmpty条件的等待线程
        } finally {
            lock.unlock();
        }
    }

    public int consume() throws InterruptedException {
        lock.lock();
        try {
            while (buffer.isEmpty()) {
                System.out.println("Buffer empty, waiting...");
                notEmpty.await();  // 在notEmpty条件上等待
            }

            int value = buffer.poll();
            System.out.println("Consumed: " + value);

            notFull.signal();  // 通知notFull条件的等待线程
            return value;
        } finally {
            lock.unlock();
        }
    }
}
```

*优势*：

- 可以有多个条件变量
- 可以精确唤醒特定条件的线程
- 支持中断和超时

==== 多条件示例

```java
public class BoundedBuffer {
    private final ReentrantLock lock = new ReentrantLock();
    private final Condition notFull = lock.newCondition();
    private final Condition notEmpty = lock.newCondition();
    private final Object[] items = new Object[100];
    private int count, putIndex, takeIndex;

    public void put(Object x) throws InterruptedException {
        lock.lock();
        try {
            while (count == items.length)
                notFull.await();

            items[putIndex] = x;
            putIndex = (putIndex + 1) % items.length;
            ++count;

            notEmpty.signal();  // 只唤醒消费者
        } finally {
            lock.unlock();
        }
    }

    public Object take() throws InterruptedException {
        lock.lock();
        try {
            while (count == 0)
                notEmpty.await();

            Object x = items[takeIndex];
            takeIndex = (takeIndex + 1) % items.length;
            --count;

            notFull.signal();  // 只唤醒生产者
            return x;
        } finally {
            lock.unlock();
        }
    }
}
```

#note[
  Condition比wait/notify更灵活，适合复杂的线程协作场景。
]

=== BlockingQueue

BlockingQueue是线程安全的队列，内置阻塞功能。

==== 常用实现

#tex-table(
  ("实现类", "特点", "适用场景"),
  ("ArrayBlockingQueue", "有界，数组实现", "已知容量上限"),
  ("LinkedBlockingQueue", "可选有界，链表实现", "吞吐量要求高"),
  ("PriorityBlockingQueue", "无界，优先级队列", "需要优先级排序"),
  ("DelayQueue", "无界，延迟队列", "定时任务"),
  ("SynchronousQueue", "容量为0，直接传递", "线程池"),
)

==== 使用示例

```java
import java.util.concurrent.*;

public class BlockingQueueExample {
    private final BlockingQueue<Integer> queue = new ArrayBlockingQueue<>(10);

    public void produce() throws InterruptedException {
        int value = 0;
        while (true) {
            queue.put(value);  // 队列满时阻塞
            System.out.println("Produced: " + value++);
            Thread.sleep(100);
        }
    }

    public void consume() throws InterruptedException {
        while (true) {
            Integer value = queue.take();  // 队列空时阻塞
            System.out.println("Consumed: " + value);
            Thread.sleep(150);
        }
    }
}
```

*阻塞方法*：

- `put()`: 队列满时阻塞
- `take()`: 队列空时阻塞
- `offer(e, time, unit)`: 超时阻塞
- `poll(time, unit)`: 超时阻塞

#tip[
  BlockingQueue是实现生产者-消费者模式的最简单方式，推荐优先使用。
]

== 线程池

线程池是管理和复用线程的框架，避免频繁创建销毁线程的开销。

=== 为什么需要线程池

*问题*：

```java
// 不好的做法：每次请求都创建新线程
for (int i = 0; i < 1000; i++) {
    new Thread(() -> {
        // 处理任务
    }).start();
}
```

*缺点*：

- 频繁创建销毁线程，性能差
- 无法控制线程数量，可能导致OOM
- 缺乏统一管理，难以监控

*线程池的优势*：

- 降低资源消耗（复用线程）
- 提高响应速度（无需创建线程）
- 提高线程可管理性（统一调度）

=== ThreadPoolExecutor核心参数

```java
public ThreadPoolExecutor(
    int corePoolSize,        // 核心线程数
    int maximumPoolSize,     // 最大线程数
    long keepAliveTime,      // 空闲线程存活时间
    TimeUnit unit,           // 时间单位
    BlockingQueue<Runnable> workQueue,  // 工作队列
    ThreadFactory threadFactory,        // 线程工厂
    RejectedExecutionHandler handler    // 拒绝策略
)
```

==== 参数详解

===== corePoolSize（核心线程数）

- 线程池中保持的最小线程数
- 即使空闲也不会被回收（除非allowCoreThreadTimeOut）
- 新任务到达时，如果当前线程数 < corePoolSize，创建新线程

===== maximumPoolSize（最大线程数）

- 线程池中允许的最大线程数
- 当队列满且当前线程数 < maximumPoolSize时，创建非核心线程

===== keepAliveTime（空闲线程存活时间）

- 非核心线程的空闲超时时间
- 超过这个时间的空闲非核心线程会被回收

===== workQueue（工作队列）

存储待执行任务的队列：

#tex-table(
  ("队列类型", "特点", "风险"),
  ("ArrayBlockingQueue", "有界队列", "可能触发拒绝策略"),
  ("LinkedBlockingQueue", "无界队列（默认Integer.MAX_VALUE）", "可能OOM"),
  ("SynchronousQueue", "不存储，直接传递", "需要较大的maximumPoolSize"),
  ("PriorityBlockingQueue", "优先级队列", "可能OOM"),
)

===== threadFactory（线程工厂）

用于创建线程，可以自定义线程名称、优先级等：

```java
ThreadFactory factory = new ThreadFactory() {
    private final AtomicInteger count = new AtomicInteger(1);

    @Override
    public Thread newThread(Runnable r) {
        Thread thread = new Thread(r);
        thread.setName("my-pool-" + count.getAndIncrement());
        thread.setDaemon(false);
        return thread;
    }
};
```

===== handler（拒绝策略）

当队列满且达到最大线程数时的处理策略：

#tex-table(
  ("策略", "行为", "适用场景"),
  ("AbortPolicy", "抛出RejectedExecutionException", "默认，重要任务"),
  ("CallerRunsPolicy", "由调用线程执行", "不允许丢失任务"),
  ("DiscardPolicy", "静默丢弃", "允许丢失"),
  ("DiscardOldestPolicy", "丢弃最老的任务", "允许丢失旧任务"),
)

=== 线程池工作流程

```
新任务提交
    ↓
当前线程数 < corePoolSize？
    ├→ 是：创建核心线程执行
    └→ 否：↓
         ↓
工作队列已满？
    ├→ 否：加入工作队列等待
    └→ 是：↓
         ↓
当前线程数 < maximumPoolSize？
    ├→ 是：创建非核心线程执行
    └→ 否：↓
         ↓
执行拒绝策略
```

#tip[
  理解这个流程是掌握线程池的关键！
]

=== 线程池的使用

==== 手动创建（推荐）

```java
ThreadPoolExecutor executor = new ThreadPoolExecutor(
    5,                      // 核心线程数
    10,                     // 最大线程数
    60L, TimeUnit.SECONDS,  // 空闲线程存活60秒
    new ArrayBlockingQueue<>(100),  // 有界队列
    new ThreadPoolExecutor.CallerRunsPolicy()  // 拒绝策略
);

// 提交任务
executor.submit(() -> {
    System.out.println("Task executed by: " + Thread.currentThread().getName());
});

// 关闭线程池
executor.shutdown();  // 优雅关闭
// executor.shutdownNow();  // 立即关闭
```

==== Executors工厂方法（不推荐）

```java
// 固定大小线程池
ExecutorService fixedPool = Executors.newFixedThreadPool(10);

// 单线程池
ExecutorService singlePool = Executors.newSingleThreadExecutor();

// 缓存线程池（无界，危险！）
ExecutorService cachedPool = Executors.newCachedThreadPool();

// 定时任务线程池
ScheduledExecutorService scheduledPool = Executors.newScheduledThreadPool(5);
```

#caution[
  《阿里巴巴Java开发手册》禁止使用Executors创建线程池，因为：
  - FixedThreadPool和SingleThreadPool：队列无界，可能OOM
  - CachedThreadPool：线程数无界，可能OOM
  - 应该手动创建ThreadPoolExecutor
]

=== 线程池监控

```java
ThreadPoolExecutor executor = new ThreadPoolExecutor(...);

// 监控指标
System.out.println("活跃线程数: " + executor.getActiveCount());
System.out.println("已完成任务数: " + executor.getCompletedTaskCount());
System.out.println("当前线程数: " + executor.getPoolSize());
System.out.println("核心线程数: " + executor.getCorePoolSize());
System.out.println("最大线程数: " + executor.getMaximumPoolSize());
System.out.println("队列大小: " + executor.getQueue().size());
```

=== 线程池最佳实践

==== 合理设置参数

*CPU密集型任务*：

```java
int corePoolSize = Runtime.getRuntime().availableProcessors() + 1;
```

*IO密集型任务*：

```java
int corePoolSize = Runtime.getRuntime().availableProcessors() * 2;
// 或
double corePoolSize = Runtime.getRuntime().availableProcessors() / (1 - 阻塞系数);
// 阻塞系数通常在0.8~0.9之间
```

==== 自定义线程名称

```java
ThreadFactory factory = new ThreadFactoryBuilder()
    .setNameFormat("order-pool-%d")
    .setDaemon(false)
    .build();

ThreadPoolExecutor executor = new ThreadPoolExecutor(
    5, 10, 60L, TimeUnit.SECONDS,
    new ArrayBlockingQueue<>(100),
    factory
);
```

#tip[
  自定义线程名称便于问题排查，特别是在生产环境中。
]

==== 优雅关闭

```java
public void shutdownGracefully(ThreadPoolExecutor executor) {
    executor.shutdown();  // 不再接受新任务
    try {
        if (!executor.awaitTermination(60, TimeUnit.SECONDS)) {
            executor.shutdownNow();  // 强制关闭
            if (!executor.awaitTermination(60, TimeUnit.SECONDS)) {
                System.err.println("线程池未能正常关闭");
            }
        }
    } catch (InterruptedException e) {
        executor.shutdownNow();
        Thread.currentThread().interrupt();
    }
}
```

==== 异常处理

```java
// submit方式的异常不会直接抛出
Future<?> future = executor.submit(() -> {
    throw new RuntimeException("Task failed");
});

try {
    future.get();  // 这里才会抛出异常
} catch (ExecutionException e) {
    e.getCause().printStackTrace();
}

// execute方式的异常需要通过UncaughtExceptionHandler处理
executor.setThreadFactory(r -> {
    Thread t = new Thread(r);
    t.setUncaughtExceptionHandler((thread, ex) -> {
        System.err.println("Thread " + thread.getName() + " failed: " + ex.getMessage());
    });
    return t;
});
```

== JUC工具类

java.util.concurrent包提供了丰富的并发工具类。

=== CountDownLatch

允许一个或多个线程等待其他线程完成操作。

```java
public class CountDownLatchExample {
    public static void main(String[] args) throws InterruptedException {
        int threadCount = 5;
        CountDownLatch latch = new CountDownLatch(threadCount);

        for (int i = 0; i < threadCount; i++) {
            new Thread(() -> {
                System.out.println(Thread.currentThread().getName() + " working...");
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                System.out.println(Thread.currentThread().getName() + " done");
                latch.countDown();  // 计数减1
            }, "Worker-" + i).start();
        }

        latch.await();  // 等待所有线程完成
        System.out.println("All workers completed!");
    }
}
```

*特点*：

- 计数器只能递减，不能重置
- 一次性使用
- 适合等待多个并行任务完成

=== CyclicBarrier

让一组线程互相等待，直到所有线程都到达某个屏障点。

```java
public class CyclicBarrierExample {
    public static void main(String[] args) {
        int threadCount = 3;
        CyclicBarrier barrier = new CyclicBarrier(threadCount, () -> {
            System.out.println("All threads reached barrier, proceeding...");
        });

        for (int i = 0; i < threadCount; i++) {
            new Thread(() -> {
                try {
                    System.out.println(Thread.currentThread().getName() + " preparing...");
                    Thread.sleep((long) (Math.random() * 3000));

                    System.out.println(Thread.currentThread().getName() + " waiting at barrier");
                    barrier.await();  // 等待其他线程

                    System.out.println(Thread.currentThread().getName() + " continuing...");
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }, "Thread-" + i).start();
        }
    }
}
```

*特点*：

- 可以重复使用（reset）
- 所有线程同时继续执行
- 适合分阶段并行计算

#note[
  CountDownLatch是一个线程等待其他线程，CyclicBarrier是一组线程互相等待。
]

=== Semaphore

控制同时访问某个资源的线程数量。

```java
public class SemaphoreExample {
    private final Semaphore semaphore = new Semaphore(3);  // 最多3个并发

    public void accessResource() {
        try {
            semaphore.acquire();  // 获取许可
            System.out.println(Thread.currentThread().getName() + " accessing resource");
            Thread.sleep(2000);
            System.out.println(Thread.currentThread().getName() + " releasing resource");
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
            semaphore.release();  // 释放许可
        }
    }
}
```

*应用场景*：

- 限流
- 控制数据库连接数
- 控制并发访问数

=== CompletableFuture

异步编程的强大工具，支持链式调用和组合。

==== 基本用法

```java
import java.util.concurrent.*;

public class CompletableFutureExample {
    public static void main(String[] args) throws Exception {
        // 异步执行
        CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> {
            System.out.println("Executing in: " + Thread.currentThread().getName());
            return "Hello";
        });

        // 获取结果
        String result = future.get();
        System.out.println("Result: " + result);
    }
}
```

==== 链式调用

```java
CompletableFuture<String> future = CompletableFuture
    .supplyAsync(() -> "Hello")
    .thenApply(s -> s + " World")
    .thenApply(String::toUpperCase)
    .thenAccept(System.out::println);  // HELLO WORLD

future.join();  // 等待完成
```

==== 组合多个CompletableFuture

```java
CompletableFuture<String> future1 = CompletableFuture.supplyAsync(() -> "Hello");
CompletableFuture<String> future2 = CompletableFuture.supplyAsync(() -> "World");

// thenCombine: 两个都完成后执行
CompletableFuture<String> combined = future1.thenCombine(future2, (s1, s2) -> s1 + " " + s2);
System.out.println(combined.join());  // Hello World

// allOf: 所有完成后执行
CompletableFuture<Void> all = CompletableFuture.allOf(future1, future2);
all.join();

// anyOf: 任意一个完成后执行
CompletableFuture<Object> any = CompletableFuture.anyOf(future1, future2);
System.out.println(any.join());
```

==== 异常处理

```java
CompletableFuture<String> future = CompletableFuture
    .supplyAsync(() -> {
        if (Math.random() > 0.5) {
            throw new RuntimeException("Error!");
        }
        return "Success";
    })
    .exceptionally(ex -> {
        System.err.println("Exception: " + ex.getMessage());
        return "Fallback";
    })
    .handle((result, ex) -> {
        if (ex != null) {
            return "Handled: " + ex.getMessage();
        }
        return result;
    });

System.out.println(future.join());
```

#tip[
  CompletableFuture是现代Java异步编程的首选，比传统的Future更强大和灵活。
]

=== Exchanger

用于两个线程之间交换数据。

```java
public class ExchangerExample {
    public static void main(String[] args) {
        Exchanger<String> exchanger = new Exchanger<>();

        new Thread(() -> {
            try {
                String data = "Data from Thread 1";
                System.out.println("Thread 1 sending: " + data);
                String received = exchanger.exchange(data);
                System.out.println("Thread 1 received: " + received);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }).start();

        new Thread(() -> {
            try {
                String data = "Data from Thread 2";
                System.out.println("Thread 2 sending: " + data);
                String received = exchanger.exchange(data);
                System.out.println("Thread 2 received: " + received);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }).start();
    }
}
```

== 总结

并发协作与线程池的核心要点：

- *线程通信*：wait/notify、Condition、BlockingQueue
- *线程池*：ThreadPoolExecutor七大参数、工作流程、最佳实践
- *JUC工具*：
  - CountDownLatch：一个等待多个
  - CyclicBarrier：多个互相等待
  - Semaphore：控制并发数
  - CompletableFuture：异步编程
  - Exchanger：线程间交换数据

#fancy-divider

下一章将探讨*并发容器与原子类*的使用。


= Kotlin 协程基础

Kotlin协程是一种轻量级的并发框架，通过挂起和恢复机制实现高效的异步编程。它是Kotlin语言的核心特性之一。

#note[
  协程的核心理念是*用户态线程*，由程序员控制调度，而非操作系统，因此更加轻量和高效。
]

== 协程模型

=== 什么是协程

协程（Coroutine）是一种用户态的轻量级线程，可以在执行过程中暂停和恢复。

*特点*：

- *轻量级*：一个线程可以运行成千上万个协程
- *协作式*：协程主动让出执行权，而非被抢占
- *结构化*：有明确的生命周期和作用域

```kotlin
import kotlinx.coroutines.*

fun main() = runBlocking {
    // 启动一个协程
    launch {
        delay(1000L)  // 非阻塞延迟
        println("World!")
    }
    println("Hello,")
}
// 输出:
// Hello,
// World!
```

=== 协程 vs 线程

#tex-table(
  ("特性", "线程", "协程"),
  ("创建开销", "高（MB级栈空间）", "低（KB级）"),
  ("切换成本", "高（内核态切换）", "低（用户态切换）"),
  ("数量限制", "几百到几千", "数万到数百万"),
  ("调度方式", "操作系统调度", "程序员控制"),
  ("阻塞", "阻塞线程", "挂起不阻塞线程"),
  ("内存占用", "~1MB/线程", "~几KB/协程"),
)

*示例对比*：

```kotlin
// 线程方式：创建10000个线程会导致OOM
for (i in 1..10000) {
    Thread {
        Thread.sleep(1000)
        println("Thread $i")
    }.start()
}

// 协程方式：轻松创建10000个协程
runBlocking {
    for (i in 1..10000) {
        launch {
            delay(1000)
            println("Coroutine $i")
        }
    }
}
```

#tip[
  协程不是替代线程，而是建立在线程之上的更高层抽象。
]

=== 协程的优势

1. *高性能*：
  - 轻量级，可以创建大量协程
  - 无锁设计，减少竞争

2. *易读性*：
  - 异步代码像同步代码一样书写
  - 避免回调地狱

3. *结构化并发*：
  - 自动管理生命周期
  - 异常传播清晰
  - 资源自动清理

4. *灵活性*：
  - 可以轻松切换执行上下文
  - 支持取消和超时

=== 结构化并发

结构化并发确保协程的生命周期清晰可控。

*原则*：

1. 子协程的作用域不能超过父协程
2. 父协程等待所有子协程完成
3. 异常向上传播

```kotlin
fun main() = runBlocking {
    // 父协程
    launch {
        // 子协程1
        launch {
            delay(1000)
            println("Child 1")
        }

        // 子协程2
        launch {
            delay(500)
            println("Child 2")
        }

        println("Parent waiting...")
    }  // 父协程会等待所有子协程完成

    println("All done")
}
```

*优势*：

- 防止协程泄漏
- 自动取消子协程
- 清晰的错误处理

#caution[
  避免使用GlobalScope，它破坏了结构化并发原则。
]

== 核心概念

=== 挂起函数（Suspend Function）

挂起函数是可以暂停执行而不阻塞线程的函数。

==== 定义挂起函数

```kotlin
import kotlinx.coroutines.*

// 普通函数不能调用挂起函数
// suspend函数可以调用其他suspend函数
suspend fun fetchData(): String {
    delay(1000)  // 挂起点，不阻塞线程
    return "Data"
}

suspend fun processData(): String {
    val data = fetchData()  // 调用挂起函数
    return data.uppercase()
}
```

*关键字*：`suspend`

*特点*：

- 只能在协程或其他挂起函数中调用
- 可以在不阻塞线程的情况下暂停执行
- 编译器将其转换为状态机

==== 挂起函数的原理

```text
普通函数调用：
调用 → 执行 → 返回

挂起函数调用：
调用 → 执行 → 挂起（保存状态） → 恢复（从保存点继续） → 返回
```

*编译器转换*：

```kotlin
// 原始代码
suspend fun example() {
    println("Before")
    delay(1000)  // 挂起点
    println("After")
}

// 编译器生成的伪代码（简化）
fun example(continuation: Continuation) {
    when (continuation.label) {
        0 -> {
            println("Before")
            continuation.label = 1
            delay(1000, continuation)  // 传入continuation
            return
        }
        1 -> {
            println("After")
            continuation.resume(Unit)
        }
    }
}
```

#note[
  挂起函数不是新的线程，而是在现有线程上通过状态机实现的协作式多任务。
]

=== 协程构建器

==== launch

启动一个新协程，返回Job对象。

```kotlin
fun main() = runBlocking {
    val job = launch {
        delay(1000)
        println("Launch coroutine")
    }

    println("Main continues...")
    job.join()  // 等待协程完成
    println("Done")
}
```

*特点*：

- 返回 `Job`
- 用于“发射并忘记”的场景
- 异常会传递给父协程

==== async

启动一个新协程，返回Deferred对象（继承自Job）。

```kotlin
fun main() = runBlocking {
    val deferred = async {
        delay(1000)
        "Result"
    }

    println("Main continues...")
    val result = deferred.await()  // 获取结果
    println("Result: $result")
}
```

*特点*：

- 返回 `Deferred<T>`
- 用于需要返回值的场景
- `await()` 获取结果

==== 对比

```kotlin
// launch：不需要返回值
launch {
    doSomeWork()
}

// async：需要返回值
val result = async {
    computeSomething()
}.await()
```

#tip[
  如果不需要返回值，使用launch；如果需要返回值，使用async。
]

=== 协程作用域（CoroutineScope）

作用域定义了协程的生命周期和上下文。

==== 常用作用域

===== runBlocking

阻塞当前线程，直到所有协程完成。

```kotlin
fun main() = runBlocking {
    // 这个协程会阻塞main线程
    launch {
        delay(1000)
        println("Done")
    }
}
```

*用途*：

- 测试代码
- main函数入口
- 桥接阻塞和非阻塞代码

===== coroutineScope

创建一个新作用域，等待所有子协程完成。

```kotlin
suspend fun doConcurrentWork() = coroutineScope {
    val task1 = async { fetchData1() }
    val task2 = async { fetchData2() }

    // 并行执行
    val result1 = task1.await()
    val result2 = task2.await()

    process(result1, result2)
}  // 这里会等待所有子协程完成
```

*特点*：

- 挂起函数
- 等待所有子协程
- 异常传播

===== GlobalScope（不推荐）

全局作用域，生命周期与应用相同。

```kotlin
// 不推荐！
GlobalScope.launch {
    delay(1000)
    println("This might leak!")
}
```

#caution[
  避免使用GlobalScope，它会导致协程泄漏，破坏结构化并发。
]

===== MainScope / lifecycleScope（Android）

```kotlin
// Android ViewModel
class MyViewModel : ViewModel() {
    val viewModelScope = viewModelScope  // 自动绑定ViewModel生命周期

    fun loadData() {
        viewModelScope.launch {
            // ViewModel销毁时自动取消
        }
    }
}

// Android Activity/Fragment
class MyActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        lifecycleScope.launch {
            // Activity销毁时自动取消
        }
    }
}
```

==== 自定义作用域

```kotlin
class MyClass {
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Default)

    fun doWork() {
        scope.launch {
            // 工作
        }
    }

    fun cleanup() {
        scope.cancel()  // 取消所有协程
    }
}
```

=== 取消与超时

==== 协程取消

```kotlin
fun main() = runBlocking {
    val job = launch {
        repeat(1000) { i ->
            println("Working... $i")
            delay(100)
        }
    }

    delay(250)
    println("Cancelling...")
    job.cancel()  // 取消协程
    job.join()    // 等待取消完成
    println("Cancelled!")
}
```

*取消是协作式的*：

```kotlin
val job = launch {
    while (isActive) {  // 检查是否被取消
        // 做工作
        if (isCancelled) break
    }
}
```

*不可取消的操作*：

```kotlin
val job = launch {
    try {
        // 这段代码不会被中断
        doCriticalWork()
    } finally {
        // 清理资源（即使被取消也会执行）
        cleanup()
    }
}
job.cancel()
```

#tip[
  使用 `withContext(NonCancellable)` 来执行不可取消的操作。
]

==== 超时处理

```kotlin
fun main() = runBlocking {
    try {
        withTimeout(1000) {
            repeat(1000) { i ->
                println("Working... $i")
                delay(200)
            }
        }
    } catch (e: TimeoutCancellationException) {
        println("Timed out!")
    }
}
```

*不抛出异常的版本*：

```kotlin
val result = withTimeoutOrNull(1000) {
    // 长时间运行的操作
    delay(2000)
    "Result"
}

if (result == null) {
    println("Timed out")
} else {
    println("Result: $result")
}
```

== 协程上下文与调度器

协程上下文定义了协程的执行环境。

=== 协程上下文组成

```kotlin
CoroutineContext = Job + CoroutineDispatcher + CoroutineName + ...
```

*主要元素*：

#tex-table(
  ("元素", "作用", "示例"),
  ("Job", "生命周期管理", "cancel(), join()"),
  ("Dispatcher", "线程调度", "Dispatchers.IO"),
  ("CoroutineName", "调试名称", "CoroutineName(\"MyCoroutine\")"),
  ("ExceptionHandler", "异常处理", "CoroutineExceptionHandler"),
)

=== 调度器（Dispatcher）

调度器决定协程在哪个线程上执行。

==== 主要调度器

===== Dispatchers.Default

*用途*：CPU密集型任务

*线程池*：大小等于CPU核心数

```kotlin
launch(Dispatchers.Default) {
    // CPU密集型计算
    val result = heavyComputation()
}
```

===== Dispatchers.IO

*用途*：IO密集型任务（网络、文件、数据库）

*线程池*：默认64个线程或CPU核心数（取较大值）

```kotlin
launch(Dispatchers.IO) {
    // IO操作
    val data = readFile()
    val response = httpClient.get(url)
}
```

===== Dispatchers.Main

*用途*：Android主线程（UI更新）

*依赖*：需要添加 `kotlinx-coroutines-android`

```kotlin
// Android
launch(Dispatchers.Main) {
    // 更新UI
    textView.text = "Updated"
}
```

===== Dispatchers.Unconfined

*用途*：不限制线程，在当前线程开始，在恢复的线程继续

```kotlin
launch(Dispatchers.Unconfined) {
    println("Start: ${Thread.currentThread().name}")
    delay(100)
    println("After delay: ${Thread.currentThread().name}")  // 可能不同线程
}
```

#caution[
  Dispatchers.Unconfined主要用于测试，生产环境慎用。
]

==== 切换调度器

```kotlin
fun main() = runBlocking {
    println("Main: ${Thread.currentThread().name}")

    withContext(Dispatchers.Default) {
        println("Default: ${Thread.currentThread().name}")

        withContext(Dispatchers.IO) {
            println("IO: ${Thread.currentThread().name}")
        }

        println("Back to Default: ${Thread.currentThread().name}")
    }

    println("Back to Main: ${Thread.currentThread().name}")
}
```

*最佳实践*：

```kotlin
suspend fun loadAndProcessData() {
    // IO线程加载数据
    val data = withContext(Dispatchers.IO) {
        database.query()
    }

    // Default线程处理数据
    val result = withContext(Dispatchers.Default) {
        data.map { transform(it) }
    }

    // 返回结果（在调用者的上下文中）
    return result
}
```

#tip[
  遵循“在哪里使用，就在哪里切换”的原则，让调用者决定最终的执行上下文。
]

=== 上下文继承

子协程继承父协程的上下文。

```kotlin
fun main() = runBlocking(CoroutineName("Parent")) {
    println("Parent: ${coroutineContext[CoroutineName]}")

    launch {  // 继承父的CoroutineName
        println("Child: ${coroutineContext[CoroutineName]}")
    }

    launch(CoroutineName("CustomChild")) {  // 覆盖CoroutineName
        println("Custom Child: ${coroutineContext[CoroutineName]}")
    }
}
```

=== 自定义上下文元素

```kotlin
// 自定义日志上下文
data class LoggerContext(val tag: String) : CoroutineContext.Element {
    companion object Key : CoroutineContext.Key<LoggerContext>
}

fun main() = runBlocking {
    val scope = CoroutineScope(LoggerContext("MyTag") + Dispatchers.Default)

    scope.launch {
        val logger = coroutineContext[LoggerContext]
        println("[${logger?.tag}] Working...")
    }
}
```

=== 异常处理

==== CoroutineExceptionHandler

```kotlin
val handler = CoroutineExceptionHandler { context, exception ->
    println("Caught exception: ${exception.message}")
}

val scope = CoroutineScope(Job() + handler)

scope.launch {
    throw RuntimeException("Error!")
}
```

*注意*：

- 只对顶层协程有效
- launch的异常会传递给父协程
- async的异常在await()时抛出

==== SupervisorJob

允许子协程失败而不影响其他子协程。

```kotlin
val scope = CoroutineScope(SupervisorJob())

scope.launch {
    throw RuntimeException("This won't cancel siblings")
}

scope.launch {
    delay(1000)
    println("This will still execute")
}
```

*vs Job*：

#tex-table(
  ("特性", "Job", "SupervisorJob"),
  ("子协程失败", "取消所有子协程", "只取消失败的"),
  ("异常传播", "向上传播", "需要Handler捕获"),
  ("适用场景", "强关联任务", "独立任务"),
)

== 实战示例

=== 并行数据加载

```kotlin
suspend fun loadDashboardData(): DashboardData {
    return coroutineScope {
        // 并行加载
        val userDeferred = async { fetchUserProfile() }
        val postsDeferred = async { fetchUserPosts() }
        val statsDeferred = async { fetchUserStats() }

        // 等待所有结果
        DashboardData(
            user = userDeferred.await(),
            posts = postsDeferred.await(),
            stats = statsDeferred.await()
        )
    }
}
```

=== 重试机制

```kotlin
suspend fun <T> retry(
    times: Int = 3,
    initialDelay: Long = 100,
    maxDelay: Long = 1000,
    factor: Double = 2.0,
    block: suspend () -> T
): T {
    var currentDelay = initialDelay
    repeat(times - 1) {
        try {
            return block()
        } catch (e: Exception) {
            println("Retry ${it + 1}: ${e.message}")
        }
        delay(currentDelay)
        currentDelay = (currentDelay * factor).toLong().coerceAtMost(maxDelay)
    }
    return block()  // 最后一次尝试
}

// 使用
val data = retry {
    apiService.fetchData()
}
```

=== Flow集成

```kotlin
import kotlinx.coroutines.flow.*

fun observeData(): Flow<String> = flow {
    for (i in 1..10) {
        delay(100)
        emit("Data $i")
    }
}

fun main() = runBlocking {
    observeData()
        .filter { it.contains("5") }
        .map { it.uppercase() }
        .collect { println(it) }
}
```

== 总结

Kotlin协程的核心要点：

- *协程模型*：轻量级、用户态、结构化并发
- *挂起函数*：suspend关键字，状态机实现
- *构建器*：launch（无返回值）、async（有返回值）
- *作用域*：runBlocking、coroutineScope、避免GlobalScope
- *取消与超时*：协作式取消、withTimeout
- *调度器*：Default（CPU）、IO（IO）、Main（UI）
- *上下文*：Job + Dispatcher + 其他元素
- *异常处理*：CoroutineExceptionHandler、SupervisorJob

#fancy-divider

下一章将探讨*并发容器与原子类*的使用。


= 协程进阶与异步流

= 并发诊断与综合实战
