#import "../../99-索引与模板/TypstTemplate/computer-notes.typ": *


// ── 文档元信息 ──
#set document(
  title: "Vue",
  author: "Violet",
  date: datetime.today(),
)

// 应用全局样式
#show: apply-style


// ══════════════════════════════════════════════════════════════════════
// 封面
// ══════════════════════════════════════════════════════════════════════

#make-cover(
  "Vue",
  "Violet",
  date: datetime.today().display(),
)

// 目录
#make-outline(depth: 3)





// 目录

// ─────────────────────────────────────────────────────────────────────
// Part 1：Vue 3 核心基础（Composition API）
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：Vue 3 入门与环境搭建 🔶
// 1.1 Vue 演进史：Vue 2 → Vue 3、Options API → Composition API、为什么需要 Composition API
// 1.2 开发环境搭建：Node.js、Vite、VS Code + Volar、Vue DevTools
// 1.3 第一个应用：create-vue、项目结构、单文件组件（SFC）
// 1.4 响应式基础：ref、reactive、toRef/toRefs、响应式原理简述

// Chapter 2：Composition API 核心 🔶
// 2.1 setup 语法糖：<script setup>、顶层绑定、defineProps/defineEmits
// 2.2 生命周期钩子：onMounted/onUnmounted、与 Options API 对比
// 2.3 计算属性与侦听器：computed、watch/watchEffect、深度监听
// 2.4 模板引用：ref 获取 DOM/组件实例、template refs
// 2.5 依赖注入：provide/inject、跨层级通信

// Chapter 3：组件系统 🔶
// 3.1 组件注册：全局注册、局部注册、自动导入（unplugin-vue-components）
// 3.2 Props 与 Emits：类型声明、默认值、验证、v-model 双向绑定
// 3.3 插槽（Slots）：默认插槽、具名插槽、作用域插槽
// 3.4 异步组件：defineAsyncComponent、Suspense、懒加载
// 3.5 组件通信：props/emits、provide/inject、mitt 事件总线、Pinia

// Chapter 4：指令与过渡动画 ⚪
// 4.1 内置指令：v-if/v-show、v-for、v-bind/v-on、v-model、v-slot
// 4.2 自定义指令：directive 注册、钩子函数、实战示例
// 4.3 过渡系统：<Transition>、CSS 过渡/动画、JavaScript 钩子
// 4.4 列表过渡：<TransitionGroup>、FLIP 动画、性能优化

// ─────────────────────────────────────────────────────────────────────
// Part 2：Vue 官方生态（路由、状态管理、持久化）
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：Vue Router 路由管理 🔶
// 1.1 路由基础：安装配置、路由表、router-link/router-view
// 1.2 动态路由：路径参数、查询参数、路由守卫（全局/路由独享/组件内）
// 1.3 嵌套路由：children 配置、命名视图、重定向与别名
// 1.4 编程式导航：push/replace/go、路由元信息、滚动行为
// 1.5 高级特性：路由懒加载、权限控制、KeepAlive 缓存

// Chapter 2：Pinia 状态管理 🔶
// 2.1 Pinia 简介：为什么取代 Vuex、核心概念（Store、State、Getter、Action）
// 2.2 定义 Store：defineStore、Setup Stores vs Options Stores
// 2.3 使用 Store：storeToRefs、解构保持响应式、$patch 批量更新
// 2.4 模块化设计：多 Store 组织、Store 间调用、持久化插件
// 2.5 高级用法：订阅（$subscribe）、插件开发、SSR 支持

// Chapter 3：数据持久化 ⚪
// 3.1 localStorage/sessionStorage：pinia-plugin-persistedstate
// 3.2 IndexedDB：idb-keyval、大型数据存储
// 3.3 Service Worker：离线缓存、PWA 支持
// 3.4 服务端同步：SWR 模式、TanStack Query（Vue Query）

// Chapter 4：HTTP 请求与 API 管理 🔶
// 4.1 Axios 集成：拦截器、错误处理、请求取消
// 4.2 Fetch API：原生 fetch、AbortController、Streaming
// 4.3 API 层设计：模块化、TypeScript 类型、Mock 数据
// 4.4 实时通信：WebSocket、Socket.io、SSE（Server-Sent Events）

// ─────────────────────────────────────────────────────────────────────
// Part 3：现代 UI 库与 Shadcn-vue
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：UI 库演进与 Shadcn 崛起 🔶
// 1.1 传统 UI 库困境：Element UI/Ant Design、体积臃肿、样式覆盖困难、定制性差
// 1.2 Shadcn 理念：不是组件库而是代码集合、Copy-Paste、完全可控、Tailwind CSS
// 1.3 Shadcn 优势：零运行时开销、无障碍访问（a11y）、主题定制、Tree-Shaking
// 1.4 生态对比：Radix UI（Headless）、Reka UI（Vue 版）、Shadcn/ui（React）、Shadcn-vue

// Chapter 2：Shadcn-vue 快速上手 🔶
// 2.1 环境准备：Vue 3 + TypeScript + Vite + Tailwind CSS
// 2.2 初始化 Shadcn：shadcn-vue init、配置文件（components.json）
// 2.3 添加组件：shadcn add button、按需引入、组件结构解析
// 2.4 主题定制：tailwind.config.js、CSS 变量、暗色模式
// 2.5 图标集成：Lucide Icons、Iconify、自定义 SVG

// Chapter 3：Shadcn-vue 核心组件 🔶
// 3.1 基础组件：Button、Input、Textarea、Label、Checkbox、Radio
// 3.2 数据展示：Table、Card、Badge、Avatar、Separator
// 3.3 反馈组件：Alert、Toast、Dialog、Sheet、Skeleton、Progress
// 3.4 导航组件：Navigation Menu、Tabs、Breadcrumb、Pagination
// 3.5 表单组件：Form（VeeValidate/Zod）、Select、Combobox、DatePicker

// Chapter 4：Shadcn-vue 高级用法 ⚪
// 4.1 组合式组件：构建复杂 UI、Compound Components 模式
// 4.2 自定义 Hook：useToast、useMediaQuery、复用逻辑
// 4.3 性能优化：虚拟滚动、懒加载、代码分割
// 4.4 无障碍访问：ARIA 属性、键盘导航、屏幕阅读器支持
// 4.5 国际化：vue-i18n 集成、多语言切换

// Chapter 5：其他现代 UI 方案 ⚪
// 5.1 Headless UI：无样式组件、完全自定义、Vue 官方推荐
// 5.2 PrimeVue：企业级组件库、主题丰富、DataTable 强大
// 5.3 Naive UI：TypeScript 优先、主题定制、中文文档友好
// 5.4 选择指南：场景分析、团队规模、定制需求、 bundle 大小

// ─────────────────────────────────────────────────────────────────────
// Part 4：工程化与最佳实践
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：TypeScript 集成 🔶
// 1.1 类型声明：Props、Emits、Slots、Expose、Ref
// 1.2 泛型组件：通用列表、表格、表单封装
// 1.3 工具类型：Partial、Pick、Omit、ReturnType
// 1.4 类型安全：Zod 验证、运行时类型检查

// Chapter 2：Vite 构建优化 🔶
// 2.1 Vite 原理：ESBuild、Rollup、HMR、预构建
// 2.2 插件系统：unplugin-auto-import、unplugin-vue-components、vite-plugin-pages
// 2.3 优化策略：代码分割、懒加载、Tree-Shaking、Gzip/Brotli
// 2.4 环境变量：.env 文件、模式切换、类型安全

// Chapter 3：测试与质量保障 ⚪
// 3.1 单元测试：Vitest、Vue Test Utils、组件测试
// 3.2 E2E 测试：Playwright/Cypress、用户流程测试
// 3.3 代码规范：ESLint、Prettier、Stylelint、Husky
// 3.4 CI/CD：GitHub Actions、自动化测试、部署流水线

// Chapter 4：性能优化 🔶
// 4.1 渲染优化：v-memo、keep-alive、虚拟列表、防抖节流
// 4.2 Bundle 优化：分包策略、CDN 加速、图片优化、字体优化
// 4.3 运行时性能：Chrome DevTools、Lighthouse、Web Vitals
// 4.4 SSR/SSG：Nuxt 3、预渲染、增量静态生成

// ─────────────────────────────────────────────────────────────────────
// Part 5：Vue 2 兼容与迁移（选学）
// ─────────────────────────────────────────────────────────────────────

// Chapter 1：Options API 回顾 ⚪
// 1.1 选项式结构：data、methods、computed、watch、生命周期
// 1.2 Mixins 与 HOC：代码复用、命名冲突、维护困难
// 1.3 this 上下文：指向问题、箭头函数陷阱
// 1.4 常见模式：高阶组件、作用域插槽、递归组件

// Chapter 2：Vue 2 → Vue 3 迁移 ⚪
// 2.1 破坏性变更：全局 API、v-model、v-if/v-for 优先级、过滤器移除
// 2.2 迁移工具：@vue/compat、渐进式迁移、兼容性构建
// 2.3 Composition API 迁移：重构策略、逐步替换、混合使用
// 2.4 生态迁移：Vue Router 4、Vuex → Pinia、Element Plus





// 目录
