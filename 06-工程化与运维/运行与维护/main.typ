#import "../../99-索引与模板/TypstTemplate/computer-notes.typ": *


// ── 文档元信息 ──
#set document(
  title: "运行与维护",
  author: "Violet",
  date: datetime.today(),
)

// 应用全局样式
#show: apply-style


// ══════════════════════════════════════════════════════════════════════
// 封面
// ══════════════════════════════════════════════════════════════════════

#make-cover(
  "运行与维护",
  "Violet",
  date: datetime.today().display(),
)

// 目录
#make-outline(depth: 2)


// 目录

// ─────────────────────────────────────────────────────────────────────
// Part 1：Linux 系统运维基础
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：Linux 系统管理 🔶
// 1.1 系统监控：top/htop、vmstat、iostat、sar
// 1.2 进程管理：ps、kill、nice/renice、systemd
// 1.3 文件系统管理：df、du、fdisk、LVM
// 1.4 用户与权限：useradd、chmod、chown、sudo
// 1.5 日志管理：journalctl、logrotate、rsyslog
// 1.6 网络配置：ip、ss、iptables、NetworkManager

// Chapter 2：Shell 脚本自动化 🔶
// 2.1 Shell 编程进阶：函数、数组、正则表达式
// 2.2 文本处理：awk、sed、grep 高级用法
// 2.3 定时任务：cron、at、systemd timers
// 2.4 系统备份：tar、rsync、增量备份策略
// 2.5 自动化部署脚本：SSH 免密、批量执行

// Chapter 3：服务管理与高可用 ⚪
// 3.1 systemd 服务管理：unit 文件、依赖关系
// 3.2 负载均衡：Nginx、HAProxy 配置
// 3.3 高可用架构：Keepalived、VRRP
// 3.4 故障转移：主从切换、健康检查

// ─────────────────────────────────────────────────────────────────────
// Part 2：容器化技术
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：Docker 基础 🔶
// 1.1 容器概念：容器 vs 虚拟机、命名空间、Cgroups
// 1.2 Docker 安装与配置：引擎、守护进程、镜像加速
// 1.3 镜像管理：Dockerfile、分层存储、镜像优化
// 1.4 容器操作：run、exec、logs、inspect
// 1.5 数据持久化：Volume、Bind Mount、tmpfs
// 1.6 网络模式：bridge、host、none、overlay

// Chapter 2：Docker 高级特性 🔶
// 2.1 Docker Compose：多容器编排、服务依赖
// 2.2 Docker Swarm：集群管理、服务发现
// 2.3 安全最佳实践：非 root 用户、资源限制、镜像扫描
// 2.4 性能调优：存储驱动、网络优化、日志轮转
// 2.5 CI/CD 集成：Jenkins、GitLab CI、GitHub Actions

// Chapter 3：容器运行时 ⚪
// 3.1 containerd：CRI 接口、插件机制
// 3.2 CRI-O：Kubernetes 专用运行时
// 3.3 Podman：无守护进程容器引擎
// 3.4 运行时对比：功能、性能、适用场景

// ─────────────────────────────────────────────────────────────────────
// Part 3：云原生基础
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：云原生理念与架构 🔶
// 1.1 云原生定义：CNCF、十二要素应用
// 1.2 微服务架构：服务拆分、API 网关、服务网格
// 1.3 DevOps 文化：CI/CD、基础设施即代码
// 1.4 声明式 API：期望状态、控制器模式
// 1.5 可观测性：Logging、Metrics、Tracing

// Chapter 2：服务网格（Service Mesh）⚪
// 2.1 Istio 架构：Envoy、Pilot、Mixer、Citadel
// 2.2 流量管理：路由规则、负载均衡、熔断
// 2.3 安全通信：mTLS、认证授权、策略控制
// 2.4 可观测性集成：分布式追踪、指标收集
// 2.5 Linkerd：轻量级服务网格替代方案

// Chapter 3：云原生存储 ⚪
// 3.1 CSI（Container Storage Interface）：标准接口
// 3.2 存储类型：块存储、文件存储、对象存储
// 3.3 动态供给：StorageClass、Provisioner
// 3.4 数据保护：快照、克隆、备份恢复

// ─────────────────────────────────────────────────────────────────────
// Part 4：Kubernetes 核心
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：K8s 架构与核心概念 🔶
// 1.1 架构组件：Master（API Server、etcd、Scheduler、Controller Manager）
// 1.2 Node 组件：kubelet、kube-proxy、容器运行时
// 1.3 核心对象：Pod、Deployment、Service、Namespace
// 1.4 配置管理：ConfigMap、Secret、ResourceQuota
// 1.5 kubectl 命令行：常用命令、JSONPath、插件

// Chapter 2：工作负载管理 🔶
// 2.1 Pod 详解：生命周期、探针、初始化容器
// 2.2 Deployment：滚动更新、回滚、版本管理
// 2.3 StatefulSet：有状态应用、稳定标识、有序部署
// 2.4 DaemonSet：节点级守护进程、日志收集
// 2.5 Job/CronJob：批处理任务、定时任务
// 2.6 HPA/VPA：水平/垂直自动扩缩容

// Chapter 3：服务发现与网络 🔶
// 3.1 Service 类型：ClusterIP、NodePort、LoadBalancer、ExternalName
// 3.2 Ingress 控制器：Nginx Ingress、Traefik
// 3.3 网络插件（CNI）：Calico、Flannel、Cilium
// 3.4 网络策略：NetworkPolicy、隔离规则
// 3.5 DNS 服务：CoreDNS、服务发现

// Chapter 4：存储与配置管理 🔶
// 4.1 Volume 类型：emptyDir、hostPath、nfs、ceph
// 4.2 PersistentVolume/PersistentVolumeClaim
// 4.3 StorageClass：动态供给、回收策略
// 4.4 ConfigMap 与 Secret：配置注入、加密存储
// 4.5 Downward API：元数据注入

// Chapter 5：安全与权限控制 🔶
// 5.1 RBAC：Role、ClusterRole、Binding
// 5.2 ServiceAccount：身份认证、Token 管理
// 5.3 SecurityContext：特权模式、能力控制
// 5.4 NetworkPolicy：网络隔离、白名单
// 5.5 Pod Security Standards：Privileged、Baseline、Restricted
// 5.6 OPA/Gatekeeper：策略即代码

// ─────────────────────────────────────────────────────────────────────
// Part 5：Kubernetes 进阶
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：Helm 包管理 🔶
// 1.1 Helm 架构：Chart、Release、Repository
// 1.2 Chart 开发：模板语法、Values、Helpers
// 1.3 依赖管理：requirements.yaml、子 Chart
// 1.4 发布管理：install、upgrade、rollback
// 1.5 私有仓库：ChartMuseum、Harbor

// Chapter 2：Operator 模式 ⚪
// 2.1 Operator 概念：CRD、Controller、Reconcile
// 2.2 Kubebuilder 框架：脚手架、API 设计
// 2.3 Operator SDK：Go/Ansible/Helm Operator
// 2.4 实战：编写数据库 Operator
// 2.5 社区 Operator：Prometheus、Etcd、Cert-Manager

// Chapter 3：监控与日志 🔶
// 3.1 Prometheus：架构、数据模型、PromQL
// 3.2 Grafana：仪表盘、告警规则、数据源
// 3.3 Alertmanager：告警路由、静默、分组
// 3.4 ELK Stack：Elasticsearch、Logstash、Kibana
// 3.5 EFK Stack：Fluentd/Fluent Bit 替代 Logstash
// 3.6 Jaeger/Zipkin：分布式链路追踪

// Chapter 4：CI/CD 与 GitOps ⚪
// 4.1 Jenkins X：云原生 CI/CD
// 4.2 Argo CD：GitOps 持续交付
// 4.3 Flux CD：声明式 GitOps
// 4.4 Tekton：云原生 CI 流水线
// 4.5 GitOps 最佳实践：分支策略、回滚策略

// ─────────────────────────────────────────────────────────────────────
// Part 6：云平台与基础设施
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：公有云 K8s 服务 ⚪
// 1.1 AWS EKS：架构、节点组、Fargate
// 1.2 Azure AKS：托管控制平面、虚拟节点
// 1.3 GCP GKE：Autopilot、Workload Identity
// 1.4 阿里云 ACK：专有版、托管版、Serverless
// 1.5 多云管理：跨云部署、统一治理

// Chapter 2：基础设施即代码（IaC）⚪
// 2.1 Terraform：Provider、Resource、Module
// 2.2 Pulumi：通用编程语言 IaC
// 2.3 Ansible：配置管理、Playbook
// 2.4 Crossplane：Kubernetes 原生 IaC
// 2.5 状态管理：远程后端、锁定机制

// Chapter 3：边缘计算与 K8s ⚪
// 3.1 K3s：轻量级 Kubernetes
// 3.2 KubeEdge：云边协同架构
// 3.3 OpenYurt：阿里云边缘计算方案
// 3.4 边缘场景：低带宽、离线运行、设备管理

// ─────────────────────────────────────────────────────────────────────
// Part 7：生产实践与故障排查
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：集群规划与部署 🔶
// 1.1 容量规划：节点规格、网络规划、存储规划
// 1.2 高可用部署：多 Master、etcd 集群、负载均衡
// 1.3 升级策略：滚动升级、蓝绿部署、金丝雀发布
// 1.4 备份恢复：etcd 备份、Velero 工具
// 1.5 灾备方案：多可用区、多地域

// Chapter 2：性能优化 🔶
// 2.1 资源管理：Requests/Limits、QoS 等级
// 2.2 调度优化：亲和性、污点容忍、拓扑分布
// 2.3 网络优化：CNI 选择、Service Mesh 开销
// 2.4 存储优化：本地存储、缓存策略、IO 调度
// 2.5 内核参数调优：net.core、fs.file-max

// Chapter 3：故障排查方法论 🔶
// 3.1 排查思路：现象→日志→指标→根因
// 3.2 常见问题：CrashLoopBackOff、ImagePullBackOff
// 3.3 网络问题：DNS 解析失败、Service 不通
// 3.4 存储问题：PV 绑定失败、权限错误
// 3.5 性能问题：CPU 限流、内存 OOM、磁盘 IO
// 3.6 调试工具：kubectl debug、ephemeral containers

// Chapter 4：成本优化与管理 ⚪
// 4.1 资源利用率分析：vpa-recommender
// 4.2 自动扩缩容：Cluster Autoscaler
// 4.3 Spot 实例：中断处理、混合部署
// 4.4 成本监控：Kubecost、Cloud Health
// 4.5 FinOps 实践：预算控制、成本分摊

#part("Linux 系统运维基础")
#include "chapters/Linux基础.typ"

#part("容器化技术")
#include "chapters/容器化.typ"

#part("云原生基础")
#include "chapters/云原生基础.typ"

#part("Kubernetes 核心")
#include "chapters/Kubernetes核心.typ"

#part("Kubernetes 进阶")
#include "chapters/Kubernetes进阶.typ"

#part("云平台与基础设施")
#include "chapters/云平台.typ"

#part("生产实践与故障排查")
#include "chapters/生产实践.typ"
