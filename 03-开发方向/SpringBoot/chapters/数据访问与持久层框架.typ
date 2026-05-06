#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= 数据访问与持久层框架

Spring Boot 提供了多种数据访问方案，从原生的 JDBC 到功能强大的 ORM 框架，满足不同场景的需求。

== 数据源配置与连接池（HikariCP）

=== Spring Boot 默认数据源

Spring Boot 2.x+ 默认使用 *HikariCP* 作为数据库连接池，它是目前性能最好的连接池之一。

==== 基本配置

```yaml
# application.yml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/mydb?useSSL=false&serverTimezone=UTC
    username: root
    password: root
    driver-class-name: com.mysql.cj.jdbc.Driver
```

==== HikariCP 核心参数

```yaml
spring:
  datasource:
    hikari:
      # 最小空闲连接数
      minimum-idle: 5

      # 最大连接池大小
      maximum-pool-size: 20

      # 连接超时时间（毫秒）
      connection-timeout: 30000

      # 空闲连接超时时间（毫秒）
      idle-timeout: 600000

      # 连接最大生命周期（毫秒）
      max-lifetime: 1800000

      # 连接测试查询
      connection-test-query: SELECT 1
```

#tip[
  HikariCP 的性能优势来自于其优化的字节码、并发控制和连接验证机制。大多数情况下，默认配置已经足够优秀。
]

==== 监控连接池状态

```java
import com.zaxxer.hikari.HikariDataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class DataSourceController {

    @Autowired
    private HikariDataSource dataSource;

    @GetMapping("/datasource/stats")
    public Map<String, Object> getDataSourceStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("activeConnections", dataSource.getHikariPoolMXBean().getActiveConnections());
        stats.put("idleConnections", dataSource.getHikariPoolMXBean().getIdleConnections());
        stats.put("totalConnections", dataSource.getHikariPoolMXBean().getTotalConnections());
        stats.put("threadsAwaitingConnection", dataSource.getHikariPoolMXBean().getThreadsAwaitingConnection());
        return stats;
    }
}
```

=== 其他连接池对比

#tex-table(
  ("连接池", "性能", "特性", "适用场景"),
  ("HikariCP", "★★★★★", "轻量、快速", "默认推荐"),
  ("Druid", "★★★★☆", "监控强大", "需要SQL监控"),
  ("Tomcat JDBC", "★★★☆☆", "稳定", "Tomcat环境"),
  ("C3P0", "★★☆☆☆", "老旧", "不推荐"),
)

==== Druid 连接池配置

阿里巴巴开源的连接池，提供强大的监控功能。

```xml
<!-- pom.xml -->
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>druid-spring-boot-starter</artifactId>
    <version>1.2.20</version>
</dependency>
```

```yaml
spring:
  datasource:
    type: com.alibaba.druid.pool.DruidDataSource
    druid:
      # 初始连接数
      initial-size: 5
      # 最小空闲连接
      min-idle: 5
      # 最大活跃连接
      max-active: 20
      # 获取连接等待超时时间
      max-wait: 60000

      # 监控配置
      stat-view-servlet:
        enabled: true
        url-pattern: /druid/*
        login-username: admin
        login-password: admin
```

访问 `http://localhost:8080/druid` 查看监控面板。

== MyBatis 整合

MyBatis 是一款优秀的持久层框架，它支持自定义 SQL、存储过程以及高级映射。

=== 基本配置

==== 添加依赖

```xml
<dependency>
    <groupId>org.mybatis.spring.boot</groupId>
    <artifactId>mybatis-spring-boot-starter</artifactId>
    <version>3.0.3</version>
</dependency>

<dependency>
    <groupId>com.mysql</groupId>
    <artifactId>mysql-connector-j</artifactId>
    <scope>runtime</scope>
</dependency>
```

==== 配置文件

```yaml
mybatis:
  # Mapper XML 文件位置
  mapper-locations: classpath:mapper/*.xml

  # 类型别名包
  type-aliases-package: com.example.myapp.model

  # 全局配置
  configuration:
    # 开启驼峰命名自动映射
    map-underscore-to-camel-case: true

    # 开启二级缓存
    cache-enabled: true
```

=== XML 映射方式

==== Mapper 接口

```java
@Mapper
public interface UserMapper {

    // 查询所有用户
    List<User> findAll();

    // 根据ID查询
    User findById(@Param("id") Long id);

    // 插入用户
    int insert(User user);

    // 更新用户
    int update(User user);

    // 删除用户
    int delete(@Param("id") Long id);
}
```

==== XML 映射文件

```xml
<!-- src/main/resources/mapper/UserMapper.xml -->
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<mapper namespace="com.example.myapp.mapper.UserMapper">

    <!-- 结果映射 -->
    <resultMap id="UserResultMap" type="User">
        <id property="id" column="id"/>
        <result property="name" column="name"/>
        <result property="email" column="email"/>
        <result property="age" column="age"/>
        <result property="createdAt" column="created_at"/>
    </resultMap>

    <!-- 查询所有 -->
    <select id="findAll" resultMap="UserResultMap">
        SELECT * FROM users ORDER BY id DESC
    </select>

    <!-- 根据ID查询 -->
    <select id="findById" resultMap="UserResultMap">
        SELECT * FROM users WHERE id = #{id}
    </select>

    <!-- 插入 -->
    <insert id="insert" useGeneratedKeys="true" keyProperty="id">
        INSERT INTO users (name, email, age, created_at)
        VALUES (#{name}, #{email}, #{age}, NOW())
    </insert>

    <!-- 更新 -->
    <update id="update">
        UPDATE users
        SET name = #{name},
            email = #{email},
            age = #{age}
        WHERE id = #{id}
    </update>

    <!-- 删除 -->
    <delete id="delete">
        DELETE FROM users WHERE id = #{id}
    </delete>
</mapper>
```

#note[
  `useGeneratedKeys="true"` 和 `keyProperty="id"` 用于获取自增主键的值。
]

=== 注解映射方式

适合简单SQL，避免XML文件。

```java
@Mapper
public interface UserMapper {

    @Select("SELECT * FROM users")
    @Results({
        @Result(property = "id", column = "id"),
        @Result(property = "name", column = "name"),
        @Result(property = "email", column = "email"),
        @Result(property = "age", column = "age"),
        @Result(property = "createdAt", column = "created_at")
    })
    List<User> findAll();

    @Select("SELECT * FROM users WHERE id = #{id}")
    User findById(@Param("id") Long id);

    @Insert("INSERT INTO users (name, email, age) VALUES (#{name}, #{email}, #{age})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(User user);

    @Update("UPDATE users SET name = #{name}, email = #{email} WHERE id = #{id}")
    int update(User user);

    @Delete("DELETE FROM users WHERE id = #{id}")
    int delete(@Param("id") Long id);
}
```

#tip[
  复杂SQL建议使用XML方式，简单SQL可以使用注解方式。两者可以混合使用。
]

=== #text("@MapperScan") 批量扫描

避免在每个Mapper接口上添加`@Mapper`注解。

```java
@SpringBootApplication
@MapperScan("com.example.myapp.mapper")
public class MyappApplication {
    public static void main(String[] args) {
        SpringApplication.run(MyappApplication.class, args);
    }
}
```

这样，`com.example.myapp.mapper` 包下的所有接口都会被自动注册为Mapper。

== MyBatis-Plus 整合

MyBatis-Plus 是 MyBatis 的增强工具，在 MyBatis 的基础上只做增强不做改变，简化开发、提高效率。

=== 基本配置

==== 添加依赖

```xml
<dependency>
    <groupId>com.baomidou</groupId>
    <artifactId>mybatis-plus-spring-boot3-starter</artifactId>
    <version>3.5.5</version>
</dependency>
```

#caution[
  Spring Boot 3.x 需要使用 `mybatis-plus-spring-boot3-starter`，而不是 `mybatis-plus-boot-starter`。
]

==== 实体类

```java
import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("users")
public class User {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String name;

    private String email;

    private Integer age;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
```

=== CRUD 接口

MyBatis-Plus 提供了通用的 CRUD 接口，无需编写 SQL。

==== Mapper 接口

```java
import com.baomidou.mybatisplus.core.mapper.BaseMapper;

@Mapper
public interface UserMapper extends BaseMapper<User> {
    // 继承 BaseMapper 后，自动拥有 CRUD 方法
}
```

==== Service 层

```java
import com.baomidou.mybatisplus.extension.service.IService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;

// Service 接口
public interface UserService extends IService<User> {
}

// Service 实现
@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {
}
```

==== Controller 使用

```java
@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    // 查询所有
    @GetMapping
    public List<User> list() {
        return userService.list();
    }

    // 根据ID查询
    @GetMapping("/{id}")
    public User getById(@PathVariable Long id) {
        return userService.getById(id);
    }

    // 新增
    @PostMapping
    public boolean save(@RequestBody User user) {
        return userService.save(user);
    }

    // 更新
    @PutMapping
    public boolean update(@RequestBody User user) {
        return userService.updateById(user);
    }

    // 删除
    @DeleteMapping("/{id}")
    public boolean remove(@PathVariable Long id) {
        return userService.removeById(id);
    }
}
```

=== 条件构造器

MyBatis-Plus 的核心特性，通过链式调用构建查询条件。

==== QueryWrapper（查询）

```java
@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {

    public List<User> searchUsers(String name, Integer minAge, Integer maxAge) {
        QueryWrapper<User> wrapper = new QueryWrapper<>();

        // 模糊查询
        if (StringUtils.hasText(name)) {
            wrapper.like("name", name);
        }

        // 年龄范围
        if (minAge != null) {
            wrapper.ge("age", minAge);  // >=
        }
        if (maxAge != null) {
            wrapper.le("age", maxAge);  // <=
        }

        // 排序
        wrapper.orderByDesc("created_at");

        return this.list(wrapper);
    }
}
```

*常用条件*：

#tex-table(
  ("方法", "说明", "示例"),
  ("eq", "等于", `eq("age", 18)`),
  ("ne", "不等于", `ne("status", 0)`),
  ("gt", "大于", `gt("age", 18)`),
  ("ge", "大于等于", `ge("age", 18)`),
  ("lt", "小于", `lt("age", 60)`),
  ("le", "小于等于", `le("age", 60)`),
  ("like", "模糊查询", `like("name", "张")`),
  ("in", "IN查询", `in("id", 1, 2, 3)`),
  ("between", "范围", `between("age", 18, 60)`),
  ("isNull", "为空", `isNull("deleted_at")`),
  ("orderByDesc", "降序", `orderByDesc("created_at")`),
)

==== UpdateWrapper（更新）

```java
public boolean updateUserEmail(Long id, String email) {
    UpdateWrapper<User> wrapper = new UpdateWrapper<>();
    wrapper.eq("id", id)
           .set("email", email)
           .set("updated_at", LocalDateTime.now());

    return this.update(wrapper);
}
```

==== LambdaQueryWrapper（类型安全）

```java
public List<User> searchWithLambda(String name) {
    LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();

    // 类型安全，编译时检查
    wrapper.like(User::getName, name)
           .ge(User::getAge, 18)
           .orderByDesc(User::getCreatedAt);

    return this.list(wrapper);
}
```

#tip[
  推荐使用 LambdaQueryWrapper，具有类型安全性，重构时更安全。
]

=== 分页插件

==== 配置分页插件

```java
import com.baomidou.mybatisplus.annotation.DbType;
import com.baomidou.mybatisplus.extension.plugins.MybatisPlusInterceptor;
import com.baomidou.mybatisplus.extension.plugins.inner.PaginationInnerInterceptor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class MybatisPlusConfig {

    @Bean
    public MybatisPlusInterceptor mybatisPlusInterceptor() {
        MybatisPlusInterceptor interceptor = new MybatisPlusInterceptor();

        // 添加分页插件
        PaginationInnerInterceptor paginationInterceptor = new PaginationInnerInterceptor(DbType.MYSQL);

        // 设置最大单页限制数量，默认 500 条，-1 不受限制
        paginationInterceptor.setMaxLimit(500L);

        // 溢出总页数后是否进行处理（默认不处理）
        paginationInterceptor.setOverflow(false);

        interceptor.addInnerInterceptor(paginationInterceptor);
        return interceptor;
    }
}
```

==== 使用分页

```java
@GetMapping("/api/users/page")
public Page<User> getUsers(
    @RequestParam(defaultValue = "1") int page,
    @RequestParam(defaultValue = "10") int size
) {
    // 创建分页对象
    Page<User> pageParam = new Page<>(page, size);

    // 执行分页查询
    Page<User> result = userService.page(pageParam);

    return result;
}
```

*响应示例*：

```json
{
  "records": [...],
  "total": 100,
  "size": 10,
  "current": 1,
  "pages": 10
}
```

==== 分页 + 条件查询

```java
public Page<User> searchUsersWithPage(
    String name,
    Integer page,
    Integer size
) {
    Page<User> pageParam = new Page<>(page, size);

    LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
    if (StringUtils.hasText(name)) {
        wrapper.like(User::getName, name);
    }
    wrapper.orderByDesc(User::getCreatedAt);

    return userService.page(pageParam, wrapper);
}
```

=== 自动填充

自动填充创建时间、更新时间等字段。

==== 实体类配置

```java
@Data
@TableName("users")
public class User {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String name;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
```

==== 实现 MetaObjectHandler

```java
import com.baomidou.mybatisplus.core.handlers.MetaObjectHandler;
import org.apache.ibatis.reflection.MetaObject;
import org.springframework.stereotype.Component;
import java.time.LocalDateTime;

@Component
public class MyMetaObjectHandler implements MetaObjectHandler {

    @Override
    public void insertFill(MetaObject metaObject) {
        this.strictInsertFill(metaObject, "createdAt", LocalDateTime.class, LocalDateTime.now());
        this.strictInsertFill(metaObject, "updatedAt", LocalDateTime.class, LocalDateTime.now());
    }

    @Override
    public void updateFill(MetaObject metaObject) {
        this.strictUpdateFill(metaObject, "updatedAt", LocalDateTime.class, LocalDateTime.now());
    }
}
```

=== 逻辑删除

软删除，不真正删除数据。

==== 配置

```yaml
mybatis-plus:
  global-config:
    db-config:
      logic-delete-field: deleted  # 全局逻辑删除字段名
      logic-delete-value: 1        # 逻辑已删除值
      logic-not-delete-value: 0    # 逻辑未删除值
```

==== 实体类

```java
@Data
@TableName("users")
public class User {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String name;

    @TableLogic
    private Integer deleted;  // 0:未删除, 1:已删除
}
```

调用 `removeById()` 时，会自动执行 `UPDATE users SET deleted=1 WHERE id=?` 而非 `DELETE`。

== Spring Data JPA 基础

Spring Data JPA 是基于 JPA 规范的 Repository 抽象，进一步简化数据访问层的开发。

=== 基本配置

==== 添加依赖

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>

<dependency>
    <groupId>com.mysql</groupId>
    <artifactId>mysql-connector-j</artifactId>
    <scope>runtime</scope>
</dependency>
```

==== 配置文件

```yaml
spring:
  jpa:
    # 数据库平台
    database: mysql

    # 显示 SQL
    show-sql: true

    # 格式化 SQL
    properties:
      hibernate:
        format_sql: true

    # DDL 策略
    hibernate:
      ddl-auto: update  # validate | update | create | create-drop
```

#caution[
  生产环境不要使用 `create` 或 `create-drop`，会删除表结构！推荐使用 `validate` 或手动管理数据库迁移（Flyway/Liquibase）。
]

=== 实体类

```java
import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Entity
@Table(name = "users")
@Data
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 50)
    private String name;

    @Column(unique = true, nullable = false)
    private String email;

    private Integer age;

    @Column(name = "created_at")
    private LocalDateTime createdAt;
}
```

=== Repository 接口

Spring Data JPA 的核心，只需定义接口，无需实现。

==== 基本 Repository

```java
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface UserRepository extends JpaRepository<User, Long> {

    // 方法命名规则查询
    List<User> findByName(String name);

    List<User> findByAgeGreaterThan(Integer age);

    List<User> findByNameContainingAndAgeGreaterThan(String name, Integer age);

    // 自定义 JPQL
    @Query("SELECT u FROM User u WHERE u.email LIKE %:domain")
    List<User> findByEmailDomain(@Param("domain") String domain);

    // 原生 SQL
    @Query(value = "SELECT * FROM users WHERE age > :age", nativeQuery = true)
    List<User> findByAgeGreaterThanNative(@Param("age") Integer age);
}
```

==== 方法命名规则

#tex-table(
  ("关键字", "示例", "JPQL片段"),
  ("findBy", `findByName`, `WHERE name = ?`),
  ("And", `findByNameAndAge`, `WHERE name = ? AND age = ?`),
  ("Or", `findByNameOrEmail`, `WHERE name = ? OR email = ?`),
  ("Between", `findByAgeBetween`, `WHERE age BETWEEN ? AND ?`),
  ("LessThan", `findByAgeLessThan`, `WHERE age < ?`),
  ("GreaterThan", `findByAgeGreaterThan`, `WHERE age > ?`),
  ("Like", `findByNameLike`, `WHERE name LIKE ?`),
  ("Containing", `findByNameContaining`, `WHERE name LIKE %?%`),
  ("OrderBy", `findByNameOrderByAgeDesc`, `ORDER BY age DESC`),
  ("Count", `countByName`, `SELECT COUNT(*) WHERE name = ?`),
)

=== 使用 Repository

```java
@Service
@Transactional
public class UserService {

    @Autowired
    private UserRepository userRepository;

    // 保存
    public User save(User user) {
        return userRepository.save(user);
    }

    // 查询所有
    public List<User> findAll() {
        return userRepository.findAll();
    }

    // 根据ID查询
    public User findById(Long id) {
        return userRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("用户不存在"));
    }

    // 删除
    public void delete(Long id) {
        userRepository.deleteById(id);
    }

    // 自定义查询
    public List<User> searchByName(String name) {
        return userRepository.findByName(name);
    }
}
```

=== PagingAndSortingRepository

支持分页和排序。

```java
public interface UserRepository extends JpaRepository<User, Long> {
}

// 使用
@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    public Page<User> getUsers(int page, int size, String sortField, String sortDirection) {
        Sort.Direction direction = "asc".equalsIgnoreCase(sortDirection)
            ? Sort.Direction.ASC
            : Sort.Direction.DESC;

        Sort sort = Sort.by(direction, sortField);
        Pageable pageable = PageRequest.of(page, size, sort);

        return userRepository.findAll(pageable);
    }
}
```

== 多数据源与动态数据源实现

=== 多数据源配置

适用于读写分离、多数据库场景。

==== 配置文件

```yaml
spring:
  datasource:
    # 主数据源
    master:
      jdbc-url: jdbc:mysql://localhost:3306/master_db
      username: root
      password: root
      driver-class-name: com.mysql.cj.jdbc.Driver

    # 从数据源
    slave:
      jdbc-url: jdbc:mysql://localhost:3306/slave_db
      username: root
      password: root
      driver-class-name: com.mysql.cj.jdbc.Driver
```

==== 配置类

```java
import com.zaxxer.hikari.HikariDataSource;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;

import javax.sql.DataSource;

@Configuration
public class DataSourceConfig {

    // 主数据源
    @Primary
    @Bean(name = "masterDataSource")
    @ConfigurationProperties(prefix = "spring.datasource.master")
    public DataSource masterDataSource() {
        return DataSourceBuilder.create().type(HikariDataSource.class).build();
    }

    // 从数据源
    @Bean(name = "slaveDataSource")
    @ConfigurationProperties(prefix = "spring.datasource.slave")
    public DataSource slaveDataSource() {
        return DataSourceBuilder.create().type(HikariDataSource.class).build();
    }

    // 主数据源 SqlSessionFactory
    @Primary
    @Bean(name = "masterSqlSessionFactory")
    public SqlSessionFactory masterSqlSessionFactory(
        @Qualifier("masterDataSource") DataSource dataSource
    ) throws Exception {
        SqlSessionFactoryBean bean = new SqlSessionFactoryBean();
        bean.setDataSource(dataSource);
        bean.setMapperLocations(
            new PathMatchingResourcePatternResolver()
                .getResources("classpath:mapper/master/*.xml")
        );
        return bean.getObject();
    }

    // 从数据源 SqlSessionFactory
    @Bean(name = "slaveSqlSessionFactory")
    public SqlSessionFactory slaveSqlSessionFactory(
        @Qualifier("slaveDataSource") DataSource dataSource
    ) throws Exception {
        SqlSessionFactoryBean bean = new SqlSessionFactoryBean();
        bean.setDataSource(dataSource);
        bean.setMapperLocations(
            new PathMatchingResourcePatternResolver()
                .getResources("classpath:mapper/slave/*.xml")
        );
        return bean.getObject();
    }
}
```

==== Mapper 扫描

```java
@Configuration
@MapperScan(basePackages = "com.example.myapp.mapper.master",
            sqlSessionFactoryRef = "masterSqlSessionFactory")
public class MasterMapperConfig {
}

@Configuration
@MapperScan(basePackages = "com.example.myapp.mapper.slave",
            sqlSessionFactoryRef = "slaveSqlSessionFactory")
public class SlaveMapperConfig {
}
```

=== 动态数据源

根据运行时条件切换数据源，常用于读写分离。

==== 动态数据源实现

```java
import org.springframework.jdbc.datasource.lookup.AbstractRoutingDataSource;

public class DynamicDataSource extends AbstractRoutingDataSource {

    @Override
    protected Object determineCurrentLookupKey() {
        return DataSourceContextHolder.getDataSourceType();
    }
}
```

==== 数据源上下文

```java
public class DataSourceContextHolder {

    private static final ThreadLocal<String> contextHolder = new ThreadLocal<>();

    public static void setDataSourceType(String dataSourceType) {
        contextHolder.set(dataSourceType);
    }

    public static String getDataSourceType() {
        return contextHolder.get();
    }

    public static void clearDataSourceType() {
        contextHolder.remove();
    }
}
```

==== 自定义注解

```java
@Target({ElementType.METHOD, ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface DataSource {
    String value() default "master";
}
```

==== AOP 切面

```java
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

@Aspect
@Order(1)  // 确保在事务切面之前执行
@Component
public class DataSourceAspect {

    @Around("@annotation(dataSource)")
    public Object around(ProceedingJoinPoint point, DataSource dataSource) throws Throwable {
        try {
            DataSourceContextHolder.setDataSourceType(dataSource.value());
            return point.proceed();
        } finally {
            DataSourceContextHolder.clearDataSourceType();
        }
    }
}
```

==== 使用示例

```java
@Service
public class UserService {

    @Autowired
    private UserMapper userMapper;

    // 写操作 - 使用主库
    @DataSource("master")
    @Transactional
    public void createUser(User user) {
        userMapper.insert(user);
    }

    // 读操作 - 使用从库
    @DataSource("slave")
    public List<User> findAll() {
        return userMapper.findAll();
    }
}
```

== 事务管理基础

Spring 提供了声明式事务管理，通过 `@Transactional` 注解实现。

=== #text("@Transactional") 基本用法

```java
@Service
@Transactional  // 类级别：所有方法都启用事务
public class UserService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private OrderMapper orderMapper;

    // 方法级别：单独配置
    @Transactional
    public void createUserWithOrder(User user, Order order) {
        userMapper.insert(user);
        orderMapper.insert(order);

        // 如果这里抛出异常，两个操作都会回滚
        if (user.getName() == null) {
            throw new RuntimeException("用户名不能为空");
        }
    }
}
```

#note[
  `@Transactional` 只对 `public` 方法有效，且必须通过 Spring 代理调用才会生效。
]

=== 传播行为

定义事务方法被另一个事务方法调用时的行为。

#tex-table(
  ("传播行为", "说明", "场景"),
  ("REQUIRED", "默认。如果存在事务则加入，否则新建", "大多数场景"),
  ("REQUIRES_NEW", "总是新建事务，挂起当前事务", "独立业务，如日志记录"),
  ("SUPPORTS", "如果存在事务则加入，否则非事务执行", "查询操作"),
  ("NOT_SUPPORTED", "非事务执行，挂起当前事务", "不适用"),
  ("MANDATORY", "必须在事务中运行，否则抛异常", "强制事务"),
  ("NEVER", "不能在事务中运行，否则抛异常", "不适用"),
  ("NESTED", "嵌套事务，外层回滚内层也回滚", "特殊场景"),
)

==== 示例

```java
@Service
public class OrderService {

    @Autowired
    private UserService userService;

    @Autowired
    private LogService logService;

    @Transactional(propagation = Propagation.REQUIRED)
    public void createOrder(Order order) {
        // 1. 创建订单
        orderMapper.insert(order);

        // 2. 更新用户积分（加入当前事务）
        userService.updatePoints(order.getUserId(), order.getAmount());

        // 3. 记录日志（独立事务，即使外层回滚也不影响）
        logService.log("创建订单: " + order.getId());
    }
}

@Service
public class LogService {

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void log(String message) {
        logMapper.insert(new Log(message));
    }
}
```

=== 隔离级别

定义事务之间的隔离程度。

#tex-table(
  ("隔离级别", "脏读", "不可重复读", "幻读", "性能"),
  ("READ_UNCOMMITTED", "✓", "✓", "✓", "最高"),
  ("READ_COMMITTED", "✗", "✓", "✓", "高"),
  ("REPEATABLE_READ", "✗", "✗", "✓", "中"),
  ("SERIALIZABLE", "✗", "✗", "✗", "最低"),
  ("DEFAULT", "数据库默认", "数据库默认", "数据库默认", "默认"),
)

```java
@Transactional(isolation = Isolation.READ_COMMITTED)
public void updateUser(User user) {
    userMapper.update(user);
}
```

#tip[
  MySQL 默认隔离级别是 `REPEATABLE_READ`，大多数场景使用 `READ_COMMITTED` 即可。
]

=== 只读事务

优化查询性能。

```java
@Transactional(readOnly = true)
public List<User> findAll() {
    return userMapper.findAll();
}
```

#note[
  `readOnly = true` 提示数据库优化查询，但不能执行写操作。
]

=== 超时与回滚规则

```java
@Transactional(
    timeout = 30,              // 超时时间（秒）
    rollbackFor = Exception.class,  // 遇到Exception回滚
    noRollbackFor = BusinessException.class  // 遇到BusinessException不回滚
)
public void complexOperation() {
    // 复杂业务逻辑
}
```

#caution[
  Spring 默认只在抛出 `RuntimeException` 时回滚，检查型异常（Checked Exception）不会回滚。建议始终指定 `rollbackFor = Exception.class`。
]
