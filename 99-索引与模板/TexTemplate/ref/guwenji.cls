% ----------------------------------------------------------------------
% 文件名：guwenji.cls
% 功能定位：中国古典文学合集书籍专用LaTeX文档类
% 适用场景：诗词、歌赋、楚辞、诗经、诸子百家、史书、佛经等全品类古典文本排版
% 编译要求：仅支持XeLaTeX编译器，UTF-8编码，编译后自动嵌入全部字体
% 版本：v1.0
% 定制说明：用户专属定制，可自由修改、复用
% 参考借鉴：参考elegantbook、orangebook模板的模块化设计与中文排版规范，剔除所有无关功能
% ----------------------------------------------------------------------
% 变更记录：
% v1.0 (2026/03/12) 初始版本，完整支持双栏古文注释、主题标签、全书籍结构排版
% ----------------------------------------------------------------------

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{guwenji}[2026/03/11 v1.0 Chinese Classical Literature Book Class]

% ----------------------------------------------------------------------
%   基础文档类加载：以标准 book 类为基础，传递所有未捕获选项
% ----------------------------------------------------------------------
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions\relax
\LoadClass[a4paper, oneside, 12pt]{book}
\RequirePackage{xcolor}             % 提前加载颜色系统：供全局参数模块集中定义色彩变量

% ======================================================================
%   模块一：全局可配置参数
%   所有格式参数集中于此，禁止在后续代码中硬编码具体数值
% ======================================================================

% --- 页面版心参数 ---
\def\GWJ@topmargin{2.2cm}          % 上边距，适度收紧以扩大版心
\def\GWJ@bottommargin{1.6cm}       % 下边距，重点收紧以减少页脚下方留白
\def\GWJ@innermargin{2.4cm}        % 内侧（装订侧）边距，略收紧
\def\GWJ@outermargin{1.8cm}        % 外侧边距，略收紧
\def\GWJ@headheight{14pt}          % 页眉高度，与fancyhdr配合，默认14pt
\def\GWJ@headsep{0.5cm}            % 页眉与正文间距
\def\GWJ@footskip{0.52cm}          % 正文与页脚基线间距（减小页脚下方视觉空白）

% --- 双栏比例参数（仅在guwen环境内生效）---
% 说明：左栏65% + 间距5% + 右栏30% = 100%版心宽度
\def\GWJ@leftcolratio{0.65}        % 左栏（古文原文）占版心宽度比例，默认0.65
\def\GWJ@colsepratio{0.05}         % 两栏间距占版心宽度比例，默认0.05
\def\GWJ@rightcolratio{0.30}       % 右栏（侧边栏注释）占版心宽度比例，默认0.30

% --- 字号参数（单位pt）---
\def\GWJ@mainfontsize{10.5pt}      % 古文正文（左栏原文）字号，五号=10.5pt
\def\GWJ@notefontsize{9pt}         % 侧边栏注释字号，小五号=9pt
\def\GWJ@introductfontsize{10.5pt} % 说明性文本（楷体环境）字号，五号=10.5pt
\def\GWJ@sectionauthorsize{9pt}    % section下方「朝代·作者」标注字号，小五号

% --- 色彩系统（UI美化层，参考 elegantbook 的集中配色管理思路）---
% 设计意图：在保持古典书卷气的前提下，提供统一、可维护的色彩变量。
\definecolor{clrtxt}{gray}{0.10}       % 正文主色：深墨黑（近似 gray!90）
\definecolor{clrtitle}{RGB}{0,0,0}     % 标题主色：纯黑
\definecolor{clraccent}{RGB}{140,32,24} % 点缀色：朱红/赭石（强调、链接、装饰）
\definecolor{clrbg}{gray}{0.95}        % 背景色：旧纸浅色（近似 gray!5）
\definecolor{clrborder}{gray}{0.80}    % 边框色：浅灰（近似 gray!20）
\definecolor{clrinfo}{RGB}{70,130,180} % 信息提示色：钢蓝（用于篇目概述盒子）

% 兼容旧命名（不改核心逻辑，避免影响既有宏调用）
\colorlet{GWJprimary}{clrtitle}
\colorlet{GWJlink}{clraccent}
\colorlet{GWJtagbg}{clrborder}
\colorlet{GWJintrobg}{clrbg}

% ======================================================================
%   模块二：宏包加载
%   所有依赖宏包均在此集中加载，用户无需在tex文件中另行加载
% ======================================================================

\RequirePackage{fontspec}           % XeLaTeX字体加载核心，支持OTF/TTF字体
\RequirePackage{xeCJK}              % 中文排版，提供中文字体分组、标点禁则与断行
\RequirePackage{geometry}           % 控制页边距与版心尺寸
\RequirePackage{titlesec}           % 重定义\part/\chapter/\section/\subsection样式
\RequirePackage{tocloft}            % 精细控制目录各层级样式、缩进与引导点
\RequirePackage{titletoc}           % 目录条目视觉编排（参考 elegantbook copy）
\RequirePackage{indentfirst}        % 章节标题后首段也缩进（用于“序”等开篇段落）
\RequirePackage{fancyhdr}           % 自定义页眉页脚，实现奇偶页差异化排版
\RequirePackage{emptypage}          % 章节间自动补全的空白页不显示页眉页脚
\RequirePackage{hyperref}           % 生成PDF内部超链接，支持目录跳转与交叉引用
\RequirePackage{bookmark}           % 增强PDF书签功能，与hyperref配合使用
\RequirePackage{graphicx}           % 支持插图命令\includegraphics
\RequirePackage{tikz}              % 参考 elegant copy 的 Part 页面背景绘制
\usetikzlibrary{chains,calc}
\newif\ifGWJ@pgfornamenthan
\IfFileExists{pgfornament-han.sty}{%
  \RequirePackage{pgfornament-han}%
  \GWJ@pgfornamenthantrue
}{%
  \GWJ@pgfornamenthanfalse
  \ClassWarning{guwenji}{pgfornament-han.sty not found; page ornaments disabled}%
}
\RequirePackage[many]{tcolorbox}    % 提供圆角彩色背景框，用于标签与作者介绍
\RequirePackage{lettrine}           % 首字下沉支持：用于 partintro/chapterintro 的书卷风首字
\RequirePackage{amsmath}            % 数学公式支持，古文年份推算等偶发场景使用
\RequirePackage[toc]{appendix}      % 附录支持，toc选项自动将附录纳入目录
\RequirePackage{paracol}            % 左右平行双栏宏包，用于guwen环境双栏排版
\RequirePackage{enumitem}           % 灵活定制列表环境间距
\RequirePackage{etoolbox}           % 提供\patchcmd、\apptocmd、\docsvlist等工具
\RequirePackage{calc}               % 长度运算，用于动态计算栏宽
\RequirePackage{xparse}             % 提供\NewDocumentCommand，支持复杂参数语法
\RequirePackage{zhnumber}  % 提供 \zhnumber 命令，将阿拉伯数字转换为中文大写数字（1→一，2→二，...） 

% 页面几何参数应用（统一由模块一变量驱动）
\geometry{
  top        = \GWJ@topmargin,
  bottom     = \GWJ@bottommargin,
  inner      = \GWJ@innermargin,
  outer      = \GWJ@outermargin,
  headheight = \GWJ@headheight,
  headsep    = \GWJ@headsep,
  footskip   = \GWJ@footskip
}

% ======================================================================
%   模块三：字体配置（思源系列字体，生僻字全覆盖）
% ======================================================================
%

% --- CJK 主字体（宋体正文）---
\setCJKmainfont[
  BoldFont   = {FangSong},
  ItalicFont = {FangSong}
]{TW-Sung}  

% --- CJK 无衬线字体（黑体标题）---
% 若已安装思源黑体，替换为：
%   \setCJKsansfont[BoldFont={Source Han Sans SC Bold}]{Source Han Sans SC}
\setCJKsansfont[
  BoldFont = {SimHei}
]{SimHei}

% --- CJK 等宽字体（兜底）---
\setCJKmonofont{DengXian}

% --- 楷体字族（说明性文本、注释、emph/textit强调）---
\setCJKfamilyfont{kaiti}{KaiTi}

% --- 字体快捷切换命令 ---
\newcommand{\kaiti}{\CJKfamily{kaiti}}      % \kaiti 切换至楷体字族

% --- 重定义强调命令（符合中文古文排版规范）---
% \textit / \emph：替换为楷体，避免西文斜体破坏中文书卷风格
\renewcommand{\textit}[1]{{\kaiti #1}}
\renewcommand{\emph}[1]{{\kaiti #1}}

% --- 西文字体（古文排版以中文为主，西文仅作兜底）---
\setmainfont{Merriweather}               % 开源Times近似字体
\setsansfont{Microsoft YaHei}                % 开源Helvetica近似字体
% ======================================================================

\hypersetup{
  colorlinks        = true,
  linkcolor         = clraccent,    % 内部链接（目录项、交叉引用）
  urlcolor          = clraccent,    % URL链接
  citecolor         = clraccent,    % 文献引用
  pdfborder         = {0 0 0},      % 关闭链接边框/下划线风格
  pdfencoding       = auto,
  pdftitle          = {},
  pdfauthor         = {},
  pdfcreator        = {XeLaTeX + guwenji.cls v1.0},
  bookmarksopen     = true,
  bookmarksnumbered = true
}

\bookmarksetup{
  open     = true,
  numbered = true
}

% ======================================================================
%   模块七：xeCJK 中文排版规范配置
% ======================================================================

% 全角标点处理：自动挤压连续全角标点间的多余空白，防止行首行尾多余间距
\xeCJKsetup{
  PunctStyle    = quanjiao,  % 全角标点风格，防止标点堆叠或行首出现右标点
  CheckSingle   = true,      % 禁止单汉字孤立于行末
  AutoFakeBold  = false,     % 禁用伪粗体（已设置Bold字体变体）
  AutoFakeSlant = false       % 禁用伪斜体
}

% 中文断行规则（防止英文断行算法导致中文排版溢出）
\XeTeXlinebreaklocale "zh"
\XeTeXlinebreakskip = 0pt plus 1pt

% ======================================================================
%   模块八：标题层级样式
% ======================================================================

% --- \part：时代大分部标题 ---
% 规格：参考 elegant copy 的 display 风格，使用整页浅底背景块与居中大标题
% 特殊：\part 页使用 partpage 样式（无页眉无页码），通过模块二十的补丁实现

\renewcommand{\partname}{\color{clrtitle}}
\renewcommand{\thepart}{第\zhnumber{\arabic{part}}部分}

% \part 页面垂直位置控制：调这个长度可整体移动「部分编号 + 标题」
\newlength{\GWJ@partblockvshift}
\setlength{\GWJ@partblockvshift}{9cm}

\titleformat{\part}[display]
  {\thispagestyle{partpage}\centering\normalfont\Huge\bfseries\color{clrtitle}}
  {%
    \begin{tikzpicture}[remember picture,overlay]
      \node[anchor=center,rectangle,fill=clraccent!15,fill opacity=0.9,
            minimum height=0.35\paperheight,minimum width=\paperwidth]
      at (current page.center) {};
    \end{tikzpicture}%
  }
  {3pt}
  {
    \vspace*{\GWJ@partblockvshift}%
    {\fontsize{22}{26}\selectfont\color{clrtitle}\partname~\thepart\\[0.25em]}%
    \vspace*{13pt}
    \fontsize{32}{38}\selectfont\color{clrtitle}
  }
  [\newpage]

\titlespacing*{\part}{0pt}{0pt}{0pt}

% --- \chapter：文体/主题章节标题 ---
% 规格：三号黑体加粗居中，深蓝色，下方短横线装饰，上下间距各2em
% 特殊：章节开篇页通过 \patchcmd 替换为 chapterpage 样式（仅页脚页码）


\titleformat{\chapter}[display]
  {\normalfont\sffamily\bfseries\Large\centering\color{clrtitle}}
  {\sffamily\normalsize\bfseries\chaptername\;\thechapter}
  {0.6em}{}
  [\vspace{0.2em}%
   {\centering\color{clrtitle}\rule{0.5\textwidth}{0.5pt}}%
   \vspace{0em}]

\titlespacing*{\chapter}{0pt}{2em}{2em}   % 上间距2em，下间距2em

% --- \section：单篇篇目标题 ---
% 规格：四号黑体左对齐，左边朱红圆角粗竖线
\titleformat{\section}[block]
  {\normalfont\sffamily\bfseries\fontsize{14pt}{20pt}\selectfont\color{black}}
  {}
  {0pt}
  {\tikz[baseline=0.35ex]\draw[clraccent, line width=3.5pt, line cap=round]
  (0,0) -- (0,1em);\hspace{10pt}}

\titlespacing*{\section}{0pt}{1em}{0.4em}   % 上间距1em，下间距0.4em

% --- \subsection：篇目内小节标题 ---
% 规格：小四号黑体居中，无编号显示；下方「朝代·作者」通过\subsectionauthor命令输出
\titleformat{\subsection}[block]
  {\normalfont\sffamily\bfseries\fontsize{12pt}{16pt}\selectfont%
   \centering\color{black}}
  {}
  {0pt}
  {}

\titlespacing*{\subsection}{0pt}{0.8em}{0.4em}

% --- \subsubsection：第四级标题（备用）---
\titleformat{\subsubsection}[block]
  {\normalfont\sffamily\bfseries\normalsize\fontsize{10pt}{14pt}\color{black}}
  {}
  {0pt}
  {\hspace{2em}}

\titlespacing*{\subsubsection}{0pt}{0.5em}{0.3em}

% ======================================================================
%   附录标题格式
%   说明：\appendix 之后，\chapter 自动显示为「附录X 标题名」（X为中文大写）
% ======================================================================

\newcounter{GWJ@appendixcnt}         % 附录序号计数器
\newif\ifGWJ@inappendix               % 附录模式开关
\GWJ@inappendixfalse

% 中文大写数字映射命令（参数为阿拉伯数字，支持1-10）
\newcommand{\GWJ@getappendixname}[1]{%
  \ifnum#1=1 一\else
  \ifnum#1=2 二\else
  \ifnum#1=3 三\else
  \ifnum#1=4 四\else
  \ifnum#1=5 五\else
  \ifnum#1=6 六\else
  \ifnum#1=7 七\else
  \ifnum#1=8 八\else
  \ifnum#1=9 九\else
  \ifnum#1=10 十\else ?\fi\fi\fi\fi\fi\fi\fi\fi\fi\fi%
}

% 重定义 \appendix：切换附录模式，并修改 \chapter 的 titleformat
\let\GWJ@oldappendix\appendix
\renewcommand{\appendix}{%
  \GWJ@oldappendix
  \GWJ@inappendixtrue
  \setcounter{GWJ@appendixcnt}{0}
  % 附录章节格式：标号行显示「附录X」（X在每个\chapter前递增）
  \titleformat{\chapter}[display]
    {\normalfont\sffamily\bfseries\Large\centering\color{GWJprimary}}
    {\sffamily\normalsize\bfseries 附录\GWJ@getappendixname{\arabic{GWJ@appendixcnt}}}
    {0.6em}{}
    [\vspace{0.2em}%
      {\centering\color{clrtitle}\rule{0.5\textwidth}{0.5pt}}]
  \titlespacing*{\chapter}{0pt}{2em}{2em}
  % 每个 \chapter 触发前递增附录序号
  \pretocmd{\chapter}{\stepcounter{GWJ@appendixcnt}}{}{}
}

% ======================================================================
%   模块九：页眉页脚规范（fancyhdr）
% ======================================================================

% 书名缓存（由 \booktitle 命令填充，用于正文偶数页页眉）
\newcommand{\GWJ@booktitle}{}
% 页码位置微调入口（手动调节只改这里）：
% - 第一个参数（\hspace*）负值越大越靠左
% - 第二个参数（\raisebox）负值越大越靠下
\newcommand{\GWJ@pageformat}{\hspace*{-16pt}\raisebox{-4pt}{\sffamily\small\thepage}}
\newsavebox{\GWJ@ornamenttile}
\newcount\GWJ@suppressornamentpages
\GWJ@suppressornamentpages=0
\newif\ifGWJ@ornamentenabled
\GWJ@ornamentenabledfalse
\newif\ifGWJ@suspendornament
\GWJ@suspendornamentfalse

\AtBeginDocument{%
  \ifGWJ@pgfornamenthan
    \savebox{\GWJ@ornamenttile}{\pgfornamenthan[scale=0.2,color=clrborder]{47}}%
  \fi
}

\newcommand{\GWJ@mainpageornament}{%
  \ifGWJ@pgfornamenthan
    \begin{tikzpicture}[overlay,remember picture]
      \tikzset{every node/.append style={inner sep=0pt,color=clrborder}}%
      \node[anchor=north west,shift={(14.5pt,-14.5pt)}] at (current page.north west) (nw) {\pgfornamenthan[scale=0.2]{25}};
      \node[anchor=north east,shift={(-14.5pt,-14.5pt)}] at (current page.north east) (ne) {\pgfornamenthan[scale=0.2,symmetry=v]{25}};
      \node[anchor=south west,shift={(14.5pt,14.5pt)}] at (current page.south west) (sw) {\pgfornamenthan[scale=0.2,symmetry=h]{25}};
      \node[anchor=south east,shift={(-14.5pt,14.5pt)}] at (current page.south east) (se) {\pgfornamenthan[scale=0.2,symmetry=c]{25}};

      \begin{scope}[start chain,node distance=0pt]
        \node[anchor=north west,on chain] at (nw.north east) {\usebox{\GWJ@ornamenttile}};
        \foreach \i in {1,...,15} {\node[on chain]{\usebox{\GWJ@ornamenttile}};}
      \end{scope}

      \begin{scope}[start chain,node distance=0pt]
        \node[anchor=south west,on chain] at (sw.south east) {\usebox{\GWJ@ornamenttile}};
        \foreach \i in {1,...,6} {\node[on chain]{\usebox{\GWJ@ornamenttile}};}
      \end{scope}

      \begin{scope}[start chain=going left,node distance=0pt]
        \node[anchor=south east,on chain] at (se.south west) {\usebox{\GWJ@ornamenttile}};
        \foreach \i in {1,...,6} {\node[on chain]{\usebox{\GWJ@ornamenttile}};}
      \end{scope}

      \foreach \i in {0,...,21} {
        \node[anchor=south west,rotate=-90,shift={(\i*31bp,0)}] at (nw.south west) {\usebox{\GWJ@ornamenttile}};
      }
      \foreach \i in {0,...,21} {
        \node[anchor=south east,rotate=90,shift={(-\i*31bp,0)}] at (ne.south east) {\usebox{\GWJ@ornamenttile}};
      }

      % 底部中心纹样位置微调入口（调这里可让纹样与页码更对齐）
      \node[yshift=30pt,color=clraccent] at (current page.south) {\pgfornamenthan[scale=0.1]{51}};
    \end{tikzpicture}%
  \fi
}

\AddToHook{shipout/background}{%
  \ifGWJ@pgfornamenthan
    \ifGWJ@ornamentenabled
      \ifGWJ@suspendornament
      \else
        \ifnum\GWJ@suppressornamentpages>0
          \global\advance\GWJ@suppressornamentpages by -1\relax
        \else
          \GWJ@mainpageornament
        \fi
      \fi
    \fi
  \fi
}

\pagestyle{fancy}
\fancyhf{}   % 清空所有默认页眉页脚

% 正文主样式（单面印刷模式）
% 右侧页眉：当前章节名（由 \chaptermark 更新）
% 左侧页眉：书名（由 \booktitle 命令填充）
\fancyhead[R]{\sffamily\small\color{GWJprimary}\rightmark}
\fancyhead[L]{\sffamily\small\color{GWJprimary}\GWJ@booktitle}
\fancyfoot[C]{\GWJ@pageformat}         % 页脚居中，阿拉伯数字页码
\renewcommand{\headrulewidth}{0.4pt}             % 页眉横线0.4pt细线
\renewcommand{\footrulewidth}{0pt}               % 无页脚横线

% 页眉内容更新规则
\renewcommand{\chaptermark}[1]{\markright{\thechapter\quad #1}}
\renewcommand{\sectionmark}[1]{}                 % section不更新页眉

% 正文章节首页不绘制底纹：在内部标题构建阶段恢复开关并跳过当前标题页
\pretocmd{\@chapter}{\global\GWJ@suspendornamentfalse\global\GWJ@suppressornamentpages=1}{}{}
\pretocmd{\@schapter}{\global\GWJ@suspendornamentfalse\global\GWJ@suppressornamentpages=1}{}{}
\pretocmd{\part}{\global\GWJ@suspendornamenttrue}{}{}
\pretocmd{\@part}{\global\GWJ@suspendornamenttrue\global\GWJ@suppressornamentpages=1}{}{}
\pretocmd{\@spart}{\global\GWJ@suspendornamenttrue\global\GWJ@suppressornamentpages=1}{}{}

% 章节开篇页样式（仅保留页脚页码，隐藏页眉与分隔线）
\fancypagestyle{chapterpage}{%
  \fancyhf{}
  \fancyfoot[C]{\GWJ@pageformat}
  \renewcommand{\headrulewidth}{0pt}
}

% 前置部分页面样式（目录等前置内容：无页眉，罗马数字页码）
\fancypagestyle{frontpagestyle}{%
  \fancyhf{}
  \fancyfoot[C]{\GWJ@pageformat}   % 页码样式由\frontmatter控制
  \renewcommand{\headrulewidth}{0pt}
}

% plain样式覆盖（\chapter默认触发plain，统一为有页码无页眉）
\fancypagestyle{plain}{%
  \fancyhf{}
  \fancyfoot[C]{\GWJ@pageformat}
  \renewcommand{\headrulewidth}{0pt}
}

% 分部页样式（\part页：无页眉，无页码）
\fancypagestyle{partpage}{%
  \fancyhf{}
  \renewcommand{\headrulewidth}{0pt}
}

% \frontmatter 自动切换至前置页样式（罗马数字页码）
\let\GWJ@oldfrontmatter\frontmatter
\renewcommand{\frontmatter}{%
  \GWJ@oldfrontmatter
  \global\GWJ@ornamentenabledfalse
  \global\GWJ@suspendornamentfalse
  \pagenumbering{Roman}%
  \pagestyle{frontpagestyle}
}

% \mainmatter 切回正文主样式（阿拉伯数字页码从1重新计数）
\let\GWJ@oldmainmatter\mainmatter
\renewcommand{\mainmatter}{%
  \GWJ@oldmainmatter
  \global\GWJ@ornamentenabledtrue
  \global\GWJ@suspendornamentfalse
  \pagenumbering{arabic}%
  \pagestyle{fancy}
}

% ======================================================================
%   模块十：目录样式（参考 elegantbook copy / OrangeBook）
% ======================================================================

% 目录标题
\renewcommand{\contentsname}{目\quad 录}

% 覆盖目录命令：保持目录页整体更接近参考模板风格
\renewcommand\tableofcontents{%
  \hypersetup{linktoc=all, linkcolor=clrtitle}%
  \if@twocolumn
    \@restonecoltrue\onecolumn
  \else
    \@restonecolfalse
  \fi
  \chapter*{\contentsname\@mkboth{\contentsname}{\contentsname}}%
  \@starttoc{toc}%
  \if@restonecol\twocolumn\fi
  \hypersetup{linkcolor=clraccent}%
}

% titletoc 编排（直接参考 elegantbook copy，并按 guwenji 配色微调）
\contentsmargin{0cm}

\newcommand{\GWJ@tocentrypartnumbered}[1]{%
  \setlength\fboxsep{0pt}%
  \contentslabel[%
    \colorbox{clrborder!55}{%
      \strut\parbox[c][.7cm]{1.1cm}{%
        \color{clrtitle}\Large\bfseries\centering\thecontentslabel%
      }%
    }%
    \hspace{4pt}%
    \colorbox{clrbg}{%
      \strut\parbox[c][.7cm]{\dimexpr\linewidth-1.25cm\relax}{%
        \centering\Large\bfseries\color{clrtitle}#1%
      }%
    }%
  ]{1.25cm}%
}

\newcommand{\GWJ@tocentrypartunnumbered}[1]{%
  \setlength\fboxsep{0pt}%
  \contentslabel[%
    \colorbox{clrbg}{%
      \strut\parbox[c][.7cm]{\linewidth}{%
        \centering\Large\bfseries\color{clrtitle}#1%
      }%
    }%
  ]{1.25cm}%
}

\titlecontents{part}
  [1.25cm]
  {\addvspace{20pt}\Large\bfseries\hypersetup{linkcolor=clrtitle}}
  {\GWJ@tocentrypartnumbered}
  {\GWJ@tocentrypartunnumbered}
  {}
  []

\titlecontents{chapter}
  [1.25cm]
  {\addvspace{12pt}\large\bfseries\hypersetup{linkcolor=clraccent}}
  {\color{clraccent}\contentslabel[\Large\thecontentslabel]{1.25cm}}
  {}
  {\color{clrborder}\normalsize\;\titlerule*[6pt]{.}\;\color{clraccent}\thecontentspage}
  []

\titlecontents{section}
  [1.25cm]
  {\addvspace{3pt}\small\color{clrtxt}}
  {\contentslabel[\thecontentslabel]{1.25cm}}
  {}
  {~{\normalfont\color{clrborder}\titlerule*[6pt]{.}}~\color{clraccent}\thecontentspage}
  []

\titlecontents{subsection}
  [1.75cm]
  {\addvspace{1pt}\footnotesize\color{clrtxt}}
  {\contentslabel[\thecontentslabel]{1.75cm}}
  {}
  {~{\normalfont\color{clrborder}\titlerule*[6pt]{.}}~\color{clraccent}\thecontentspage}
  []

% 目录显示深度：显示到 section 层级
\setcounter{tocdepth}{2}
\setcounter{secnumdepth}{3}

% ======================================================================
%   模块十一：书籍元信息与封面命令
% ======================================================================

% --- 内部存储变量（由对应用户命令填充）---
\newcommand{\GWJ@subtitle}{}     % 副标题内容
\newcommand{\GWJ@editor}{}       % 编者信息
\newcommand{\GWJ@pressinfo}{}    % 出版信息
\newif\ifGWJ@covermade            % 封面是否已生成：避免扉页与封面视觉重复
\GWJ@covermadefalse

% --- \booktitle：设置书名 ---
% 用法：\booktitle{中国古典文学精粹}
% 说明：同步更新PDF标题元信息与页眉书名缓存
\NewDocumentCommand{\booktitle}{ m }{%
  \renewcommand{\GWJ@booktitle}{#1}%
  \hypersetup{pdftitle={#1}}%
  \title{#1}%
}

% --- \booksubtitle：设置副标题 ---
% 用法：\booksubtitle{历朝历代经典文选}
\NewDocumentCommand{\booksubtitle}{ m }{%
  \renewcommand{\GWJ@subtitle}{#1}%
}

% --- \editor：设置编者信息 ---
% 用法：\editor{张三 编著}
\NewDocumentCommand{\editor}{ m }{%
  \renewcommand{\GWJ@editor}{#1}%
  \author{#1}%
}

% --- \pressinfo：设置出版信息 ---
% 用法：\pressinfo{某某出版社\quad 2026年3月}
\NewDocumentCommand{\pressinfo}{ m }{%
  \renewcommand{\GWJ@pressinfo}{#1}%
}

% --- \makecover：生成规范封面 ---
% 用法：\makecover
% 封面布局：书名（26pt黑体加粗居中）+ 副标题（楷体居中）+ 编者/出版信息（底部居中）
% 特殊：封面不计入页码（setcounter{page}{0}）
\NewDocumentCommand{\makecover}{}{%
  \ifGWJ@covermade
    \ClassWarning{guwenji}{\string\makecover\space called more than once; duplicate cover page suppressed}%
  \else
    \global\GWJ@covermadetrue
    \begin{titlepage}
      \thispagestyle{empty}
      \setcounter{page}{0}
      \begin{center}
        \vspace*{3.5cm}
        % 书名
        {\sffamily\bfseries\fontsize{26pt}{36pt}\selectfont\color{GWJprimary}%
          \GWJ@booktitle\par}
        \vspace{1.5em}
        % 装饰横线
        {\color{GWJprimary}\rule{0.5\textwidth}{0.8pt}}\par
        \vspace{1.5em}
        % 副标题（若存在）
        \ifx\GWJ@subtitle\empty\relax\else
          {\kaiti\fontsize{16pt}{24pt}\selectfont\GWJ@subtitle\par}%
        \fi
        \vfill
        % 编者（若存在）
        \ifx\GWJ@editor\empty\relax\else
          {\kaiti\fontsize{12pt}{18pt}\selectfont\GWJ@editor\par}%
          \vspace{1em}%
        \fi
        % 出版信息（若存在）
        \ifx\GWJ@pressinfo\empty\relax\else
          {\fontsize{9pt}{14pt}\selectfont\GWJ@pressinfo\par}%
        \fi
        \vspace{2cm}
      \end{center}
    \end{titlepage}
    \clearpage
  \fi
}

% --- \maketitlepage：生成正式扉页 ---
% 用法：\maketitlepage
% 说明：调用于\makecover之后，生成内封（与封面明确区分，避免“重复封面”观感）
\NewDocumentCommand{\maketitlepage}{}{%
  % 若已生成封面，则默认不再输出扉页，避免“封面出现两次”的观感
  \ifGWJ@covermade
    \ClassWarning{guwenji}{\string\maketitlepage\space suppressed because \string\makecover\space has already been used}%
  \else
    \begin{titlepage}
      \thispagestyle{empty}
      \begin{center}
        \vspace*{3.2cm}
        {\sffamily\bfseries\fontsize{22pt}{30pt}\selectfont\color{clrtitle}%
          \GWJ@booktitle\par}
        \vspace{1.0em}
        {\color{clraccent}\rule{0.35\textwidth}{0.6pt}}\par
        \vspace{1.0em}
        \ifx\GWJ@subtitle\empty\relax\else
          {\kaiti\fontsize{14pt}{22pt}\selectfont\color{clrtxt}\GWJ@subtitle\par}%
        \fi
        \vfill
        \ifx\GWJ@editor\empty\relax\else
          {\kaiti\fontsize{11pt}{17pt}\selectfont\color{clrtxt}\GWJ@editor\par}%
          \vspace{0.8em}%
        \fi
        \ifx\GWJ@pressinfo\empty\relax\else
          {\fontsize{9pt}{14pt}\selectfont\color{clrtxt}\GWJ@pressinfo\par}%
        \fi
        \vspace{1.6cm}
      \end{center}
    \end{titlepage}
    \clearpage
  \fi
}

% ======================================================================
%   模块十二：说明性文本环境（均为单栏，楷体）
% ======================================================================

% 统一盒子样式（参考 elegantbook 的 fancy 盒子：标题贴边 + 轻背景 + 可断页）
\tcbset{
  GWJ/fancycommon/.style={
    enhanced,
    breakable,
    fontupper=\kaiti,
    coltitle=white,
    colback=clrbg,
    boxrule=0.5pt,
    fonttitle=\bfseries,
    top=8pt,
    before skip=8pt,
    attach boxed title to top left={yshift=-0.11in,xshift=0.15in},
    boxed title style={
      boxrule=0pt,
      colframe=white,
      arc=0pt,
      outer arc=0pt
    }
  },
  GWJ/authorintro/.style={
    GWJ/fancycommon,
    colframe=clraccent,
    colback=clraccent!5,
    colbacktitle=clraccent,
    left=1em,right=1em,top=1em,bottom=1em,
    before upper={\setlength{\parindent}{0pt}}% 作者介绍：不缩进
  },
  GWJ/articleoverview/.style={
    GWJ/fancycommon,
    colframe=clrinfo,
    colback=clrinfo!5,
    colbacktitle=clrinfo,
    left=1em,right=1em,top=0.8em,bottom=0.8em,
    before upper={\setlength{\parindent}{0pt}}% 篇目概述：不缩进
  },
  GWJ/appendixbox/.style={
    GWJ/fancycommon,
    colframe=clrborder,
    colback=clrbg,
    colbacktitle=clrborder,
    left=1em,right=1em,top=0.8em,bottom=0.8em,
    before upper={\setlength{\parindent}{2em}}
  }
}

% 首字下沉辅助命令：用于 partintro/chapterintro 开头的视觉点缀
% 用法：\begin{partintro}\GWJdropcap{先}秦是...\end{partintro}
\NewDocumentCommand{\GWJdropcap}{m}{%
  \lettrine[lines=3,lhang=0.15,loversize=0.15,findent=0.3em]{\textcolor{clraccent}{#1}}{}%
}

% --- partintro：分部综述环境 ---
% 功能：用于\part之后，描述该时代分部的文学发展脉络与时代背景
% 用法：\begin{partintro}\GWJdropcap{先}秦是...\end{partintro}
% 样式：单栏，小四号楷体，首行缩进2字，段间距1em
\newenvironment{partintro}{%
  \global\GWJ@suspendornamenttrue
  \begingroup
  \setlength{\parindent}{2em}%
  \setlength{\parskip}{1em}%
  % \setlength{\leftskip}{0pt}%
  % \setlength{\rightskip}{0pt}%
  \kaiti\fontsize{12pt}{18pt}\selectfont
  \par\indent\ignorespaces
}{%
  \par\endgroup
  \vspace{1em}%
}

% --- chapterintro：章节简介环境 ---
% 功能：用于\chapter之后，介绍该文体/主题的起源、发展与艺术特点
% 用法：\begin{chapterintro}\GWJdropcap{诗}经是...\end{chapterintro}
% 样式：单栏，五号楷体，首行缩进2字，段间距0.8em
\newenvironment{chapterintro}{%
  \begingroup
  \ifGWJ@inappendix
    % 附录态：使用浅旧纸底色 + 细边框 + 轻阴影，形成与正文区隔
    \begin{tcolorbox}[GWJ/appendixbox,title={附录导读}]
  \fi
  \setlength{\parindent}{2em}%
  \setlength{\parskip}{0.8em}%
  \setlength{\leftskip}{0pt}%
  \setlength{\rightskip}{0pt}%
  \kaiti\fontsize{\GWJ@introductfontsize}{16pt}\selectfont
  \par\indent\ignorespaces
}{%
  \ifGWJ@inappendix
    \end{tcolorbox}
  \fi
  \par\endgroup
  \vspace{0.8em}%
}

% --- authorintro：作者介绍环境 ---
% 功能：用于\biaoqian之后、\begin{guwen}之前，书写作者生平、时代与文学地位
% 用法：\begin{authorintro} 作者介绍正文 \end{authorintro}
% 样式：单栏，小五号楷体，朱红背景框，不缩进
\newenvironment{authorintro}{%
  \begin{tcolorbox}[GWJ/authorintro,title={作者介绍}]%
  \kaiti\fontsize{\GWJ@notefontsize}{14pt}\selectfont
}{%
  \end{tcolorbox}%
  \vspace{0.4em}%
}

% --- articleoverview：篇目概述环境 ---
% 功能：用于\authorintro之后、古文环境之前，介绍创作背景、主旨思想与文学价值
% 用法：\begin{articleoverview} 概述正文 \end{articleoverview}
% 样式：单栏，小五号楷体，钢蓝背景fancy盒子，不缩进
\newenvironment{articleoverview}{%
  \begin{tcolorbox}[GWJ/articleoverview,title={篇目概述}]%
  \kaiti\fontsize{\GWJ@notefontsize}{14pt}\selectfont
}{%
  \end{tcolorbox}%
  \vspace{0.4em}%
}


% ======================================================================
%   模块十三：篇目标注命令
% ======================================================================

% --- \subsectionauthor：subsection标题下方「朝代·作者」标注 ---
% 功能：在小节标题（\subsection）下方输出居中的「〔朝代〕作者名」信息
% 用法：\subsectionauthor{唐}{杜甫}   →   输出「〔唐〕杜甫」居中显示
% 参数：#1 = 朝代名；#2 = 作者名
\NewDocumentCommand{\subsectionauthor}{ m m }{%
  \begin{center}
    {\kaiti\fontsize{\GWJ@sectionauthorsize}{13pt}\selectfont
     \textcolor{clraccent}{〔#1〕}\,#2}%
  \end{center}%
  \vspace{0.3em}%
}

% ======================================================================
%   模块十四：主题标签命令（\biaoqian）
% ======================================================================

% 内部：单个标签渲染辅助命令
% 功能：输出一个带浅灰圆角背景的标签盒子
% 用法：\GWJ@rendertag{思乡}
\newcommand{\GWJ@rendertag}[1]{%
  \tcbox[%
    colback   = clrborder,%
    colframe  = clrborder,%
    coltext   = clrtxt,%
    arc       = 2pt,%
    boxrule   = 0pt,%
    left=0.5em, right=0.5em, top=0.1em, bottom=0.1em,%
    on line,%
    fontupper = {\sffamily\fontsize{\GWJ@notefontsize}{13pt}\selectfont}%
  ]{#1}%
}

% --- \biaoqian：主题标签组命令 ---
% 功能：在篇目下方输出多个主题标签，帮助读者快速把握篇目主旨
% 用法：\biaoqian{思乡,写景,咏史}   （英文逗号分隔，支持无限个标签）
% 样式：小五号黑体，浅灰圆角背景，各标签之间留0.3em间距，整体居中对齐
\NewDocumentCommand{\biaoqian}{ m }{%
  \begin{center}
    \renewcommand{\do}[1]{\GWJ@rendertag{##1}\hspace{0.3em}}%
    \docsvlist{#1}%
  \end{center}%
  \vspace{0.3em}%
}

% ======================================================================
%   模块十五：附录跳转引用命令（\csyl）
% ======================================================================

% --- \csyl：附录内容超链接跳转命令 ---
% 功能：在注释或正文中插入可点击的超链接，点击后跳转至附录对应位置
% 用法：\csyl{app:guanzhi}{官职制度}
%         #1：目标 \label 标签名（须在附录中用 \label 事先定义）
%         #2：在当前位置显示的超链接文本
% 样式：深蓝色，无下划线，点击后跳转至附录对应段落
\NewDocumentCommand{\csyl}{ m m }{%
  \hyperref[#1]{{\color{clraccent}#2}}%
}

% ======================================================================
%   模块十六：带圈注释序号辅助命令
% ======================================================================

% --- \GWJcircnum：输出第n个带圈数字（兼容保留） ---
% 功能：保留旧接口兼容；当前 guwen 正文不再显示圆圈注号
% 用法：\GWJcircnum{3}  →  ③
% 参数：n = 1..20（整数）；超出范围时输出「(n)」
\newcommand{\GWJcircnum}[1]{%
  \ifcase#1%
    \or①\or②\or③\or④\or⑤%
    \or⑥\or⑦\or⑧\or⑨\or⑩%
    \or⑪\or⑫\or⑬\or⑭\or⑮%
    \or⑯\or⑰\or⑱\or⑲\or⑳%
    \else(#1)\fi%
}

% ======================================================================
%   模块十七：古文双栏核心环境（guwen）与注释系统
%
%   实现方式：使用 paracol 宏包实现左右平行双栏排版
%   左栏容纳古文原文（占70%版心宽），右栏容纳对应注释（占25%版心宽）
%
%   注释工作流：
%     1. 在左栏原文段落后使用 \zs{注释文字} 标注
%        → 注释进入队列，不在原文中插入编号或关键字
%     2. 调用 \switchcolumn 切换到右栏
%     3. 在右栏调用 \zwz 渲染当前队列中所有注释（输出后自动清空队列）
%     4. 长文可多次 \switchcolumn + \zwz 分段对照
%
%   典型用法：
%     \begin{guwen}
%       关关雎鸠，在河之洲。\\
%       窈窕淑女，君子好逑。
%       \zs{雎鸠：水鸟名，雌雄形影不离，古人以其象征忠贞爱情。}
%       \switchcolumn
%       \zwz
%     \end{guwen}
% ======================================================================

% --- 注释内容队列（全局宏文本堆叠）---
\newcommand{\GWJ@noteslist}{}     % 当前待输出的注释内容（宏文本模式）

% 清空注释队列（在每次进入新的guwen环境时调用）
\newcommand{\GWJ@clearnotes}{%
  \global\def\GWJ@noteslist{}%
}

% 追加单条注释到队列（由\zs内部调用）
% #1 = 注释文字
% 右栏注释排版微调入口：字号/行距/颜色/条目间距都在此处
\newcommand{\GWJ@appendnote}[1]{%
  \g@addto@macro\GWJ@noteslist{%
    \noindent{\kaiti\fontsize{8.5pt}{8.5pt}\selectfont\color{clrtxt}
      #1}\par\vspace{0em}%
  }%
}

% --- \zs：右栏注释收集命令（段落注释） ---
% 用法：\zs{注释内容}
\newcommand{\zs}[1]{%
  \GWJ@appendnote{#1}%
}

% --- \zwz：右栏注释渲染命令 ---
% 功能：将当前注释队列中所有条目逐条渲染输出到右栏，输出后清空队列
% 用法：在guwen环境的右栏部分调用 \zwz（即\switchcolumn之后）
% 样式：小五号楷体，条目间留小间距
\newcommand{\zwz}{%
  \GWJ@noteslist%      % 输出当前队列中的全部注释
  \GWJ@clearnotes%     % 清空队列（为下一段原文准备）
}

% --- 双栏间距长度变量（在\AtBeginDocument中根据实际\textwidth计算）---
\newlength{\GWJ@colsepwidth}     % 两栏间距（= \GWJ@colsepratio × \textwidth）

\AtBeginDocument{%
  \setlength{\GWJ@colsepwidth}{\GWJ@colsepratio\textwidth}%
}

% --- guwen：古文双栏主环境 ---
% 功能：唯一使用双栏布局的环境，进入自动切换为左右双栏，退出自动恢复单栏
% 实现：使用paracol宏包的paracol环境，左栏原文，右栏注释
% 用法详见本模块开头注释块
\newenvironment{guwen}{%
  % 清空注释队列（每进入新guwen环境时重置）
  \GWJ@clearnotes%
  % 配置两栏比例（左栏70%，右栏25%，间距5%）
  \columnratio{\GWJ@leftcolratio}%
  \setlength{\columnsep}{\GWJ@colsepwidth}%
  % 启动双栏
  \begin{paracol}{2}%
  % 左栏字体：五号思源宋体
  \fontsize{\GWJ@mainfontsize}{18pt}\selectfont%
  % 段落格式：古诗/章句默认不首行缩进，避免对仗文本参差
  \setlength{\parindent}{0pt}%
  \setlength{\parskip}{4pt}%
}{%
  \end{paracol}%
  % 恢复单栏格式（paracol自动恢复\textwidth，此处补全段落缩进状态）
  \normalsize\normalfont%
  \setlength{\parindent}{2em}%
  \vspace{0.5em}%
}

% ======================================================================
%   模块十八：全局段落格式
% ======================================================================

% 全局段落缩进设置延迟到 AtBeginDocument 钩子执行。
\AtBeginDocument{%
  \setlength{\parindent}{2em}%   % 全局首行缩进：2个汉字宽度
  \setlength{\parskip}{0pt}%        % 段间距：默认0，避免多余空白
}

% 列表环境间距压缩（中文排版常见约定）
\setlist{nolistsep, itemsep=2pt, topsep=4pt}

% ======================================================================
%   模块十九：PDF 元信息自动填充
% ======================================================================

\AtBeginDocument{%
  \color{clrtxt}% 统一正文主色（深墨黑）
  \ifx\GWJ@booktitle\empty\else
    \hypersetup{pdftitle={\GWJ@booktitle}}%
  \fi
  \ifx\GWJ@editor\empty\else
    \hypersetup{pdfauthor={\GWJ@editor}}%
  \fi
}

% ======================================================================
%   模块二十：兼容性修复与杂项
% ======================================================================

% 修复\part页：替换默认的plain样式为partpage样式（无页眉无页码）
\patchcmd{\@part}{\thispagestyle{plain}}{\thispagestyle{partpage}}{}{}
\patchcmd{\@spart}{\thispagestyle{plain}}{\thispagestyle{partpage}}{}{}

% 修复\chapter开篇页：替换plain样式为chapterpage样式（仅页脚页码）
\patchcmd{\@chapter}{\thispagestyle{plain}}{\thispagestyle{chapterpage}}{}{}
\patchcmd{\@schapter}{\thispagestyle{plain}}{\thispagestyle{chapterpage}}{}{}

% 修复tocloft与hyperref共用时目录标题显示问题
\patchcmd{\tableofcontents}{\MakeUppercase}{\relax}{}{}

% 附录在目录中增加前置空白以区分正文区域
\AtBeginEnvironment{appendix}{%
  \addtocontents{toc}{\protect\vspace{0.5em}}%
}

% hyperref书签中中文字体切换命令的安全降级（避免书签乱码）
\pdfstringdefDisableCommands{%
  \renewcommand{\kaiti}{}%
}

\endinput
% ======================================================================
%   guwenji.cls 结束
% ======================================================================
