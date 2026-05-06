#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= 安全与认证授权

Spring Boot 提供了强大的安全框架，包括 Spring Security、JWT、Sa-Token 等多种方案，满足不同场景的认证授权需求。

== Spring Security 核心概念与架构

=== Spring Security 简介

Spring Security 是 Spring 生态系统中最流行的安全框架，提供全面的认证和授权功能。

==== 核心特性

#tex-table(
  ("特性", "说明"),
  ("认证", "验证用户身份（用户名密码、OAuth2、JWT等）"),
  ("授权", "控制用户访问资源（角色、权限）"),
  ("防护", "CSRF、CORS、会话固定攻击等"),
  ("集成", "与 Spring MVC、WebFlux 无缝集成"),
)

==== 核心组件

*SecurityFilterChain*：过滤器链，每个过滤器负责特定的安全功能。

#tex-table(
  ("过滤器", "职责"),
  ("UsernamePasswordAuthenticationFilter", "处理表单登录"),
  ("BasicAuthenticationFilter", "处理HTTP Basic认证"),
  ("BearerTokenAuthenticationFilter", "处理JWT Token"),
  ("AuthorizationFilter", "执行授权检查"),
  ("ExceptionTranslationFilter", "处理安全异常"),
)

=== 认证与授权

==== Authentication（认证）

认证是验证用户身份的过程。

```java
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;

// 认证成功后返回 Authentication 对象
Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

// 获取用户信息
String username = authentication.getName();
Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
Object principal = authentication.getPrincipal();  // UserDetails
```

==== Authorization（授权）

授权是控制用户访问资源的过程。

```java
// 基于角色的访问控制
@PreAuthorize("hasRole('ADMIN')")
public void deleteUsers() {
    // 只有 ADMIN 角色可以访问
}

// 基于权限的访问控制
@PreAuthorize("hasAuthority('user:delete')")
public void deleteUser(Long id) {
    // 只有拥有 user:delete 权限的用户可以访问
}
```

==== UserDetails

UserDetails 是 Spring Security 中的用户信息接口。

```java
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.GrantedAuthority;

public class CustomUserDetails implements UserDetails {

    private Long id;
    private String username;
    private String password;
    private Collection<? extends GrantedAuthority> authorities;

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public String getUsername() {
        return username;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
}
```

=== 安全配置

Spring Security 6.x 使用基于 Bean 的配置方式。

==== SecurityFilterChain 配置

```java
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            // 授权规则
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/public/**").permitAll()  // 公开接口
                .requestMatchers("/api/admin/**").hasRole("ADMIN")  // 需要ADMIN角色
                .anyRequest().authenticated()  // 其他接口需要认证
            )
            // 表单登录
            .formLogin(form -> form
                .loginPage("/login")
                .loginProcessingUrl("/api/auth/login")
                .successHandler((request, response, authentication) -> {
                    // 登录成功处理
                })
                .failureHandler((request, response, exception) -> {
                    // 登录失败处理
                })
            )
            // 登出
            .logout(logout -> logout
                .logoutUrl("/api/auth/logout")
                .logoutSuccessHandler((request, response, authentication) -> {
                    // 登出成功处理
                })
            )
            // CSRF（REST API通常禁用）
            .csrf(csrf -> csrf.disable());

        return http.build();
    }
}
```

==== WebSecurityCustomizer

用于忽略某些路径的安全检查（如静态资源）。

```java
@Bean
public WebSecurityCustomizer webSecurityCustomizer() {
    return (web) -> web.ignoring()
        .requestMatchers("/static/**")
        .requestMatchers("/favicon.ico");
}
```

=== 密码编码

Spring Security 推荐使用 BCrypt PasswordEncoder。

==== 配置密码编码器

```java
@Bean
public PasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder();
}
```

==== 使用密码编码器

```java
@Service
public class UserService {

    @Autowired
    private PasswordEncoder passwordEncoder;

    public void createUser(User user) {
        // 加密密码
        String encodedPassword = passwordEncoder.encode(user.getPassword());
        user.setPassword(encodedPassword);

        // 保存用户
        userRepository.save(user);
    }

    public boolean verifyPassword(String rawPassword, String encodedPassword) {
        // 验证密码
        return passwordEncoder.matches(rawPassword, encodedPassword);
    }
}
```

#tip[
  BCrypt 会自动加盐，每次加密相同密码都会得到不同的结果，这是正常且安全的。
]

== 基于表单的认证与授权

=== 表单登录配置

==== 基本配置

```java
@Configuration
public class FormLoginConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .formLogin(form -> form
                // 登录页面路径
                .loginPage("/login.html")

                // 登录处理URL（POST请求）
                .loginProcessingUrl("/api/auth/login")

                // 默认登录成功跳转页面
                .defaultSuccessUrl("/home", true)

                // 登录失败跳转页面
                .failureUrl("/login.html?error=true")

                // 自定义成功处理器
                .successHandler(new AuthenticationSuccessHandler() {
                    @Override
                    public void onAuthenticationSuccess(
                        HttpServletRequest request,
                        HttpServletResponse response,
                        Authentication authentication
                    ) throws IOException {
                        response.setContentType("application/json;charset=UTF-8");
                        response.getWriter().write("{\"code\":200,\"message\":\"登录成功\"}");
                    }
                })

                // 自定义失败处理器
                .failureHandler(new AuthenticationFailureHandler() {
                    @Override
                    public void onAuthenticationFailure(
                        HttpServletRequest request,
                        HttpServletResponse response,
                        AuthenticationException exception
                    ) throws IOException {
                        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                        response.setContentType("application/json;charset=UTF-8");
                        response.getWriter().write("{\"code\":401,\"message\":\"用户名或密码错误\"}");
                    }
                })

                // 允许所有用户访问登录页面
                .permitAll()
            );

        return http.build();
    }
}
```

==== 前端登录表单

```html
<!-- login.html -->
<form action="/api/auth/login" method="post">
    <input type="text" name="username" placeholder="用户名" required />
    <input type="password" name="password" placeholder="密码" required />
    <button type="submit">登录</button>
</form>
```

#note[
  Spring Security 默认期望的字段名是 `username` 和 `password`，可以通过 `.usernameParameter()` 和 `.passwordParameter()` 自定义。
]

=== UserDetailsService

UserDetailsService 负责加载用户信息。

==== 内存用户（测试用）

```java
@Bean
public UserDetailsService userDetailsService() {
    UserDetails admin = User.builder()
        .username("admin")
        .password(passwordEncoder().encode("admin123"))
        .roles("ADMIN")
        .build();

    UserDetails user = User.builder()
        .username("user")
        .password(passwordEncoder().encode("user123"))
        .roles("USER")
        .build();

    return new InMemoryUserDetailsManager(admin, user);
}
```

==== 数据库用户（生产环境）

```java
@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String username)
        throws UsernameNotFoundException {

        // 从数据库查询用户
        User user = userRepository.findByUsername(username)
            .orElseThrow(() -> new UsernameNotFoundException("用户不存在"));

        // 构建 UserDetails
        return new CustomUserDetails(
            user.getId(),
            user.getUsername(),
            user.getPassword(),
            user.getAuthorities()  // 角色和权限
        );
    }
}
```

=== 角色与权限

==== 角色定义

Spring Security 中角色以 `ROLE_` 为前缀。

```java
// 定义角色
List<GrantedAuthority> authorities = Arrays.asList(
    new SimpleGrantedAuthority("ROLE_ADMIN"),
    new SimpleGrantedAuthority("ROLE_USER")
);

// 检查角色
@PreAuthorize("hasRole('ADMIN')")  // 自动添加 ROLE_ 前缀
public void adminOnly() {
    // 只有 ADMIN 角色可以访问
}

@PreAuthorize("hasAuthority('ROLE_ADMIN')")  // 需要完整名称
public void adminOnly2() {
    // 同上
}
```

==== 权限定义

权限更细粒度，不需要前缀。

```java
// 定义权限
List<GrantedAuthority> authorities = Arrays.asList(
    new SimpleGrantedAuthority("user:create"),
    new SimpleGrantedAuthority("user:update"),
    new SimpleGrantedAuthority("user:delete")
);

// 检查权限
@PreAuthorize("hasAuthority('user:create')")
public void createUser() {
    // 只有拥有 user:create 权限的用户可以访问
}

// 多个权限
@PreAuthorize("hasAnyAuthority('user:create', 'user:update')")
public void createOrUpdateUser() {
    // 拥有任一权限即可
}
```

==== 权限表达式

#tex-table(
  ("表达式", "说明", "示例"),
  ("hasRole", "检查角色", `hasRole('ADMIN')`),
  ("hasAnyRole", "检查任一角色", `hasAnyRole('ADMIN', 'USER')`),
  ("hasAuthority", "检查权限", `hasAuthority('user:create')`),
  ("hasAnyAuthority", "检查任一权限", `hasAnyAuthority('user:create', 'user:update')`),
  ("permitAll", "允许所有", `permitAll()`),
  ("denyAll", "拒绝所有", `denyAll()`),
  ("isAuthenticated", "已认证", `isAuthenticated()`),
  ("isAnonymous", "匿名用户", `isAnonymous()`),
  ("hasIpAddress", "IP地址", `hasIpAddress('192.168.1.0/24')`),
)

=== 登出与会话管理

==== 登出配置

```java
@Bean
public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
    http
        .logout(logout -> logout
            // 登出URL
            .logoutUrl("/api/auth/logout")

            // 登出成功后跳转
            .logoutSuccessUrl("/login.html?logout=true")

            // 清除认证信息
            .clearAuthentication(true)

            // 使 Session 失效
            .invalidateHttpSession(true)

            // 删除 Cookie
            .deleteCookies("JSESSIONID")

            // 自定义登出成功处理器
            .logoutSuccessHandler((request, response, authentication) -> {
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"code\":200,\"message\":\"登出成功\"}");
            })

            .permitAll()
        );

    return http.build();
}
```

==== 会话管理

```java
@Bean
public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
    http
        .sessionManagement(session -> session
            // 最大会话数
            .maximumSessions(1)

            // 达到最大会话数时的策略
            .maxSessionsPreventsLogin(false)  // false: 踢掉旧会话, true: 阻止新登录

            // 会话过期URL
            .expiredUrl("/login.html?expired=true")

            // 会话固定攻击防护
            .sessionFixation().migrateSession()  // migrateSession: 创建新Session并复制属性
        );

    return http.build();
}
```

=== CSRF 防护

CSRF（跨站请求伪造）是一种常见攻击。

==== CSRF 配置

```java
@Bean
public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
    http
        .csrf(csrf -> csrf
            // 启用 CSRF（默认启用）
            .enable()

            // CSRF Token 存储方式
            .csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse())

            // 忽略某些路径（如公开API）
            .ignoringRequestMatchers("/api/public/**")
        );

    return http.build();
}
```

#caution[
  RESTful API 通常使用 JWT 等无状态认证，可以禁用 CSRF。但基于 Session 的表单登录必须启用 CSRF 防护。
]

==== 前端携带 CSRF Token

```javascript
// 从 Cookie 中获取 CSRF Token
function getCsrfToken() {
    const cookies = document.cookie.split(';');
    for (let cookie of cookies) {
        const [name, value] = cookie.trim().split('=');
        if (name === 'XSRF-TOKEN') {
            return decodeURIComponent(value);
        }
    }
    return null;
}

// 在请求头中携带 CSRF Token
fetch('/api/users', {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json',
        'X-XSRF-TOKEN': getCsrfToken()
    },
    body: JSON.stringify({ name: 'John' })
});
```

== JWT 无状态认证

JWT（JSON Web Token）是一种无状态认证方案，适合 RESTful API 和微服务架构。

=== JWT 基础

==== JWT 结构

JWT 由三部分组成，用 `.` 分隔：

```
Header.Payload.Signature
```

*Header*：令牌类型和算法
```json
{
  "alg": "HS256",
  "typ": "JWT"
}
```

*Payload*：载荷（用户信息）
```json
{
  "sub": "1234567890",
  "username": "john",
  "role": "USER",
  "iat": 1516239022,
  "exp": 1516242622
}
```

*Signature*：签名（防止篡改）
```
HMACSHA256(
  base64UrlEncode(header) + "." + base64UrlEncode(payload),
  secret
)
```

==== JWT 优势与劣势

#tex-table(
  ("优势", "劣势"),
  ("无状态，易于扩展", "无法主动撤销（需黑名单机制）"),
  ("跨域友好", "Token体积较大"),
  ("适合移动端", "密钥泄露风险高"),
  ("减少数据库查询", "刷新机制复杂"),
)

=== JWT 工具类

使用 jjwt 库操作 JWT。

==== 添加依赖

```xml
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-api</artifactId>
    <version>0.12.3</version>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-impl</artifactId>
    <version>0.12.3</version>
    <scope>runtime</scope>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-jackson</artifactId>
    <version>0.12.3</version>
    <scope>runtime</scope>
</dependency>
```

==== JWT 工具类实现

```java
import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.springframework.stereotype.Component;
import javax.crypto.SecretKey;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Component
public class JwtUtil {

    // 密钥（生产环境应从配置文件读取）
    private static final String SECRET_KEY = "your-secret-key-here-must-be-long-enough";
    private static final long EXPIRATION_TIME = 1000 * 60 * 60 * 24;  // 24小时

    private SecretKey getSigningKey() {
        return Keys.hmacShaKeyFor(SECRET_KEY.getBytes());
    }

    /**
     * 生成 JWT Token
     */
    public String generateToken(String username, String role) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("role", role);

        return Jwts.builder()
            .claims(claims)
            .subject(username)
            .issuedAt(new Date())
            .expiration(new Date(System.currentTimeMillis() + EXPIRATION_TIME))
            .signWith(getSigningKey())
            .compact();
    }

    /**
     * 解析 JWT Token
     */
    public Claims parseToken(String token) {
        return Jwts.parser()
            .verifyWith(getSigningKey())
            .build()
            .parseSignedClaims(token)
            .getPayload();
    }

    /**
     * 验证 Token 是否有效
     */
    public boolean validateToken(String token) {
        try {
            parseToken(token);
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            return false;
        }
    }

    /**
     * 从 Token 中获取用户名
     */
    public String getUsernameFromToken(String token) {
        return parseToken(token).getSubject();
    }

    /**
     * 从 Token 中获取角色
     */
    public String getRoleFromToken(String token) {
        return parseToken(token).get("role", String.class);
    }
}
```

=== JWT 过滤器集成

==== JWT 认证过滤器

```java
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private UserDetailsService userDetailsService;

    @Override
    protected void doFilterInternal(
        HttpServletRequest request,
        HttpServletResponse response,
        FilterChain filterChain
    ) throws ServletException, IOException {

        // 1. 从请求头获取 Token
        String authHeader = request.getHeader("Authorization");

        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }

        String token = authHeader.substring(7);

        // 2. 验证 Token
        if (!jwtUtil.validateToken(token)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"code\":401,\"message\":\"Token无效或已过期\"}");
            return;
        }

        // 3. 从 Token 中获取用户信息
        String username = jwtUtil.getUsernameFromToken(token);

        // 4. 加载用户详情
        UserDetails userDetails = userDetailsService.loadUserByUsername(username);

        // 5. 创建认证对象
        UsernamePasswordAuthenticationToken authentication =
            new UsernamePasswordAuthenticationToken(
                userDetails,
                null,
                userDetails.getAuthorities()
            );

        authentication.setDetails(
            new WebAuthenticationDetailsSource().buildDetails(request)
        );

        // 6. 设置到 SecurityContext
        SecurityContextHolder.getContext().setAuthentication(authentication);

        // 7. 继续过滤链
        filterChain.doFilter(request, response);
    }
}
```

==== 配置过滤器

```java
@Configuration
public class JwtSecurityConfig {

    @Autowired
    private JwtAuthenticationFilter jwtAuthenticationFilter;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            // 禁用 CSRF（JWT 无状态）
            .csrf(csrf -> csrf.disable())

            // 会话管理（无状态）
            .sessionManagement(session ->
                session.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            )

            // 授权规则
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/auth/**").permitAll()  // 认证接口公开
                .requestMatchers("/api/public/**").permitAll()  // 公开接口
                .anyRequest().authenticated()  // 其他接口需要认证
            )

            // 添加 JWT 过滤器
            .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
```

=== 登录接口

```java
@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtUtil jwtUtil;

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody LoginRequest request) {
        try {
            // 1. 认证
            Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                    request.getUsername(),
                    request.getPassword()
                )
            );

            // 2. 生成 Token
            UserDetails userDetails = (UserDetails) authentication.getPrincipal();
            String token = jwtUtil.generateToken(
                userDetails.getUsername(),
                userDetails.getAuthorities().stream()
                    .findFirst()
                    .map(GrantedAuthority::getAuthority)
                    .orElse("USER")
            );

            // 3. 返回 Token
            Map<String, Object> result = new HashMap<>();
            result.put("code", 200);
            result.put("message", "登录成功");
            result.put("data", Map.of(
                "token", token,
                "username", userDetails.getUsername(),
                "expiresIn", 86400  // 24小时
            ));

            return ResponseEntity.ok(result);

        } catch (BadCredentialsException e) {
            Map<String, Object> error = new HashMap<>();
            error.put("code", 401);
            error.put("message", "用户名或密码错误");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error);
        }
    }
}
```

=== 刷新令牌机制

双令牌机制：Access Token（短期）+ Refresh Token（长期）。

==== Refresh Token 实体

```java
@Entity
@Table(name = "refresh_tokens")
public class RefreshToken {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @Column(nullable = false)
    private String token;

    @Column(nullable = false)
    private String username;

    @Column(nullable = false)
    private LocalDateTime expiryDate;

    @Column(nullable = false)
    private boolean revoked = false;
}
```

==== 刷新令牌接口

```java
@PostMapping("/refresh")
public ResponseEntity<Map<String, Object>> refreshToken(@RequestBody RefreshTokenRequest request) {
    // 1. 验证 Refresh Token
    RefreshToken refreshToken = refreshTokenRepository.findByToken(request.getToken())
        .orElseThrow(() -> new RuntimeException("无效的刷新令牌"));

    if (refreshToken.isRevoked() || refreshToken.getExpiryDate().isBefore(LocalDateTime.now())) {
        throw new RuntimeException("刷新令牌已过期");
    }

    // 2. 生成新的 Access Token
    UserDetails userDetails = userDetailsService.loadUserByUsername(refreshToken.getUsername());
    String newAccessToken = jwtUtil.generateToken(
        userDetails.getUsername(),
        userDetails.getAuthorities().stream()
            .findFirst()
            .map(GrantedAuthority::getAuthority)
            .orElse("USER")
    );

    // 3. 返回新 Token
    Map<String, Object> result = new HashMap<>();
    result.put("code", 200);
    result.put("data", Map.of(
        "accessToken", newAccessToken,
        "expiresIn", 3600  // 1小时
    ));

    return ResponseEntity.ok(result);
}
```

== Sa-Token 轻量级认证框架

Sa-Token 是一个轻量级的 Java 权限认证框架，相比 Spring Security 更加简单易用。

=== Sa-Token 简介

==== 为什么选择 Sa-Token

#tex-table(
  ("特性", "Spring Security", "Sa-Token"),
  ("学习曲线", "陡峭", "平缓"),
  ("配置复杂度", "复杂", "简单"),
  ("功能丰富度", "非常全面", "够用"),
  ("社区活跃度", "非常高", "较高"),
  ("适用场景", "大型企业项目", "中小型项目、快速开发"),
)

*Sa-Token 的优势*：

1. **API 简洁**：一行代码完成登录、注销
2. **开箱即用**：默认配置即可满足大部分需求
3. **功能全面**：认证、授权、Session、OAuth2、SSO
4. **文档友好**：中文文档详细，示例丰富

==== 添加依赖

```xml
<dependency>
    <groupId>cn.dev33</groupId>
    <artifactId>sa-token-spring-boot3-starter</artifactId>
    <version>1.37.0</version>
</dependency>

<!-- Redis 集成（可选，用于分布式 Session） -->
<dependency>
    <groupId>cn.dev33</groupId>
    <artifactId>sa-token-dao-redis-jackson</artifactId>
    <version>1.37.0</version>
</dependency>
```

=== 快速上手

==== 基本配置

```yaml
# application.yml
sa-token:
  # Token 名称
  token-name: satoken

  # Token 有效期（秒），-1 代表永不过期
  timeout: 86400

  # Token 临时有效期（秒），-1 代表不开启
  active-timeout: -1

  # 是否允许同一账号并发登录
  is-concurrent: true

  # 在多人登录同一账号时，是否共用一个 Token
  is-share: false

  # Token 风格
  token-style: uuid

  # 是否输出操作日志
  is-log: true
```

==== 登录与注销

```java
@RestController
@RequestMapping("/api/auth")
public class SaTokenAuthController {

    @Autowired
    private UserService userService;

    /**
     * 登录
     */
    @PostMapping("/login")
    public SaResult login(@RequestBody LoginRequest request) {
        // 1. 验证用户名密码
        User user = userService.login(request.getUsername(), request.getPassword());

        // 2. 登录（一行代码）
        StpUtil.login(user.getId());

        // 3. 返回 Token
        return SaResult.ok()
            .set("token", StpUtil.getTokenValue())
            .set("userId", user.getId());
    }

    /**
     * 注销
     */
    @PostMapping("/logout")
    public SaResult logout() {
        // 注销（一行代码）
        StpUtil.logout();
        return SaResult.ok("注销成功");
    }

    /**
     * 获取当前登录用户信息
     */
    @GetMapping("/info")
    public SaResult getInfo() {
        // 获取当前登录用户 ID
        long userId = StpUtil.getLoginIdAsLong();

        User user = userService.getById(userId);
        return SaResult.data(user);
    }
}
```

#tip[
  Sa-Token 的核心 API 都在 `StpUtil` 类中，非常简洁。
]

=== 会话管理

==== Token 存储

Sa-Token 支持多种 Token 存储方式：

#tex-table(
  ("存储方式", "适用场景", "配置"),
  ("内存", "单机应用", "默认"),
  ("Redis", "分布式应用", `sa-token-dao-redis-jackson`),
  ("MySQL", "持久化存储", `sa-token-dao-mysql`),
)

==== 多端登录

```java
// 不同设备使用不同的 Token
StpUtil.login(userId, "PC");      // PC 端登录
StpUtil.login(userId, "APP");     // APP 端登录
StpUtil.login(userId, "MINI");    // 小程序端登录

// 查询指定设备的 Token
String pcToken = StpUtil.getTokenValueByLoginId(userId, "PC");
String appToken = StpUtil.getTokenValueByLoginId(userId, "APP");
```

==== 踢人下线

```java
// 踢掉指定用户的所有登录
StpUtil.kickout(userId);

// 踢掉指定用户的指定设备
StpUtil.kickout(userId, "PC");

// 踢掉自己（当前登录）
StpUtil.logout();
```

=== 权限认证

==== 角色认证

```java
// 判断是否有某个角色
boolean hasRole = StpUtil.hasRole("admin");

// 判断是否有任意一个角色
boolean hasAnyRole = StpUtil.hasRoleOr("admin", "manager");

// 判断是否有所有角色
boolean hasAllRoles = StpUtil.hasRoleAnd("admin", "manager");

// 注解方式
@SaCheckRole("admin")
@GetMapping("/admin/dashboard")
public SaResult adminDashboard() {
    return SaResult.ok("管理员仪表盘");
}
```

==== 权限认证

```java
// 判断是否有某个权限
boolean hasPermission = StpUtil.hasPermission("user:add");

// 判断是否有任意一个权限
boolean hasAnyPermission = StpUtil.hasPermissionOr("user:add", "user:update");

// 判断是否有所有权限
boolean hasAllPermissions = StpUtil.hasPermissionAnd("user:add", "user:update");

// 注解方式
@SaCheckPermission("user:delete")
@DeleteMapping("/users/{id}")
public SaResult deleteUser(@PathVariable Long id) {
    userService.delete(id);
    return SaResult.ok("删除成功");
}
```

==== 二级认证

敏感操作需要重新验证密码。

```java
// 开启二级认证（有效期 300 秒）
StpUtil.openSafe(300);

// 检查二级认证
if (!StpUtil.isSafe()) {
    return SaResult.error("请进行二级认证");
}

// 关闭二级认证
StpUtil.closeSafe();

// 注解方式
@SaCheckSafe
@PostMapping("/users/delete-batch")
public SaResult batchDelete(@RequestBody List<Long> ids) {
    // 需要二级认证才能执行
    userService.batchDelete(ids);
    return SaResult.ok("批量删除成功");
}
```

=== OAuth2.0 支持

Sa-Token 内置 OAuth2.0 模块，支持第三方登录。

==== 微信登录示例

```java
@RestController
@RequestMapping("/api/oauth")
public class OAuthController {

    /**
     * 获取微信授权 URL
     */
    @GetMapping("/wechat/url")
    public SaResult getWechatAuthUrl() {
        String url = StpOAuth2Util.buildAuthUrl(
            "wechat",  // 平台标识
            "https://example.com/api/oauth/wechat/callback"  // 回调地址
        );
        return SaResult.data(url);
    }

    /**
     * 微信授权回调
     */
    @GetMapping("/wechat/callback")
    public SaResult wechatCallback(@RequestParam String code) {
        // 1. 获取 Access Token
        OAuth2Token token = StpOAuth2Util.getAccessToken("wechat", code);

        // 2. 获取用户信息
        OAuth2User user = StpOAuth2Util.getUserInfo("wechat", token.getAccessToken());

        // 3. 绑定或创建本地用户
        Long userId = userService.bindOrCreateWechatUser(user);

        // 4. 登录
        StpUtil.login(userId);

        return SaResult.ok()
            .set("token", StpUtil.getTokenValue())
            .set("userId", userId);
    }
}
```

#note[
  需要在配置文件中配置微信的 appid 和 secret。
]

=== 高级特性

==== 微服务网关鉴权

```java
// Gateway 全局过滤器
@Component
public class SaTokenGatewayFilter implements GlobalFilter, Ordered {

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        // 获取 Token
        String token = exchange.getRequest().getHeaders().getFirst("satoken");

        // 验证 Token
        if (token == null || !StpUtil.stpLogic.isActive(token)) {
            exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
            return exchange.getResponse().setComplete();
        }

        // 传递用户信息到下游服务
        ServerHttpRequest request = exchange.getRequest().mutate()
            .header("X-User-Id", StpUtil.getLoginIdAsString())
            .build();

        return chain.filter(exchange.mutate().request(request).build());
    }

    @Override
    public int getOrder() {
        return -100;
    }
}
```

==== 单点登录 SSO

```yaml
# SSO-Server 配置
sa-token:
  sso-server:
    # SSO-Server 端域名
    server-url: http://sso.example.com

    # Ticket 有效期（秒）
    ticket-timeout: 300
```

```java
// SSO-Client 配置
@RestController
@RequestMapping("/api/sso")
public class SsoController {

    /**
     * SSO 登录
     */
    @GetMapping("/login")
    public void ssoLogin(HttpServletResponse response) throws IOException {
        // 重定向到 SSO-Server
        response.sendRedirect(StpSsoUtil.buildSsoAuthUrl());
    }

    /**
     * SSO 回调
     */
    @GetMapping("/callback")
    public SaResult ssoCallback(@RequestParam String ticket) {
        // 校验 Ticket 并登录
        StpSsoUtil.ssoLogin(ticket);
        return SaResult.ok("登录成功");
    }
}
```

==== 临时身份切换

```java
// 临时切换到另一个身份
StpUtil.switchTo(10001);

try {
    // 以 10001 的身份执行操作
    userService.doSomething();
} finally {
    // 恢复原身份
    StpUtil.untieSwitch();
}
```

== OAuth2 客户端与资源服务器

=== OAuth2.0 协议

OAuth2.0 是一种授权框架，允许第三方应用访问用户资源。

==== 四种授权模式

#tex-table(
  ("模式", "适用场景", "安全性"),
  ("授权码模式", "Web 应用", "最高"),
  ("隐式模式", "SPA 应用", "中"),
  ("密码模式", "可信应用", "低"),
  ("客户端模式", "服务端应用", "中"),
)

=== OAuth2 客户端

使用 Spring Security OAuth2 Client 实现第三方登录。

==== 添加依赖

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-oauth2-client</artifactId>
</dependency>
```

==== GitHub 登录配置

```yaml
spring:
  security:
    oauth2:
      client:
        registration:
          github:
            client-id: your-github-client-id
            client-secret: your-github-client-secret
            scope: user:email
```

==== OAuth2 登录控制器

```java
@RestController
@RequestMapping("/api/oauth2")
public class OAuth2LoginController {

    @GetMapping("/login/github")
    public void githubLogin(HttpServletResponse response) throws IOException {
        // 重定向到 GitHub 授权页面
        response.sendRedirect("/oauth2/authorization/github");
    }

    @GetMapping("/login/success")
    public SaResult loginSuccess(OAuth2AuthenticationToken authentication) {
        OAuth2User oauth2User = authentication.getPrincipal();

        String githubId = oauth2User.getAttribute("id");
        String username = oauth2User.getAttribute("login");
        String email = oauth2User.getAttribute("email");

        // 绑定或创建本地用户
        Long userId = userService.bindOrCreateGithubUser(githubId, username, email);

        // 生成本地 Token
        String token = jwtUtil.generateToken(username, "USER");

        return SaResult.ok()
            .set("token", token)
            .set("userId", userId);
    }
}
```

=== 资源服务器

保护 API 资源，验证 JWT Token。

==== 添加依赖

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-oauth2-resource-server</artifactId>
</dependency>
```

==== 配置资源服务器

```yaml
spring:
  security:
    oauth2:
      resourceserver:
        jwt:
          # JWT 公钥位置
          jwk-set-uri: https://auth.example.com/.well-known/jwks.json
```

```java
@Configuration
public class ResourceServerConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .oauth2ResourceServer(oauth2 -> oauth2
                .jwt(jwt -> jwt
                    // 自定义 JWT 转换器
                    .jwtAuthenticationConverter(jwtAuthenticationConverter())
                )
            )
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/public/**").permitAll()
                .anyRequest().authenticated()
            );

        return http.build();
    }

    @Bean
    public JwtAuthenticationConverter jwtAuthenticationConverter() {
        JwtGrantedAuthoritiesConverter grantedAuthoritiesConverter = new JwtGrantedAuthoritiesConverter();
        grantedAuthoritiesConverter.setAuthorityPrefix("ROLE_");
        grantedAuthoritiesConverter.setAuthoritiesClaimName("scopes");

        JwtAuthenticationConverter authenticationConverter = new JwtAuthenticationConverter();
        authenticationConverter.setJwtGrantedAuthoritiesConverter(grantedAuthoritiesConverter);

        return authenticationConverter;
    }
}
```

=== 授权服务器

使用 Spring Authorization Server 搭建 OAuth2 授权服务器。

#note[
  Spring Authorization Server 是 Spring 官方推荐的 OAuth2 授权服务器实现，替代了已停止维护的 Spring Security OAuth。
]

==== 添加依赖

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-oauth2-authorization-server</artifactId>
</dependency>
```

#caution[
  授权服务器的配置较为复杂，建议参考官方文档和示例项目。对于大多数应用场景，使用现有的 OAuth2 提供商（如 Keycloak、Auth0）更为合适。
]
