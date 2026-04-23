#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= BIO: 阻塞式 IO

BIO（Blocking I/O）是 Java 最基础的网络编程模型，采用同步阻塞方式，每个连接需要一个独立线程处理。

== Socket 编程

=== ServerSocket 服务端

```java
import java.net.ServerSocket;
import java.net.Socket;
import java.io.*;

public class BioServer {
    public static void main(String[] args) throws IOException {
        // 创建服务端 Socket，监听 8080 端口
        ServerSocket serverSocket = new ServerSocket(8080);
        System.out.println("Server started on port 8080");

        while (true) {
            // accept() 阻塞等待客户端连接
            Socket clientSocket = serverSocket.accept();
            System.out.println("Client connected: " +
                clientSocket.getInetAddress());

            // 处理客户端请求
            handleClient(clientSocket);
        }
    }

    private static void handleClient(Socket socket) throws IOException {
        try (
            BufferedReader in = new BufferedReader(
                new InputStreamReader(socket.getInputStream())
            );
            PrintWriter out = new PrintWriter(
                socket.getOutputStream(), true
            )
        ) {
            String message = in.readLine();
            System.out.println("Received: " + message);

            // 响应客户端
            out.println("Echo: " + message);
        } finally {
            socket.close();
        }
    }
}
```

*关键 API*：

#tex-table(
  ("方法", "说明", "阻塞点"),
  ("accept()", "接受客户端连接", "等待新连接"),
  ("getInputStream()", "获取输入流", "读取数据时阻塞"),
  ("getOutputStream()", "获取输出流", "写入数据时阻塞"),
  ("close()", "关闭连接", "无"),
)

=== Socket 客户端

```java
import java.net.Socket;
import java.io.*;

public class BioClient {
    public static void main(String[] args) throws IOException {
        // 连接服务器
        Socket socket = new Socket("localhost", 8080);
        System.out.println("Connected to server");

        try (
            PrintWriter out = new PrintWriter(
                socket.getOutputStream(), true
            );
            BufferedReader in = new BufferedReader(
                new InputStreamReader(socket.getInputStream())
            )
        ) {
            // 发送消息
            out.println("Hello, Server!");

            // 接收响应
            String response = in.readLine();
            System.out.println("Response: " + response);
        } finally {
            socket.close();
        }
    }
}
```

=== 连接建立与关闭

==== TCP 三次握手（API 层面）

```java
// 客户端发起连接
Socket socket = new Socket("localhost", 8080);
// 此时完成三次握手，连接建立

// 服务端接受连接
Socket clientSocket = serverSocket.accept();
// 返回已建立的连接
```

#note[
  Java Socket API 封装了底层的 TCP 握手过程，开发者无需手动处理。
]

==== 优雅关闭

```java
// 半关闭：只关闭输出流，仍可读取
socket.shutdownOutput();

// 半关闭：只关闭输入流，仍可写入
socket.shutdownInput();

// 完全关闭
socket.close();

// 设置超时
socket.setSoTimeout(5000);  // 5秒超时
```

==== 配置选项

```java
Socket socket = new Socket();

// 禁用 Nagle 算法（减少延迟）
socket.setTcpNoDelay(true);

// 保持连接活跃
socket.setKeepAlive(true);

// 重用地址
socket.setReuseAddress(true);

// 发送缓冲区大小
socket.setSendBufferSize(8192);

// 接收缓冲区大小
socket.setReceiveBufferSize(8192);
```

== 多线程 BIO 服务器

单线程 BIO 服务器只能处理一个客户端，需要使用多线程支持并发。

=== 线程-per-connection 模型

```java
public class MultiThreadBioServer {
    public static void main(String[] args) throws IOException {
        ServerSocket serverSocket = new ServerSocket(8080);
        System.out.println("Multi-threaded server started");

        while (true) {
            Socket clientSocket = serverSocket.accept();

            // 为每个客户端创建新线程
            Thread thread = new Thread(() -> {
                try {
                    handleClient(clientSocket);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            });
            thread.start();
        }
    }

    private static void handleClient(Socket socket) throws IOException {
        // 处理逻辑
    }
}
```

#caution[
  线程-per-connection 模型在高并发下会创建大量线程，导致内存溢出和上下文切换开销过大。
]

=== 线程池模型（推荐）

```java
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class ThreadPoolBioServer {
    private static final int POOL_SIZE = 10;
    private static ExecutorService threadPool =
        Executors.newFixedThreadPool(POOL_SIZE);

    public static void main(String[] args) throws IOException {
        ServerSocket serverSocket = new ServerSocket(8080);
        System.out.println("Thread pool server started (pool size: " +
            POOL_SIZE + ")");

        while (true) {
            Socket clientSocket = serverSocket.accept();

            // 提交到线程池处理
            threadPool.submit(() -> {
                try {
                    handleClient(clientSocket);
                } catch (IOException e) {
                    e.printStackTrace();
                } finally {
                    try {
                        clientSocket.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            });
        }
    }

    private static void handleClient(Socket socket) throws IOException {
        try (
            BufferedReader in = new BufferedReader(
                new InputStreamReader(socket.getInputStream())
            );
            PrintWriter out = new PrintWriter(
                socket.getOutputStream(), true
            )
        ) {
            String message;
            while ((message = in.readLine()) != null) {
                System.out.println("Received: " + message);
                out.println("Echo: " + message);

                if ("bye".equalsIgnoreCase(message)) {
                    break;
                }
            }
        }
    }
}
```

*线程池优势*：

- 限制最大线程数，避免资源耗尽
- 复用线程，减少创建/销毁开销
- 更好的可控性和监控能力

=== 客户端并发测试

```java
import java.util.concurrent.CountDownLatch;

public class ConcurrentClientTest {
    public static void main(String[] args) throws InterruptedException {
        int clientCount = 100;
        CountDownLatch latch = new CountDownLatch(clientCount);

        for (int i = 0; i < clientCount; i++) {
            final int clientId = i;
            new Thread(() -> {
                try {
                    Socket socket = new Socket("localhost", 8080);

                    PrintWriter out = new PrintWriter(
                        socket.getOutputStream(), true
                    );
                    BufferedReader in = new BufferedReader(
                        new InputStreamReader(socket.getInputStream())
                    );

                    out.println("Hello from client " + clientId);
                    String response = in.readLine();
                    System.out.println("Client " + clientId + ": " + response);

                    socket.close();
                } catch (IOException e) {
                    e.printStackTrace();
                } finally {
                    latch.countDown();
                }
            }).start();
        }

        latch.await();  // 等待所有客户端完成
        System.out.println("All clients finished");
    }
}
```

== UDP 通信

UDP 是无连接的协议，使用 DatagramSocket 和 DatagramPacket。

=== UDP 服务端

```java
import java.net.DatagramSocket;
import java.net.DatagramPacket;

public class UdpServer {
    public static void main(String[] args) throws Exception {
        DatagramSocket socket = new DatagramSocket(8080);
        System.out.println("UDP server started");

        byte[] buffer = new byte[1024];

        while (true) {
            // 接收数据报
            DatagramPacket packet = new DatagramPacket(buffer, buffer.length);
            socket.receive(packet);  // 阻塞等待

            // 解析数据
            String message = new String(
                packet.getData(), 0, packet.getLength()
            );
            System.out.println("Received: " + message);

            // 构造响应
            String response = "Echo: " + message;
            byte[] responseData = response.getBytes();

            // 发送响应
            DatagramPacket responsePacket = new DatagramPacket(
                responseData,
                responseData.length,
                packet.getAddress(),
                packet.getPort()
            );
            socket.send(responsePacket);
        }
    }
}
```

=== UDP 客户端

```java
import java.net.DatagramSocket;
import java.net.DatagramPacket;
import java.net.InetAddress;

public class UdpClient {
    public static void main(String[] args) throws Exception {
        DatagramSocket socket = new DatagramSocket();

        // 发送数据
        String message = "Hello, UDP Server!";
        byte[] sendData = message.getBytes();

        DatagramPacket sendPacket = new DatagramPacket(
            sendData,
            sendData.length,
            InetAddress.getByName("localhost"),
            8080
        );
        socket.send(sendPacket);

        // 接收响应
        byte[] receiveData = new byte[1024];
        DatagramPacket receivePacket = new DatagramPacket(
            receiveData, receiveData.length
        );
        socket.receive(receivePacket);

        String response = new String(
            receivePacket.getData(), 0, receivePacket.getLength()
        );
        System.out.println("Response: " + response);

        socket.close();
    }
}
```

*UDP vs TCP*：

#tex-table(
  ("特性", "TCP", "UDP"),
  ("连接", "面向连接", "无连接"),
  ("可靠性", "可靠传输", "不可靠"),
  ("顺序", "保证顺序", "不保证"),
  ("速度", "较慢", "较快"),
  ("适用场景", "文件传输、Web", "视频、游戏、DNS"),
)

== Kotlin 简化实现

Kotlin 通过扩展函数和协程简化 BIO 编程。

=== 扩展函数封装

```kotlin
import java.net.ServerSocket
import java.net.Socket
import java.io.*

// 扩展函数：快速创建 BufferedReader
fun Socket.bufferedReader(): BufferedReader {
    return BufferedReader(InputStreamReader(getInputStream()))
}

// 扩展函数：快速创建 PrintWriter
fun Socket.printWriter(autoFlush: Boolean = true): PrintWriter {
    return PrintWriter(OutputStreamWriter(getOutputStream()), autoFlush)
}

// 扩展函数：安全关闭
fun Socket.closeQuietly() {
    try {
        close()
    } catch (e: IOException) {
        // 忽略
    }
}
```

=== Kotlin 服务端

```kotlin
fun main() {
    val serverSocket = ServerSocket(8080)
    println("Kotlin BIO server started")

    while (true) {
        val clientSocket = serverSocket.accept()

        Thread {
            try {
                handleClient(clientSocket)
            } catch (e: IOException) {
                e.printStackTrace()
            } finally {
                clientSocket.closeQuietly()
            }
        }.start()
    }
}

fun handleClient(socket: Socket) {
    socket.use {  // use 自动关闭
        val input = it.bufferedReader()
        val output = it.printWriter()

        val message = input.readLine()
        println("Received: $message")

        output.println("Echo: $message")
    }
}
```

#tip[
  Kotlin 的 `use` 函数等价于 Java 的 try-with-resources，自动管理资源。
]

=== 协程封装（实验性）

```kotlin
import kotlinx.coroutines.*

fun main() = runBlocking {
    val serverSocket = ServerSocket(8080)
    println("Coroutine-based BIO server started")

    while (isActive) {
        val clientSocket = serverSocket.accept()

        // 启动协程处理客户端
        launch(Dispatchers.IO) {
            try {
                handleClientAsync(clientSocket)
            } catch (e: Exception) {
                e.printStackTrace()
            } finally {
                clientSocket.closeQuietly()
            }
        }
    }
}

suspend fun handleClientAsync(socket: Socket) {
    withContext(Dispatchers.IO) {
        socket.use {
            val input = it.bufferedReader()
            val output = it.printWriter()

            val message = input.readLine()
            println("Received: $message")

            output.println("Echo: $message")
        }
    }
}
```

#note[
  虽然协程可以简化代码，但 BIO 本质仍是阻塞的，协程只是提供了更优雅的线程管理方式。对于高并发场景，应使用 NIO 或异步框架。
]

== BIO 性能瓶颈

=== 线程开销

```text
每个连接 = 1个线程

问题：
1. 线程创建开销：~1ms
2. 线程内存占用：~1MB/线程（栈空间）
3. 上下文切换：CPU 时间片轮转
4. 线程调度开销：操作系统内核态切换
```

*示例计算*：

- 1000 个并发连接 → 1000 个线程 → ~1GB 内存
- 10000 个并发连接 → 10000 个线程 → ~10GB 内存（OOM！）

=== 上下文切换

```java
// 当线程数 > CPU 核心数时，频繁上下文切换
Runtime.getRuntime().availableProcessors()  // 获取 CPU 核心数

// 假设 8 核 CPU，1000 个线程
// 每个线程平均只能获得 8ms/1000ms = 0.8% 的 CPU 时间
```

*上下文切换成本*：

- CPU 缓存失效（L1/L2/L3）
- TLB（页表缓存）刷新
- 寄存器保存/恢复
- 内核态/用户态切换

=== C10K 问题

**C10K Problem**：如何同时处理 10,000 个并发连接？

*BIO 的局限*：

```
BIO 模型：
- 10,000 连接 → 10,000 线程
- 内存消耗：~10 GB
- 上下文切换：极高
- 实际吞吐量：很低
```

*解决方案*：

1. **线程池**：限制最大线程数（但仍无法解决阻塞问题）
2. **NIO**：使用 Selector 多路复用，单线程处理多个连接
3. **AIO**：异步 IO，操作系统通知完成
4. **Netty**：基于 NIO 的高性能框架

=== 性能对比

#tex-table(
  ("模型", "并发能力", "内存占用", "复杂度"),
  ("BIO（单线程）", "1", "低", "低"),
  ("BIO（线程池）", "数百", "中", "中"),
  ("NIO", "数万", "低", "高"),
  ("AIO", "数万", "低", "高"),
  ("Netty", "数十万", "低", "中"),
)

#caution[
  BIO 适合低并发场景（< 1000 连接）。高并发场景应使用 NIO 或 Netty。
]

=== 监控与调优

```java
// 监控线程数
ThreadMXBean threadBean = ManagementFactory.getThreadMXBean();
System.out.println("Active threads: " + threadBean.getThreadCount());

// 监控连接数
serverSocket.getLocalPort();  // 监听端口

// JVM 参数调优
// -Xss256k  # 减小线程栈大小（默认 1MB）
// -XX:+UseG1GC  # 使用 G1 垃圾收集器
```

#fancy-divider

本章完
