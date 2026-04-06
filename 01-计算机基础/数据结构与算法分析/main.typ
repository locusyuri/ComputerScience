#import "../../99-索引与模板/TypstTemplate/computer-notes.typ": *


// ── 文档元信息 ──
#set document(
  title: "数据结构与算法分析",
  author: "Violet",
  date: datetime.today(),
)

// 应用全局样式
#show: apply-style


// ══════════════════════════════════════════════════════════════════════
// 封面
// ══════════════════════════════════════════════════════════════════════

#make-cover(
  "数据结构与算法分析",
  "Violet",
  date: datetime.today().display(),
)

// 目录
#make-outline(depth: 3)


#part("数据结构与算法基础")

#part("线性数据结构")

#part("树")

#part("图")

#part("算法设计")

#part("查找与排序")

#part("高级数据结构")