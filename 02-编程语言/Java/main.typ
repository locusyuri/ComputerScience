#import "../../99-索引与模板/TypstTemplate/computer-notes.typ": *


// ── 文档元信息 ──
#set document(
  title: "Java",
  author: "Violet",
  date: datetime.today(),
)

// 应用全局样式
#show: apply-style


// ══════════════════════════════════════════════════════════════════════
// 封面
// ══════════════════════════════════════════════════════════════════════

#make-cover(
  "Java",
  "Violet",
  date: datetime.today().display(),
)

// 目录
#make-outline(depth: 3)


#part("Java & Kotlin 核心基础")

#part("JVM 标准库与常用工具")

#part("高级特性与函数式编程")

#part("并发编程")

#part("网络编程与高性能 IO")

#part("JVM 底层原理与性能调优")
