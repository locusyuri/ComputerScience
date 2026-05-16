#import "../../99-索引与模板/TypstTemplate/computer-notes.typ": *


// ── 文档元信息 ──
#set document(
  title: "计算机组成原理",
  author: "Violet",
  date: datetime.today(),
)

// 应用全局样式
#show: apply-style

// ══════════════════════════════════════════════════════════════════════
// 封面
// ══════════════════════════════════════════════════════════════════════

#make-cover(
  "计算机组成原理",
  "Violet",
  date: datetime.today().display(),
)

// 目录
#make-outline(depth: 2)
