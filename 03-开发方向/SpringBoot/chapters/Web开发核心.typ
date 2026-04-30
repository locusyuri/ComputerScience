#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= Web 开发核心

#note[
  Spring Boot 的 Web 开发基于 Spring MVC 框架，提供了构建 RESTful API 和传统 Web 应用的完整解决方案。
]

== RESTful API 设计

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

REST（Representational State Transfer）是一种基于 HTTP 协议的 Web 架构风格，它通过资源定位、无状态通信和表现层状态转换，简化了 Web 应用的开发和维护。

*RESTful API 的核心特点*：

1. *资源定位*：使用 URI 唯一标识资源
2. *表现层状态转换*：客户端通过修改资源状态实现状态转换
3. *无状态*：每次请求都包含完整信息，服务器不保存客户端状态
4. *统一接口*：使用标准 HTTP 方法操作资源
5. *可缓存*：响应可以明确标注是否可缓存

#tip[
  RESTful API 已成为 Web 应用程序的标准 API 设计风格，被 Facebook、Twitter、GitHub 等主流互联网公司广泛采用。
]

==== 资源命名规范

*1. 使用名词，不使用动词*

RESTful API 将数据和操作转化为资源和 HTTP 动词，URI 应该只表示资源，操作由 HTTP 方法表达。

```text
✅ GET    /api/users          # 获取用户列表
✅ GET    /api/users/1        # 获取单个用户
✅ POST   /api/users          # 创建用户
✅ PUT    /api/users/1        # 更新用户
✅ DELETE /api/users/1        # 删除用户

❌ GET    /api/getUsers       # 不要在 URI 中使用动词
❌ POST   /api/createUser     # 操作应由 HTTP 方法表达
❌ POST   /api/deleteUser/1   # 避免混淆
```

*2. 使用复数名词*

保持一致性，所有资源都使用复数形式。

```text
✅ /api/users
✅ /api/orders
✅ /api/products

❌ /api/user      # 不一致
❌ /api/order     # 不一致
```

#note[
  例外情况：如果资源本身就是单数概念（如 /api/info、/api/status），可以保持单数。
]

*3. 使用小写字母和连字符*

```text
✅ /api/user-profiles
✅ /api/order-items
✅ /api/product-categories

❌ /api/UserProfiles      # 避免驼峰
❌ /api/user_profiles     # 避免下划线
```

*4. 嵌套资源表示关系*

使用嵌套路径表示资源之间的从属关系，但层级不宜过深（建议不超过3层）。

```text
✅ GET /api/users/1/orders              # 获取用户 1 的订单
✅ GET /api/users/1/orders/100          # 获取用户 1 的订单 100
✅ GET /api/users/1/orders/100/items    # 获取订单 100 的商品项

❌ GET /api/users/1/orders/100/items/5/details/extra  # 层级过深
```

*替代方案：使用查询参数*

```text
# 如果嵌套过深，可以使用查询参数
✅ GET /api/order-items?orderId=100&userId=1
```

*5. 避免暴露内部实现*

```text
✅ /api/users
✅ /api/articles

❌ /api/getUsersFromDatabase    # 暴露实现细节
❌ /api/json/users              # 暴露数据格式
```

==== HTTP 方法的正确使用

HTTP 方法是 RESTful API 的核心，每个方法都有明确的语义。

*GET*：查询资源（安全、幂等）

- *安全*：不会修改服务器状态
- *幂等*：多次执行结果相同
- *可缓存*：响应可以被缓存

```java
@GetMapping("/api/users")
public ResponseEntity<List<User>> getUsers() {
    List<User> users = userService.findAll();
    return ResponseEntity.ok(users);
}

@GetMapping("/api/users/{id}")
public ResponseEntity<User> getUser(@PathVariable Long id) {
    User user = userService.findById(id)
        .orElseThrow(() -> new ResourceNotFoundException("用户不存在"));
    return ResponseEntity.ok(user);
}
```

#caution[
  GET 请求不应该有副作用，不要用于修改数据。GET 请求的参数应该放在 URL 中，而不是请求体中。
]

*POST*：创建资源（非幂等）

- *非幂等*：多次执行可能创建多个资源
- 返回 201 Created 状态码
- 在 Location 头中返回新资源的 URI

```java
@PostMapping("/api/users")
public ResponseEntity<User> createUser(@Valid @RequestBody CreateUserRequest request) {
    User user = userService.createUser(request);

    URI location = URI.create("/api/users/" + user.getId());
    return ResponseEntity.created(location).body(user);
}
```

*PUT*：全量更新（幂等）

- *幂等*：多次执行结果相同
- 需要提供完整的资源表示
- 如果资源不存在，可以创建（可选）

```java
@PutMapping("/api/users/{id}")
public ResponseEntity<Void> updateUser(
    @PathVariable Long id,
    @Valid @RequestBody UpdateUserRequest request
) {
    userService.update(id, request);
    return ResponseEntity.noContent().build();
}
```

*PATCH*：部分更新（非幂等）

- *非幂等*：多次执行可能产生不同结果
- 只需要提供要更新的字段
- 更适合实际应用场景

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

#tip[
  在实际项目中，如果只需要更新部分字段，优先使用 PATCH 而非 PUT。PUT 适合表单提交等需要完整数据的场景。
]

*DELETE*：删除资源（幂等）

- *幂等*：多次执行结果相同（第一次删除后，后续返回 404 或 204）
- 通常返回 204 No Content

```java
@DeleteMapping("/api/users/{id}")
public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
    userService.delete(id);
    return ResponseEntity.noContent().build();
}
```

*其他方法*：

#tex-table(
  ("方法", "用途", "幂等", "示例"),
  ("HEAD", "获取资源元信息", "是", "检查资源是否存在"),
  ("OPTIONS", "获取支持的 HTTP 方法", "是", "CORS 预检请求"),
)

==== 状态码的正确使用

HTTP 状态码是 RESTful API 的重要组成部分，客户端根据状态码判断请求结果。

*成功状态码（2xx）*：

#tex-table(
  ("状态码", "含义", "使用场景"),
  ("200 OK", "请求成功", "GET、PUT、PATCH 成功"),
  ("201 Created", "资源创建成功", "POST 创建资源"),
  ("204 No Content", "成功但无返回内容", "DELETE 成功"),
  ("206 Partial Content", "部分内容", "分页、断点续传"),
)

*客户端错误（4xx）*：

#tex-table(
  ("状态码", "含义", "使用场景"),
  ("400 Bad Request", "请求参数错误", "参数验证失败、JSON 格式错误"),
  ("401 Unauthorized", "未认证", "Token 无效、未登录"),
  ("403 Forbidden", "无权限", "权限不足、IP 被禁止"),
  ("404 Not Found", "资源不存在", "URI 错误、资源已删除"),
  ("405 Method Not Allowed", "方法不允许", "使用了不支持的 HTTP 方法"),
  ("409 Conflict", "冲突", "用户名已存在、版本冲突"),
  ("422 Unprocessable Entity", "语义错误", "参数逻辑错误、业务规则违反"),
  ("429 Too Many Requests", "请求过多", "触发限流"),
)

*服务器错误（5xx）*：

#tex-table(
  ("状态码", "含义", "使用场景"),
  ("500 Internal Server Error", "服务器内部错误", "未捕获的异常"),
  ("502 Bad Gateway", "网关错误", "上游服务不可用"),
  ("503 Service Unavailable", "服务不可用", "维护中、过载"),
  ("504 Gateway Timeout", "网关超时", "上游服务超时"),
)

*实战示例*：

```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    // 资源不存在 - 404
    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleNotFound(ResourceNotFoundException ex) {
        ErrorResponse error = new ErrorResponse(
            "NOT_FOUND",
            ex.getMessage(),
            LocalDateTime.now()
        );
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
    }

    // 参数验证失败 - 400
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidation(MethodArgumentNotValidException ex) {
        String message = ex.getBindingResult().getFieldErrors().stream()
            .map(error -> error.getField() + ": " + error.getDefaultMessage())
            .collect(Collectors.joining(", "));

        ErrorResponse error = new ErrorResponse(
            "VALIDATION_ERROR",
            message,
            LocalDateTime.now()
        );
        return ResponseEntity.badRequest().body(error);
    }

    // 业务冲突 - 409
    @ExceptionHandler(BusinessConflictException.class)
    public ResponseEntity<ErrorResponse> handleConflict(BusinessConflictException ex) {
        ErrorResponse error = new ErrorResponse(
            "CONFLICT",
            ex.getMessage(),
            LocalDateTime.now()
        );
        return ResponseEntity.status(HttpStatus.CONFLICT).body(error);
    }

    // 服务器错误 - 500
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleException(Exception ex) {
        log.error("服务器内部错误", ex);

        ErrorResponse error = new ErrorResponse(
            "INTERNAL_ERROR",
            "服务器内部错误，请稍后重试",
            LocalDateTime.now()
        );
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
    }
}
```

*统一错误响应格式*：

```json
{
  "code": "VALIDATION_ERROR",
  "message": "email: 邮箱格式不正确, name: 姓名不能为空",
  "timestamp": "2025-01-15T10:30:00",
  "path": "/api/users",
  "errors": [
    {
      "field": "email",
      "message": "邮箱格式不正确"
    },
    {
      "field": "name",
      "message": "姓名不能为空"
    }
  ]
}
```

#note[
  生产环境中，500 错误的详细信息不应该暴露给客户端，只返回通用错误消息，详细日志记录在服务器端。
]

==== 数据格式规范

*1. 使用 JSON 作为默认格式*

JSON 是现代 Web API 的事实标准，具有良好的可读性和广泛的语言支持。

```java
@RestController
@RequestMapping("/api/users")
public class UserController {

    // Spring Boot 默认使用 Jackson 序列化 JSON
    @GetMapping("/{id}")
    public User getUser(@PathVariable Long id) {
        return userService.findById(id).orElseThrow();
    }
}
```

*请求示例*：

```json
POST /api/users
Content-Type: application/json

{
  "name": "张三",
  "email": "zhangsan@example.com",
  "age": 25
}
```

*响应示例*：

```json
{
  "id": 1,
  "name": "张三",
  "email": "zhangsan@example.com",
  "age": 25,
  "createdAt": "2025-01-15T10:30:00",
  "updatedAt": "2025-01-15T10:30:00"
}
```

*2. 日期时间格式*

使用 ISO 8601 标准格式：

```json
{
  "createdAt": "2025-01-15T10:30:00Z",        // UTC 时间
  "birthDate": "1990-01-15",                   // 日期
  "localTime": "2025-01-15T10:30:00+08:00"    // 带时区
}
```

*3. 空值处理*

```json
// 推荐：省略 null 字段
{
  "id": 1,
  "name": "张三",
  "email": "zhangsan@example.com"
  // age 为 null，直接省略
}

// 或者明确返回 null
{
  "id": 1,
  "name": "张三",
  "email": "zhangsan@example.com",
  "age": null
}
```

配置 Jackson 忽略 null 值：

```java
@Configuration
public class JacksonConfig {

    @Bean
    public Jackson2ObjectMapperBuilderCustomizer customizer() {
        return builder -> builder.serializationInclusion(JsonInclude.Include.NON_NULL);
    }
}
```

==== 版本控制

API 版本控制是保证向后兼容和平滑升级的关键。

*1. URL 路径版本*（推荐）

最直观、最常用的方式，易于理解和调试。

```text
/api/v1/users
/api/v2/users
```

```java
@RestController
@RequestMapping("/api/v1/users")
public class UserControllerV1 {
    @GetMapping
    public List<UserV1> getUsers() {
        // v1 版本的实现
    }
}

@RestController
@RequestMapping("/api/v2/users")
public class UserControllerV2 {
    @GetMapping
    public List<UserV2> getUsers() {
        // v2 版本的实现
    }
}
```

*优势*：
- 直观明了，易于理解
- 便于缓存（不同版本的 URL 不同）
- 浏览器可以直接访问测试

*劣势*：
- URL 不够 RESTful（资源应该是 /users，而不是 /v1/users）
- 版本升级需要修改 URL

*2. 请求头版本*

```text
GET /api/users
Accept-Version: v1

# 或者
GET /api/users
Api-Version: 2025-01-15
```

```java
@RestController
@RequestMapping("/api/users")
public class UserController {

    @GetMapping
    public List<User> getUsers(@RequestHeader("Api-Version") String version) {
        if ("v1".equals(version)) {
            return userService.findAllV1();
        } else {
            return userService.findAllV2();
        }
    }
}
```

*优势*：
- URL 保持纯净
- 更符合 RESTful 理念

*劣势*：
- 不易于调试（浏览器无法直接设置 Header）
- 缓存策略复杂

*3. 查询参数版本*

```text
/api/users?version=1
/api/users?v=2
```

*优势*：
- 简单易用
- 易于测试

*劣势*：
- 与过滤参数混淆
- 不符合 RESTful 最佳实践

*4. Content-Type 版本*

```text
GET /api/users
Accept: application/vnd.myapp.v1+json

POST /api/users
Content-Type: application/vnd.myapp.v2+json
```

#tip[
  *推荐选择*：大多数项目使用 URL 路径版本，因为它最直观、最易用。如果追求严格的 RESTful，可以选择请求头版本。
]

*版本管理策略*：

```text
v1: 2023年发布，当前稳定版本
v2: 2024年发布，新增特性，向后不兼容
v3: 2025年规划中

策略：
- 同时维护 v1 和 v2
- v1 进入维护模式（只修复 bug，不新增功能）
- 鼓励用户迁移到 v2
- 提前 6-12 个月通知 v1 下线
```

==== 分页与过滤

处理大量数据时，分页和过滤是必不可少的。

*1. 分页*

*偏移量分页*（传统方式）：

```text
GET /api/users?page=0&size=10

Response:
{
  "content": [...],
  "pageable": {
    "pageNumber": 0,
    "pageSize": 10
  },
  "totalElements": 100,
  "totalPages": 10
}
```

```java
@GetMapping("/api/users")
public ResponseEntity<Page<User>> getUsers(
    @RequestParam(defaultValue = "0") int page,
    @RequestParam(defaultValue = "10") int size,
    @RequestParam(defaultValue = "id,asc") String sort
) {
    Pageable pageable = PageRequest.of(page, size, Sort.by(sort.split(",")));
    Page<User> users = userService.findAll(pageable);
    return ResponseEntity.ok(users);
}
```

*游标分页*（推荐，性能更好）：

```text
GET /api/users?limit=10&cursor=eyJpZCI6MTB9

Response:
{
  "data": [...],
  "pagination": {
    "limit": 10,
    "nextCursor": "eyJpZCI6MjB9",
    "hasMore": true
  }
}
```

*优势*：
- 性能更好（不需要计算总记录数）
- 数据一致性更好（插入/删除不影响分页）

*劣势*：
- 实现复杂
- 不支持跳转到指定页

#tip[
  对于大数据集（百万级），推荐使用游标分页。对于小数据集，偏移量分页更简单。
]

*2. 排序*

```text
GET /api/users?sort=name,asc
GET /api/users?sort=createdAt,desc&sort=name,asc
```

```java
@GetMapping("/api/users")
public ResponseEntity<List<User>> getUsers(
    @RequestParam(defaultValue = "id,asc") String sort
) {
    String[] sortParams = sort.split(",");
    Sort sorting = Sort.by(Sort.Direction.fromString(sortParams[1]), sortParams[0]);
    List<User> users = userService.findAll(sorting);
    return ResponseEntity.ok(users);
}
```

*3. 过滤*

*简单过滤*：

```text
GET /api/users?status=active&role=admin
GET /api/users?createdAtAfter=2024-01-01&createdAtBefore=2024-12-31
```

*高级过滤*（使用 RSQL 或类似语法）：

```text
GET /api/users?filter=status==active;age>18;name=like=*张*
```

```java
@GetMapping("/api/users")
public ResponseEntity<List<User>> getUsers(
    @RequestParam(required = false) String status,
    @RequestParam(required = false) String role,
    @RequestParam(required = false) LocalDate createdAtAfter
) {
    Specification<User> spec = Specification.where(null);

    if (status != null) {
        spec = spec.and((root, query, cb) ->
            cb.equal(root.get("status"), status));
    }

    if (role != null) {
        spec = spec.and((root, query, cb) ->
            cb.equal(root.get("role"), role));
    }

    if (createdAtAfter != null) {
        spec = spec.and((root, query, cb) ->
            cb.greaterThanOrEqualTo(root.get("createdAt"), createdAtAfter));
    }

    List<User> users = userRepository.findAll(spec);
    return ResponseEntity.ok(users);
}
```

*4. 字段选择*

减少网络传输，提高性能。

```text
GET /api/users?fields=id,name,email
```

```java
@GetMapping("/api/users")
public ResponseEntity<List<Map<String, Object>>> getUsers(
    @RequestParam(required = false) String fields
) {
    List<User> users = userService.findAll();

    if (fields != null) {
        String[] fieldArray = fields.split(",");
        List<Map<String, Object>> result = users.stream()
            .map(user -> {
                Map<String, Object> map = new HashMap<>();
                for (String field : fieldArray) {
                    map.put(field, getFieldvalue(user, field));
                }
                return map;
            })
            .collect(Collectors.toList());
        return ResponseEntity.ok(result);
    }

    return ResponseEntity.ok(users);
}
```

#note[
  字段选择会增加代码复杂度，权衡利弊后决定是否实现。对于公共 API，字段选择很有价值；对于内部 API，可以省略。
]

==== HATEOAS（超媒体即应用状态引擎）

HATEOAS（Hypermedia As The Engine Of Application State）是 REST 的最高成熟度级别（Level 3），通过在响应中包含相关链接，提高 API 的可发现性。

*基本示例*：

```json
GET /api/users/1

{
  "id": 1,
  "name": "张三",
  "email": "zhangsan@example.com",
  "_links": {
    "self": {
      "href": "/api/users/1"
    },
    "orders": {
      "href": "/api/users/1/orders"
    },
    "update": {
      "href": "/api/users/1",
      "method": "PUT"
    },
    "delete": {
      "href": "/api/users/1",
      "method": "DELETE"
    }
  }
}
```

*Spring HATEOAS 实现*：

```java
import org.springframework.hateoas.EntityModel;
import org.springframework.hateoas.server.mvc.WebMvcLinkBuilder;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @GetMapping("/{id}")
    public EntityModel<User> getUser(@PathVariable Long id) {
        User user = userService.findById(id).orElseThrow();

        EntityModel<User> resource = EntityModel.of(user);

        // 添加链接
        resource.add(WebMvcLinkBuilder.linkTo(
            WebMvcLinkBuilder.methodOn(UserController.class).getUser(id)
        ).withSelfRel());

        resource.add(WebMvcLinkBuilder.linkTo(
            WebMvcLinkBuilder.methodOn(UserController.class).getOrders(id)
        ).withRel("orders"));

        resource.add(WebMvcLinkBuilder.linkTo(
            WebMvcLinkBuilder.methodOn(UserController.class).updateUser(id, null)
        ).withRel("update"));

        return resource;
    }
}
```

*依赖*：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-hateoas</artifactId>
</dependency>
```

*HATEOAS 的优势*：

1. *可发现性*：客户端可以通过链接自主探索 API
2. *解耦*：客户端不需要硬编码 URL
3. *灵活性*：服务端可以改变 URL 结构而不影响客户端

*HATEOAS 的劣势*：

1. *复杂性*：实现和维护成本高
2. *学习曲线*：客户端需要理解 HATEOAS 概念
3. *过度设计*：对于简单 API 可能不必要

#tip[
  大多数项目不需要实现完整的 HATEOAS。简单的做法是在响应中添加几个关键链接即可，无需严格遵循 Level 3 REST。
]

==== 最佳实践总结

*1. 命名规范*

- 使用名词，不使用动词
- 使用复数形式
- 使用小写字母和连字符
- 避免暴露内部实现

*2. HTTP 方法*

- GET：查询（安全、幂等）
- POST：创建（非幂等）
- PUT：全量更新（幂等）
- PATCH：部分更新（非幂等）
- DELETE：删除（幂等）

*3. 状态码*

- 2xx：成功
- 4xx：客户端错误
- 5xx：服务器错误
- 使用具体的状态码，不要全部返回 200

*4. 数据格式*

- 使用 JSON
- 日期时间使用 ISO 8601
- 统一错误响应格式

*5. 版本控制*

- 使用 URL 路径版本（推荐）
- 保持向后兼容
- 提前通知旧版本下线

*6. 分页与过滤*

- 支持分页（偏移量或游标）
- 支持排序
- 支持过滤
- 可选支持字段选择

*7. 安全性*

- 使用 HTTPS
- 实施认证和授权
- 防止 SQL 注入、XSS 等攻击
- 实施限流

*8. 文档化*

- 使用 OpenAPI/Swagger
- 提供示例请求和响应
- 说明错误码和含义

#note[
  遵循这些最佳实践可以提高 API 的可用性、可维护性和可扩展性，使 API 更加专业和可靠。
]

#fancy-divider

本节介绍了 HTTP 协议基础、Spring MVC 架构和 RESTful API 设计规范。理解这些概念是构建高质量 Web API 的基础。

== 请求处理：参数接收与数据绑定

Spring MVC 提供了多种注解来接收 HTTP 请求中的参数，每种注解适用于不同的场景。

#tip[
  本节同时提供前端 TypeScript + axios 的对应代码，帮助全栈开发者理解前后端交互。
]

=== #text("@PathVariable")：路径变量

从 URL 路径中提取变量值。

==== 基本用法

*后端代码*：

```java
@GetMapping("/api/users/{id}")
public User getUser(@PathVariable Long id) {
    return userService.findById(id);
}
```

*请求*：`GET /api/users/123`

*提取*：`id = 123`

*前端代码（TypeScript + axios）*：

```typescript
import axios from 'axios';

// 定义用户接口
interface User {
  id: number;
  name: string;
  email: string;
}

// 获取单个用户
async function getUser(id: number): Promise<User> {
  const response = await axios.get<User>(`/api/users/${id}`);
  return response.data;
}

// 使用示例
const user = await getUser(123);
console.log(user.name);
```

==== 多个路径变量

*后端代码*：

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

*前端代码*：

```typescript
interface Order {
  id: number;
  userId: number;
  productId: number;
  amount: number;
}

async function getOrder(userId: number, orderId: number): Promise<Order> {
  const response = await axios.get<Order>(
    `/api/users/${userId}/orders/${orderId}`
  );
  return response.data;
}

// 使用示例
const order = await getOrder(1, 100);
console.log(order.amount);
```

==== 自定义变量名

当方法参数名与路径变量名不一致时，需要显式指定：

```java
@GetMapping("/api/users/{id}")
public User getUser(@PathVariable("id") Long userId) {
    return userService.findById(userId);
}
```

==== 可选路径变量

*后端代码*：

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

*前端代码*：

```typescript
// 方案1：根据是否有id调用不同接口
async function getUsers(id?: number): Promise<User | User[]> {
  if (id) {
    const response = await axios.get<User>(`/api/users/${id}`);
    return response.data;
  } else {
    const response = await axios.get<User[]>('/api/users');
    return response.data;
  }
}

// 使用示例
const allUsers = await getUsers();       // 获取所有用户
const oneUser = await getUsers(123);     // 获取单个用户
```

=== #text("@RequestParam")：请求参数

从查询字符串（Query String）或表单数据中提取参数。

==== 基本用法

*后端代码*：

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

*前端代码*：

```typescript
async function searchUsers(name: string, age: number): Promise<User[]> {
  const response = await axios.get<User[]>('/api/users', {
    params: {
      name: name,
      age: age
    }
  });
  return response.data;
}

// 使用示例
const users = await searchUsers('John', 25);
console.log(users.length);
```

#tip[
  axios 的 `params` 选项会自动将对象序列化为查询字符串，无需手动拼接 URL。
]

==== 可选参数

*后端代码*：

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

*前端代码*：

```typescript
interface SearchParams {
  name?: string;
  age?: number;
}

async function searchUsers(params: SearchParams = {}): Promise<User[]> {
  const response = await axios.get<User[]>('/api/users', {
    params: params  // axios 会自动忽略 undefined 的值
  });
  return response.data;
}

// 使用示例
const allUsers = await searchUsers();                    // 无参数
const byName = await searchUsers({ name: 'John' });      // 只有 name
const byAge = await searchUsers({ age: 25 });            // 只有 age
const both = await searchUsers({ name: 'John', age: 25 }); // 都有
```

==== 默认值

*后端代码*：

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

*前端代码*：

```typescript
interface PageParams {
  page?: number;
  size?: number;
  sort?: string;
}

async function getUsers(params: PageParams = {}): Promise<Page<User>> {
  const response = await axios.get<Page<User>>('/api/users', {
    params: {
      page: params.page ?? 0,      // 默认值在前端也可以设置
      size: params.size ?? 10,
      sort: params.sort ?? 'name,asc'
    }
  });
  return response.data;
}

// 使用示例
const firstPage = await getUsers();                              // 使用默认值
const customPage = await getUsers({ page: 2, size: 20 });       // 自定义分页
```

#note[
  默认值可以在后端设置（推荐），也可以在前端设置。建议在后端设置，保持单一数据源。
]

==== 多值参数

*后端代码*：

```java
@GetMapping("/api/users")
public List<User> getUsers(@RequestParam List<Long> ids) {
    return userService.findByIds(ids);
}
```

*请求*：`GET /api/users?ids=1&ids=2&ids=3`

*提取*：`ids = [1, 2, 3]`

*前端代码*：

```typescript
async function getUsersByIds(ids: number[]): Promise<User[]> {
  const response = await axios.get<User[]>('/api/users', {
    params: {
      ids: ids  // axios 会自动序列化为 ?ids=1&ids=2&ids=3
    }
  });
  return response.data;
}

// 使用示例
const users = await getUsersByIds([1, 2, 3]);
console.log(users.length);  // 3
```

==== 参数名映射

*后端代码*：

```java
@GetMapping("/api/users")
public List<User> getUsers(@RequestParam("user_name") String userName) {
    return userService.findByName(userName);
}
```

*请求*：`GET /api/users?user_name=John`

*前端代码*：

```typescript
async function searchUsers(userName: string): Promise<User[]> {
  const response = await axios.get<User[]>('/api/users', {
    params: {
      user_name: userName  // 注意参数名要与后端一致
    }
  });
  return response.data;
}
```

=== #text("@RequestBody")：请求体

将 HTTP 请求体（通常是 JSON）反序列化为 Java 对象。

==== 基本用法

*后端代码*：

```java
@PostMapping("/api/users")
public ResponseEntity<User> createUser(@RequestBody User user) {
    User saved = userService.save(user);
    return ResponseEntity.status(HttpStatus.CREATED).body(saved);
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

*前端代码*：

```typescript
// 创建用户的请求DTO
interface CreateUserRequest {
  name: string;
  email: string;
  age: number;
}

async function createUser(userData: CreateUserRequest): Promise<User> {
  const response = await axios.post<User>('/api/users', userData);
  return response.data;
}

// 使用示例
const newUser = await createUser({
  name: 'John Doe',
  email: 'john@example.com',
  age: 25
});
console.log(newUser.id);  // 返回的用户ID
```

*完整示例（带错误处理）*：

```typescript
async function createUser(userData: CreateUserRequest): Promise<User> {
  try {
    const response = await axios.post<User>('/api/users', userData, {
      headers: {
        'Content-Type': 'application/json'
      }
    });
    return response.data;
  } catch (error) {
    if (axios.isAxiosError(error)) {
      if (error.response?.status === 400) {
        throw new Error('请求参数错误：' + error.response.data.message);
      } else if (error.response?.status === 409) {
        throw new Error('用户已存在');
      } else {
        throw new Error('创建用户失败');
      }
    }
    throw error;
  }
}
```

#tip[
  axios 默认会自动设置 `Content-Type: application/json`，并序列化 JavaScript 对象为 JSON 字符串。
]

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

== 参数校验：Bean Validation 实战

参数校验是保证数据质量的第一道防线，Spring Boot 集成了 Bean Validation（JSR 380）提供强大的校验功能。

=== Bean Validation 基础

Bean Validation 是一套 Java Bean 验证规范，Hibernate Validator 是其参考实现。

==== 依赖引入

*Spring Boot 2.x*：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-validation</artifactId>
</dependency>
```

*Spring Boot 3.x*：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-validation</artifactId>
</dependency>
```

#note[
  Spring Boot 3.x 使用 Jakarta Validation（包名从 `javax.validation` 改为 `jakarta.validation`）。
]

==== 常用校验注解

#tex-table(
  ("注解", "说明", "示例"),
  ("@NotNull", "不能为 null", "任何类型"),
  ("@NotEmpty", "不能为 null 或空", "String、Collection、Map、Array"),
  ("@NotBlank", "不能为 null 或空白", "String"),
  ("@Min(value)", "最小值", "数字类型"),
  ("@Max(value)", "最大值", "数字类型"),
  ("@DecimalMin(value)", "最小值（支持小数）", "BigDecimal、String"),
  ("@DecimalMax(value)", "最大值（支持小数）", "BigDecimal、String"),
  ("@Size(min, max)", "长度范围", "String、Collection、Array"),
  ("@Email", "邮箱格式", "String"),
  ("@Pattern(regexp)", "正则表达式", "String"),
  ("@Past", "必须是过去的日期", "Date、LocalDate"),
  ("@Future", "必须是未来的日期", "Date、LocalDate"),
  ("@AssertTrue", "必须为 true", "boolean"),
  ("@AssertFalse", "必须为 false", "boolean"),
)

=== #text("@Valid")：启用校验

`@Valid` 注解用于触发 Bean Validation 校验。

==== 基本用法

*DTO 定义*：

```java
public class UserCreateRequest {

    @NotBlank(message = "Username is required")
    @Size(min = 3, max = 20, message = "Username must be between 3 and 20 characters")
    private String username;

    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    private String email;

    @NotNull(message = "Age is required")
    @Min(value = 1, message = "Age must be at least 1")
    @Max(value = 150, message = "Age must be at most 150")
    private Integer age;

    @NotBlank(message = "Password is required")
    @Size(min = 8, message = "Password must be at least 8 characters")
    @Pattern(regexp = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d).*$",
             message = "Password must contain uppercase, lowercase and digit")
    private String password;

    // getters and setters
}
```

*Controller*：

```java
@PostMapping("/api/users")
public ResponseEntity<User> createUser(
    @Valid @RequestBody UserCreateRequest request
) {
    User user = userService.create(request);
    return ResponseEntity.status(HttpStatus.CREATED).body(user);
}
```

*校验失败响应*：

```http
HTTP/1.1 400 Bad Request
Content-Type: application/json

{
  "timestamp": "2024-01-01T00:00:00.000+00:00",
  "status": 400,
  "error": "Bad Request",
  "message": "Validation failed",
  "errors": [
    {
      "field": "username",
      "rejectedValue": "ab",
      "message": "Username must be between 3 and 20 characters"
    },
    {
      "field": "email",
      "rejectedValue": "invalid-email",
      "message": "Invalid email format"
    }
  ]
}
```

==== 嵌套对象校验

如果 DTO 中包含其他对象，需要使用 `@Valid` 级联校验。

```java
public class OrderCreateRequest {

    @NotNull(message = "User is required")
    @Valid  // 级联校验
    private UserCreateRequest user;

    @NotEmpty(message = "Items are required")
    @Valid  // 级联校验列表中的每个元素
    private List<OrderItemRequest> items;

    // getters and setters
}

public class OrderItemRequest {

    @NotNull(message = "Product ID is required")
    private Long productId;

    @Min(value = 1, message = "Quantity must be at least 1")
    private Integer quantity;

    // getters and setters
}
```

*Controller*：

```java
@PostMapping("/api/orders")
public ResponseEntity<Order> createOrder(
    @Valid @RequestBody OrderCreateRequest request
) {
    Order order = orderService.create(request);
    return ResponseEntity.status(HttpStatus.CREATED).body(order);
}
```

#note[
  如果没有 `@Valid`，嵌套对象不会进行校验。
]

=== 分组校验

不同场景可能需要不同的校验规则，分组校验可以解决这个问题。

==== 定义分组接口

```java
// 创建分组
public interface CreateGroup {}

// 更新分组
public interface UpdateGroup {}
```

==== DTO 中指定分组

```java
public class UserRequest {

    // ID：更新时必填，创建时不需要
    @Null(groups = CreateGroup.class, message = "ID must be null for creation")
    @NotNull(groups = UpdateGroup.class, message = "ID is required for update")
    private Long id;

    // 用户名：创建和更新都需要
    @NotBlank(groups = {CreateGroup.class, UpdateGroup.class},
              message = "Username is required")
    @Size(min = 3, max = 20,
          groups = {CreateGroup.class, UpdateGroup.class})
    private String username;

    // 邮箱：仅创建时需要
    @NotBlank(groups = CreateGroup.class, message = "Email is required")
    @Email(groups = CreateGroup.class)
    private String email;

    // 年龄：创建和更新都需要
    @Min(value = 1, groups = {CreateGroup.class, UpdateGroup.class})
    @Max(value = 150, groups = {CreateGroup.class, UpdateGroup.class})
    private Integer age;

    // getters and setters
}
```

==== Controller 中使用分组

```java
@RestController
@RequestMapping("/api/users")
public class UserController {

    // 创建：使用 CreateGroup
    @PostMapping
    public ResponseEntity<User> createUser(
        @Validated(CreateGroup.class) @RequestBody UserRequest request
    ) {
        User user = userService.create(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(user);
    }

    // 更新：使用 UpdateGroup
    @PutMapping("/{id}")
    public ResponseEntity<User> updateUser(
        @PathVariable Long id,
        @Validated(UpdateGroup.class) @RequestBody UserRequest request
    ) {
        request.setId(id); // 设置 ID
        User user = userService.update(request);
        return ResponseEntity.ok(user);
    }
}
```

#note[
  分组校验使用 `@Validated` 而不是 `@Valid`，因为 `@Valid` 不支持分组。
]

=== 自定义校验器

当内置注解无法满足需求时，可以创建自定义校验注解和校验器。

==== 创建自定义注解

```java
@Target({ElementType.FIELD, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = PhoneValidator.class)
@Documented
public @interface ValidPhone {

    String message() default "Invalid phone number";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}
```

==== 实现校验器

```java
public class PhoneValidator implements ConstraintValidator<ValidPhone, String> {

    private static final Pattern PHONE_PATTERN =
        Pattern.compile("^1[3-9]\\d{9}$"); // 中国大陆手机号

    @Override
    public void initialize(ValidPhone constraintAnnotation) {
        // 初始化逻辑（可选）
    }

    @Override
    public boolean isValid(String phone, ConstraintValidatorContext context) {
        if (phone == null || phone.isEmpty()) {
            return true; // null 或空由 @NotBlank 处理
        }
        return PHONE_PATTERN.matcher(phone).matches();
    }
}
```

==== 使用自定义注解

```java
public class UserCreateRequest {

    @NotBlank(message = "Phone is required")
    @ValidPhone(message = "Invalid Chinese phone number")
    private String phone;

    // other fields...
}
```

==== 复杂校验：密码强度

```java
@Target({ElementType.FIELD, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = PasswordStrengthValidator.class)
@Documented
public @interface StrongPassword {

    String message() default "Password is not strong enough";

    int minLength() default 8;

    boolean requireUppercase() default true;

    boolean requireLowercase() default true;

    boolean requireDigit() default true;

    boolean requireSpecial() default true;

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}

public class PasswordStrengthValidator
    implements ConstraintValidator<StrongPassword, String> {

    private int minLength;
    private boolean requireUppercase;
    private boolean requireLowercase;
    private boolean requireDigit;
    private boolean requireSpecial;

    @Override
    public void initialize(StrongPassword constraintAnnotation) {
        this.minLength = constraintAnnotation.minLength();
        this.requireUppercase = constraintAnnotation.requireUppercase();
        this.requireLowercase = constraintAnnotation.requireLowercase();
        this.requireDigit = constraintAnnotation.requireDigit();
        this.requireSpecial = constraintAnnotation.requireSpecial();
    }

    @Override
    public boolean isValid(String password, ConstraintValidatorContext context) {
        if (password == null || password.length() < minLength) {
            return false;
        }

        if (requireUppercase && !password.matches(".*[A-Z].*")) {
            return false;
        }

        if (requireLowercase && !password.matches(".*[a-z].*")) {
            return false;
        }

        if (requireDigit && !password.matches(".*\\d.*")) {
            return false;
        }

        if (requireSpecial && !password.matches(".*[^a-zA-Z0-9].*")) {
            return false;
        }

        return true;
    }
}
```

*使用*：

```java
public class UserCreateRequest {

    @StrongPassword(
        minLength = 10,
        requireUppercase = true,
        requireLowercase = true,
        requireDigit = true,
        requireSpecial = true,
        message = "Password must be at least 10 characters with uppercase, lowercase, digit and special character"
    )
    private String password;
}
```

=== 国际化错误消息

支持多语言的错误消息提示。

==== 配置消息文件

*src/main/resources/ValidationMessages.properties*（默认）：

```properties
user.username.notblank=Username is required
user.username.size=Username must be between {min} and {max} characters
user.email.invalid=Invalid email format
user.age.range=Age must be between {min} and {max}
```

*src/main/resources/ValidationMessages_zh_CN.properties*（中文）：

```properties
user.username.notblank=\u7528\u6237\u540d\u4e0d\u80fd\u4e3a\u7a7a
user.username.size=\u7528\u6237\u540d\u5fc5\u987b\u5728 {min} \u5230 {max} \u4e2a\u5b57\u7b26\u4e4b\u95f4
user.email.invalid=\u90ae\u7bb1\u683c\u5f0f\u4e0d\u6b63\u786e
user.age.range=\u5e74\u9f84\u5fc5\u987b\u5728 {min} \u5230 {max} \u4e4b\u95f4
```

==== DTO 中使用消息键

```java
public class UserCreateRequest {

    @NotBlank(message = "{user.username.notblank}")
    @Size(min = 3, max = 20, message = "{user.username.size}")
    private String username;

    @NotBlank(message = "{user.email.notblank}")
    @Email(message = "{user.email.invalid}")
    private String email;

    @NotNull(message = "{user.age.notnull}")
    @Min(value = 1, message = "{user.age.min}")
    @Max(value = 150, message = "{user.age.max}")
    private Integer age;
}
```

==== 配置 MessageSource

*application.yml*：

```yaml
spring:
  messages:
    basename: i18n/messages,ValidationMessages
    encoding: UTF-8
```

==== 根据 Locale 返回消息

```java
@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private MessageSource messageSource;

    @PostMapping
    public ResponseEntity<User> createUser(
        @Valid @RequestBody UserCreateRequest request,
        Locale locale
    ) {
        User user = userService.create(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(user);
    }
}
```

#note[
  Spring 会根据请求头 `Accept-Language` 自动解析 Locale。
]

=== 全局异常处理

将校验异常转换为统一的错误响应。

==== 处理 MethodArgumentNotValidException

```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiResponse<Map<String, String>>> handleValidationExceptions(
        MethodArgumentNotValidException ex
    ) {
        Map<String, String> errors = new HashMap<>();

        ex.getBindingResult().getFieldErrors().forEach(error -> {
            errors.put(error.getField(), error.getDefaultMessage());
        });

        ApiResponse<Map<String, String>> response = ApiResponse.error(
            HttpStatus.BAD_REQUEST.value(),
            "Validation failed"
        );
        response.setData(errors);

        return ResponseEntity.badRequest().body(response);
    }
}
```

*响应*：

```json
{
  "code": 400,
  "message": "Validation failed",
  "data": {
    "username": "Username must be between 3 and 20 characters",
    "email": "Invalid email format"
  },
  "timestamp": 1704067200000
}
```

==== 处理 ConstraintViolationException

对于 `@RequestParam`、`@PathVariable` 等参数的校验失败，会抛出 `ConstraintViolationException`。

```java
@ExceptionHandler(ConstraintViolationException.class)
public ResponseEntity<ApiResponse<List<String>>> handleConstraintViolation(
    ConstraintViolationException ex
) {
    List<String> errors = ex.getConstraintViolations().stream()
        .map(violation -> violation.getMessage())
        .collect(Collectors.toList());

    ApiResponse<List<String>> response = ApiResponse.error(
        HttpStatus.BAD_REQUEST.value(),
        "Validation failed"
    );
    response.setData(errors);

    return ResponseEntity.badRequest().body(response);
}
```

=== 编程式校验

除了注解方式，还可以手动进行校验。

==== 使用 Validator

```java
@Service
public class UserService {

    @Autowired
    private Validator validator;

    public User create(UserCreateRequest request) {
        // 手动校验
        Set<ConstraintViolation<UserCreateRequest>> violations =
            validator.validate(request);

        if (!violations.isEmpty()) {
            throw new ConstraintViolationException(violations);
        }

        // 业务逻辑...
    }
}
```

==== 使用 BindingResult

```java
@PostMapping("/api/users")
public ResponseEntity<?> createUser(
    @Valid @RequestBody UserCreateRequest request,
    BindingResult bindingResult
) {
    if (bindingResult.hasErrors()) {
        List<String> errors = bindingResult.getFieldErrors().stream()
            .map(error -> error.getField() + ": " + error.getDefaultMessage())
            .collect(Collectors.toList());

        return ResponseEntity.badRequest().body(errors);
    }

    User user = userService.create(request);
    return ResponseEntity.status(HttpStatus.CREATED).body(user);
}
```

#note[
  如果使用 `BindingResult`，必须紧跟在 `@Valid` 参数之后。
]

=== 校验最佳实践

#tex-table(
  ("实践", "说明", "示例"),
  ("DTO 层校验", "在 DTO 上添加校验注解", "UserCreateRequest"),
  ("分层校验", "Controller 校验格式，Service 校验业务", "邮箱唯一性"),
  ("使用分组", "不同场景使用不同校验规则", "Create vs Update"),
  ("自定义注解", "封装复杂校验逻辑", "@ValidPhone"),
  ("国际化", "支持多语言错误消息", "ValidationMessages_zh_CN"),
  ("统一异常处理", "全局捕获校验异常", "@RestControllerAdvice"),
  ("清晰错误消息", "提供有用的错误提示", "具体说明哪个字段出错"),
)

==== 完整示例

```java
// DTO
public class UserCreateRequest {

    @NotBlank(groups = CreateGroup.class, message = "{user.username.notblank}")
    @Size(min = 3, max = 20, groups = CreateGroup.class,
          message = "{user.username.size}")
    private String username;

    @NotBlank(groups = CreateGroup.class, message = "{user.email.notblank}")
    @Email(groups = CreateGroup.class, message = "{user.email.invalid}")
    private String email;

    @ValidPhone(groups = CreateGroup.class)
    private String phone;

    @StrongPassword(groups = CreateGroup.class)
    private String password;

    // getters and setters
}

// Controller
@RestController
@RequestMapping("/api/v1/users")
public class UserController {

    @PostMapping
    public ResponseEntity<ApiResponse<UserDTO>> createUser(
        @Validated(CreateGroup.class) @RequestBody UserCreateRequest request
    ) {
        User user = userService.create(request);
        return ResponseEntity.status(HttpStatus.CREATED)
            .body(ApiResponse.success("User created", convertToDTO(user)));
    }
}

// Service
@Service
public class UserService {

    public User create(UserCreateRequest request) {
        // 业务校验：邮箱唯一性
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new BusinessException("Email already exists");
        }

        // 业务校验：手机号唯一性
        if (userRepository.existsByPhone(request.getPhone())) {
            throw new BusinessException("Phone number already exists");
        }

        // 保存用户...
    }
}

// 全局异常处理
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiResponse<Map<String, String>>> handleValidation(
        MethodArgumentNotValidException ex
    ) {
        Map<String, String> errors = ex.getBindingResult().getFieldErrors().stream()
            .collect(Collectors.toMap(
                FieldError::getField,
                FieldError::getDefaultMessage,
                (e1, e2) -> e1
            ));

        return ResponseEntity.badRequest()
            .body(ApiResponse.error(400, "Validation failed", errors));
    }

    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<ApiResponse<Void>> handleBusinessException(
        BusinessException ex
    ) {
        return ResponseEntity.status(HttpStatus.CONFLICT)
            .body(ApiResponse.error(409, ex.getMessage()));
    }
}
```

#fancy-divider

本节详细介绍了 Bean Validation 的完整使用方案，包括基础注解、分组校验、自定义校验器、国际化以及全局异常处理。合理的参数校验能够提高系统的健壮性和用户体验。

== 全局异常处理：#text("@ControllerAdvice") + #text("@ExceptionHandler")

全局异常处理是构建健壮 Web 应用的关键，能够统一处理各种异常情况，提供友好的错误响应。

=== 异常分类

在 Spring Boot 中，异常可以分为以下几类：

==== 客户端异常（4xx）

由客户端请求错误引起，应该返回 4xx 状态码。

#tex-table(
  ("异常类型", "HTTP 状态码", "说明"),
  ("MethodArgumentNotValidException", "400", "参数校验失败"),
  ("ConstraintViolationException", "400", "约束违反"),
  ("MissingServletRequestParameterException", "400", "缺少请求参数"),
  ("TypeMismatchException", "400", "类型转换失败"),
  ("HttpMessageNotReadableException", "400", "请求体解析失败"),
  ("HttpRequestMethodNotSupportedException", "405", "不支持的 HTTP 方法"),
  ("NoSuchRequestHandlingMethodException", "404", "请求映射不存在"),
  ("ResourceNotFoundException", "404", "资源不存在"),
  ("AccessDeniedException", "403", "访问被拒绝"),
),

==== 服务器异常（5xx）

由服务器端错误引起，应该返回 5xx 状态码。

#tex-table(
  ("异常类型", "HTTP 状态码", "说明"),
  ("NullPointerException", "500", "空指针异常"),
  ("IllegalArgumentException", "500", "非法参数"),
  ("IllegalStateException", "500", "非法状态"),
  ("DataAccessException", "500", "数据访问异常"),
  ("TransactionException", "500", "事务异常"),
  ("RuntimeException", "500", "运行时异常"),
),

==== 业务异常

由业务逻辑错误引起，根据具体情况返回不同的状态码。

```java
// 资源已存在
public class ResourceAlreadyExistsException extends RuntimeException {
    public ResourceAlreadyExistsException(String message) {
        super(message);
    }
}

// 业务规则违反
public class BusinessException extends RuntimeException {
    private int errorCode;

    public BusinessException(int errorCode, String message) {
        super(message);
        this.errorCode = errorCode;
    }

    public int getErrorCode() {
        return errorCode;
    }
}

// 认证失败
public class AuthenticationException extends RuntimeException {
    public AuthenticationException(String message) {
        super(message);
    }
}
```

=== #text("@ControllerAdvice") 基础

`@ControllerAdvice` 是一个特殊的 `@Component`，用于全局处理 Controller 层的异常。

==== 基本用法

```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ApiResponse<Void>> handleResourceNotFound(
        ResourceNotFoundException ex
    ) {
        ApiResponse<Void> response = ApiResponse.error(
            HttpStatus.NOT_FOUND.value(),
            ex.getMessage()
        );
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
    }

    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<ApiResponse<Void>> handleBusinessException(
        BusinessException ex
    ) {
        ApiResponse<Void> response = ApiResponse.error(
            ex.getErrorCode(),
            ex.getMessage()
        );
        return ResponseEntity.status(ex.getErrorCode()).body(response);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiResponse<Void>> handleGenericException(
        Exception ex
    ) {
        // 记录日志
        log.error("Unexpected error", ex);

        ApiResponse<Void> response = ApiResponse.error(
            HttpStatus.INTERNAL_SERVER_ERROR.value(),
            "An unexpected error occurred"
        );
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
    }
}
```

#note[
  `@RestControllerAdvice` = `@ControllerAdvice` + `@ResponseBody`，直接返回 JSON。
]

==== 指定处理的 Controller

可以限制 `@ControllerAdvice` 只处理特定的 Controller。

```java
// 只处理指定包下的 Controller
@RestControllerAdvice("com.example.api.v1")
public class V1ExceptionHandler { ... }

// 只处理指定的 Controller 类
@RestControllerAdvice(assignableTypes = {UserController.class, OrderController.class})
public class SpecificExceptionHandler { ... }

// 只处理带有特定注解的 Controller
@RestControllerAdvice(annotations = RestController.class)
public class RestExceptionHandler { ... }
```

=== #text("@ExceptionHandler") 详解

`@ExceptionHandler` 注解用于指定处理方法要捕获的异常类型。

==== 优先级规则

当多个 `@ExceptionHandler` 都能处理同一个异常时，按照以下规则选择：

1. *最具体匹配*：精确匹配的异常优先于父类异常
2. *同级别*：定义在更具体的 `@ControllerAdvice` 中的优先
3. *默认*：如果没有匹配，使用 Spring Boot 默认的异常处理

```java
@RestControllerAdvice
public class ExceptionHandler {

    // 优先级最高：精确匹配
    @ExceptionHandler(UserNotFoundException.class)
    public ResponseEntity<?> handleUserNotFound(UserNotFoundException ex) { ... }

    // 优先级次之：父类异常
    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<?> handleResourceNotFound(ResourceNotFoundException ex) { ... }

    // 优先级最低：通用异常
    @ExceptionHandler(Exception.class)
    public ResponseEntity<?> handleGeneric(Exception ex) { ... }
}
```

==== 获取异常信息

可以从异常对象中提取详细信息。

```java
@ExceptionHandler(MethodArgumentNotValidException.class)
public ResponseEntity<ApiResponse<Map<String, String>>> handleValidation(
    MethodArgumentNotValidException ex
) {
    // 获取所有字段错误
    Map<String, String> errors = ex.getBindingResult().getFieldErrors().stream()
        .collect(Collectors.toMap(
            FieldError::getField,
            FieldError::getDefaultMessage,
            (e1, e2) -> e1  // 如果有重复，保留第一个
        ));

    // 获取所有全局错误
    List<String> globalErrors = ex.getBindingResult().getGlobalErrors().stream()
        .map(ObjectError::getDefaultMessage)
        .collect(Collectors.toList());

    ApiResponse<Map<String, String>> response = ApiResponse.error(
        HttpStatus.BAD_REQUEST.value(),
        "Validation failed"
    );
    response.setData(errors);

    return ResponseEntity.badRequest().body(response);
}
```

==== 获取请求信息

可以访问当前的 HttpServletRequest 获取请求详情。

```java
@ExceptionHandler(Exception.class)
public ResponseEntity<ApiResponse<Map<String, Object>>> handleException(
    Exception ex,
    HttpServletRequest request
) {
    Map<String, Object> errorDetails = new HashMap<>();
    errorDetails.put("timestamp", LocalDateTime.now());
    errorDetails.put("status", HttpStatus.INTERNAL_SERVER_ERROR.value());
    errorDetails.put("error", HttpStatus.INTERNAL_SERVER_ERROR.getReasonPhrase());
    errorDetails.put("message", ex.getMessage());
    errorDetails.put("path", request.getRequestURI());
    errorDetails.put("method", request.getMethod());

    // 生产环境不要暴露堆栈跟踪
    if (isDevelopmentEnvironment()) {
        errorDetails.put("stackTrace", getStackTrace(ex));
    }

    ApiResponse<Map<String, Object>> response = ApiResponse.error(
        HttpStatus.INTERNAL_SERVER_ERROR.value(),
        "Internal server error"
    );
    response.setData(errorDetails);

    return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
}
```

=== 错误码设计

良好的错误码设计能够帮助前端准确识别错误类型。

==== 错误码规范

推荐采用分段式错误码：

```
格式：XXXYYZZZ
- XXX: 模块代码（100-999）
- YY: 错误类型（00-99）
- ZZZ: 具体错误（000-999）

示例：
1000001 - 用户模块 - 参数错误 - 用户名为空
1000002 - 用户模块 - 参数错误 - 邮箱格式错误
1001001 - 用户模块 - 业务错误 - 用户已存在
1001002 - 用户模块 - 业务错误 - 用户不存在
2000001 - 订单模块 - 参数错误 - 商品 ID 为空
2001001 - 订单模块 - 业务错误 - 库存不足
```

==== 错误码枚举

```java
public enum ErrorCode {

    // 成功
    SUCCESS(2000000, "Success"),

    // 通用错误 (000xxx)
    BAD_REQUEST(4000000, "Bad request"),
    UNAUTHORIZED(4010000, "Unauthorized"),
    FORBIDDEN(4030000, "Forbidden"),
    NOT_FOUND(4040000, "Resource not found"),
    INTERNAL_ERROR(5000000, "Internal server error"),

    // 用户模块 (100xxx)
    USER_NOT_FOUND(1001001, "User not found"),
    USER_ALREADY_EXISTS(1001002, "User already exists"),
    INVALID_USERNAME(1000001, "Invalid username"),
    INVALID_EMAIL(1000002, "Invalid email format"),
    INVALID_PASSWORD(1000003, "Invalid password"),

    // 订单模块 (200xxx)
    ORDER_NOT_FOUND(2001001, "Order not found"),
    INSUFFICIENT_STOCK(2001002, "Insufficient stock"),
    ORDER_ALREADY_PAID(2001003, "Order already paid"),

    // 产品模块 (300xxx)
    PRODUCT_NOT_FOUND(3001001, "Product not found"),
    PRODUCT_DISABLED(3001002, "Product is disabled");

    private final int code;
    private final String message;

    ErrorCode(int code, String message) {
        this.code = code;
        this.message = message;
    }

    public int getCode() {
        return code;
    }

    public String getMessage() {
        return message;
    }
}
```

==== 统一异常类

```java
public class ApiException extends RuntimeException {

    private final ErrorCode errorCode;
    private final Object[] args;  // 消息参数

    public ApiException(ErrorCode errorCode) {
        super(errorCode.getMessage());
        this.errorCode = errorCode;
        this.args = new Object[0];
    }

    public ApiException(ErrorCode errorCode, Object... args) {
        super(formatMessage(errorCode.getMessage(), args));
        this.errorCode = errorCode;
        this.args = args;
    }

    public ApiException(ErrorCode errorCode, Throwable cause) {
        super(errorCode.getMessage(), cause);
        this.errorCode = errorCode;
        this.args = new Object[0];
    }

    public int getCode() {
        return errorCode.getCode();
    }

    public String getErrorMessage() {
        return errorCode.getMessage();
    }

    private static String formatMessage(String message, Object[] args) {
        if (args == null || args.length == 0) {
            return message;
        }
        return String.format(message.replace("{}", "%s"), args);
    }
}
```

*使用*：

```java
@Service
public class UserService {

    public User create(UserCreateRequest request) {
        // 检查用户是否已存在
        if (userRepository.existsByUsername(request.getUsername())) {
            throw new ApiException(ErrorCode.USER_ALREADY_EXISTS);
        }

        // 检查邮箱是否已存在
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new ApiException(ErrorCode.INVALID_EMAIL, request.getEmail());
        }

        // 创建用户...
    }

    public User findById(Long id) {
        return userRepository.findById(id)
            .orElseThrow(() -> new ApiException(ErrorCode.USER_NOT_FOUND, id));
    }
}
```

==== 全局异常处理

```java
@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    // 业务异常
    @ExceptionHandler(ApiException.class)
    public ResponseEntity<ApiResponse<Void>> handleApiException(ApiException ex) {
        log.warn("API exception: {} - {}", ex.getCode(), ex.getMessage());

        ApiResponse<Void> response = ApiResponse.error(
            ex.getCode(),
            ex.getErrorMessage()
        );

        // 根据错误码确定 HTTP 状态码
        HttpStatus status = determineHttpStatus(ex.getCode());

        return ResponseEntity.status(status).body(response);
    }

    // 参数校验异常
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiResponse<Map<String, String>>> handleValidation(
        MethodArgumentNotValidException ex
    ) {
        Map<String, String> errors = ex.getBindingResult().getFieldErrors().stream()
            .collect(Collectors.toMap(
                FieldError::getField,
                FieldError::getDefaultMessage,
                (e1, e2) -> e1
            ));

        ApiResponse<Map<String, String>> response = ApiResponse.error(
            ErrorCode.BAD_REQUEST.getCode(),
            "Validation failed"
        );
        response.setData(errors);

        return ResponseEntity.badRequest().body(response);
    }

    // 资源不存在
    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ApiResponse<Void>> handleResourceNotFound(
        ResourceNotFoundException ex
    ) {
        log.warn("Resource not found: {}", ex.getMessage());

        ApiResponse<Void> response = ApiResponse.error(
            ErrorCode.NOT_FOUND.getCode(),
            ex.getMessage()
        );

        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
    }

    // 通用异常
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiResponse<Void>> handleGenericException(Exception ex) {
        log.error("Unexpected error", ex);

        ApiResponse<Void> response = ApiResponse.error(
            ErrorCode.INTERNAL_ERROR.getCode(),
            "An unexpected error occurred"
        );

        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
    }

    private HttpStatus determineHttpStatus(int errorCode) {
        if (errorCode >= 5000000) {
            return HttpStatus.INTERNAL_SERVER_ERROR;
        } else if (errorCode >= 4040000) {
            return HttpStatus.NOT_FOUND;
        } else if (errorCode >= 4030000) {
            return HttpStatus.FORBIDDEN;
        } else if (errorCode >= 4010000) {
            return HttpStatus.UNAUTHORIZED;
        } else if (errorCode >= 4000000) {
            return HttpStatus.BAD_REQUEST;
        }
        return HttpStatus.OK;
    }
}
```

=== 异常处理最佳实践

#tex-table(
  ("实践", "说明", "示例"),
  ("分层处理", "Controller 处理参数异常，Service 处理业务异常", "不同层级不同策略"),
  ("统一格式", "所有异常返回相同的响应结构", "ApiResponse"),
  ("错误码规范", "使用分段式错误码", "1001001"),
  ("日志记录", "记录异常详情便于排查", "log.error"),
  ("信息安全", "生产环境不暴露堆栈", "隐藏敏感信息"),
  ("友好提示", "提供清晰的错误消息", "具体说明错误原因"),
  ("异常分类", "区分客户端错误和服务器错误", "4xx vs 5xx"),
)

==== 完整示例

```java
// 1. 定义错误码
public enum ErrorCode {
    SUCCESS(2000000, "Success"),
    BAD_REQUEST(4000000, "Bad request"),
    UNAUTHORIZED(4010000, "Unauthorized"),
    FORBIDDEN(4030000, "Forbidden"),
    NOT_FOUND(4040000, "Resource not found"),
    INTERNAL_ERROR(5000000, "Internal server error"),

    USER_NOT_FOUND(1001001, "User not found"),
    USER_ALREADY_EXISTS(1001002, "User already exists"),
    INVALID_CREDENTIALS(1001003, "Invalid username or password");

    private final int code;
    private final String message;

    // constructor, getters...
}

// 2. 定义业务异常
public class ApiException extends RuntimeException {
    private final ErrorCode errorCode;

    public ApiException(ErrorCode errorCode) {
        super(errorCode.getMessage());
        this.errorCode = errorCode;
    }

    public int getCode() {
        return errorCode.getCode();
    }
}

// 3. Service 层抛出异常
@Service
public class UserService {

    public User login(String username, String password) {
        User user = userRepository.findByUsername(username)
            .orElseThrow(() -> new ApiException(ErrorCode.USER_NOT_FOUND));

        if (!passwordEncoder.matches(password, user.getPassword())) {
            throw new ApiException(ErrorCode.INVALID_CREDENTIALS);
        }

        return user;
    }
}

// 4. Controller 层
@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<TokenResponse>> login(
        @Valid @RequestBody LoginRequest request
    ) {
        User user = userService.login(request.getUsername(), request.getPassword());
        String token = jwtService.generateToken(user);

        TokenResponse response = new TokenResponse(token);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
}

// 5. 全局异常处理
@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    @ExceptionHandler(ApiException.class)
    public ResponseEntity<ApiResponse<Void>> handleApiException(ApiException ex) {
        log.warn("API exception [{}]: {}", ex.getCode(), ex.getMessage());

        ApiResponse<Void> response = ApiResponse.error(
            ex.getCode(),
            ex.getMessage()
        );

        HttpStatus status = switch (ex.getCode() / 10000) {
            case 400 -> HttpStatus.BAD_REQUEST;
            case 401 -> HttpStatus.UNAUTHORIZED;
            case 403 -> HttpStatus.FORBIDDEN;
            case 404 -> HttpStatus.NOT_FOUND;
            default -> HttpStatus.INTERNAL_SERVER_ERROR;
        };

        return ResponseEntity.status(status).body(response);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiResponse<Map<String, String>>> handleValidation(
        MethodArgumentNotValidException ex
    ) {
        Map<String, String> errors = ex.getBindingResult().getFieldErrors().stream()
            .collect(Collectors.toMap(
                FieldError::getField,
                FieldError::getDefaultMessage,
                (e1, e2) -> e1
            ));

        ApiResponse<Map<String, String>> response = ApiResponse.error(
            ErrorCode.BAD_REQUEST.getCode(),
            "Validation failed"
        );
        response.setData(errors);

        return ResponseEntity.badRequest().body(response);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiResponse<Void>> handleGenericException(Exception ex) {
        log.error("Unexpected error", ex);

        ApiResponse<Void> response = ApiResponse.error(
            ErrorCode.INTERNAL_ERROR.getCode(),
            "An unexpected error occurred"
        );

        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
    }
}
```

*成功响应*：

```json
{
  "code": 2000000,
  "message": "Success",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  },
  "timestamp": 1704067200000
}
```

*失败响应*：

```json
{
  "code": 1001003,
  "message": "Invalid username or password",
  "data": null,
  "timestamp": 1704067200000
}
```

*校验失败响应*：

```json
{
  "code": 4000000,
  "message": "Validation failed",
  "data": {
    "username": "Username is required",
    "password": "Password must be at least 8 characters"
  },
  "timestamp": 1704067200000
}
```

#fancy-divider

本节详细介绍了全局异常处理的完整方案，包括异常分类、错误码设计、统一异常类以及最佳实践。良好的异常处理能够提高系统的可维护性和用户体验。

== 拦截器与过滤器：HandlerInterceptor、Filter、OncePerRequestFilter

拦截器和过滤器是 Spring Web 应用中实现横切关注点（如日志、认证、权限）的重要机制。

=== 执行顺序与生命周期

理解 Filter 和 Interceptor 的执行顺序至关重要。

==== 请求处理流程

```
Client Request
    ↓
┌─────────────────┐
│   Filters       │ ← Servlet Container 管理
│  (Chain)        │
└─────────────────┘
    ↓
┌─────────────────┐
│ DispatcherServlet│ ← Spring MVC 入口
└─────────────────┘
    ↓
┌─────────────────┐
│ Interceptors    │ ← Spring MVC 管理
│  (preHandle)    │
└─────────────────┘
    ↓
┌─────────────────┐
│   Controller    │ ← 业务逻辑
└─────────────────┘
    ↓
┌─────────────────┐
│ Interceptors    │
│ (postHandle)    │
└─────────────────┘
    ↓
┌─────────────────┐
│ Interceptors    │
│(afterCompletion)│
└─────────────────┘
    ↓
┌─────────────────┐
│   Filters       │
└─────────────────┘
    ↓
Client Response
```

==== 关键区别

#tex-table(
  ("特性", "Filter", "Interceptor"),
  ("规范", "Servlet 规范", "Spring MVC"),
  ("管理容器", "Servlet Container", "Spring Context"),
  ("访问范围", "所有请求", "DispatcherServlet 处理的请求"),
  ("访问对象", "ServletRequest/Response", "HttpServletRequest/Response, Handler"),
  ("执行时机", "请求前后", "pre/post/afterCompletion"),
  ("依赖注入", "不支持", "支持 @Autowired"),
  ("异常捕获", "可以", "postHandle 不能捕获"),
)

#note[
  Filter 在 Interceptor 之前执行，Interceptor 只能拦截被 DispatcherServlet 处理的请求。
]

=== Filter：过滤器

Filter 是 Servlet 规范的一部分，用于在请求到达 Servlet 之前或响应返回客户端之前进行处理。

==== 基本用法

*使用 #text("@Component") 自动注册*：

```java
@Component
public class LoggingFilter implements Filter {

    private static final Logger log = LoggerFactory.getLogger(LoggingFilter.class);

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        long startTime = System.currentTimeMillis();

        log.info("Request: {} {}", httpRequest.getMethod(), httpRequest.getRequestURI());

        // 继续过滤链
        chain.doFilter(request, response);

        long duration = System.currentTimeMillis() - startTime;
        log.info("Response: {} - Duration: {}ms", httpResponse.getStatus(), duration);
    }
}
```

==== 使用 #text("@WebFilter")

*需要配合 #text("@ServletComponentScan")*：

```java
@SpringBootApplication
@ServletComponentScan  // 扫描 @WebFilter
public class Application { ... }

@WebFilter(urlPatterns = "/*", filterName = "loggingFilter")
public class LoggingFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {
        // 过滤逻辑
        chain.doFilter(request, response);
    }
}
```

==== 配置 Filter

*Java Config 方式*：

```java
@Configuration
public class FilterConfig {

    @Bean
    public FilterRegistrationBean<LoggingFilter> loggingFilter() {
        FilterRegistrationBean<LoggingFilter> registration = new FilterRegistrationBean<>();
        registration.setFilter(new LoggingFilter());
        registration.addUrlPatterns("/api/*");  // 只拦截 /api/*
        registration.setOrder(1);  // 执行顺序
        registration.setName("loggingFilter");
        return registration;
    }

    @Bean
    public FilterRegistrationBean<AuthFilter> authFilter() {
        FilterRegistrationBean<AuthFilter> registration = new FilterRegistrationBean<>();
        registration.setFilter(new AuthFilter());
        registration.addUrlPatterns("/api/*");
        registration.setOrder(2);  // 在 LoggingFilter 之后执行
        return registration;
    }
}
```

#note[
  Order 值越小，优先级越高，越先执行。
]

==== 多个 Filter 的执行顺序

```java
// Filter 1
@Component
@Order(1)
public class FirstFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {
        System.out.println("FirstFilter - Before");
        chain.doFilter(request, response);
        System.out.println("FirstFilter - After");
    }
}

// Filter 2
@Component
@Order(2)
public class SecondFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {
        System.out.println("SecondFilter - Before");
        chain.doFilter(request, response);
        System.out.println("SecondFilter - After");
    }
}
```

*输出*：

```
FirstFilter - Before
SecondFilter - Before
... Controller ...
SecondFilter - After
FirstFilter - After
```

=== OncePerRequestFilter

`OncePerRequestFilter` 确保每个请求只执行一次过滤逻辑，避免 forward/include 时重复执行。

==== 基本用法

```java
@Component
public class AuthenticationFilter extends OncePerRequestFilter {

    @Autowired
    private JwtTokenProvider tokenProvider;

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain)
            throws ServletException, IOException {

        String token = extractToken(request);

        if (token != null && tokenProvider.validateToken(token)) {
            // 设置认证信息
            Authentication auth = tokenProvider.getAuthentication(token);
            SecurityContextHolder.getContext().setAuthentication(auth);
        }

        // 继续过滤链
        filterChain.doFilter(request, response);
    }

    private String extractToken(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);
        }
        return null;
    }
}
```

==== 跳过某些请求

```java
@Component
public class AuthenticationFilter extends OncePerRequestFilter {

    private static final List<String> EXCLUDED_PATHS = List.of(
        "/api/auth/login",
        "/api/auth/register",
        "/api/public/**"
    );

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain)
            throws ServletException, IOException {

        String path = request.getRequestURI();

        // 跳过不需要认证的路径
        if (isExcluded(path)) {
            filterChain.doFilter(request, response);
            return;
        }

        // 认证逻辑...
        String token = extractToken(request);
        if (token == null || !tokenProvider.validateToken(token)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("Unauthorized");
            return;
        }

        filterChain.doFilter(request, response);
    }

    private boolean isExcluded(String path) {
        return EXCLUDED_PATHS.stream()
            .anyMatch(pattern -> {
                if (pattern.endsWith("**")) {
                    return path.startsWith(pattern.substring(0, pattern.length() - 2));
                }
                return path.equals(pattern);
            });
    }
}
```

==== shouldNotFilter 方法

```java
@Component
public class CorsFilter extends OncePerRequestFilter {

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain)
            throws ServletException, IOException {

        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "*");

        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            response.setStatus(HttpServletResponse.SC_OK);
            return;
        }

        filterChain.doFilter(request, response);
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        // 只处理 /api/* 路径
        return !request.getRequestURI().startsWith("/api/");
    }
}
```

=== HandlerInterceptor：拦截器

Interceptor 是 Spring MVC 提供的拦截机制，可以访问 Handler 和 ModelAndView。

==== 基本用法

```java
@Component
public class LoggingInterceptor implements HandlerInterceptor {

    private static final Logger log = LoggerFactory.getLogger(LoggingInterceptor.class);

    @Override
    public boolean preHandle(HttpServletRequest request,
                            HttpServletResponse response,
                            Object handler) throws Exception {

        long startTime = System.currentTimeMillis();
        request.setAttribute("startTime", startTime);

        log.info("Request: {} {}", request.getMethod(), request.getRequestURI());

        // 返回 true 继续执行，false 中断请求
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest request,
                          HttpServletResponse response,
                          Object handler,
                          ModelAndView modelAndView) throws Exception {

        log.info("Handler: {}", handler.getClass().getSimpleName());

        // 可以在这里修改 ModelAndView
        if (modelAndView != null) {
            modelAndView.addObject("timestamp", System.currentTimeMillis());
        }
    }

    @Override
    public void afterCompletion(HttpServletRequest request,
                               HttpServletResponse response,
                               Object handler,
                               Exception ex) throws Exception {

        Long startTime = (Long) request.getAttribute("startTime");
        if (startTime != null) {
            long duration = System.currentTimeMillis() - startTime;
            log.info("Response: {} - Duration: {}ms", response.getStatus(), duration);
        }

        if (ex != null) {
            log.error("Exception occurred", ex);
        }
    }
}
```

==== 三个方法的执行时机

#tex-table(
  ("方法", "执行时机", "能否中断", "能捕获异常"),
  ("preHandle", "Controller 之前", "✓", "✗"),
  ("postHandle", "Controller 之后，视图渲染之前", "✗", "✗"),
  ("afterCompletion", "视图渲染之后", "✗", "✓"),
)

*注意*：

- `preHandle` 返回 `false` 会中断请求，后续的 Interceptor 和 Controller 都不会执行
- `postHandle` 只有在 `preHandle` 返回 `true` 且没有异常时才会执行
- `afterCompletion` 无论如何都会执行（除非 JVM 崩溃）

==== 配置 Interceptor

```java
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Autowired
    private LoggingInterceptor loggingInterceptor;

    @Autowired
    private AuthInterceptor authInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {

        // 日志拦截器：拦截所有请求
        registry.addInterceptor(loggingInterceptor)
            .addPathPatterns("/**");

        // 认证拦截器：拦截 /api/*，排除公开接口
        registry.addInterceptor(authInterceptor)
            .addPathPatterns("/api/**")
            .excludePathPatterns(
                "/api/auth/login",
                "/api/auth/register",
                "/api/public/**"
            )
            .order(1);  // 执行顺序
    }
}
```

==== 认证拦截器示例

```java
@Component
public class AuthInterceptor implements HandlerInterceptor {

    @Autowired
    private JwtTokenProvider tokenProvider;

    @Override
    public boolean preHandle(HttpServletRequest request,
                            HttpServletResponse response,
                            Object handler) throws Exception {

        String token = extractToken(request);

        if (token == null) {
            sendErrorResponse(response, HttpStatus.UNAUTHORIZED, "Token is required");
            return false;
        }

        if (!tokenProvider.validateToken(token)) {
            sendErrorResponse(response, HttpStatus.UNAUTHORIZED, "Invalid token");
            return false;
        }

        // 设置认证信息
        Authentication auth = tokenProvider.getAuthentication(token);
        SecurityContextHolder.getContext().setAuthentication(auth);

        return true;
    }

    private String extractToken(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);
        }
        return null;
    }

    private void sendErrorResponse(HttpServletResponse response,
                                  HttpStatus status,
                                  String message) throws IOException {
        response.setStatus(status.value());
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Map<String, Object> error = new HashMap<>();
        error.put("code", status.value());
        error.put("message", message);
        error.put("timestamp", System.currentTimeMillis());

        ObjectMapper mapper = new ObjectMapper();
        mapper.writeValue(response.getWriter(), error);
    }
}
```

=== 多个 Interceptor 的执行顺序

```java
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addInterceptors(InterceptorRegistry registry) {

        // Order 1: 先执行
        registry.addInterceptor(new FirstInterceptor())
            .addPathPatterns("/**")
            .order(1);

        // Order 2: 后执行
        registry.addInterceptor(new SecondInterceptor())
            .addPathPatterns("/**")
            .order(2);
    }
}
```

*执行顺序*：

```
FirstInterceptor.preHandle
SecondInterceptor.preHandle
... Controller ...
SecondInterceptor.postHandle
FirstInterceptor.postHandle
SecondInterceptor.afterCompletion
FirstInterceptor.afterCompletion
```

#note[
  preHandle 按 order 从小到大执行，postHandle 和 afterCompletion 按 order 从大到小执行（栈式）。
]

=== Filter vs Interceptor 选择指南

#tex-table(
  ("场景", "推荐", "原因"),
  ("日志记录", "Filter", "所有请求都需要记录"),
  ("认证授权", "Filter 或 Interceptor", "Filter 更早执行，Interceptor 可访问 Handler"),
  ("跨域处理", "Filter", "需要在最早阶段处理"),
  ("性能监控", "Interceptor", "可以获取 Handler 信息"),
  ("数据压缩", "Filter", "需要处理响应流"),
  ("请求参数修改", "Filter", "在到达 Spring MVC 之前处理"),
  ("ModelAndView 修改", "Interceptor", "只有 Interceptor 能访问"),
  ("依赖注入需求", "Interceptor", "天然支持 Spring DI"),
)

=== 综合示例：完整的请求处理链

```java
// 1. CORS Filter（最外层）
@Component
@Order(1)
public class CorsFilter extends OncePerRequestFilter {

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain)
            throws ServletException, IOException {

        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "*");
        response.setHeader("Access-Control-Allow-Headers", "*");

        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            response.setStatus(HttpServletResponse.SC_OK);
            return;
        }

        filterChain.doFilter(request, response);
    }
}

// 2. Logging Filter
@Component
@Order(2)
public class LoggingFilter extends OncePerRequestFilter {

    private static final Logger log = LoggerFactory.getLogger(LoggingFilter.class);

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain)
            throws ServletException, IOException {

        long startTime = System.currentTimeMillis();

        log.info(">>> Request: {} {}", request.getMethod(), request.getRequestURI());

        try {
            filterChain.doFilter(request, response);
        } finally {
            long duration = System.currentTimeMillis() - startTime;
            log.info("<<< Response: {} - {}ms", response.getStatus(), duration);
        }
    }
}

// 3. Authentication Filter
@Component
@Order(3)
public class AuthenticationFilter extends OncePerRequestFilter {

    @Autowired
    private JwtTokenProvider tokenProvider;

    private static final List<String> EXCLUDED_PATHS = List.of(
        "/api/auth/login",
        "/api/auth/register"
    );

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain)
            throws ServletException, IOException {

        if (isExcluded(request.getRequestURI())) {
            filterChain.doFilter(request, response);
            return;
        }

        String token = extractToken(request);
        if (token == null || !tokenProvider.validateToken(token)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        Authentication auth = tokenProvider.getAuthentication(token);
        SecurityContextHolder.getContext().setAuthentication(auth);

        filterChain.doFilter(request, response);
    }

    private boolean isExcluded(String path) {
        return EXCLUDED_PATHS.contains(path);
    }
}

// 4. Logging Interceptor
@Component
public class LoggingInterceptor implements HandlerInterceptor {

    private static final Logger log = LoggerFactory.getLogger(LoggingInterceptor.class);

    @Override
    public boolean preHandle(HttpServletRequest request,
                            HttpServletResponse response,
                            Object handler) {
        request.setAttribute("startTime", System.currentTimeMillis());
        return true;
    }

    @Override
    public void afterCompletion(HttpServletRequest request,
                               HttpServletResponse response,
                               Object handler,
                               Exception ex) {
        Long startTime = (Long) request.getAttribute("startTime");
        if (startTime != null) {
            long duration = System.currentTimeMillis() - startTime;
            log.info("Handler: {} - {}ms",
                handler.getClass().getSimpleName(), duration);
        }
    }
}

// 5. Configuration
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Autowired
    private LoggingInterceptor loggingInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(loggingInterceptor)
            .addPathPatterns("/api/**");
    }
}
```

*请求处理流程*：

```
1. CorsFilter.doFilter (CORS 处理)
2. LoggingFilter.doFilter (开始计时)
3. AuthenticationFilter.doFilter (认证检查)
4. LoggingInterceptor.preHandle (记录开始时间)
5. Controller 执行业务逻辑
6. LoggingInterceptor.afterCompletion (记录耗时)
7. LoggingFilter.doFilter (结束计时，记录日志)
8. 返回响应
```

#fancy-divider

本节详细介绍了 Filter 和 Interceptor 的使用，包括执行顺序、应用场景以及综合示例。合理选择 Filter 或 Interceptor 能够有效实现横切关注点的处理。
