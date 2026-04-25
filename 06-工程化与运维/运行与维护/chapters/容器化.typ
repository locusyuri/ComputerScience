#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= Docker 基础

Docker 是最流行的容器化平台，通过轻量级容器实现应用的快速部署和隔离运行。

== 容器概念

=== 容器 vs 虚拟机

```text
虚拟机架构：
┌─────────────────────┐
│     应用程序         │
├─────────────────────┤
│   Guest OS          │  ← 完整的操作系统
├─────────────────────┤
│   Hypervisor        │  ← 虚拟化层
├─────────────────────┤
│   Host OS           │
├─────────────────────┤
│   硬件              │
└─────────────────────┘

容器架构：
┌─────────────────────┐
│     应用程序         │
├─────────────────────┤
│   依赖库             │
├─────────────────────┤
│   Docker Engine     │  ← 容器引擎
├─────────────────────┤
│   Host OS Kernel    │  ← 共享内核
├─────────────────────┤
│   硬件              │
└─────────────────────┘
```

#tex-table(
  ("特性", "虚拟机", "容器"),
  ("启动速度", "分钟级", "秒级"),
  ("资源占用", "高（完整OS）", "低（共享内核）"),
  ("隔离性", "强", "中（命名空间）"),
  ("性能损耗", "5-10%", "< 1%"),
  ("镜像大小", "GB级", "MB级"),
  ("密度", "低", "高"),
)

#tip[
  容器不是虚拟机的替代品，两者各有适用场景。容器适合微服务、CI/CD；虚拟机适合多租户、强隔离。
]

=== 命名空间（Namespaces）

命名空间提供资源隔离：

```bash
# 查看进程的命名空间
ls -l /proc/$$/ns

# 输出：
# lrwxrwxrwx 1 root root 0 Jan 1 12:00 cgroup -> cgroup:[4026531835]
# lrwxrwxrwx 1 root root 0 Jan 1 12:00 ipc -> ipc:[4026531839]
# lrwxrwxrwx 1 root root 0 Jan 1 12:00 mnt -> mnt:[4026531840]
# lrwxrwxrwx 1 root root 0 Jan 1 12:00 net -> net:[4026531992]
# lrwxrwxrwx 1 root root 0 Jan 1 12:00 pid -> pid:[4026531836]
# lrwxrwxrwx 1 root root 0 Jan 1 12:00 user -> user:[4026531837]
# lrwxrwxrwx 1 root root 0 Jan 1 12:00 uts -> uts:[4026531838]
```

*6种命名空间*：

#tex-table(
  ("命名空间", "隔离内容", "作用"),
  ("PID", "进程ID", "进程可见性"),
  ("NET", "网络设备", "网络栈隔离"),
  ("MNT", "挂载点", "文件系统隔离"),
  ("UTS", "主机名", "主机名隔离"),
  ("IPC", "进程间通信", "信号量、消息队列"),
  ("USER", "用户ID", "用户权限映射"),
)

=== Cgroups（控制组）

Cgroups 限制和监控资源使用：

```bash
# 查看容器的 cgroup

docker inspect --format='{{.HostConfig.CpuShares}}' container_id
docker inspect --format='{{.HostConfig.Memory}}' container_id

# 限制 CPU 和内存

docker run --cpus=1.5 --memory=512m nginx

# 查看 cgroup 文件系统

cat /sys/fs/cgroup/cpu/docker/<container_id>/cpu.shares
cat /sys/fs/cgroup/memory/docker/<container_id>/memory.limit_in_bytes
```

*Cgroups v1 vs v2*：

- v1：多个子系统，层次结构复杂
- v2：统一 hierarchy，更简洁
- Docker 支持两种版本

#note[
  命名空间提供隔离，Cgroups 提供资源限制，两者结合实现容器化。
]

== Docker 安装与配置

=== 安装 Docker Engine

```bash
# Ubuntu/Debian

# 卸载旧版本
sudo apt-get remove docker docker-engine docker.io containerd runc

# 安装依赖
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# 添加 GPG 密钥
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# 添加仓库
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 安装
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

# 验证
sudo docker run hello-world
```

#caution[
  生产环境建议使用官方脚本或包管理器安装，避免使用 convenience scripts。
]

=== Docker 守护进程配置

```bash
# 配置文件位置

sudo vim /etc/docker/daemon.json

# 示例配置
{
  "registry-mirrors": [
    "https://docker.mirrors.ustc.edu.cn",
    "https://hub-mirror.c.163.com"
  ],
  "storage-driver": "overlay2",
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "default-runtime": "runc",
  "live-restore": true
}

# 重启 Docker

sudo systemctl daemon-reload
sudo systemctl restart docker

# 验证配置

docker info
```

*常用配置项*：

#tex-table(
  ("配置项", "说明", "推荐值"),
  ("registry-mirrors", "镜像加速", "国内镜像源"),
  ("storage-driver", "存储驱动", "overlay2"),
  ("log-driver", "日志驱动", "json-file"),
  ("max-size", "日志大小", "10m"),
  ("live-restore", "守护进程重启时保持容器运行", "true"),
)

=== 镜像加速器配置

```bash
# 国内常用镜像源

# 阿里云（需要注册获取专属地址）
https://<your-id>.mirror.aliyuncs.com

# 中科大
https://docker.mirrors.ustc.edu.cn

# 网易
https://hub-mirror.c.163.com

# 腾讯云
https://mirror.ccs.tencentyun.com

# 配置后测试

docker pull nginx  # 应该明显加快
```

#tip[
  配置镜像加速器可以大幅提升镜像拉取速度，特别是国内环境。
]

== 镜像管理

=== Dockerfile 基础

```dockerfile
# 基础镜像
FROM ubuntu:22.04

# 元数据
LABEL maintainer="alice@example.com"
LABEL version="1.0"
LABEL description="My application"

# 环境变量
ENV APP_HOME=/app
ENV NODE_ENV=production

# 工作目录
WORKDIR $APP_HOME

# 复制文件
COPY package*.json ./
COPY . .

# 执行命令
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    nodejs npm && \
    rm -rf /var/lib/apt/lists/* && \
    npm install

# 暴露端口
EXPOSE 3000

# 卷
VOLUME ["/data"]

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:3000/ || exit 1

# 启动命令
CMD ["node", "server.js"]
```

*Dockerfile 最佳实践*：

1. 使用具体的基础镜像标签（不用 `latest`）
2. 合并 RUN 指令，减少层数
3. 使用 `.dockerignore` 排除不必要文件
4. 多阶段构建减小镜像体积
5. 不以 root 用户运行

=== 分层存储原理

```dockerfile
# 每一层都是只读的
FROM ubuntu:22.04          # Layer 1: 基础镜像
RUN apt-get update         # Layer 2: 更新包列表
RUN apt-get install -y nginx  # Layer 3: 安装 nginx
COPY . /var/www/html       # Layer 4: 复制文件
EXPOSE 80                  # Layer 5: 元数据
CMD ["nginx", "-g", "daemon off;"]  # Layer 6: 启动命令
```

*分层优势*：

- **缓存**：未改变的层可以复用
- **共享**：多个镜像可以共享相同的层
- **增量更新**：只传输变化的层

```bash
# 查看镜像层

docker history nginx:latest

# 输出：
# IMAGE          CREATED        CREATED BY                                      SIZE
# abc123         2 days ago     /bin/sh -c #(nop)  CMD ["nginx" "-g" ...]     0B
# def456         2 days ago     /bin/sh -c #(nop)  EXPOSE 80                   0B
# ghi789         2 days ago     /bin/sh -c apt-get update && apt-get ...      50MB
# jkl012         1 week ago     /bin/sh -c #(nop)  FROM ubuntu:22.04          77MB
```

#note[
  理解分层存储有助于优化 Dockerfile，减小镜像体积，加快构建速度。
]

=== 镜像优化

```dockerfile
# ❌ 不好的实践：多层、大体积
FROM ubuntu:22.04
RUN apt-get update
RUN apt-get install -y python3
RUN apt-get install -y python3-pip
RUN pip3 install flask
COPY . /app

# ✅ 好的实践：合并层、清理缓存
FROM ubuntu:22.04
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3 python3-pip && \
    rm -rf /var/lib/apt/lists/* && \
    pip3 install --no-cache-dir flask
COPY . /app

# ✅ 更好的实践：多阶段构建
# 构建阶段
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --production
COPY . .
RUN npm run build

# 运行阶段
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

*优化技巧*：

#tex-table(
  ("技巧", "效果", "示例"),
  ("使用 Alpine", "减小体积", "python:3.11-alpine"),
  ("多阶段构建", "去除构建工具", "builder + runtime"),
  ("合并 RUN", "减少层数", "apt-get update && install"),
  ("清理缓存", "减小体积", "rm -rf /var/lib/apt/lists/*"),
  (".dockerignore", "减小上下文", "排除 node_modules, .git"),
  ("不使用 root", "安全性", "USER nobody"),
)

=== 镜像操作命令

```bash
# 拉取镜像

docker pull nginx:latest
docker pull python:3.11-slim

# 查看本地镜像

docker images
docker images -a  # 包括中间层

# 搜索镜像

docker search nginx

# 删除镜像

docker rmi nginx:latest
docker rmi <image_id>

# 导出/导入

docker save nginx > nginx.tar
docker load < nginx.tar

# 打标签

docker tag nginx:latest myregistry.com/nginx:v1.0

# 推送到仓库

docker push myregistry.com/nginx:v1.0
```

== 容器操作

=== 运行容器

```bash
# 基本运行

docker run nginx

# 后台运行

docker run -d nginx

# 指定名称

docker run -d --name my-nginx nginx

# 端口映射

docker run -d -p 8080:80 nginx  # 主机8080 -> 容器80

# 环境变量

docker run -d -e MYSQL_ROOT_PASSWORD=secret mysql

# 挂载卷

docker run -d -v /host/data:/container/data nginx

# 资源限制

docker run -d --cpus=1.5 --memory=512m nginx

# 网络

docker run -d --network my-network nginx

# 重启策略

docker run -d --restart=always nginx
```

#tip[
  常用组合：`docker run -d --name <name> -p <host_port>:<container_port> <image>`
]

=== 容器生命周期管理

```bash
# 查看运行中的容器

docker ps
docker ps -a  # 包括停止的

# 停止容器

docker stop my-nginx
docker stop $(docker ps -q)  # 停止所有

# 启动已停止的容器

docker start my-nginx

# 重启容器

docker restart my-nginx

# 删除容器

docker rm my-nginx
docker rm $(docker ps -aq)  # 删除所有

# 强制删除运行中的容器

docker rm -f my-nginx
```

=== exec 进入容器

```bash
# 执行命令

docker exec my-nginx ls /usr/share/nginx/html

# 交互式 shell

docker exec -it my-nginx bash
docker exec -it my-nginx sh  # Alpine 镜像没有 bash

# 以特定用户执行

docker exec -u root -it my-nginx bash

# 环境变量

docker exec -e MY_VAR=value my-nginx env
```

#caution[
  生产环境尽量避免 exec 进入容器调试，应该通过日志和监控排查问题。
]

=== 日志查看

```bash
# 查看日志

docker logs my-nginx

# 实时跟踪

docker logs -f my-nginx

# 显示时间戳

docker logs -t my-nginx

# 最后100行

docker logs --tail 100 my-nginx

# 最近1小时

docker logs --since 1h my-nginx

# 导出日志

docker logs my-nginx > nginx.log 2>&1
```

#note[
  默认日志驱动是 json-file，可以通过 daemon.json 配置日志轮转。
]

=== inspect 查看详情

```bash
# 查看容器详细信息

docker inspect my-nginx

# 格式化输出

docker inspect --format='{{.NetworkSettings.IPAddress}}' my-nginx
docker inspect --format='{{.State.Status}}' my-nginx
docker inspect --format='{{.Config.Env}}' my-nginx

# 查看镜像详情

docker inspect nginx:latest

# JSON 格式

docker inspect my-nginx | jq .
```

== 数据持久化

=== Volume（卷）

```bash
# 创建卷

docker volume create my-data

# 查看卷

docker volume ls
docker volume inspect my-data

# 使用卷

docker run -d -v my-data:/app/data nginx

# 删除卷

docker volume rm my-data
docker volume prune  # 删除未使用的卷
```

*Volume 特点*：

- 由 Docker 管理，存储在 `/var/lib/docker/volumes/`
- 易于备份和迁移
- 支持多种驱动（local、nfs、cloud等）

=== Bind Mount（绑定挂载）

```bash
# 绑定主机目录

docker run -d -v /host/path:/container/path nginx

# 只读挂载

docker run -d -v /host/path:/container/path:ro nginx

# 挂载单个文件

docker run -d -v /host/nginx.conf:/etc/nginx/nginx.conf nginx
```

*Bind Mount 特点*：

- 直接映射主机文件系统
- 性能好，适合开发环境
- 路径依赖主机，可移植性差

#tip[
  开发环境用 Bind Mount（代码热更新），生产环境用 Volume（数据持久化）。
]

=== tmpfs（临时文件系统）

```bash
# 使用 tmpfs

docker run -d --tmpfs /app/tmp nginx

# 指定大小

docker run -d --tmpfs /app/tmp:size=100m nginx
```

*tmpfs 特点*：

- 存储在内存中
- 容器停止后数据丢失
- 适合敏感数据（密码、token）

=== 数据卷容器模式

```bash
# 创建数据卷容器

docker create -v /data --name data-store alpine /bin/true

# 其他容器挂载

docker run -d --volumes-from data-store --name app1 nginx
docker run -d --volumes-from data-store --name app2 nginx

# 备份

docker run --rm --volumes-from data-store -v $(pwd):/backup alpine \
  tar czf /backup/backup.tar.gz /data
```

#note[
  数据卷容器模式在 Docker Compose 出现前常用，现在推荐使用命名卷。
]

== 网络模式

=== Bridge 模式（默认）

```bash
# 创建自定义网桥

docker network create my-bridge

# 连接到网桥

docker run -d --network my-bridge --name web nginx
docker run -d --network my-bridge --name db mysql

# 容器间通信（通过容器名）

docker exec web ping db  # 可以解析容器名

# 查看网络

docker network ls
docker network inspect my-bridge
```

*Bridge 特点*：

- 默认网络模式
- 容器有独立 IP
- 需要通过端口映射访问
- 自定义网桥支持 DNS 解析

=== Host 模式

```bash
# 使用 host 网络

docker run -d --network host nginx

# 容器直接使用主机网络栈
# 无需端口映射
# 访问 localhost:80 即可
```

*Host 特点*：

- 性能最好（无 NAT）
- 端口冲突风险
- 隔离性差
- 适合高性能需求场景

=== None 模式

```bash
# 禁用网络

docker run -d --network none alpine sleep 3600

# 容器只有 loopback 接口
# 适合批处理任务
```

=== Overlay 模式（Swarm）

```bash
# 初始化 Swarm

docker swarm init

# 创建 overlay 网络

docker network create -d overlay my-overlay

# 跨主机通信

docker service create --network my-overlay --name web nginx
```

*Overlay 特点*：

- 跨主机容器通信
- 用于 Docker Swarm
- Kubernetes 使用 CNI 插件

#tex-table(
  ("模式", "隔离性", "性能", "适用场景"),
  ("bridge", "中", "中", "默认，通用"),
  ("host", "低", "高", "高性能需求"),
  ("none", "高", "N/A", "无网络需求"),
  ("overlay", "中", "中", "跨主机通信"),
)

#fancy-divider

本章完

= Docker 高级特性

= 容器运行时
