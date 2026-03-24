// =============================================================================
// Typst 计算机学科笔记模板 - 完整版本
// 作者: Copilot
// 版本: 1.0
// =============================================================================

// ==================== 全局文档配置 ====================
#set document(
  title: "计算机科学笔记",
  author: "CatMono",
  date: auto,
)

// ==================== 颜色定义 ====================
// 说明：统一颜色集合，引用方式固定为 color.xxx，便于全局换色。
#let color = (
  // 文档基础色
  page_bg: rgb("#fefdfd"),
  text_primary: rgb("#1a1a1a"),
  text_secondary: rgb("#222222"),
  text_muted: rgb("#666"),
  text_soft: rgb("#555"),
  text_caption: rgb("#999"),
  // 主题色
  heading: rgb("#0d47a1"),
  accent: rgb("#1976d2"),
  // 边框与容器
  border: rgb("#e0e0e0"),
  code_bg: rgb("#f5f5f5"),
  code_header_bg: rgb("#e8e8e8"),
  // 代码与键帽
  inline_code_text: rgb("#c41f0f"),
  code_text: rgb("#121212"),
  key_bg: rgb("#f5f5f5"),
  key_border: rgb("#999"),
  key_text: rgb("#333"),
  // 终端
  terminal_bg: rgb("#1e1e1e"),
  terminal_border: rgb("#444"),
  terminal_text: rgb("#00ff00"),
  // 组件块
  callout_body_text: rgb("#2b2b2b"),
  definition_bg: rgb("#f0f4ff"),
  algorithm_bg: rgb("#f9f9f9"),
  algorithm_border: rgb("#424242"),
  // 封面
  cover_grad_start: rgb("#f5f5f5"),
  cover_grad_end: rgb("#e8e8f0"),
  // Callout 配色
  note_bg: rgb("#e3f2fd"),
  note_border: rgb("#2196f3"),
  tip_bg: rgb("#f3e5f5"),
  tip_border: rgb("#9c27b0"),
  info_bg: rgb("#e0f2f1"),
  info_border: rgb("#009688"),
  warning_bg: rgb("#fff3e0"),
  warning_border: rgb("#ff9800"),
  caution_bg: rgb("#fce4ec"),
  caution_border: rgb("#e91e63"),
  danger_bg: rgb("#ffebee"),
  danger_border: rgb("#f44336"),
  todo_bg: rgb("#f1f8e9"),
  todo_border: rgb("#689f38"),
)

// ==================== 字体定义 ====================
// 说明：统一把字体集中在一个集合中，引用方式固定为 font.xxx。
// 这样可以避免零散变量，后续替换字体时只改这一处。
#let font = (
  // 默认正文中文字体（全局 #set text 使用）
  zh_default: "TW-Sung",
  // 标题字体
  heading_zh: "STKaiti",
  heading_en: "Candara",
  // 正文字体
  body_zh: "TW-Sung",
  body_en: "Merriweather",
  // Callout 提示框字体
  callout_zh: "LXGW WenKai Screen",
  callout_en: "Segoe UI",
  // 代码等宽字体（用于代码块、行内代码、终端、快捷键）
  code_mono: "Constantia",
)

// Callout 颜色配置
#let callout_colors = (
  note: (bg: color.note_bg, border: color.note_border, icon: "📝"),
  tip: (bg: color.tip_bg, border: color.tip_border, icon: "💡"),
  info: (bg: color.info_bg, border: color.info_border, icon: "🛈"),
  warning: (bg: color.warning_bg, border: color.warning_border, icon: "⚠"),
  caution: (bg: color.caution_bg, border: color.caution_border, icon: "⚡"),
  danger: (bg: color.danger_bg, border: color.danger_border, icon: "⛔"),
  todo: (bg: color.todo_bg, border: color.todo_border, icon: "✓"),
)

// ==================== 行内代码样式 ====================
#let inline_code(code_content) = box(
  fill: color.code_bg,
  inset: (x: 4pt, y: 2pt),
  radius: 3pt,
  stroke: 1pt + color.border,
  text(
    font: font.code_mono,
    size: 10pt,
    fill: color.inline_code_text,
    weight: "regular",
  )[#code_content],
)

// ==================== 代码块组件 ====================
// 调用方式：#codeBlock("python", "filename.py")[代码内容]
#let codeBlock(lang, filename, body) = {
  block(
    fill: color.code_bg,
    stroke: 1pt + color.border,
    radius: 6pt,
    inset: 0pt,
    spacing: 0pt,
  )[
    // 顶部文件名栏
    #if filename != "" {
      box(
        width: 100%,
        fill: color.code_header_bg,
        inset: (x: 12pt, y: 8pt),
        radius: (top: 6pt),
        text(
          font: font.code_mono,
          size: 9pt,
          weight: "bold",
          fill: color.text_soft,
        )[
          📄 #filename
          #if lang != "" {
            h(1fr)
            text(size: 8pt, fill: color.text_caption)[#lang]
          }
        ],
      )
    }

    // 代码内容
    box(
    width: 100%,
    inset: (x: 12pt, y: 10pt),
    radius: (bottom: 6pt),
    text(
    font: font.code_mono,
    size: 9pt,
    fill: color.code_text,
    weight: "regular",
    )[
    #align(left)[#body]
    ],
    )
  ]
}

// ==================== Callout 提示框 (7种类型) ====================
// 使用示例：#note[内容], #tip[内容], 等

// 通用 Callout 生成函数
#let create_callout(title, icon, bg_color, border_color, content) = {
  block(
    fill: bg_color,
    stroke: 2pt + border_color,
    radius: 6pt,
    inset: (x: 12pt, y: 10pt),
    spacing: 0.8em,
  )[
    // 标题行
    #text(
      font: (font.callout_en, font.callout_zh),
      size: 11pt,
      weight: "bold",
      fill: border_color,
    )[
      #icon #title
    ]

    // 内容
    #text(
      font: (font.callout_en, font.callout_zh),
      size: 10pt,
      fill: color.callout_body_text,
    )[
      #content
    ]
  ]
}

// 7 种 Callout 的简便调用
#let note(body) = create_callout(
  "笔记",
  "📝",
  callout_colors.note.bg,
  callout_colors.note.border,
  body,
)

#let tip(body) = create_callout(
  "技巧",
  "💡",
  callout_colors.tip.bg,
  callout_colors.tip.border,
  body,
)

#let info(body) = create_callout(
  "信息",
  "ℹ",
  callout_colors.info.bg,
  callout_colors.info.border,
  body,
)

#let warning(body) = create_callout(
  "警告",
  "⚠",
  callout_colors.warning.bg,
  callout_colors.warning.border,
  body,
)

#let caution(body) = create_callout(
  "注意",
  "⚡",
  callout_colors.caution.bg,
  callout_colors.caution.border,
  body,
)

#let danger(body) = create_callout(
  "危险",
  "⛔",
  callout_colors.danger.bg,
  callout_colors.danger.border,
  body,
)

#let todo(body) = create_callout(
  "待办",
  "✓",
  callout_colors.todo.bg,
  callout_colors.todo.border,
  body,
)

// ==================== 定义框 & 算法框 ====================
// 定义框：高亮关键术语
#let definition(term, def_content) = {
  block(
    fill: color.definition_bg,
    stroke: 2pt + color.accent,
    radius: 6pt,
    inset: (x: 12pt, y: 10pt),
  )[
    #text(
      font: (font.heading_en, font.heading_zh),
      size: 11pt,
      weight: "bold",
      fill: color.accent,
    )[
      // 定义：#term
    ]
    #v(0.3em)
    #text(
      font: (font.body_en, font.body_zh),
      size: 10pt,
    )[
      #def_content
    ]
  ]
}

// 算法框：伪代码展示
#let algorithm(title, steps) = {
  block(
    fill: color.algorithm_bg,
    stroke: 2pt + color.algorithm_border,
    radius: 6pt,
    inset: (x: 12pt, y: 10pt),
  )[
    #text(
      font: (font.heading_en, font.heading_zh),
      size: 11pt,
      weight: "bold",
    )[
      🔹 #title
    ]
    #v(0.6em)
    #text(
      font: (font.body_en, font.body_zh),
      size: 10pt,
    )[
      #steps
    ]
  ]
}

// ==================== 快捷键样式 ====================
// 调用：#key("Ctrl") + #key("C")
#let key(k) = box(
  fill: color.key_bg,
  stroke: 1pt + color.key_border,
  radius: 2pt,
  inset: (x: 5pt, y: 2pt),
  text(
    font: font.code_mono,
    size: 9pt,
    weight: "bold",
    fill: color.key_text,
  )[#k],
)

// ==================== 命令行 / 终端样式 ====================
#let terminal(body) = block(
  fill: color.terminal_bg,
  stroke: 1pt + color.terminal_border,
  radius: 6pt,
  inset: (x: 12pt, y: 10pt),
)[
  #text(
    font: font.code_mono,
    size: 9pt,
    fill: color.terminal_text,
    weight: "regular",
  )[
    > #body
  ]
]

// ==================== 封面生成函数 ====================
#let make_cover(
  title,
  subtitle: "计算机科学笔记",
  author: "学生",
  date_str: "2026年3月",
) = {
  page(
    background: rect(
      width: 100%,
      height: 100%,
      fill: gradient.linear(
        color.cover_grad_start,
        color.cover_grad_end,
        angle: 135deg,
      ),
    ),
  )[
    #v(8em)

    // 主标题
    #align(center)[
      #text(
        size: 42pt,
        weight: "bold",
        font: (font.heading_en, font.heading_zh),
        fill: color.heading,
      )[
        #title
      ]
    ]

    #v(1em)

    // 副标题
    #align(center)[
      #text(
        size: 18pt,
        weight: "regular",
        font: (font.body_en, font.body_zh),
        fill: color.text_muted,
      )[
        #subtitle
      ]
    ]

    #v(4em)

    // 分割线
    #align(center)[
      #line(length: 4cm, stroke: 1pt + color.accent)
    ]

    #v(2em)

    // 作者与日期
    #align(center)[
      #text(
        size: 12pt,
        font: (font.body_en, font.body_zh),
        fill: color.text_soft,
        [
          #author \
          #date_str
        ],
      )
    ]

    #v(1fr)
  ]
}

// ==================== 导出模板入口（解决 import 不应用样式） ====================
// 用法：
// 1) #import "style.typ": *
// 2) #show: applyStyle
// 说明：Typst 的 #import 只导入符号，不会自动把本文件顶层 #set/#show 作用到调用文档。
// 因此提供 applyStyle 作为显式样式入口，让 import 场景也能稳定生效。
#let applyStyle(body) = {
  set document(
    title: "计算机科学笔记",
    author: "CatMono",
    date: auto,
  )

  set page(
    paper: "a4",
    margin: (left: 2cm, right: 2cm, top: 2.5cm, bottom: 2.5cm),
    background: rect(
      width: 100%,
      height: 100%,
      fill: color.page_bg,
    ),
  )

  set text(
    font: font.zh_default,
    size: 11pt,
    lang: "zh",
    fill: color.text_primary,
  )

  set heading(numbering: "1.")

  show heading.where(level: 1): it => {
    v(1.5em)
    align(center)[
      text(
      size: 30pt,
      weight: "bold",
      font: (font.heading_en, font.heading_zh),
      fill: color.heading,
      )[
      #it.body
      ]
    ]
    v(0.8em)
  }

  show heading.where(level: 2): it => {
    v(1.2em)
    text(
      size: 18pt,
      weight: "bold",
      font: (font.heading_en, font.heading_zh),
      fill: color.heading,
    )[
      #it.body
    ]
    v(0.6em)
  }

  show heading.where(level: 3): it => {
    v(1em)
    text(
      size: 14pt,
      weight: "bold",
      font: (font.heading_en, font.heading_zh),
      fill: color.accent,
    )[
      #it.body
    ]
    v(0.4em)
  }

  show heading.where(level: 4): it => {
    v(0.8em)
    text(
      size: 12pt,
      weight: "bold",
      font: (font.heading_en, font.heading_zh),
      fill: color.text_secondary,
    )[
      #it.body
    ]
    v(0.3em)
  }

  show heading.where(level: 5): it => {
    text(
      size: 11pt,
      weight: "bold",
      font: (font.heading_en, font.heading_zh),
      fill: color.text_secondary,
    )[#it.body]
  }

  show heading.where(level: 6): it => {
    text(
      size: 11pt,
      weight: "regular",
      font: (font.heading_en, font.heading_zh),
      fill: color.text_secondary,
    )[#it.body]
  }

  set par(justify: true, leading: 1.6em)

  set enum(
    numbering: "1.",
    indent: 1.5em,
    body-indent: 0.5em,
    spacing: 0.8em,
  )

  set list(
    marker: ([•], [◦], [▪]),
    indent: 1.5em,
    body-indent: 0.5em,
    spacing: 0.8em,
  )

  set page(
    header: context {
      set text(size: 9pt, fill: color.text_caption)
      set align(center)

      grid(
        columns: (1fr, 1fr),
        [计算机科学笔记], align(right)[第 #counter(page).display() 页],
      )

      line(length: 100%, stroke: 0.5pt + color.border)
    },

    footer: context {
      set text(size: 9pt, fill: color.text_caption)
      set align(center)

      text[
        作者 | 第 #counter(page).display() 页 | #datetime.today().display("[year]-[month]-[day]")
      ]
    },
  )

  set math.equation(numbering: "(1)")

  body
}

