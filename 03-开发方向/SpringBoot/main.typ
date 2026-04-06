#import "../../99-索引与模板/TypstTemplate/computer-notes.typ": *


// ── 文档元信息 ──
#set document(
  title: "Spring Boot",
  author: "Violet",
  date: datetime.today(),
)

// 应用全局样式
#show: apply-style


// ══════════════════════════════════════════════════════════════════════
// 封面
// ══════════════════════════════════════════════════════════════════════

#make-cover(
  "Spring Boot",
  "Violet",
  date: datetime.today().display(),
)

// 目录
#make-outline(depth: 3)


#part("Spring Boot 基础")

#part("Spring Boot 核心")
#include "chapters/Web开发核心.typ"
#include "chapters/数据访问与持久层框架.typ"
#include "chapters/安全与认证授权.typ"


#part("微服务与中间件")
#include "chapters/微服务架构基础.typ"

#part("Spring Boot 源码")
