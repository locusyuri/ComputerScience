![](https://locus622.oss-cn-beijing.aliyuncs.com/img/202503192210611.png)

# Linux 基础
## Linux简介
Linux 内核最初只是由芬兰人林纳斯·托瓦兹（Linus Torvalds）在赫尔辛基大学上学时出于个人爱好而编写的。

Linux 是一套免费使用和自由传播的类 Unix 操作系统，是一个基于 POSIX 和 UNIX 的多用户、多任务、支持多线程和多 CPU 的操作系统。

Linux 能运行主要的 UNIX 工具软件、应用程序和网络协议。它支持 32 位和 64 位硬件。Linux 继承了 Unix 以网络为核心的设计思想，是一个性能稳定的多用户网络操作系统。

Linux 的发行版说简单点就是将 Linux 内核与应用软件做一个打包。
![image.png](https://locus622.oss-cn-beijing.aliyuncs.com/img/202503192207777.png)

目前市面上较知名的发行版有：Ubuntu、RedHat、CentOS、Debian、Fedora、SuSE、OpenSUSE、Arch Linux、SolusOS 等。
- **红帽企业版** Linux：RHEL是全世界内使用最广泛的 Linux系统。它具有极强的性能与稳定性，是众多生成环境中使用的（收费的）系统。
- **Fedora** ：由红帽公司发布的桌面版系统套件，用户可以免费体验到最新的技术或工具，这些技术或工具在成熟后会被加入到RHEL系统中，因此 Fedora也成为RHEL系统的试验版本。
- **CentOS** ：通过把RHEL系统重新编译并发布给用户免费使用的 Linux系统，具有广泛的使用人群。
- **Deepin** ：中国发行，对优秀的开源成品进行集成和配置。
- **Debian** ：稳定性、安全性强，提供了免费的基础支持，在国外拥有很高的认可度和使用率。
- **Ubuntu** ：是一款派生自Debian的操作系统，对新款硬件具有极强的兼容能力。Ubuntu与Fedora都是极其出色的 Linux桌面系统，而且 Ubuntu也可用于服务器领域。

## 软件包管理工具
### 基于二进制包的管理工具（传统方式）
这类工具直接管理预编译的二进制软件包，安装速度快，适合大多数用户。

#### Debian/Ubuntu 系列（.deb 包）
- `apt`/`apt-get`
    - 说明：`apt-get` 是 Debian/Ubuntu 传统的命令行工具，`apt` 是其改进版（更简洁），用于搜索、安装、更新软件包。
    - 特点：使用软件源（`/etc/apt/sources.list`），支持依赖自动解析。

```bash
apt update && apt upgrade # 更新软件源和已安装包 
apt install package-name # 安装软件
```

- `dpkg`
    - 说明：底层工具，用于直接操作 `.deb` 包（安装、查询、删除），但不处理依赖关系。
    - 常用场景：手动安装本地下载的 `.deb` 包（如官网提供的安装包）。

#### Red Hat/CentOS/Fedora 系列（.rpm 包）
- `yum`（Yellowdog Updater, Modified）
    - 说明：Red Hat 系传统工具，用于管理 `.rpm` 包，支持依赖解析。
    - 现状：在 RHEL 8 及以上版本中逐渐被 `dnf` 替代。
- `dnf`（Dandified Yum）
    - 说明：`yum` 的新一代替代品，性能更好、功能更强，Fedora/RHEL 8+ 默认使用。

```bash
dnf update && dnf upgrade  # 更新系统
dnf install package-name   # 安装软件
```

#### Arch Linux 系列（.pkg.tar.zst 包）

- `pacman`
    - 说明：Arch Linux 及其衍生版（如 Manjaro）的官方工具，轻量高效，支持依赖管理和系统升级。
    - 特点：软件源更新及时，支持 `--sync`（同步源）和 `--install`（安装包）操作。
```bash
pacman -Sy  # 同步软件源
pacman -S package-name  # 安装软件
pacman -Rs package-name  # 删除软件及依赖
```

#### SUSE 系列（.rpm 包，兼容 Red Hat 体系）
- `zypper`
    - 说明：SUSE/openSUSE 的官方工具，基于 `rpm`，但界面更友好，支持图形化工具（如 YaST）。
```bash
zypper refresh  # 更新软件源
zypper install package-name  # 安装软件
```

### 基于源码编译的管理工具（定制化需求）

这类工具通过编译源代码安装软件，可自定义配置，但安装过程较慢。

#### Gentoo/Funtoo（Portage 框架）

- **`emerge`**
    - 说明：Gentoo 的核心工具，基于 Portage 软件仓库，通过编译源码安装软件，支持大量编译选项（USE 标志）。
    - 特点：高度定制化，但安装耗时，适合追求性能和定制性的用户。
```bash
emerge --ask package-name  # 编译并安装软件
```

#### FreeBSD（与 Linux 相关但属于 BSD 系统）

- **`pkgng`（`pkg`）**
    - 说明：FreeBSD 的官方包管理工具，支持二进制包和源码编译（通过 `ports` 系统）。
```bash
pkg install package-name  # 安装二进制包
```

### 通用型包管理工具（跨发行版）

这类工具不依赖特定发行版，适合在不同 Linux 系统中使用。

#### `snap`（Canonical 开发）

- 说明：基于容器技术的包管理工具，软件包（snap）包含完整运行环境，可跨发行版使用。
    - 特点：自动更新，沙盒化运行，但包体积较大。
    - 支持系统：Ubuntu、Debian、Arch、Fedora 等。
```bash
snap install package-name  # 安装软件
```

#### `flatpak`（原 xdg-app）

- 说明：另一种容器化包管理工具，软件包（flatpak）同样包含依赖，支持跨发行版。
    - 特点：更注重开源和社区生态，需手动配置软件源（如 Flathub）。

```bash
flatpak install flathub package-name  # 从 Flathub 安装
```

### 其他工具

- `nix`（NixOS 系统）
    声明式包管理工具，支持原子更新和多版本共存，适合复杂环境配置。
- `guix`（GNU 系统）  
    基于函数式编程的包管理工具，强调自由软件和可复现构建。


|发行版家族|代表系统|包格式|主要工具|
|---|---|---|---|
|Debian/Ubuntu|Ubuntu|.deb|`apt`, `dpkg`|
|Red Hat|RHEL/Fedora|.rpm|`dnf`, `yum`|
|Arch|Arch/Manjaro|.pkg.tar|`pacman`|
|SUSE|openSUSE|.rpm|`zypper`|
|Gentoo|Gentoo|源码|`emerge`|
|跨发行版通用|任意|容器化|`snap`, `flatpak`|
## 桌面环境 DE
桌面环境(Desktop Environment)是一系列组件的集合，它们共同提供了图形用户界面，让用户可以通过窗口、图标、菜单和面板与计算机进行直观的交互。一个完整的桌面环境通常包括：
- 窗口管理器：控制应用程序窗口的外观、位置和行为（如最大化、最小化）。
- 文件管理器：用于浏览和管理文件和文件夹。
- 面板/任务栏：通常位于屏幕顶部或底部，包含应用程序启动器、系统托盘、时钟和快捷方式。
- 登录管理器：图形化的登录界面。
- 一套核心应用程序：如文本编辑器、终端模拟器、图像查看器、计算器等。
- 工具和库：提供主题、图标、光标、字体等外观定制功能。

### 主流环境
#### GNOME
- 特点：现代化、简洁、注重用户体验和工作流。是许多主流发行版（如 Ubuntu、Fedora）的默认环境。
- 设计哲学：“简单至上”。默认布局取消了传统的桌面图标和最小化按钮，通过“活动概览”屏幕（按 `Super` 键）来访问所有应用程序和窗口，鼓励用户无分心地专注于当前任务。
- 外观：默认使用 Adwaita 主题，外观大气、圆润。对触摸板手势的支持非常好。
- 可定制性：官方不支持高度定制，以保持一致的体验。但可以通过扩展来增加功能，不过扩展可能会随版本更新而失效。
- 资源占用：中等偏高。近年来优化后已改善不少，但仍不如轻量级环境。
- 代表发行版：Fedora, Ubuntu, Debian, `Pop!_OS`（基于 GNOME 深度定制）

#### KDE Plasma
- 特点：功能极其丰富、视觉效果华丽、高度可定制。是 GNOME 的主要竞争对手。
- 设计哲学：“自由”。提供海量的设置选项，用户几乎可以调整每一个像素。它默认提供了类似 Windows 的传统布局，但也能轻松模仿 macOS 或其他风格。
- 外观：默认使用 Breeze 主题，清爽美观。支持丰富的动画特效和透明度效果。
- 可定制性：极高。被誉为“终极定制桌面”。面板、小部件、主题、快捷键等几乎所有东西都可以按用户喜好修改。
- 资源占用：与 GNOME 不相上下，但以其提供的丰富功能来看，效率非常高。
- 代表发行版：Kubuntu, KDE Neon, Manjaro KDE, openSUSE


### 轻量级环境
#### Xfce

- 特点：轻量、快速、稳定。它就像一个可靠的工具，不华丽但非常实用。
- 设计哲学：“用更少的资源做更多的事”。它遵循传统的桌面隐喻（底部面板、开始菜单），非常容易上手。
- 外观：默认外观略显传统和朴素，但可以通过主题美化得非常漂亮。
- 可定制性：良好。可以配置面板、菜单、主题等，但不如 KDE 那样深入骨髓。
- 资源占用：非常低。在保持功能完整的前提下，对内存和 CPU 的占用控制得极好。
- 代表发行版：Xubuntu, Manjaro Xfce
    

#### LXQt

- 特点：极致的轻量级。是 LXDE 和 Razor-qt 项目的合并产物。
- 设计哲学：“尽可能轻量，同时保持美观和可用性”。使用 Qt 工具包开发，而非 GTK。
- 外观：非常简洁，几乎没有多余的动画特效。
- 可定制性：一般，提供必要的配置选项。
- 资源占用：极低。甚至比 Xfce 还要轻量，是老旧电脑的救星。
- 代表发行版：Lubuntu, LXQt Spin of Fedora

#### MATE

- 特点：经典、传统。它是已停止维护的 GNOME 2 的一个分支，旨在保留那种经典、高效的桌面体验。
- 设计哲学：“延续经典”。对于从旧版 Linux 或 Windows XP/7 转来的用户来说，MATE 非常亲切和舒适。
- 外观：经典的底部面板+顶部面板布局，带有可展开的菜单。
- 可定制性：不错，可以通过工具调整面板和主题。
- 资源占用：较低，与 Xfce 属于同一级别。
- 代表发行版：Ubuntu MATE, Linux Mint MATE
### 创新性环境
#### 6. Cinnamon

- 特点：美观、易用、传统。由 Linux Mint 团队开发，最初是 GNOME 3 的一个分支，但现在已完全独立。
- 设计哲学：“为用户提供强大、先进的现代桌面，同时保持传统的操作习惯”。它非常适合从 Windows 转来的用户，几乎零学习成本。
- 外观：默认非常漂亮，类似 Windows 7 的布局，但带有现代感。
- 可定制性：很好，提供了专门的“桌面设置”工具，可以轻松调整主题、小程序、面板等。
- 资源占用：中等。
- 代表发行版：Linux Mint（默认）, Fedora Cinnamon Spin
    

#### 7. Budgie

- 特点：现代、简洁、优雅。由 Solus 项目开发，但现在已独立。
- 设计哲学：“设计为先”。旨在提供现代简洁的美学设计，同时保持传统的可用性。其标志性的 Raven 侧边栏用于通知、日历和系统控制，非常独特。
- 外观：非常干净、现代化，有一丝 macOS 的感觉。
- 可定制性：良好，可以通过面板和主题进行调整。
- 资源占用：中等偏低。
- 代表发行版：Solus, Ubuntu Budgie

#### Deepin DE

- 特点：极其华丽、动画效果丰富、一体化。由中国 Deepin 团队开发。
- 设计哲学：“美观易用，开箱即用”。它提供了一个高度集成的、类似 macOS 的精致体验，所有深度原生应用都拥有统一的设计语言。
- 外观：可能是 Linux 世界中最华丽、最精致的桌面环境，拥有大量平滑的动画效果。
- 可定制性：一般，主要提供一些主题和透明度设置。
- 资源占用：较高。华丽的视觉效果带来了相应的资源开销。
- 代表发行版：Deepin, Ubuntu DDE
### 窗口管理器
这类严格来说不是完整的“桌面环境”，但它们提供了另一种极致高效的选择。
- 特点：键盘驱动、极致高效、零鼠标操作。如 i 3 wm, AwesomeWM, Sway。
- 设计哲学：“自动管理窗口布局，最大化屏幕利用率和工作效率”。窗口会自动平铺排列，不会重叠。用户通过键盘快捷键完成所有操作。
- 外观：极其简约，甚至“丑陋”，一切为了功能服务。但高手可以通过配置将其美化得非常酷。
- 可定制性：无限。所有行为都通过纯文本配置文件定义，你可以完全掌控一切。
- 资源占用：极低。因为它们只包含最核心的窗口管理功能。
- 适用人群：程序员、系统管理员、键盘爱好者以及对效率有极致追求的用户。




# Linux 常用命令
[Linux命令大全](https://www.linuxcool.com/)

## 文件管理
### ls
Ls 命令来自英文单词 list 的缩写，中文译为“列出”，其功能是显示目录中的文件及其属性信息。

默认不添加任何参数的情况下，ls 命令会列出当前工作目录中的文件信息，常与 cd 或 pwd 命令搭配使用。

常用参数：
<table class="has-fixed-layout"><thead><tr><th>参数</th><th>说明</th></tr></thead><tbody><tr><td><code>-a</code></td><td>显示所有文件，包括以<code>.</code>开头的隐藏文件</td></tr><tr><td><code>-A</code></td><td>显示除<code>.</code>和<code>..</code>外的所有文件</td></tr><tr><td><code>-b</code></td><td>以八进制转义字符显示不可打印字符</td></tr><tr><td><code>-c</code></td><td>根据文件状态更改时间排序，并显示 ctime</td></tr><tr><td><code>-d</code></td><td>将目录视为普通文件，显示目录自身的信息</td></tr><tr><td><code>-f</code></td><td>不进行排序，直接列出结果，等同于启用<code>-aU</code>并禁用<code>-lst</code></td></tr><tr><td><code>-F</code></td><td>在每个名称后附加指示符号（例如：<code>/</code>表示目录，<code>*</code>表示可执行文件）</td></tr><tr><td><code>-h</code></td><td>以人类可读的格式显示文件大小（例如：1 K，234 M，2 G）</td></tr><tr><td><code>-i</code></td><td>显示文件的 inode 编号</td></tr><tr><td><code>-l</code></td><td>以长格式显示文件的详细信息，包括权限、所有者、大小和修改时间</td></tr><tr><td><code>-m</code></td><td>使用逗号分隔文件名，横向输出</td></tr><tr><td><code>-n</code></td><td>以数字形式显示用户和组 ID，而非名称</td></tr><tr><td><code>-p</code></td><td>在目录名后加上斜杠<code>/</code>以区分目录</td></tr><tr><td><code>-q</code></td><td>用问号<code>?</code>替换不可打印的字符</td></tr><tr><td><code>-r</code></td><td>逆序排列输出</td></tr><tr><td><code>-R</code></td><td>递归列出所有子目录及其内容</td></tr><tr><td><code>-s</code></td><td>显示每个文件的块大小</td></tr><tr><td><code>-S</code></td><td>按文件大小排序</td></tr><tr><td><code>-t</code></td><td>按修改时间排序，最新的排在前面</td></tr><tr><td><code>-u</code></td><td>显示文件的访问时间，并根据访问时间排序</td></tr><tr><td><code>-x</code></td><td>按行列顺序排列输出，横向排序</td></tr><tr><td><code>-1</code></td><td>每行只输出一个文件名</td></tr><tr><td><code>--color</code></td><td>根据文件类型使用不同颜色显示，参数可为<code>never</code>、<code>always</code>或<code>auto</code></td></tr><tr><td><code>--full-time</code></td><td>显示完整的时间戳信息</td></tr><tr><td><code>--help</code></td><td>显示此命令的帮助信息</td></tr><tr><td><code>--version</code></td><td>显示此命令的版本信息</td></tr></tbody></table>

### pwd
pwd 命令来自英文词组 print working directory 的缩写，其功能是显示当前工作目录的路径，即显示所在位置的绝对路‍径。  

常用参数：
<table><tbody><tr><td>-L <strong></strong></td><td>显示逻辑路径 </td><td rowspan="2"><strong>&nbsp;</strong></td><td>--version <strong></strong></td><td>显示版本信息 </td></tr><tr><td>-P <strong></strong></td><td>显示实际物理地址 <strong></strong></td><td>--help </td><td>显示帮助信息 <strong></strong></td></tr></tbody></table>


### tar
`tar` 是 Linux 中一个常用的文件归档工具，用于压缩和解压文件或目录。它支持多种压缩格式，比如 `.tar.gz`, `.tar.bz2` 等。
```bash
tar [选项] [参数]
```

- `-c`：创建新的归档文件（create）。
- `-x`：解压归档文件（extract）。
- `-v`：显示归档或解压过程中的详细信息（verbose）。
- `-f`：指定归档文件名（file）。
- `-z`：使用 gzip 压缩归档文件。
- `-j`：使用 bzip2 压缩归档文件。
- `-p`：保留文件权限。
- `-P`：保留绝对路径。
- `--exclude=pattern`：排除符合指定模式的文件或目录。

> [!note] 
> `gzip` 压缩速度较快，但压缩率较低；`bzip2` 压缩较慢，但压缩率较高。

## 文档编辑
### echo 
Echo 命令的功能是在终端设备上输出指定字符串或变量提取后的值，
1. 能够给用户一些简单的提醒信息 
2. 亦可以将输出的指定字符串内容同管道符一起传递给后续命令作为标准输入信息进行二次处理 
3. 还可以同输出重定向符一起操作，将信息直接写入文件。
4. 如需提取变量值，需在变量名称前加入 `$` 符号，变量名称一般均为大写形‍式。  

常用参数： 
<table><tbody><tr><td>-e “\a”<strong></strong></td><td>发出警告音</td><td rowspan="5"><strong>&nbsp;</strong></td><td>-e “\r”<strong></strong></td><td>光标移至行首但不换行</td></tr><tr><td>-e “\b”<strong></strong></td><td>删除前面的一个字符<strong></strong></td><td>-E</td><td>禁止反斜杠转义<strong></strong></td></tr><tr><td>-e “\c”<strong></strong></td><td>结尾不加换行符</td><td>-n<strong></strong></td><td>不输出结尾的换行符<strong></strong></td></tr><tr><td>-e “\f”</td><td>换行后光标仍停留在原来的位置<strong></strong></td><td>--version<strong></strong></td><td>显示版本信息</td></tr><tr><td>-e “\n”<strong></strong></td><td>换行后光标移至行首<strong></strong></td><td>--help </td><td>显示帮助信息<strong></strong></td></tr></tbody></table>

>[!note] 
>1. 通过 ANSI 转义码实现彩色文本，格式： `echo -e "\033[字体样式;前景色;背景色m文本\033[0m"` 
>2. 输出 `$` 需转义：`echo "Cost: \$100"`
>3. 路径斜杠无需转义：`echo "Path: /usr/bin"` 
>4. Windows 批处理中，`@echo` 仅显示输出的内容，而 `echo` 同时显示命令本身
>

---


覆盖写入文件 (`>`)：
```bash
echo "Content" > file.txt # 创建/覆盖文件内容
```

追加到文件 (`>>`)：
```bash
echo "New line" >> file.txt # 在文件末尾添加内容
```

生成多行文件 (配合 Here Document)：
```bash
cat <<EOF > config.conf 
[Database] 
host=localhost 
user=admin 
EOF
```

### grep
Grep 命令来自英文词组 global search regular expression and print out the line 的缩写，意思是用于全面搜索的正则表达式，并将结果输出。人们通常会将 grep 命令与正则表达式搭配使用，参数作为搜索过程中的补充或对输出结果的筛选，命令模式十分灵‍活。 

与之容易混淆的是 egrep 命令和 fgrep 命令。如果把 grep 命令当作标准搜索命令，那么 egrep 则是扩展搜索命令，等价于 grep -E 命令，支持扩展的正则表达式。而 fgrep 则是快速搜索命令，等价于 grep -F 命令，不支持正则表达式，直接按照字符串内容进行匹配。  

常用参数： 
<table><tbody><tr><td>-b</td><td>显示匹配行距文件头部的偏移量</td><td rowspan="6">&nbsp;</td><td>-o</td><td>显示匹配词距文件头部的偏移量</td></tr><tr><td>-c</td><td>只显示匹配的行数</td><td>-q</td><td>静默执行模式</td></tr><tr><td>-E</td><td>支持扩展正则表达式</td><td>-r</td><td>递归搜索模式</td></tr><tr><td>-F</td><td>匹配固定字符串的内容</td><td>-s</td><td>不显示没有匹配文本的错误信息</td></tr><tr><td>-h</td><td>搜索多文件时不显示文件名</td><td>-v</td><td>显示不包含匹配文本的所有行</td></tr><tr><td>-i</td><td>忽略关键词大小写</td><td>-w</td><td>精准匹配整词</td></tr><tr><td>-l</td><td>只显示符合匹配条件的文件名</td><td>&nbsp;</td><td>-x</td><td>精准匹配整行</td></tr><tr><td>-n</td><td>显示所有匹配行及其行号</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr></tbody></table>

---

基础文本搜索：
```bash
grep "error" system.log # 在 system.log 中搜索包含 "error" 的所有行
```

递归文本搜索：
```bash
grep -r "TODO" ./src/ # 递归搜索 ./src/ 目录下所有文件中的 "TODO"
```

正则表达式匹配：
```bash
grep "^202[0-9]-" log.txt # 匹配以 "2020"-"2029" 开头的日期行
```

### cat
Cat（全称 concatenate，意为“连接”）是 Linux/Unix 系统中一个基础且功能强大的文本处理命令，主要用于查看创建连接（合并）文件内容。

常用参数：
<table><tbody><tr><td>-A<strong></strong></td><td>等价于-vET 参数组合</td><td rowspan="6"><strong>&nbsp;</strong></td><td>-t<strong></strong></td><td>等价于-vT 参数组合</td></tr><tr><td>-b<strong></strong></td><td>显示行数（空行不编号）<strong></strong></td><td>-T</td><td>将 TAB 字符显示为^I 符号<strong></strong></td></tr><tr><td>-e<strong></strong></td><td>等价于-vE 参数组合</td><td>-v<strong></strong></td><td>使用^和 M-引用，LFD 和 TAB 除外<strong></strong></td></tr><tr><td>-E</td><td>每行结束处显示$符号<strong></strong></td><td>--help<strong></strong></td><td>显示帮助信息</td></tr><tr><td>-n<strong></strong></td><td>显示行数（空行也编号）<strong></strong></td><td>--version</td><td>显示版本信息<strong></strong></td></tr><tr><td>-s<strong></strong></td><td>显示行数（多个空行算一个编号） </td><td><strong>&nbsp;</strong></td><td><strong>&nbsp;</strong></td></tr></tbody></table>

>[!note] 
>Cat 会一次性加载整个文件到内存，大文件建议用 less 或 head/tail 



---

查看文件内容，支持同时查看多个文件，直接将文件内容打印到终端：
```bash
cat filename.txt # 显示 filename.txt 的内容
cat file1.txt file2.txt # 依次显示 file1 和 file2 的内容
```

创建新文件，从键盘输入内容保存为新文件 (`Ctrl + D` 结束输入，支持自定义结束符)：
```bash
cat > newfile.txt # 输入内容后保存到 newfile.txt
cat > newfile.txt << EOF # 输入内容直到遇到 "EOF" 结束
```

合并文件：
```bash
cat file1.txt file2.txt > merged.txt # 合并到 merged.txt, 覆盖目标文件
cat file1.txt >> existing.txt # 将 file1 内容追加到 existing.txt, 不覆盖原内容
```

