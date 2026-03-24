% ╔════════════════════════════════════════════════════════════════════╗
% ║                                                                    ║
% ║             COMPUTER SCIENCE NOTES LaTeX TEMPLATE CLASS            ║
% ║                        计算机学科笔记模板类                          ║
% ║                                                                    ║
% ╚════════════════════════════════════════════════════════════════════╝
%
% ┌────────────────────────────────────────────────────────────────────┐
% │ 1. 文件信息 (FILE INFORMATION)                                      │
% └────────────────────────────────────────────────────────────────────┘
%
%   文件名:   computer-notes.cls
%   用途:     为计算机科学领域笔记提供专业的 LaTeX 文档类
%   特色:     · 7 层标题体系 (part/chapter/section/ssection/sssction/paragraph/subparagraph)
%             · 蓝色主题科技风格，参考 lapis.css 和 guwenji.cls
%             · CJK 与英文字体细分指定，支持自定义
%             · 代码块、callout、引用等多种结构化排版
%             · 优化的页眉页脚与内边距设置
%             
% ┌────────────────────────────────────────────────────────────────────┐
% │ 2. 版本历史 (VERSION HISTORY)                                       │
% └────────────────────────────────────────────────────────────────────┘
%
%   版本号:   v1.0.0
%   发布日期: 2026-03-21
%   状态:     Stable (Production Ready)
%
%   ╔ v1.0.0 (2026-03-21) ═════════════════════════════════════════╗
%   ║ 首个稳定版本，全功能可用                                      ║
%   ║                                                              ║
%   ║ 新增:                                                         ║
%   ║  · 完整 7 层标题体系（part/chapter/section/ssection/sssction/paragraph/subparagraph）║
%   ║  · Part 独立分隔页（含该 Part 的迷你目录）                   ║
%   ║  · 一级标题 (chapter) 下方附蓝色装饰横线                     ║
%   ║  · 二级标题 (section) 统一蓝底白字盒，圆角处理              ║
%   ║  · 三级标题 (ssection) 蓝色左竖线                            ║
%   ║  · 四级标题 (sssction) 蓝色左竖线，无编号                    ║
%   ║  · 五级/六级标题 (paragraph/subparagraph) 加粗顶格           ║
%   ║  · 精选字体集：CJK + 英文分离指定，避免可变字体问题          ║
%   ║  · 规范代码块 codeblock 环境（Consolas 字体，灰底）          ║
%   ║  · Callout 信息框（info/warning/error 3 种样式）             ║
%   ║  · 快速参数定位注释（QUICK-EDIT 锚点系统）                   ║
%   ║                                                              ║
%   ║ 已验证:                                                      ║
%   ║  · XeLaTeX 编译无误                                          ║
%   ║  · PDF 输出 15 页，包含完整示例                              ║
%   ║  · 所有中英文混排、特殊符号、代码块均正常                     ║
%   ╚═════════════════════════════════════════════════════════════╝
%
% ┌────────────────────────────────────────────────────────────────────┐
% │ 3. 编译要求 (BUILD REQUIREMENTS)                                   │
% └────────────────────────────────────────────────────────────────────┘
%
%   推荐编译器: XeLaTeX (主验证路径)
%   备选编译器: LuaLaTeX
%   编码格式:   UTF-8
%   字体要求:   
%     · CJK 主字体:         LXGW WenKai (或同类开源字体)
%     · 标题 CJK 字体:      Source Han Serif SC 
%     · 标题英文字体:       Merriweather Regular
%     · 代码字体:           Consolas / YaHei Mono
%
%   典型编译命令:
%     xelatex -interaction=nonstopmode document.tex
%     xelatex -synctex=1 document.tex
%
% ┌────────────────────────────────────────────────────────────────────┐
% │ 4. 快速参考 (QUICK REFERENCE)                                      │
% └────────────────────────────────────────────────────────────────────┘
%
%   本文件使用"快速编辑标记系统" (QUICK-EDIT) 方便参数调整。
%   使用 Ctrl+F 搜索下列标记快速定位可配置参数：
%
%   [标题层级与样式]
%     QUICK-EDIT:TITLE-HIERARCHY       Part + 一级~六级标题定义
%     QUICK-EDIT:PART-PAGE             Part 分隔页样式与迷你目录配置
%     QUICK-EDIT:CHAPTER-LINE          一级标题装饰横线配置
%     QUICK-EDIT:SECTION-PADDING       二级标题内边距设置
%     QUICK-EDIT:SUBSUBSECTION-LINE    四级标题左竖线配置
%     QUICK-EDIT:SUBSUBSECTION-COLOR   四级标题竖线颜色
%
%   [色彩与字体]
%     QUICK-EDIT:COLOR-PALETTE         颜色定义（主题蓝、钢蓝等）
%     QUICK-EDIT:FONT-CJK              中文字体 (fontspec 配置)
%     QUICK-EDIT:FONT-TITLE            标题字体分离
%
%   [排版与间距]
%     QUICK-EDIT:PAGE-GEOMETRY         页面尺寸和边距
%     QUICK-EDIT:CODE-BLOCK-STYLE      代码块颜色、文字大小
%     QUICK-EDIT:HEADER-FOOTER         页眉页脚内容
%
% ┌────────────────────────────────────────────────────────────────────┐
% │ 5. 设计理念 (DESIGN PRINCIPLES)                                    │
% └────────────────────────────────────────────────────────────────────┘
%
%   ✓ 科技感强  蓝色主题参考现代 UI 设计（lapis.css）
%   ✓ 护眼设计  选用高对比度无衬线字体，避免疲劳
%   ✓ 层级清晰  7 层标题+装饰视觉效果，读者一目了然
%   ✓ 易于维护  核心参数集中、快速编辑标记明确
%   ✓ 中英混排  字体细分指定，确保美观与正确性
%   ✓ 开箱即用  完整示例文件 example.tex 演示所有功能
%
% ┌────────────────────────────────────────────────────────────────────┐
% │ 6. 维护与反馈 (MAINTENANCE & FEEDBACK)                              │
% └────────────────────────────────────────────────────────────────────┘
%
%   维护者:     Violet 
%   项目地址:   C:\Users\Violet\OneDrive\Notiz
%   最后更新:   2026-03-21
%   
%   如遇到编译错误、字体问题或功能建议，请：
%   1. 确认 XeLaTeX 版本 ≥ 0.99995
%   2. 检查所需字体是否已安装
%   3. 对照本文件的快速参考指南快速定位参数
%
% ══════════════════════════════════════════════════════════════════════

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{computer-notes}[2026/03/19 v1.0 Computer Science Notes Template]

% ======================================================================
%   第一部分: 文档类基础配置
% ======================================================================

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[a4paper, 12pt, oneside]{book}

% ======================================================================
%   第二部分: 宏包导入 (按功能分组)
% ======================================================================

% --- 字体与中文支持 ---
\RequirePackage{fontspec}
\RequirePackage{xeCJK}
\RequirePackage{xcolor}

% --- 页面格式与排版 ---
\RequirePackage{geometry}
\RequirePackage{fancyhdr}
\RequirePackage[explicit,newparttoc]{titlesec}
\RequirePackage{titletoc}
\RequirePackage{indentfirst}

% --- 目录与书签 ---
\RequirePackage{hyperref}
\RequirePackage{bookmark}
\RequirePackage[toc]{appendix}

% --- 数学公式 ---
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{mathtools}

% --- 表格与图表 ---
\RequirePackage{graphicx}
\RequirePackage{array}
\RequirePackage{tabularray}
\RequirePackage{caption}
\RequirePackage{tikz}
\usetikzlibrary{shapes.misc, positioning, calc}
\RequirePackage{svg}

% --- tabularray 表格默认字号 ---
% [QUICK-EDIT:TABULARRAY-FONT] Ctrl+F 搜索本标记可快速调整表格单元格与说明文字字号
% 说明：正文当前为 10.5pt，这里显式设为 9.5pt，确保表格比正文小一号
\newcommand{\cnTableBodyFont}{\fontsize{9.5pt}{13pt}\selectfont}
\newcommand{\cnTableCaptionFont}{\fontsize{9.5pt}{12pt}\selectfont}
\AddToHook{env/tblr/begin}{\cnTableBodyFont}
\AddToHook{env/longtblr/begin}{\cnTableBodyFont}
\DeclareCaptionFont{cnTableCaption}{\cnTableCaptionFont}
\captionsetup[table]{font=cnTableCaption,skip=4pt}

% --- 代码与排版 ---
\RequirePackage{listings}
\RequirePackage[many]{tcolorbox}
\tcbuselibrary{listings,skins,breakable}

% --- 列表与杂项 ---
\RequirePackage{enumitem}
\RequirePackage{calc}

% ======================================================================
%   第三部分: 全局参数定义 (集中管理所有可配置的值)
% ======================================================================

% --- 页面边距 ---
% [QUICK-EDIT:PAGE-MARGIN] Ctrl+F 搜索本标记可直接修改页边距
% 建议区间: 2.0cm ~ 2.6cm，越小版心越大
\def\cnMarginTop{2.1cm}
\def\cnMarginBottom{1.2cm}
\def\cnMarginLeft{2.0cm}
\def\cnMarginRight{2.0cm}

% --- 字号参数 (单位 pt) ---
% [QUICK-EDIT:MAIN-FONT] Ctrl+F 搜索本标记可直接修改正文字号
\def\cnFontsizeMain{10.5pt}              % 正文字号（已调小）
\def\cnFontsizeSection{16pt}             % section 字号
\def\cnFontsizeSubsection{13pt}          % subsection 字号
\def\cnFontsizeSubsubsection{12pt}       % subsubsection 字号
\def\cnFontsizeCode{10.5pt}               % 代码字号
%! [QUICK-EDIT:CALLOUT-FONT] Ctrl+F 搜索本标记可直接修改 callout 字号
\def\cnFontsizeCallout{8.8pt}            % callout 字号（再调小）

% --- 色彩系统 ---
\definecolor{color_main_text}{gray}{0.15}     % 正文主色: 深灰
\definecolor{color_title}{gray}{0.1}          % 标题色: 纯黑
\definecolor{color_accent}{RGB}{72, 112, 172} % 主题色: 科技蓝
\definecolor{color_bg_light}{gray}{0.97}      % 浅背景: 暖白
\definecolor{color_border_light}{gray}{0.85}  % 浅边框: 浅灰

% --- Callout 色彩 ---
%! [QUICK-EDIT:CALLOUT-COLOR] Ctrl+F 搜索本标记可直接修改 callout 配色
\definecolor{color_note_bg}{RGB}{230, 240, 250} % 笔记框背景: 浅蓝
\definecolor{color_note_border}{RGB}{41, 128, 185} % 笔记框边框: 科技蓝
\definecolor{color_tip_bg}{RGB}{240, 250, 230} % 技巧框背景: 浅绿
\definecolor{color_tip_border}{RGB}{70, 180, 70} % 技巧框边框: 绿色
\definecolor{color_info_bg}{RGB}{232, 244, 255} % 信息框背景: 浅灰蓝
\definecolor{color_info_border}{RGB}{74, 124, 180} % 信息框边框: 深蓝
\definecolor{color_warning_bg}{RGB}{255, 248, 225} % 警告框背景: 浅黄
\definecolor{color_warning_border}{RGB}{218, 165, 32} % 警告框边框: 金黄
\definecolor{color_caution_bg}{RGB}{255, 240, 240} % 注意框背景: 浅橙红
\definecolor{color_caution_border}{RGB}{220, 20, 60} % 注意框边框: 橙红色
\definecolor{color_danger_bg}{RGB}{255, 230, 230} % 危险框背景: 浅红
\definecolor{color_danger_border}{RGB}{178, 34, 34} % 危险框边框: 深红色
\definecolor{color_todo_bg}{RGB}{255, 250, 240} % 待办框背景: 浅橙
\definecolor{color_todo_border}{RGB}{255, 140, 0} % 待办框边框: 橙色
\definecolor{color_terminal_bg}{RGB}{45, 44, 37} % 终端背景: 深黑灰
\definecolor{color_terminal_text}{RGB}{204, 204, 204} % 终端文本: 浅白
\definecolor{color_terminal_border}{RGB}{60, 60, 60} % 终端边框: 中灰
\definecolor{color_algorithm_bg}{RGB}{245, 248, 255} % 算法框背景: 浅蓝
\definecolor{color_algorithm_border}{RGB}{70, 130, 180} % 算法框边框: 深蓝

% --- 代码色彩主题 ---
\definecolor{color_code_bg}{gray}{0.97}
\definecolor{color_code_text}{gray}{0.2}
\definecolor{color_code_string}{RGB}{70, 180, 70}

% ======================================================================
%   第四部分: 页面几何配置
% ======================================================================

\geometry{
  top        = \cnMarginTop,
  bottom     = \cnMarginBottom,
  left       = \cnMarginLeft,
  right      = \cnMarginRight,
  headheight = 20pt,
  headsep    = 15pt,
  footskip   = 18pt
}

% ======================================================================
%   第五部分: 字体配置 (四套字体系统)
% ======================================================================

% --- 套 1: CJK 主字体（参考 guwenji）---
\IfFontExistsTF{LXGW WenKai Screen}{%
  \setCJKmainfont[
    AutoFakeBold  = 5,
    AutoFakeSlant = 0.2
  ]{LXGW WenKai Screen}%
}{%
  \setCJKmainfont[
    BoldFont   = {SimHei},
    ItalicFont = {KaiTi}
  ]{SimSun}%
}

% --- 套 2: CJK 标题字体（仅 Source Han Serif SC）---
% [QUICK-EDIT:TITLE-CJK-FONT] Ctrl+F 搜索本标记可快速替换标题中文字体
\setCJKsansfont[
  AutoFakeBold  = 2,
  AutoFakeSlant = 0.2
]{Source Han Serif SC}

% --- 标题中英文分离字体（中文/英文可独立调整）---
% [QUICK-EDIT:TITLE-LATIN-FONT] Ctrl+F 搜索本标记可快速替换标题英文字体
\IfFontExistsTF{Merriweather}{%
  \newfontfamily\cnTitleLatinFont{Merriweather}
}{%
  \newfontfamily\cnTitleLatinFont{Arial}
}
% [QUICK-EDIT:TITLE-CJK-FAMILY] Ctrl+F 搜索本标记可快速替换标题中文字体族
\newCJKfontfamily\cnTitleCJKFont[
  AutoFakeBold  = 2,
  AutoFakeSlant = 0.2
]{Source Han Serif SC}
\newcommand{\cnTitleFont}{\cnTitleLatinFont\cnTitleCJKFont}

% --- 套 3: CJK 等宽字体（兜底）---
\setCJKmonofont[
  ItalicFont = {FangSong}
]{FangSong}

% --- 楷体字族（强调文本）---
\IfFontExistsTF{KaiTi}{%
  \setCJKfamilyfont{kaiti}{KaiTi}%
}{%
  \setCJKfamilyfont{kaiti}{FangSong}%
}
\newcommand{\kaiti}{\CJKfamily{kaiti}}
\renewcommand{\textit}[1]{{\kaiti #1}}
\renewcommand{\emph}[1]{{\kaiti #1}}

% --- 强调字体（未来圆 SC，带兜底）---
% [QUICK-EDIT:EMPHASIS-FONT] Ctrl+F 搜索本标记可快速替换强调字体
% 说明：AutoFakeBold 使用较小数值，仅做“稍微加重”
\IfFontExistsTF{未来圆SC}{%
  \newCJKfontfamily\cnEmphasisFont[AutoFakeBold=1.25]{未来圆SC}%
}{%
  \newCJKfontfamily\cnEmphasisFont[AutoFakeBold=1.25]{Source Han Serif SC}%
}

% --- 套 4: 等宽字体（代码专用）---
\IfFontExistsTF{Consolas}{%
  \setmonofont[Scale=0.9]{Consolas}%
}{%
  \setmonofont[Scale=0.9]{Courier New}%
}

% --- 西文字体（优先使用稳定的非可变字体）---
\IfFontExistsTF{Cantarell}{
  \setmainfont{Cantarell}
}{
  \setmainfont{TeX Gyre Heros}
}

\IfFontExistsTF{Merriweather}{%
  \setsansfont{Merriweather}
}{
  \setsansfont{Times New Roman}
}


% ======================================================================
%   第六部分: 标题样式配置
% ======================================================================

% [QUICK-EDIT:TITLE-HIERARCHY] Ctrl+F 搜索本标记可快速调整标题层级
% 层级映射：part=一级，chapter=二级，section=三级，ssection=四级，sssction=五级，paragraph=六级，subparagraph=七级
\setcounter{secnumdepth}{2}
\setcounter{tocdepth}{2}
\renewcommand{\thesection}{\arabic{section}}
\renewcommand{\thesubsection}{\thesection.\arabic{subsection}}

% --- 四级/五级标题命名别名（仅改名字，不改原有层级与样式）---
\newcommand{\ssection}{\subsection}
\newcommand{\sssction}{\subsubsection}

% --- Part 分隔页（一级标题，参考 OrangeBook）---
% [QUICK-EDIT:CHAPTER-LINE] Ctrl+F 搜索本标记可快速调整二级标题下方横线
% [QUICK-EDIT:PART-PAGE] Ctrl+F 搜索本标记可快速调整 Part 分隔页样式
% 参考 OrangeBook：Part 使用独立整页视觉，并在右下角显示该 Part 的迷你目录
\newcommand{\cnPartOutputPage}[2]{%
  \begin{tikzpicture}[remember picture,overlay]
    \node[anchor=center, rectangle, fill=color_accent!14, inner sep=0pt, minimum height=\paperheight, minimum width=\paperwidth] at (current page.center) {};
    \node[anchor=north west, inner sep=0pt, xshift=\cnMarginLeft, yshift=-\cnMarginTop] at (current page.north west) {\fontsize{120pt}{120pt}\selectfont\cnTitleFont\bfseries\textcolor{color_accent!30}{#1}};
    \node[anchor=north east, inner sep=0pt, xshift=-\cnMarginRight, yshift=-\cnMarginTop] at (current page.north east) {\fontsize{24pt}{28pt}\selectfont\cnTitleFont\bfseries\textcolor{color_accent}{\strut #2}};
    \node[anchor=north west, inner sep=0pt, xshift=\cnMarginLeft, yshift=-\dimexpr\cnMarginTop+1.8cm\relax] at (current page.north west) {\fontsize{20pt}{24pt}\selectfont\cnTitleFont\bfseries\textcolor{color_accent!70}{\partname}};
    \node[anchor=south east, inner sep=0pt, xshift=-\cnMarginRight, yshift=\cnMarginBottom] at (current page.south east) {%
      \parbox[t][][t]{8.2cm}{%
        \printcontents[part]{l}{0}{\setcounter{tocdepth}{1}}%
      }%
    };
  \end{tikzpicture}%
}

\titleformat{\part}[display]
  {\thispagestyle{empty}\startcontents[part]}
  {}
  {0em}
  {\cnPartOutputPage{\thepart}{#1}}
  [\newpage]

% --- 目录样式：Part 及 Part 分区迷你目录（参考 OrangeBook）---
% [QUICK-EDIT:PART-TOC] Ctrl+F 搜索本标记可快速调整 Part 在目录中的显示
\newcommand{\cnTocPartNumbered}[1]{%
  \setlength\fboxsep{0pt}%
  \contentslabel[%
    \colorbox{color_accent!18}{%
      \strut\parbox[c][0.72cm]{1.18cm}{%
        \centering\cnTitleFont\bfseries\large\textcolor{color_accent}{\thecontentslabel}%
      }%
    }%
    \hspace{4pt}%
    \colorbox{color_accent!36}{%
      \strut\parbox[c][0.72cm]{\linewidth-1.32cm}{%
        \centering\cnTitleFont\bfseries\large\textcolor{color_title}{#1}%
      }%
    }%
  ]{1.32cm}%
}

\newcommand{\cnTocPartUnnumbered}[1]{%
  \setlength\fboxsep{0pt}%
  \contentslabel[%
    \colorbox{color_accent!36}{%
      \strut\parbox[c][0.72cm]{\linewidth}{%
        \centering\cnTitleFont\bfseries\large\textcolor{color_title}{#1}%
      }%
    }%
  ]{1.32cm}%
}

\titlecontents{part}
  [1.32cm]
  {\addvspace{10pt}\cnTitleFont\bfseries\large\hypersetup{linkcolor=black}}
  {\cnTocPartNumbered}
  {\cnTocPartUnnumbered}
  {}
  []

\titlecontents{lchapter}
  [0cm]
  {\addvspace{8pt}\cnTitleFont\bfseries\normalsize\color{color_accent}}
  {\contentslabel[\thecontentslabel]{1.15cm}}
  {}
  {\ \titlerule*[5pt]{.}\ \thecontentspage}
  []

\titlecontents{lsection}
  [0.35cm]
  {\cnTitleFont\small\color{color_main_text}}
  {\contentslabel[\thecontentslabel]{1.0cm}}
  {}
  {\ \titlerule*[5pt]{.}\ \thecontentspage}
  []

% --- \chapter（二级标题，参考 lapis h1：居中、蓝色、较大、下方横线）---
\titleformat{\chapter}[display]
  {\normalfont\cnTitleFont\bfseries\fontsize{24pt}{30pt}\selectfont\color{color_accent}\centering}
  {\chaptername\ \thechapter}
  {0.5em}
  {#1}
  [\vspace{0.20em} % 标题与横线之间的垂直间距
   {\centering\color{color_accent}\rule{0.8\textwidth}{0.8pt}} % 横线设计：宽度占80%，厚度0.8pt，颜色与标题呼应
   \vspace{0.1em}]

\titlespacing*{\chapter}{0pt}{1.5em}{1.2em}

% --- \section（三级标题，参考 lapis h2：蓝底白字）---
% [QUICK-EDIT:SECTION-PADDING] Ctrl+F 搜索本标记可快速调整三级标题内边距
% 参数说明：left/right 控制左右留白，top/bottom 控制上下留白
\newtcbox{\cnSectionUnifiedBox}{
  on line,
  boxrule=0pt,
  arc=3pt,
  colback=color_accent,
  colframe=color_accent,
  coltext=white,
  left=11pt,
  right=13pt,
  top=4pt,
  bottom=4pt,
  boxsep=0pt
}


\titleformat{\section}[hang]
  {\normalfont\cnTitleFont\bfseries\fontsize{18pt}{22pt}\selectfont\color{white}}
  {}
  {0pt}
  {\cnSectionUnifiedBox{\thesection\hspace{0.55em}#1}}

\titlespacing*{\section}{0pt}{0.6em}{0.4em}

% --- \ssection（四级标题，命令名映射到 \subsection，参考 lapis h3）---
\titleformat{\subsection}[hang]
  {\normalfont\cnTitleFont\bfseries\fontsize{16pt}{20pt}\selectfont\color{color_accent}}
  {\thesubsection}
  {0.6em}
  {#1}

\titlespacing*{\subsection}{0pt}{1.0em}{0.6em}

% --- \sssction（五级标题，命令名映射到 \subsubsection，参考 lapis h4）---
% [QUICK-EDIT:SUBSUBSECTION-LINE-COLOR] Ctrl+F 搜索本标记可快速调整五级标题左侧竖线颜色
% 设计说明：竖线采用更沉稳的蓝色，和二级标题蓝底形成层级呼应
\titleformat{\subsubsection}[hang]
  {\normalfont\cnTitleFont\bfseries\fontsize{14pt}{18pt}\selectfont\color{color_accent}}
  {}
  {0pt}
  {\tikz[baseline=0.35ex]\draw[color_info_border, line width=2.8pt, line cap=round] (0,0) -- (0,1em);\hspace{8pt}#1}

\titlespacing*{\subsubsection}{0pt}{0.8em}{0.4em}

% --- \paragraph（六级标题，普通加粗顶格）---
\titleformat{\paragraph}[hang]
  {\normalfont\cnTitleFont\bfseries\fontsize{12pt}{16pt}\selectfont\color{color_accent}}
  {}
  {0pt}
  {#1}

\titlespacing*{\paragraph}{0pt}{0.6em}{0.3em}

% --- \subparagraph（七级标题，普通加粗顶格）---
\titleformat{\subparagraph}[hang]
  {\normalfont\cnTitleFont\bfseries\fontsize{11pt}{15pt}\selectfont\color{color_accent}}
  {}
  {0pt}
  {#1}

\titlespacing*{\subparagraph}{0pt}{0.4em}{0.2em}

% ======================================================================
%   第七部分: 页眉页脚 (fancyhdr)
% ======================================================================

\pagestyle{fancy}
\fancyhf{}

% --- 页眉 ---
% 左页眉: 章节标题
\fancyhead[L]{\sffamily\fontsize{10pt}{12pt}\selectfont\color{color_accent}\ \leftmark}
% 右页眉: 页码
\fancyhead[R]{\sffamily\fontsize{10pt}{12pt}\selectfont\color{color_accent}\thepage}

% --- 页脚 ---
% 中页脚: 章节信息（预留位置，可选使用）
\fancyfoot[C]{}

% --- 横线 ---
\renewcommand{\headrulewidth}{0.5pt}
\renewcommand{\footrulewidth}{0pt}
\renewcommand{\headrule}{%
  {\color{color_border_light}\hrule\@height\headrulewidth\@width\headwidth}%
}

% --- 脚注样式（默认启用）---
% [QUICK-EDIT:FOOTNOTE-STYLE] Ctrl+F 搜索本标记可快速调整脚注视觉与间距
% 说明：统一脚注区留白、分隔线和编号文本对齐，适配当前蓝色主题
\setlength{\skip\footins}{0.9em}
\setlength{\footnotesep}{0.35em}
\renewcommand{\footnoterule}{%
  \vspace*{-0.25em}
  {\color{color_border_light}\hrule width 0.28\textwidth height 0.5pt}
  \vspace*{0.35em}
}
\makeatletter
\renewcommand\@makefntext[1]{%
  \noindent
  \makebox[1.6em][l]{\textcolor{color_accent}{\textsuperscript{\@thefnmark}}}#1%
}
\makeatother

% ======================================================================
%   第八部分: 正文格式 (段落、列表)
% ======================================================================

% --- 正文段落 ---
% [QUICK-EDIT:BODY-LINE-SPACING] Ctrl+F 搜索本标记可快速调整正文字号与行间距
% 说明：将基线距从 17pt 下调到 16pt，使正文更紧凑
\AtBeginDocument{%
  \color{color_main_text}
  \fontsize{\cnFontsizeMain}{16pt}\selectfont
  \setlength{\parindent}{2em}
  \setlength{\parskip}{0.5em}
}

% --- 列表间距压缩（有序/无序）---
% [QUICK-EDIT:LIST-SPACING] Ctrl+F 搜索本标记可快速调整列表上下间距与行间距
% 全局说明：统一收紧列表前后空白，减少段落跳跃感
\setlist{
  topsep     = 0.15em,
  partopsep  = 0em,
  leftmargin = 1.7em
}

% [QUICK-EDIT:LIST-MARKERS] Ctrl+F 搜索本标记可快速调整列表符号视觉
% 参考 elegantbook：按层级使用不同圆点样式，提升嵌套列表辨识度
\newcommand*{\cnitemi}{\tikz \draw [baseline, ball color=color_accent, draw=none] circle (2pt);}
\newcommand*{\cnitemii}{\tikz \draw [baseline, fill=color_accent!85!black, draw=none] circle (2pt);}
\newcommand*{\cnitemiii}{\tikz \draw [baseline, fill=color_accent!70!black, draw=none] circle (1.6pt);}

% 无序列表：按层级设置标记（elegantbook 风格）并保持紧凑行距
\setlist[itemize]{
  itemsep    = 0.05em,
  parsep     = 0.05em,
  labelsep   = 0.55em
}
\setlist[itemize,1]{label={\cnitemi}}
\setlist[itemize,2]{label={\cnitemii}}
\setlist[itemize,3]{label={\cnitemiii}}


% 有序列表：参考 elegantbook 的分级编号体系（1. / (a). / I. / A.）
\setlist[enumerate]{
  itemsep    = 0.05em,
  parsep     = 0.05em,
  labelsep   = 0.55em
}
\setlist[enumerate,1]{label=\textcolor{color_accent}{\arabic*.}}
\setlist[enumerate,2]{label=\textcolor{color_accent}{(\alph*).}}
\setlist[enumerate,3]{label=\textcolor{color_accent}{\Roman*.}}
\setlist[enumerate,4]{label=\textcolor{color_accent}{\Alph*.}}

% 描述列表：调整标签样式与间距
\setlist[description]{
  itemsep    = 0.05em,
  parsep     = 0.05em,
  labelsep   = 0.5em,
  font       = \bfseries\color{color_accent}
}

% ======================================================================
%   第九部分: 数学公式样式
% ======================================================================

% equation 环境自动编号与周围间距
\renewcommand{\theequation}{\thesection.\arabic{equation}}

% 行内公式周围的间距调整
\abovedisplayskip = 0.5em plus 0.2em minus 0.2em
\belowdisplayskip = 0.5em plus 0.2em minus 0.2em

% ======================================================================
%   第十部分: 超链接与书签配置
% ======================================================================

\hypersetup{
  colorlinks        = true,
  linkcolor         = color_accent,
  urlcolor          = color_accent,
  citecolor         = color_accent,
  bookmarksopen     = true,
  bookmarksnumbered = true,
  pdfborder         = {0 0 0}
}

\bookmarksetup{
  open     = true,
  numbered = true
}

% ======================================================================
%   第十一部分: 自定义标题页与目录
% ======================================================================

% --- 内部存储 ---
\newcommand{\cnDocTitle}{}
\newcommand{\cnDocAuthor}{}
\newcommand{\cnDocDate}{}

% --- \settitle: 设置文档标题 (同时更新 PDF 元信息) ---
\newcommand{\settitle}[1]{%
  \renewcommand{\cnDocTitle}{#1}%
  \title{#1}%
  \hypersetup{pdftitle={#1}}%
}

% --- \setauthor: 设置作者 ---
\newcommand{\setauthor}[1]{%
  \renewcommand{\cnDocAuthor}{#1}%
  \author{#1}%
  \hypersetup{pdfauthor={#1}}%
}

% --- \setdate: 设置日期 ---
\newcommand{\setdate}[1]{%
  \renewcommand{\cnDocDate}{#1}%
  \date{#1}%
}

% --- \makecover: 生成简约科技风封面 ---
\newcommand{\makecover}{%
  \begin{titlepage}%
    \thispagestyle{empty}
    \setcounter{page}{0}
    \begin{center}%
      \vspace*{80pt}
      
      % 标题
      {\fontsize{32pt}{40pt}\selectfont\sffamily\bfseries\color{color_title}%
        \cnDocTitle\par}
      
      \vspace{30pt}
      
      % 装饰线
      {\color{color_accent}\rule{0.4\textwidth}{1.5pt}}\par
      
      \vspace{50pt}
      
      % 作者
      {\fontsize{14pt}{18pt}\selectfont\color{color_main_text}%
        \cnDocAuthor\par}
      
      \vspace{10pt}
      
      % 日期
      {\fontsize{12pt}{16pt}\selectfont\color{color_border_light}%
        \cnDocDate\par}
      
    \end{center}%
    \vfill
  \end{titlepage}%
  \clearpage
  \setcounter{page}{1}
}

% --- 目录样式 ---
\renewcommand{\contentsname}{\textbf{目\quad 录}}

% ======================================================================
%   第十二部分: Callout 提示框系统 (7 种类型)
% ======================================================================

% --- tcolorbox 通用配置 ---
\tcbset{
  cn_common/.style={
    enhanced,
    breakable,
    colback      = white,
    coltitle     = color_title,
    colframe     = color_border_light,
    boxrule      = 0pt,
    leftrule     = 4pt,
    arc          = 5pt,
    outer arc    = 5pt,
    left         = 0.8em,
    right        = 0.8em,
    top          = 0.6em,
    bottom       = 0.6em,
    boxed title style = {boxrule=0pt, colback=color_bg_light, arc=2pt, outer arc=2pt},
    attach boxed title to top left = {yshift=-2mm, xshift=5mm},
    fonttitle    = \bfseries\fontsize{\cnFontsizeCallout}{11pt}\selectfont,
    fontlower    = \fontsize{\cnFontsizeCallout}{9.5pt}\selectfont
  }
}

% --- \note: 笔记框 (蓝色) ---
\newtcolorbox{notebox}[1][]{%
  cn_common,
  colback      = color_note_bg,
  colframe     = color_note_border,
  coltitle     = color_note_border,
  boxed title style = {boxrule=0pt, colback=color_note_bg!85!white, arc=2pt, outer arc=2pt},
  title        = {\textcolor{color_note_border}{NOTE}},
  #1
}

\NewDocumentCommand{\note}{+m}{%
  \begin{notebox}
  #1
  \end{notebox}
}

% --- \tip: 技巧框 (绿色) ---
\newtcolorbox{tipbox}[1][]{%
  cn_common,
  colback      = color_tip_bg,
  colframe     = color_tip_border,
  coltitle     = color_tip_border,
  title        = {\textcolor{color_tip_border}{TIP}},
  #1
}

\NewDocumentCommand{\tip}{+m}{%
  \begin{tipbox}
  #1
  \end{tipbox}
}

% --- \info: 信息框 (灰色) ---
\newtcolorbox{infobox}[1][]{%
  cn_common,
  colback      = color_info_bg,
  colframe     = color_info_border,
  coltitle     = color_info_border,
  boxed title style = {boxrule=0pt, colback=color_info_bg!90!white, arc=2pt, outer arc=2pt},
  title        = {\textcolor{color_info_border}{INFO}},
  #1
}

\NewDocumentCommand{\info}{+m}{%
  \begin{infobox}
  #1
  \end{infobox}
}

% --- \warning: 警告框 (黄色) ---
\newtcolorbox{warningbox}[1][]{%
  cn_common,
  colback      = color_warning_bg,
  colframe     = color_warning_border,
  coltitle     = color_warning_border,
  title        = {\textcolor{color_warning_border}{WARNING}},
  #1
}

\NewDocumentCommand{\warning}{+m}{%
  \begin{warningbox}
  #1
  \end{warningbox}
}

% --- \caution: 注意框 (橙红色) ---
\newtcolorbox{cautionbox}[1][]{%
  cn_common,
  colback      = color_caution_bg,
  colframe     = color_caution_border,
  coltitle     = color_caution_border,
  title        = {\textcolor{color_caution_border}{CAUTION}},
  #1
}

\NewDocumentCommand{\caution}{+m}{%
  \begin{cautionbox}
  #1
  \end{cautionbox}
}

% --- \danger: 危险框 (深红色) ---
\newtcolorbox{dangerbox}[1][]{%
  cn_common,
  colback      = color_danger_bg,
  colframe     = color_danger_border,
  coltitle     = color_danger_border,
  title        = {\textcolor{color_danger_border}{DANGER}},
  #1
}

\NewDocumentCommand{\danger}{+m}{%
  \begin{dangerbox}
  #1
  \end{dangerbox}
}

% --- \todo: 待办框 (橙色) ---
\newtcolorbox{todobox}[1][]{%
  cn_common,
  colback      = color_todo_bg,
  colframe     = color_todo_border,
  coltitle     = color_todo_border,
  title        = {\textcolor{color_todo_border}{TODO}},
  #1
}

\NewDocumentCommand{\todo}{+m}{%
  \begin{todobox}
  #1
  \end{todobox}
}

% ======================================================================
%   第十三部分: 代码块系统
% ======================================================================

% [QUICK-EDIT:CODE-BLOCK] Ctrl+F 搜索本标记可快速定位代码块实现
% 设计说明:
% 1) listings 负责语法高亮/行号
% 2) tcolorbox 负责圆角边框/标题栏
% 3) 推荐优先使用 codeblock 环境（最稳定，支持多行）
% 4) \code 命令保留为快捷封装（适合短代码）

% --- listings 全局配置 ---
\lstset{
  basicstyle       = \ttfamily\fontsize{\cnFontsizeCode}{9pt}\selectfont\color{color_code_text},
  keywordstyle     = \color{color_accent}\bfseries,
  commentstyle     = \color{gray},
  stringstyle      = \color{color_code_string},%
  breaklines       = true,
  columns          = flexible,
  tabsize          = 2,
  showstringspaces = false,
  backgroundcolor  = \color{color_code_bg},
  rulecolor        = \color{color_border_light},
  frame            = tb,
  framerule        = 0.5pt,
  framexleftmargin = 5pt,
  framexrightmargin= 5pt,
  xleftmargin      = 8pt,
  xrightmargin     = 8pt,
  numbers          = left,
  numberstyle      = \tiny\color{gray},
  stepnumber       = 1,
  belowskip        = 0.5em,
  aboveskip        = 0.5em
}

% --- 语言配置 ---
\lstdefinelanguage{Python}{
  keywords={and, as, assert, break, class, continue, def, del, elif, else, except, False, finally, for, from, global, if, import, in, is, lambda, None, nonlocal, not, or, pass, raise, return, True, try, while, with, yield},
  basicstyle=\ttfamily\fontsize{\cnFontsizeCode}{9pt}\selectfont\color{color_code_text},
  commentstyle=\color{gray},
  stringstyle=\color{color_code_string}
}

\lstdefinelanguage{Bash}{
  keywords={if, then, else, elif, fi, case, in, esac, for, do, done, while, function, return, echo, export, source},
  basicstyle=\ttfamily\fontsize{\cnFontsizeCode}{9pt}\selectfont\color{color_code_text},
  commentstyle=\color{gray},
  stringstyle=\color{color_code_string}
}

\lstdefinelanguage{SQL}{
  keywords={SELECT, FROM, WHERE, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, TABLE, PRIMARY, KEY, FOREIGN, NOT, NULL, UNIQUE, DEFAULT, AUTO_INCREMENT, INT, VARCHAR, TIMESTAMP, CURRENT_TIMESTAMP},
  basicstyle=\ttfamily\fontsize{\cnFontsizeCode}{9pt}\selectfont\color{color_code_text},
  commentstyle=\color{gray},
  stringstyle=\color{color_code_string},
  keywordstyle=\color{color_accent}\bfseries
}

\lstdefinelanguage{YAML}{
  keywords={true,false,null,yes,no,on,off},
  sensitive=false,
  morecomment=[l]{\#},
  morestring=[b]",
  basicstyle=\ttfamily\fontsize{\cnFontsizeCode}{9pt}\selectfont\color{color_code_text},
  commentstyle=\color{gray},
  stringstyle=\color{color_code_string},
  keywordstyle=\color{color_accent}\bfseries
}

\lstdefinelanguage{yml}{
  keywords={true,false,null,yes,no,on,off},
  sensitive=false,
  morecomment=[l]{\#},
  morestring=[b]",
  basicstyle=\ttfamily\fontsize{\cnFontsizeCode}{9pt}\selectfont\color{color_code_text},
  commentstyle=\color{gray},
  stringstyle=\color{color_code_string},
  keywordstyle=\color{color_accent}\bfseries
}

\lstdefinelanguage{yaml}{
  keywords={true,false,null,yes,no,on,off},
  sensitive=false,
  morecomment=[l]{\#},
  morestring=[b]",
  basicstyle=\ttfamily\fontsize{\cnFontsizeCode}{9pt}\selectfont\color{color_code_text},
  commentstyle=\color{gray},
  stringstyle=\color{color_code_string},
  keywordstyle=\color{color_accent}\bfseries
}

\lstdefinelanguage{JSON}{
  morestring=[b]",
  showstringspaces=false,
  basicstyle=\ttfamily\fontsize{\cnFontsizeCode}{9pt}\selectfont\color{color_code_text},
  stringstyle=\color{color_code_string},
  keywordstyle=\color{color_accent}\bfseries,
  literate=
   *{:}{{{\textcolor{color_accent}{:}}}}{1}
    {,}{{{\textcolor{color_accent}{,}}}}{1}
    {\{}{{{\textcolor{color_accent}{\{}}}}{1}
    {\}}{{{\textcolor{color_accent}{\}}}}}{1}
    {[}{{{\textcolor{color_accent}{[}}}}{1}
    {]}{{{\textcolor{color_accent}{]}}}}{1}
}

\lstdefinelanguage{Java}{
  keywords={abstract,assert,boolean,break,byte,case,catch,char,class,const,continue,default,do,double,else,enum,extends,final,finally,float,for,goto,if,implements,import,instanceof,int,interface,long,native,new,package,private,protected,public,return,short,static,strictfp,super,switch,synchronized,this,throw,throws,transient,try,void,volatile,while,true,false,null,var,record,sealed,permits},
  sensitive=true,
  morecomment=[l]{//},
  morecomment=[s]{/*}{*/},
  morestring=[b]",
  basicstyle=\ttfamily\fontsize{\cnFontsizeCode}{9pt}\selectfont\color{color_code_text},
  commentstyle=\color{gray},
  stringstyle=\color{color_code_string},
  keywordstyle=\color{color_accent}\bfseries
}

\lstdefinelanguage{Kotlin}{
  keywords={as,as?,break,class,continue,do,else,false,for,fun,if,in,!in,interface,is,!is,null,object,package,return,super,this,throw,true,try,typealias,val,var,when,while,by,catch,constructor,delegate,dynamic,field,file,finally,get,import,init,param,property,receiver,set,setparam,where,actual,abstract,annotation,companion,const,crossinline,data,enum,expect,external,final,infix,inline,inner,internal,lateinit,noinline,open,operator,out,override,private,protected,public,reified,sealed,suspend,tailrec,vararg,where},
  sensitive=true,
  morecomment=[l]{//},
  morecomment=[s]{/*}{*/},
  morestring=[b]",
  basicstyle=\ttfamily\fontsize{\cnFontsizeCode}{9pt}\selectfont\color{color_code_text},
  commentstyle=\color{gray},
  stringstyle=\color{color_code_string},
  keywordstyle=\color{color_accent}\bfseries
}

\lstdefinelanguage{XML}{
  sensitive=true,
  morecomment=[s]{<!--}{-->},
  morestring=[b]",
  morestring=[b]',
  basicstyle=\ttfamily\fontsize{\cnFontsizeCode}{9pt}\selectfont\color{color_code_text},
  commentstyle=\color{gray},
  stringstyle=\color{color_code_string},
  keywordstyle=\color{color_accent}\bfseries,
  literate=
   *{<}{{{\textcolor{color_accent}{<}}}}{1}
    {>}{{{\textcolor{color_accent}{>}}}}{1}
    {/}{{{\textcolor{color_accent}{/}}}}{1}
}

\lstdefinelanguage{JavaScript}{
  keywords={break,case,catch,class,const,continue,debugger,default,delete,do,else,export,extends,false,finally,for,function,if,import,in,instanceof,let,new,null,return,super,switch,this,throw,true,try,typeof,var,void,while,with,yield,async,await},
  sensitive=true,
  morecomment=[l]{//},
  morecomment=[s]{/*}{*/},
  morestring=[b]",
  morestring=[b]',
  basicstyle=\ttfamily\fontsize{\cnFontsizeCode}{9pt}\selectfont\color{color_code_text},
  commentstyle=\color{gray},
  stringstyle=\color{color_code_string},
  keywordstyle=\color{color_accent}\bfseries
}

\lstdefinelanguage{TypeScript}{
  language=JavaScript,
  keywords={any,as,boolean,constructor,declare,get,module,namespace,never,readonly,number,require,set,string,symbol,type,from,of,implements,interface,private,protected,public,enum}
}

\lstdefinelanguage{C}{
  language=[ANSI]C,
  basicstyle=\ttfamily\fontsize{\cnFontsizeCode}{9pt}\selectfont\color{color_code_text},
  keywordstyle=\color{color_accent}\bfseries,
  commentstyle=\color{gray},
  stringstyle=\color{color_code_string}
}

\lstdefinelanguage{C++}{
  language=[ISO]C++,
  basicstyle=\ttfamily\fontsize{\cnFontsizeCode}{9pt}\selectfont\color{color_code_text},
  keywordstyle=\color{color_accent}\bfseries,
  commentstyle=\color{gray},
  stringstyle=\color{color_code_string}
}

\lstdefinelanguage{cpp}{language=C++}
\lstdefinelanguage{cxx}{language=C++}

% 说明：listings 对 C# 建议使用 CSharp/csharp/cs 作为语言名
\lstdefinelanguage{CSharp}{
  language=[Sharp]C,
  basicstyle=\ttfamily\fontsize{\cnFontsizeCode}{9pt}\selectfont\color{color_code_text},
  keywordstyle=\color{color_accent}\bfseries,
  commentstyle=\color{gray},
  stringstyle=\color{color_code_string}
}
\lstdefinelanguage{csharp}{language=CSharp}
\lstdefinelanguage{cs}{language=CSharp}

\lstdefinelanguage{Rust}{
  keywords={as,break,const,continue,crate,else,enum,extern,false,fn,for,if,impl,in,let,loop,match,mod,move,mut,pub,ref,return,self,Self,static,struct,super,trait,true,type,unsafe,use,where,while,async,await,dyn},
  sensitive=true,
  morecomment=[l]{//},
  morecomment=[s]{/*}{*/},
  morestring=[b]",
  basicstyle=\ttfamily\fontsize{\cnFontsizeCode}{9pt}\selectfont\color{color_code_text},
  commentstyle=\color{gray},
  stringstyle=\color{color_code_string},
  keywordstyle=\color{color_accent}\bfseries
}

\lstdefinelanguage{Go}{
  keywords={break,case,chan,const,continue,default,defer,else,fallthrough,for,func,go,goto,if,import,interface,map,package,range,return,select,struct,switch,type,var},
  sensitive=true,
  morecomment=[l]{//},
  morecomment=[s]{/*}{*/},
  morestring=[b]",
  basicstyle=\ttfamily\fontsize{\cnFontsizeCode}{9pt}\selectfont\color{color_code_text},
  commentstyle=\color{gray},
  stringstyle=\color{color_code_string},
  keywordstyle=\color{color_accent}\bfseries
}

\lstdefinelanguage{PHP}{
  keywords={abstract,and,array,as,break,callable,case,catch,class,clone,const,continue,declare,default,do,echo,else,elseif,empty,enddeclare,endfor,endforeach,endif,endswitch,endwhile,eval,exit,extends,final,finally,fn,for,foreach,function,global,goto,if,implements,include,include_once,instanceof,insteadof,interface,isset,list,match,namespace,new,or,print,private,protected,public,readonly,require,require_once,return,static,switch,throw,trait,try,unset,use,var,while,xor,yield,true,false,null},
  sensitive=true,
  morecomment=[l]{//},
  morecomment=[l]{\#},
  morecomment=[s]{/*}{*/},
  morestring=[b]",
  basicstyle=\ttfamily\fontsize{\cnFontsizeCode}{9pt}\selectfont\color{color_code_text},
  commentstyle=\color{gray},
  stringstyle=\color{color_code_string},
  keywordstyle=\color{color_accent}\bfseries
}

\lstdefinelanguage{Ruby}{
  keywords={BEGIN,END,alias,and,begin,break,case,class,def,defined?,do,else,elsif,end,ensure,false,for,if,in,module,next,nil,not,or,redo,rescue,retry,return,self,super,then,true,undef,unless,until,when,while,yield},
  sensitive=true,
  morecomment=[l]{\#},
  morestring=[b]",
  morestring=[b]',
  basicstyle=\ttfamily\fontsize{\cnFontsizeCode}{9pt}\selectfont\color{color_code_text},
  commentstyle=\color{gray},
  stringstyle=\color{color_code_string},
  keywordstyle=\color{color_accent}\bfseries
}

\lstdefinelanguage{Swift}{
  keywords={associatedtype,class,deinit,enum,extension,fileprivate,func,import,init,inout,internal,let,open,operator,private,protocol,public,rethrows,static,struct,subscript,typealias,var,break,case,continue,default,defer,do,else,fallthrough,for,guard,if,in,repeat,return,switch,where,while,as,Any,false,is,nil,self,Self,super,throw,throws,true,try},
  sensitive=true,
  morecomment=[l]{//},
  morecomment=[s]{/*}{*/},
  morestring=[b]",
  basicstyle=\ttfamily\fontsize{\cnFontsizeCode}{9pt}\selectfont\color{color_code_text},
  commentstyle=\color{gray},
  stringstyle=\color{color_code_string},
  keywordstyle=\color{color_accent}\bfseries
}

\lstdefinelanguage{R}{
  keywords={if,else,repeat,while,function,for,in,next,break,TRUE,FALSE,NULL,NA,NaN,Inf},
  sensitive=true,
  morecomment=[l]{\#},
  morestring=[b]",
  morestring=[b]',
  basicstyle=\ttfamily\fontsize{\cnFontsizeCode}{9pt}\selectfont\color{color_code_text},
  commentstyle=\color{gray},
  stringstyle=\color{color_code_string},
  keywordstyle=\color{color_accent}\bfseries
}

\lstdefinelanguage{Scala}{
  keywords={abstract,case,catch,class,def,do,else,extends,false,final,finally,for,forSome,if,implicit,import,lazy,match,new,null,object,override,package,private,protected,return,sealed,super,this,throw,trait,true,try,type,val,var,while,with,yield},
  sensitive=true,
  morecomment=[l]{//},
  morecomment=[s]{/*}{*/},
  morestring=[b]",
  basicstyle=\ttfamily\fontsize{\cnFontsizeCode}{9pt}\selectfont\color{color_code_text},
  commentstyle=\color{gray},
  stringstyle=\color{color_code_string},
  keywordstyle=\color{color_accent}\bfseries
}

\lstdefinelanguage{Dart}{
  keywords={abstract,as,assert,async,await,break,case,catch,class,const,continue,covariant,default,deferred,do,dynamic,else,enum,export,extends,extension,external,factory,false,final,finally,for,Function,get,hide,if,implements,import,in,interface,is,late,library,mixin,new,null,on,operator,part,rethrow,return,set,show,static,super,switch,sync,this,throw,true,try,typedef,var,void,while,with,yield},
  sensitive=true,
  morecomment=[l]{//},
  morecomment=[s]{/*}{*/},
  morestring=[b]",
  basicstyle=\ttfamily\fontsize{\cnFontsizeCode}{9pt}\selectfont\color{color_code_text},
  commentstyle=\color{gray},
  stringstyle=\color{color_code_string},
  keywordstyle=\color{color_accent}\bfseries
}

\lstdefinelanguage{Lua}{
  keywords={and,break,do,else,elseif,end,false,for,function,goto,if,in,local,nil,not,or,repeat,return,then,true,until,while},
  sensitive=true,
  morecomment=[l]{--},
  morecomment=[s]{--[[}{]]},
  morestring=[b]",
  morestring=[b]',
  basicstyle=\ttfamily\fontsize{\cnFontsizeCode}{9pt}\selectfont\color{color_code_text},
  commentstyle=\color{gray},
  stringstyle=\color{color_code_string},
  keywordstyle=\color{color_accent}\bfseries
}

\lstdefinelanguage{PowerShell}{
  keywords={begin,break,catch,class,continue,data,define,do,dynamicparam,else,elseif,end,exit,filter,finally,for,foreach,from,function,if,in,param,process,return,switch,throw,trap,try,until,using,var,while},
  sensitive=false,
  morecomment=[l]{\#},
  morestring=[b]",
  basicstyle=\ttfamily\fontsize{\cnFontsizeCode}{9pt}\selectfont\color{color_code_text},
  commentstyle=\color{gray},
  stringstyle=\color{color_code_string},
  keywordstyle=\color{color_accent}\bfseries
}

\lstdefinelanguage{powershell}{language=PowerShell}

\lstdefinelanguage{Dockerfile}{
  keywords={FROM,RUN,CMD,LABEL,EXPOSE,ENV,ADD,COPY,ENTRYPOINT,VOLUME,USER,WORKDIR,ARG,ONBUILD,STOPSIGNAL,HEALTHCHECK,SHELL,AS},
  sensitive=false,
  morecomment=[l]{\#},
  morestring=[b]",
  basicstyle=\ttfamily\fontsize{\cnFontsizeCode}{9pt}\selectfont\color{color_code_text},
  commentstyle=\color{gray},
  stringstyle=\color{color_code_string},
  keywordstyle=\color{color_accent}\bfseries
}

\lstdefinelanguage{Nginx}{
  keywords={server,location,listen,server_name,root,index,try_files,proxy_pass,proxy_set_header,rewrite,return,if,set,upstream,include,error_page,access_log,error_log,gzip,types,default_type},
  sensitive=false,
  morecomment=[l]{\#},
  morestring=[b]",
  basicstyle=\ttfamily\fontsize{\cnFontsizeCode}{9pt}\selectfont\color{color_code_text},
  commentstyle=\color{gray},
  stringstyle=\color{color_code_string},
  keywordstyle=\color{color_accent}\bfseries
}

\lstdefinelanguage{TOML}{
  keywords={true,false},
  sensitive=false,
  morecomment=[l]{\#},
  morestring=[b]",
  basicstyle=\ttfamily\fontsize{\cnFontsizeCode}{9pt}\selectfont\color{color_code_text},
  commentstyle=\color{gray},
  stringstyle=\color{color_code_string},
  keywordstyle=\color{color_accent}\bfseries,
  literate=
   *{=}{{{\textcolor{color_accent}{=}}}}{1}
    {[}{{{\textcolor{color_accent}{[}}}}{1}
    {]}{{{\textcolor{color_accent}{]}}}}{1}
}

\lstdefinelanguage{INI}{
  sensitive=false,
  morecomment=[l]{;},
  morecomment=[l]{\#},
  morestring=[b]",
  basicstyle=\ttfamily\fontsize{\cnFontsizeCode}{9pt}\selectfont\color{color_code_text},
  commentstyle=\color{gray},
  stringstyle=\color{color_code_string},
  keywordstyle=\color{color_accent}\bfseries,
  literate=
   *{=}{{{\textcolor{color_accent}{=}}}}{1}
    {[}{{{\textcolor{color_accent}{[}}}}{1}
    {]}{{{\textcolor{color_accent}{]}}}}{1}
}

\lstdefinelanguage{HCL}{
  keywords={resource,data,variable,output,module,provider,terraform,locals,true,false,null},
  sensitive=true,
  morecomment=[l]{\#},
  morecomment=[l]{//},
  morecomment=[s]{/*}{*/},
  morestring=[b]",
  basicstyle=\ttfamily\fontsize{\cnFontsizeCode}{9pt}\selectfont\color{color_code_text},
  commentstyle=\color{gray},
  stringstyle=\color{color_code_string},
  keywordstyle=\color{color_accent}\bfseries
}

\lstdefinelanguage{Makefile}{
  keywords={ifeq,ifneq,ifdef,ifndef,else,endif,include,override,define,endef,export,unexport,vpath},
  sensitive=true,
  morecomment=[l]{\#},
  morestring=[b]",
  basicstyle=\ttfamily\fontsize{\cnFontsizeCode}{9pt}\selectfont\color{color_code_text},
  commentstyle=\color{gray},
  stringstyle=\color{color_code_string},
  keywordstyle=\color{color_accent}\bfseries
}

\lstdefinelanguage{mk}{language=Makefile}

% --- codeblock: 代码块主环境（推荐） ---
% 功能: 语法高亮 + 行号 + 圆角边框 + 顶部文件名栏
% 参数:
%   #1 可选: 语言名（默认 Python，可用 Bash/SQL/YAML/yml/yaml/JSON/Java/Kotlin/C/C++/cpp/cxx/CSharp/csharp/cs/Rust/Go/PHP/Ruby/Swift/R/Scala/Dart/Lua/PowerShell/XML/JavaScript/TypeScript/Dockerfile/Nginx/TOML/INI/HCL/Makefile/mk 等）
%   #2 必填: 文件名标题
% 用法:
%   \begin{codeblock}[Python]{main.py}
%   print("hello")
%   \end{codeblock}
\newtcblisting{codeblock}[2][Python]{
  enhanced,
  breakable,
  listing only,
  listing engine=listings,
  colback     = color_code_bg,
  colframe    = color_border_light,
  boxrule     = 0.5pt,
  arc         = 4pt,
  outer arc   = 4pt,
  left        = 5pt,
  right       = 5pt,
  top         = 18pt,
  bottom      = 3pt,
  attach boxed title to top left = {yshift=-10pt, xshift=10pt},
  boxed title style = {boxrule=0pt, colback=color_border_light, arc=2pt, outer arc=2pt},
  coltitle    = white,
  fonttitle   = \ttfamily\fontsize{9pt}{11pt}\selectfont,
  title       = {#2},
  listing options={
    language=#1,
    aboveskip=0pt,
    belowskip=0pt
  }
}

% --- \code: 快捷命令封装 ---
% 功能: 一行命令快速插入代码块（内部转发到 codeblock 环境）
% 参数: #1 语言, #2 文件名, #3 代码正文
% 用法: \code{Python}{hello.py}{print("hello")}
% 说明: 若代码中包含大量复杂花括号/特殊字符，建议改用 codeblock 环境更稳。
\NewDocumentCommand{\code}{m m +m}{%
  \begin{codeblock}[#1]{#2}
#3
  \end{codeblock}
}

% ======================================================================
%   第十四部分: 行内代码与其他组件
% ======================================================================

% --- \inline: 行内代码 (等宽字体 + 浅背景) ---
% 用法: \inline{x = 10}
\newcommand{\inline}[1]{%
  {\ttfamily\fontsize{\cnFontsizeCode}{10pt}\selectfont%
   \colorbox{color_code_bg}{\textcolor{color_code_text}{#1}}}%
}

% --- \terminal: 终端命令风格 (黑底白字) ---
% 用法: \terminal{ls -la /home}
\newcommand{\terminal}[1]{%
  \begin{tcolorbox}[
    enhanced,
    colback     = color_terminal_bg,
    coltext     = color_terminal_text,
    colframe    = color_terminal_border,
    boxrule     = 0.5pt,
    arc         = 3pt,
    left        = 8pt,
    right       = 8pt,
    top         = 6pt,
    bottom      = 6pt
  ]
  \ttfamily\fontsize{8.5pt}{10pt}\selectfont#1
  \end{tcolorbox}
}

% --- \definition: 定义框 (用于定理、定义等) ---
% 用法: \definition{定义名}{定义内容}
\NewDocumentCommand{\definition}{m +m}{%
  \begin{tcolorbox}[
    enhanced,
    colback     = color_bg_light,
    colframe    = color_accent,
    boxrule     = 1pt,
    arc         = 4pt,
    left        = 0.8em,
    right       = 0.8em,
    top         = 0.6em,
    bottom      = 0.6em,
    attach boxed title to top left = {yshift=-2mm, xshift=5mm},
    title style = {boxrule=0pt, colback=white},
    coltitle    = color_accent,
    fonttitle   = \bfseries
  ]
  \textbf{#1}
  
  \vspace{0.3em}
  
  #2
  \end{tcolorbox}
}

% --- \algorithm: 算法框 ---
% 用法: \algorithm{算法描述}
\NewDocumentCommand{\algorithm}{+m}{%
  \begin{tcolorbox}[
    enhanced,
    colback     = color_algorithm_bg,
    colframe    = color_algorithm_border,
    boxrule     = 1pt,
    arc         = 4pt,
    left        = 0.8em,
    right       = 0.8em,
    top         = 0.6em,
    bottom      = 0.6em,
    attach boxed title to top left = {yshift=-2mm, xshift=5mm},
    title style = {boxrule=0pt, colback=white},
    coltitle    = color_algorithm_border,
    fonttitle   = \bfseries
  ]
  {Algorithm}
  
  \vspace{0.3em}
  
  #1
  \end{tcolorbox}
}

% --- \shortcut: 快捷键风格 ---
% 用法: \shortcut{Ctrl + S}
\newcommand{\shortcut}[1]{%
  {\small\sffamily%
   % [QUICK-EDIT:SHORTCUT-BASELINE] 若仍偏上/偏下，可微调 baseline 的锚点或 inner ysep
   \tikz[baseline=(shortcutnode.base)]{
     \node[
       name=shortcutnode,
       rounded rectangle,
       draw=color_accent,
       fill=color_accent!10,
       line width=0.5pt,
       inner xsep=6pt,
       inner ysep=3pt,
       font=\ttfamily\fontsize{9pt}{11pt}\selectfont
     ] {#1};
   }%
  }%
}

% ======================================================================
%   第十五部分: 其他实用命令
% ======================================================================

% --- \file: 文件路径样式 ---
% 用法: \file{/home/user/config.txt}
\newcommand{\file}[1]{%
  {\ttfamily\fontsize{9pt}{11pt}\selectfont\textcolor{color_accent}{#1}}%
}

% --- \highlight: 文本高亮 ---
% 用法: \highlight{重点内容}
\newcommand{\highlight}[1]{%
  {\tikz[baseline=(cnhighlight.base)]{
    \node[
      name=cnhighlight,
      fill=color_accent!20,
      rounded corners=2pt,
      inner xsep=3pt,
      inner ysep=1pt
    ] {#1};
  }}%
}

% --- \emphasis: 强调 (楷体 + 颜色) ---
% 用法: \emphasis{强调内容}
\newcommand{\emphasis}[1]{%
  {{\cnEmphasisFont\textcolor{color_accent}{#1}}}%
}

\endinput
% ======================================================================
%   computer-notes.cls 结束
% ======================================================================
