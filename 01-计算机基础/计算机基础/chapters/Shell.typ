#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= Shell 命令行与脚本编程

Shell 是用户与操作系统内核交互的接口，它读取用户输入的命令，解释并执行它们。掌握 Shell 是成为高效开发者的必备技能。

#note[
  Shell 的全称是 *Command-Line Interpreter*（命令行解释器），它提供了一个 REPL（Read-Eval-Print Loop）环境。
]

== Shell 概述

=== 什么是 Shell

Shell 是一个命令行解释器，位于用户和操作系统内核之间：

```text
┌──────────────┐
│   用户        │
└──────┬───────┘
       │ 输入命令
       v
┌──────────────┐
│   Shell      │  ← 命令行解释器
└──────┬───────┘
       │ 系统调用
       v
┌──────────────┐
│   Kernel     │  ← 操作系统内核
└──────────────┘
```

*核心功能*：

- 命令解析与执行
- 管道和重定向
- 变量和环境管理
- 脚本编程支持

=== REPL 循环

Shell 工作在 REPL 模式下：

1. *Read*：读取用户输入
2. *Eval*：解析并执行命令
3. *Print*：输出结果
4. *Loop*：回到步骤1

#tip[
  理解 REPL 模式有助于掌握交互式 Shell 的使用方式。
]

=== 常见 Shell 类型

==== Bash（Bourne Again Shell）

- Linux/macOS 默认 Shell
- POSIX 兼容
- 最广泛使用
- 丰富的功能和插件生态

==== Zsh（Z Shell）

- Bash 的增强版
- 更强大的自动补全
- 主题和插件系统（Oh My Zsh）
- macOS Catalina+ 默认 Shell

==== Fish（Friendly Interactive Shell）

- 用户友好设计
- 智能自动补全
- 语法高亮
- 开箱即用，无需配置

==== PowerShell

- Windows 默认 Shell
- 基于 .NET
- 对象管道而非文本管道
- 跨平台（PowerShell Core）

#tex-table(
  ("Shell", "平台", "特点", "学习曲线"),
  ("Bash", "Linux/macOS", "标准、稳定", "中"),
  ("Zsh", "跨平台", "强大、可定制", "中高"),
  ("Fish", "跨平台", "友好、智能", "低"),
  ("PowerShell", "Windows/跨平台", "对象导向", "中高"),
)

== Shell 实现

=== POSIX 标准

POSIX（Portable Operating System Interface）定义了 Shell 的行为规范：

*POSIX Shell 特性*：

- 基本命令语法
- 变量和参数扩展
- 控制结构（if、for、while）
- 函数定义
- 输入输出重定向

#note[
  编写可移植的 Shell 脚本时，应遵循 POSIX 标准，使用 `#!/bin/sh` 而非 `#!/bin/bash`。
]

=== Unix/Linux Shell

==== Bourne Shell (sh)

- 最早的 Unix Shell
- 由 Stephen Bourne 于1979年开发
- 现代 Shell 的基础

==== Bash

- GNU 项目的一部分
- sh 的超集
- 添加了数组、命令补全等功能
- 大多数 Linux 发行版的默认 Shell

==== Zsh

- 1990年由 Paul Falstad 创建
- 兼容 Bash
- 增强了交互体验
- Oh My Zsh 框架使其流行

=== Windows Shell

==== CMD（Command Prompt）

- Windows 传统命令行
- DOS 命令继承
- 功能有限
- 逐渐被 PowerShell 取代

==== PowerShell

- 2006年发布
- 基于 .NET Framework
- cmdlet（命令-动词）命名规范
- 对象管道：`Get-Process | Where-Object { $_.CPU -gt 100 }`

*PowerShell 示例*：

```powershell
# 获取所有进程并按 CPU 使用率排序
Get-Process | Sort-Object CPU -Descending | Select-Object -First 5

# 查找大文件
Get-ChildItem -Recurse | Where-Object { $_.Length -gt 100MB }
```

#tip[
  现代 Windows 开发推荐使用 PowerShell 或 WSL（Windows Subsystem for Linux）中的 Bash。
]

== 基本命令

=== 文件和目录操作

==== 导航命令

```bash
# 显示当前目录
pwd

# 列出目录内容
ls
ls -l      # 详细列表
ls -a      # 显示隐藏文件
ls -lh     # 人类可读的文件大小

# 切换目录
cd /path/to/dir
cd ..      # 上一级目录
cd ~       # 主目录
cd -       # 上一个目录
```

==== 文件操作

```bash
# 创建目录
mkdir new_dir
mkdir -p parent/child/grandchild  # 递归创建

# 删除
rm file.txt
rm -r directory    # 递归删除目录
rm -rf directory   # 强制删除（谨慎使用！）

# 复制
cp source.txt dest.txt
cp -r source_dir dest_dir  # 递归复制目录

# 移动/重命名
mv old_name.txt new_name.txt
mv file.txt /path/to/dir/

# 查看文件内容
cat file.txt
less file.txt      # 分页查看
head -n 10 file.txt  # 前10行
tail -n 10 file.txt  # 后10行
```

#caution[
  `rm -rf` 是危险命令，会永久删除文件且无法恢复。使用前务必确认路径正确！
]

==== 文件查找

```bash
# find：按条件查找文件
find . -name "*.txt"           # 按名称
find . -type f -size +1M       # 大于1MB的文件
find . -mtime -7               # 7天内修改的文件

# locate：快速查找（需要数据库）
locate filename

# which/whereis：查找命令位置
which python
whereis gcc
```

=== 文本查看与编辑

```bash
# 查看文件
cat file.txt              # 全部内容
head file.txt             # 前10行
tail file.txt             # 后10行
tail -f logfile.log       # 实时跟踪日志

# 简单编辑
echo "Hello" > file.txt   # 覆盖写入
echo "World" >> file.txt  # 追加写入

# 比较文件
diff file1.txt file2.txt
```

=== 系统信息

```bash
# 系统信息
uname -a          # 系统信息
hostname          # 主机名
whoami            # 当前用户
date              # 当前日期时间

# 磁盘空间
df -h             # 磁盘使用情况
du -sh directory  # 目录大小

# 内存信息
free -h           # 内存使用情况
```

#tip[
  使用 `-h`（human-readable）选项可以让输出更易读，自动转换为 KB、MB、GB 等单位。
]

== 文件权限

=== 权限表示

Unix/Linux 系统中，每个文件有三类权限：

- *r*（read）：读取权限
- *w*（write）：写入权限
- *x*（execute）：执行权限

针对三类用户：

- *u*（user/owner）：文件所有者
- *g*（group）：所属组
- *o*（others）：其他用户

*示例*：

```bash
-rwxr-xr-- 1 user group 1024 Jan 1 12:00 script.sh
```

分解：

```
-    rwx    r-x    r--
|     |      |      |
类型  所有者  所属组  其他用户
```

- `-`：普通文件（`d` 表示目录，`l` 表示链接）
- `rwx`：所有者有读、写、执行权限
- `r-x`：组成员有读、执行权限
- `r--`：其他用户只有读权限

=== chmod 命令

修改文件权限：

```bash
# 符号模式
chmod u+x script.sh       # 给所有者添加执行权限
chmod g-w file.txt        # 移除组的写入权限
chmod o=r file.txt        # 设置其他用户只读
chmod a+x script.sh       # 所有用户添加执行权限

# 数字模式（八进制）
chmod 755 script.sh       # rwxr-xr-x
chmod 644 file.txt        # rw-r--r--
chmod 600 private.key     # rw-------
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

#tip[
  常用权限：`755`（可执行脚本）、`644`（普通文件）、`600`（私钥等敏感文件）。
]

=== chown 和 chgrp

```bash
# 改变文件所有者
chown newuser file.txt
chown newuser:newgroup file.txt  # 同时改变所有者和组

# 改变所属组
chgrp newgroup file.txt

# 递归修改目录
chown -R user:group directory/
```

=== umask

设置默认权限掩码：

```bash
# 查看当前 umask
umask

# 设置 umask
umask 022    # 默认文件权限 644，目录 755
umask 027    # 更严格的权限
```

*计算规则*：

- 文件默认权限 = 666 - umask
- 目录默认权限 = 777 - umask

== 输入输出重定向

=== 标准流

Unix 系统有三个标准流：

- *stdin*（标准输入）：文件描述符 0，默认从键盘读取
- *stdout*（标准输出）：文件描述符 1，默认输出到屏幕
- *stderr*（标准错误）：文件描述符 2，默认输出到屏幕

=== 重定向操作符

```bash
# 输出重定向（覆盖）
echo "Hello" > file.txt

# 输出重定向（追加）
echo "World" >> file.txt

# 错误重定向
command 2> error.log

# 标准和错误都重定向
command > output.log 2>&1
command &> output.log    # Bash 简写

# 输入重定向
sort < unsorted.txt

# here string
grep "pattern" <<< "text to search"
```

=== 管道（Pipe）

将一个命令的输出作为另一个命令的输入：

```bash
# 基本管道
cat file.txt | grep "error" | wc -l

# 复杂管道
ps aux | sort -k3 -rn | head -n 10

# tee：同时输出到文件和屏幕
command | tee output.log

# 命名管道（FIFO）
mkfifo mypipe
cat < mypipe &
echo "Hello" > mypipe
```

#tip[
  管道是 Unix 哲学的核心："做一件事并做好"，通过组合简单工具完成复杂任务。
]

=== /dev/null 和 /dev/zero

```bash
# /dev/null：黑洞，丢弃所有写入的数据
command > /dev/null          # 丢弃输出
command > /dev/null 2>&1     # 丢弃所有输出

# /dev/zero：产生无限的字节约
 dd if=/dev/zero of=testfile bs=1M count=100  # 创建100MB文件
```

== 环境变量

=== 什么是环境变量

环境变量是在 Shell 会话中全局可用的键值对，用于配置系统和应用程序行为。

*常见环境变量*：

- `$HOME`：用户主目录
- `$PATH`：可执行文件搜索路径
- `$USER`：当前用户名
- `$SHELL`：当前 Shell
- `$PWD`：当前工作目录
- `$LANG`：语言设置

=== 查看和设置变量

```bash
# 查看所有环境变量
env
printenv

# 查看特定变量
echo $HOME
printenv PATH

# 设置变量（当前会话）
MY_VAR="hello"
export MY_VAR    # 导出为环境变量

# 设置并导出
export JAVA_HOME=/usr/lib/jvm/java-11

# 删除变量
unset MY_VAR
```

#note[
  未使用 `export` 的变量只在当前 Shell 中有效，不会传递给子进程。
]

=== PATH 变量

`$PATH` 定义了 Shell 搜索可执行文件的目录列表：

```bash
# 查看 PATH
echo $PATH

# 临时添加路径
export PATH=$PATH:/new/path

# 永久添加（添加到 ~/.bashrc 或 ~/.zshrc）
echo 'export PATH=$PATH:/new/path' >> ~/.bashrc
source ~/.bashrc
```

*PATH 搜索顺序*：

从左到右依次搜索，找到第一个匹配的可执行文件即停止。

=== 配置文件

*Bash 配置文件加载顺序*：

1. `/etc/profile`：系统级配置
2. `~/.bash_profile` 或 `~/.profile`：用户登录时加载
3. `~/.bashrc`：交互式非登录 Shell 加载
4. `~/.bash_logout`：退出时执行

*Zsh 配置文件*：

- `~/.zshenv`：始终加载
- `~/.zprofile`：登录 Shell
- `~/.zshrc`：交互式 Shell
- `~/.zlogin`：登录后
- `~/.zlogout`：退出时

#tip[
  通常将别名、函数、环境变量放在 `.bashrc`/`.zshrc` 中，将登录相关配置放在 `.bash_profile`/`.zprofile` 中。
]

== Shell 语法

=== 变量

```bash
# 定义变量（等号两边不能有空格）
name="Alice"
age=25

# 使用变量
echo $name
echo ${name}    # 推荐，更清晰

# 只读变量
readonly PI=3.14159

# 特殊变量
echo $0         # 脚本名称
echo $1, $2     # 位置参数
echo $#         # 参数个数
echo $@         # 所有参数
echo $?         # 上个命令的退出状态
echo $$         # 当前进程ID
```

=== 条件判断

==== if 语句

```bash
# 基本 if
if [ condition ]; then
    commands
fi

# if-else
if [ $age -ge 18 ]; then
    echo "Adult"
else
    echo "Minor"
fi

# if-elif-else
if [ $score -ge 90 ]; then
    echo "A"
elif [ $score -ge 80 ]; then
    echo "B"
elif [ $score -ge 70 ]; then
    echo "C"
else
    echo "F"
fi
```

==== 测试表达式

```bash
# 数值比较
[ $a -eq $b ]    # 等于
[ $a -ne $b ]    # 不等于
[ $a -gt $b ]    # 大于
[ $a -lt $b ]    # 小于
[ $a -ge $b ]    # 大于等于
[ $a -le $b ]    # 小于等于

# 字符串比较
[ "$str1" = "$str2" ]   # 相等
[ "$str1" != "$str2" ]  # 不等
[ -z "$str" ]           # 空字符串
[ -n "$str" ]           # 非空

# 文件测试
[ -f file.txt ]     # 普通文件
[ -d directory ]    # 目录
[ -e path ]         # 存在
[ -r file ]         # 可读
[ -w file ]         # 可写
[ -x file ]         # 可执行

# 逻辑运算
[ cond1 -a cond2 ]  # AND
[ cond1 -o cond2 ]  # OR
[ ! cond ]          # NOT

# 现代语法（推荐）
[[ $a == $b ]]      # 支持模式匹配
[[ $str =~ regex ]] # 正则匹配
```

=== 循环

==== for 循环

```bash
# 列表迭代
for item in apple banana cherry; do
    echo $item
done

# C风格
for ((i=0; i<10; i++)); do
    echo $i
done

# 遍历文件
for file in *.txt; do
    echo "Processing $file"
done

# 命令输出
for line in $(cat file.txt); do
    echo $line
done
```

==== while 循环

```bash
# 基本条件
while [ $count -lt 10 ]; do
    echo $count
    ((count++))
done

# 读取文件
while IFS= read -r line; do
    echo "$line"
done < file.txt

# 无限循环
while true; do
    echo "Running..."
    sleep 1
done
```

==== until 循环

```bash
# 直到条件为真
until [ $count -ge 10 ]; do
    echo $count
    ((count++))
done
```

=== 函数

```bash
# 定义函数
greet() {
    echo "Hello, $1!"
}

# 调用函数
greet "Alice"

# 带返回值
add() {
    local result=$(($1 + $2))
    echo $result
}

sum=$(add 5 3)
echo $sum  # 8

# 局部变量
my_function() {
    local var="local value"
    echo $var
}
```

#note[
  Shell 函数只能返回整数（0-255），通常通过 `echo` 输出结果并使用命令替换捕获。
]

=== 数组

```bash
# 定义数组
fruits=("apple" "banana" "cherry")

# 访问元素
echo ${fruits[0]}      # apple
echo ${fruits[@]}      # 所有元素
echo ${#fruits[@]}     # 数组长度

# 修改数组
fruits[1]="orange"
fruits+=("grape")      # 追加

# 遍历数组
for fruit in "${fruits[@]}"; do
    echo $fruit
done

# 切片
echo ${fruits[@]:1:2}  # 从索引1开始，取2个元素
```

== 文本处理工具

=== grep：模式匹配

```bash
# 基本搜索
grep "error" logfile.txt

# 忽略大小写
grep -i "error" logfile.txt

# 显示行号
grep -n "error" logfile.txt

# 递归搜索
grep -r "pattern" directory/

# 反向匹配
grep -v "info" logfile.txt

# 扩展正则
grep -E "(error|warning)" logfile.txt

# 计数
grep -c "error" logfile.txt
```

=== sed：流编辑器

```bash
# 替换
echo "Hello World" | sed 's/World/Unix/'

# 全局替换
echo "aaa bbb aaa" | sed 's/aaa/ccc/g'

# 删除行
sed '2d' file.txt          # 删除第2行
sed '/pattern/d' file.txt  # 删除匹配行

# 插入/追加
sed '2i\New Line' file.txt     # 在第2行前插入
sed '2a\New Line' file.txt     # 在第2行后追加

# 原地编辑
sed -i 's/old/new/g' file.txt
```

=== awk：文本处理语言

```bash
# 基本用法
awk '{print $1}' file.txt       # 打印第一列
awk '{print $1, $3}' file.txt   # 打印第1和第3列

# 分隔符
awk -F: '{print $1}' /etc/passwd  # 以:分隔

# 条件过滤
awk '$3 > 100 {print $1}' file.txt

# 内置变量
awk '{print NR, $0}' file.txt   # NR: 行号
awk '{print NF, $0}' file.txt   # NF: 字段数

# BEGIN/END 块
awk 'BEGIN {sum=0} {sum+=$1} END {print sum}' file.txt

# 格式化输出
awk '{printf "%-10s %5d\n", $1, $2}' file.txt
```

#tip[
  awk 是一门完整的编程语言，适合复杂的文本处理任务。简单场景用 grep/sed，复杂场景用 awk。
]

=== 其他文本工具

```bash
# sort：排序
sort file.txt              # 字母排序
sort -n file.txt           # 数字排序
sort -r file.txt           # 逆序
sort -t: -k3 -n file.txt   # 按第3字段数字排序

# uniq：去重（需要先排序）
sort file.txt | uniq
sort file.txt | uniq -c    # 显示出现次数

# wc：统计
wc -l file.txt             # 行数
wc -w file.txt             # 单词数
wc -c file.txt             # 字节数

# cut：提取列
cut -d: -f1 /etc/passwd    # 以:分隔，取第1列
cut -c1-5 file.txt         # 取每行前5个字符

# tr：转换或删除字符
echo "HELLO" | tr 'A-Z' 'a-z'  # 转小写
echo "hello" | tr -d 'l'        # 删除'l'

# head/tail：首尾行
head -n 10 file.txt        # 前10行
tail -n 10 file.txt        # 后10行
tail -f logfile.log        # 实时跟踪
```

== 进程管理

=== 查看进程

```bash
# ps：进程快照
ps                     # 当前终端的进程
ps aux                 # 所有进程的详细信息
ps -ef                 # 完整格式
ps -u username         # 特定用户的进程

# top：动态监控
top                    # 交互式监控
htop                   # 增强版（需安装）

# pgrep：按名称查找
pgrep nginx            # 查找nginx进程ID
pgrep -l python        # 显示名称
```

*ps aux 输出解释*：

#tex-table(
  ("列", "含义"),
  ("USER", "用户"),
  ("PID", "进程ID"),
  ("%CPU", "CPU使用率"),
  ("%MEM", "内存使用率"),
  ("VSZ", "虚拟内存"),
  ("RSS", "物理内存"),
  ("STAT", "状态"),
  ("COMMAND", "命令"),
)

=== 终止进程

```bash
# kill：发送信号
kill 1234              # 默认发送 SIGTERM
kill -9 1234           # 强制终止（SIGKILL）
kill -15 1234          # 优雅终止（SIGTERM）

# killall：按名称终止
killall nginx
killall -9 python

# pkill：按模式终止
pkill -f "python script.py"
```

*常用信号*：

- `SIGTERM` (15)：请求终止（默认）
- `SIGKILL` (9)：强制终止
- `SIGHUP` (1)：重新加载配置
- `SIGINT` (2)：中断（Ctrl+C）
- `SIGSTOP` (19)：暂停
- `SIGCONT` (18)：继续

=== 后台作业

```bash
# 后台运行
command &

# 查看作业
jobs
jobs -l                # 显示PID

# 前台/后台切换
fg %1                  # 将作业1放到前台
bg %1                  # 将作业1放到后台

# 挂起和恢复
Ctrl+Z                 # 挂起当前进程
kill %1                # 终止作业1

# nohup：退出终端后继续运行
nohup command > output.log 2>&1 &
```

#tip[
  对于长时间运行的任务，推荐使用 `tmux` 或 `screen` 而非 nohup，可以更好地管理会话。
]

== Shell 脚本编程

=== 脚本基础

==== Shebang

```bash
#!/bin/bash          # Bash 脚本
#!/bin/sh            # POSIX Shell
#!/usr/bin/env python3  # Python 脚本
```

#note[
  Shebang 必须是文件的第一行，告诉系统使用哪个解释器执行脚本。
]

==== 创建和运行脚本

```bash
# 创建脚本
cat > myscript.sh << 'EOF'
#!/bin/bash
echo "Hello, World!"
EOF

# 添加执行权限
chmod +x myscript.sh

# 运行脚本
./myscript.sh
bash myscript.sh       # 或者显式指定解释器
```

=== 参数传递

```bash
#!/bin/bash

echo "脚本名称: $0"
echo "第一个参数: $1"
echo "第二个参数: $2"
echo "所有参数: $@"
echo "参数个数: $#"
echo "进程ID: $$"

# 移位
shift                  # $1变成$2，$2变成$3...
echo "移位后第一个参数: $1"
```

*运行示例*：

```bash
./script.sh arg1 arg2 arg3
```

=== 错误处理

```bash
#!/bin/bash

# 遇到错误立即退出
set -e

# 未定义变量报错
set -u

# 管道中任一命令失败则退出
set -o pipefail

# 打印执行的命令
set -x

# 组合使用（推荐）
set -euo pipefail

# 自定义错误处理
error_handler() {
    echo "Error on line $1"
    exit 1
}
trap 'error_handler $LINENO' ERR

# 检查命令是否成功
if ! command_that_might_fail; then
    echo "Command failed"
    exit 1
fi

# 或使用 ||
command_that_might_fail || echo "Fallback action"
```

=== 调试技巧

```bash
# 启用调试模式
bash -x script.sh

# 在脚本中启用/禁用调试
set -x     # 开启调试
# ... 代码 ...
set +x     # 关闭调试

# 输出到stderr
echo "Debug info" >&2

# 使用日志函数
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" >&2
}

log "Starting process..."
```

== 高级特性

=== 命令替换

```bash
# 旧语法（不推荐）
date_str=`date`

# 新语法（推荐）
date_str=$(date)
files=$(ls *.txt)

# 嵌套使用
result=$(echo $(dirname $(readlink -f "$0")))
```

=== 进程替换

```bash
# 将命令输出作为文件
diff <(sort file1.txt) <(sort file2.txt)

# 多个输入源
cat <(echo "Line 1") <(echo "Line 2")

# 输出重定向到进程
tee >(wc -l) < file.txt
```

=== Here Document

```bash
# 基本用法
cat << EOF
This is line 1
This is line 2
Variable: $HOME
EOF

# 禁止变量扩展
cat << 'EOF'
Variable will not expand: $HOME
EOF

# 去除前导tab
cat <<- EOF
	Indented line
	Another line
EOF

# 用于SQL、HTML等多行文本
mysql database << SQL
SELECT * FROM users;
SQL
```

=== Here String

```bash
# 将字符串作为输入
grep "pattern" <<< "text to search"
wc -w <<< "hello world"
```

=== Trap 信号处理

```bash
#!/bin/bash

# 清理临时文件
temp_file=$(mktemp)
trap "rm -f $temp_file" EXIT

# 捕获中断信号
cleanup() {
    echo "Cleaning up..."
    rm -f $temp_file
    exit 0
}
trap cleanup SIGINT SIGTERM

# 主逻辑
while true; do
    echo "Working..."
    sleep 1
done
```

*常用信号*：

- `EXIT`：脚本退出时
- `ERR`：命令失败时
- `SIGINT`：Ctrl+C
- `SIGTERM`：kill 命令
- `SIGHUP`：终端断开

=== 子 Shell

```bash
# 在子shell中执行
(cd /tmp && ls)    # 不影响当前目录

# 命令组
{ cmd1; cmd2; }    # 当前shell
(cmd1; cmd2)       # 子shell

# 后台子shell
(long_running_command) &
```

== Shell 效率提升

=== 别名（Alias）

```bash
# 查看别名
alias

# 创建别名
alias ll='ls -la'
alias gs='git status'
alias gpo='git push origin'
alias mkcd='mkdir -p "$1" && cd "$1"'

# 临时禁用别名
\ls                # 使用原始命令
command ls         # 同上

# 永久保存（添加到 ~/.bashrc 或 ~/.zshrc）
echo "alias ll='ls -la'" >> ~/.bashrc
```

#tip[
  为常用命令创建别名可以大幅提升效率，但不要过度使用，避免忘记原始命令。
]

=== 快捷键

*光标移动*：

- `Ctrl+A`：行首
- `Ctrl+E`：行尾
- `Alt+B`：向前一个单词
- `Alt+F`：向后一个单词

*编辑操作*：

- `Ctrl+U`：删除到行首
- `Ctrl+K`：删除到行尾
- `Ctrl+W`：删除前一个单词
- `Ctrl+Y`：粘贴（yank）
- `Ctrl+T`：交换字符
- `Alt+T`：交换单词

*历史搜索*：

- `Ctrl+R`：反向搜索历史
- `Ctrl+S`：正向搜索历史
- `!!`：上一条命令
- `!$`：上一条命令的最后一个参数
- `!*`：上一条命令的所有参数

*其他*：

- `Ctrl+L`：清屏
- `Ctrl+C`：中断当前命令
- `Ctrl+Z`：挂起当前命令
- `Ctrl+D`：退出 Shell 或 EOF

=== 自动补全

```bash
# Tab：基本补全
ls /usr/lo<Tab>    # 补全为 /usr/local/

# Tab Tab：显示所有可能
ls /usr/<Tab><Tab>

# 增强补全（需要安装）
# Bash: bash-completion
# Zsh: zsh-autosuggestions, zsh-syntax-highlighting
```

=== 历史搜索

```bash
# Ctrl+R：交互式搜索
# 输入关键词，按Ctrl+R循环匹配

# !!：重复上一条命令
sudo !!            # 以sudo重新运行

# !string：运行最近以string开头的命令
!git               # 运行最近的git命令

# !$：上一条命令的最后一个参数
mkdir new_dir
cd !$              # cd new_dir

# history：查看历史
history | grep git
```

=== 提示符定制

*Bash 提示符*：

```bash
# 编辑 ~/.bashrc
export PS1="\u@\h:\w\$ "

# 常用转义序列
# \u: 用户名
# \h: 主机名
# \w: 当前目录
# \$: 提示符（$或#）
# \t: 时间
# \!: 历史编号
```

*Zsh 主题*：

```bash
# 使用 Oh My Zsh
# 编辑 ~/.zshrc
ZSH_THEME="agnoster"

# 其他流行主题：powerlevel10k, robbyrussell, bira
```

#fancy-divider

本章完
