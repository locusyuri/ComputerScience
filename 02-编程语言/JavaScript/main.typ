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


#part("JS & TS 核心基础")
#include "chapters/核心基础.typ"

#part("JavaScript 核心特性")
#include "chapters/核心特性.typ"

#part("TypeScript 类型系统与高级特性")

#part("标准库与常用 API")

#part("浏览器端 JavaScript")

#part("Node.js")

#part("JavaScript 工程化")

#part("JavaScript 底层原理")


