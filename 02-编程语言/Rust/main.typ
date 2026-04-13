#import "../../99-索引与模板/TypstTemplate/computer-notes.typ": *


// ── 文档元信息 ──
#set document(
  title: "Rust",
  author: "Violet",
  date: datetime.today(),
)

// 应用全局样式
#show: apply-style

// ══════════════════════════════════════════════════════════════════════
// 封面
// ══════════════════════════════════════════════════════════════════════

#make-cover(
  "Rust",
  "Violet",
  date: datetime.today().display(),
)

// 目录
#make-outline(depth: 2)


#part("Rust 核心基础")
#include "chapters/Rust核心基础.typ"

#part("核心标准库与常用工具")

#part("高级特性与元编程")

#part("并发编程")

#part("网络编程")

#part("底层原理与性能调优")