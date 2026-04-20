#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= Web 开发核心

#note[
  Spring Boot 的 Web 开发基于 Spring MVC 框架，提供了构建 RESTful API 和传统 Web 应用的完整解决方案。
]

== HTTP 协议与 RESTful API 设计

本节介绍 HTTP 协议基础、Spring MVC 架构以及 RESTful API 设计规范。

=== HTTP 协议基础

HTTP（HyperText Transfer Protocol）是无状态的应用层协议。

==== HTTP 请求/响应模型

*请求结构*：

```
GET /api/users/1 HTTP/1.1
Host: example.com
Accept: application/json
Authorization: Bearer token123
```

*响应结构*：

```
HTTP/1.1 200 OK
Content-Type: application/json

{
  "id": 1,
  "name": "John Doe"
}
```

==== HTTP 方法语义

#tex-table(
  ("方法", "幂等", "安全", "用途"),
  ("GET", "✓", "✓", "查询资源"),
  ("POST", "✗", "✗", "创建资源"),
  ("PUT", "✓", "✗", "更新资源（全量）"),
  ("PATCH", "✗", "✗", "更新资源（部分）"),
  ("DELETE", "✓", "✗", "删除资源"),
)

*幂等性*：多次执行相同请求，结果一致

*安全性*：不修改服务器状态

==== HTTP 状态码

#tex-table(
  ("范围", "含义", "常用状态码"),
  ("1xx", "信息性", "100 Continue"),
  ("2xx", "成功", "200 OK, 201 Created, 204 No Content"),
  ("3xx", "重定向", "301 Moved, 302 Found, 304 Not Modified"),
  ("4xx", "客户端错误", "400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found"),
  ("5xx", "服务器错误", "500 Internal Server Error, 502 Bad Gateway, 503 Service Unavailable"),
)

#tip[
  正确使用 HTTP 方法和状态码是 RESTful API 设计的核心。
]

=== Spring MVC 架构

Spring MVC 是基于 Servlet 的 Web 框架，采用前端控制器模式。

==== 核心组件

```
Client → DispatcherServlet → HandlerMapping → Controller → ViewResolver → Response
              ↑                    ↑                ↓
         Front Controller    查找 Handler    HandlerAdapter
```

*DispatcherServlet*：前端控制器，所有请求的入口

*HandlerMapping*：根据 URL 查找对应的 Controller

*HandlerAdapter*：适配不同类型的 Handler

*Controller*：处理业务逻辑

*ViewResolver*：解析视图（REST API 中通常不需要）

==== 请求处理流程

1. 客户端发送请求到 `DispatcherServlet`
2. `DispatcherServlet` 查询 `HandlerMapping` 找到对应的 Controller
3. `HandlerAdapter` 调用 Controller 的方法
4. Controller 执行业务逻辑，返回结果
5. `DispatcherServlet` 将结果转换为 HTTP 响应
6. 返回给客户端

==== Spring Boot 自动配置

Spring Boot 自动配置了 Spring MVC 的核心组件：

```java
// Spring Boot 自动配置类
@Configuration
@ConditionalOnWebApplication
public class WebMvcAutoConfiguration {

    @Bean
    public DispatcherServlet dispatcherServlet() {
        return new DispatcherServlet();
    }

    @Bean
    public HandlerMapping handlerMapping() {
        // 配置 HandlerMapping
    }
}
```

#note[
  Spring Boot 通过 `spring-boot-starter-web` 依赖自动配置 Spring MVC，无需手动配置。
]

=== RESTful API 设计规范

REST（Representational State Transfer）是一种软件架构风格。

==== 资源命名规范

*使用名词，不使用动词*：

```text
✅ GET    /api/users          # 获取用户列表
✅ GET    /api/users/1        # 获取单个用户
✅ POST   /api/users          # 创建用户
✅ PUT    /api/users/1        # 更新用户
✅ DELETE /api/users/1        # 删除用户

❌ GET    /api/getUsers
❌ POST   /api/createUser
❌ POST   /api/deleteUser/1
```

*使用复数名词*：

```text
✅ /api/users
✅ /api/orders
✅ /api/products

❌ /api/user
❌ /api/order
```

*嵌套资源表示关系*：

```text
✅ GET /api/users/1/orders       # 获取用户 1 的订单
✅ GET /api/users/1/orders/100   # 获取用户 1 的订单 100
```

==== HTTP 方法的正确使用

*GET*：查询资源（安全、幂等）

```java
@GetMapping("/api/users")
public List<User> getUsers() { ... }

@GetMapping("/api/users/{id}")
public User getUser(@PathVariable Long id) { ... }
```

*POST*：创建资源（非幂等）

```java
@PostMapping("/api/users")
public ResponseEntity<User> createUser(@RequestBody User user) {
    User saved = userService.save(user);
    return ResponseEntity.status(HttpStatus.CREATED).body(saved);
}
```

*PUT*：全量更新（幂等）

```java
@PutMapping("/api/users/{id}")
public ResponseEntity<Void> updateUser(
    @PathVariable Long id,
    @RequestBody User user
) {
    userService.update(id, user);
    return ResponseEntity.noContent().build();
}
```

*PATCH*：部分更新（非幂等）

```java
@PatchMapping("/api/users/{id}")
public ResponseEntity<Void> patchUser(
    @PathVariable Long id,
    @RequestBody Map<String, Object> updates
) {
    userService.patch(id, updates);
    return ResponseEntity.noContent().build();
}
```

*DELETE*：删除资源（幂等）

```java
@DeleteMapping("/api/users/{id}")
public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
    userService.delete(id);
    return ResponseEntity.noContent().build();
}
```

==== 状态码的正确使用

#tex-table(
  ("场景", "状态码", "示例"),
  ("查询成功", "200 OK", "GET /api/users"),
  ("创建成功", "201 Created", "POST /api/users"),
  ("删除成功", "204 No Content", "DELETE /api/users/1"),
  ("参数错误", "400 Bad Request", "缺少必填字段"),
  ("未认证", "401 Unauthorized", "Token 无效"),
  ("无权限", "403 Forbidden", "权限不足"),
  ("资源不存在", "404 Not Found", "用户 ID 不存在"),
  ("冲突", "409 Conflict", "用户名已存在"),
  ("服务器错误", "500 Internal Server Error", "未知异常"),
)

==== 版本控制

*URL 路径版本*（推荐）：

```text
/api/v1/users
/api/v2/users
```

*请求头版本*：

```text
GET /api/users
Accept-Version: v1
```

*查询参数版本*：

```text
/api/users?version=1
```

==== 分页与过滤

*分页*：

```text
GET /api/users?page=0&size=10&sort=name,asc

Response:
{
  "content": [...],
  "pageable": {
    "pageNumber": 0,
    "pageSize": 10,
    "sort": "name,asc"
  },
  "totalElements": 100,
  "totalPages": 10
}
```

*过滤*：

```text
GET /api/users?status=active&role=admin
GET /api/users?createdAtAfter=2024-01-01
```

*字段选择*：

```text
GET /api/users?fields=id,name,email
```

==== HATEOAS（可选）

Hypermedia as the Engine of Application State，在响应中包含相关链接。

```json
{
  "id": 1,
  "name": "John Doe",
  "_links": {
    "self": { "href": "/api/users/1" },
    "orders": { "href": "/api/users/1/orders" },
    "update": { "href": "/api/users/1", "method": "PUT" },
    "delete": { "href": "/api/users/1", "method": "DELETE" }
  }
}
```

#fancy-divider

本节介绍了 HTTP 协议基础、Spring MVC 架构和 RESTful API 设计规范。理解这些概念是构建高质量 Web API 的基础。

== 请求处理：参数接收与数据绑定

Spring MVC 提供了多种注解来接收 HTTP 请求中的参数，每种注解适用于不同的场景。

=== #text("@PathVariable")：路径变量

从 URL 路径中提取变量值。

==== 基本用法

```java
@GetMapping("/api/users/{id}")
public User getUser(@PathVariable Long id) {
    return userService.findById(id);
}
```

*请求*：`GET /api/users/123`

*提取*：`id = 123`

==== 多个路径变量

```java
@GetMapping("/api/users/{userId}/orders/{orderId}")
public Order getOrder(
    @PathVariable Long userId,
    @PathVariable Long orderId
) {
    return orderService.findByUserAndOrder(userId, orderId);
}
```

*请求*：`GET /api/users/1/orders/100`

==== 自定义变量名

当方法参数名与路径变量名不一致时，需要显式指定：

```java
@GetMapping("/api/users/{id}")
public User getUser(@PathVariable("id") Long userId) {
    return userService.findById(userId);
}
```

==== 可选路径变量

```java
@GetMapping(value = {"/api/users", "/api/users/{id}"})
public Object getUsers(@PathVariable(required = false) Long id) {
    if (id == null) {
        return userService.findAll();
    }
    return userService.findById(id);
}
```

#note[
  `required = false` 表示该路径变量是可选的，默认为 `true`。
]

=== #text("@RequestParam")：请求参数

从查询字符串（Query String）或表单数据中提取参数。

==== 基本用法

```java
@GetMapping("/api/users")
public List<User> getUsers(
    @RequestParam String name,
    @RequestParam Integer age
) {
    return userService.findByNameAndAge(name, age);
}
```

*请求*：`GET /api/users?name=John&age=25`

==== 可选参数

```java
@GetMapping("/api/users")
public List<User> getUsers(
    @RequestParam(required = false) String name,
    @RequestParam(required = false) Integer age
) {
    // name 和 age 都可以为 null
    return userService.findByNameAndAge(name, age);
}
```

*请求*：

- `GET /api/users?name=John` （只有 name）
- `GET /api/users?age=25` （只有 age）
- `GET /api/users` （都没有）

==== 默认值

```java
@GetMapping("/api/users")
public Page<User> getUsers(
    @RequestParam(defaultValue = "0") int page,
    @RequestParam(defaultValue = "10") int size,
    @RequestParam(defaultValue = "name,asc") String sort
) {
    return userService.findAll(PageRequest.of(page, size, Sort.by(sort)));
}
```

*请求*：`GET /api/users` （使用默认值）

*等价于*：`GET /api/users?page=0&size=10&sort=name,asc`

==== 多值参数

```java
@GetMapping("/api/users")
public List<User> getUsers(@RequestParam List<Long> ids) {
    return userService.findByIds(ids);
}
```

*请求*：`GET /api/users?ids=1&ids=2&ids=3`

*提取*：`ids = [1, 2, 3]`

==== 参数名映射

```java
@GetMapping("/api/users")
public List<User> getUsers(@RequestParam("user_name") String userName) {
    return userService.findByName(userName);
}
```

*请求*：`GET /api/users?user_name=John`

=== #text("@RequestBody")：请求体

将 HTTP 请求体（通常是 JSON）反序列化为 Java 对象。

==== 基本用法

```java
@PostMapping("/api/users")
public ResponseEntity<User> createUser(@RequestBody User user) {
    User saved = userService.save(user);
    return ResponseEntity.status(HttpStatus.CREATED).body(saved);
}
```

*请求*：

```http
POST /api/users
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "age": 25
}
```

*User 类*：

```java
public class User {
    private String name;
    private String email;
    private Integer age;

    // getters and setters
}
```

==== 可选请求体

```java
@PostMapping("/api/users")
public ResponseEntity<User> createUser(
    @RequestBody(required = false) User user
) {
    if (user == null) {
        // 处理空请求体
    }
    User saved = userService.save(user);
    return ResponseEntity.status(HttpStatus.CREATED).body(saved);
}
```

==== 验证请求体

结合 `@Valid` 进行参数校验：

```java
@PostMapping("/api/users")
public ResponseEntity<User> createUser(
    @Valid @RequestBody User user
) {
    User saved = userService.save(user);
    return ResponseEntity.status(HttpStatus.CREATED).body(saved);
}
```

#caution[
  #text("@RequestBody") 只能使用一次，因为请求体只能读取一次。
]

=== #text("@RequestHeader")：请求头

从 HTTP 请求头中提取信息。

==== 基本用法

```java
@GetMapping("/api/users")
public List<User> getUsers(@RequestHeader("Authorization") String token) {
    // 验证 token
    return userService.findAll();
}
```

==== 可选请求头

```java
@GetMapping("/api/users")
public List<User> getUsers(
    @RequestHeader(required = false) String Authorization
) {
    if (Authorization != null) {
        // 有 token，返回认证用户的数据
    }
    // 无 token，返回公开数据
    return userService.findPublic();
}
```

==== 获取所有请求头

```java
@GetMapping("/api/debug")
public Map<String, String> getHeaders(@RequestHeader HttpHeaders headers) {
    return headers.toSingleValueMap();
}
```

=== #text("@CookieValue")：Cookie 值

从 Cookie 中提取值。

```java
@GetMapping("/api/profile")
public String getProfile(@CookieValue("sessionId") String sessionId) {
    // 使用 sessionId 获取用户信息
    return userService.findBySession(sessionId);
}
```

=== #text("@ModelAttribute")：模型属性

从请求参数或表单数据中绑定到对象。

==== 基本用法

```java
@PostMapping("/api/users")
public String createUser(@ModelAttribute UserForm form) {
    // form 包含所有表单字段
    userService.create(form);
    return "redirect:/users";
}
```

*UserForm 类*：

```java
public class UserForm {
    private String name;
    private String email;
    private Integer age;

    // getters and setters
}
```

*请求*：`POST /api/users` with form data `name=John&email=john@example.com&age=25`

==== 与 #text("@RequestBody") 的区别

#tex-table(
  ("特性", "@ModelAttribute", "@RequestBody"),
  ("数据来源", "查询参数/表单", "请求体（JSON/XML）"),
  ("Content-Type", "application/x-www-form-urlencoded", "application/json"),
  ("使用场景", "传统表单提交", "RESTful API"),
  ("数据格式", "键值对", "结构化数据"),
)

=== #text("@MatrixVariable")：矩阵变量

从 URL 路径中的矩阵变量提取值（较少使用）。

```java
@GetMapping("/api/users/{id}")
public User getUser(
    @PathVariable Long id,
    @MatrixVariable String status
) {
    return userService.findByIdAndStatus(id, status);
}
```

*请求*：`GET /api/users/1;status=active`

#note[
  需要在配置中启用矩阵变量支持：
  ```java
  @Configuration
  public class WebConfig implements WebMvcConfigurer {
      @Override
      public void configurePathMatch(PathMatchConfigurer configurer) {
          UrlPathHelper urlPathHelper = new UrlPathHelper();
          urlPathHelper.setRemoveSemicolonContent(false);
          configurer.setUrlPathHelper(urlPathHelper);
      }
  }
  ```
]

=== 参数注解对比总结

#tex-table(
  ("注解", "数据来源", "示例", "常用场景"),
  ("@PathVariable", "URL 路径", "/users/{id}", "RESTful 资源 ID"),
  ("@RequestParam", "查询字符串", "?name=John", "过滤、分页、排序"),
  ("@RequestBody", "请求体", "JSON/XML", "创建/更新资源"),
  ("@RequestHeader", "请求头", "Authorization", "认证、内容协商"),
  ("@CookieValue", "Cookie", "sessionId", "会话管理"),
  ("@ModelAttribute", "表单数据", "form fields", "传统表单提交"),
  ("@MatrixVariable", "矩阵变量", ";status=active", "特殊场景"),
)

=== 综合示例

```java
@RestController
@RequestMapping("/api/users")
public class UserController {

    @GetMapping
    public Page<User> getUsers(
        @RequestParam(required = false) String name,
        @RequestParam(required = false) Integer age,
        @RequestParam(defaultValue = "0") int page,
        @RequestParam(defaultValue = "10") int size,
        @RequestHeader(required = false) String Authorization
    ) {
        // 根据 Authorization 判断权限
        // 根据 name、age 过滤
        // 分页返回
        return userService.findAll(name, age, PageRequest.of(page, size));
    }

    @GetMapping("/{id}")
    public User getUser(@PathVariable Long id) {
        return userService.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("User not found"));
    }

    @PostMapping
    public ResponseEntity<User> createUser(
        @Valid @RequestBody UserCreateRequest request
    ) {
        User user = userService.create(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(user);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Void> updateUser(
        @PathVariable Long id,
        @Valid @RequestBody UserUpdateRequest request
    ) {
        userService.update(id, request);
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        userService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
```

== 请求处理：文件上传与下载

文件上传和下载是 Web 应用的常见需求，Spring Boot 提供了完善的支持。

=== MultipartFile：文件上传

`MultipartFile` 是 Spring 提供的文件上传接口。

==== 基本用法

*Controller*：

```java
@PostMapping("/api/upload")
public ResponseEntity<String> uploadFile(
    @RequestParam("file") MultipartFile file
) {
    if (file.isEmpty()) {
        return ResponseEntity.badRequest().body("File is empty");
    }

    try {
        // 保存文件
        String fileName = file.getOriginalFilename();
        Path path = Paths.get("uploads/" + fileName);
        Files.write(path, file.getBytes());

        return ResponseEntity.ok("File uploaded: " + fileName);
    } catch (IOException e) {
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
            .body("Upload failed: " + e.getMessage());
    }
}
```

*前端请求*：

```html
<form action="/api/upload" method="post" enctype="multipart/form-data">
    <input type="file" name="file" />
    <button type="submit">Upload</button>
</form>
```

或使用 JavaScript：

```javascript
const formData = new FormData();
formData.append('file', fileInput.files[0]);

fetch('/api/upload', {
    method: 'POST',
    body: formData
});
```

==== MultipartFile 常用方法

#tex-table(
  ("方法", "返回类型", "说明"),
  ("getOriginalFilename()", "String", "原始文件名"),
  ("getSize()", "long", "文件大小（字节）"),
  ("getContentType()", "String", "文件 MIME 类型"),
  ("isEmpty()", "boolean", "是否为空"),
  ("getBytes()", "byte[]", "文件内容"),
  ("getInputStream()", "InputStream", "输入流"),
  ("transferTo(File)", "void", "保存到文件"),
)

==== 多文件上传

```java
@PostMapping("/api/upload/multiple")
public ResponseEntity<String> uploadFiles(
    @RequestParam("files") List<MultipartFile> files
) {
    for (MultipartFile file : files) {
        if (!file.isEmpty()) {
            try {
                String fileName = file.getOriginalFilename();
                Path path = Paths.get("uploads/" + fileName);
                Files.write(path, file.getBytes());
            } catch (IOException e) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Upload failed: " + e.getMessage());
            }
        }
    }

    return ResponseEntity.ok("Files uploaded successfully");
}
```

*前端*：

```html
<input type="file" name="files" multiple />
```

==== 文件上传配置

*application.yml*：

```yaml
spring:
  servlet:
    multipart:
      enabled: true              # 启用文件上传
      max-file-size: 10MB        # 单个文件最大大小
      max-request-size: 50MB     # 请求总大小
      file-size-threshold: 2KB   # 超过此大小写入磁盘
```

#caution[
  默认情况下，Spring Boot 限制单个文件为 1MB，总请求为 10MB。需要根据实际需求调整。
]

=== 大文件处理

对于大文件，直接读取到内存会导致 OOM，应该使用流式处理。

==== 流式保存

```java
@PostMapping("/api/upload/large")
public ResponseEntity<String> uploadLargeFile(
    @RequestParam("file") MultipartFile file
) {
    if (file.isEmpty()) {
        return ResponseEntity.badRequest().body("File is empty");
    }

    try {
        String fileName = file.getOriginalFilename();
        Path targetPath = Paths.get("uploads/" + fileName);

        // 使用 InputStream 流式保存，避免内存溢出
        try (InputStream inputStream = file.getInputStream()) {
            Files.copy(inputStream, targetPath, StandardCopyOption.REPLACE_EXISTING);
        }

        return ResponseEntity.ok("Large file uploaded: " + fileName);
    } catch (IOException e) {
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
            .body("Upload failed: " + e.getMessage());
    }
}
```

==== 分片上传

将大文件分成多个小块上传，适合超大文件（GB级别）。

*Controller*：

```java
@RestController
@RequestMapping("/api/upload/chunk")
public class ChunkUploadController {

    private static final String UPLOAD_DIR = "uploads/chunks/";

    @PostMapping("/upload")
    public ResponseEntity<String> uploadChunk(
        @RequestParam("file") MultipartFile chunk,
        @RequestParam("chunkNumber") int chunkNumber,
        @RequestParam("totalChunks") int totalChunks,
        @RequestParam("fileName") String fileName
    ) {
        try {
            // 保存分片
            Path chunkPath = Paths.get(UPLOAD_DIR + fileName + ".part" + chunkNumber);
            Files.createDirectories(chunkPath.getParent());

            try (InputStream inputStream = chunk.getInputStream()) {
                Files.copy(inputStream, chunkPath, StandardCopyOption.REPLACE_EXISTING);
            }

            // 检查是否所有分片都已上传
            if (isAllChunksUploaded(fileName, totalChunks)) {
                mergeChunks(fileName, totalChunks);
                return ResponseEntity.ok("File merged: " + fileName);
            }

            return ResponseEntity.ok("Chunk " + chunkNumber + " uploaded");
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body("Upload failed: " + e.getMessage());
        }
    }

    private boolean isAllChunksUploaded(String fileName, int totalChunks) {
        for (int i = 1; i <= totalChunks; i++) {
            Path chunkPath = Paths.get(UPLOAD_DIR + fileName + ".part" + i);
            if (!Files.exists(chunkPath)) {
                return false;
            }
        }
        return true;
    }

    private void mergeChunks(String fileName, int totalChunks) throws IOException {
        Path mergedPath = Paths.get("uploads/" + fileName);

        try (OutputStream outputStream = Files.newOutputStream(mergedPath)) {
            for (int i = 1; i <= totalChunks; i++) {
                Path chunkPath = Paths.get(UPLOAD_DIR + fileName + ".part" + i);
                Files.copy(chunkPath, outputStream);
                Files.delete(chunkPath); // 删除分片
            }
        }
    }
}
```

*前端*：

```javascript
async function uploadLargeFile(file) {
    const chunkSize = 5 * 1024 * 1024; // 5MB per chunk
    const totalChunks = Math.ceil(file.size / chunkSize);

    for (let i = 0; i < totalChunks; i++) {
        const start = i * chunkSize;
        const end = Math.min(start + chunkSize, file.size);
        const chunk = file.slice(start, end);

        const formData = new FormData();
        formData.append('file', chunk);
        formData.append('chunkNumber', i + 1);
        formData.append('totalChunks', totalChunks);
        formData.append('fileName', file.name);

        await fetch('/api/upload/chunk/upload', {
            method: 'POST',
            body: formData
        });
    }
}
```

=== 断点续传

断点续传允许中断后从上次位置继续上传。

==== 实现思路

1. 客户端计算文件的 MD5 或 SHA1
2. 上传前询问服务器已上传的字节数
3. 从断点处继续上传

*Controller*：

```java
@RestController
@RequestMapping("/api/upload/resume")
public class ResumeUploadController {

    private static final String UPLOAD_DIR = "uploads/";

    // 查询已上传的字节数
    @GetMapping("/status")
    public ResponseEntity<Map<String, Object>> getUploadStatus(
        @RequestParam("fileId") String fileId
    ) {
        Path filePath = Paths.get(UPLOAD_DIR + fileId);

        Map<String, Object> status = new HashMap<>();
        if (Files.exists(filePath)) {
            try {
                long uploadedBytes = Files.size(filePath);
                status.put("uploadedBytes", uploadedBytes);
                status.put("completed", false);
            } catch (IOException e) {
                status.put("error", e.getMessage());
            }
        } else {
            status.put("uploadedBytes", 0);
            status.put("completed", false);
        }

        return ResponseEntity.ok(status);
    }

    // 续传文件
    @PostMapping("/upload")
    public ResponseEntity<String> resumeUpload(
        @RequestParam("file") MultipartFile chunk,
        @RequestParam("fileId") String fileId,
        @RequestParam("offset") long offset
    ) {
        try {
            Path filePath = Paths.get(UPLOAD_DIR + fileId);

            // 追加写入
            try (OutputStream outputStream = Files.newOutputStream(
                filePath,
                StandardOpenOption.CREATE,
                StandardOpenOption.APPEND
            )) {
                outputStream.write(chunk.getBytes());
            }

            return ResponseEntity.ok("Uploaded to offset: " + (offset + chunk.getSize()));
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body("Upload failed: " + e.getMessage());
        }
    }
}
```

*前端*：

```javascript
async function uploadWithResume(file, fileId) {
    const chunkSize = 5 * 1024 * 1024; // 5MB
    let offset = 0;

    // 查询已上传的字节数
    const statusResponse = await fetch(
        `/api/upload/resume/status?fileId=${fileId}`
    );
    const status = await statusResponse.json();
    offset = status.uploadedBytes;

    // 从断点处继续上传
    while (offset < file.size) {
        const end = Math.min(offset + chunkSize, file.size);
        const chunk = file.slice(offset, end);

        const formData = new FormData();
        formData.append('file', chunk);
        formData.append('fileId', fileId);
        formData.append('offset', offset);

        await fetch('/api/upload/resume/upload', {
            method: 'POST',
            body: formData
        });

        offset = end;
    }
}
```

=== 文件下载

==== 基本下载

```java
@GetMapping("/api/download/{fileName}")
public ResponseEntity<Resource> downloadFile(
    @PathVariable String fileName
) {
    try {
        Path filePath = Paths.get("uploads/" + fileName);
        Resource resource = new UrlResource(filePath.toUri());

        if (!resource.exists() || !resource.isReadable()) {
            throw new FileNotFoundException("File not found: " + fileName);
        }

        return ResponseEntity.ok()
            .contentType(MediaType.APPLICATION_OCTET_STREAM)
            .header(HttpHeaders.CONTENT_DISPOSITION,
                "attachment; filename=\"" + resource.getFilename() + "\"")
            .body(resource);
    } catch (MalformedURLException e) {
        throw new RuntimeException("File download failed", e);
    }
}
```

==== 指定 Content-Type

```java
@GetMapping("/api/download/image/{fileName}")
public ResponseEntity<Resource> downloadImage(
    @PathVariable String fileName
) {
    try {
        Path filePath = Paths.get("uploads/images/" + fileName);
        Resource resource = new UrlResource(filePath.toUri());

        // 根据文件扩展名设置 Content-Type
        String contentType = Files.probeContentType(filePath);
        if (contentType == null) {
            contentType = "application/octet-stream";
        }

        return ResponseEntity.ok()
            .contentType(MediaType.parseMediaType(contentType))
            .header(HttpHeaders.CONTENT_DISPOSITION,
                "inline; filename=\"" + resource.getFilename() + "\"")
            .body(resource);
    } catch (IOException e) {
        throw new RuntimeException("File download failed", e);
    }
}
```

*区别*：

- `attachment`：强制下载
- `inline`：浏览器尝试直接显示（如图片、PDF）

==== 范围请求（支持断点续下载）

```java
@GetMapping("/api/download/range/{fileName}")
public ResponseEntity<Resource> downloadWithRange(
    @PathVariable String fileName,
    @RequestHeader(value = HttpHeaders.RANGE, required = false) String rangeHeader
) {
    try {
        Path filePath = Paths.get("uploads/" + fileName);
        Resource resource = new UrlResource(filePath.toUri());
        long fileSize = Files.size(filePath);

        if (rangeHeader != null && rangeHeader.startsWith("bytes=")) {
            // 解析 Range 头
            String[] ranges = rangeHeader.substring(6).split("-");
            long start = Long.parseLong(ranges[0]);
            long end = ranges.length > 1 ? Long.parseLong(ranges[1]) : fileSize - 1;

            // 返回部分内容
            return ResponseEntity.status(HttpStatus.PARTIAL_CONTENT)
                .contentType(MediaType.APPLICATION_OCTET_STREAM)
                .header(HttpHeaders.CONTENT_RANGE,
                    "bytes " + start + "-" + end + "/" + fileSize)
                .header(HttpHeaders.ACCEPT_RANGES, "bytes")
                .body(new InputStreamResource(
                    new FileInputStream(filePath.toFile())
                ));
        }

        // 完整下载
        return ResponseEntity.ok()
            .contentType(MediaType.APPLICATION_OCTET_STREAM)
            .header(HttpHeaders.CONTENT_DISPOSITION,
                "attachment; filename=\"" + fileName + "\"")
            .header(HttpHeaders.ACCEPT_RANGES, "bytes")
            .body(resource);
    } catch (IOException e) {
        throw new RuntimeException("File download failed", e);
    }
}
```

*前端使用*：

```javascript
// 支持断点续下载
fetch('/api/download/range/largefile.zip', {
    headers: {
        'Range': 'bytes=0-1048575' // 下载前 1MB
    }
});
```

=== 文件上传最佳实践

#tex-table(
  ("实践", "说明", "示例"),
  ("限制文件大小", "防止恶意大文件", "max-file-size: 10MB"),
  ("验证文件类型", "检查 MIME Type", "image/jpeg, application/pdf"),
  ("重命名文件", "避免文件名冲突", "UUID + 扩展名"),
  ("存储到外部", "不存储在应用目录", "OSS、S3、NAS"),
  ("异步处理", "大文件异步上传", "@Async、消息队列"),
  ("进度反馈", "实时上传进度", "WebSocket、SSE"),
  ("安全防护", "防止路径遍历", "验证文件名合法性"),
)

==== 文件类型验证

```java
@PostMapping("/api/upload/validate")
public ResponseEntity<String> uploadWithValidation(
    @RequestParam("file") MultipartFile file
) {
    // 验证文件大小
    if (file.getSize() > 10 * 1024 * 1024) {
        return ResponseEntity.badRequest().body("File too large");
    }

    // 验证文件类型
    String contentType = file.getContentType();
    List<String> allowedTypes = List.of(
        "image/jpeg", "image/png", "application/pdf"
    );
    if (!allowedTypes.contains(contentType)) {
        return ResponseEntity.badRequest().body("Invalid file type");
    }

    // 验证文件扩展名
    String fileName = file.getOriginalFilename();
    if (fileName != null) {
        String extension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
        List<String> allowedExtensions = List.of(".jpg", ".jpeg", ".png", ".pdf");
        if (!allowedExtensions.contains(extension)) {
            return ResponseEntity.badRequest().body("Invalid file extension");
        }
    }

    // 保存文件...
    return ResponseEntity.ok("File uploaded successfully");
}
```

==== 文件重命名

```java
private String generateFileName(String originalFileName) {
    String extension = "";
    if (originalFileName != null && originalFileName.contains(".")) {
        extension = originalFileName.substring(originalFileName.lastIndexOf("."));
    }
    return UUID.randomUUID().toString() + extension;
}
```

#fancy-divider

本节详细介绍了文件上传与下载的完整实现，包括基本的 MultipartFile 使用、大文件处理、断点续传以及安全防护。实际项目中应根据需求选择合适的方案。

== 响应处理：ResponseEntity 与统一响应结构

良好的响应设计是 RESTful API 的重要组成部分，包括正确的状态码、统一的响应格式和分页支持。

=== ResponseEntity 基础

`ResponseEntity` 是 Spring 提供的响应封装类，可以控制 HTTP 响应的状态码、 headers 和 body。

==== 基本用法

```java
@GetMapping("/api/users/{id}")
public ResponseEntity<User> getUser(@PathVariable Long id) {
    User user = userService.findById(id)
        .orElseThrow(() -> new ResourceNotFoundException("User not found"));
    
    return ResponseEntity.ok(user);
}
```

*等价于*：

```java
return new ResponseEntity<>(user, HttpStatus.OK);
```

==== 常用静态方法

#tex-table(
  ("方法", "状态码", "说明"),
  ("ok()", "200 OK", "成功"),
  ("created(uri)", "201 Created", "资源创建成功"),
  ("accepted()", "202 Accepted", "请求已接受"),
  ("noContent()", "204 No Content", "成功但无内容"),
  ("badRequest()", "400 Bad Request", "请求错误"),
  ("notFound()", "404 Not Found", "资源不存在"),
  ("internalServerError()", "500 Internal Server Error", "服务器错误"),
)

==== 设置响应头

```java
@PostMapping("/api/users")
public ResponseEntity<User> createUser(@RequestBody User user) {
    User saved = userService.save(user);
    
    URI location = URI.create("/api/users/" + saved.getId());
    
    return ResponseEntity.created(location)
        .header("X-Custom-Header", "Custom Value")
        .body(saved);
}
```

*响应*：

```http
HTTP/1.1 201 Created
Location: /api/users/123
X-Custom-Header: Custom Value
Content-Type: application/json

{
  "id": 123,
  "name": "John Doe"
}
```

==== 条件响应

```java
@GetMapping("/api/users/{id}")
public ResponseEntity<User> getUserWithEtag(
    @PathVariable Long id,
    @RequestHeader(value = HttpHeaders.IF_NONE_MATCH, required = false) String ifNoneMatch
) {
    User user = userService.findById(id)
        .orElseThrow(() -> new ResourceNotFoundException("User not found"));
    
    String etag = "\"" + user.getVersion() + "\"";
    
    if (etag.equals(ifNoneMatch)) {
        return ResponseEntity.status(HttpStatus.NOT_MODIFIED).build();
    }
    
    return ResponseEntity.ok()
        .eTag(etag)
        .lastModified(user.getUpdatedAt().toInstant().toEpochMilli())
        .body(user);
}
```

=== 统一响应结构

在实际项目中，通常使用统一的响应格式，便于前端处理。

==== 响应结构设计

```java
public class ApiResponse<T> {
    private int code;           // 业务状态码
    private String message;     // 响应消息
    private T data;            // 响应数据
    private long timestamp;    // 时间戳
    
    public ApiResponse(int code, String message, T data) {
        this.code = code;
        this.message = message;
        this.data = data;
        this.timestamp = System.currentTimeMillis();
    }
    
    // 成功响应
    public static <T> ApiResponse<T> success(T data) {
        return new ApiResponse<>(200, "Success", data);
    }
    
    public static <T> ApiResponse<T> success(String message, T data) {
        return new ApiResponse<>(200, message, data);
    }
    
    // 失败响应
    public static <T> ApiResponse<T> error(int code, String message) {
        return new ApiResponse<>(code, message, null);
    }
    
    public static <T> ApiResponse<T> error(String message) {
        return new ApiResponse<>(500, message, null);
    }
    
    // getters and setters
}
```

==== 使用示例

```java
@RestController
@RequestMapping("/api/users")
public class UserController {
    
    @GetMapping("/{id}")
    public ApiResponse<User> getUser(@PathVariable Long id) {
        User user = userService.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("User not found"));
        
        return ApiResponse.success(user);
    }
    
    @PostMapping
    public ApiResponse<User> createUser(@Valid @RequestBody UserCreateRequest request) {
        User user = userService.create(request);
        return ApiResponse.success("User created successfully", user);
    }
    
    @DeleteMapping("/{id}")
    public ApiResponse<Void> deleteUser(@PathVariable Long id) {
        userService.delete(id);
        return ApiResponse.success("User deleted successfully", null);
    }
}
```

*成功响应*：

```json
{
  "code": 200,
  "message": "Success",
  "data": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com"
  },
  "timestamp": 1704067200000
}
```

*失败响应*：

```json
{
  "code": 404,
  "message": "User not found",
  "data": null,
  "timestamp": 1704067200000
}
```

==== 泛型封装的优势

#tex-table(
  ("优势", "说明"),
  ("类型安全", "编译时检查，避免类型错误"),
  ("代码复用", "统一的响应处理逻辑"),
  ("前端友好", "固定的响应结构，易于解析"),
  ("扩展性强", "可添加分页、元数据等字段"),
  ("维护性好", "修改响应格式只需改一处"),
)

=== 分页响应

对于列表查询，通常需要返回分页信息。

==== 分页响应结构

```java
public class PageResponse<T> {
    private List<T> content;        // 数据列表
    private int pageNumber;         // 当前页码
    private int pageSize;          // 每页大小
    private long totalElements;    // 总记录数
    private int totalPages;        // 总页数
    private boolean first;         // 是否第一页
    private boolean last;          // 是否最后一页
    
    public PageResponse(Page<T> page) {
        this.content = page.getContent();
        this.pageNumber = page.getNumber();
        this.pageSize = page.getSize();
        this.totalElements = page.getTotalElements();
        this.totalPages = page.getTotalPages();
        this.first = page.isFirst();
        this.last = page.isLast();
    }
    
    // getters
}
```

==== 结合统一响应

```java
@GetMapping
public ApiResponse<PageResponse<User>> getUsers(
    @RequestParam(defaultValue = "0") int page,
    @RequestParam(defaultValue = "10") int size,
    @RequestParam(defaultValue = "id,asc") String sort
) {
    Sort sorting = Sort.by(
        sort.split(",")[0],
        sort.split(",")[1].equalsIgnoreCase("desc") 
            ? Sort.Direction.DESC 
            : Sort.Direction.ASC
    );
    
    Pageable pageable = PageRequest.of(page, size, sorting);
    Page<User> userPage = userService.findAll(pageable);
    
    PageResponse<User> pageResponse = new PageResponse<>(userPage);
    
    return ApiResponse.success(pageResponse);
}
```

*响应*：

```json
{
  "code": 200,
  "message": "Success",
  "data": {
    "content": [
      { "id": 1, "name": "John Doe" },
      { "id": 2, "name": "Jane Smith" }
    ],
    "pageNumber": 0,
    "pageSize": 10,
    "totalElements": 100,
    "totalPages": 10,
    "first": true,
    "last": false
  },
  "timestamp": 1704067200000
}
```

==== Spring Data JPA 分页

如果使用 Spring Data JPA，可以直接返回 `Page` 对象。

*Repository*：

```java
public interface UserRepository extends JpaRepository<User, Long> {
    Page<User> findByNameContaining(String name, Pageable pageable);
}
```

*Service*：

```java
@Service
public class UserService {
    
    @Autowired
    private UserRepository userRepository;
    
    public Page<User> findAll(Pageable pageable) {
        return userRepository.findAll(pageable);
    }
    
    public Page<User> searchByName(String name, Pageable pageable) {
        return userRepository.findByNameContaining(name, pageable);
    }
}
```

*Controller*：

```java
@GetMapping("/search")
public ApiResponse<PageResponse<User>> searchUsers(
    @RequestParam String name,
    @RequestParam(defaultValue = "0") int page,
    @RequestParam(defaultValue = "10") int size
) {
    Pageable pageable = PageRequest.of(page, size);
    Page<User> userPage = userService.searchByName(name, pageable);
    
    return ApiResponse.success(new PageResponse<>(userPage));
}
```

=== 响应状态码映射

将业务异常映射为合适的 HTTP 状态码。

==== 自定义异常

```java
// 资源不存在
@ResponseStatus(HttpStatus.NOT_FOUND)
public class ResourceNotFoundException extends RuntimeException {
    public ResourceNotFoundException(String message) {
        super(message);
    }
}

// 参数错误
@ResponseStatus(HttpStatus.BAD_REQUEST)
public class BadRequestException extends RuntimeException {
    public BadRequestException(String message) {
        super(message);
    }
}

// 权限不足
@ResponseStatus(HttpStatus.FORBIDDEN)
public class ForbiddenException extends RuntimeException {
    public ForbiddenException(String message) {
        super(message);
    }
}
```

==== 使用示例

```java
@GetMapping("/api/users/{id}")
public ResponseEntity<User> getUser(@PathVariable Long id) {
    User user = userService.findById(id)
        .orElseThrow(() -> new ResourceNotFoundException(
            "User not found with id: " + id
        ));
    
    return ResponseEntity.ok(user);
}
```

*响应*：

```http
HTTP/1.1 404 Not Found
Content-Type: application/json

{
  "timestamp": "2024-01-01T00:00:00.000+00:00",
  "status": 404,
  "error": "Not Found",
  "message": "User not found with id: 999",
  "path": "/api/users/999"
}
```

#note[
  Spring Boot 默认会将异常转换为 JSON 响应，包含 timestamp、status、error、message、path 等字段。
]

=== 响应缓存

通过缓存减少重复请求，提高性能。

==== Cache-Control 头

```java
@GetMapping("/api/config")
public ResponseEntity<Map<String, Object>> getConfig() {
    Map<String, Object> config = configService.getConfig();
    
    return ResponseEntity.ok()
        .cacheControl(CacheControl.maxAge(3600, TimeUnit.SECONDS))
        .body(config);
}
```

*响应头*：

```http
Cache-Control: max-age=3600
```

==== ETag 缓存

```java
@GetMapping("/api/users/{id}")
public ResponseEntity<User> getUserWithETag(@PathVariable Long id) {
    User user = userService.findById(id)
        .orElseThrow(() -> new ResourceNotFoundException("User not found"));
    
    String etag = "\"" + user.getVersion() + "\"";
    
    return ResponseEntity.ok()
        .eTag(etag)
        .body(user);
}
```

*客户端后续请求*：

```http
GET /api/users/1
If-None-Match: "123"

HTTP/1.1 304 Not Modified
```

=== 响应处理最佳实践

#tex-table(
  ("实践", "说明", "示例"),
  ("统一响应格式", "所有接口使用相同结构", "ApiResponse<T>"),
  ("正确使用状态码", "根据语义选择状态码", "201 Created, 204 No Content"),
  ("分页标准化", "使用 PageRequest 和 Page", "page, size, sort 参数"),
  ("HATEOAS 链接", "提供相关资源链接", "_links 字段"),
  ("版本控制", "API 版本在 URL 中", "/api/v1/users"),
  ("错误信息清晰", "提供有用的错误消息", "具体说明错误原因"),
  ("敏感信息脱敏", "不暴露内部细节", "隐藏堆栈跟踪"),
)

==== 完整示例

```java
@RestController
@RequestMapping("/api/v1/users")
public class UserController {
    
    @Autowired
    private UserService userService;
    
    // 查询列表（分页）
    @GetMapping
    public ApiResponse<PageResponse<UserDTO>> getUsers(
        @RequestParam(required = false) String name,
        @RequestParam(defaultValue = "0") int page,
        @RequestParam(defaultValue = "10") int size,
        @RequestParam(defaultValue = "id,asc") String sort
    ) {
        Sort sorting = parseSort(sort);
        Pageable pageable = PageRequest.of(page, size, sorting);
        
        Page<User> userPage;
        if (name != null && !name.isEmpty()) {
            userPage = userService.searchByName(name, pageable);
        } else {
            userPage = userService.findAll(pageable);
        }
        
        List<UserDTO> dtos = userPage.getContent().stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
        
        Page<UserDTO> dtoPage = new PageImpl<>(
            dtos, 
            pageable, 
            userPage.getTotalElements()
        );
        
        return ApiResponse.success(new PageResponse<>(dtoPage));
    }
    
    // 查询单个
    @GetMapping("/{id}")
    public ApiResponse<UserDTO> getUser(@PathVariable Long id) {
        User user = userService.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException(
                "User not found with id: " + id
            ));
        
        return ApiResponse.success(convertToDTO(user));
    }
    
    // 创建
    @PostMapping
    public ResponseEntity<ApiResponse<UserDTO>> createUser(
        @Valid @RequestBody UserCreateRequest request
    ) {
        User user = userService.create(request);
        UserDTO dto = convertToDTO(user);
        
        URI location = URI.create("/api/v1/users/" + user.getId());
        
        return ResponseEntity.created(location)
            .body(ApiResponse.success("User created successfully", dto));
    }
    
    // 更新
    @PutMapping("/{id}")
    public ApiResponse<UserDTO> updateUser(
        @PathVariable Long id,
        @Valid @RequestBody UserUpdateRequest request
    ) {
        User user = userService.update(id, request);
        return ApiResponse.success("User updated successfully", convertToDTO(user));
    }
    
    // 删除
    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteUser(@PathVariable Long id) {
        userService.delete(id);
        return ResponseEntity.noContent().build();
    }
    
    private UserDTO convertToDTO(User user) {
        UserDTO dto = new UserDTO();
        dto.setId(user.getId());
        dto.setName(user.getName());
        dto.setEmail(user.getEmail());
        // 脱敏：不返回密码等敏感信息
        return dto;
    }
    
    private Sort parseSort(String sort) {
        String[] parts = sort.split(",");
        return Sort.by(
            parts[0],
            parts.length > 1 && parts[1].equalsIgnoreCase("desc")
                ? Sort.Direction.DESC
                : Sort.Direction.ASC
        );
    }
}
```

#fancy-divider

本节详细介绍了响应处理的完整方案，包括 ResponseEntity 的使用、统一响应结构设计、分页响应实现以及最佳实践。良好的响应设计能够提升 API 的可用性和可维护性。
