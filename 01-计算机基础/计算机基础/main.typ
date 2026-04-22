#import "../../99-索引与模板/TypstTemplate/computer-notes.typ": *


// ── 文档元信息 ──
#set document(
  title: "计算机基础",
  author: "Violet",
  date: datetime.today(),
)

// 应用全局样式
#show: apply-style


// ══════════════════════════════════════════════════════════════════════
// 封面
// ══════════════════════════════════════════════════════════════════════

#make-cover(
  "计算机基础",
  "Violet",
  date: datetime.today().display(),
)

// 目录
#make-outline(depth: 2)

#part("版本管理与开发工具")
#include "chapters/Git.typ"
#include "chapters/Shell.typ"

#part("数据库系统")
#include "chapters/数据库.typ"

#part("并发编程与分布式系统")
#include "chapters/并发编程.typ"
#include "chapters/分布式系统.typ"

#part("设计模式")

#part("计算机基础综合")
#include "chapters/正则表达式.typ"


// 章节结构
// Part 1: 版本管理与开发工具
// Chapter 1: Git 版本控制详解 🔶
// 1.1 版本控制系统概述：集中式 vs 分布式、Git 的设计理念
// 1.2 Git 核心概念：仓库、工作区、暂存区、提交历史、HEAD
// 1.3 Git 基本操作：init、add、commit、status、log、diff
// 1.4 分支管理：branch、checkout/switch、merge、rebase、冲突解决
// 1.5 远程协作：remote、push、pull、fetch、upstream
// 1.6 高级操作：stash、cherry-pick、reset/revert、reflog、bisect
// 1.7 标签管理：轻量标签、附注标签、标签推送
// 1.8 Git 工作流：Git Flow、GitHub Flow、GitLab Flow、Trunk-Based
// 1.9 .gitignore 配置：规则语法、全局忽略、最佳实践
// 1.10 Git 钩子（hooks）：pre-commit、post-merge、自定义脚本
// 1.11 子模块与子树：git submodule、git subtree
// 1.12 性能优化：浅克隆、稀疏检出、大文件存储（LFS）

// Chapter 2: Shell 命令行与脚本编程 🔶
// 2.1 Shell 概述：REPL、Shell 类型（Bash、Zsh、Fish、PowerShell）
// 2.2 Shell 实现：POSIX 标准、Unix Shell、Windows Shell（CMD、PowerShell）
// 2.3 基本命令：ls、cd、pwd、mkdir、rm、cp、mv、cat、echo
// 2.4 文件权限：chmod、chown、umask、权限表示（rwx）
// 2.5 输入输出重定向：stdin/stdout/stderr、管道、tee
// 2.6 环境变量：PATH、HOME、export、env、配置文件（.bashrc、.zshrc）
// 2.7 Shell 语法：变量、条件判断、循环、函数、数组
// 2.8 文本处理工具：grep、sed、awk、sort、uniq、wc
// 2.9 进程管理：ps、top、kill、jobs、bg/fg、nohup
// 2.10 Shell 脚本编程：shebang、参数传递、错误处理、调试
// 2.11 高级特性：命令替换、进程替换、here document、trap
// 2.12 Shell 效率提升：别名、快捷键、自动补全、历史搜索
//
// Chapter 3: Vim编辑器精通
// 3.1 Vim工作模式（普通、插入、可视、命令行）
// 3.2 光标移动与文本导航
// 3.3 文本编辑操作（删除、复制、粘贴、替换）
// 3.4 搜索与替换（/、?、:%s）
// 3.5 窗口与标签页管理
// 3.6 宏录制与回放
// 3.7 常用快捷键速查表
// 3.8 Vim配置文件（.vimrc）详解
// 3.9 插件管理（Vundle、Pathogen、vim-plug）
// 3.10 实用插件推荐（NERDTree、fzf、coc.nvim等）
// 3.11 Neovim与现代配置（Lua配置）
// 3.12 Vim效率提升技巧
//
//
//
// Part 2: 并发系统与分布式理论
// Chapter 4: 并发编程基础
// 4.1 进程与线程的概念
// 4.2 并发与并行的区别
// 4.3 线程状态与生命周期
// 4.4 线程同步机制（互斥锁、读写锁、条件变量）
// 4.5 死锁的产生与预防
// 4.6 信号量与管程
// 4.7 无锁编程与原子操作
// 4.8 内存模型与可见性
// 4.9 volatile关键字的作用
// 4.10 CAS（比较并交换）操作
//
// Chapter 5: 分布式系统理论
// 5.1 分布式系统概述与挑战
// 5.2 CAP定理详解（一致性、可用性、分区容错性）
// 5.3 CAP权衡与实际应用
// 5.4 BASE理论（基本可用、软状态、最终一致性）
// 5.5 一致性模型（强一致性、弱一致性、因果一致性）
// 5.6 分布式事务（2PC、3PC、TCC、Saga）
// 5.7 分布式锁实现（基于ZooKeeper、Redis）
// 5.8 Leader选举算法
// 5.9 拜占庭将军问题
// 5.10 FLP不可能定理
//
// Chapter 6: 共识算法
// 6.1 共识问题定义
// 6.2 Paxos算法详解（Basic Paxos、Multi-Paxos）
// 6.3 Raft算法详解（Leader选举、日志复制、安全性）
// 6.4 Zab协议（ZooKeeper原子广播）
// 6.5 Gossip协议
// 6.6 共识算法对比与选型
// 6.7 etcd与Consul实践
//
// Chapter 7: 分布式协调与服务发现
// 7.1 ZooKeeper架构与ZAB协议
// 7.2 ZooKeeper数据模型与Watcher机制
// 7.3 ZooKeeper典型应用场景
// 7.4 Consul服务发现与健康检查
// 7.5 etcd键值存储与应用
// 7.6 Nacos配置中心与服务发现
// 7.7 服务网格（Service Mesh）概念
//
// Chapter 8: 负载均衡与高可用
// 8.1 负载均衡算法（轮询、加权、最少连接、一致性哈希）
// 8.2 四层负载均衡 vs 七层负载均衡
// 8.3 LVS、Nginx、HAProxy对比
// 8.4 健康检查机制
// 8.5 故障转移与容灾
// 8.6 熔断器模式（Circuit Breaker）
// 8.7 限流算法（令牌桶、漏桶、滑动窗口）
// 8.8 降级与隔离策略
//
//
//
//
// Part 3: 数据库系统
// Chapter 9: 数据库基础理论
// 9.1 数据库系统概述与发展历程
// 9.2 数据模型（层次、网状、关系、面向对象）
// 9.3 数据库体系结构（三级模式、两级映像）
// 9.4 数据独立性（物理独立性与逻辑独立性）
// 9.5 数据库管理系统（DBMS）的功能与组成
// 9.6 事务的基本概念（ACID特性）
// 9.7 并发控制理论基础
// 9.8 数据库安全性与完整性
//
// Chapter 10: 关系型数据库
// 10.1 关系模型基础（关系、元组、属性、域）
// 10.2 关系代数（选择、投影、连接、除运算）
// 10.3 SQL语言基础（DDL、DML、DCL、TCL）
// 10.4 数据查询进阶（子查询、连接查询、集合运算）
// 10.5 索引技术（B+树索引、哈希索引、覆盖索引）
// 10.6 视图与存储过程
// 10.7 触发器与事件调度
// 10.8 数据库规范化理论（1NF、2NF、3NF、BCNF）
// 10.9 反规范化设计与性能优化
// 10.10 锁机制与并发控制（共享锁、排他锁、意向锁）
// 10.11 事务隔离级别（读未提交、读已提交、可重复读、串行化）
// 10.12 MVCC（多版本并发控制）原理
// 10.13 MySQL架构与存储引擎（InnoDB、MyISAM）
// 10.14 PostgreSQL特性与应用
// 10.15 关系型数据库性能调优
//
// Chapter 11: NoSQL数据库
// 11.1 NoSQL概述与CAP/BASE理论
// 11.2 键值存储数据库（Redis、Memcached）
// 11.3 Redis数据结构与命令详解
// 11.4 Redis持久化机制（RDB、AOF）
// 11.5 Redis集群与高可用（主从复制、哨兵、Cluster）
// 11.6 文档数据库（MongoDB、CouchDB）
// 11.7 MongoDB文档模型与查询语言
// 11.8 MongoDB索引与聚合框架
// 11.9 列族数据库（Cassandra、HBase）
// 11.10 Cassandra数据建模与一致性级别
// 11.11 时序数据库（InfluxDB、TimescaleDB）
// 11.12 NoSQL选型指南与应用场景
//
// Chapter 12: 图数据库
// 12.1 图论基础（节点、边、路径、连通性）
// 12.2 图数据库概述与应用场景
// 12.3 属性图模型 vs RDF图模型
// 12.4 Neo4j架构与Cypher查询语言
// 12.5 图遍历算法（BFS、DFS、最短路径）
// 12.6 中心性算法（度中心性、介数中心性、接近中心性）
// 12.7 社区发现算法
// 12.8 JanusGraph分布式图数据库
// 12.9 图数据库性能优化
// 12.10 知识图谱构建与应用
//
// Chapter 13: 向量数据库
// 13.1 向量嵌入与语义表示
// 13.2 向量相似度度量（余弦相似度、欧氏距离、点积）
// 13.3 近似最近邻搜索（ANN）算法
// 13.4 HNSW（分层导航小世界）算法
// 13.5 IVF（倒排文件索引）算法
// 13.6 PQ（乘积量化）算法
// 13.7 FAISS库详解
// 13.8 Milvus向量数据库架构
// 13.9 Pinecone云服务介绍
// 13.10 Chroma轻量级向量数据库
// 13.11 向量数据库在AI应用中的角色
// 13.12 RAG（检索增强生成）架构
// 13.13 向量索引优化与性能调优
//
// Chapter 14: 数据库高级主题
// 14.1 分布式数据库理论
// 14.2 分片策略（范围分片、哈希分片、一致性哈希）
// 14.3 复制拓扑（主从、主主、多主）
// 14.4 NewSQL数据库（TiDB、CockroachDB）
// 14.5 数据库中间件（ShardingSphere、MyCat）
// 14.6 OLTP vs OLAP
// 14.7 数据仓库与ETL
// 14.8 湖仓一体（Data Lakehouse）
// 14.9 数据库监控与运维
//
//
//
//
// Part 4: 设计模式
// Chapter 15: 设计模式概述
// 15.1 设计模式的起源与发展
// 15.2 GoF设计模式分类（创建型、结构型、行为型）
// 15.3 设计原则（SOLID、DRY、KISS、YAGNI）
// 15.4 单一职责原则（SRP）
// 15.5 开闭原则（OCP）
// 15.6 里氏替换原则（LSP）
// 15.7 依赖倒置原则（DIP）
// 15.8 接口隔离原则（ISP）
// 15.9 组合复用原则（CRP）
// 15.10 迪米特法则（LoD）
//
// Chapter 16: 创建型模式
// 16.1 单例模式（Singleton）- 懒汉、饿汉、双重检查、枚举
// 16.2 工厂方法模式（Factory Method）
// 16.3 抽象工厂模式（Abstract Factory）
// 16.4 建造者模式（Builder）
// 16.5 原型模式（Prototype）
// 16.6 对象池模式（Object Pool）
// 16.7 创建型模式对比与选择
//
// Chapter 17: 结构型模式
// 17.1 适配器模式（Adapter）- 类适配器、对象适配器
// 17.2 桥接模式（Bridge）
// 17.3 组合模式（Composite）
// 17.4 装饰器模式（Decorator）
// 17.5 外观模式（Facade）
// 17.6 享元模式（Flyweight）
// 17.7 代理模式（Proxy）- 静态代理、动态代理、CGLIB
// 17.8 结构型模式对比与应用场景
//
// Chapter 18: 行为型模式
// 18.1 责任链模式（Chain of Responsibility）
// 18.2 命令模式（Command）
// 18.3 解释器模式（Interpreter）
// 18.4 迭代器模式（Iterator）
// 18.5 中介者模式（Mediator）
// 18.6 备忘录模式（Memento）
// 18.7 观察者模式（Observer）
// 18.8 状态模式（State）
// 18.9 策略模式（Strategy）
// 18.10 模板方法模式（Template Method）
// 18.11 访问者模式（Visitor）
// 18.12 行为型模式对比与选择
//
// Chapter 19: 架构模式与设计实践
// 19.1 MVC模式（Model-View-Controller）
// 19.2 MVP模式（Model-View-Presenter）
// 19.3 MVVM模式（Model-View-ViewModel）
// 19.4 分层架构（Layered Architecture）
// 19.5 六边形架构（Hexagonal Architecture）
// 19.6 整洁架构（Clean Architecture）
// 19.7 CQRS（命令查询职责分离）
// 19.8 事件驱动架构（EDA）
// 19.9 微服务架构模式
// 19.10 领域驱动设计（DDD）基础
// 19.11 设计模式在框架中的应用（Spring、React等）
// 19.12 反模式识别与重构
//
//
//
//
// Part 5: 计算机基础综合
// Chapter 20: 编码与字符集
// 20.1 ASCII编码
// 20.2 Unicode标准
// 20.3 UTF-8、UTF-16、UTF-32编码方案
// 20.4 GBK、GB2312、GB18030中文编码
// 20.5 编码转换与乱码问题
// 20.6 Base64编码原理与应用
//
// Chapter 21: 数据表示与运算
// 21.1 进制转换（二进制、八进制、十进制、十六进制）
// 21.2 原码、反码、补码
// 21.3 浮点数表示（IEEE 754标准）
// 21.4 位运算技巧与应用
// 21.5 大端序与小端序
//
// Chapter 22: 编译原理基础
// 22.1 编译过程概述（词法分析、语法分析、语义分析、代码生成）
// 22.2 正则表达式与有限自动机
// 22.3 上下文无关文法
// 22.4 语法树与抽象语法树（AST）
// 22.5 链接过程（静态链接、动态链接）
// 22.6 编译器与解释器的区别
//

