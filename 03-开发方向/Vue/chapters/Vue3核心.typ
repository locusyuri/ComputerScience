#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= Vue 3 入门与环境搭建

= Composition API 核心

= 组件系统

组件是 Vue 应用的核心构建块。Vue 3 提供了强大的组件系统，支持灵活的注册方式、类型安全的 Props/Emits、以及多种通信机制。

== 组件注册

=== 全局注册

```vue
// main.ts
import { createApp } from 'vue'
import App from './App.vue'

// 全局注册组件
import BaseButton from './components/BaseButton.vue'
import BaseInput from './components/BaseInput.vue'

const app = createApp(App)
app.component('BaseButton', BaseButton)
app.component('BaseInput', BaseInput)
app.mount('#app')
```

*使用*：

```vue
<!-- 任何组件中都可以直接使用，无需导入 -->
<template>
  <BaseButton>点击</BaseButton>
  <BaseInput v-model="value" />
</template>
```

*优缺点*：

#tex-table(
  ("优点", "缺点"),
  ("使用方便，无需导入", "所有组件都会打包进 bundle"),
  ("适合基础组件", "可能导致命名冲突"),
  ("减少重复导入", "不利于 Tree-Shaking"),
)

#caution[
  全局注册适合少量基础组件（Button、Input等），不建议大量使用。
]

=== 局部注册

```vue
<script setup lang="ts">
import MyComponent from './MyComponent.vue'
import AnotherComponent from './AnotherComponent.vue'

// 自动注册（<script setup>）
// 只需导入，无需额外注册
</script>

<template>
  <MyComponent />
  <AnotherComponent />
</template>
```

*传统写法*：

```vue
<script>
import MyComponent from './MyComponent.vue'

export default {
  components: {
    MyComponent  // 手动注册
  }
}
</script>
```

*优势*：

- *更好的 Tree-Shaking*：未使用的组件不会被打包
- *明确的依赖关系*：可以清楚看到组件使用了哪些子组件
- *避免命名冲突*：组件名只在当前作用域有效

#tip[
  推荐使用局部注册，配合自动导入插件提升开发体验。
]

=== 自动导入（unplugin-vue-components）

```bash
# 安装
npm install -D unplugin-vue-components
```

```typescript
// vite.config.ts
import Components from 'unplugin-vue-components/vite'

export default defineConfig({
  plugins: [
    vue(),
    Components({
      // 自动导入 src/components 目录下的组件
      dirs: ['src/components'],
      // 生成类型声明
      dts: true,
      // 支持 UI 库
      resolvers: [
        // Element Plus
        ElementPlusResolver(),
        // Shadcn-vue
        // 不需要 resolver，因为代码在项目中
      ],
    }),
  ],
})
```

*使用*：

```vue
<script setup lang="ts">
// 无需导入！自动识别
</script>

<template>
  <BaseButton>自动导入的组件</BaseButton>
  <MyCustomComponent />  <!-- 只要在 components 目录下 -->
</template>
```

*生成的类型声明*：

```typescript
// components.d.ts（自动生成）
declare module 'vue' {
  export interface GlobalComponents {
    BaseButton: typeof import('./src/components/BaseButton.vue')['default']
    MyCustomComponent: typeof import('./src/components/MyCustomComponent.vue')['default']
  }
}
```

#note[
  自动导入插件结合了全局注册的便利性和局部注册的 Tree-Shaking 优势。
]

== Props 与 Emits

=== Props 类型声明

```vue
<script setup lang="ts">
interface Props {
  title: string
  count?: number  // 可选
  disabled?: boolean
  items: Array<{ id: number; name: string }>
}

// 带默认值
withDefaults(defineProps<Props>(), {
  count: 0,
  disabled: false,
})
</script>

<template>
  <h1>{{ title }}</h1>
  <p>Count: {{ count }}</p>
</template>
```

*运行时声明（不使用 TypeScript）*：

```vue
<script setup>
defineProps({
  title: {
    type: String,
    required: true,
  },
  count: {
    type: Number,
    default: 0,
  },
  disabled: Boolean,
  items: {
    type: Array,
    default: () => [],
  },
})
</script>
```

#tip[
  推荐使用 TypeScript + `defineProps<T>()`，获得完整的类型检查和 IDE 支持。
]

=== Props 验证

```vue
<script setup lang="ts">
interface Props {
  status: 'success' | 'warning' | 'error'  // 字面量联合类型
  size: 'sm' | 'md' | 'lg'
  color?: string
}

const props = defineProps<Props>()

// 自定义验证逻辑
import { watchEffect } from 'vue'

watchEffect(() => {
  if (props.status === 'error' && !props.color) {
    console.warn('Error status should have a color')
  }
})
</script>
```

*运行时验证*：

```vue
<script setup>
defineProps({
  status: {
    type: String,
    validator: (value) => {
      return ['success', 'warning', 'error'].includes(value)
    },
  },
  age: {
    type: Number,
    validator: (value) => {
      return value >= 0 && value <= 150
    },
  },
})
</script>
```

=== Emits 类型声明

```vue
<script setup lang="ts">
// 定义 emit 事件
const emit = defineEmits<{
  (e: 'update', value: string): void
  (e: 'change', id: number, name: string): void
  (e: 'delete', id: number): void
}>()

// 触发事件
function handleClick() {
  emit('update', 'new value')
  emit('change', 1, 'Item 1')
}

function handleDelete(id: number) {
  emit('delete', id)
}
</script>

<template>
  <button @click="handleClick">更新</button>
  <button @click="handleDelete(1)">删除</button>
</template>
```

*父组件使用*：

```vue
<script setup lang="ts">
import ChildComponent from './ChildComponent.vue'

function handleUpdate(value: string) {
  console.log('Updated:', value)
}

function handleChange(id: number, name: string) {
  console.log(`Changed: ${id} - ${name}`)
}
</script>

<template>
  <ChildComponent
    @update="handleUpdate"
    @change="handleChange"
    @delete="(id) => console.log('Deleted:', id)"
  />
</template>
```

#note[
  TypeScript 声明的 emits 提供完整的类型检查，IDE 会自动补全事件名和参数。
]

=== v-model 双向绑定

```vue
<!-- 子组件 -->
<script setup lang="ts">
const props = defineProps<{
  modelValue: string
}>()

const emit = defineEmits<{
  (e: 'update:modelValue', value: string): void
}>()

function updateValue(event: Event) {
  const target = event.target as HTMLInputElement
  emit('update:modelValue', target.value)
}
</script>

<template>
  <input :value="modelValue" @input="updateValue" />
</template>
```

*父组件使用*：

```vue
<script setup lang="ts">
import { ref } from 'vue'
import CustomInput from './CustomInput.vue'

const inputValue = ref('Hello')
</script>

<template>
  <CustomInput v-model="inputValue" />
  <p>Value: {{ inputValue }}</p>
</template>
```

*多个 v-model*：

```vue
<!-- 子组件 -->
<script setup lang="ts">
defineProps<{
  modelValue: string
  modelModifiers?: Record<string, boolean>
  title: string
}>()

defineEmits<{
  (e: 'update:modelValue', value: string): void
  (e: 'update:title', value: string): void
}>()
</script>

<!-- 父组件 -->
<template>
  <CustomInput
    v-model="inputValue"
    v-model:title="pageTitle"
  />
</template>
```

#tip[
  Vue 3 支持多个 v-model，通过不同的 modifier 实现更灵活的双向绑定。
]

== 插槽（Slots）

=== 默认插槽

```vue
<!-- Card.vue -->
<template>
  <div class="card">
    <div class="card-header">
      <slot name="header">默认标题</slot>
    </div>

    <div class="card-body">
      <slot>默认内容</slot>
    </div>

    <div class="card-footer">
      <slot name="footer">默认底部</slot>
    </div>
  </div>
</template>
```

*使用*：

```vue
<Card>
  <template #header>
    <h2>自定义标题</h2>
  </template>

  <p>自定义内容</p>

  <template #footer>
    <button>操作按钮</button>
  </template>
</Card>
```

=== 具名插槽

```vue
<!-- Layout.vue -->
<template>
  <div class="layout">
    <header>
      <slot name="header"></slot>
    </header>

    <main>
      <slot name="default"></slot>
    </main>

    <aside>
      <slot name="sidebar"></slot>
    </aside>

    <footer>
      <slot name="footer"></slot>
    </footer>
  </div>
</template>
```

*使用*：

```vue
<Layout>
  <template #header>
    <NavBar />
  </template>

  <template #default>
    <RouterView />
  </template>

  <template #sidebar>
    <SideMenu />
  </template>

  <template #footer>
    <Footer />
  </template>
</Layout>
```

#note[
  具名插槽让组件布局更加灵活，适合构建页面模板。
]

=== 作用域插槽

```vue
<!-- DataTable.vue -->
<script setup lang="ts">
interface Row {
  id: number
  name: string
  email: string
}

defineProps<{
  data: Row[]
}>()
</script>

<template>
  <table>
    <thead>
      <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Email</th>
        <th>Actions</th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="row in data" :key="row.id">
        <td>{{ row.id }}</td>
        <td>{{ row.name }}</td>
        <td>{{ row.email }}</td>
        <td>
          <!-- 作用域插槽：将 row 数据传递给父组件 -->
          <slot name="actions" :row="row"></slot>
        </td>
      </tr>
    </tbody>
  </table>
</template>
```

*使用*：

```vue
<script setup lang="ts">
import { ref } from 'vue'
import DataTable from './DataTable.vue'

const users = ref([
  { id: 1, name: 'Alice', email: 'alice@example.com' },
  { id: 2, name: 'Bob', email: 'bob@example.com' },
])

function handleEdit(row: any) {
  console.log('Edit:', row)
}

function handleDelete(row: any) {
  console.log('Delete:', row)
}
</script>

<template>
  <DataTable :data="users">
    <template #actions="{ row }">
      <button @click="handleEdit(row)">编辑</button>
      <button @click="handleDelete(row)">删除</button>
    </template>
  </DataTable>
</template>
```

#tip[
  作用域插槽让父组件可以访问子组件的数据，实现高度定制化的渲染。
]

== 异步组件

=== defineAsyncComponent

```vue
<script setup lang="ts">
import { defineAsyncComponent } from 'vue'

// 基本用法
const AsyncComponent = defineAsyncComponent(() =>
  import('./HeavyComponent.vue')
)

// 带加载状态
const AsyncComponentWithLoading = defineAsyncComponent({
  loader: () => import('./HeavyComponent.vue'),
  loadingComponent: LoadingSpinner,
  delay: 200,  // 延迟显示 loading（避免闪烁）
  timeout: 3000,  // 超时时间
  errorComponent: ErrorDisplay,
  onError(error, retry, fail, attempts) {
    if (attempts <= 3) {
      retry()  // 重试
    } else {
      fail()  // 失败
    }
  },
})
</script>

<template>
  <AsyncComponent />
  <AsyncComponentWithLoading />
</template>
```

#note[
  异步组件适合大型组件或很少使用的组件，可以减小初始 bundle 大小。
]

=== Suspense

```vue
<!-- Parent.vue -->
<script setup lang="ts">
import AsyncChild from './AsyncChild.vue'
</script>

<template>
  <Suspense>
    <!-- 默认内容（异步组件加载完成后显示） -->
    <template #default>
      <AsyncChild />
    </template>

    <!-- 后备内容（加载过程中显示） -->
    <template #fallback>
      <div class="loading">
        <p>加载中...</p>
      </div>
    </template>
  </Suspense>
</template>
```

*AsyncChild.vue*：

```vue
<script setup lang="ts">
// async setup 自动被 Suspense 捕获
const data = await fetch('/api/data').then(res => res.json())
</script>

<template>
  <div>{{ data }}</div>
</template>
```

#caution[
  Suspense 目前是实验性功能，API 可能会在未来版本中调整。
]

== 组件通信

=== Props/Emits（父子通信）

```vue
<!-- 父组件 -->
<script setup lang="ts">
import { ref } from 'vue'
import Child from './Child.vue'

const message = ref('Hello from parent')

function handleMessageFromChild(msg: string) {
  console.log('Received:', msg)
}
</script>

<template>
  <Child
    :message="message"
    @child-message="handleMessageFromChild"
  />
</template>
```

```vue
<!-- 子组件 -->
<script setup lang="ts">
defineProps<{
  message: string
}>()

const emit = defineEmits<{
  (e: 'child-message', msg: string): void
}>()

function sendMessage() {
  emit('child-message', 'Hello from child')
}
</script>

<template>
  <p>{{ message }}</p>
  <button @click="sendMessage">发送消息</button>
</template>
```

=== Provide/Inject（跨层级通信）

```vue
<!-- 祖先组件 -->
<script setup lang="ts">
import { provide, ref } from 'vue'

const theme = ref('light')
const user = ref({ name: 'Alice' })

// 提供数据
provide('theme', theme)
provide('user', user)

// 提供方法
provide('setTheme', (newTheme: string) => {
  theme.value = newTheme
})
</script>
```

```vue
<!-- 后代组件（任意层级） -->
<script setup lang="ts">
import { inject } from 'vue'

const theme = inject('theme')
const user = inject('user')
const setTheme = inject('setTheme')

function toggleTheme() {
  setTheme?.(theme.value === 'light' ? 'dark' : 'light')
}
</script>

<template>
  <p>Theme: {{ theme }}</p>
  <p>User: {{ user?.name }}</p>
  <button @click="toggleTheme">切换主题</button>
</template>
```

#tip[
  Provide/Inject 适合深层嵌套的组件通信，避免 Props 逐层传递（Prop Drilling）。
]

=== Mitt 事件总线（兄弟组件通信）

```bash
npm install mitt
```

```typescript
// eventBus.ts
import mitt from 'mitt'

export const emitter = mitt()

// 类型定义
type Events = {
  'user-login': { userId: number; username: string }
  'cart-update': { itemCount: number }
  'theme-change': string
}

export type Emitter = typeof emitter
```

```vue
<!-- 组件 A：发送事件 -->
<script setup lang="ts">
import { emitter } from '@/eventBus'

function login() {
  emitter.emit('user-login', {
    userId: 1,
    username: 'Alice'
  })
}
</script>
```

```vue
<!-- 组件 B：接收事件 -->
<script setup lang="ts">
import { onMounted, onUnmounted } from 'vue'
import { emitter } from '@/eventBus'

onMounted(() => {
  emitter.on('user-login', ({ userId, username }) => {
    console.log(`User ${username} (${userId}) logged in`)
  })
})

onUnmounted(() => {
  emitter.off('user-login')  // 清理事件监听
})
</script>
```

#caution[
  事件总线适合小型应用，大型应用推荐使用 Pinia 进行状态管理。
]

=== Pinia（全局状态管理）

```typescript
// stores/user.ts
import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useUserStore = defineStore('user', () => {
  const user = ref<{ name: string; email: string } | null>(null)
  const isLoggedIn = ref(false)

  function login(name: string, email: string) {
    user.value = { name, email }
    isLoggedIn.value = true
  }

  function logout() {
    user.value = null
    isLoggedIn.value = false
  }

  return { user, isLoggedIn, login, logout }
})
```

```vue
<!-- 任意组件中使用 -->
<script setup lang="ts">
import { useUserStore } from '@/stores/user'

const userStore = useUserStore()

function handleLogin() {
  userStore.login('Alice', 'alice@example.com')
}
</script>

<template>
  <div v-if="userStore.isLoggedIn">
    <p>Welcome, {{ userStore.user?.name }}</p>
    <button @click="userStore.logout">Logout</button>
  </div>
  <button v-else @click="handleLogin">Login</button>
</template>
```

#note[
  Pinia 是 Vue 3 推荐的状态管理方案，替代了 Vuex。
]

#fancy-divider

本章完

= 指令与过渡动画

Vue 提供了强大的指令系统和过渡动画系统，让 DOM 操作和动画效果变得简单易用。

== 内置指令

=== v-if / v-show

```vue
<script setup lang="ts">
import { ref } from 'vue'

const isVisible = ref(true)
const userType = ref('admin')
</script>

<template>
  <!-- v-if: 条件渲染，元素会被销毁/重建 -->
  <div v-if="isVisible">显示的内容</div>

  <!-- v-else-if / v-else -->
  <div v-if="userType === 'admin'">管理员界面</div>
  <div v-else-if="userType === 'user'">用户界面</div>
  <div v-else>访客界面</div>

  <!-- v-show: 条件显示，元素始终存在，只切换 display -->
  <div v-show="isVisible">显示的内容</div>
</template>
```

*对比*：

#tex-table(
  ("特性", "v-if", "v-show"),
  ("渲染方式", "条件渲染", "条件显示"),
  ("DOM 元素", "销毁/重建", "始终存在"),
  ("CSS display", "不涉及", "none/block"),
  ("初始开销", "低（如果不显示）", "高（始终渲染）"),
  ("切换开销", "高", "低"),
  ("适用场景", "不频繁切换", "频繁切换"),
)

#tip[
  频繁切换用 v-show，很少切换用 v-if。
]

=== v-for

```vue
<script setup lang="ts">
import { ref } from 'vue'

interface User {
  id: number
  name: string
  email: string
}

const users = ref<User[]>([
  { id: 1, name: 'Alice', email: 'alice@example.com' },
  { id: 2, name: 'Bob', email: 'bob@example.com' },
])

const numbers = ref([1, 2, 3, 4, 5])
const object = ref({ name: 'Alice', age: 25 })
</script>

<template>
  <!-- 数组遍历 -->
  <ul>
    <li v-for="(user, index) in users" :key="user.id">
      {{ index + 1 }}. {{ user.name }} - {{ user.email }}
    </li>
  </ul>

  <!-- 数字范围 -->
  <span v-for="n in 10" :key="n">{{ n }}</span>

  <!-- 对象遍历 -->
  <div v-for="(value, key) in object" :key="key">
    {{ key }}: {{ value }}
  </div>

  <!-- 字符串遍历 -->
  <span v-for="char in 'Hello'" :key="char">{{ char }}</span>
</template>
```

#caution[
  v-for 必须绑定 :key，且 key 应该是唯一且稳定的标识符（如 ID），不要用 index。
]

=== v-bind / v-on

```vue
<script setup lang="ts">
import { ref } from 'vue'

const imageUrl = ref('/path/to/image.jpg')
const isDisabled = ref(false)
const customClass = ref('active')

function handleClick(event: MouseEvent) {
  console.log('Clicked!', event)
}

function handleKeydown(event: KeyboardEvent) {
  if (event.key === 'Enter') {
    console.log('Enter pressed')
  }
}
</script>

<template>
  <!-- v-bind: 动态绑定属性 -->
  <img :src="imageUrl" :alt="'Image'" />
  <button :disabled="isDisabled">按钮</button>
  <div :class="customClass">内容</div>

  <!-- 对象语法绑定 class -->
  <div :class="{ active: isActive, 'text-danger': hasError }">内容</div>

  <!-- 数组语法绑定 class -->
  <div :class="[baseClass, errorClass]">内容</div>

  <!-- 对象语法绑定 style -->
  <div :style="{ color: activeColor, fontSize: fontSize + 'px' }">内容</div>

  <!-- v-on: 事件监听 -->
  <button @click="handleClick">点击</button>
  <input @keydown="handleKeydown" />

  <!-- 事件修饰符 -->
  <form @submit.prevent="handleSubmit">表单</form>
  <button @click.stop="handleClick">阻止冒泡</button>
  <a @click.once="handleClick">只触发一次</a>

  <!-- 按键修饰符 -->
  <input @keyup.enter="handleSubmit" />
  <input @keyup.ctrl.enter="handleSubmit" />

  <!-- 简写语法 -->
  <img :src="imageUrl" @click="handleClick" />
</template>
```

#note[
  `:` 是 `v-bind` 的简写，`@` 是 `v-on` 的简写。
]

=== v-model

```vue
<script setup lang="ts">
import { ref } from 'vue'

const text = ref('')
const checked = ref(false)
const selected = ref('option1')
const number = ref(0)
</script>

<template>
  <!-- 文本输入 -->
  <input v-model="text" type="text" />

  <!-- 复选框 -->
  <input v-model="checked" type="checkbox" />

  <!-- 单选框 -->
  <input v-model="selected" type="radio" value="option1" />
  <input v-model="selected" type="radio" value="option2" />

  <!-- 下拉选择 -->
  <select v-model="selected">
    <option value="option1">选项 1</option>
    <option value="option2">选项 2</option>
  </select>

  <!-- 修饰符 -->
  <input v-model.trim="text" />  <!-- 自动去除首尾空格 -->
  <input v-model.number="number" type="number" />  <!-- 自动转换为数字 -->
  <input v-model.lazy="text" />  <!-- change 事件而非 input 事件 -->
</template>
```

*自定义组件的 v-model*：

```vue
<!-- CustomInput.vue -->
<script setup lang="ts">
const props = defineProps<{
  modelValue: string
}>()

const emit = defineEmits<{
  (e: 'update:modelValue', value: string): void
}>()

function updateValue(event: Event) {
  const target = event.target as HTMLInputElement
  emit('update:modelValue', target.value)
}
</script>

<template>
  <input :value="modelValue" @input="updateValue" />
</template>
```

```vue
<!-- 使用 -->
<script setup lang="ts">
import { ref } from 'vue'
import CustomInput from './CustomInput.vue'

const inputValue = ref('')
</script>

<template>
  <CustomInput v-model="inputValue" />
</template>
```

=== v-slot

```vue
<!-- Card.vue -->
<template>
  <div class="card">
    <header>
      <slot name="header">默认标题</slot>
    </header>
    <main>
      <slot>默认内容</slot>
    </main>
    <footer>
      <slot name="footer">默认底部</slot>
    </footer>
  </div>
</template>
```

*使用*：

```vue
<Card>
  <template #header>
    <h2>标题</h2>
  </template>

  <p>内容</p>

  <template #footer>
    <button>按钮</button>
  </template>
</Card>
```

#tip[
  `#` 是 `v-slot:` 的简写，`#default` 可以省略。
]

== 自定义指令

=== 指令注册

```typescript
// directives/focus.ts
import type { Directive } from 'vue'

export const focus: Directive = {
  mounted: (el) => el.focus()
}
```

```typescript
// main.ts
import { createApp } from 'vue'
import App from './App.vue'
import { focus } from './directives/focus'

const app = createApp(App)
app.directive('focus', focus)
app.mount('#app')
```

*局部注册*：

```vue
<script setup lang="ts">
import type { Directive } from 'vue'

const focus: Directive = {
  mounted: (el) => el.focus()
}
</script>

<template>
  <input v-focus />
</template>
```

=== 钩子函数

```typescript
import type { DirectiveBinding } from 'vue'

const myDirective = {
  // 在绑定元素的 attribute 前或事件监听器应用前调用
  created(el: HTMLElement, binding: DirectiveBinding, vnode, prevVnode) {
    console.log('created')
  },

  // 在元素被插入到 DOM 前调用
  beforeMount(el, binding, vnode, prevVnode) {
    console.log('beforeMount')
  },

  // 在绑定元素的父组件及他自己的所有子节点都挂载完成后调用
  mounted(el, binding, vnode, prevVnode) {
    console.log('mounted')
  },

  // 绑定元素的父组件更新前调用
  beforeUpdate(el, binding, vnode, prevVnode) {
    console.log('beforeUpdate')
  },

  // 在绑定元素的父组件及他自己的所有子节点都更新后调用
  updated(el, binding, vnode, prevVnode) {
    console.log('updated')
  },

  // 绑定元素的父组件卸载前调用
  beforeUnmount(el, binding, vnode, prevVnode) {
    console.log('beforeUnmount')
  },

  // 绑定元素的父组件卸载后调用
  unmounted(el, binding, vnode, prevVnode) {
    console.log('unmounted')
  },
}
```

#note[
  Vue 3 中自定义指令的钩子函数名称与组件生命周期钩子一致。
]

=== 实战示例

*自动聚焦*：

```typescript
// directives/focus.ts
import type { Directive } from 'vue'

export const focus: Directive<HTMLInputElement> = {
  mounted: (el) => {
    el.focus()
  }
}
```

```vue
<template>
  <input v-focus placeholder="自动聚焦" />
</template>
```

*权限控制*：

```typescript
// directives/permission.ts
import type { Directive } from 'vue'
import { useUserStore } from '@/stores/user'

export const permission: Directive = {
  mounted(el: HTMLElement, binding) {
    const userStore = useUserStore()
    const requiredRole = binding.value

    if (!userStore.hasPermission(requiredRole)) {
      el.parentNode?.removeChild(el)
    }
  }
}
```

```vue
<template>
  <button v-permission="'admin'">仅管理员可见</button>
  <button v-permission="['admin', 'editor']">管理员或编辑可见</button>
</template>
```

*防抖*：

```typescript
// directives/debounce.ts
import type { Directive } from 'vue'

export const debounce: Directive = {
  mounted(el: HTMLElement, binding) {
    let timeoutId: number

    const handler = (event: Event) => {
      clearTimeout(timeoutId)
      timeoutId = setTimeout(() => {
        binding.value(event)
      }, 300) as unknown as number
    }

    el.addEventListener('input', handler)

    // 存储清理函数
    ;(el as any)._debounceCleanup = () => {
      el.removeEventListener('input', handler)
      clearTimeout(timeoutId)
    }
  },

  unmounted(el: HTMLElement) {
    ;(el as any)._debounceCleanup?.()
  }
}
```

```vue
<script setup lang="ts">
import { debounce } from '@/directives/debounce'

function handleSearch(event: Event) {
  const target = event.target as HTMLInputElement
  console.log('Search:', target.value)
}
</script>

<template>
  <input v-debounce="handleSearch" placeholder="搜索..." />
</template>
```

#tip[
  自定义指令适合封装 DOM 操作相关的逻辑，如聚焦、滚动、拖拽等。
]

== 过渡系统

=== `<Transition>` 基础

```vue
<script setup lang="ts">
import { ref } from 'vue'

const show = ref(false)
</script>

<template>
  <button @click="show = !show">切换</button>

  <Transition name="fade">
    <div v-if="show" class="box">内容</div>
  </Transition>
</template>

<style>
/* fade 过渡 */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
```

*过渡类名*：

#tex-table(
  ("类名", "时机", "说明"),
  ("v-enter-from", "进入前", "起始状态"),
  ("v-enter-active", "进入中", "激活状态，定义过渡"),
  ("v-enter-to", "进入后", "结束状态"),
  ("v-leave-from", "离开前", "起始状态"),
  ("v-leave-active", "离开中", "激活状态，定义过渡"),
  ("v-leave-to", "离开后", "结束状态"),
)

#note[
  如果给 `<Transition>` 设置了 `name` 属性（如 `name="fade"`），则类名前缀从 `v-` 变为 `fade-`。
]

=== CSS 过渡/动画

*淡入淡出*：

```css
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
```

*滑动*：

```css
.slide-enter-active,
.slide-leave-active {
  transition: transform 0.3s ease;
}

.slide-enter-from {
  transform: translateX(-100%);
}

.slide-leave-to {
  transform: translateX(100%);
}
```

*缩放*：

```css
.scale-enter-active,
.scale-leave-active {
  transition: transform 0.3s ease, opacity 0.3s ease;
}

.scale-enter-from,
.scale-leave-to {
  transform: scale(0);
  opacity: 0;
}
```

*使用 CSS Animation*：

```vue
<Transition name="bounce">
  <div v-if="show">内容</div>
</Transition>

<style>
.bounce-enter-active {
  animation: bounce-in 0.5s;
}

.bounce-leave-active {
  animation: bounce-in 0.5s reverse;
}

@keyframes bounce-in {
  0% {
    transform: scale(0);
  }
  50% {
    transform: scale(1.25);
  }
  100% {
    transform: scale(1);
  }
}
</style>
```

#tip[
  Transition 支持 CSS transition 和 animation，Vue 会自动检测并使用。
]

=== JavaScript 钩子

```vue
<script setup lang="ts">
import { ref } from 'vue'
import gsap from 'gsap'

const show = ref(false)

function onBeforeEnter(el: Element) {
  gsap.set(el, {
    scaleX: 0.25,
    scaleY: 0.25,
    opacity: 1
  })
}

function onEnter(el: Element, done: () => void) {
  gsap.to(el, {
    duration: 1,
    scaleX: 1,
    scaleY: 1,
    ease: "elastic.inOut(2.5, 1)",
    onComplete: done
  })
}

function onLeave(el: Element, done: () => void) {
  gsap.to(el, {
    duration: 0.7,
    scaleX: 1,
    scaleY: 1,
    x: 300,
    ease: "elastic.inOut(2.5, 1)"
  })
  gsap.to(el, {
    duration: 0.2,
    delay: 0.5,
    opacity: 0,
    onComplete: done
  })
}
</script>

<template>
  <button @click="show = !show">切换</button>

  <Transition
    @before-enter="onBeforeEnter"
    @enter="onEnter"
    @leave="onLeave"
    :css="false"
  >
    <div v-if="show" class="box">GSAP 动画</div>
  </Transition>
</template>
```

*JavaScript 钩子列表*：

#tex-table(
  ("钩子", "参数", "说明"),
  ("@before-enter", "el", "进入前"),
  ("@enter", "el, done", "进入中，done 是回调"),
  ("@after-enter", "el", "进入后"),
  ("@enter-cancelled", "el", "进入取消"),
  ("@before-leave", "el", "离开前"),
  ("@leave", "el, done", "离开中，done 是回调"),
  ("@after-leave", "el", "离开后"),
  ("@leave-cancelled", "el", "离开取消"),
)

#caution[
  使用 JavaScript 钩子时，需要设置 `:css="false"`，否则 Vue 会同时应用 CSS 过渡。
]

== 列表过渡

=== <TransitionGroup> 基础

```vue
<script setup lang="ts">
import { ref } from 'vue'

let nextId = 1
const items = ref([
  { id: nextId++, text: 'Item 1' },
  { id: nextId++, text: 'Item 2' },
  { id: nextId++, text: 'Item 3' },
])

function addItem() {
  items.value.push({ id: nextId++, text: `Item ${nextId - 1}` })
}

function removeItem(item: any) {
  const index = items.value.indexOf(item)
  if (index > -1) {
    items.value.splice(index, 1)
  }
}
</script>

<template>
  <button @click="addItem">添加</button>

  <TransitionGroup name="list" tag="ul">
    <li v-for="item in items" :key="item.id" @click="removeItem(item)">
      {{ item.text }}
    </li>
  </TransitionGroup>
</template>

<style>
.list-enter-active,
.list-leave-active {
  transition: all 0.3s ease;
}

.list-enter-from,
.list-leave-to {
  opacity: 0;
  transform: translateX(30px);
}

.list-leave-active {
  position: absolute;  /* 防止其他元素跳动 */
}
</style>
```

#note[
  TransitionGroup 与 Transition 的区别：
  - TransitionGroup 用于列表，Transition 用于单个元素
  - TransitionGroup 没有 mode 属性
  - TransitionGroup 需要 tag 或 appear 属性
]

=== FLIP 动画

FLIP（First, Last, Invert, Play）是一种高性能的动画技术。

```vue
<script setup lang="ts">
import { ref } from 'vue'

const items = ref([1, 2, 3, 4, 5])

function shuffle() {
  items.value = items.value.sort(() => Math.random() - 0.5)
}
</script>

<template>
  <button @click="shuffle">打乱顺序</button>

  <TransitionGroup name="flip" tag="div" class="container">
    <div v-for="item in items" :key="item" class="item">
      {{ item }}
    </div>
  </TransitionGroup>
</template>

<style>
.flip-move {
  transition: transform 0.3s ease;
}

.container {
  display: flex;
  gap: 10px;
}

.item {
  width: 50px;
  height: 50px;
  background: #42b983;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 4px;
}
</style>
```

*FLIP 原理*：

1. *First*：记录元素的初始位置
2. *Last*：记录元素的最终位置
3. *Invert*：计算位置差值，应用 transform 将元素移回初始位置
4. *Play*：移除 transform，让元素平滑移动到最终位置

#tip[
  Vue 的 TransitionGroup 自动实现了 FLIP 动画，只需添加 `.move` 类即可。
]

=== 性能优化

*使用 will-change*：

```css
.list-item {
  will-change: transform, opacity;
}
```

*避免布局抖动*：

```css
.list-leave-active {
  position: absolute;  /* 防止其他元素重新布局 */
}
```

*使用 transform 而非 top/left*：

```css
/* ✅ 好：使用 transform（GPU 加速） */
.item {
  transform: translateX(0);
  transition: transform 0.3s;
}

/* ❌ 差：使用 top/left（触发重排） */
.item {
  top: 0;
  transition: top 0.3s;
}
```

*限制动画数量*：

```vue
<!-- 只动画可见区域内的元素 -->
<TransitionGroup name="list">
  <li v-for="item in visibleItems" :key="item.id">
    {{ item.text }}
  </li>
</TransitionGroup>
```

#caution[
  过多的过渡动画会影响性能，特别是在移动设备上。谨慎使用，并进行性能测试。
]

#fancy-divider

本章完
