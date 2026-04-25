#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= Linux 系统管理

Linux 系统管理是运维工作的基础，包括系统监控、进程管理、文件系统、用户权限、日志和网络配置等核心技能。

== 系统监控

系统监控帮助了解服务器运行状态，及时发现性能瓶颈和异常。

=== top/htop：实时进程监控

```bash
# top：系统自带

top

# 常用快捷键
# P：按 CPU 使用率排序
# M：按内存使用率排序
# 1：显示所有 CPU 核心
# q：退出

# htop：增强版（需安装）

htop

# 优势：
# - 彩色显示
# - 支持鼠标操作
# - 树状视图
# - 更直观的界面
```

*top 输出解读*：

#tex-table(
  ("字段", "含义", "说明"),
  ("PID", "进程ID", "唯一标识"),
  ("USER", "用户", "进程所有者"),
  ("PR", "优先级", "数值越小优先级越高"),
  ("NI", "Nice值", "-20到19，影响优先级"),
  ("VIRT", "虚拟内存", "进程使用的虚拟内存"),
  ("RES", " resident 内存", "实际使用的物理内存"),
  ("SHR", "共享内存", "可与其他进程共享的内存"),
  ("S", "状态", "R运行/S睡眠/Z僵尸"),
  ("%CPU", "CPU使用率", "百分比"),
  ("%MEM", "内存使用率", "百分比"),
  ("TIME+", "CPU时间", "进程占用的CPU时间"),
  ("COMMAND", "命令", "进程名称"),
)

#tip[
  生产环境推荐使用 `htop`，界面更友好，功能更强大。
]

=== vmstat：虚拟内存统计

```bash
# 每2秒刷新一次，共5次

vmstat 2 5

# 输出示例：
# procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
#  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
#  1  0      0 123456  12345 678901    0    0    10    20  100  200  5  2 93  0  0
```

*关键指标*：

#tex-table(
  ("列", "含义", "正常范围"),
  ("r", "运行队列长度", "< CPU核心数"),
  ("b", "阻塞进程数", "0"),
  ("swpd", "交换分区使用", "越低越好"),
  ("free", "空闲内存", "越高越好"),
  ("si/so", "swap in/out", "应为0"),
  ("bi/bo", "块设备IO", "根据负载"),
  ("us", "用户CPU", "< 70%"),
  ("sy", "系统CPU", "< 30%"),
  ("id", "空闲CPU", "越高越好"),
  ("wa", "IO等待", "< 10%"),
)

#caution[
  如果 `si/so` 不为0，说明内存不足，正在使用 swap，应增加内存或优化应用。
]

=== iostat：磁盘 IO 监控

```bash
# 安装 sysstat 包

sudo apt install sysstat  # Debian/Ubuntu
sudo yum install sysstat  # CentOS/RHEL

# 每2秒刷新一次

iostat -x 2

# 输出示例：
# Device  rrqm/s wrqm/s   r/s   w/s rkB/s wkB/s avgrq-sz avgqu-sz   await svctm  %util
# sda       0.00   1.00  0.50  2.00   10   20    20.00     0.01    2.00  1.00   0.25
```

*关键指标*：

- `%util`：磁盘利用率，接近100%表示磁盘饱和
- `await`：IO请求平均等待时间，过高表示磁盘瓶颈
- `svctm`：IO请求平均服务时间
- `avgqu-sz`：平均队列长度

#tip[
  `%util` 高但 `await` 低，说明磁盘繁忙但性能好；两者都高说明磁盘成为瓶颈。
]

=== sar：系统活动报告

```bash
# 查看历史数据

sar -u          # CPU 使用率
sar -r          # 内存使用
sar -b          # IO 传输
sar -n DEV      # 网络统计
sar -q          # 队列长度和负载

# 查看特定时间段

sar -u -f /var/log/sa/sa15  # 查看15日的数据

# 实时监控

sar -u 1 5  # 每1秒采样，共5次
```

*sar 优势*：

- 可以查看历史数据（默认保存7天）
- 数据存储在 `/var/log/sa/`
- 支持多种指标（CPU、内存、IO、网络）

== 进程管理

=== ps：进程快照

```bash
# 查看所有进程

ps aux

# 输出字段：
# USER PID %CPU %MEM VSZ RSS TTY STAT START TIME COMMAND

# 查找特定进程

ps aux | grep nginx
ps -ef | grep java

# 按条件筛选

ps aux --sort=-%cpu | head -10  # CPU 使用率前10
ps aux --sort=-%mem | head -10  # 内存使用率前10

# 查看进程树

ps auxf  # 树状显示
pstree   # 更清晰的树状图
```

*进程状态*：

#tex-table(
  ("状态", "含义"),
  ("R", "运行中"),
  ("S", "可中断睡眠"),
  ("D", "不可中断睡眠"),
  ("Z", "僵尸进程"),
  ("T", "停止/追踪"),
)

=== kill：终止进程

```bash
# 发送信号

kill 1234           # 默认 SIGTERM（优雅终止）
kill -9 1234        # SIGKILL（强制终止）
kill -15 1234       # SIGTERM（显式指定）
kill -1 1234        # SIGHUP（重新加载配置）

# 批量终止

killall nginx       # 按名称终止
pkill -f "java.*app"  # 按模式匹配

# 查看信号列表

kill -l
```

*常用信号*：

- `SIGTERM` (15)：请求终止，允许清理资源
- `SIGKILL` (9)：强制终止，无法捕获
- `SIGHUP` (1)：重新加载配置
- `SIGINT` (2)：中断（Ctrl+C）
- `SIGSTOP` (19)：暂停
- `SIGCONT` (18)：继续

#caution[
  优先使用 `SIGTERM`，给进程清理资源的机会。`SIGKILL` 是最后手段。
]

=== nice/renice：调整优先级

```bash
# nice：启动时设置优先级

nice -n 10 ./slow_script.sh  # 较低优先级
nice -n -5 ./important_task  # 较高优先级（需要 root）

# renice：修改运行中进程的优先级

renice -n 10 -p 1234         # 降低优先级
renice -n -5 -p 1234         # 提高优先级（需要 root）

# 优先级范围：-20（最高）到 19（最低）
```

#note[
  Nice 值越低，优先级越高。普通用户只能降低优先级（增大 nice 值）。
]

=== systemd：现代 init 系统

```bash
# 服务管理

systemctl start nginx        # 启动服务
systemctl stop nginx         # 停止服务
systemctl restart nginx      # 重启服务
systemctl reload nginx       # 重载配置
systemctl status nginx       # 查看状态

# 开机自启

systemctl enable nginx       # 启用开机自启
systemctl disable nginx      # 禁用开机自启

# 查看日志

journalctl -u nginx          # 查看服务日志
journalctl -u nginx -f       # 实时跟踪
journalctl -u nginx --since "1 hour ago"

# 查看所有服务

systemctl list-units --type=service
systemctl list-unit-files    # 查看所有单元文件
```

*systemd 优势*：

- 并行启动，加快开机速度
- 依赖管理，自动处理服务顺序
- 统一的日志管理（journalctl）
- 强大的资源配置能力

== 文件系统管理

=== df：磁盘空间使用情况

```bash
# 查看所有挂载点

df -h  # 人类可读格式

# 输出示例：
# Filesystem      Size  Used Avail Use% Mounted on
# /dev/sda1        50G   20G   30G  40% /
# tmpfs           7.8G     0  7.8G   0% /dev/shm

# 查看特定类型

df -hT             # 显示文件系统类型
df -h /home        # 查看特定目录
```

#tip[
  定期监控磁盘使用率，建议在达到 80% 时发出警告，90% 时紧急处理。
]

=== du：目录大小统计

```bash
# 查看目录大小

du -sh /var/log    # 单个目录总大小
du -sh /var/*      # 子目录大小

# 查找大文件

du -ah /var | sort -rh | head -20  # 最大的20个文件/目录

# 深度控制

du -h --max-depth=1 /home  # 只显示第一层
```

=== fdisk：分区管理

```bash
# 查看分区表

sudo fdisk -l

# 交互式分区

sudo fdisk /dev/sdb

# 常用命令：
# p：打印分区表
# n：新建分区
# d：删除分区
# t：修改分区类型
# w：写入并退出
# q：退出不保存
```

#caution[
  分区操作有风险，务必先备份重要数据。生产环境建议使用 LVM。
]

=== LVM：逻辑卷管理

LVM（Logical Volume Manager）提供灵活的存储管理。

```bash
# 创建物理卷

pvcreate /dev/sdb1

# 创建卷组

vgcreate vg_data /dev/sdb1

# 创建逻辑卷

lvcreate -L 100G -n lv_home vg_data

# 格式化并挂载

mkfs.ext4 /dev/vg_data/lv_home
mount /dev/vg_data/lv_home /home

# 扩展逻辑卷（在线）

lvextend -L +50G /dev/vg_data/lv_home
resize2fs /dev/vg_data/lv_home  # ext4
xfs_growfs /home                # xfs

# 查看信息

pvdisplay
vgdisplay
lvdisplay
```

*LVM 优势*：

- 在线扩展/缩小卷
- 快照功能（备份）
- 跨多个磁盘聚合存储
- 灵活的存储池管理

== 用户与权限

=== 用户管理

```bash
# 创建用户

sudo useradd -m -s /bin/bash username
sudo passwd username

# 删除用户

sudo userdel -r username  # -r 同时删除家目录

# 修改用户

sudo usermod -aG sudo username  # 添加到 sudo 组
sudo usermod -s /sbin/nologin username  # 禁止登录

# 查看用户

id username
whoami
cat /etc/passwd
```

#tip[
  `-m` 创建家目录，`-s` 指定 shell，`-aG` 追加到组（不覆盖原有组）。
]

=== 文件权限

```bash
# 查看权限

ls -l file.txt
# -rw-r--r-- 1 user group 1024 Jan 1 12:00 file.txt

# 权限分解：
# -    rw-    r--    r--
# |     |      |      |
# 类型  所有者  所属组  其他用户

# 修改权限（符号模式）

chmod u+x script.sh      # 所有者添加执行权限
chmod g-w file.txt       # 组移除写入权限
chmod o=r file.txt       # 其他用户只读
chmod a+x script.sh      # 所有用户添加执行权限

# 修改权限（数字模式）

chmod 755 script.sh      # rwxr-xr-x
chmod 644 file.txt       # rw-r--r--
chmod 600 private.key    # rw-------
```

*数字权限对照*：

#tex-table(
  ("权限", "数字", "含义"),
  ("r", "4", "读"),
  ("w", "2", "写"),
  ("x", "1", "执行"),
  ("rwx", "7", "4+2+1"),
  ("rw-", "6", "4+2"),
  ("r-x", "5", "4+1"),
)

=== chown：修改所有者

```bash
# 修改所有者

sudo chown newuser file.txt
sudo chown newuser:newgroup file.txt  # 同时修改组和所有者

# 递归修改

sudo chown -R user:group /directory/
```

=== sudo：提权执行

```bash
# 使用 sudo

sudo command

# 编辑 sudoers 文件（必须用 visudo）

sudo visudo

# 添加规则

username ALL=(ALL:ALL) ALL
%admin ALL=(ALL) NOPASSWD: ALL  # admin 组无需密码

# 查看 sudo 权限

sudo -l
```

#caution[
  始终使用 `visudo` 编辑 sudoers 文件，它会检查语法错误，避免锁定系统。
]

== 日志管理

=== journalctl：systemd 日志

```bash
# 查看所有日志

journalctl

# 查看特定服务

journalctl -u nginx
journalctl -u sshd

# 时间过滤

journalctl --since "2024-01-01"
journalctl --since "1 hour ago"
journalctl --until "10 min ago"

# 优先级过滤

journalctl -p err       # 错误及以上
journalctl -p warning   # 警告及以上

# 实时跟踪

journalctl -f
journalctl -u nginx -f

# 查看内核日志

journalctl -k
```

#tip[
  `journalctl` 是 systemd 系统的统一日志接口，取代了传统的 syslog。
]

=== logrotate：日志轮转

```bash
# 配置文件

/etc/logrotate.conf         # 主配置
/etc/logrotate.d/           # 子配置目录

# 示例配置（/etc/logrotate.d/nginx）

/var/log/nginx/*.log {
    daily                   # 每天轮转
    missingok               # 日志不存在不报错
    rotate 14               # 保留14个备份
    compress                # 压缩旧日志
    delaycompress           # 延迟一天压缩
    notifempty              # 空文件不轮转
    create 0640 www-data adm
    sharedscripts
    postrotate
        [ -f /var/run/nginx.pid ] && kill -USR1 `cat /var/run/nginx.pid`
    endscript
}

# 手动测试

logrotate -d /etc/logrotate.d/nginx  # 调试模式
logrotate -f /etc/logrotate.d/nginx  # 强制执行
```

*常用选项*：

- `daily/weekly/monthly`：轮转频率
- `rotate N`：保留N个备份
- `size N`：达到指定大小后轮转
- `compress`：压缩旧日志
- `copytruncate`：复制后清空（适合不支持 reopen 的应用）

=== rsyslog：传统日志系统

```bash
# 配置文件

/etc/rsyslog.conf
/etc/rsyslog.d/

# 基本规则

# 格式：facility.priority    action
*.info;mail.none;authpriv.none;cron.none    /var/log/messages
authpriv.*                                  /var/log/secure
mail.*                                      /var/log/maillog
cron.*                                      /var/log/cron

# 远程日志

*.* @@remote-host:514    # TCP
*.* @remote-host:514     # UDP

# 重启服务

sudo systemctl restart rsyslog
```

#note[
  现代 Linux 发行版通常同时运行 rsyslog 和 journald，journald 作为主要日志系统。
]

== 网络配置

=== ip：网络接口管理

```bash
# 查看网络接口

ip addr show
ip -brief addr show      # 简洁输出

# 查看路由表

ip route show
ip route get 8.8.8.8     # 查询特定IP的路由

# 查看邻居表（ARP）

ip neigh show

# 启用/禁用接口

sudo ip link set eth0 up
sudo ip link set eth0 down

# 添加IP地址

sudo ip addr add 192.168.1.100/24 dev eth0
sudo ip addr del 192.168.1.100/24 dev eth0
```

#tip[
  `ip` 命令取代了旧的 `ifconfig`、`route`、`arp` 等命令，功能更强大。
]

=== ss：Socket 统计

```bash
# 查看所有连接

ss -tulpn

# 输出示例：
# Netid State  Recv-Q Send-Q Local Address:Port  Peer Address:Port Process
# tcp   LISTEN 0      128    0.0.0.0:22          0.0.0.0:*     users:(...)
# tcp   ESTAB  0      0      192.168.1.10:22     192.168.1.5:54321

# 过滤

ss -t state established    # 已建立的TCP连接
ss -t state listening      # 监听端口
ss -u                      # UDP连接
ss -x                      # Unix socket

# 统计

ss -s                      # 摘要统计
```

*ss vs netstat*：

- `ss` 更快，直接从内核获取信息
- `netstat` 已废弃，但仍在广泛使用
- 推荐使用 `ss`

=== iptables：防火墙

```bash
# 查看规则

sudo iptables -L -n -v
sudo iptables -L INPUT -n -v

# 基本规则

sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT    # 允许SSH
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT    # 允许HTTP
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT   # 允许HTTPS
sudo iptables -A INPUT -j DROP                        # 拒绝其他

# 删除规则

sudo iptables -D INPUT 3    # 删除第3条规则

# 保存规则（Debian/Ubuntu）

sudo iptables-save > /etc/iptables/rules.v4

# 保存规则（CentOS/RHEL）

sudo service iptables save
```

#caution[
  iptables 规则复杂且容易出错，生产环境建议使用 firewalld 或 ufw 简化管理。
]

=== NetworkManager：网络管理

```bash
# 使用 nmcli

nmcli device status          # 查看设备状态
nmcli connection show        # 查看连接
nmcli device wifi list       # 扫描WiFi

# 配置静态IP

sudo nmcli con mod "eth0" ipv4.addresses 192.168.1.100/24
sudo nmcli con mod "eth0" ipv4.gateway 192.168.1.1
sudo nmcli con mod "eth0" ipv4.dns "8.8.8.8 8.8.4.4"
sudo nmcli con mod "eth0" ipv4.method manual
sudo nmcli con up "eth0"

# 使用 nmtui（文本界面）

sudo nmtui
```

#fancy-divider

本章完

= Shell 脚本自动化

Shell 脚本是 Linux 运维自动化的核心工具，通过编写脚本可以批量执行任务、定时调度、系统备份等。

== Shell 编程进阶

=== 函数定义与调用

```bash
#!/bin/bash

# 基本函数

greet() {
    echo "Hello, $1!"
}

# 调用函数

greet "Alice"
greet "Bob"

# 带返回值

add() {
    local result=$(($1 + $2))
    echo $result
}

sum=$(add 5 3)
echo "Sum: $sum"  # Sum: 8

# 检查函数是否存在

if declare -f greet > /dev/null; then
    echo "Function greet exists"
fi
```

#tip[
  使用 `local` 关键字声明局部变量，避免污染全局命名空间。
]

=== 数组操作

```bash
#!/bin/bash

# 定义数组

fruits=("apple" "banana" "cherry")
numbers=(1 2 3 4 5)

# 访问元素

echo ${fruits[0]}       # apple
echo ${fruits[@]}       # 所有元素
echo ${#fruits[@]}      # 数组长度（3）

# 修改数组

fruits[1]="orange"      # 修改元素
fruits+=("grape")       # 追加元素

# 遍历数组

for fruit in "${fruits[@]}"; do
    echo "Fruit: $fruit"
done

# 带索引遍历

for i in "${!fruits[@]}"; do
    echo "$i: ${fruits[$i]}"
done

# 切片

echo ${fruits[@]:1:2}   # 从索引1开始，取2个元素

# 关联数组（Bash 4+）

declare -A colors
colors["red"]="#FF0000"
colors["green"]="#00FF00"
colors["blue"]="#0000FF"

for key in "${!colors[@]}"; do
    echo "$key: ${colors[$key]}"
done
```

=== 正则表达式

```bash
#!/bin/bash

# 基本匹配

if [[ "hello world" =~ ^hello ]]; then
    echo "Starts with hello"
fi

# 提取匹配内容

email="user@example.com"
if [[ $email =~ ([a-zA-Z0-9._%+-]+)@([a-zA-Z0-9.-]+)\.([a-zA-Z]{2,}) ]]; then
    echo "Username: ${BASH_REMATCH[1]}"
    echo "Domain: ${BASH_REMATCH[2]}"
    echo "TLD: ${BASH_REMATCH[3]}"
fi

# 常用正则模式

# 验证IP地址
ip_pattern="^([0-9]{1,3}\.){3}[0-9]{1,3}$"
if [[ "192.168.1.1" =~ $ip_pattern ]]; then
    echo "Valid IP"
fi

# 验证日期格式
date_pattern="^[0-9]{4}-[0-9]{2}-[0-9]{2}$"
if [[ "2024-01-15" =~ $date_pattern ]]; then
    echo "Valid date format"
fi

# 验证手机号
phone_pattern="^1[3-9][0-9]{9}$"
if [[ "13812345678" =~ $phone_pattern ]]; then
    echo "Valid phone number"
fi
```

#note[
  Bash 的正则使用 `=~` 运算符，匹配结果存储在 `BASH_REMATCH` 数组中。
]

=== 字符串处理

```bash
#!/bin/bash

str="Hello World"

# 长度

echo ${#str}            # 11

# 截取

echo ${str:0:5}         # Hello
echo ${str:6}           # World
echo ${str: -5}         # World（注意空格）

# 替换

echo ${str/World/Unix}  # Hello Unix
echo ${str//l/L}        # HeLLo WorLd（全部替换）

# 删除

echo ${str#Hello }      # World（删除前缀）
echo ${str% World}      # Hello（删除后缀）

# 大小写转换

echo ${str,,}           # hello world（转小写）
echo ${str^^}           # HELLO WORLD（转大写）
echo ${str^}            # Hello world（首字母大写）

# 默认值

var=""
echo ${var:-default}    # default（如果var为空，使用default）
echo ${var:=default}    # 同时赋值
echo ${var:+exists}     # 如果var非空，返回exists
```

== 文本处理

=== awk 高级用法

```bash
#!/bin/bash

# 内置变量

awk '{print NR, NF, $0}' file.txt  # NR:行号, NF:字段数

# 条件过滤

awk '$3 > 100 {print $1, $3}' data.txt

# 数学运算

awk '{sum += $1} END {print "Sum:", sum, "Avg:", sum/NR}' numbers.txt

# 格式化输出

awk '{printf "%-10s %5d %8.2f\n", $1, $2, $3}' data.txt

# 多分隔符

awk -F'[: ]' '{print $1, $3}' file.txt  # 以:或空格分隔

# 关联数组

awk '{count[$1]++} END {for (word in count) print word, count[word]}' words.txt

# 外部变量

threshold=100
awk -v thresh=$threshold '$1 > thresh {print $0}' data.txt

# 实战：分析日志

# 统计HTTP状态码
awk '{print $9}' access.log | sort | uniq -c | sort -rn

# 统计IP访问次数
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head -10
```

#tip[
  awk 是一门完整的编程语言，适合复杂的文本处理任务。掌握 awk 可以大幅提升数据处理效率。
]

=== sed 高级用法

```bash
#!/bin/bash

# 多重编辑

sed -e 's/foo/bar/g' -e 's/baz/qux/g' file.txt

# 范围选择

sed '2,5d' file.txt              # 删除2-5行
sed '/start/,/end/d' file.txt    # 删除start到end之间的行

# 插入和追加

sed '2i\New Line Before' file.txt     # 在第2行前插入
sed '2a\New Line After' file.txt      # 在第2行后追加
sed '2c\Replace Line 2' file.txt      # 替换第2行

# 标签和分支（实现循环）

# 删除空行
sed '/^$/d' file.txt

# 合并连续空行为一行
sed '/^$/{N;/^\n$/d}' file.txt

# 反转文件行序

sed '1!G;h;$!d' file.txt

# 实战：批量修改配置文件

# 修改所有.conf文件中的端口
find /etc -name "*.conf" -exec sed -i 's/port=8080/port=9090/g' {} \;

# 注释掉特定行
sed -i '/^PermitRootLogin/s/^/#/' /etc/ssh/sshd_config
```

=== grep 高级用法

```bash
#!/bin/bash

# 扩展正则

grep -E "(error|warning|critical)" logfile.txt
grep -E "^[0-9]{4}-[0-9]{2}-[0-9]{2}" logfile.txt

# Perl正则

grep -P "\d{4}-\d{2}-\d{2}" logfile.txt

# 上下文

grep -A 5 "error" logfile.txt    # 显示匹配行及后5行
grep -B 5 "error" logfile.txt    # 显示匹配行及前5行
grep -C 5 "error" logfile.txt    # 显示匹配行及前后5行

# 递归搜索

grep -r "TODO" src/              # 递归搜索目录
grep -rl "TODO" src/             # 只显示文件名

# 排除文件

grep -r "pattern" --exclude="*.log" --exclude-dir="node_modules" .

# 计数和统计

grep -c "error" logfile.txt      # 统计匹配行数
grep -o "error" logfile.txt | wc -l  # 统计匹配次数

# 实战：日志分析

# 查找最近1小时的错误
grep "$(date -d '1 hour ago' '+%Y-%m-%d %H')" /var/log/syslog | grep error

# 统计各级别日志数量
grep -oP '\b(ERROR|WARN|INFO|DEBUG)\b' app.log | sort | uniq -c
```

== 定时任务

=== cron：周期性任务

```bash
# 编辑当前用户的 crontab

crontab -e

# 查看当前用户的 crontab

crontab -l

# 删除当前用户的 crontab

crontab -r

# 格式：分 时 日 月 周 命令
# *   *   *   *   * command
# |   |   |   |   |
# |   |   |   |   +-- 星期 (0-7, 0和7都是周日)
# |   |   |   +------ 月份 (1-12)
# |   |   +---------- 日期 (1-31)
# |   +-------------- 小时 (0-23)
# +------------------ 分钟 (0-59)

# 示例

# 每天凌晨2点执行
0 2 * * * /usr/local/bin/backup.sh

# 每15分钟执行
*/15 * * * * /usr/local/bin/check_health.sh

# 每周一上午9点执行
0 9 * * 1 /usr/local/bin/weekly_report.sh

# 每月1号凌晨3点执行
0 3 1 * * /usr/local/bin/monthly_cleanup.sh

# 工作日每小时执行
0 * * * 1-5 /usr/local/bin/hourly_task.sh

# 特殊字符串
@reboot /usr/local/bin/startup.sh          # 开机时执行
@yearly 0 0 1 1 * /usr/local/bin/yearly.sh # 每年执行
@monthly 0 0 1 * * /usr/local/bin/monthly.sh # 每月执行
@weekly 0 0 * * 0 /usr/local/bin/weekly.sh # 每周执行
@daily 0 0 * * * /usr/local/bin/daily.sh   # 每天执行
@hourly 0 * * * * /usr/local/bin/hourly.sh # 每小时执行
```

#caution[
  cron 的环境变量很少，建议在脚本中使用绝对路径，或在 crontab 开头设置 PATH。
]

=== at：一次性任务

```bash
# 在指定时间执行

at 14:30
at> /usr/local/bin/task.sh
at> <EOT>   # Ctrl+D 结束

# 延迟执行

at now + 1 hour
at> command
at> <EOT>

at now + 3 days
at> command
at> <EOT>

# 查看待执行任务

atq

# 删除任务

atrm 123  # 删除任务ID为123的任务

# 从文件读取任务

echo "/usr/local/bin/task.sh" | at 15:00
```

=== systemd timers：现代定时任务

```bash
# 创建 timer 单元文件

sudo tee /etc/systemd/system/backup.timer << EOF
[Unit]
Description=Daily Backup Timer

[Timer]
OnCalendar=*-*-* 02:00:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

# 创建对应的 service 单元文件

sudo tee /etc/systemd/system/backup.service << EOF
[Unit]
Description=Daily Backup

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup.sh
EOF

# 启用并启动 timer

sudo systemctl enable backup.timer
sudo systemctl start backup.timer

# 查看 timer 状态

systemctl list-timers
systemctl list-timers --all

# 查看下次执行时间

systemctl status backup.timer
```

#tip[
  systemd timers 比 cron 更强大，支持更精确的时间控制、持久化、依赖管理等。
]

== 系统备份

=== tar：归档压缩

```bash
#!/bin/bash

# 创建备份

tar czf backup-$(date +%Y%m%d).tar.gz /home/user/data

# 增量备份（需要配合 find）

find /home/user/data -mtime -1 -type f | tar czf incremental.tar.gz -T -

# 排除特定目录

tar czf backup.tar.gz --exclude='/tmp' --exclude='*.log' /home/user

# 查看归档内容

tar tzf backup.tar.gz

# 解压

tar xzf backup.tar.gz
tar xzf backup.tar.gz -C /target/dir  # 指定解压目录

# 保留权限

tar czpf backup.tar.gz /etc  # p 保留权限

# 分卷压缩（适合大文件）

tar czf - /large/dir | split -b 1G - backup.tar.gz.part.

# 恢复分卷

cat backup.tar.gz.part.* | tar xzf -
```

=== rsync：增量同步

```bash
#!/bin/bash

# 本地同步

rsync -avz /source/ /destination/

# 远程同步（SSH）

rsync -avz -e ssh /source/ user@remote:/destination/
rsync -avz -e ssh user@remote:/source/ /destination/

# 删除目标多余文件

rsync -avz --delete /source/ /destination/

# 排除文件

rsync -avz --exclude='*.log' --exclude='tmp/' /source/ /destination/

# 带宽限制

rsync -avz --bwlimit=1000 /source/ /destination/  # 1MB/s

# 断点续传

rsync -avz --partial --progress /source/ /destination/

# 备份脚本示例

#!/bin/bash

BACKUP_DIR="/backup"
SOURCE_DIR="/home/user/data"
DATE=$(date +%Y%m%d_%H%M%S)

# 创建备份目录
mkdir -p $BACKUP_DIR

# 执行备份
rsync -avz --delete \
    --exclude='*.tmp' \
    --exclude='cache/' \
    $SOURCE_DIR/ \
    $BACKUP_DIR/backup-$DATE/

# 删除7天前的备份
find $BACKUP_DIR -maxdepth 1 -name "backup-*" -mtime +7 -exec rm -rf {} \;

echo "Backup completed: backup-$DATE"
```

#tip[
  rsync 只传输变化的部分，非常适合增量备份和大文件同步。
]

=== 备份策略

```bash
#!/bin/bash

# 完整备份 + 增量备份策略

BACKUP_BASE="/backup"
SOURCE="/data"
DATE=$(date +%Y%m%d)
WEEKDAY=$(date +%u)  # 1-7 (Monday-Sunday)

# 每周日完整备份
if [ $WEEKDAY -eq 7 ]; then
    echo "Performing full backup..."
    tar czf $BACKUP_BASE/full-$DATE.tar.gz $SOURCE
else
    echo "Performing incremental backup..."
    # 基于昨天的备份进行增量
    YESTERDAY=$(date -d "yesterday" +%Y%m%d)
    if [ -f "$BACKUP_BASE/full-$YESTERDAY.tar.gz" ]; then
        find $SOURCE -newer $BACKUP_BASE/full-$YESTERDAY.tar.gz | \
            tar czf $BACKUP_BASE/incr-$DATE.tar.gz -T -
    fi
fi

# 清理旧备份（保留30天）
find $BACKUP_BASE -name "*.tar.gz" -mtime +30 -delete

echo "Backup completed on $(date)"
```

*备份策略建议*：

#tex-table(
  ("策略", "频率", "优点", "缺点"),
  ("完全备份", "每周", "恢复简单", "占用空间大"),
  ("增量备份", "每天", "节省空间", "恢复复杂"),
  ("差异备份", "每天", "折中方案", "后期备份变大"),
  ("快照备份", "实时", "快速一致", "需要文件系统支持"),
)

== 自动化部署脚本

=== SSH 免密登录

```bash
#!/bin/bash

# 生成密钥对（如果不存在）

if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa
fi

# 复制公钥到远程服务器

ssh-copy-id user@remote-server

# 手动配置

cat ~/.ssh/id_rsa.pub | ssh user@remote-server "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"

# 测试免密登录

ssh user@remote-server "echo 'Success!'"
```

#tip[
  使用 `ssh-agent` 管理密钥，避免每次输入 passphrase。
]

=== 批量执行命令

```bash
#!/bin/bash

# 服务器列表

SERVERS=(
    "user@server1.example.com"
    "user@server2.example.com"
    "user@server3.example.com"
)

# 批量执行命令

for server in "${SERVERS[@]}"; do
    echo "Executing on $server..."
    ssh $server "uname -a && df -h && free -m"
    echo "---"
done

# 并行执行（使用 background jobs）

for server in "${SERVERS[@]}"; do
    (
        echo "Executing on $server..."
        ssh $server "command"
    ) &
done

wait  # 等待所有后台任务完成

# 使用 parallel 工具（更高效）

parallel ssh {} "command" ::: "${SERVERS[@]}"
```

=== 自动化部署脚本

```bash
#!/bin/bash

set -euo pipefail  # 严格模式

# 配置

APP_NAME="myapp"
APP_DIR="/opt/$APP_NAME"
REPO_URL="git@github.com:user/myapp.git"
BRANCH="main"
BACKUP_DIR="/backup/$APP_NAME"
DATE=$(date +%Y%m%d_%H%M%S)

# 颜色输出

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 备份当前版本

backup_current() {
    log_info "Backing up current version..."
    mkdir -p $BACKUP_DIR
    if [ -d "$APP_DIR" ]; then
        tar czf $BACKUP_DIR/backup-$DATE.tar.gz -C $(dirname $APP_DIR) $(basename $APP_DIR)
        log_info "Backup created: backup-$DATE.tar.gz"
    fi
}

# 拉取最新代码

deploy_code() {
    log_info "Deploying code..."

    if [ ! -d "$APP_DIR" ]; then
        git clone $REPO_URL $APP_DIR
    else
        cd $APP_DIR
        git fetch origin
        git reset --hard origin/$BRANCH
    fi

    log_info "Code deployed from branch: $BRANCH"
}

# 安装依赖

install_dependencies() {
    log_info "Installing dependencies..."
    cd $APP_DIR

    # 根据项目类型选择
    if [ -f "requirements.txt" ]; then
        pip install -r requirements.txt
    elif [ -f "package.json" ]; then
        npm install --production
    elif [ -f "pom.xml" ]; then
        mvn clean package -DskipTests
    fi

    log_info "Dependencies installed"
}

# 重启服务

restart_service() {
    log_info "Restarting service..."
    sudo systemctl restart $APP_NAME
    sudo systemctl status $APP_NAME --no-pager
    log_info "Service restarted"
}

# 健康检查

health_check() {
    log_info "Performing health check..."
    sleep 5

    if curl -f http://localhost:8080/health > /dev/null 2>&1; then
        log_info "Health check passed"
        return 0
    else
        log_error "Health check failed"
        return 1
    fi
}

# 回滚函数

rollback() {
    log_warn "Rolling back to previous version..."

    LATEST_BACKUP=$(ls -t $BACKUP_DIR/backup-*.tar.gz | head -1)
    if [ -n "$LATEST_BACKUP" ]; then
        tar xzf $LATEST_BACKUP -C /
        sudo systemctl restart $APP_NAME
        log_info "Rollback completed"
    else
        log_error "No backup found for rollback"
        exit 1
    fi
}

# 主流程

main() {
    log_info "Starting deployment of $APP_NAME"

    backup_current
    deploy_code
    install_dependencies
    restart_service

    if health_check; then
        log_info "Deployment successful!"
    else
        log_error "Deployment failed, rolling back..."
        rollback
        exit 1
    fi
}

# 执行

main "$@"
```

#caution[
  生产环境部署建议使用专业的 CI/CD 工具（Jenkins、GitLab CI、GitHub Actions），而非手写脚本。
]

=== 监控告警脚本

```bash
#!/bin/bash

# 磁盘空间监控

check_disk() {
    THRESHOLD=90

    while read -r line; do
        usage=$(echo $line | awk '{print $5}' | sed 's/%//')
        mount=$(echo $line | awk '{print $6}')

        if [ $usage -gt $THRESHOLD ]; then
            echo "WARNING: Disk usage ${usage}% on $mount" | \
                mail -s "Disk Alert" admin@example.com
        fi
    done < <(df -h | tail -n +2)
}

# 内存监控

check_memory() {
    THRESHOLD=90

    used=$(free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}')

    if [ $used -gt $THRESHOLD ]; then
        echo "WARNING: Memory usage ${used}%" | \
            mail -s "Memory Alert" admin@example.com
    fi
}

# 服务监控

check_service() {
    SERVICE=$1

    if ! systemctl is-active --quiet $SERVICE; then
        echo "CRITICAL: Service $SERVICE is not running" | \
            mail -s "Service Alert: $SERVICE" admin@example.com

        # 尝试重启
        systemctl restart $SERVICE
    fi
}

# 执行检查

check_disk
check_memory
check_service nginx
check_service mysql

echo "Monitoring checks completed at $(date)"
```

#fancy-divider

本章完

= 服务管理与高可用
