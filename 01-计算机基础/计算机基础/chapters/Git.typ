#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= Git版本控制详解

Git是目前最流行的分布式版本控制系统，由Linus Torvalds于2005年创建，用于Linux内核开发。它以其速度、数据完整性和对非线性工作流的强大支持而闻名。

#note[
  Git的核心设计理念是*快照*而非*差异*。每次提交时，Git都会存储整个项目的快照，如果文件没有变化，则只存储指向之前版本的链接。
]

== 版本控制系统概述

=== 集中式 vs 分布式

==== 集中式版本控制（CVCS）

代表工具：SVN、CVS、Perforce

*特点*：

- 单一中央服务器存储所有版本历史
- 客户端只获取最新版本
- 必须联网才能进行大部分操作
- 中央服务器是单点故障

*优点*：

- 权限管理简单
- 学习曲线较低
- 适合小型团队

*缺点*：

- 网络依赖性强
- 中央服务器故障影响所有人
- 分支和合并操作较慢

==== 分布式版本控制（DVCS）

代表工具：Git、Mercurial、Bazaar

*特点*：

- 每个客户端都有完整的仓库副本
- 大多数操作在本地完成
- 支持离线工作
- 无单点故障

*优点*：

- 速度快（本地操作）
- 支持离线工作
- 分支和合并高效
- 更好的容错性

*缺点*：

- 学习曲线较陡
- 仓库占用空间较大
- 权限管理复杂

#tip[
  现代软件开发中，分布式版本控制已成为主流，Git占据了超过90%的市场份额。
]

=== 其他版本管理工具简介

虽然 Git 已成为行业标准，但了解其他工具仍有价值：

*Subversion (SVN)*：

- 最流行的集中式版本控制系统
- 适合二进制文件管理（如设计资源）
- 目录级权限控制更精细
- 仍在一些传统企业中使用

*Mercurial (Hg)*：

- 分布式版本控制，与 Git 类似
- 命令更简洁直观
- Python 编写，跨平台性好
- Bitbucket 早期默认支持

*Perforce (P4)*：

- 商业版本控制系统
- 擅长处理大型二进制文件
- 游戏开发行业广泛使用
- 细粒度权限控制

#note[
  除非有特殊需求（如公司强制要求），否则建议直接使用 Git。它的生态系统最完善，社区支持最好。
]

=== Git的发展历程

- *2005年*：Linus Torvalds创建Git，替代BitKeeper
- *2008年*：GitHub上线，推动Git普及
- *2010年后*：Git成为行业标准
- *现在*：几乎所有开源项目和大多数企业都使用Git

== Git核心概念

=== 四个工作区域

Git有四个主要的工作区域，理解它们是掌握Git的关键：

==== 工作区（Working Directory）

- 你正在编辑的文件所在的目录
- 包含项目的当前状态
- 可以随意修改文件

==== 暂存区（Staging Area / Index）

- 也称为"索引"
- 临时存储下次要提交的文件快照
- 通过 `git add` 将文件从工作区添加到暂存区
- 允许你精心准备每次提交的内容

==== 本地仓库（Local Repository）

- 位于 `.git` 目录下
- 存储所有提交历史和元数据
- 是你的完整项目历史
- 通过 `git commit` 将暂存区内容提交到本地仓库

==== 远程仓库（Remote Repository）

- 存储在远程服务器上的仓库副本
- 如GitHub、GitLab、Gitee等平台
- 通过 `git push` 和 `git pull` 同步

==== HEAD指针

- 指向当前检出的提交或分支
- 通常是一个符号引用，指向当前分支
- 可以使用 `git log HEAD` 查看当前位置
- 分离 HEAD 状态：直接指向某个提交而非分支

```text
┌─────────────┐     git add      ┌──────────┐    git commit    ┌──────────────┐
│   工作区     │ ───────────────> │  暂存区   │ ──────────────> │  本地仓库     │
│ (修改文件)   │                  │ (准备提交) │                 │ (保存历史)    │
└─────────────┘                  └──────────┘                 └──────┬───────┘
                                                                     │
                                                              git push/pull
                                                                     │
                                                                     v
                                                            ┌──────────────┐
                                                            │  远程仓库     │
                                                            │ (团队协作)    │
                                                            └──────────────┘
```

#caution[
  新手常犯的错误是直接将工作区的修改commit，而忽略了add步骤。记住：先add，再commit！
]

=== 文件状态

Git中的文件有三种状态：

- *已修改（modified）*：文件已被修改但尚未暂存
- *已暂存（staged）*：文件已标记为下次提交的版本
- *已提交（committed）*：文件已安全存储在本地数据库中

=== Git对象类型

Git底层使用四种对象类型来存储数据：

==== Blob（二进制大对象）

- 存储文件内容
- 不包含文件名或元数据
- 相同内容的文件只存储一次

==== Tree（树对象）

- 表示目录结构
- 包含文件名、权限和指向blob或其他tree的指针
- 类似于文件系统的目录

==== Commit（提交对象）

- 包含指向tree对象的指针
- 包含作者、提交者、时间戳和提交信息
- 包含指向父提交的指针（形成历史记录）

==== Tag（标签对象）

- 给特定提交打上永久标签
- 通常用于标记发布版本
- 包含标签名、消息和指向commit的指针

#tip[
  可以使用 `git cat-file -p <hash>` 查看任何Git对象的详细内容，深入了解Git内部工作原理。
]

== Git基本操作

=== 初始化仓库

==== git init

在当前目录创建新的Git仓库：

```bash
git init
```

会在当前目录创建 `.git` 隐藏目录，包含所有Git元数据。

==== git clone

克隆远程仓库到本地：

```bash
# 克隆仓库
git clone https://github.com/user/repo.git

# 克隆到指定目录
git clone https://github.com/user/repo.git my-project

# 克隆特定分支
git clone -b develop https://github.com/user/repo.git
```

#note[
  `git clone` 会自动设置origin远程仓库，并检出默认分支（通常是main或master）。
]

=== 查看状态与历史

==== git status

显示工作区和暂存区的状态：

```bash
git status

# 简洁输出
git status -s
```

输出示例：

```
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   README.md

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        new_file.txt
```

==== git log

查看提交历史：

```bash
# 基本日志
git log

# 一行显示
git log --oneline

# 图形化显示分支
git log --graph --oneline --all

# 显示统计信息
git log --stat

# 显示补丁
git log -p

# 最近n次提交
git log -n 5
```

==== git diff

查看文件差异：

```bash
# 工作区与暂存区的差异
git diff

# 暂存区与最新提交的差异
git diff --staged

# 两个提交之间的差异
git diff commit1 commit2

# 特定文件的差异
git diff filename
```

=== 添加与提交

==== git add

将文件添加到暂存区：

```bash
# 添加特定文件
git add file.txt

# 添加多个文件
git add file1.txt file2.txt

# 添加所有修改的文件
git add .

# 交互式添加
git add -i

# 添加部分修改（patch模式）
git add -p
```

#tip[
  使用 `git add -p` 可以逐块审查修改，选择性地暂存部分修改，非常适合精细控制提交内容。
]

==== git commit

将暂存区的内容提交到本地仓库：

```bash
# 基本提交
git commit -m "feat: add user authentication"

# 使用编辑器编写详细提交信息
git commit

# 跳过暂存区，直接提交所有修改的文件
git commit -a -m "fix: correct typo"

# 修改最后一次提交
git commit --amend
```

*提交信息规范*（Conventional Commits）：

```
<type>(<scope>): <subject>

<body>

<footer>
```

常用type：

- `feat`: 新功能
- `fix`: 修复bug
- `docs`: 文档更新
- `style`: 代码格式（不影响功能）
- `refactor`: 重构
- `test`: 测试相关
- `chore`: 构建过程或辅助工具变动

#caution[
  避免使用模糊的提交信息如"update"、"fix bug"。好的提交信息应该清晰说明*做了什么*和*为什么做*。
]

=== 撤销操作

==== git restore

撤销工作区的修改：

```bash
# 撤销单个文件的修改
git restore file.txt

# 撤销所有未暂存的修改
git restore .
```

==== git reset

重置暂存区或回退提交：

```bash
# 软重置：保留工作区和暂存区
git reset --soft HEAD~1

# 混合重置（默认）：保留工作区，清空暂存区
git reset HEAD~1

# 硬重置：丢弃工作区和暂存区的修改
git reset --hard HEAD~1

# 重置特定文件
git reset HEAD file.txt
```

#caution[
  `git reset --hard` 会永久丢失未提交的修改，使用前务必确认！
]

==== git revert

创建新的提交来撤销之前的修改（安全的方式）：

```bash
# 撤销某次提交
git revert <commit-hash>

# 撤销多次提交
git revert HEAD~3..HEAD
```

#tip[
  对于已经push到远程的提交，使用 `git revert` 而非 `git reset`，避免破坏共享历史。
]

== 分支管理

分支是Git最强大的特性之一，允许你并行开发多个功能。

=== 分支基本概念

Git中的分支本质上是一个指向特定提交的轻量级指针。创建、切换和删除分支都非常快速。

```text
      A---B---C  main
           \
            D---E  feature
```

=== 基本分支操作

==== 查看分支

```bash
# 查看所有本地分支
git branch

# 查看所有分支（包括远程）
git branch -a

# 查看分支及其最后提交
git branch -v

# 查看已合并的分支
git branch --merged

# 查看未合并的分支
git branch --no-merged
```

==== 创建分支

```bash
# 创建新分支
git branch feature-login

# 创建并切换到新分支
git checkout -b feature-login

# 基于特定提交创建分支
git branch feature-login abc1234
```

==== 切换分支

```bash
# 切换到已有分支（旧命令）
git checkout feature-login

# 或使用新命令（推荐）
git switch feature-login

# 切换回上一个分支
git checkout -
git switch -
```

#tip[
  Git 2.23+引入了 `git switch` 和 `git restore`，使命令语义更清晰。`git checkout` 仍然可用但功能过于复杂。
]

==== 解决合并冲突

当两个分支修改了同一文件的同一部分时，会产生冲突：

*步骤1：查看冲突文件*

```bash
git status
```

*步骤2：手动编辑冲突文件*

查找冲突标记：

```text
<<<<<<< HEAD
你的修改
别人的修改
>>>>>>> feature-branch
```

保留需要的代码，删除冲突标记。

*步骤3：标记冲突已解决*

```bash
git add resolved_file.txt
```

*步骤4：完成合并*

```bash
git commit
```

*使用可视化工具*：

```bash
# 使用内置合并工具
git mergetool

# 配置喜欢的合并工具
git config --global merge.tool meld
git mergetool
```

#tip[
  推荐使用 VS Code、IntelliJ IDEA 等 IDE 的内置合并工具，界面友好，操作直观。
]

==== 删除分支

```bash
# 删除已合并的分支
git branch -d feature-login

# 强制删除未合并的分支
git branch -D feature-login

# 删除远程分支
git push origin --delete feature-login
```

=== 合并分支

==== git merge

将一个分支的更改合并到当前分支：

```bash
# 切换到目标分支
git checkout main

# 合并feature分支
git merge feature-login
```

*合并策略*：

- *Fast-forward*：如果目标分支是源分支的直接祖先，只是移动指针
- *Three-way merge*：创建一个新的merge commit
- *Squash merge*：将所有提交压缩为一个

```bash
# 禁用fast-forward，总是创建merge commit
git merge --no-ff feature-login

# Squash合并
git merge --squash feature-login
git commit -m "feat: add login feature"
```

==== 解决冲突

当两个分支修改了同一文件的同一部分时，会产生冲突：

```bash
# 查看冲突文件
git status

# 手动编辑冲突文件，解决冲突后
git add resolved_file.txt
git commit
```

冲突标记：

```text
<<<<<<< HEAD
你的修改
别人的修改
>>>>>>> feature-branch
```

#tip[
  使用 `git mergetool` 可以调用可视化的合并工具（如meld、kdiff3）来解决冲突。
]

=== Rebase（变基）

Rebase可以将一个分支的提交"重新播放"到另一个分支上，保持线性历史。

```bash
# 将当前分支rebase到main
git checkout feature
git rebase main
```

*Merge vs Rebase*：

#tex-table(
  ("特性", "Merge", "Rebase"),
  ("历史记录", "保留完整历史，有merge commit", "线性历史，更清晰"),
  ("真实性", "反映真实的开发过程", "重写历史"),
  ("安全性", "安全，不改变历史", "可能危险，特别是已push的提交"),
  ("适用场景", "公共分支", "私有分支"),
)

#caution[
  *永远不要rebase已经push到远程的公共分支*！这会改写历史，导致其他协作者的仓库出现问题。
]

==== 交互式Rebase

可以修改、合并、删除或重新排序提交：

```bash
git rebase -i HEAD~3
```

可用命令：

- `pick`: 保留提交
- `reword`: 保留提交，修改提交信息
- `edit`: 暂停，允许修改提交
- `squash`: 合并到前一个提交
- `fixup`: 类似squash，但丢弃提交信息
- `drop`: 删除提交

#tip[
  交互式rebase是整理提交历史的强大工具，可以让你的提交历史更加清晰和专业。
]

== 远程协作

=== 远程仓库管理

==== 查看远程仓库

```bash
# 查看远程仓库
git remote -v

# 查看远程仓库详细信息
git remote show origin
```

==== 添加远程仓库

```bash
# 添加远程仓库
git remote add origin https://github.com/user/repo.git

# 添加多个远程仓库
git remote add upstream https://github.com/original/repo.git
```

==== 重命名和删除远程仓库

```bash
# 重命名
git remote rename origin github

# 删除
git remote remove github
```

=== 推送与拉取

==== git push

将本地提交推送到远程仓库：

```bash
# 推送到默认远程和分支
git push

# 推送到特定远程和分支
git push origin main

# 首次推送，设置上游分支
git push -u origin main

# 强制推送（谨慎使用）
git push --force

# 更安全的强制推送（只覆盖没有其他人推送的部分）
git push --force-with-lease
```

#caution[
  避免使用 `--force`，优先使用 `--force-with-lease`，它会检查远程分支是否被其他人更新过。
]

==== git pull

从远程仓库拉取并合并更改：

```bash
# 拉取并合并
git pull

# 拉取特定分支
git pull origin main

# 拉取但不自动合并
git pull --no-commit

# 使用rebase代替merge
git pull --rebase
```

==== git fetch

仅下载远程更改，不自动合并：

```bash
# 获取所有远程分支的更新
git fetch

# 获取特定远程
git fetch origin

# 获取特定分支
git fetch origin main
```

#tip[
  推荐工作流程：先 `git fetch` 查看远程变化，再决定如何合并，而不是直接使用 `git pull`。
]

=== 跟踪分支

```bash
# 设置上游分支
git branch --set-upstream-to=origin/main main

# 简写
git branch -u origin/main

# 查看跟踪关系
git branch -vv
```

==== upstream 追踪分支

`upstream` 是指向原始仓库的远程引用，常用于 fork 工作流：

```bash
# 添加上游远程仓库
git remote add upstream https://github.com/original/repo.git

# 从上游拉取最新更改
git fetch upstream

# 合并上游更改到本地分支
git merge upstream/main

# 或使用 rebase 保持线性历史
git rebase upstream/main
```

#tip[
  在开源项目中，通常 `origin` 指向你的 fork，`upstream` 指向原始仓库。定期从 upstream 同步可以保持代码最新。
]

== 高级操作

=== Stash（储藏）

临时保存工作进度，稍后恢复：

```bash
# 储藏当前修改
git stash

# 储藏并包含未跟踪的文件
git stash -u

# 带消息的储藏
git stash save "WIP: working on login feature"

# 查看所有储藏
git stash list

# 应用最近的储藏
git stash apply

# 应用并删除储藏
git stash pop

# 应用特定的储藏
git stash apply stash@{2}

# 删除储藏
git stash drop stash@{1}

# 清空所有储藏
git stash clear
```

#note[
  Stash非常适合需要临时切换分支但又不想提交未完成工作的场景。
]

=== Cherry-pick

选择性地应用某个提交到当前分支：

```bash
# 应用单个提交
git cherry-pick abc1234

# 应用多个提交
git cherry-pick abc1234 def5678

# 应用提交范围
git cherry-pick abc1234..def5678

# 应用但不自动提交
git cherry-pick --no-commit abc1234
```

#tip[
  Cherry-pick常用于将bug修复从开发分支应用到生产分支。
]

=== Reset深入

```bash
# 软重置：只移动HEAD指针
git reset --soft HEAD~1

# 混合重置：移动HEAD并重置暂存区（默认）
git reset HEAD~1

# 硬重置：移动HEAD、重置暂存区和工作区
git reset --hard HEAD~1

# 重置到特定提交
git reset --hard abc1234

# 重置特定文件
git reset HEAD file.txt
```

=== Reflog（引用日志）

记录HEAD和分支引用的变化历史，是“后悔药”：

```bash
# 查看reflog
git reflog

# 查看特定分支的reflog
git reflog show main

# 恢复到之前的状态
git reset --hard HEAD@{3}

# 恢复丢失的提交
git reset --hard abc1234
```

#caution[
  Reflog只在本地有效，默认保留90天。如果执行了 `git gc` 或超过了保留期限，可能无法恢复。
]

#tip[
  即使使用了 `git reset --hard` 或删除了分支，只要reflog还在，就有可能找回丢失的提交。
]

=== Revert（安全回退）

创建新的提交来撤销之前的修改，不会改写历史：

```bash
# 撤销某次提交
git revert <commit-hash>

# 撤销多次提交
git revert HEAD~3..HEAD

# 撤销合并提交
git revert -m 1 <merge-commit-hash>
```

#tip[
  对于已经push到远程的提交，使用 `git revert` 而非 `git reset`，避免破坏共享历史。
]

=== Bisect（二分查找Bug）

使用二分查找法定位引入 bug 的提交：

```bash
# 开始 bisect
git bisect start

# 标记当前提交为坏
git bisect bad

# 标记某个旧提交为好
git bisect good abc1234

# Git 会自动检出中间提交，测试后标记
git bisect good  # 或 git bisect bad

# 重复直到找到第一个坏提交

# 结束 bisect
git bisect reset
```

#tip[
  `git bisect` 可以自动化测试：`git bisect run npm test`，自动定位导致测试失败的提交。
]

== 标签管理

标签用于标记重要的提交点，通常用于发布版本。

=== 标签类型

==== 轻量标签（Lightweight）

只是一个指向提交的指针：

```bash
git tag v1.0.0
```

==== 附注标签（Annotated）

包含完整信息的标签对象：

```bash
git tag -a v1.0.0 -m "Release version 1.0.0"
```

#tip[
  推荐使用附注标签，因为它包含更多信息（打标签的人、日期、消息等）。
]

=== 标签操作

```bash
# 查看所有标签
git tag

# 查看匹配模式的标签
git tag -l "v1.*"

# 查看标签详情
git show v1.0.0

# 删除标签
git tag -d v1.0.0

# 推送标签到远程
git push origin v1.0.0

# 推送所有标签
git push origin --tags

# 删除远程标签
git push origin --delete v1.0.0

# 基于特定提交创建标签
git tag -a v1.0.0 abc1234 -m "Release version 1.0.0"
```

== Git工作流

=== Git Flow

经典的Git分支模型，适合有固定发布周期的项目：

*分支类型*：

- `main/master`: 生产环境代码
- `develop`: 开发主分支
- `feature/*`: 功能分支，从develop分出
- `release/*`: 发布分支，从develop分出
- `hotfix/*`: 热修复分支，从main分出

*工作流程*：

```text
1. 从develop创建feature分支
2. 在feature分支上开发
3. 完成后合并回develop
4. 从develop创建release分支进行测试
5. release完成后合并到main和develop
6. 在main上打tag
7. 如有紧急bug，从main创建hotfix分支
8. hotfix完成后合并到main和develop
```

#note[
  Git Flow适合传统软件项目，但对于持续部署的现代Web应用可能过于复杂。
]

=== GitHub Flow

更简单的分支模型，适合持续部署：

*核心原则*：

- main分支始终可部署
- 从main创建功能分支
- 频繁推送到远程
- 通过Pull Request讨论和审查
- 审查通过后合并到main
- 立即部署

*工作流程*：

```text
1. 从main创建分支
2. 提交更改
3. 打开Pull Request
4. 讨论和审查
5. 合并到main
6. 部署
```

#tip[
  GitHub Flow简单灵活，适合大多数现代软件开发项目，特别是SaaS应用。
]

=== GitLab Flow

结合Git Flow和GitHub Flow的优点：

*特点*：

- 以main为主开发分支
- 可以有环境分支（如production、staging）
- 可以有版本分支（如v1.0、v2.0）
- 变更从上游向下游流动

*适用场景*：

- 需要同时维护多个版本
- 有多个部署环境
- 需要严格的发布管理

=== Trunk-Based Development

现代持续交付推荐的工作流，强调短生命周期分支：

*核心原则*：

- 所有开发者直接向 main（trunk）提交
- 分支生命周期极短（不超过1-2天）
- 频繁集成，每天多次合并
- 使用功能开关（Feature Flags）控制新功能

*工作流程*：

```text
1. 从 main 创建短期功能分支
2. 快速开发（1-2天内完成）
3. 通过 CI/CD 自动化测试
4. 合并回 main
5. 使用 Feature Flag 控制功能可见性
6. 持续部署到生产环境
```

*优势*：

- 减少合并冲突
- 更快的反馈循环
- 简化分支管理
- 适合持续部署

#note[
  Google、Facebook 等大厂都采用 Trunk-Based Development，配合强大的 CI/CD 和 Feature Flag 系统。
]

=== 选择建议

#tex-table(
  ("工作流", "复杂度", "适用场景", "学习成本"),
  ("Git Flow", "高", "传统软件、固定发布周期", "高"),
  ("GitHub Flow", "低", "持续部署、Web应用", "低"),
  ("GitLab Flow", "中", "多版本、多环境", "中"),
)

#tip[
  小团队或新项目建议从GitHub Flow开始，随着项目复杂度增加再考虑更复杂的工作流。
]

== .gitignore配置

`.gitignore` 文件指定Git应该忽略哪些文件和目录。

=== 基本语法

```gitignore
# 注释

# 忽略所有.log文件
*.log

# 忽略node_modules目录
node_modules/

# 忽略特定文件
config/local.json

# 例外规则（不忽略important.log）
*.log
!important.log

# 忽略所有txt文件，除了readme.txt
*.txt
!readme.txt
```

=== 常用忽略规则

```gitignore
# 依赖目录
node_modules/
vendor/
__pycache__/

# 构建输出
dist/
build/
*.o
*.pyc

# 环境变量
.env
.env.local

# IDE配置
.vscode/
.idea/
*.swp
*.swo

# 操作系统文件
.DS_Store
Thumbs.db

# 日志文件
*.log
logs/

# 临时文件
tmp/
temp/
```

=== 全局.gitignore

创建全局忽略文件，对所有仓库生效：

```bash
# 创建全局gitignore
git config --global core.excludesfile ~/.gitignore_global

# 编辑文件
vim ~/.gitignore_global
```

#tip[
  将IDE配置、操作系统文件等个人偏好设置放在全局.gitignore中，避免污染项目级别的配置。
]

=== .gitignore最佳实践

- 在项目根目录放置 `.gitignore`
- 使用在线生成器（如gitignore.io）生成模板
- 定期审查和更新
- 不要忽略必要的配置文件
- 团队成员应保持一致的忽略规则

== Git钩子（Hooks）

Git钩子是脚本，在特定事件发生时自动执行。

=== 钩子类型

==== 客户端钩子

- `pre-commit`: 提交前执行
- `prepare-commit-msg`: 准备提交消息时
- `commit-msg`: 验证提交消息
- `post-commit`: 提交后执行
- `pre-push`: 推送前执行

==== 服务端钩子

- `pre-receive`: 接收推送前
- `update`: 更新引用前
- `post-receive`: 接收推送后

=== 使用示例

==== pre-commit钩子

在 `.git/hooks/pre-commit` 中：

```bash
#!/bin/bash

# 检查是否有调试代码
if grep -r "console.log" --include="*.js" .; then
    echo "Error: Found console.log statements"
    exit 1
fi

# 运行代码格式化
npm run lint

# 运行测试
npm test
```

```bash
# 使钩子可执行
chmod +x .git/hooks/pre-commit
```

#note[
  Git钩子不会被clone，需要在每个仓库中单独设置。可以使用工具如Husky（Node.js）来自动化这个过程。
]

==== commit-msg钩子

验证提交消息格式：

```bash
#!/bin/bash

commit_msg=$(cat $1)

# 检查是否符合Conventional Commits规范
if ! echo "$commit_msg" | grep -qE "^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .+"; then
    echo "Error: Commit message does not follow Conventional Commits format"
    echo "Format: <type>(<scope>): <subject>"
    exit 1
fi
```

=== Husky（推荐）

对于Node.js项目，使用Husky管理Git钩子：

```bash
# 安装Husky
npm install husky --save-dev
npx husky install

# 添加pre-commit钩子
npx husky add .husky/pre-commit "npm test"

# 添加commit-msg钩子
npx husky add .husky/commit-msg 'npx --no-install commitlint --edit "$1"'
```

#tip[
  使用Husky + lint-staged可以在提交前自动运行linter和测试，确保代码质量。
]

== 子模块与子树

当项目需要依赖其他 Git 仓库时，可以使用子模块或子树。

=== Git Submodule（子模块）

子模块允许你将一个 Git 仓库作为另一个仓库的子目录：

```bash
# 添加子模块
git submodule add https://github.com/user/lib.git libs/mylib

# 初始化子模块
git submodule init

# 更新子模块
git submodule update

# 克隆包含子模块的仓库
git clone --recursive https://github.com/user/repo.git

# 查看子模块状态
git submodule status

# 更新所有子模块到最新版本
git submodule update --remote
```

*优点*：

- 子模块独立管理，有自己的历史
- 可以锁定到特定提交
- 适合大型依赖

*缺点*：

- 操作复杂，容易出错
- 嵌套子模块难以管理
- 团队成员需要额外学习成本

#caution[
  子模块是 Git 中最容易被误解和误用的功能之一。除非必要，否则考虑使用包管理器代替。
]

=== Git Subtree（子树）

子树将外部仓库的内容合并到当前仓库中：

```bash
# 添加子树
git subtree add --prefix=libs/mylib https://github.com/user/lib.git main --squash

# 拉取子树更新
git subtree pull --prefix=libs/mylib https://github.com/user/lib.git main --squash

# 推送更改回子树
git subtree push --prefix=libs/mylib https://github.com/user/lib.git main
```

*优点*：

- 无需特殊命令，像普通文件一样操作
- 单个仓库，简化协作
- 不需要 `.gitmodules` 文件

*缺点*：

- 合并历史可能混乱
- 大仓库会导致主仓库膨胀
- 推送/拉取命令较长

=== Submodule vs Subtree

#tex-table(
  ("特性", "Submodule", "Subtree"),
  ("仓库独立性", "完全独立", "合并到主仓库"),
  ("操作复杂度", "高", "中"),
  ("学习成本", "高", "低"),
  ("适用场景", "大型依赖、第三方库", "小型依赖、共享代码"),
  ("团队协作", "需额外培训", "透明无缝"),
)

#tip[
  对于现代项目，优先使用包管理器（npm、pip、maven等）。只有在包管理器无法满足需求时，才考虑 submodule 或 subtree。
]

== 常见问题与解决方案

=== 合并冲突解决

==== 预防冲突

- 频繁pull远程更改
- 小而频繁的提交
- 清晰的沟通（谁在修改什么）
- 使用功能分支

==== 解决冲突的步骤

```bash
# 1. 查看冲突文件
git status

# 2. 打开冲突文件，手动解决冲突
# 查找 <<<<<<<, =======, >>>>>>> 标记

# 3. 标记冲突已解决
git add resolved_file.txt

# 4. 完成合并
git commit
```

==== 使用工具

```bash
# 使用内置合并工具
git mergetool

# 配置喜欢的合并工具
git config --global merge.tool meld
```

=== 修改提交历史

==== 修改最后一次提交

```bash
# 修改提交消息
git commit --amend -m "New commit message"

# 添加遗漏的文件
git add forgotten_file.txt
git commit --amend --no-edit
```

#caution[
  只修改还未push的提交！修改已push的提交会影响其他协作者。
]

==== 修改多次提交

使用交互式rebase：

```bash
git rebase -i HEAD~3
```

然后根据需要选择 `reword`、`edit`、`squash` 等操作。

=== 恢复丢失的提交

```bash
# 1. 查看reflog
git reflog

# 2. 找到丢失的提交的hash
git show abc1234

# 3. 恢复提交
git cherry-pick abc1234
# 或
git reset --hard abc1234
```

=== 清理仓库

```bash
# 删除未跟踪的文件
git clean -n  # 预览
git clean -f  # 执行

# 删除未跟踪的目录
git clean -fd

# 优化仓库
git gc

# 清理远程追踪分支
git remote prune origin
```

== Git性能优化

=== 大仓库优化

==== 浅克隆（Shallow Clone）

只克隆最近的历史，大幅减少下载时间：

```bash
# 只克隆最近的一次提交
git clone --depth 1 https://github.com/user/repo.git

# 克隆特定深度的历史
git clone --depth 50 https://github.com/user/repo.git

# 将浅克隆转换为完整克隆
git fetch --unshallow
```

#tip[
  在 CI/CD 环境中，使用 `--depth 1` 可以显著加快构建速度。
]

==== 稀疏检出（Sparse Checkout）

只检出特定的目录或文件：

```bash
# 启用稀疏检出
git clone --sparse https://github.com/user/repo.git
cd repo

# 指定要检出的目录
git sparse-checkout set src/docs

# 添加更多目录
git sparse-checkout add src/tests

# 查看当前稀疏检出配置
git sparse-checkout list
```

==== Git LFS（Large File Storage）

专门用于管理大文件（如图片、视频、二进制文件）：

```bash
# 安装 Git LFS
git lfs install

# 跟踪大文件类型
git lfs track "*.psd"
git lfs track "*.mp4"
git lfs track "models/*.bin"

# 查看跟踪的文件类型
git lfs track

# 正常 add 和 commit
git add .gitattributes
git add large_file.psd
git commit -m "Add large file with LFS"

# 推送到远程（LFS 文件会单独上传）
git push origin main

# 查看 LFS 文件状态
git lfs ls-files

# 拉取 LFS 文件
git lfs pull
```

*工作原理*：

- LFS 文件存储在单独的服务器上
- Git 仓库中只存储指针文件（几十字节）
- 克隆时快速下载指针，按需下载实际文件

#note[
  GitHub 免费账户提供 1GB LFS 存储和 1GB/月带宽。超出需要付费。
]

=== 加速Git操作

==== 启用FSMonitor

```bash
git config core.fsmonitor true
```

监视文件系统变化，加速 `git status`。

==== 使用SSD

Git操作大量涉及小文件读写，SSD能显著提升性能。

==== 增加内存缓存

```bash
git config --global core.preloadIndex true
git config --global core.unpackLimit 10000
```

=== 减小仓库大小

```bash
# 清理不必要的对象
git gc --prune=now --aggressive

# 移除大文件历史（使用git-filter-repo）
pip install git-filter-repo
git filter-repo --path large_file.bin --invert-paths
```

#caution[
  修改历史后需要强制推送，并确保团队成员知道如何处理。
]

=== 分包（Submodules）

将大型依赖作为子模块：

```bash
# 添加子模块
git submodule add https://github.com/user/lib.git libs/mylib

# 初始化子模块
git submodule init
git submodule update

# 克隆包含子模块的仓库
git clone --recursive https://github.com/user/repo.git
```

#tip[
  对于现代项目，考虑使用包管理器（npm、pip、maven等）代替submodules，更简单易用。
]

== Git最佳实践总结

=== 提交规范

- 小而频繁的提交
- 清晰的提交信息
- 一个提交只做一件事
- 遵循Conventional Commits规范

=== 分支策略

- 使用有意义的分支名
- 及时删除已合并的分支
- 定期rebase以保持历史清晰
- 不要rebase公共分支

=== 协作礼仪

- 经常push和pull
- 代码审查后再合并
- 尊重他人的工作
- 清晰的PR描述

=== 安全措施

- 使用SSH密钥而非HTTPS密码
- 启用双因素认证
- 定期备份重要仓库
- 谨慎使用force push

#fancy-divider

本章完

