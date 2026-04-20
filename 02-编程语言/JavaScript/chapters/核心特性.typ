#import "../../../99-索引与模板/TypstTemplate/computer-notes.typ": *

= 原型与面向对象

= this 与执行上下文

= 异步编程与事件循环

== JavaScript 异步模型概览
=== 同步 vs 异步
=== 为什么需要异步
=== 异步编程的演进历程

== 事件循环机制
=== 调用栈（Call Stack）
=== 任务队列（Task Queue）
=== 微任务与宏任务
=== 事件循环执行流程
=== 浏览器 vs Node.js 事件循环

== Promise：异步编程的核心

Promise 是 JavaScript 异步编程的核心抽象，代表一个异步操作的最终完成（或失败）及其结果值。

=== Promise 基础概念

Promise 是一个对象，用于表示异步操作的最终完成（或失败）。

*三种状态*：

#tex-table(
  ("状态", "说明", "可否改变"),
  ("pending（等待中）", "初始状态，既不是成功也不是失败", "✓"),
  ("fulfilled（已成功）", "操作成功完成", "✗"),
  ("rejected（已失败）", "操作失败", "✗"),
)

*状态转换*：

```
pending → fulfilled（resolve）
pending → rejected（reject）
```

*基本语法*：

```javascript
const promise = new Promise((resolve, reject) => {
  // 异步操作
  setTimeout(() => {
    const success = true;

    if (success) {
      resolve("操作成功");  // 状态变为 fulfilled
    } else {
      reject(new Error("操作失败"));  // 状态变为 rejected
    }
  }, 1000);
});

promise
  .then(result => {
    console.log(result);  // "操作成功"
  })
  .catch(error => {
    console.error(error);  // 如果失败则执行
  });
```

*Promise 的特点*：

#tex-table(
  ("特点", "说明"),
  ("状态不可逆", "一旦从 pending 变为 fulfilled/rejected，状态不再改变"),
  ("链式调用", "then/catch 返回新的 Promise，可以链式调用"),
  ("微任务", "Promise 回调作为微任务执行，优先级高于宏任务"),
  ("错误冒泡", "错误会沿着链式调用向下传递，直到被 catch 捕获"),
  ("立即执行", "Promise 构造函数中的代码会立即执行"),
)

=== Promise 状态机

Promise 的状态变化遵循严格的状态机规则。

*状态转换图*：

```
         resolve()
pending ----------→ fulfilled
   |                    |
   |                    | then() 回调
   |                    ↓
   |              返回值/新Promise
   |
   | reject()
   ----------→ rejected
                    |
                    | catch() 回调
                    ↓
              错误处理/新Promise
```

*示例：状态变化*：

```javascript
// 示例 1：成功状态
const p1 = new Promise((resolve, reject) => {
  console.log("Promise 创建");  // 立即执行
  resolve("成功");
});

p1.then(value => {
  console.log(value);  // "成功"
  return "新值";
}).then(value => {
  console.log(value);  // "新值"
});

// 示例 2：失败状态
const p2 = new Promise((resolve, reject) => {
  reject(new Error("失败"));
});

p2.catch(error => {
  console.error(error.message);  // "失败"
});

// 示例 3：状态不可逆
const p3 = new Promise((resolve, reject) => {
  resolve("第一次");
  reject("第二次");  // 这行不会生效
});

p3.then(value => {
  console.log(value);  // "第一次"
});
```

*Pending 状态的持久性*：

```javascript
// Promise 一直处于 pending 状态
const pendingPromise = new Promise(() => {
  // 既不 resolve 也不 reject
});

pendingPromise.then(() => {
  console.log("永远不会执行");
});

// 超时控制
const timeoutPromise = new Promise((_, reject) => {
  setTimeout(() => {
    reject(new Error("Timeout"));
  }, 5000);
});
```

=== then/catch/finally

这三个方法是 Promise 的核心 API。

*then 方法*：

`then` 方法接受两个可选参数：成功回调和失败回调。

```javascript
promise.then(
  onFulfilled,  // 可选，当 Promise fulfilled 时调用
  onRejected    // 可选，当 Promise rejected 时调用
);
```

*基本用法*：

```javascript
const promise = fetchData();

// 方式 1：两个参数
promise.then(
  result => console.log("成功:", result),
  error => console.error("失败:", error)
);

// 方式 2：then + catch（推荐）
promise
  .then(result => console.log("成功:", result))
  .catch(error => console.error("失败:", error));
```

*返回值*：

```javascript
// then 返回新的 Promise
promise
  .then(result => {
    console.log(result);  // "原始值"
    return "新值";  // 返回新值，下一个 then 接收
  })
  .then(newResult => {
    console.log(newResult);  // "新值"
    return Promise.resolve("Promise 值");  // 返回 Promise
  })
  .then(finalResult => {
    console.log(finalResult);  // "Promise 值"
  });
```

*catch 方法*：

`catch` 是 `then(null, onRejected)` 的语法糖。

```javascript
// 这两种写法等价
promise.catch(error => console.error(error));
promise.then(null, error => console.error(error));
```

*错误捕获*：

```javascript
fetchData()
  .then(result => {
    // 如果这里抛出错误，会被后面的 catch 捕获
    if (!result) {
      throw new Error("数据为空");
    }
    return process(result);
  })
  .then(processed => {
    return save(processed);
  })
  .catch(error => {
    // 捕获上面任何一步的错误
    console.error("错误:", error.message);
  });
```

#note[
  `catch` 会捕获前面所有步骤的错误，包括 then 回调中抛出的错误。
]

*finally 方法*：

`finally` 无论 Promise 成功还是失败都会执行，常用于清理工作。

```javascript
showLoading();

fetchData()
  .then(result => {
    display(result);
  })
  .catch(error => {
    showError(error);
  })
  .finally(() => {
    // 无论成功还是失败，都会执行
    hideLoading();
  });
```

*特点*：

#tex-table(
  ("特点", "说明"),
  ("必定执行", "无论 fulfilled 还是 rejected 都会执行"),
  ("无参数", "不接收任何参数"),
  ("不改变结果", "返回值不影响 Promise 的最终结果"),
  ("透传", "继续传递原始的 resolved/rejected 值"),
)

*示例*：

```javascript
Promise.resolve("成功")
  .finally(() => {
    console.log("清理工作");
    return "被忽略";  // 这个返回值会被忽略
  })
  .then(value => {
    console.log(value);  // "成功"（原始值）
  });

Promise.reject(new Error("失败"))
  .finally(() => {
    console.log("清理工作");
  })
  .catch(error => {
    console.error(error.message);  // "失败"（原始错误）
  });
```

=== Promise 链式调用

Promise 的强大之处在于链式调用，可以避免回调地狱。

*基本链式调用*：

```javascript
// 串行执行：每一步依赖上一步的结果
fetchUser(userId)
  .then(user => {
    return fetchPosts(user.id);  // 返回 Promise
  })
  .then(posts => {
    return fetchComments(posts[0].id);  // 返回 Promise
  })
  .then(comments => {
    console.log(comments);
  })
  .catch(error => {
    console.error("任何一步出错都会到这里", error);
  });
```

*返回值类型*：

```javascript
promise
  .then(result => {
    // 情况 1：返回普通值
    return "字符串";
    // 下一个 then 接收: "字符串"
  })
  .then(value => {
    // 情况 2：返回 Promise
    return Promise.resolve(42);
    // 下一个 then 接收: 42
  })
  .then(value => {
    // 情况 3：不返回（返回 undefined）
    console.log(value);  // 42
    // 下一个 then 接收: undefined
  })
  .then(value => {
    console.log(value);  // undefined
  });
```

*链式调用的错误传播*：

```javascript
step1()
  .then(result1 => step2(result1))
  .then(result2 => step3(result2))  // 如果 step2 失败，跳过这里
  .then(result3 => step4(result3))  // 如果 step3 失败，跳过这里
  .catch(error => {
    // 捕获 step1、step2、step3、step4 中任何一个的错误
    console.error(error);
  });
```

*局部错误处理*：

```javascript
step1()
  .then(result1 => {
    return step2(result1).catch(error => {
      // 只捕获 step2 的错误
      console.warn("step2 失败，使用默认值");
      return defaultValue;
    });
  })
  .then(result2 => {
    // 即使 step2 失败，这里仍会执行（使用默认值）
    return step3(result2);
  })
  .catch(error => {
    // 捕获 step1 或 step3 的错误
    console.error(error);
  });
```

=== Promise 静态方法

Promise 提供了多个静态方法来处理多个 Promise。

*Promise.all*：

等待所有 Promise 都成功，返回结果数组；如果有一个失败，立即拒绝。

```javascript
const promise1 = Promise.resolve(3);
const promise2 = 42;  // 非 Promise 值会被包装
const promise3 = new Promise(resolve => {
  setTimeout(resolve, 100, "foo");
});

Promise.all([promise1, promise2, promise3])
  .then(values => {
    console.log(values);  // [3, 42, "foo"]
  })
  .catch(error => {
    // 如果任何一个 Promise reject，立即执行
    console.error(error);
  });
```

*失败快速*：

```javascript
const p1 = Promise.resolve(1);
const p2 = Promise.reject(new Error("失败"));
const p3 = Promise.resolve(3);

Promise.all([p1, p2, p3])
  .then(values => {
    console.log(values);  // 不会执行
  })
  .catch(error => {
    console.error(error.message);  // "失败"
    // 注意：p3 可能还在执行，但结果被忽略
  });
```

*应用场景*：

```javascript
// 并行加载多个资源
async function loadResources() {
  const [users, posts, comments] = await Promise.all([
    fetch("/api/users").then(r => r.json()),
    fetch("/api/posts").then(r => r.json()),
    fetch("/api/comments").then(r => r.json())
  ]);

  return { users, posts, comments };
}
```

*Promise.race*：

返回第一个 settled（fulfilled 或 rejected）的 Promise 的结果。

```javascript
const p1 = new Promise(resolve => {
  setTimeout(resolve, 500, "first");
});

const p2 = new Promise(resolve => {
  setTimeout(resolve, 100, "second");
});

Promise.race([p1, p2])
  .then(value => {
    console.log(value);  // "second"（更快的那个）
  });
```

*超时控制*：

```javascript
function fetchWithTimeout(url, timeout) {
  const fetchPromise = fetch(url);
  const timeoutPromise = new Promise((_, reject) => {
    setTimeout(() => reject(new Error("Request timeout")), timeout);
  });

  return Promise.race([fetchPromise, timeoutPromise]);
}

// 使用
fetchWithTimeout("https://api.example.com/data", 5000)
  .then(response => response.json())
  .catch(error => {
    console.error(error.message);  // "Request timeout" 或网络错误
  });
```

*Promise.allSettled*：

等待所有 Promise 都 settled，返回每个 Promise 的状态和结果。

```javascript
const p1 = Promise.resolve(1);
const p2 = Promise.reject(new Error("失败"));
const p3 = Promise.resolve(3);

Promise.allSettled([p1, p2, p3])
  .then(results => {
    console.log(results);
    // [
    //   { status: "fulfilled", value: 1 },
    //   { status: "rejected", reason: Error: 失败 },
    //   { status: "fulfilled", value: 3 }
    // ]
  });
```

*处理部分失败*：

```javascript
async function loadAllResources(urls) {
  const promises = urls.map(url =>
    fetch(url).then(r => r.json()).catch(error => ({ error }))
  );

  const results = await Promise.allSettled(promises);

  const successful = results
    .filter(r => r.status === "fulfilled")
    .map(r => r.value);

  const failed = results
    .filter(r => r.status === "rejected")
    .map(r => r.reason);

  console.log("成功:", successful.length);
  console.log("失败:", failed.length);

  return { successful, failed };
}
```

*Promise.any*：

返回第一个 fulfilled 的 Promise 的结果；如果全部 rejected，返回 AggregateError。

```javascript
const p1 = Promise.reject(new Error("失败 1"));
const p2 = Promise.resolve("成功");
const p3 = Promise.reject(new Error("失败 2"));

Promise.any([p1, p2, p3])
  .then(value => {
    console.log(value);  // "成功"
  })
  .catch(error => {
    // 只有全部失败才会到这里
    console.error(error);  // AggregateError
  });
```

*全部失败*：

```javascript
const p1 = Promise.reject(new Error("失败 1"));
const p2 = Promise.reject(new Error("失败 2"));

Promise.any([p1, p2])
  .then(value => {
    console.log(value);  // 不会执行
  })
  .catch(error => {
    console.error(error.name);  // "AggregateError"
    console.error(error.errors);  // [Error: 失败 1, Error: 失败 2]
  });
```

*应用场景：多源数据获取*：

```javascript
// 从多个 CDN 获取数据，使用最快的成功响应
const cdns = [
  fetch("https://cdn1.example.com/data.json"),
  fetch("https://cdn2.example.com/data.json"),
  fetch("https://cdn3.example.com/data.json")
];

Promise.any(cdns)
  .then(response => response.json())
  .then(data => {
    console.log("从最快的 CDN 获取数据:", data);
  })
  .catch(error => {
    console.error("所有 CDN 都失败:", error.errors);
  });
```

*对比总结*：

#tex-table(
  ("方法", "成功条件", "失败条件", "返回值"),
  ("Promise.all", "全部 fulfilled", "任一 rejected", "结果数组 / 第一个错误"),
  ("Promise.race", "第一个 settled", "第一个 rejected", "第一个结果 / 错误"),
  ("Promise.allSettled", "全部 settled", "永不失败", "状态数组"),
  ("Promise.any", "任一 fulfilled", "全部 rejected", "第一个成功 / AggregateError"),
)

=== 错误处理最佳实践

良好的错误处理是 Promise 使用的关键。

*始终添加 catch*：

```javascript
// ❌ 错误做法：未捕获的错误
fetchData().then(result => {
  console.log(result);
});

// ✅ 正确做法：总是添加 catch
fetchData()
  .then(result => {
    console.log(result);
  })
  .catch(error => {
    console.error("Error:", error);
  });
```

*避免吞掉错误*：

```javascript
// ❌ 错误做法：吞掉错误
promise.catch(error => {
  // 什么都不做
});

// ✅ 正确做法：记录或重新抛出
promise.catch(error => {
  console.error(error);
  // 或者重新抛出，让上层处理
  throw error;
});
```

*统一的错误处理*：

```javascript
// 全局未处理的 Promise rejection
window.addEventListener("unhandledrejection", event => {
  console.error("Unhandled rejection:", event.reason);
  event.preventDefault();  // 防止控制台警告
});

// Node.js
process.on("unhandledRejection", (reason, promise) => {
  console.error("Unhandled Rejection at:", promise, "reason:", reason);
});
```

*async/await 中的错误处理*：

```javascript
// 方式 1：try-catch
async function loadData() {
  try {
    const response = await fetch("/api/data");
    const data = await response.json();
    return data;
  } catch (error) {
    console.error("Failed to load data:", error);
    throw error;  // 重新抛出或返回默认值
  }
}

// 方式 2：.catch()
async function loadData() {
  return fetch("/api/data")
    .then(response => response.json())
    .catch(error => {
      console.error("Failed to load data:", error);
      return null;  // 返回默认值
    });
}
```

== async/await：语法糖的威力

`async/await` 是基于 Promise 的语法糖，让异步代码看起来像同步代码，提高可读性和可维护性。

=== 基本语法

`async` 关键字声明一个异步函数，`await` 关键字等待 Promise 完成。

==== async 函数

```javascript
// 声明 async 函数
async function fetchData() {
  return "data";
}

// async 函数总是返回 Promise
fetchData().then(data => {
  console.log(data);  // "data"
});

// 等价于
function fetchData() {
  return Promise.resolve("data");
}
```

*特点*：

#tex-table(
  ("特点", "说明"),
  ("返回值", "自动包装为 Promise"),
  ("非 async 函数调用", "可以调用 async 函数"),
  ("异常处理", "抛出的异常会被 reject"),
  ("兼容性", "ES2017+"),
)

==== await 表达式

`await` 只能在 `async` 函数内部使用，用于等待 Promise 完成。

```javascript
async function loadData() {
  // 等待 Promise 完成
  const response = await fetch("/api/data");

  // 继续等待 JSON 解析
  const data = await response.json();

  return data;
}

// 使用
loadData().then(data => {
  console.log(data);
});
```

*执行流程*：

```javascript
async function example() {
  console.log("1. 开始");

  const result = await someAsyncOperation();
  console.log("2. 结果:", result);

  console.log("3. 结束");
}

// 输出顺序：
// 1. 开始
// (等待 someAsyncOperation 完成)
// 2. 结果: xxx
// 3. 结束
```

==== 对比：Promise vs async/await

```javascript
// Promise 链式调用
function loadUserData(userId) {
  return fetchUser(userId)
    .then(user => fetchPosts(user.id))
    .then(posts => fetchComments(posts[0].id))
    .then(comments => {
      return { user, posts, comments };
    })
    .catch(error => {
      console.error(error);
    });
}

// async/await（更清晰）
async function loadUserData(userId) {
  try {
    const user = await fetchUser(userId);
    const posts = await fetchPosts(user.id);
    const comments = await fetchComments(posts[0].id);

    return { user, posts, comments };
  } catch (error) {
    console.error(error);
  }
}
```

=== 错误处理

async/await 提供了更直观的错误处理方式。

==== try-catch 方式

```javascript
async function loadData() {
  try {
    const response = await fetch("/api/data");

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const data = await response.json();
    return data;

  } catch (error) {
    console.error("Failed to load data:", error.message);

    // 可以选择：
    // 1. 重新抛出
    throw error;

    // 2. 返回默认值
    // return defaultValue;

    // 3. 返回 null
    // return null;
  }
}
```

==== 多个 await 的错误处理

```javascript
async function loadAllData() {
  try {
    const users = await fetchUsers();
    const posts = await fetchPosts();
    const comments = await fetchComments();

    return { users, posts, comments };

  } catch (error) {
    // 任何一个 await 失败都会到这里
    console.error("Failed to load data:", error);
    throw error;
  }
}
```

#note[
  如果第一个 await 失败，后面的 await 不会执行。
]

==== 独立的错误处理

```javascript
async function loadAllData() {
  let users, posts, comments;

  // 每个请求独立处理错误
  try {
    users = await fetchUsers();
  } catch (error) {
    console.warn("Failed to load users:", error);
    users = [];
  }

  try {
    posts = await fetchPosts();
  } catch (error) {
    console.warn("Failed to load posts:", error);
    posts = [];
  }

  try {
    comments = await fetchComments();
  } catch (error) {
    console.warn("Failed to load comments:", error);
    comments = [];
  }

  return { users, posts, comments };
}
```

==== Promise.catch 混合使用

```javascript
async function loadData() {
  // 方式 1：await + try-catch
  try {
    const data = await fetchData();
    return data;
  } catch (error) {
    console.error(error);
  }

  // 方式 2：await + .catch()
  const data = await fetchData().catch(error => {
    console.error(error);
    return null;
  });

  return data;
}
```

=== 并行执行 vs 串行执行

理解并行和串行的区别对于性能优化至关重要。

==== 串行执行（不推荐）

```javascript
// ❌ 串行执行：总耗时 = 1s + 1s + 1s = 3s
async function loadSerially() {
  const users = await fetchUsers();     // 1s
  const posts = await fetchPosts();     // 1s
  const comments = await fetchComments(); // 1s

  return { users, posts, comments };
}
```

*执行时间线*：

```
0s -----> 1s -----> 2s -----> 3s
|fetchUsers|fetchPosts|fetchComments|
```

==== 并行执行（推荐）

```javascript
// ✅ 并行执行：总耗时 = max(1s, 1s, 1s) = 1s
async function loadInParallel() {
  const [users, posts, comments] = await Promise.all([
    fetchUsers(),
    fetchPosts(),
    fetchComments()
  ]);

  return { users, posts, comments };
}
```

*执行时间线*：

```
0s -----------------> 1s
|fetchUsers         |
|fetchPosts         |
|fetchComments      |
```

==== 部分并行

当某些请求依赖其他请求的结果时，可以部分并行。

```javascript
async function loadUserData(userId) {
  // 第一步：获取用户（必须串行）
  const user = await fetchUser(userId);

  // 第二步：并行获取用户的帖子和评论
  const [posts, comments] = await Promise.all([
    fetchPosts(user.id),
    fetchComments(user.id)
  ]);

  return { user, posts, comments };
}
```

*执行时间线*：

```
0s -----> 1s -----------------> 2s
|fetchUser|fetchPosts          |
|         |fetchComments       |
```

==== 性能对比

```javascript
// 测试性能差异
async function testPerformance() {
  console.time("Serial");
  await loadSerially();
  console.timeEnd("Serial");  // ~3000ms

  console.time("Parallel");
  await loadInParallel();
  console.timeEnd("Parallel");  // ~1000ms
}
```

#tip[
  当多个异步操作互不依赖时，总是使用并行执行以提高性能。
]

=== 常见陷阱与解决方案

async/await 虽然简化了异步编程，但也有一些常见的陷阱需要注意。

==== 陷阱 1：忘记 await

```javascript
// ❌ 错误：忘记 await
async function loadData() {
  const data = fetchData();  // 返回 Promise，不是实际数据
  console.log(data);  // Promise { <pending> }
}

// ✅ 正确：添加 await
async function loadData() {
  const data = await fetchData();
  console.log(data);  // 实际数据
}
```

==== 陷阱 2：在循环中串行执行

```javascript
// ❌ 错误：串行执行，性能差
async function loadUsers(userIds) {
  const users = [];
  for (const id of userIds) {
    const user = await fetchUser(id);  // 每次等待
    users.push(user);
  }
  return users;
}

// ✅ 正确：并行执行
async function loadUsers(userIds) {
  const promises = userIds.map(id => fetchUser(id));
  return await Promise.all(promises);
}
```

*性能对比*：

```javascript
// 假设有 100 个用户，每个请求 100ms
// 串行：100 * 100ms = 10s
// 并行：max(100ms) = 100ms
```

==== 陷阱 3：未处理的错误

```javascript
// ❌ 错误：未捕获的错误
async function loadData() {
  const data = await fetchData();  // 如果失败，错误未被捕获
  return data;
}

// ✅ 正确：添加错误处理
async function loadData() {
  try {
    const data = await fetchData();
    return data;
  } catch (error) {
    console.error(error);
    return null;
  }
}
```

==== 陷阱 4：顶层 await 的限制

```javascript
// ❌ 错误：在非 async 函数中使用 await
function loadData() {
  const data = await fetchData();  // SyntaxError
}

// ✅ 正确 1：在 async 函数中
async function loadData() {
  const data = await fetchData();
}

// ✅ 正确 2：顶层 await（ES Module）
// 只在 ES Module 中支持
const data = await fetchData();
```

#note[
  顶层 await 仅在 ES Module 中支持，CommonJS 不支持。
]

==== 陷阱 5：过度使用 async/await

```javascript
// ❌ 不必要：简单的 Promise 链
async function loadData() {
  const response = await fetch("/api/data");
  const data = await response.json();
  return data;
}

// ✅ 更简洁：直接返回 Promise
function loadData() {
  return fetch("/api/data")
    .then(response => response.json());
}
```

#tip[
  如果函数只是简单地转发 Promise，不需要使用 async/await。
]

==== 陷阱 6：错误堆栈丢失

```javascript
// ❌ 可能丢失堆栈信息
async function loadData() {
  try {
    await fetchData();
  } catch (error) {
    throw new Error("Failed to load");  // 原始堆栈丢失
  }
}

// ✅ 保留原始错误
async function loadData() {
  try {
    await fetchData();
  } catch (error) {
    error.message = "Failed to load: " + error.message;
    throw error;  // 保留原始堆栈
  }
}
```

==== 最佳实践总结

#tex-table(
  ("实践", "说明", "示例"),
  ("总是 await", "确保获取实际值", "const data = await fetchData()"),
  ("并行执行", "互不依赖的请求并行", "Promise.all"),
  ("错误处理", "使用 try-catch", "try { await ... } catch {}"),
  ("避免嵌套", "扁平化异步代码", "减少 then 链"),
  ("简洁返回", "简单场景直接返回 Promise", "return fetch()"),
  ("保留堆栈", "不要创建新错误", "修改原错误消息"),
)

==== 完整示例

```javascript
// 真实的 API 请求封装
class ApiService {
  constructor(baseUrl) {
    this.baseUrl = baseUrl;
  }

  async request(endpoint, options = {}) {
    const url = `${this.baseUrl}${endpoint}`;

    try {
      const response = await fetch(url, {
        headers: {
          "Content-Type": "application/json",
          ...options.headers
        },
        ...options
      });

      if (!response.ok) {
        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
      }

      return await response.json();

    } catch (error) {
      console.error(`Request failed: ${endpoint}`, error);
      throw error;
    }
  }

  async getUsers() {
    return this.request("/users");
  }

  async getUser(id) {
    return this.request(`/users/${id}`);
  }

  async createUser(userData) {
    return this.request("/users", {
      method: "POST",
      body: JSON.stringify(userData)
    });
  }

  async loadDashboard(userId) {
    // 第一步：获取用户
    const user = await this.getUser(userId);

    // 第二步：并行获取相关数据
    const [posts, comments, stats] = await Promise.all([
      this.request(`/users/${userId}/posts`),
      this.request(`/users/${userId}/comments`),
      this.request(`/users/${userId}/stats`)
    ]);

    return {
      user,
      posts,
      comments,
      stats
    };
  }
}

// 使用
const api = new ApiService("https://api.example.com");

async function main() {
  try {
    const dashboard = await api.loadDashboard(123);
    console.log("Dashboard loaded:", dashboard);
  } catch (error) {
    console.error("Failed to load dashboard:", error);
  }
}

main();
```

#fancy-divider

本节详细介绍了 async/await 的基本语法、错误处理、并行执行以及常见陷阱。async/await 让异步代码更加清晰易读，是现代 JavaScript 异步编程的首选方式。

== 高级异步模式

在实际开发中，除了基础的 Promise 和 async/await，还需要掌握一些高级的异步编程模式来解决复杂场景。

=== 回调地狱与解决方案

回调地狱（Callback Hell）是早期 JavaScript 异步编程的主要问题。

==== 什么是回调地狱

```javascript
// ❌ 回调地狱：嵌套层级深，难以维护
getUser(userId, function(user) {
  getPosts(user.id, function(posts) {
    getComments(posts[0].id, function(comments) {
      getAuthor(comments[0].authorId, function(author) {
        console.log(author);
      });
    });
  });
});
```

*问题*：

#tex-table(
  ("问题", "说明"),
  ("嵌套过深", "代码向右延伸，难以阅读"),
  ("错误处理困难", "每层都需要单独处理错误"),
  ("控制流复杂", "难以实现并行、竞争等逻辑"),
  ("调试困难", "堆栈跟踪不清晰"),
)

==== 解决方案 1：Promise 链式调用

```javascript
// ✅ Promise 链式调用
getUser(userId)
  .then(user => getPosts(user.id))
  .then(posts => getComments(posts[0].id))
  .then(comments => getAuthor(comments[0].authorId))
  .then(author => {
    console.log(author);
  })
  .catch(error => {
    console.error(error);
  });
```

==== 解决方案 2：async/await

```javascript
// ✅ async/await：最清晰的写法
async function loadAuthorInfo(userId) {
  try {
    const user = await getUser(userId);
    const posts = await getPosts(user.id);
    const comments = await getComments(posts[0].id);
    const author = await getAuthor(comments[0].authorId);

    console.log(author);
    return author;
  } catch (error) {
    console.error(error);
  }
}
```

==== 解决方案 3：命名函数

```javascript
// ✅ 提取为命名函数
function handleUser(user) {
  return getPosts(user.id);
}

function handlePosts(posts) {
  return getComments(posts[0].id);
}

function handleComments(comments) {
  return getAuthor(comments[0].authorId);
}

getUser(userId)
  .then(handleUser)
  .then(handlePosts)
  .then(handleComments)
  .then(author => console.log(author))
  .catch(console.error);
```

=== 发布-订阅模式

发布-订阅（Pub/Sub）模式是一种事件驱动的异步模式，解耦生产者和消费者。

==== 基本实现

```javascript
class EventEmitter {
  constructor() {
    this.events = {};
  }

  // 订阅事件
  on(event, callback) {
    if (!this.events[event]) {
      this.events[event] = [];
    }
    this.events[event].push(callback);

    // 返回取消订阅函数
    return () => {
      this.events[event] = this.events[event].filter(cb => cb !== callback);
    };
  }

  // 发布事件
  emit(event, ...args) {
    if (this.events[event]) {
      this.events[event].forEach(callback => {
        callback(...args);
      });
    }
  }

  // 只订阅一次
  once(event, callback) {
    const unsubscribe = this.on(event, (...args) => {
      callback(...args);
      unsubscribe();  // 自动取消订阅
    });
  }

  // 取消所有订阅
  off(event) {
    delete this.events[event];
  }
}
```

==== 使用示例

```javascript
const emitter = new EventEmitter();

// 订阅事件
const unsubscribe = emitter.on("data", (data) => {
  console.log("收到数据:", data);
});

// 发布事件
emitter.emit("data", { id: 1, value: "test" });
// 输出: 收到数据: { id: 1, value: "test" }

// 取消订阅
unsubscribe();
emitter.emit("data", { id: 2, value: "test2" });
// 不会输出，因为已取消订阅
```

==== 异步事件处理

```javascript
class AsyncEventEmitter extends EventEmitter {
  // 异步发布，等待所有处理器完成
  async emitAsync(event, ...args) {
    if (this.events[event]) {
      const promises = this.events[event].map(callback => {
        try {
          return Promise.resolve(callback(...args));
        } catch (error) {
          return Promise.reject(error);
        }
      });

      return Promise.allSettled(promises);
    }
  }
}

// 使用
const asyncEmitter = new AsyncEventEmitter();

asyncEmitter.on("request", async (url) => {
  const response = await fetch(url);
  return response.json();
});

asyncEmitter.on("request", async (url) => {
  console.log("Logging request to:", url);
});

// 发布并等待所有处理器完成
const results = await asyncEmitter.emitAsync("request", "https://api.example.com");
console.log(results);
// [
//   { status: "fulfilled", value: {...} },
//   { status: "fulfilled", value: undefined }
// ]
```

==== 应用场景

#tex-table(
  ("场景", "说明", "示例"),
  ("事件驱动架构", "组件间通信", "UI 事件、消息队列"),
  ("插件系统", "扩展点机制", "Webpack 插件、Babel 插件"),
  ("状态管理", "状态变化通知", "Redux、Vuex"),
  ("实时通信", "WebSocket 消息", "聊天应用、实时通知"),
  ("日志系统", "多目标日志", "控制台、文件、远程服务器"),
)

=== 生产者-消费者模式

生产者-消费者模式用于处理异步数据流，解耦数据生产和消费。

==== 基于 Promise 的实现

```javascript
class TaskQueue {
  constructor(concurrency = 1) {
    this.queue = [];
    this.concurrency = concurrency;
    this.running = 0;
  }

  // 添加任务
  add(task) {
    return new Promise((resolve, reject) => {
      this.queue.push({
        task,
        resolve,
        reject
      });

      this.process();
    });
  }

  // 处理任务
  async process() {
    if (this.running >= this.concurrency || this.queue.length === 0) {
      return;
    }

    this.running++;
    const { task, resolve, reject } = this.queue.shift();

    try {
      const result = await task();
      resolve(result);
    } catch (error) {
      reject(error);
    } finally {
      this.running--;
      this.process();  // 处理下一个任务
    }
  }
}
```

*使用*：

```javascript
const queue = new TaskQueue(3);  // 最多 3 个并发

// 添加 10 个任务
for (let i = 0; i < 10; i++) {
  queue.add(() => {
    console.log(`Task ${i} started`);
    return new Promise(resolve => {
      setTimeout(() => {
        console.log(`Task ${i} completed`);
        resolve(i);
      }, 1000);
    });
  }).then(result => {
    console.log(`Result: ${result}`);
  });
}

// 输出：
// Task 0 started
// Task 1 started
// Task 2 started
// (1秒后)
// Task 0 completed
// Result: 0
// Task 3 started
// ...
```

==== 基于生成器的实现

```javascript
function* producer() {
  let i = 0;
  while (true) {
    yield i++;
  }
}

function* consumer(producer) {
  while (true) {
    const value = producer.next().value;
    console.log("Consumed:", value);
    yield value;
  }
}

// 使用
const prod = producer();
const cons = consumer(prod);

cons.next();  // Consumed: 0
cons.next();  // Consumed: 1
cons.next();  // Consumed: 2
```

==== 基于 AsyncIterator 的实现

```javascript
class AsyncQueue {
  constructor() {
    this.items = [];
    this.resolvers = [];
  }

  // 生产者：添加数据
  push(item) {
    if (this.resolvers.length > 0) {
      const resolve = this.resolvers.shift();
      resolve({ value: item, done: false });
    } else {
      this.items.push(item);
    }
  }

  // 消费者：获取数据
  pop() {
    if (this.items.length > 0) {
      return Promise.resolve({
        value: this.items.shift(),
        done: false
      });
    }

    return new Promise(resolve => {
      this.resolvers.push(resolve);
    });
  }

  // 实现 AsyncIterator
  [Symbol.asyncIterator]() {
    return {
      next: () => this.pop()
    };
  }
}
```

*使用*：

```javascript
const queue = new AsyncQueue();

// 消费者：异步迭代
(async () => {
  for await (const item of queue) {
    console.log("Processed:", item);
  }
})();

// 生产者：添加数据
setTimeout(() => queue.push(1), 1000);
setTimeout(() => queue.push(2), 2000);
setTimeout(() => queue.push(3), 3000);

// 输出：
// (1秒后) Processed: 1
// (2秒后) Processed: 2
// (3秒后) Processed: 3
```

==== 应用场景

#tex-table(
  ("场景", "说明", "示例"),
  ("任务队列", "限制并发数", "图片上传、API 请求"),
  ("数据流处理", "背压控制", "文件读写、网络流"),
  ("消息队列", "异步消息处理", "RabbitMQ、Kafka"),
  ("批处理", "批量处理数据", "数据库批量插入"),
  ("工作线程池", "CPU 密集型任务", "图像处理、计算"),
)

=== 异步迭代器与生成器

异步迭代器和生成器提供了处理异步数据流的优雅方式。

==== 生成器基础

生成器函数可以暂停和恢复执行。

```javascript
function* numberGenerator() {
  yield 1;
  yield 2;
  yield 3;
}

const gen = numberGenerator();

console.log(gen.next());  // { value: 1, done: false }
console.log(gen.next());  // { value: 2, done: false }
console.log(gen.next());  // { value: 3, done: false }
console.log(gen.next());  // { value: undefined, done: true }
```

==== 异步生成器

异步生成器可以 yield Promise。

```javascript
async function* asyncNumberGenerator() {
  yield await Promise.resolve(1);
  yield await Promise.resolve(2);
  yield await Promise.resolve(3);
}

// 使用 for-await-of
(async () => {
  for await (const num of asyncNumberGenerator()) {
    console.log(num);  // 1, 2, 3
  }
})();
```

==== 实战：分页数据加载

```javascript
async function* fetchPages(baseUrl) {
  let page = 1;
  let hasMore = true;

  while (hasMore) {
    const response = await fetch(`${baseUrl}?page=${page}`);
    const data = await response.json();

    for (const item of data.items) {
      yield item;
    }

    hasMore = data.hasMore;
    page++;
  }
}

// 使用：像同步代码一样处理异步数据流
(async () => {
  for await (const item of fetchPages("https://api.example.com/items")) {
    console.log(item);
    // 可以在这里处理每个 item
    // 不需要关心分页逻辑
  }
})();
```

==== 实战：无限滚动

```javascript
async function* infiniteScroll(fetchFn) {
  let cursor = null;

  while (true) {
    const { items, nextCursor } = await fetchFn(cursor);

    for (const item of items) {
      yield item;
    }

    if (!nextCursor) {
      break;
    }

    cursor = nextCursor;
  }
}

// 使用
const fetchPosts = async (cursor) => {
  const url = cursor
    ? `/api/posts?cursor=${cursor}`
    : "/api/posts";

  const response = await fetch(url);
  return response.json();
};

(async () => {
  let count = 0;
  for await (const post of infiniteScroll(fetchPosts)) {
    console.log(post.title);
    count++;

    // 加载 100 条后停止
    if (count >= 100) {
      break;
    }
  }
})();
```

==== 异步迭代器协议

手动实现异步迭代器。

```javascript
class AsyncRange {
  constructor(start, end) {
    this.start = start;
    this.end = end;
  }

  [Symbol.asyncIterator]() {
    let current = this.start;

    return {
      async next() {
        // 模拟异步操作
        await new Promise(resolve => setTimeout(resolve, 100));

        if (current < this.end) {
          return { value: current++, done: false };
        } else {
          return { done: true };
        }
      }
    };
  }
}

// 使用
(async () => {
  for await (const num of new AsyncRange(0, 5)) {
    console.log(num);  // 0, 1, 2, 3, 4 (每个间隔 100ms)
  }
})();
```

==== 组合异步迭代器

```javascript
// 过滤
async function* filter(asyncIterable, predicate) {
  for await (const item of asyncIterable) {
    if (predicate(item)) {
      yield item;
    }
  }
}

// 映射
async function* map(asyncIterable, transform) {
  for await (const item of asyncIterable) {
    yield transform(item);
  }
}

// 限制数量
async function* take(asyncIterable, count) {
  let taken = 0;
  for await (const item of asyncIterable) {
    if (taken >= count) break;
    yield item;
    taken++;
  }
}

// 组合使用
(async () => {
  const numbers = new AsyncRange(0, 100);

  const result = await Array.fromAsync(
    take(
      filter(
        map(numbers, n => n * 2),
        n => n % 3 === 0
      ),
      5
    )
  );

  console.log(result);  // [0, 6, 12, 18, 24]
})();
```

#note[
  `Array.fromAsync()` 是 ES2023 新增的方法，用于将异步迭代器转换为数组。
]

==== 应用场景

#tex-table(
  ("场景", "说明", "示例"),
  ("分页数据", "逐页加载", "无限滚动、懒加载"),
  ("数据流处理", "流式处理大数据", "文件读取、网络流"),
  ("实时数据", "WebSocket 消息流", "股票行情、聊天消息"),
  ("数据库查询", "游标遍历", "大量数据查询"),
  ("管道处理", "数据转换管道", "ETL、数据处理"),
)

#fancy-divider

本节介绍了高级异步模式，包括回调地狱的解决方案、发布-订阅模式、生产者-消费者模式以及异步迭代器与生成器。这些模式能够帮助你解决复杂的异步编程场景，写出更优雅、更可维护的代码。


== 定时器与异步调度
=== setTimeout / setInterval
=== requestAnimationFrame
=== setImmediate（Node.js）
=== process.nextTick（Node.js）



== 实战示例
=== API 请求封装
=== 并发控制
=== 重试机制
=== 超时控制
