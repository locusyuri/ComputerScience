#import "../../99-索引与模板/TypstTemplate/computer-notes.typ": *


// ── 文档元信息 ──
#set document(
  title: "网络安全",
  author: "Violet",
  date: datetime.today(),
)

// 应用全局样式
#show: apply-style


// ══════════════════════════════════════════════════════════════════════
// 封面
// ══════════════════════════════════════════════════════════════════════

#make-cover(
  "网络安全",
  "Violet",
  date: datetime.today().display(),
)

// 目录
#make-outline(depth: 3)

#part("密码学基础")
#include "chapters/密码学基础.typ"
