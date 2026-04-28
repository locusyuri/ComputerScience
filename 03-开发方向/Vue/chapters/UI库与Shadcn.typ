#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= UI 库演进与 Shadcn 崛起

UI 组件库是前端开发的核心基础设施。从传统的 Element UI、Ant Design 到现代的 Shadcn-vue，UI 库的理念和实现方式发生了巨大变化。

== 传统 UI 库困境

在 Shadcn 出现之前，主流 UI 库（Element UI、Ant Design、Vuetify 等）面临诸多问题。

=== 体积臃肿

```javascript
// Element Plus 完整引入
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'

// Bundle 大小分析
// element-plus: ~1.2MB (uncompressed)
// 即使 Tree-Shaking 后，仍然有数百 KB
```

*问题分析*：

#tex-table(
  ("问题", "影响", "示例"),
  ("完整 CSS", "首屏加载慢", "~400KB CSS"),
  ("未使用的组件", "Bundle 过大", "只用了 Button，却打包了所有组件"),
  ("依赖过多", "间接依赖膨胀", "dayjs、lodash 等"),
)

#caution[
  传统 UI 库即使用了按需导入，仍然会引入大量未使用的样式和工具函数。
]

=== 样式覆盖困难

```css
/* 覆盖 Element UI 样式 */
.el-button {
  /* 需要 !important 或更高优先级 */
  background-color: #ff0000 !important;
}

/* 深度选择器 */
::v-deep .el-input__inner {
  border-radius: 8px;
}

/* Scoped CSS 中的覆盖 */
<style scoped>
.my-component :deep(.el-button) {
  color: blue;
}
</style>
```

*痛点*：

1. *CSS 优先级战争*：需要 `!important` 或复杂的选择器
2. *Scoped CSS 限制*：需要使用 `::v-deep`、`:deep()` 等穿透语法
3. *主题定制复杂*：需要修改 Sass 变量或提供完整的主题包
4. *版本升级风险*：内部类名可能改变，导致样式失效

#note[
  传统 UI 库的样式封装过度，导致定制化成本极高。
]

=== 定制性差

```vue
<!-- Element UI Button -->
<el-button type="primary">按钮</el-button>

<!-- 想要完全自定义？很难 -->
<!-- 只能覆盖样式，无法改变结构 -->
<!-- 无法添加额外的 DOM 节点 -->
<!-- 无法控制内部的 class 命名 -->
```

*限制*：

- *固定 DOM 结构*：无法修改组件内部的 HTML 结构
- *固定的 Class 命名*：BEM 命名规范，无法自定义
- *有限的 Props*：只能通过提供的 props 配置，无法扩展
- *黑盒实现*：内部逻辑不透明，难以调试

#tip[
  传统 UI 库适合快速原型开发，但不适合高度定制化的产品。
]

== Shadcn 理念

Shadcn 不是传统意义上的 UI 库，而是一种全新的组件构建理念。

=== 不是组件库而是代码集合

```bash
# 传统 UI 库：npm install
npm install element-plus

# Shadcn：复制代码到你的项目
npx shadcn-vue@latest add button

# 结果：组件代码直接复制到 src/components/ui/button.vue
# 你拥有完全的代码控制权
```

*核心理念对比*：

#tex-table(
  ("特性", "传统 UI 库", "Shadcn"),
  ("安装方式", "npm install", "复制代码到项目"),
  ("代码所有权", "第三方依赖", "你的代码"),
  ("定制难度", "高（覆盖样式）", "低（直接修改代码）"),
  ("更新方式", "npm update", "手动合并或重新添加"),
  ("Bundle 大小", "包含所有组件", "只包含使用的组件"),
  ("学习曲线", "学习 API", "学习代码本身"),
)

#note[
  Shadcn 的本质是「可复制的代码片段」，而不是「安装的依赖包」。
]

=== Copy-Paste 工作流

```bash
# 1. 初始化（一次性）
npx shadcn-vue@latest init

# 2. 添加组件（按需）
npx shadcn-vue@latest add button
npx shadcn-vue@latest add dialog
npx shadcn-vue@latest add table

# 3. 代码出现在项目中
src/
├── components/
│   └── ui/
│       ├── button/
│       │   ├── Button.vue
│       │   └── index.ts
│       ├── dialog/
│       │   ├── Dialog.vue
│       │   └── ...
│       └── table/
│           └── ...
```

*优势*：

1. *完全可控*：代码在你的项目中，可以随意修改
2. *零抽象*：没有黑盒，所有逻辑可见
3. *类型安全*：TypeScript 支持，IDE 自动补全
4. *无运行时依赖*：不需要额外的 JS bundle

=== 基于 Tailwind CSS

```vue
<!-- Shadcn Button 源码 -->
<template>
  <button
    :class="cn(
      'inline-flex items-center justify-center rounded-md text-sm font-medium',
      'ring-offset-background transition-colors',
      'focus-visible:outline-none focus-visible:ring-2',
      'focus-visible:ring-ring focus-visible:ring-offset-2',
      'disabled:pointer-events-none disabled:opacity-50',
      variantClass,
      sizeClass,
      $attrs.class
    )"
  >
    <slot />
  </button>
</template>

<script setup lang="ts">
import { cn } from '@/lib/utils'
// ... props 定义
</script>
```

*Tailwind 优势*：

- *Utility-first*：直接使用原子类，无需编写 CSS
- *设计系统*：通过 `tailwind.config.js` 统一定义颜色、间距等
- *响应式*：内置响应式前缀（`sm:`、`md:`、`lg:`）
- *暗色模式*：`dark:` 前缀轻松实现主题切换
- *Tree-Shaking*：PurgeCSS 自动移除未使用的类

#tip[
  Tailwind CSS + Shadcn = 极致的样式定制能力 + 零运行时开销
]

== Shadcn 优势

=== 零运行时开销

```javascript
// 传统 UI 库
import { ElButton } from 'element-plus'
// → 引入整个 Element Plus 运行时
// → 包括事件处理、状态管理、动画系统等

// Shadcn
import Button from '@/components/ui/button/Button.vue'
// → 只引入一个 Vue 组件
// → 没有任何额外的运行时依赖
```

*Bundle 对比*：

#tex-table(
  ("方案", "Button 组件", "额外依赖", "总大小"),
  ("Element Plus", "~5KB", "~1.2MB", "~1.2MB"),
  ("Ant Design Vue", "~4KB", "~800KB", "~800KB"),
  ("Shadcn-vue", "~2KB", "0KB", "~2KB"),
)

#caution[
  Shadcn 的 Bundle 大小只包含你实际使用的组件，没有隐藏成本。
]

=== 无障碍访问（a11y）

Shadcn 基于 Radix UI / Reka UI，这些 Headless UI 库专注于无障碍。

```vue
<!-- Reka UI Dialog（Shadcn 底层） -->
<DialogRoot>
  <DialogTrigger as-child>
    <Button>打开对话框</Button>
  </DialogTrigger>

  <DialogPortal>
    <DialogOverlay class="fixed inset-0 bg-black/50" />
    <DialogContent
      class="fixed top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2"
      role="dialog"
      aria-modal="true"
      aria-labelledby="dialog-title"
    >
      <DialogTitle id="dialog-title">标题</DialogTitle>
      <DialogDescription>描述</DialogDescription>

      <!-- 自动焦点管理 -->
      <!-- 自动 ESC 关闭 -->
      <!-- 自动 Trap Focus -->
    </DialogContent>
  </DialogPortal>
</DialogRoot>
```

*a11y 特性*：

- ✅ *键盘导航*：Tab、Enter、Escape 等快捷键
- ✅ *焦点管理*：自动聚焦、焦点陷阱
- ✅ *ARIA 属性*：role、aria-label、aria-describedby
- ✅ *屏幕阅读器*：完整的语义化支持
- ✅ *颜色对比度*：符合 WCAG 标准

#note[
  无障碍访问不是可选功能，而是现代 Web 应用的必备要求。
]

=== 主题定制

```javascript
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        border: 'hsl(var(--border))',
        input: 'hsl(var(--input))',
        ring: 'hsl(var(--ring))',
        background: 'hsl(var(--background))',
        foreground: 'hsl(var(--foreground))',
        primary: {
          DEFAULT: 'hsl(var(--primary))',
          foreground: 'hsl(var(--primary-foreground))',
        },
        // ... 更多颜色
      },
    },
  },
}
```

```css
/* globals.css */
:root {
  --background: 0 0% 100%;
  --foreground: 222.2 84% 4.9%;
  --primary: 222.2 47.4% 11.2%;
  --primary-foreground: 210 40% 98%;
  /* ... */
}

.dark {
  --background: 222.2 84% 4.9%;
  --foreground: 210 40% 98%;
  --primary: 210 40% 98%;
  --primary-foreground: 222.2 47.4% 11.2%;
  /* ... */
}
```

*定制流程*：

1. 修改 CSS 变量（全局主题）
2. 修改 `tailwind.config.js`（设计系统）
3. 直接修改组件代码（局部定制）

#tip[
  三层定制能力：全局主题 → 设计系统 → 组件代码，灵活性极高。
]

=== Tree-Shaking 友好

```javascript
// Vite + Rollup 自动 Tree-Shaking

// 只导入使用的组件
import Button from '@/components/ui/button/Button.vue'
import Dialog from '@/components/ui/dialog/Dialog.vue'

// 未导入的组件不会被打包
// Table、Calendar、DatePicker 等不会出现在最终 bundle 中
```

*优化效果*：

- *按需加载*：只打包实际使用的组件
- *代码分割*：配合动态导入实现路由级分割
- *CSS 清理*：PurgeCSS 移除未使用的 Tailwind 类
- *无死代码*：没有未使用的导出或副作用

== 生态对比

=== Radix UI（React Headless UI）

```jsx
// Radix UI（React）
import * as Dialog from '@radix-ui/react-dialog'

function MyDialog() {
  return (
    <Dialog.Root>
      <Dialog.Trigger>Open</Dialog.Trigger>
      <Dialog.Portal>
        <Dialog.Overlay />
        <Dialog.Content>
          <Dialog.Title>Title</Dialog.Title>
          <Dialog.Description>Description</Dialog.Description>
        </Dialog.Content>
      </Dialog.Portal>
    </Dialog.Root>
  )
}
```

*特点*：

- *Headless*：无样式，只提供行为和 a11y
- *React 专用*：不支持 Vue
- *组合式 API*：Compound Components 模式
- *Shadcn/ui 的基础*：Shadcn React 版基于 Radix


=== Reka UI（Vue Headless UI）

```vue
<!-- Reka UI（Vue） -->
<script setup>
import {
  DialogRoot,
  DialogTrigger,
  DialogPortal,
  DialogOverlay,
  DialogContent,
  DialogTitle,
  DialogDescription,
} from 'reka-ui'
</script>

<template>
  <DialogRoot>
    <DialogTrigger as-child>
      <Button>打开</Button>
    </DialogTrigger>

    <DialogPortal>
      <DialogOverlay />
      <DialogContent>
        <DialogTitle>标题</DialogTitle>
        <DialogDescription>描述</DialogDescription>
      </DialogContent>
    </DialogPortal>
  </DialogRoot>
</template>
```

*特点*：

- *Vue 版 Radix*：相同的 API 设计
- *Headless*：无样式，专注行为
- *Composition API*：完美适配 Vue 3
- *Shadcn-vue 的基础*：Shadcn Vue 版基于 Reka

#note[
  Reka UI 是 Radix UI 的 Vue 移植，由同一团队维护。
]

=== Shadcn/ui（React）vs Shadcn-vue（Vue）

#tex-table(
  ("特性", "Shadcn/ui (React)", "Shadcn-vue (Vue)"),
  ("基础库", "Radix UI", "Reka UI"),
  ("语言", "TypeScript + JSX", "TypeScript + SFC"),
  ("样式", "Tailwind CSS", "Tailwind CSS"),
  ("CLI 工具", "shadcn-ui", "shadcn-vue"),
  ("社区规模", "大（React 生态）", "增长中（Vue 生态）"),
  ("组件数量", "50+", "40+"),
  ("成熟度", "高", "中高"),
)

*共同点*：

- ✅ 相同的理念：Copy-Paste、完全可控
- ✅ 相同的技术栈：Tailwind CSS + Headless UI
- ✅ 相同的 CLI：`npx shadcn add <component>`
- ✅ 相同的定制能力：直接修改源码

*差异*：

- React 版更早推出，社区更成熟
- Vue 版正在快速追赶，组件覆盖率已达 80%+
- API 设计风格一致，降低跨框架学习成本

#fancy-divider

本章完

= Shadcn-vue 快速上手

= Shadcn-vue 核心组件

= Shadcn-vue 高级用法

= 其他现代 UI 方案
