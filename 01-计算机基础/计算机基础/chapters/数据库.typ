#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= 数据库基础理论

数据库是現代信息系统的核心组件，用于高效地存储、管理和检索数据。本章介绍数据库的基本概念、理论模型和核心原理。

#note[
  数据库系统的核心价值在于*数据独立性*和*数据共享*，使得应用程序与数据存储细节分离，提高开发效率和数据一致性。
]

== 数据库系统概述与发展历程

=== 什么是数据库系统

*数据库（Database, DB）*：长期存储在计算机内、有组织的、可共享的大量数据的集合。

*数据库管理系统（DBMS）*：位于用户与操作系统之间的一层数据管理软件。

*数据库系统（DBS）*：由数据库、DBMS、应用系统、数据库管理员和用户组成。

```text
┌─────────────────────────────────┐
│         用户/应用程序            │
├─────────────────────────────────┤
│      数据库管理系统 (DBMS)       │
├─────────────────────────────────┤
│           数据库 (DB)            │
├─────────────────────────────────┤
│         操作系统 (OS)            │
├─────────────────────────────────┤
│           硬件                   │
└─────────────────────────────────┘
```

=== 发展历程

==== 人工管理阶段（1950s以前）

*特点*：

- 数据不保存
- 应用程序管理数据
- 数据不共享
- 数据不具有独立性

*问题*：数据冗余大，维护困难

==== 文件系统阶段（1950s-1960s）

*特点*：

- 数据可以长期保存
- 文件系统管理数据
- 数据共享性差
- 数据独立性差

*问题*：数据冗余、不一致、难以维护

==== 数据库系统阶段（1960s至今）

*特点*：

- 数据结构化
- 数据共享性高
- 数据独立性高
- 统一的数据控制

*优势*：减少冗余、保持一致、易于维护

#tip[
  数据库系统的出现是数据管理技术的革命，解决了文件系统的诸多问题。
]

=== 数据库系统的特点

1. *数据结构化*：整体结构化，不仅内部结构化，整体也结构化
2. *数据共享性高*：多个用户、多个应用可以同时使用
3. *数据独立性高*：物理独立性和逻辑独立性
4. *统一的数据控制*：安全性、完整性、并发控制、恢复

== 数据模型

数据模型是对现实世界数据特征的抽象，是数据库系统的核心和基础。

=== 数据模型的要素

1. *数据结构*：描述系统的静态特性
2. *数据操作*：描述系统的动态特性
3. *数据约束*：完整性规则集合

=== 层次模型

用树形结构表示实体及其联系。

*特点*：

- 有且只有一个根节点
- 其他节点有且只有一个父节点
- 适合表示一对多关系

```text
        学校
       /    \
     学院    学院
    /  \      |
  专业  专业  专业
```

*优点*：

- 结构简单
- 查询效率高

*缺点*：

- 只能表示一对多关系
- 插入删除操作复杂
- 查询子节点必须经过父节点

#note[
  层次模型的代表系统是IBM的IMS（Information Management System）。
]

=== 网状模型

用图结构表示实体及其联系。

*特点*：

- 允许一个以上节点无双亲
- 一个节点可以有多于一个双亲
- 可以表示多对多关系

```text
    学生 ←──→ 课程
     |         |
     └────┬────┘
          |
       选课关系
```

*优点*：

- 能直接描述现实世界
- 存取效率高

*缺点*：

- 结构复杂
- DDL和DML语言复杂
- 用户不易掌握

=== 关系模型（最重要）

用二维表结构表示实体及其联系。

*基本概念*：

- *关系（Relation）*：一张二维表
- *元组（Tuple）*：表中的一行
- *属性（Attribute）*：表中的一列
- *域（Domain）*：属性的取值范围
- *码（Key）*：唯一标识元组的属性或属性组
- *关系模式*：关系的结构描述

*示例*：

```text
学生表：
┌──────┬──────┬──────┬────────┐
│ 学号 │ 姓名 │ 年龄 │  系别   │
├──────┼──────┼──────┼────────┤
│ 001  │ 张三 │  20  │ 计算机 │
│ 002  │ 李四 │  21  │ 数学   │
│ 003  │ 王五 │  19  │ 物理   │
└──────┴──────┴──────┴────────┘
```

*优点*：

- 结构简单清晰
- 理论基础坚实（关系代数、关系演算）
- 数据独立性高
- 使用方便

*缺点*：

- 查询效率可能较低
- 复杂查询需要连接操作

#tip[
  关系模型是目前最主流的数据库模型，MySQL、PostgreSQL、Oracle等都是关系型数据库。
]

=== 面向对象模型

将面向对象的概念引入数据库。

*特点*：

- 封装性
- 继承性
- 多态性
- 支持复杂数据类型

*适用场景*：

- CAD/CAM系统
- 多媒体数据库
- 地理信息系统

=== ER模型（实体-联系模型）

用于概念设计的工具，独立于具体的DBMS。

*基本要素*：

- *实体（Entity）*：客观存在并可相互区别的事物
- *属性（Attribute）*：实体所具有的某一特性
- *联系（Relationship）*：实体之间的关联

*联系的类型*：

- *一对一（1:1）*：一个实体最多与另一个实体的一个实例相关联
- *一对多（1:n）*：一个实体可以与多个另一类实体相关联
- *多对多（m:n）*：两个实体集之间是多对多关系

*ER图符号*：

```
矩形：实体
椭圆：属性
菱形：联系
直线：连接
```

*示例*：

```text
   ┌─────┐       ┌──────┐       ┌─────┐
   │学生 │───────│ 选课  │───────│课程 │
   └─────┘   m   └──────┘   n   └─────┘
     |                |
   学号             成绩
   姓名
   年龄
```

#note[
  ER模型是数据库设计的重要工具，帮助我们从现实世界抽象出数据模型。
]

== 数据库体系结构

=== 三级模式结构

数据库系统的三级模式结构提供了数据抽象的三个级别。

==== 外模式（External Schema）

*定义*：用户能看到和使用的局部数据的逻辑结构和特征的描述。

*特点*：

- 也称子模式或用户模式
- 一个数据库可以有多个外模式
- 是用户的数据视图
- 保证数据安全

==== 模式（Schema）

*定义*：数据库中全体数据的逻辑结构和特征的描述。

*特点*：

- 也称逻辑模式
- 一个数据库只有一个模式
- 是所有用户的公共数据视图
- 不涉及物理存储细节

==== 内模式（Internal Schema）

*定义*：数据在数据库系统内部的表示方式。

*特点*：

- 也称存储模式
- 一个数据库只有一个内模式
- 涉及物理存储结构
- 包括索引、压缩、加密等

```text
┌─────────────────────────────┐
│        外模式 1              │  ← 用户A视图
├─────────────────────────────┤
│        外模式 2              │  ← 用户B视图
├─────────────────────────────┤
│        外模式 n              │  ← 用户N视图
├─────────────────────────────┤
│         模式                 │  ← 全局逻辑视图
├─────────────────────────────┤
│        内模式                │  ← 物理存储视图
└─────────────────────────────┘
```

=== 两级映像

==== 外模式/模式映像

*定义*：定义外模式与模式之间的对应关系。

*作用*：

- 当模式改变时，修改映像
- 外模式可以保持不变
- 保证数据的*逻辑独立性*

==== 模式/内模式映像

*定义*：定义模式与内模式之间的对应关系。

*作用*：

- 当内模式改变时，修改映像
- 模式可以保持不变
- 保证数据的*物理独立性*

```text
用户请求
    ↓
外模式
    ↓
外模式/模式映像  ← 逻辑独立性
    ↓
模式
    ↓
模式/内模式映像  ← 物理独立性
    ↓
内模式
    ↓
物理存储
```

#tip[
  两级映像是数据库系统实现数据独立性的关键机制。
]

== 数据独立性

数据独立性是数据库系统的重要目标，包括物理独立性和逻辑独立性。

=== 物理独立性

*定义*：用户的应用程序与数据库中数据的物理存储是相互独立的。

*含义*：

- 当数据的物理存储改变了（如更换存储设备、调整索引策略）
- 应用程序不需要改变

*实现*：通过模式/内模式映像

*示例*：

```
原存储：数据按姓名排序
新存储：数据按学号排序 + B+树索引

应用程序：SELECT * FROM students WHERE id = '001'
结果：无需修改
```

=== 逻辑独立性

*定义*：用户的应用程序与数据库的逻辑结构是相互独立的。

*含义*：

- 当数据的逻辑结构改变了（如增加字段、拆分表）
- 应用程序不需要改变

*实现*：通过外模式/模式映像

*示例*：

```
原模式：students(id, name, age, dept)
新模式：students(id, name, age), departments(dept_id, dept_name)

外模式：保持students(id, name, age, dept)不变
应用程序：无需修改
```

#caution[
  逻辑独立性比物理独立性更难实现，因为应用程序通常依赖于特定的数据结构。
]

=== 数据独立性的意义

1. *降低维护成本*：数据结构变化不影响应用
2. *提高开发效率*：开发者关注业务逻辑
3. *增强系统灵活性*：易于优化和调整
4. *保护投资*：延长应用程序寿命

#tex-table(
  ("独立性类型", "变化内容", "影响范围", "实现机制"),
  ("物理独立性", "存储结构、索引", "最小", "模式/内模式映像"),
  ("逻辑独立性", "逻辑结构、表结构", "较小", "外模式/模式映像"),
)

== 数据库管理系统（DBMS）的功能与组成

=== DBMS的主要功能

==== 数据定义功能（DDL）

提供数据定义语言，定义数据库结构：

```sql
-- 创建数据库
CREATE DATABASE university;

-- 创建表
CREATE TABLE students (
    id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    age INT,
    dept VARCHAR(50)
);

-- 修改表结构
ALTER TABLE students ADD COLUMN email VARCHAR(100);

-- 删除表
DROP TABLE students;
```

==== 数据操纵功能（DML）

提供数据操纵语言，实现对数据的操作：

```sql
-- 插入数据
INSERT INTO students VALUES ('001', '张三', 20, '计算机');

-- 查询数据
SELECT * FROM students WHERE dept = '计算机';

-- 更新数据
UPDATE students SET age = 21 WHERE id = '001';

-- 删除数据
DELETE FROM students WHERE id = '001';
```

==== 数据库运行管理功能

- *并发控制*：确保多用户同时访问时的数据一致性
- *事务管理*：保证事务的ACID特性
- *安全性检查*：用户身份验证和权限控制
- *完整性检查*：确保数据符合约束条件

==== 数据库的建立和维护功能

- *初始数据装入*：批量导入数据
- *数据库转储*：定期备份
- *数据库恢复*：故障后恢复数据
- *数据库重组*：优化存储结构
- *性能监控*：分析系统性能

==== 数据组织、存储和管理

- *索引管理*：B+树、哈希索引等
- *数据压缩*：节省存储空间
- *数据加密*：保护敏感数据
- *缓存管理*：提高访问速度

=== DBMS的组成

```text
┌──────────────────────────────────────┐
│          查询处理器                   │
│  ┌──────────┐  ┌──────────────────┐  │
│  │ DDL解释器 │  │ DML编译器        │  │
│  └──────────┘  └──────────────────┘  │
│                  │                     │
│              查询优化器                │
└──────────────────┼───────────────────┘
                   │
┌──────────────────┼───────────────────┐
│          存储管理器                   │
│  ┌──────────┐  ┌──────────────────┐  │
│  │授权和   │  │完整性             │  │
│  │完整性   │  │检查器             │  │
│  │检查器   │  └──────────────────┘  │
│  └──────────┘                        │
│  ┌──────────┐  ┌──────────────────┐  │
│  │事务     │  │缓冲区             │  │
│  │管理器   │  │管理器             │  │
│  └──────────┘  └──────────────────┘  │
│  ┌──────────┐                         │
│  │文件     │                         │
│  │管理器   │                         │
│  └──────────┘                         │
└──────────────────┼───────────────────┘
                   │
┌──────────────────┼───────────────────┐
│          磁盘存储                     │
└──────────────────────────────────────┘
```

#note[
  不同DBMS的具体实现可能有所不同，但基本功能模块相似。
]

== 事务的基本概念

事务是数据库操作的基本单位，是用户定义的一个操作序列。

=== 事务的定义

*事务（Transaction）*：作为单个逻辑工作单元执行的一系列操作，要么完全执行，要么完全不执行。

*示例*：银行转账

```sql
BEGIN TRANSACTION;

-- 从账户A扣款
UPDATE accounts SET balance = balance - 1000 WHERE account_id = 'A';

-- 向账户B存款
UPDATE accounts SET balance = balance + 1000 WHERE account_id = 'B';

COMMIT;  -- 提交事务
```

如果任何一步失败：

```sql
ROLLBACK;  -- 回滚事务
```

=== ACID特性

事务必须满足ACID四个特性：

==== 原子性（Atomicity）

*定义*：事务是一个不可分割的工作单位，要么全部执行，要么全部不执行。

*实现*：通过日志和回滚机制

```text
事务执行过程：
开始 → 操作1 → 操作2 → ... → 操作n → 提交
                ↓
            如果失败
                ↓
            回滚到开始状态
```

==== 一致性（Consistency）

*定义*：事务执行前后，数据库必须处于一致状态。

*含义*：

- 事务不能破坏数据库的完整性约束
- 从一个一致状态变换到另一个一致状态

*示例*：

```
转账前：A账户1000元，B账户2000元，总计3000元
转账后：A账户0元，B账户3000元，总计3000元

总额保持不变，满足一致性
```

==== 隔离性（Isolation）

*定义*：多个事务并发执行时，一个事务的执行不应影响其他事务。

*隔离级别*：

#tex-table(
  ("隔离级别", "脏读", "不可重复读", "幻读"),
  ("READ UNCOMMITTED", "可能", "可能", "可能"),
  ("READ COMMITTED", "不可能", "可能", "可能"),
  ("REPEATABLE READ", "不可能", "不可能", "可能"),
  ("SERIALIZABLE", "不可能", "不可能", "不可能"),
)

*说明*：

- *脏读*：读取了未提交的数据
- *不可重复读*：同一事务中多次读取结果不同
- *幻读*：同一查询返回不同行数

#tip[
  隔离级别越高，并发性越差。需要根据业务需求选择合适的隔离级别。
]

==== 持久性（Durability）

*定义*：一旦事务提交，其对数据库的改变就是永久的。

*实现*：

- 写-ahead日志（WAL）
- 定期checkpoint
- 数据冗余备份

```text
事务提交流程：
1. 写入日志
2. 刷新日志到磁盘
3. 提交事务
4. 异步写入数据文件

即使系统在步骤4之前崩溃，也可以通过日志恢复
```

#caution[
  ACID特性是传统关系型数据库的核心保证。NoSQL数据库通常会放宽某些特性以换取性能和可扩展性。
]

=== 事务的状态

```text
                    提交
 活动 ──────────────────→ 部分提交 ───→ 已提交
   │                                          │
   │ 失败                                     │
   ↓                                          ↓
 失败 ──────────────────→ 中止 ───────────→ 终止
                    回滚
```

*状态说明*：

- *活动（Active）*：事务正在执行
- *部分提交（Partially Committed）*：最后一条语句执行完毕
- *失败（Failed）*：正常执行无法继续
- *中止（Aborted）*：事务回滚，数据库恢复到事务开始前
- *已提交（Committed）*：事务成功完成
- *终止（Terminated）*：事务结束

== 并发控制理论基础

当多个事务同时执行时，需要并发控制来保证数据一致性。

=== 并发带来的问题

==== 丢失修改（Lost Update）

```text
时间    事务T1              事务T2
─────────────────────────────────────
t1      读取A=100
t2                          读取A=100
t3      A = A - 20 = 80
t4                          A = A - 30 = 70
t5      写入A=80
t6                          写入A=70  ← T1的修改丢失
```

==== 脏读（Dirty Read）

```text
时间    事务T1              事务T2
─────────────────────────────────────
t1      读取A=100
t2      A = A - 20 = 80
t3      写入A=80
t4                          读取A=80  ← 读到未提交数据
t5      ROLLBACK            ← T1回滚
t6                          A恢复为100，但T2已基于80计算
```

==== 不可重复读（Non-repeatable Read）

```text
时间    事务T1              事务T2
─────────────────────────────────────
t1      读取A=100
t2                          A = A + 50 = 150
t3                          写入A=150
t4                          COMMIT
t5      读取A=150  ← 两次读取结果不同
```

==== 幻读（Phantom Read）

```text
时间    事务T1                  事务T2
─────────────────────────────────────────
t1      SELECT * FROM users
        WHERE age > 20
        返回2条记录
t2                              INSERT INTO users
                                VALUES ('新用户', 25)
t3                              COMMIT
t4      SELECT * FROM users
        WHERE age > 20
        返回3条记录  ← 出现"幻影"行
```

=== 封锁协议

锁是实现并发控制的主要技术。

==== 锁的类型

*排他锁（X锁，写锁）*：

- 事务T对数据A加X锁后，其他事务不能再对A加任何锁
- 直到T释放A上的锁

*共享锁（S锁，读锁）*：

- 事务T对数据A加S锁后，其他事务只能再对A加S锁
- 直到T释放A上的S锁

#tex-table(
  ("当前锁", "请求S锁", "请求X锁"),
  ("无锁", "成功", "成功"),
  ("S锁", "成功", "等待"),
  ("X锁", "等待", "等待"),
)

==== 三级封锁协议

*一级封锁协议*：

- 事务T修改数据R之前必须先对其加X锁
- 直到事务结束才释放

*解决的问题*：丢失修改

*二级封锁协议*：

- 在一级基础上
- 读取数据R之前必须先对其加S锁
- 读完后即可释放S锁

*解决的问题*：丢失修改、脏读

*三级封锁协议*：

- 在一级基础上
- 读取数据R之前必须先对其加S锁
- 直到事务结束才释放

*解决的问题*：丢失修改、脏读、不可重复读

#note[
  封锁级别越高，并发性越差。需要根据实际需求选择合适的封锁协议。
]

==== 两段锁协议（2PL）

*定义*：所有事务必须分两个阶段对数据项加锁和解锁。

*扩展阶段（Growing Phase）*：

- 可以获得锁
- 不能释放锁

*收缩阶段（Shrinking Phase）*：

- 可以释放锁
- 不能获得新锁

```text
事务T:
LOCK-S(A)    ← 扩展阶段
LOCK-X(B)
LOCK-S(C)
───── 锁点（Lock Point）─────
UNLOCK(A)    ← 收缩阶段
UNLOCK(B)
UNLOCK(C)
```

*定理*：如果所有事务都遵循2PL协议，则它们的任何调度都是可串行化的。

#caution[
  2PL保证了可串行化，但可能导致死锁。
]

=== 死锁处理

==== 死锁预防

*一次封锁法*：

- 事务必须一次性申请所有需要的锁
- 缺点：资源利用率低

*顺序封锁法*：

- 预先规定锁的顺序
- 事务必须按顺序申请锁

==== 死锁检测与解除

*超时法*：

- 设置超时时间
- 超过时间则认为死锁

*等待图法*：

- 构建等待图
- 检测图中是否有环

*解除方法*：

- 选择一个或多个事务回滚
- 通常选择代价最小的事务

#tip[
  现代DBMS通常采用死锁检测和自动回滚机制。
]

== 数据库安全性与完整性

=== 数据库安全性

保护数据库以防止非法使用所造成的数据泄露、更改或破坏。

==== 安全威胁

- 非授权用户对数据库的恶意存取和破坏
- 敏感数据被泄露
- 完整性遭到破坏
- 可用性遭到破坏

==== 安全性控制措施

===== 用户标识和鉴定

```sql
-- 创建用户
CREATE USER alice IDENTIFIED BY 'password123';

-- 修改密码
ALTER USER alice IDENTIFIED BY 'new_password';

-- 删除用户
DROP USER alice;
```

===== 存取控制

*自主存取控制（DAC）*：

```sql
-- 授予权限
GRANT SELECT, INSERT ON students TO alice;
GRANT ALL PRIVILEGES ON database.* TO admin;

-- 收回权限
REVOKE INSERT ON students FROM alice;

-- 查看权限
SHOW GRANTS FOR alice;
```

*强制存取控制（MAC）*：

- 每个数据对象被标以一定的密级
- 每个用户也被授予某一个级别的许可证
- 只有当用户的许可证级别大于等于数据对象的密级时，才能访问

===== 视图机制

```sql
-- 创建视图，隐藏敏感信息
CREATE VIEW student_public AS
SELECT id, name, dept
FROM students;
-- 不包含age等敏感字段

-- 用户只能访问视图
GRANT SELECT ON student_public TO public_user;
```

===== 审计

```sql
-- 开启审计
AUDIT SELECT, INSERT, UPDATE, DELETE ON students;

-- 查看审计日志
SELECT * FROM audit_log;
```

*审计内容*：

- 谁（哪个用户）
- 什么时候
- 做了什么操作
- 操作是否成功

===== 数据加密

*存储加密*：

- 透明数据加密（TDE）
- 列级加密

*传输加密*：

- SSL/TLS

```sql
-- MySQL启用SSL
GRANT ALL PRIVILEGES ON *.* TO 'user'@'%' REQUIRE SSL;
```

#note[
  安全性是多层次的，需要从网络、系统、数据库、应用等多个层面综合考虑。
]

=== 数据库完整性

防止数据库中存在不符合语义的数据，防止错误信息的输入和输出。

==== 完整性约束类型

===== 实体完整性

*定义*：主键不能为空且必须唯一。

```sql
CREATE TABLE students (
    id VARCHAR(10) PRIMARY KEY,  -- 主键约束
    name VARCHAR(50) NOT NULL,
    age INT
);
```

===== 参照完整性

*定义*：外键必须是另一个表的主键的有效值，或者是NULL。

```sql
CREATE TABLE enrollments (
    student_id VARCHAR(10),
    course_id VARCHAR(10),
    grade DECIMAL(3, 1),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(id)
        ON DELETE CASCADE      -- 级联删除
        ON UPDATE CASCADE,     -- 级联更新
    FOREIGN KEY (course_id) REFERENCES courses(id)
);
```

*参照动作*：

- `CASCADE`：级联删除/更新
- `SET NULL`：设为NULL
- `RESTRICT`：拒绝操作
- `NO ACTION`：不采取行动

===== 用户定义的完整性

*域约束*：

```sql
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    age INT CHECK (age >= 18 AND age <= 65),
    gender CHAR(1) CHECK (gender IN ('M', 'F')),
    salary DECIMAL(10, 2) CHECK (salary > 0)
);
```

*断言（Assertion）*：

```sql
-- 并非所有DBMS都支持
CREATE ASSERTION salary_check
CHECK (
    NOT EXISTS (
        SELECT * FROM employees
        WHERE salary > (
            SELECT AVG(salary) * 5 FROM employees
        )
    )
);
```

*触发器（Trigger）*：

```sql
CREATE TRIGGER check_salary
BEFORE INSERT OR UPDATE ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary cannot be negative';
    END IF;
END;
```

#tip[
  完整性约束应该在数据库层面定义，而不是仅在应用层检查，以保证数据的一致性。
]

==== 完整性检查时机

- *立即检查*：每条语句执行后立即检查
- *延迟检查*：事务提交时检查

```sql
-- 设置延迟检查
SET CONSTRAINTS ALL DEFERRED;

-- 事务中的操作
BEGIN;
INSERT INTO orders VALUES (...);
UPDATE inventory SET stock = stock - 1 WHERE ...;
COMMIT;  -- 此时检查完整性
```

== 总结

数据库基础理论涵盖了以下核心内容：

- *数据模型*：层次、网状、关系、面向对象模型，其中关系模型最为重要
- *体系结构*：三级模式（外模式、模式、内模式）和两级映像
- *数据独立性*：物理独立性和逻辑独立性
- *DBMS功能*：数据定义、操纵、运行管理、建立维护
- *事务管理*：ACID特性是数据库可靠性的保证
- *并发控制*：封锁协议、两段锁、死锁处理
- *安全性与完整性*：多层次的安全控制和完整性约束

#fancy-divider

下一章将深入探讨*关系数据库标准语言SQL*的使用。


= 关系型数据库

关系型数据库是目前应用最广泛的数据库类型，基于关系模型理论，使用SQL作为标准查询语言。本章深入探讨关系型数据库的核心概念、技术和实现。

#note[
  关系型数据库的核心理念是*用二维表组织数据*，通过数学理论（关系代数）保证数据的正确性和一致性。
]

== 关系模型基础

关系模型由E.F. Codd于1970年提出，是现代数据库的理论基础。

=== 基本概念

==== 关系（Relation）

*定义*：一个关系对应一张二维表。

*特点*：

- 每一列中的数据必须是同一类型
- 不同的列可以出自同一个域
- 列的顺序无所谓
- 行的顺序无所谓
- 任意两个元组不能完全相同

```text
学生关系（Students）：
┌──────┬──────┬──────┬────────┐
│ 学号 │ 姓名 │ 年龄 │  系别   │
├──────┼──────┼──────┼────────┤
│ 001  │ 张三 │  20  │ 计算机 │
│ 002  │ 李四 │  21  │ 数学   │
└──────┴──────┴──────┴────────┘
```

==== 元组（Tuple）

*定义*：表中的一行即为一个元组。

*示例*：`(001, '张三', 20, '计算机')` 是一个元组

==== 属性（Attribute）

*定义*：表中的一列即为一个属性。

*示例*：`学号`、`姓名`、`年龄`、`系别` 都是属性

==== 域（Domain）

*定义*：属性的取值范围。

*示例*：

- `学号` 的域：长度为10的字符串
- `年龄` 的域：正整数，范围1-150
- `性别` 的域：{'男', '女'}

==== 码（Key）

*候选码（Candidate Key）*：能唯一标识元组的最小属性集。

*主码（Primary Key）*：从候选码中选择一个作为主码。

*外码（Foreign Key）*：一个关系中的属性引用另一个关系的主码。

*示例*：

```sql
CREATE TABLE students (
    id VARCHAR(10) PRIMARY KEY,      -- 主码
    name VARCHAR(50),
    dept_id VARCHAR(10),
    FOREIGN KEY (dept_id) REFERENCES departments(id)  -- 外码
);
```

==== 关系模式

*定义*：对关系的描述，表示为：`关系名(属性1, 属性2, ..., 属性n)`

*示例*：`Students(学号, 姓名, 年龄, 系别)`

#tip[
  关系模式是型（Type），关系是值（Value）。关系模式相对稳定，关系随数据更新而变化。
]

=== 关系的完整性约束

==== 实体完整性

*规则*：若属性A是基本关系R的主属性，则A不能取空值（NULL）。

```sql
CREATE TABLE students (
    id VARCHAR(10) PRIMARY KEY,  -- 自动满足实体完整性
    name VARCHAR(50) NOT NULL
);
```

==== 参照完整性

*规则*：若属性（或属性组）F是基本关系R的外码，它与基本关系S的主码Ks相对应，则对于R中每个元组在F上的值必须：

- 取空值（F的每个属性均为空值）
- 等于S中某个元组的主码值

```sql
CREATE TABLE enrollments (
    student_id VARCHAR(10),
    course_id VARCHAR(10),
    FOREIGN KEY (student_id) REFERENCES students(id)
        ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id)
        ON DELETE RESTRICT
);
```

==== 用户定义的完整性

*规则*：针对某一具体关系数据库的约束条件。

```sql
CREATE TABLE employees (
    id INT PRIMARY KEY,
    age INT CHECK (age >= 18 AND age <= 65),
    gender CHAR(1) CHECK (gender IN ('M', 'F')),
    salary DECIMAL(10, 2) CHECK (salary > 0)
);
```

== 关系代数

关系代数是关系数据库的理论基础，提供了一组操作关系的形式化方法。

=== 基本运算

==== 选择（Selection，σ）

*定义*：从关系中选出满足给定条件的元组。

*符号*：`σ_F(R)`，其中F是选择条件

*示例*：

```text
σ_年龄>20(Students)

结果：
┌──────┬──────┬──────┬────────┐
│ 学号 │ 姓名 │ 年龄 │  系别   │
├──────┼──────┼──────┼────────┤
│ 002  │ 李四 │  21  │ 数学   │
└──────┴──────┴──────┴────────┘
```

*SQL等价*：

```sql
SELECT * FROM Students WHERE 年龄 > 20;
```

==== 投影（Projection，π）

*定义*：从关系中选择出若干属性列组成新的关系。

*符号*：`π_A(R)`，其中A是属性列

*示例*：

```text
π_姓名,系别(Students)

结果：
┌──────┬────────┐
│ 姓名 │  系别   │
├──────┼────────┤
│ 张三 │ 计算机 │
│ 李四 │ 数学   │
└──────┴────────┘
```

*SQL等价*：

```sql
SELECT 姓名, 系别 FROM Students;
```

#note[
  投影会自动去除重复元组。
]

==== 并（Union，∪）

*定义*：两个相容关系的并集。

*条件*：两个关系必须有相同的属性个数，且对应属性来自相同的域。

*示例*：

```text
R ∪ S = {t | t ∈ R 或 t ∈ S}
```

*SQL等价*：

```sql
SELECT * FROM R
UNION
SELECT * FROM S;
```

==== 差（Difference，-）

*定义*：属于R但不属于S的元组集合。

*示例*：

```text
R - S = {t | t ∈ R 且 t ∉ S}
```

*SQL等价*：

```sql
SELECT * FROM R
EXCEPT
SELECT * FROM S;
```

==== 笛卡尔积（Cartesian Product，×）

*定义*：两个关系的元组两两组合。

*示例*：

```text
R × S

如果R有m个元组，S有n个元组，则R×S有m×n个元组
```

*SQL等价*：

```sql
SELECT * FROM R, S;
-- 或
SELECT * FROM R CROSS JOIN S;
```

#caution[
  笛卡尔积的结果通常很大，实际应用中应该配合选择操作使用。
]

=== 专门的关系运算

==== 连接（Join，⋈）

*定义*：从两个关系的笛卡尔积中选取属性间满足一定条件的元组。

===== 等值连接

条件为相等比较的连接。

```text
R ⋈_(R.A=S.B) S
```

*SQL等价*：

```sql
SELECT * FROM R JOIN S ON R.A = S.B;
```

===== 自然连接（Natural Join，⋈）

特殊的等值连接，要求两个关系中进行比较的分量必须是相同的属性组，并且在结果中把重复的属性列去掉。

```text
Students ⋈ Enrollments

自动在相同属性（如学号）上连接，并去除重复列
```

*SQL等价*：

```sql
SELECT * FROM Students NATURAL JOIN Enrollments;
-- 或
SELECT Students.*, Enrollments.course_id, Enrollments.grade
FROM Students JOIN Enrollments ON Students.id = Enrollments.student_id;
```

===== 外连接（Outer Join）

*左外连接*：保留左边关系的所有元组

```sql
SELECT * FROM R LEFT JOIN S ON R.A = S.B;
```

*右外连接*：保留右边关系的所有元组

```sql
SELECT * FROM R RIGHT JOIN S ON R.A = S.B;
```

*全外连接*：保留两边关系的所有元组

```sql
SELECT * FROM R FULL OUTER JOIN S ON R.A = S.B;
```

#tip[
  自然连接是最常用的连接方式。外连接用于需要保留未匹配记录的场景。
]

==== 除（Division，÷）

*定义*：给定关系R(X, Y)和S(Y, Z)，其中X, Y, Z为属性组。R÷S的结果是新关系P(X)，包含所有满足以下条件的元组：该元组在X上的分量x，其象集Y_x包含S在Y上的投影。

*通俗理解*：找出与S中所有元组都有关联的R中的元组。

*示例*：

```text
问题：查询选修了所有课程的学生

R (选课表):          S (课程表):
┌──────┬────────┐   ┌────────┐
│ 学号 │ 课程号 │   │ 课程号 │
├──────┼────────┤   ├────────┤
│ 001  │ C1     │   │ C1     │
│ 001  │ C2     │   │ C2     │
│ 001  │ C3     │   │ C3     │
│ 002  │ C1     │   └────────┘
│ 002  │ C2     │
└──────┴────────┘

R ÷ S = {001}  （只有001选修了所有课程）
```

*SQL实现*：

```sql
SELECT DISTINCT student_id
FROM enrollments e1
WHERE NOT EXISTS (
    SELECT * FROM courses c
    WHERE NOT EXISTS (
        SELECT * FROM enrollments e2
        WHERE e2.student_id = e1.student_id
        AND e2.course_id = c.course_id
    )
);
```

#note[
  除运算是关系代数中最复杂的运算，在实际SQL中通常用NOT EXISTS或COUNT来实现。
]

=== 关系代数表达式的应用

*示例*：查询计算机系选修了"数据库"课程的学生姓名

```text
π_姓名(σ_系别='计算机'(Students) ⋈ σ_课程名='数据库'(Courses ⋈ Enrollments))
```

*SQL等价*：

```sql
SELECT DISTINCT s.姓名
FROM Students s
JOIN Enrollments e ON s.学号 = e.学号
JOIN Courses c ON e.课程号 = c.课程号
WHERE s.系别 = '计算机' AND c.课程名 = '数据库';
```

#tip[
  关系代数是SQL查询优化的理论基础。DBMS会将SQL转换为关系代数表达式，然后进行优化。
]

== SQL语言基础

SQL（Structured Query Language）是关系数据库的标准语言。

=== SQL的特点

- 综合统一：集DDL、DML、DCL于一体
- 高度非过程化：只需指定"做什么"，无需说明"怎么做"
- 面向集合的操作方式
- 以同一种语法结构提供多种使用方式
- 语言简洁，易学易用

=== SQL的分类

==== DDL（Data Definition Language）

数据定义语言，用于定义数据库结构。

===== 创建数据库

```sql
CREATE DATABASE university
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
```

===== 创建表

```sql
CREATE TABLE students (
    id VARCHAR(10) PRIMARY KEY COMMENT '学号',
    name VARCHAR(50) NOT NULL COMMENT '姓名',
    age INT CHECK (age >= 0 AND age <= 150) COMMENT '年龄',
    gender ENUM('M', 'F') DEFAULT 'M' COMMENT '性别',
    dept_id VARCHAR(10) COMMENT '系别ID',
    email VARCHAR(100) UNIQUE COMMENT '邮箱',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',

    FOREIGN KEY (dept_id) REFERENCES departments(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    INDEX idx_name (name),
    INDEX idx_dept (dept_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学生表';
```

===== 修改表

```sql
-- 添加列
ALTER TABLE students ADD COLUMN phone VARCHAR(20);

-- 修改列
ALTER TABLE students MODIFY COLUMN email VARCHAR(150);

-- 删除列
ALTER TABLE students DROP COLUMN phone;

-- 添加约束
ALTER TABLE students ADD CONSTRAINT uk_email UNIQUE (email);

-- 删除约束
ALTER TABLE students DROP INDEX uk_email;

-- 重命名表
ALTER TABLE students RENAME TO stu;
```

===== 删除表

```sql
DROP TABLE IF EXISTS students;
```

#caution[
  DROP操作不可逆，生产环境要谨慎使用。建议先备份数据。
]

==== DML（Data Manipulation Language）

数据操纵语言，用于操作数据。

===== 插入数据

```sql
-- 插入单条记录
INSERT INTO students (id, name, age, dept_id)
VALUES ('001', '张三', 20, 'CS01');

-- 插入多条记录
INSERT INTO students (id, name, age, dept_id)
VALUES
    ('002', '李四', 21, 'CS01'),
    ('003', '王五', 19, 'MA01');

-- 从查询结果插入
INSERT INTO students_backup
SELECT * FROM students WHERE dept_id = 'CS01';
```

===== 更新数据

```sql
-- 更新单条记录
UPDATE students
SET age = 21, email = 'zhangsan@example.com'
WHERE id = '001';

-- 批量更新
UPDATE students
SET age = age + 1
WHERE dept_id = 'CS01';

-- 带条件的更新
UPDATE students
SET dept_id = NULL
WHERE dept_id NOT IN (SELECT id FROM departments);
```

#caution[
  UPDATE语句一定要加WHERE条件，否则会更新所有记录！
]

===== 删除数据

```sql
-- 删除单条记录
DELETE FROM students WHERE id = '001';

-- 批量删除
DELETE FROM students WHERE age < 18;

-- 清空表（比DELETE快）
TRUNCATE TABLE students;
```

#note[
  TRUNCATE是DDL操作，会重置自增计数器，且不能回滚。DELETE是DML操作，可以回滚。
]

===== 查询数据

```sql
-- 基本查询
SELECT id, name, age FROM students;

-- 条件查询
SELECT * FROM students WHERE age > 20 AND dept_id = 'CS01';

-- 排序
SELECT * FROM students ORDER BY age DESC, name ASC;

-- 限制结果
SELECT * FROM students LIMIT 10 OFFSET 20;  -- 第3页，每页10条

-- 去重
SELECT DISTINCT dept_id FROM students;

-- 聚合
SELECT dept_id, COUNT(*) as count, AVG(age) as avg_age
FROM students
GROUP BY dept_id
HAVING COUNT(*) > 5
ORDER BY count DESC;
```

==== DCL（Data Control Language）

数据控制语言，用于权限管理。

```sql
-- 创建用户
CREATE USER 'alice'@'localhost' IDENTIFIED BY 'password123';

-- 授予权限
GRANT SELECT, INSERT ON university.students TO 'alice'@'localhost';
GRANT ALL PRIVILEGES ON university.* TO 'admin'@'%';

-- 收回权限
REVOKE INSERT ON university.students FROM 'alice'@'localhost';

-- 查看权限
SHOW GRANTS FOR 'alice'@'localhost';

-- 删除用户
DROP USER 'alice'@'localhost';
```

==== TCL（Transaction Control Language）

事务控制语言，用于事务管理。

```sql
-- 开始事务
START TRANSACTION;
-- 或
BEGIN;

-- 提交事务
COMMIT;

-- 回滚事务
ROLLBACK;

-- 设置保存点
SAVEPOINT sp1;

-- 回滚到保存点
ROLLBACK TO sp1;

-- 设置隔离级别
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
```

*事务示例*：

```sql
START TRANSACTION;

UPDATE accounts SET balance = balance - 1000 WHERE id = 'A';
UPDATE accounts SET balance = balance + 1000 WHERE id = 'B';

-- 如果都成功
COMMIT;

-- 如果有错误
-- ROLLBACK;
```

#tip[
  始终显式管理事务，不要让DBMS自动提交，以保证数据一致性。
]

== 数据查询进阶

=== 子查询

子查询是嵌套在其他SQL语句中的SELECT语句。

==== 标量子查询

返回单个值的子查询。

```sql
-- 查询年龄大于平均年龄的学生
SELECT * FROM students
WHERE age > (SELECT AVG(age) FROM students);

-- 查询最高分的学生
SELECT * FROM students
WHERE id = (
    SELECT student_id FROM grades
    ORDER BY score DESC LIMIT 1
);
```

==== 列子查询

返回一列值的子查询。

```sql
-- 查询计算机系和数学系的学生
SELECT * FROM students
WHERE dept_id IN (
    SELECT id FROM departments
    WHERE name IN ('计算机', '数学')
);

-- 使用ANY/SOME
SELECT * FROM students
WHERE age > ANY (
    SELECT age FROM students WHERE dept_id = 'CS01'
);

-- 使用ALL
SELECT * FROM students
WHERE age > ALL (
    SELECT age FROM students WHERE dept_id = 'MA01'
);
```

==== 行子查询

返回一行多列的子查询。

```sql
SELECT * FROM students
WHERE (age, dept_id) = (
    SELECT age, dept_id FROM students WHERE id = '001'
);
```

==== 表子查询

返回多行多列的子查询，通常用在FROM子句中。

```sql
-- 查询每个系的平均年龄
SELECT dept_name, avg_age
FROM departments d
JOIN (
    SELECT dept_id, AVG(age) as avg_age
    FROM students
    GROUP BY dept_id
) s ON d.id = s.dept_id;
```

==== 相关子查询

子查询引用了外层查询的表。

```sql
-- 查询每个系年龄最大的学生
SELECT * FROM students s1
WHERE age = (
    SELECT MAX(age)
    FROM students s2
    WHERE s2.dept_id = s1.dept_id
);

-- 使用EXISTS
SELECT * FROM departments d
WHERE EXISTS (
    SELECT 1 FROM students s
    WHERE s.dept_id = d.id
);
```

#tip[
  相关子查询对外层每一行都执行一次，性能较差。尽量用JOIN替代。
]

=== 连接查询

==== 内连接（INNER JOIN）

只返回两个表中匹配的行。

```sql
SELECT s.name, d.name as dept_name
FROM students s
INNER JOIN departments d ON s.dept_id = d.id;
```

==== 外连接（OUTER JOIN）

===== 左外连接

```sql
-- 查询所有学生及其系别（包括没有系别的学生）
SELECT s.name, d.name as dept_name
FROM students s
LEFT JOIN departments d ON s.dept_id = d.id;
```

===== 右外连接

```sql
-- 查询所有系别及其学生（包括没有学生的系）
SELECT s.name, d.name as dept_name
FROM students s
RIGHT JOIN departments d ON s.dept_id = d.id;
```

===== 全外连接

```sql
-- MySQL不支持FULL OUTER JOIN，可以用UNION模拟
SELECT s.name, d.name as dept_name
FROM students s
LEFT JOIN departments d ON s.dept_id = d.id

UNION

SELECT s.name, d.name as dept_name
FROM students s
RIGHT JOIN departments d ON s.dept_id = d.id;
```

==== 自连接

表与自身连接。

```sql
-- 查询员工及其上级
SELECT e.name as employee, m.name as manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.id;

-- 查询同一系的学生对
SELECT s1.name, s2.name
FROM students s1
JOIN students s2 ON s1.dept_id = s2.dept_id
WHERE s1.id < s2.id;  -- 避免重复
```

==== 多表连接

```sql
-- 查询学生、课程和成绩
SELECT s.name, c.name as course, g.score
FROM students s
JOIN enrollments e ON s.id = e.student_id
JOIN courses c ON e.course_id = c.id
JOIN grades g ON e.id = g.enrollment_id
WHERE g.score >= 90;
```

#note[
  连接多个表时，注意连接顺序和索引使用，以避免性能问题。
]

=== 集合运算

==== UNION（并集）

合并两个查询结果，去除重复。

```sql
SELECT name FROM undergraduate_students
UNION
SELECT name FROM graduate_students;
```

==== UNION ALL（并集，保留重复）

```sql
SELECT name FROM undergraduate_students
UNION ALL
SELECT name FROM graduate_students;
```

#tip[
  UNION ALL比UNION快，因为不需要去重。如果确定没有重复，优先使用UNION ALL。
]

==== INTERSECT（交集）

返回两个查询的共同结果。

```sql
-- MySQL不直接支持INTERSECT，可以用JOIN或IN实现
SELECT student_id FROM enrollments WHERE course_id = 'C1'
INTERSECT
SELECT student_id FROM enrollments WHERE course_id = 'C2';

-- MySQL等价写法
SELECT e1.student_id
FROM enrollments e1
JOIN enrollments e2 ON e1.student_id = e2.student_id
WHERE e1.course_id = 'C1' AND e2.course_id = 'C2';
```

==== EXCEPT（差集）

返回在第一个查询中但不在第二个查询中的结果。

```sql
-- MySQL不直接支持EXCEPT，可以用NOT EXISTS或LEFT JOIN实现
SELECT student_id FROM all_students
EXCEPT
SELECT student_id FROM graduated_students;

-- MySQL等价写法
SELECT student_id FROM all_students
WHERE student_id NOT IN (
    SELECT student_id FROM graduated_students
);
```

=== 窗口函数（Window Functions）

窗口函数在不减少行数的情况下进行计算。

==== 排名函数

```sql
-- ROW_NUMBER(): 连续排名
SELECT name, score,
       ROW_NUMBER() OVER (ORDER BY score DESC) as rank
FROM students;

-- RANK(): 跳跃排名
SELECT name, score,
       RANK() OVER (ORDER BY score DESC) as rank
FROM students;

-- DENSE_RANK(): 密集排名
SELECT name, score,
       DENSE_RANK() OVER (ORDER BY score DESC) as rank
FROM students;
```

*区别*：

```text
分数: 100, 90, 90, 80

ROW_NUMBER: 1, 2, 3, 4
RANK:       1, 2, 2, 4
DENSE_RANK: 1, 2, 2, 3
```

==== 聚合窗口函数

```sql
-- 累计求和
SELECT date, amount,
       SUM(amount) OVER (ORDER BY date) as running_total
FROM transactions;

-- 移动平均
SELECT date, price,
       AVG(price) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as ma7
FROM stock_prices;

-- 分组内排名
SELECT name, dept_id, salary,
       RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) as dept_rank
FROM employees;
```

==== 值函数

```sql
-- LAG(): 前一行
SELECT date, price,
       LAG(price, 1) OVER (ORDER BY date) as prev_price
FROM stock_prices;

-- LEAD(): 后一行
SELECT date, price,
       LEAD(price, 1) OVER (ORDER BY date) as next_price
FROM stock_prices;

-- FIRST_VALUE(): 第一个值
SELECT name, dept_id, salary,
       FIRST_VALUE(salary) OVER (PARTITION BY dept_id ORDER BY hire_date) as first_salary
FROM employees;
```

#tip[
  窗口函数是SQL的高级特性，能解决很多复杂的分析问题。MySQL 8.0+、PostgreSQL等都支持。
]

== 索引技术

索引是提高数据库查询性能的关键技术，类似于书籍的目录。

#note[
  索引的核心思想是*用空间换时间*：占用额外存储空间，换取查询速度的大幅提升。
]

=== 索引的基本概念

==== 为什么需要索引

*没有索引*：

```sql
SELECT * FROM students WHERE name = '张三';
-- 全表扫描，时间复杂度 O(n)
```

*有索引*：

```sql
CREATE INDEX idx_name ON students(name);
-- 索引查找，时间复杂度 O(log n)
```

*性能对比*：

```text
100万条数据：
- 全表扫描：平均50万次比较
- B+树索引：约20次比较（log₂(1000000) ≈ 20）
```

==== 索引的代价

- *空间开销*：索引占用额外存储空间
- *维护成本*：INSERT、UPDATE、DELETE时需要更新索引
- *选择成本*：优化器需要选择最优索引

#tip[
  不是索引越多越好。频繁更新的列不适合建索引。
]

=== B+树索引

B+树是最常用的索引结构，被MySQL InnoDB、Oracle等广泛使用。

==== B+树的结构

```text
        [10, 20, 30]        ← 根节点（内部节点）
       /    |    |    \
  [5,10] [15,20] [25,30] [35,40]  ← 内部节点
   /  \   /  \   /  \   /   \
 [1][2][3][4][5][6][7][8][9][10]... ← 叶子节点（存储数据）
```

*特点*：

- 所有数据都存储在叶子节点
- 叶子节点之间用链表连接（支持范围查询）
- 非叶子节点只存储键值和指针
- 树的高度通常为2-4层

==== B+树的优势

1. *磁盘I/O效率高*：
  - 每个节点大小等于磁盘页大小（通常16KB）
  - 一次I/O可以读取整个节点
  - 树高度低，I/O次数少

2. *范围查询高效*：
  - 叶子节点链表支持顺序遍历
  - `WHERE age BETWEEN 20 AND 30` 非常高效

3. *稳定性能*：
  - 任何查询都需要从根到叶子的路径
  - 时间复杂度稳定为 O(log n)

==== B+树的创建与维护

```sql
-- 创建索引
CREATE INDEX idx_name ON students(name);

-- 创建联合索引
CREATE INDEX idx_dept_age ON students(dept_id, age);

-- 查看索引
SHOW INDEX FROM students;

-- 删除索引
DROP INDEX idx_name ON students;
```

#caution[
  B+树索引适合等值查询和范围查询，但不适合模糊查询的前缀通配符（如 '%abc'）。
]

=== 哈希索引

哈希索引基于哈希表实现，适合等值查询。

==== 哈希索引的结构

```text
键值      哈希函数      桶
"Alice"  ──────→  Bucket[3] → [记录指针]
"Bob"    ──────→  Bucket[7] → [记录指针]
"Carol"  ──────→  Bucket[3] → [记录指针]  ← 哈希冲突
```

*特点*：

- 通过哈希函数直接定位
- 时间复杂度 O(1)
- 不支持范围查询
- 可能存在哈希冲突

==== 哈希索引 vs B+树索引

#tex-table(
  ("特性", "B+树索引", "哈希索引"),
  ("等值查询", "O(log n)", "O(1)"),
  ("范围查询", "支持", "不支持"),
  ("排序", "支持", "不支持"),
  ("前缀匹配", "支持", "不支持"),
  ("空间利用", "较高", "较低"),
  ("适用场景", "通用", "仅等值查询"),
)

==== 哈希索引的使用

```sql
-- MySQL Memory引擎默认使用哈希索引
CREATE TABLE sessions (
    session_id VARCHAR(64) PRIMARY KEY,
    data TEXT
) ENGINE=Memory;

-- InnoDB的自适应哈希索引（自动创建）
-- 无法手动控制，由InnoDB根据访问模式自动决定
```

#note[
  InnoDB引擎不支持显式创建哈希索引，但会根据访问模式自动创建自适应哈希索引。
]

=== 聚簇索引与非聚簇索引

==== 聚簇索引（Clustered Index）

*定义*：数据行本身按照索引顺序存储。

*特点*：

- 一个表只能有一个聚簇索引
- InnoDB的主键就是聚簇索引
- 叶子节点存储完整的数据行

```text
聚簇索引结构：
        [10, 20]
       /        \
  [1-10]      [11-20]
    |            |
  [完整行]    [完整行]
```

==== 非聚簇索引（Secondary Index）

*定义*：索引和数据分开存储。

*特点*：

- 一个表可以有多个非聚簇索引
- 叶子节点存储主键值
- 需要回表查询（先查索引，再查主键索引）

```text
非聚簇索引结构：
        ["Alice", "Bob"]
       /              \
  ["Alice"]        ["Bob"]
     |                |
  [PK=001]        [PK=002]  ← 指向聚簇索引
```

==== 覆盖索引（Covering Index）

*定义*：查询的所有列都在索引中，无需回表。

```sql
-- 假设创建了联合索引 idx_dept_age(dept_id, age)

-- 覆盖索引查询（快）
SELECT dept_id, age FROM students WHERE dept_id = 'CS01';

-- 非覆盖索引查询（慢，需要回表）
SELECT dept_id, age, name FROM students WHERE dept_id = 'CS01';
```

#tip[
  尽量设计覆盖索引，避免回表操作，可以显著提升查询性能。
]

=== 索引优化策略

==== 最左前缀原则

对于联合索引 `(a, b, c)`：

```sql
-- 可以使用索引
WHERE a = 1
WHERE a = 1 AND b = 2
WHERE a = 1 AND b = 2 AND c = 3

-- 不能使用索引
WHERE b = 2
WHERE c = 3
WHERE b = 2 AND c = 3
```

==== 索引失效的场景

```sql
-- 1. 对索引列使用函数
WHERE YEAR(create_time) = 2024  -- 索引失效
WHERE create_time >= '2024-01-01' AND create_time < '2025-01-01'  -- 索引有效

-- 2. 类型转换
WHERE phone = 13800138000  -- phone是VARCHAR，索引失效
WHERE phone = '13800138000'  -- 索引有效

-- 3. 模糊查询前缀通配符
WHERE name LIKE '%张'  -- 索引失效
WHERE name LIKE '张%'  -- 索引有效

-- 4. OR条件
WHERE id = 1 OR name = '张三'  -- 如果name没有索引，全表扫描

-- 5. NOT、!=、<>
WHERE age != 20  -- 索引可能失效

-- 6. IS NULL
WHERE age IS NULL  -- 取决于数据分布
```

==== 索引选择建议

#tex-table(
  ("场景", "建议"),
  ("高频查询列", "建立索引"),
  ("区分度高的列", "优先索引"),
  ("频繁更新的列", "避免索引"),
  ("小表", "不需要索引"),
  ("TEXT/BLOB", "使用前缀索引"),
  ("联合查询", "考虑联合索引"),
)

==== 前缀索引

对于长字符串，可以只索引前缀：

```sql
-- 只索引前10个字符
CREATE INDEX idx_email ON students(email(10));
```

*优点*：节省空间
*缺点*：可能增加冲突

#caution[
  定期分析索引使用情况，删除未使用的索引：
  `SELECT * FROM sys.schema_unused_indexes;`
]

== 视图与存储过程

=== 视图（View）

视图是虚拟表，基于SQL查询结果集。

==== 创建视图

```sql
-- 基本视图
CREATE VIEW v_computer_students AS
SELECT id, name, age, email
FROM students
WHERE dept_id = 'CS01';

-- 复杂视图
CREATE VIEW v_student_grades AS
SELECT
    s.id,
    s.name,
    c.name AS course_name,
    g.score,
    RANK() OVER (PARTITION BY c.id ORDER BY g.score DESC) as rank
FROM students s
JOIN enrollments e ON s.id = e.student_id
JOIN courses c ON e.course_id = c.id
JOIN grades g ON e.id = g.enrollment_id;
```

==== 使用视图

```sql
-- 像普通表一样查询
SELECT * FROM v_computer_students WHERE age > 20;

-- 连接视图
SELECT v.*, d.name as dept_name
FROM v_computer_students v
JOIN departments d ON v.dept_id = d.id;
```

==== 视图的优势

1. *简化查询*：封装复杂逻辑
2. *安全性*：隐藏敏感字段
3. *逻辑独立性*：底层表结构变化不影响应用
4. *代码复用*：避免重复编写相同查询

==== 视图的限制

- 某些视图不可更新（包含聚合、GROUP BY等）
- 性能可能不如直接查询
- 嵌套视图可能导致性能问题

```sql
-- 可更新视图
CREATE VIEW v_active_students AS
SELECT id, name, email
FROM students
WHERE status = 'active';

UPDATE v_active_students SET email = 'new@example.com' WHERE id = '001';  -- 可以

-- 不可更新视图
CREATE VIEW v_avg_grades AS
SELECT student_id, AVG(score) as avg_score
FROM grades
GROUP BY student_id;

UPDATE v_avg_grades SET avg_score = 90;  -- 错误！
```

#tip[
  视图不会存储数据，每次查询都会执行底层SQL。如果需要物化结果，使用物化视图（Materialized View）。
]

=== 存储过程（Stored Procedure）

存储过程是预编译的SQL代码块，存储在数据库中。

==== 创建存储过程

```sql
DELIMITER //

CREATE PROCEDURE sp_transfer_money(
    IN from_account VARCHAR(20),
    IN to_account VARCHAR(20),
    IN amount DECIMAL(10, 2),
    OUT result VARCHAR(50)
)
BEGIN
    DECLARE from_balance DECIMAL(10, 2);
    DECLARE exit handler FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET result = 'TRANSFER_FAILED';
    END;

    START TRANSACTION;

    -- 检查余额
    SELECT balance INTO from_balance
    FROM accounts
    WHERE account_id = from_account
    FOR UPDATE;

    IF from_balance < amount THEN
        ROLLBACK;
        SET result = 'INSUFFICIENT_BALANCE';
    ELSE
        -- 扣款
        UPDATE accounts
        SET balance = balance - amount
        WHERE account_id = from_account;

        -- 存款
        UPDATE accounts
        SET balance = balance + amount
        WHERE account_id = to_account;

        COMMIT;
        SET result = 'SUCCESS';
    END IF;
END //

DELIMITER ;
```

==== 调用存储过程

```sql
CALL sp_transfer_money('A001', 'B002', 1000.00, @result);
SELECT @result;  -- 查看结果
```

==== 存储过程的优势

1. *性能*：预编译，减少网络传输
2. *安全*：可以控制权限
3. *封装*：隐藏业务逻辑
4. *维护*：集中管理业务规则

==== 存储过程的劣势

1. *调试困难*：不如应用代码易调试
2. *移植性差*：不同DBMS语法差异大
3. *版本控制*：难以纳入版本管理系统
4. *扩展性*：不适合复杂业务逻辑

#note[
  现代开发趋势是将业务逻辑放在应用层，数据库层只做数据存储和简单查询。
]

=== 函数（Function）

函数与存储过程类似，但必须返回值。

```sql
DELIMITER //

CREATE FUNCTION fn_calculate_age(birth_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, birth_date, CURDATE());
END //

DELIMITER ;

-- 使用函数
SELECT name, fn_calculate_age(birth_date) as age
FROM students;
```

*存储过程 vs 函数*：

#tex-table(
  ("特性", "存储过程", "函数"),
  ("返回值", "可选（OUT参数）", "必须"),
  ("调用方式", "CALL", "SELECT/表达式"),
  ("事务控制", "支持", "不支持"),
  ("SQL语句", "任意", "有限制"),
  ("用途", "业务逻辑", "计算"),
)

== 触发器与事件调度

=== 触发器（Trigger）

触发器是在特定事件发生时自动执行的代码块。

==== 触发器的类型

*按触发时机*：

- BEFORE：在操作之前执行
- AFTER：在操作之后执行

*按触发事件*：

- INSERT
- UPDATE
- DELETE

==== 创建触发器

```sql
DELIMITER //

-- 审计触发器
CREATE TRIGGER trg_student_audit
AFTER INSERT ON students
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (
        table_name, operation, record_id,
        operation_time, operator
    ) VALUES (
        'students', 'INSERT', NEW.id,
        NOW(), CURRENT_USER()
    );
END //

-- 级联更新触发器
CREATE TRIGGER trg_update_dept_count
AFTER INSERT ON students
FOR EACH ROW
BEGIN
    UPDATE departments
    SET student_count = student_count + 1
    WHERE id = NEW.dept_id;
END //

-- 数据验证触发器
CREATE TRIGGER trg_validate_salary
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary cannot be negative';
    END IF;
END //

DELIMITER ;
```

==== OLD和NEW关键字

- `NEW.column`：新值（INSERT和UPDATE可用）
- `OLD.column`：旧值（UPDATE和DELETE可用）

```sql
CREATE TRIGGER trg_log_salary_change
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    IF OLD.salary != NEW.salary THEN
        INSERT INTO salary_history (
            employee_id, old_salary, new_salary, change_date
        ) VALUES (
            NEW.id, OLD.salary, NEW.salary, NOW()
        );
    END IF;
END;
```

==== 触发器的优势

1. *自动化*：自动执行业务规则
2. *一致性*：保证数据完整性
3. *审计*：记录数据变更历史
4. *封装*：隐藏复杂逻辑

==== 触发器的劣势

1. *隐蔽性*：不易发现，调试困难
2. *性能*：可能影响批量操作性能
3. *维护*：逻辑分散，难以追踪
4. *递归*：可能触发连锁反应

#caution[
  谨慎使用触发器，复杂的业务逻辑应该在应用层处理。
]

==== 管理触发器

```sql
-- 查看所有触发器
SHOW TRIGGERS;

-- 查看特定表的触发器
SELECT * FROM information_schema.TRIGGERS
WHERE EVENT_OBJECT_TABLE = 'students';

-- 删除触发器
DROP TRIGGER IF EXISTS trg_student_audit;
```

=== 事件调度器（Event Scheduler）

事件调度器用于定时执行任务，类似于cron job。

==== 启用事件调度器

```sql
-- 查看状态
SHOW VARIABLES LIKE 'event_scheduler';

-- 启用
SET GLOBAL event_scheduler = ON;

-- 永久启用（my.cnf）
-- [mysqld]
-- event_scheduler=ON
```

==== 创建事件

```sql
-- 每天凌晨清理过期数据
CREATE EVENT evt_cleanup_expired_data
ON SCHEDULE EVERY 1 DAY
STARTS '2024-01-01 00:00:00'
DO
    DELETE FROM sessions
    WHERE expire_time < NOW();

-- 每小时统计一次
CREATE EVENT evt_hourly_stats
ON SCHEDULE EVERY 1 HOUR
DO
    INSERT INTO hourly_stats (
        stat_time, total_users, active_users
    )
    SELECT
        NOW(),
        COUNT(*),
        SUM(CASE WHEN last_login > NOW() - INTERVAL 1 HOUR THEN 1 ELSE 0 END)
    FROM users;

-- 一次性事件
CREATE EVENT evt_cleanup_once
ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 1 HOUR
DO
    CALL sp_cleanup_temp_tables();
```

==== 事件调度选项

```sql
-- 指定结束时间
ON SCHEDULE EVERY 1 DAY
ENDS '2024-12-31 23:59:59'

-- 禁用/启用
ALTER EVENT evt_cleanup_expired_data DISABLE;
ALTER EVENT evt_cleanup_expired_data ENABLE;

-- 修改调度
ALTER EVENT evt_cleanup_expired_data
ON SCHEDULE EVERY 12 HOUR;

-- 删除事件
DROP EVENT IF EXISTS evt_cleanup_expired_data;
```

==== 查看事件

```sql
-- 查看所有事件
SHOW EVENTS;

-- 查看详细信息
SELECT * FROM information_schema.EVENTS
WHERE EVENT_NAME = 'evt_cleanup_expired_data';
```

#tip[
  事件调度器适合定期维护任务，如数据清理、统计汇总、备份等。
]

== 数据库规范化理论

规范化是设计关系数据库的理论指导，目的是减少数据冗余，避免更新异常。

=== 函数依赖

*定义*：设R(U)是属性集U上的关系模式，X, Y是U的子集。若对于R(U)的任意一个可能的关系r，r中不可能存在两个元组在X上的属性值相等，而在Y上的属性值不等，则称X函数确定Y或Y函数依赖于X，记作 X → Y。

*示例*：

```
学生(学号, 姓名, 系别, 系主任)

学号 → 姓名    （学号决定姓名）
学号 → 系别    （学号决定系别）
系别 → 系主任  （系别决定系主任）
学号 → 系主任  （传递依赖）
```

=== 范式（Normal Form）

==== 第一范式（1NF）

*定义*：关系中的每个属性都是不可分割的原子值。

*不满足1NF*：

```text
┌──────┬────────────┐
│ 学号 │   课程      │
├──────┼────────────┤
│ 001  │ 数学,物理  │  ← 课程不是原子值
└──────┴────────────┘
```

*满足1NF*：

```text
┌──────┬──────┐
│ 学号 │ 课程 │
├──────┼──────┤
│ 001  │ 数学 │
│ 001  │ 物理 │
└──────┴──────┘
```

#note[
  关系模型天然满足1NF，因为关系的定义要求属性是原子的。
]

==== 第二范式（2NF）

*定义*：满足1NF，且每个非主属性完全函数依赖于码（不存在部分依赖）。

*问题示例*：

```text
选课(学号, 课程号, 成绩, 课程名, 学分)
码：(学号, 课程号)

部分依赖：
(学号, 课程号) → 成绩  ✓ 完全依赖
课程号 → 课程名        ✗ 部分依赖
课程号 → 学分          ✗ 部分依赖
```

*分解为2NF*：

```text
选课(学号, 课程号, 成绩)
课程(课程号, 课程名, 学分)
```

#tip[
  2NF主要解决复合主键的部分依赖问题。如果主键是单属性，自动满足2NF。
]

==== 第三范式（3NF）

*定义*：满足2NF，且每个非主属性不传递依赖于码。

*问题示例*：

```text
学生(学号, 姓名, 系别, 系主任)
码：学号

传递依赖：
学号 → 系别 → 系主任
```

*分解为3NF*：

```text
学生(学号, 姓名, 系别)
系别(系别, 系主任)
```

==== BC范式（BCNF）

*定义*：满足1NF，且对于每一个函数依赖 X → Y（Y ⊄ X），X都包含码。

*通俗理解*：每个决定因素都包含码。

*问题示例*：

```text
选课(学生, 教师, 课程)

函数依赖：
(学生, 课程) → 教师
教师 → 课程

码：(学生, 课程) 和 (学生, 教师)

问题：教师 → 课程，但教师不包含码
```

*分解为BCNF*：

```text
教学(学生, 教师)
授课(教师, 课程)
```

#note[
  BCNF比3NF更严格。大多数情况下，3NF已经足够好。
]

=== 范式对比

#tex-table(
  ("范式", "要求", "解决的问题"),
  ("1NF", "属性原子性", "数据不可分"),
  ("2NF", "消除部分依赖", "数据冗余、插入异常"),
  ("3NF", "消除传递依赖", "数据冗余、更新异常"),
  ("BCNF", "决定因素含码", "剩余的数据冗余"),
)

=== 规范化示例

*原始表*：

```text
订单(订单号, 日期, 客户号, 客户名, 客户地址,
     产品号, 产品名, 单价, 数量, 金额)
```

*分析问题*：

- 客户信息重复（违反3NF）
- 产品信息重复（违反3NF）
- 金额可以计算得出（派生属性）

*规范化后*：

```sql
-- 客户表
CREATE TABLE customers (
    customer_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(50),
    address VARCHAR(200)
);

-- 产品表
CREATE TABLE products (
    product_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100),
    unit_price DECIMAL(10, 2)
);

-- 订单表
CREATE TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    order_date DATE,
    customer_id VARCHAR(10),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- 订单明细表
CREATE TABLE order_items (
    order_id VARCHAR(20),
    product_id VARCHAR(10),
    quantity INT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

#caution[
  规范化程度越高，表越多，查询时需要更多的JOIN操作，可能影响性能。
]

== 反规范化设计与性能优化

反规范化是有意引入冗余以提高查询性能的设计策略。

=== 为什么要反规范化

*规范化的缺点*：

- 表数量多，JOIN操作复杂
- 查询性能可能较差
- 需要更多的I/O操作

*反规范化的优势*：

- 减少JOIN，提高查询速度
- 简化查询逻辑
- 适合读多写少的场景

#tip[
  反规范化是一种权衡：用存储空间和写入性能换取读取性能。
]

=== 常见的反规范化技术

==== 冗余字段

```sql
-- 规范化设计
SELECT o.order_id, c.name, c.address
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

-- 反规范化：在订单表中冗余客户信息
ALTER TABLE orders
ADD COLUMN customer_name VARCHAR(50),
ADD COLUMN customer_address VARCHAR(200);

-- 查询简化
SELECT order_id, customer_name, customer_address
FROM orders
WHERE order_id = 'ORD001';
```

*维护策略*：

```sql
-- 使用触发器保持数据一致
CREATE TRIGGER trg_sync_customer_info
AFTER UPDATE ON customers
FOR EACH ROW
BEGIN
    UPDATE orders
    SET customer_name = NEW.name,
        customer_address = NEW.address
    WHERE customer_id = NEW.customer_id;
END;
```

==== 汇总表

```sql
-- 创建汇总表
CREATE TABLE daily_sales_summary (
    sale_date DATE PRIMARY KEY,
    total_orders INT,
    total_amount DECIMAL(12, 2),
    avg_order_amount DECIMAL(10, 2)
);

-- 定时更新（使用事件调度器）
CREATE EVENT evt_update_daily_summary
ON SCHEDULE EVERY 1 DAY
DO
    INSERT INTO daily_sales_summary (
        sale_date, total_orders, total_amount, avg_order_amount
    )
    SELECT
        DATE(order_date),
        COUNT(*),
        SUM(amount),
        AVG(amount)
    FROM orders
    WHERE DATE(order_date) = CURDATE() - INTERVAL 1 DAY
    ON DUPLICATE KEY UPDATE
        total_orders = VALUES(total_orders),
        total_amount = VALUES(total_amount),
        avg_order_amount = VALUES(avg_order_amount);
```

==== 物化视图

```sql
-- PostgreSQL物化视图
CREATE MATERIALIZED VIEW mv_monthly_sales AS
SELECT
    DATE_TRUNC('month', order_date) as month,
    COUNT(*) as order_count,
    SUM(amount) as total_sales
FROM orders
GROUP BY DATE_TRUNC('month', order_date);

-- 刷新物化视图
REFRESH MATERIALIZED VIEW mv_monthly_sales;

-- MySQL可以使用表模拟
CREATE TABLE mv_monthly_sales AS
SELECT ...
```

==== 宽表设计

将多个相关表合并为一个大宽表：

```sql
CREATE TABLE order_wide_table (
    order_id VARCHAR(20) PRIMARY KEY,
    order_date DATE,
    customer_id VARCHAR(10),
    customer_name VARCHAR(50),      -- 冗余
    customer_email VARCHAR(100),    -- 冗余
    product_id VARCHAR(10),
    product_name VARCHAR(100),      -- 冗余
    product_category VARCHAR(50),   -- 冗余
    quantity INT,
    unit_price DECIMAL(10, 2),
    total_amount DECIMAL(12, 2)
);
```

*适用场景*：

- 数据仓库
- OLAP分析
- 报表系统

#note[
  宽表设计在OLTP系统中应谨慎使用，更适合OLAP场景。
]

=== 反规范化的原则

==== 何时使用反规范化

#tex-table(
  ("场景", "建议"),
  ("读多写少", "适合反规范化"),
  ("实时性要求高", "适合反规范化"),
  ("复杂JOIN频繁", "考虑反规范化"),
  ("写多读少", "保持规范化"),
  ("数据一致性要求高", "谨慎反规范化"),
  ("存储空间紧张", "保持规范化"),
)

==== 最佳实践

1. *先规范化，后反规范化*：
  - 先设计规范的数据库
  - 根据性能瓶颈进行反规范化

2. *文档化*：
  - 记录所有冗余字段
  - 说明维护策略

3. *自动化维护*：
  - 使用触发器
  - 使用定时任务
  - 使用应用层逻辑

4. *监控一致性*：
  - 定期检查数据一致性
  - 提供数据修复工具

5. *权衡利弊*：
  - 评估性能提升
  - 评估维护成本
  - 评估一致性风险

=== 性能优化综合策略

==== 查询优化

```sql
-- 1. 避免SELECT *
SELECT id, name FROM students;  -- 好
SELECT * FROM students;          -- 不好

-- 2. 使用EXISTS代替IN
SELECT * FROM departments d
WHERE EXISTS (
    SELECT 1 FROM students s WHERE s.dept_id = d.id
);

-- 3. 避免在索引列上使用函数
WHERE create_time >= '2024-01-01'  -- 好
WHERE YEAR(create_time) = 2024     -- 不好

-- 4. 使用LIMIT限制结果集
SELECT * FROM students LIMIT 100;

-- 5. 分析查询计划
EXPLAIN SELECT * FROM students WHERE dept_id = 'CS01';
```

==== 配置优化

```sql
-- MySQL配置优化示例

-- 缓冲池大小（建议为物理内存的50-70%）
SET GLOBAL innodb_buffer_pool_size = 4294967296;  -- 4GB

-- 连接数
SET GLOBAL max_connections = 500;

-- 查询缓存（MySQL 8.0已移除）
-- query_cache_size = 64M

-- 日志配置
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 2;  -- 超过2秒的记录
```

==== 硬件优化

- 使用SSD替代HDD
- 增加内存（提高缓存命中率）
- RAID配置（RAID 10适合数据库）
- 专用数据库服务器

==== 架构优化

- 读写分离
- 分库分表
- 缓存层（Redis、Memcached）
- CDN加速静态资源

== 锁机制与并发控制

锁是数据库实现并发控制的核心机制，用于保证多事务并发执行时的数据一致性。

#note[
  锁的本质是*协调多个进程/线程对共享资源的访问*，在保证一致性的同时尽可能提高并发性。
]

=== 锁的类型

==== 共享锁（S锁，读锁）

*定义*：允许事务读取数据，其他事务也可以获得共享锁，但不能获得排他锁。

*特点*：

- 多个事务可以同时持有S锁
- 持有S锁期间，其他事务不能获取X锁
- 用于读操作

```sql
-- MySQL中显式加共享锁
SELECT * FROM students WHERE id = '001' LOCK IN SHARE MODE;
```

==== 排他锁（X锁，写锁）

*定义*：允许事务修改数据，其他事务不能获得任何类型的锁。

*特点*：

- 只有一个事务可以持有X锁
- 持有X锁期间，其他事务不能获取S锁或X锁
- 用于写操作（INSERT、UPDATE、DELETE）

```sql
-- MySQL中显式加排他锁
SELECT * FROM students WHERE id = '001' FOR UPDATE;
```

==== 意向锁（Intention Lock）

*定义*：表级锁，表示事务打算在行上加什么类型的锁。

*类型*：

- *意向共享锁（IS）*：事务打算在行上加S锁
- *意向排他锁（IX）*：事务打算在行上加X锁

*作用*：

- 快速判断表是否可以加表锁
- 避免遍历所有行检查锁状态

```text
示例：
事务T1要在某行加X锁：
1. 先在表上加IX锁
2. 再在行上加X锁

事务T2要对整个表加X锁：
- 检查表上有IX锁 → 冲突 → 等待
```

#tip[
  意向锁是InnoDB自动添加的，用户无法手动控制。
]

=== 锁的粒度

#tex-table(
  ("锁粒度", "范围", "并发性", "开销", "示例"),
  ("全局锁", "整个数据库", "低", "小", "FTWRL"),
  ("表级锁", "整张表", "中", "小", "LOCK TABLES"),
  ("页级锁", "数据页", "较高", "中", "BDB引擎"),
  ("行级锁", "单行记录", "高", "大", "InnoDB默认"),
)

==== 行级锁（Row-Level Lock）

*特点*：

- 粒度最小，并发性最高
- 开销最大
- InnoDB默认使用

*实现*：通过索引项加锁

```sql
-- 如果id有索引，只锁定该行
SELECT * FROM students WHERE id = '001' FOR UPDATE;

-- 如果id没有索引，会锁定全表！（退化为表锁）
SELECT * FROM students WHERE name = '张三' FOR UPDATE;
```

#caution[
  行锁是通过索引实现的，如果查询条件没有用到索引，会升级为表锁！
]

==== 表级锁（Table-Level Lock）

*特点*：

- 粒度大，并发性低
- 开销小
- MyISAM引擎使用

```sql
-- 显式加表锁
LOCK TABLES students READ;
LOCK TABLES students WRITE;

-- 释放锁
UNLOCK TABLES;
```

==== 页级锁（Page-Level Lock）

*特点*：

- 介于行锁和表锁之间
- Berkeley DB引擎使用
- MySQL中较少见

=== InnoDB的锁算法

==== 记录锁（Record Lock）

*定义*：锁定索引记录本身。

```sql
-- 锁定id='001'这一行
SELECT * FROM students WHERE id = '001' FOR UPDATE;
```

==== 间隙锁（Gap Lock）

*定义*：锁定索引记录之间的间隙，防止其他事务插入新记录。

*示例*：

```text
表中有记录：id = 1, 3, 5, 7

事务T1执行：
SELECT * FROM students WHERE id = 4 FOR UPDATE;

间隙锁锁定：(3, 5) 这个区间

事务T2尝试：
INSERT INTO students VALUES (4, ...);  -- 被阻塞！
```

*作用*：防止幻读

#note[
  间隙锁只在可重复读（REPEATABLE READ）隔离级别下生效。
]

==== 临键锁（Next-Key Lock）

*定义*：记录锁 + 间隙锁的组合，锁定一个范围并包括记录本身。

*示例*：

```text
表中有记录：id = 1, 3, 5, 7

事务T1执行：
SELECT * FROM students WHERE id = 3 FOR UPDATE;

临键锁锁定：(1, 3] 这个区间（不包括1，包括3）
```

*锁定规则*：

```text
对于索引值：1, 3, 5, 7

可能的临键锁区间：
(-∞, 1]
(1, 3]
(3, 5]
(5, 7]
(7, +∞)
```

#tip[
  临键锁是InnoDB在RR级别下防止幻读的关键机制。
]

=== 死锁（Deadlock）

==== 死锁的产生

当两个或多个事务互相等待对方释放锁时，形成循环等待。

```text
时间    事务T1                  事务T2
─────────────────────────────────────────────
t1      LOCK X on A
                            t2  LOCK X on B
t3      LOCK X on B  ← 等待T2释放
                            t4  LOCK X on A  ← 等待T1释放

结果：死锁！
```

==== 死锁的必要条件

1. *互斥条件*：资源一次只能被一个事务占用
2. *请求与保持*：事务持有资源的同时请求新资源
3. *不可剥夺*：资源不能被强制剥夺
4. *循环等待*：存在循环等待链

==== 死锁的检测与处理

*InnoDB的死锁检测*：

- 维护等待图（Wait-For Graph）
- 定期检测图中是否有环
- 发现死锁后，回滚代价最小的事务

```sql
-- 查看死锁信息
SHOW ENGINE INNODB STATUS\G

-- 输出中包含：
-- LATEST DETECTED DEADLOCK
-- 显示死锁的详细信息
```

*配置参数*：

```sql
-- 死锁检测超时时间（秒）
SET GLOBAL innodb_lock_wait_timeout = 50;

-- 是否启用死锁检测
SET GLOBAL innodb_deadlock_detect = ON;
```

==== 死锁的预防

1. *固定顺序加锁*：
  ```sql
  -- 所有事务都按相同顺序访问资源
  -- T1: LOCK A, then LOCK B
  -- T2: LOCK A, then LOCK B  （不是先B后A）
  ```

2. *一次性加锁*：
  - 事务开始时获取所有需要的锁
  - 缺点：资源利用率低

3. *设置超时*：
  ```sql
  SET innodb_lock_wait_timeout = 10;
  -- 超过10秒未获取锁，自动回滚
  ```

4. *使用较低的隔离级别*：
  - READ COMMITTED不使用间隙锁
  - 减少死锁概率

#caution[
  死锁是正常现象，应用层应该有重试机制。
]

==== 死锁的处理策略

*应用层重试*：

```python
import time
import MySQLdb

def execute_with_retry(sql, max_retries=3):
    for attempt in range(max_retries):
        try:
            cursor.execute(sql)
            connection.commit()
            return
        except MySQLdb.OperationalError as e:
            if e.args[0] == 1213:  # 死锁错误码
                connection.rollback()
                time.sleep(0.1 * (2 ** attempt))  # 指数退避
                continue
            raise
    raise Exception("Max retries exceeded")
```

== 事务隔离级别

事务隔离级别决定了事务之间的可见性和并发程度。

=== SQL标准定义的隔离级别

#tex-table(
  ("隔离级别", "脏读", "不可重复读", "幻读"),
  ("READ UNCOMMITTED", "可能", "可能", "可能"),
  ("READ COMMITTED", "不可能", "可能", "可能"),
  ("REPEATABLE READ", "不可能", "不可能", "可能"),
  ("SERIALIZABLE", "不可能", "不可能", "不可能"),
)

注：InnoDB在RR级别下通过MVCC和临键锁解决了幻读问题。

=== 各隔离级别详解

==== 读未提交（READ UNCOMMITTED）

*特点*：

- 最低隔离级别
- 可以读取其他事务未提交的数据
- 并发性最高，但安全性最低

*示例*：

```sql
-- 事务T1
START TRANSACTION;
UPDATE accounts SET balance = balance - 100 WHERE id = 'A';
-- 尚未COMMIT

-- 事务T2（READ UNCOMMITTED级别）
SELECT balance FROM accounts WHERE id = 'A';
-- 读到的是T1未提交的值（脏读）

-- T1回滚
ROLLBACK;

-- T2读到的数据是错误的！
```

*使用场景*：几乎不使用，除非对数据准确性要求极低

==== 读已提交（READ COMMITTED，RC）

*特点*：

- Oracle、SQL Server的默认级别
- 只能读取已提交的数据
- 解决脏读，但存在不可重复读

*示例*：

```sql
-- 事务T1
START TRANSACTION;
SELECT balance FROM accounts WHERE id = 'A';  -- 余额1000

-- 事务T2
START TRANSACTION;
UPDATE accounts SET balance = 900 WHERE id = 'A';
COMMIT;

-- 事务T1再次查询
SELECT balance FROM accounts WHERE id = 'A';  -- 余额900（不可重复读）
```

*InnoDB的实现*：

- 每次SELECT都创建新的ReadView
- 看到最新已提交的数据

*优点*：

- 减少锁竞争
- 适合写多读少的场景

#tip[
  RC级别下，InnoDB使用快照读（Snapshot Read），不加锁。
]

==== 可重复读（REPEATABLE READ，RR）

*特点*：

- MySQL InnoDB的默认级别
- 同一事务中多次读取结果一致
- 解决脏读和不可重复读

*示例*：

```sql
-- 事务T1
START TRANSACTION;
SELECT balance FROM accounts WHERE id = 'A';  -- 余额1000

-- 事务T2
START TRANSACTION;
UPDATE accounts SET balance = 900 WHERE id = 'A';
COMMIT;

-- 事务T1再次查询
SELECT balance FROM accounts WHERE id = 'A';  -- 仍然是1000（可重复读）
```

*InnoDB的实现*：

- 事务开始时创建ReadView
- 整个事务期间使用同一个ReadView
- 配合MVCC实现一致性读

*幻读问题*：

```sql
-- 事务T1
START TRANSACTION;
SELECT * FROM students WHERE age > 20;  -- 返回2条

-- 事务T2
INSERT INTO students VALUES ('003', '王五', 25);
COMMIT;

-- 事务T1再次查询
SELECT * FROM students WHERE age > 20;  -- 仍然返回2条（RR级别）

-- 但如果T1尝试更新
UPDATE students SET age = 21 WHERE age > 20;  -- 会影响3条（包括T2插入的）
```

#note[
  InnoDB通过临键锁（Next-Key Lock）在RR级别下防止了大部分幻读场景。
]

==== 串行化（SERIALIZABLE）

*特点*：

- 最高隔离级别
- 事务串行执行
- 解决所有并发问题
- 性能最差

*实现*：

- 所有SELECT自动加共享锁
- 相当于单线程执行

```sql
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

START TRANSACTION;
SELECT * FROM students WHERE id = '001';  -- 自动加S锁
-- 其他事务不能修改这行，直到本事务结束
```

*使用场景*：

- 对数据一致性要求极高
- 并发量低的场景
- 金融系统等关键业务

#caution[
  SERIALIZABLE级别会严重降低并发性能，慎用！
]

=== 隔离级别的实现机制

==== 基于锁的实现

- SERIALIZABLE：完全基于锁
- RR：锁 + MVCC
- RC：MVCC为主
- RU：几乎不加锁

==== 基于MVCC的实现

- RC和RR主要依赖MVCC
- 通过ReadView控制可见性
- 减少锁的使用，提高并发

=== 选择合适的隔离级别

#tex-table(
  ("场景", "推荐级别", "原因"),
  ("一般业务", "RR", "MySQL默认，平衡性能和一致性"),
  ("高并发写入", "RC", "减少锁竞争"),
  ("数据分析", "RC", "需要最新数据"),
  ("金融交易", "RR或SERIALIZABLE", "强一致性要求"),
  ("报表统计", "RC", "容忍轻微不一致"),
)

#tip[
  大多数应用使用默认的RR级别即可。如果有特殊需求，再考虑调整。
]

== MVCC 原理

MVCC（Multi-Version Concurrency Control，多版本并发控制）是实现高并发的重要技术。

#note[
  MVCC的核心思想是*保存数据的历史版本*，通过版本控制实现非阻塞读。
]

=== MVCC的基本概念

==== 什么是MVCC

MVCC允许读写操作不互相阻塞：

- 读操作读取历史版本（快照读）
- 写操作创建新版本
- 读写互不干扰

*对比传统锁机制*：

```text
传统锁：
读 ──→ 加S锁 ──→ 读取 ──→ 释放锁
写 ──→ 加X锁 ──→ 修改 ──→ 释放锁
读和写互相阻塞

MVCC：
读 ──→ 读取快照（不加锁）
写 ──→ 创建新版本
读和写不阻塞
```

==== InnoDB中的MVCC实现

InnoDB通过以下机制实现MVCC：

1. *隐藏字段*：每行记录包含隐藏列
2. *Undo Log*：保存历史版本
3. *ReadView*：控制版本可见性

=== InnoDB的行记录结构

==== 隐藏字段

InnoDB的每行记录包含三个隐藏字段：

#tex-table(
  ("字段", "说明", "用途"),
  ("DB_TRX_ID", "最近修改事务ID", "判断版本可见性"),
  ("DB_ROLL_PTR", "回滚指针", "指向Undo Log"),
  ("DB_ROW_ID", "隐藏行ID", "生成聚簇索引"),
)

```text
行记录结构：
┌──────────────┬──────────────┬──────────────┬──────────────┐
│ DB_TRX_ID    │ DB_ROLL_PTR  │ DB_ROW_ID    │ 实际数据     │
│ (6字节)      │ (7字节)      │ (6字节)      │ (变长)       │
└──────────────┴──────────────┴──────────────┴──────────────┘
```

=== Undo Log与版本链

==== Undo Log

*定义*：记录数据修改前的值，用于回滚和MVCC。

*类型*：

- *Insert Undo Log*：INSERT操作产生，事务提交后可删除
- *Update Undo Log*：UPDATE/DELETE操作产生，需要保留供MVCC使用

==== 版本链

多次修改同一行记录时，通过回滚指针形成版本链：

```text
当前版本 (TRX_ID=103)
    ↑
DB_ROLL_PTR
    ↑
历史版本1 (TRX_ID=102)
    ↑
DB_ROLL_PTR
    ↑
历史版本2 (TRX_ID=101)
    ↑
DB_ROLL_PTR
    ↑
初始版本 (TRX_ID=100)
```

*示例*：

```sql
-- 初始状态：balance = 1000 (TRX_ID=100)

-- 事务T1 (TRX_ID=101)
UPDATE accounts SET balance = 900 WHERE id = 'A';
-- 创建新版本：balance = 900 (TRX_ID=101)
-- Undo Log记录：balance = 1000

-- 事务T2 (TRX_ID=102)
UPDATE accounts SET balance = 800 WHERE id = 'A';
-- 创建新版本：balance = 800 (TRX_ID=102)
-- Undo Log记录：balance = 900

-- 版本链：
-- 800 (TRX=102) → 900 (TRX=101) → 1000 (TRX=100)
```

=== ReadView（读视图）

ReadView是MVCC的核心，决定事务能看到哪个版本的数据。

==== ReadView的结构

```text
ReadView包含：
- m_ids: 活跃事务ID列表（启动ReadView时还未提交的事务）
- min_trx_id: m_ids中的最小值
- max_trx_id: 下一个要分配的事务ID
- creator_trx_id: 创建ReadView的事务ID
```

==== 可见性判断算法

对于某个版本的数据（TRX_ID = trx_id）：

```text
1. 如果 trx_id < min_trx_id
   → 版本已提交，可见

2. 如果 trx_id >= max_trx_id
   → 版本在ReadView之后生成，不可见

3. 如果 min_trx_id <= trx_id < max_trx_id
   a. 如果 trx_id 在 m_ids 中
      → 事务仍活跃，不可见
   b. 如果 trx_id 不在 m_ids 中
      → 事务已提交，可见
```

*图示*：

```text
事务ID轴：
←──可见──┼────不可见────┼──未来──→
         min_trx_id     max_trx_id

m_ids中的事务ID：不可见
m_ids外且<max的：可见
```

==== RC和RR的ReadView差异

===== READ COMMITTED

- 每次SELECT都创建新的ReadView
- 能看到最新已提交的数据

```text
T1开始 (TRX=100)
  SELECT → 创建ReadView1 (m_ids=[100])

T2提交 (TRX=101)

T1再次SELECT → 创建ReadView2 (m_ids=[100])
  → 能看到T2的修改
```

===== REPEATABLE READ

- 第一次SELECT时创建ReadView
- 整个事务期间复用同一个ReadView

```text
T1开始 (TRX=100)
  SELECT → 创建ReadView (m_ids=[100])

T2提交 (TRX=101)

T1再次SELECT → 复用ReadView (m_ids=[100])
  → 看不到T2的修改（保持一致性）
```

#tip[
  这就是RC和RR级别下行为差异的根本原因！
]

=== MVCC的操作类型

==== 快照读（Snapshot Read）

*定义*：读取数据的快照版本，不加锁。

*特点*：

- 使用MVCC
- 非阻塞
- SELECT语句（不加锁）

```sql
-- 快照读
SELECT * FROM students WHERE id = '001';
SELECT * FROM students WHERE age > 20;
```

==== 当前读（Current Read）

*定义*：读取最新版本的数据，加锁。

*特点*：

- 不使用MVCC
- 阻塞其他事务
- 需要加锁

```sql
-- 当前读
SELECT * FROM students WHERE id = '001' LOCK IN SHARE MODE;  -- S锁
SELECT * FROM students WHERE id = '001' FOR UPDATE;          -- X锁
UPDATE students SET age = 21 WHERE id = '001';               -- X锁
DELETE FROM students WHERE id = '001';                       -- X锁
INSERT INTO students VALUES (...);                           -- X锁
```

#note[
  理解快照读和当前读的区别，是掌握MVCC的关键。
]

=== MVCC的优势与劣势

==== 优势

1. *高并发*：读写不阻塞
2. *无锁读*：提高读取性能
3. *一致性*：提供一致性视图
4. *非阻塞*：减少等待时间

==== 劣势

1. *存储开销*：需要保存多个版本
2. *清理开销*：需要Purge线程清理旧版本
3. *复杂性*：实现复杂，调试困难
4. *长事务问题*：阻止旧版本清理

#caution[
  避免长时间运行的事务，它们会阻止Undo Log的清理，导致存储空间增长。
]

=== MVCC的清理机制

==== Purge线程

InnoDB后台线程负责清理不再需要的版本：

```text
清理条件：
1. 事务已提交
2. 所有活跃的ReadView都不需要该版本

清理过程：
1. 遍历Undo Log
2. 判断版本是否可见
3. 删除不可见的版本
4. 释放空间
```

==== 配置参数

```sql
-- Purge线程数量
SET GLOBAL innodb_purge_threads = 4;

-- Purge批次大小
SET GLOBAL innodb_purge_batch_size = 300;
```




== MySQL 架构与存储引擎

MySQL是最流行的开源关系型数据库，采用插件式存储引擎架构。

#note[
  MySQL的核心设计理念是*模块化*和*可扩展性*，通过插件式存储引擎实现不同场景的优化。
]

=== MySQL整体架构

```
┌─────────────────────────────────────────┐
│          连接池                          │
│  (Connection Pool / Thread Pool)        │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│          SQL接口                         │
│  (SQL Interface)                        │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│          解析器                          │
│  (Parser)                               │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│          优化器                          │
│  (Optimizer)                            │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│          缓存                            │
│  (Cache & Buffer)                       │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│      插件式存储引擎                      │
│  (Pluggable Storage Engines)            │
│  ┌──────┐ ┌──────┐ ┌──────┐            │
│  │InnoDB│ │MyISAM│ │Memory│  ...       │
│  └──────┘ └──────┘ └──────┘            │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│          文件系统                        │
│  (File System)                          │
└─────────────────────────────────────────┘
```

==== 各层职责

1. *连接层*：
  - 处理客户端连接
  - 身份验证
  - 线程管理

2. *SQL接口层*：
  - 接收SQL语句
  - 返回查询结果

3. *解析器*：
  - 词法分析
  - 语法分析
  - 生成解析树

4. *优化器*：
  - 选择最优执行计划
  - 索引选择
  - JOIN顺序优化

5. *缓存层*：
  - Query Cache（MySQL 8.0已移除）
  - Buffer Pool（InnoDB缓冲池）

6. *存储引擎层*：
  - 数据存储和提取
  - 事务支持
  - 锁机制

#tip[
  MySQL的架构设计使得可以轻松添加新的存储引擎，而不需要修改上层代码。
]

=== InnoDB存储引擎

InnoDB是MySQL的默认存储引擎，支持事务和外键。

==== 核心特性

#tex-table(
  ("特性", "InnoDB", "说明"),
  ("事务支持", "✓", "ACID兼容"),
  ("行级锁", "✓", "高并发"),
  ("外键", "✓", "参照完整性"),
  ("MVCC", "✓", "非阻塞读"),
  ("崩溃恢复", "✓", "Redo Log + Undo Log"),
  ("聚簇索引", "✓", "主键组织数据"),
  ("热备份", "✓", "在线备份"),
)

==== 内存结构

===== Buffer Pool

*作用*：缓存数据和索引页

```sql
-- 配置Buffer Pool大小（建议为物理内存的50-70%）
SET GLOBAL innodb_buffer_pool_size = 4G;

-- 查看命中率
SHOW STATUS LIKE 'Innodb_buffer_pool_read%';

-- 命中率计算：
-- (1 - Innodb_buffer_pool_reads / Innodb_buffer_pool_read_requests) * 100%
-- 应该 > 99%
```

*组成*：

- 数据页缓存
- 索引页缓存
- 插入缓冲（Insert Buffer）
- 自适应哈希索引（Adaptive Hash Index）
- 锁信息

===== Redo Log（重做日志）

*作用*：保证事务的持久性

*特点*：

- 物理日志（记录“在某个数据页上做了什么修改”）
- 循环写入
- Crash-Safe能力

```text
Redo Log结构：
┌────────┬────────┬────────┬────────┐
│ write  │ write  │ write  │ write  │
│ pos    │ pos    │ pos    │ pos    │
└────────┴────────┴────────┴────────┘
         ↑
     checkpoint
```

*工作流程*：

```
1. 事务修改数据
2. 先写Redo Log（prepare状态）
3. 再写Binlog
4. 提交事务（commit状态）

如果崩溃：
- Redo Log中有记录 → 恢复数据
- Redo Log中无记录 → 回滚事务
```

===== Undo Log（回滚日志）

*作用*：

- 事务回滚
- MVCC版本控制

*特点*：

- 逻辑日志（记录相反操作）
- INSERT的Undo Log可在事务提交后删除
- UPDATE/DELETE的Undo Log需要保留供MVCC使用

==== 磁盘结构

===== 表空间（Tablespace）

*系统表空间*：

```bash
ibdata1  # 默认系统表空间
```

*独立表空间*（推荐）：

```bash
table_name.ibd  # 每个表一个文件
```

```sql
-- 启用独立表空间（默认开启）
SET GLOBAL innodb_file_per_table = ON;
```

*优势*：

- 便于管理
- 可以快速回收空间
- 支持表级别操作

===== 数据文件结构

```
.ibd文件包含：
- 段（Segment）：表或索引
  - 区（Extent）：1MB = 64个页
    - 页（Page）：16KB（默认）
      - 行记录
```

==== 关键配置参数

```sql
-- Buffer Pool大小
innodb_buffer_pool_size = 4G

-- Buffer Pool实例数（减少锁竞争）
innodb_buffer_pool_instances = 8

-- Redo Log文件大小
innodb_log_file_size = 512M

-- Redo Log文件数量
innodb_log_files_in_group = 2

-- Flush策略
innodb_flush_log_at_trx_commit = 1  -- 最安全
-- 0: 每秒刷盘，性能最好
-- 1: 每次提交刷盘，最安全
-- 2: 每次提交写OS缓存，每秒刷盘

-- IO容量限制
innodb_io_capacity = 200
innodb_io_capacity_max = 2000

-- Purge线程数
innodb_purge_threads = 4
```

#caution[
  `innodb_flush_log_at_trx_commit=1` 是最安全的设置，但性能较差。根据业务需求权衡。
]

=== MyISAM存储引擎

MyISAM是MySQL早期的默认引擎，现在已不推荐使用。

==== 特性对比

#tex-table(
  ("特性", "MyISAM", "InnoDB"),
  ("事务", "✗", "✓"),
  ("行级锁", "✗（只有表锁）", "✓"),
  ("外键", "✗", "✓"),
  ("MVCC", "✗", "✓"),
  ("崩溃恢复", "✗", "✓"),
  ("全文索引", "✓（5.6前）", "✓（5.6+）"),
  ("COUNT(*)", "快（有计数器）", "慢（需扫描）"),
  ("存储空间", "较小", "较大"),
)

==== 适用场景

*适合*：

- 只读或读多写少
- 不需要事务
- 简单的计数操作

*不适合*：

- 需要事务支持
- 高并发写入
- 数据安全性要求高

#note[
  MySQL 5.5之后，InnoDB成为默认引擎。新项目应该使用InnoDB。
]

=== 其他存储引擎

==== Memory引擎

*特点*：

- 数据存储在内存中
- 速度极快
- 重启后数据丢失
- 支持哈希索引

```sql
CREATE TABLE sessions (
    session_id VARCHAR(64) PRIMARY KEY,
    data TEXT
) ENGINE=Memory;
```

*适用场景*：临时表、缓存表

==== Archive引擎

*特点*：

- 高压缩比
- 只支持INSERT和SELECT
- 不支持UPDATE和DELETE
- 适合归档数据

```sql
CREATE TABLE logs_archive (
    id INT AUTO_INCREMENT PRIMARY KEY,
    log_time DATETIME,
    message TEXT
) ENGINE=Archive;
```

==== CSV引擎

*特点*：

- 数据以CSV格式存储
- 可以直接用文本编辑器查看
- 性能较差

*适用场景*：数据交换

=== 存储引擎的选择

#tex-table(
  ("场景", "推荐引擎", "原因"),
  ("通用业务", "InnoDB", "功能全面，支持事务"),
  ("临时数据", "Memory", "速度快"),
  ("日志归档", "Archive", "压缩率高"),
  ("数据交换", "CSV", "易于导入导出"),
  ("只读报表", "MyISAM", "简单计数快"),
)

#tip[
  95%的场景都应该使用InnoDB。只有在特殊需求下才考虑其他引擎。
]

== PostgreSQL 特性与应用

PostgreSQL是最先进的开源关系型数据库，以功能丰富和标准兼容著称。

#note[
  PostgreSQL的核心理念是*扩展性*和*标准兼容性*，被称为“世界上最先进的开源关系型数据库”。
]

=== PostgreSQL vs MySQL

#tex-table(
  ("特性", "PostgreSQL", "MySQL"),
  ("许可证", "PostgreSQL License", "GPL"),
  ("SQL标准", "高度兼容", "部分兼容"),
  ("数据类型", "丰富", "一般"),
  ("JSON支持", "优秀（JSONB）", "良好"),
  ("GIS", "PostGIS（最强）", "一般"),
  ("复制", "流复制+逻辑复制", "主从+组复制"),
  ("分区表", "声明式分区", "支持"),
  ("并行查询", "支持", "支持"),
  ("社区活跃度", "高", "非常高"),
  ("学习曲线", "较陡", "平缓"),
)

=== PostgreSQL的核心特性

==== 丰富的数据类型

```sql
-- 基本类型
CREATE TABLE example (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    age INTEGER,
    salary NUMERIC(10, 2),
    is_active BOOLEAN,
    created_at TIMESTAMP WITH TIME ZONE
);

-- 数组类型
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    tags TEXT[],  -- 文本数组
    prices NUMERIC[]  -- 数字数组
);

-- JSON/JSONB类型
CREATE TABLE documents (
    id SERIAL PRIMARY KEY,
    metadata JSONB  -- 二进制JSON，支持索引
);

-- 范围类型
CREATE TABLE events (
    id SERIAL PRIMARY KEY,
    duration TSRANGE  -- 时间戳范围
);

-- 几何类型
CREATE TABLE locations (
    id SERIAL PRIMARY KEY,
    position POINT,
    area POLYGON
);

-- UUID类型
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100)
);
```

==== 高级索引

```sql
-- B-tree索引（默认）
CREATE INDEX idx_name ON users(name);

-- GIN索引（适合数组、JSONB、全文搜索）
CREATE INDEX idx_tags ON products USING GIN(tags);
CREATE INDEX idx_metadata ON documents USING GIN(metadata);

-- GiST索引（适合几何数据、范围类型）
CREATE INDEX idx_position ON locations USING GIST(position);

-- BRIN索引（适合大型有序表）
CREATE INDEX idx_created_at ON logs USING BRIN(created_at);

-- 部分索引
CREATE INDEX idx_active_users ON users(name) WHERE is_active = true;

-- 表达式索引
CREATE INDEX idx_lower_name ON users(LOWER(name));
```

#tip[
  PostgreSQL的索引类型非常丰富，可以根据数据特点选择最合适的索引。
]

==== 强大的JSON支持

```sql
-- 创建JSONB字段
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    attributes JSONB
);

-- 插入JSON数据
INSERT INTO products (name, attributes) VALUES
('Laptop', '{"brand": "Dell", "cpu": "i7", "ram": 16, "colors": ["black", "silver"]}');

-- 查询JSON字段
SELECT * FROM products
WHERE attributes->>'brand' = 'Dell';

-- 嵌套查询
SELECT * FROM products
WHERE attributes->'cpu' ? 'i7';

-- 数组查询
SELECT * FROM products
WHERE attributes->'colors' ? 'black';

-- 创建GIN索引
CREATE INDEX idx_attributes ON products USING GIN(attributes);
```

==== 窗口函数和CTE

```sql
-- 窗口函数
SELECT
    name,
    department,
    salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) as rank,
    AVG(salary) OVER (PARTITION BY department) as dept_avg
FROM employees;

-- 公用表表达式（CTE）
WITH dept_stats AS (
    SELECT
        department,
        COUNT(*) as emp_count,
        AVG(salary) as avg_salary
    FROM employees
    GROUP BY department
)
SELECT * FROM dept_stats
WHERE emp_count > 10
ORDER BY avg_salary DESC;

-- 递归CTE
WITH RECURSIVE hierarchy AS (
    -- 基础情况
    SELECT id, name, manager_id, 1 as level
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- 递归情况
    SELECT e.id, e.name, e.manager_id, h.level + 1
    FROM employees e
    JOIN hierarchy h ON e.manager_id = h.id
)
SELECT * FROM hierarchy
ORDER BY level, name;
```

==== 全文搜索

```sql
-- 创建表
CREATE TABLE articles (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200),
    content TEXT,
    tsvector_content TSVECTOR
);

-- 生成tsvector
UPDATE articles
SET tsvector_content = to_tsvector('chinese', title || ' ' || content);

-- 创建GIN索引
CREATE INDEX idx_search ON articles USING GIN(tsvector_content);

-- 全文搜索
SELECT * FROM articles
WHERE tsvector_content @@ to_tsquery('chinese', '数据库 & 优化');

-- 排名
SELECT *, ts_rank(tsvector_content, query) as rank
FROM articles,
     to_tsquery('chinese', '数据库') as query
WHERE tsvector_content @@ query
ORDER BY rank DESC;
```

#note[
  对于复杂的全文搜索需求，可以考虑使用Elasticsearch，但PostgreSQL的内置功能已经能满足大部分场景。
]

==== 分区表

```sql
-- 创建分区表
CREATE TABLE measurements (
    id SERIAL,
    city_id INT NOT NULL,
    logdate DATE NOT NULL,
    temperature INT
) PARTITION BY RANGE (logdate);

-- 创建分区
CREATE TABLE measurements_2024_q1
    PARTITION OF measurements
    FOR VALUES FROM ('2024-01-01') TO ('2024-04-01');

CREATE TABLE measurements_2024_q2
    PARTITION OF measurements
    FOR VALUES FROM ('2024-04-01') TO ('2024-07-01');

-- 自动分区裁剪
EXPLAIN SELECT * FROM measurements
WHERE logdate >= '2024-01-01' AND logdate < '2024-04-01';
-- 只扫描 measurements_2024_q1 分区
```

==== 扩展系统

PostgreSQL支持丰富的扩展：

```sql
-- PostGIS（地理信息系统）
CREATE EXTENSION postgis;

-- pg_stat_statements（性能分析）
CREATE EXTENSION pg_stat_statements;

-- uuid-ossp（UUID生成）
CREATE EXTENSION "uuid-ossp";

-- hstore（键值对）
CREATE EXTENSION hstore;

-- 查看所有可用扩展
SELECT * FROM pg_available_extensions;
```

*常用扩展*：

#tex-table(
  ("扩展", "用途"),
  ("PostGIS", "地理空间数据"),
  ("pg_stat_statements", "SQL性能统计"),
  ("pgcrypto", "加密函数"),
  ("citext", "大小写不敏感文本"),
  ("ltree", "层次化数据"),
  ("btree_gin", "GIN索引支持普通类型"),
)

=== PostgreSQL的应用场景

==== GIS应用

```sql
-- 使用PostGIS
SELECT name,
       ST_Distance(
           location,
           ST_SetSRID(ST_MakePoint(116.4074, 39.9042), 4326)
       ) as distance
FROM places
ORDER BY distance
LIMIT 10;
```

==== 时序数据

```sql
-- 使用时序扩展
CREATE EXTENSION timescaledb;

-- 创建hypertable
CREATE TABLE sensor_data (
    time TIMESTAMPTZ NOT NULL,
    sensor_id INT,
    value DOUBLE PRECISION
);

SELECT create_hypertable('sensor_data', 'time');
```

==== 复杂数据分析

```sql
-- 复杂聚合
SELECT
    department,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary) as median_salary,
    STDDEV(salary) as salary_stddev
FROM employees
GROUP BY department;
```

#tip[
  PostgreSQL适合需要复杂查询、数据分析、GIS等高级功能的场景。
]

== 关系型数据库性能调优

性能调优是一个系统工程，需要从多个维度综合考虑。

#note[
  性能调优的核心原则是*先测量，后优化*。没有监控就没有优化。
]

=== 性能监控

==== MySQL监控

```sql
-- 查看当前连接
SHOW PROCESSLIST;

-- 查看慢查询
SHOW VARIABLES LIKE 'slow_query_log';
SHOW VARIABLES LIKE 'long_query_time';

-- 查看InnoDB状态
SHOW ENGINE INNODB STATUS\G

-- 查看性能指标
SHOW STATUS LIKE 'Threads_connected';
SHOW STATUS LIKE 'Questions';
SHOW STATUS LIKE 'Innodb_buffer_pool_read%';

-- 使用performance_schema
SELECT * FROM performance_schema.events_statements_summary_by_digest
ORDER BY sum_timer_wait DESC
LIMIT 10;
```

==== PostgreSQL监控

```sql
-- 查看当前活动
SELECT * FROM pg_stat_activity;

-- 查看慢查询
SELECT query, calls, total_time, mean_time
FROM pg_stat_statements
ORDER BY mean_time DESC
LIMIT 10;

-- 查看表统计
SELECT schemaname, relname, seq_scan, idx_scan
FROM pg_stat_user_tables
ORDER BY seq_scan DESC;

-- 查看索引使用
SELECT indexrelname, idx_scan, idx_tup_read
FROM pg_stat_user_indexes
ORDER BY idx_scan ASC;
```

=== SQL优化

==== 使用EXPLAIN分析

```sql
-- MySQL
EXPLAIN SELECT * FROM users WHERE age > 20;
EXPLAIN FORMAT=JSON SELECT * FROM users WHERE age > 20;  -- 详细信息

-- PostgreSQL
EXPLAIN SELECT * FROM users WHERE age > 20;
EXPLAIN ANALYZE SELECT * FROM users WHERE age > 20;  -- 实际执行
```

*关注指标*：

- `type`：访问类型（ALL < index < range < ref < eq_ref < const）
- `key`：使用的索引
- `rows`：扫描行数
- `Extra`：额外信息（Using filesort, Using temporary等）

==== 常见优化技巧

===== 1. 避免SELECT \*

```sql
-- 不好
SELECT * FROM users;

-- 好
SELECT id, name, email FROM users;
```

===== 2. 优化JOIN

```sql
-- 确保JOIN字段有索引
-- 小表驱动大表
SELECT * FROM small_table s
JOIN large_table l ON s.id = l.small_id;
```

===== 3. 使用覆盖索引

```sql
-- 创建覆盖索引
CREATE INDEX idx_covering ON users(dept_id, name, email);

-- 查询只需访问索引
SELECT dept_id, name, email FROM users WHERE dept_id = 'CS01';
```

===== 4. 批量操作

```sql
-- 不好：逐条插入
INSERT INTO users VALUES (1, 'Alice');
INSERT INTO users VALUES (2, 'Bob');

-- 好：批量插入
INSERT INTO users VALUES
    (1, 'Alice'),
    (2, 'Bob'),
    (3, 'Carol');
```

===== 5. 分页优化

```sql
-- 不好：深分页
SELECT * FROM users ORDER BY id LIMIT 10 OFFSET 10000;

-- 好：游标分页
SELECT * FROM users
WHERE id > last_seen_id
ORDER BY id
LIMIT 10;
```

=== 索引优化

==== 识别缺失索引

```sql
-- MySQL：查看未使用索引的查询
SELECT * FROM sys.schema_statements_with_full_table_scans;

-- PostgreSQL：查看顺序扫描多的表
SELECT relname, seq_scan, seq_tup_read
FROM pg_stat_user_tables
WHERE seq_scan > 0
ORDER BY seq_tup_read DESC;
```

==== 识别冗余索引

```sql
-- MySQL
SELECT * FROM sys.schema_redundant_indexes;

-- PostgreSQL
SELECT * FROM pg_stat_user_indexes
WHERE idx_scan = 0;
```

==== 索引维护

```sql
-- MySQL：分析表
ANALYZE TABLE users;

-- PostgreSQL：分析表
ANALYZE users;

-- 重建索引
ALTER INDEX idx_name REBUILD;  -- PostgreSQL
OPTIMIZE TABLE users;  -- MySQL
```

=== 配置优化

==== MySQL关键配置

```ini
# my.cnf

[mysqld]
# 连接
max_connections = 500
thread_cache_size = 64

# InnoDB
innodb_buffer_pool_size = 4G
innodb_buffer_pool_instances = 8
innodb_log_file_size = 512M
innodb_flush_log_at_trx_commit = 1
innodb_flush_method = O_DIRECT

# 查询
query_cache_type = 0  # MySQL 8.0已移除
sort_buffer_size = 2M
join_buffer_size = 2M

# 日志
slow_query_log = 1
long_query_time = 2
log_queries_not_using_indexes = 1
```

==== PostgreSQL关键配置

```ini
# postgresql.conf

# 内存
shared_buffers = 2GB  # 物理内存的25%
effective_cache_size = 6GB  # 物理内存的75%
work_mem = 4MB
maintenance_work_mem = 512MB

# WAL
wal_buffers = 16MB
checkpoint_completion_target = 0.9

# 查询规划
random_page_cost = 1.1  # SSD设置为1.1
effective_io_concurrency = 200  # SSD

# 连接
max_connections = 200
```

#caution[
  配置调整需要根据实际硬件和业务负载进行测试，不要盲目套用。
]

=== 架构优化

==== 读写分离

```text
应用程序
    ↓
读写路由器
    ├→ 主库（写）
    └→ 从库1（读）
    └→ 从库2（读）
    └→ 从库N（读）
```

*实现*：

- MySQL：主从复制 + ProxySQL/MaxScale
- PostgreSQL：流复制 + Pgpool-II

==== 分库分表

*垂直拆分*：

```text
用户数据库：users, profiles, settings
订单数据库：orders, order_items, payments
商品数据库：products, categories, inventory
```

*水平拆分*：

```sql
-- 按用户ID取模
user_id % 4 = 0 → database_0
user_id % 4 = 1 → database_1
user_id % 4 = 2 → database_2
user_id % 4 = 3 → database_3
```

*中间件*：

- MyCat
- ShardingSphere
- Vitess

==== 缓存层

```text
请求流程：
应用 → Redis缓存 → 数据库
         ↓ 命中
       返回结果
         ↓ 未命中
       查询DB → 写入缓存
```

*缓存策略*：

- Cache Aside（旁路缓存）
- Read Through
- Write Through
- Write Behind

#tip[
  缓存是提高性能最有效的手段之一，但要注意缓存一致性问题。
]

=== 硬件优化

==== 存储

- 使用SSD/NVMe替代HDD
- RAID 10提供性能和冗余
- 分离数据文件和日志文件到不同磁盘

==== 内存

- 增加RAM提高缓存命中率
- 足够的内存可以避免swap

==== CPU

- 多核提高并发处理能力
- 高主频提高单查询性能

==== 网络

- 万兆网卡减少网络瓶颈
- 低延迟网络连接

=== 性能调优流程

```
1. 建立基线
   ↓
2. 监控和测量
   ↓
3. 识别瓶颈
   ↓
4. 制定优化方案
   ↓
5. 实施优化
   ↓
6. 验证效果
   ↓
7. 回到步骤2（持续优化）
```

#note[
  性能调优是一个持续的过程，不是一次性的任务。
]

#fancy-divider

本章完
