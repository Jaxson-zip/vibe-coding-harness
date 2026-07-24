---
description: Create page structure, interaction flows, and state specs from REQ. Run as designer role after /vibe-spec.
agent: general
---

设计师角色命令:根据 REQ 出页面结构、交互流程、状态规范。产物是 DESIGN 文档,供 architect 和 frontend 消费。

## 前置条件
- 角色应为 `designer`(如果不是,提示用户先 `/vibe-role designer`)
- 当前 feature 的 REQ 文件已存在(从 CURRENT.md 查路径)

## 执行步骤

### Step 1: 读上下文
- `docs/CURRENT.md`
- 当前 feature 的 `docs/REQ-{today}-{NN}-*.md`
- 已有的设计规范文档(如果有)
- `templates/roles/designer.md`(角色定义)

### Step 2: 拆页面
把 REQ 里的功能拆成页面/路由,每个页面定:
- 路由路径
- 主要内容(放什么)
- 次要内容(辅助信息)
- 数据来源(从哪个 API / 表)

### Step 3: 定交互流程
每个页面或跨页面,用步骤列表描述:
1. 用户做 X → 系统响应 Y
2. 成功 → 去 Z
3. 失败 → 显示 W

### Step 4: 定四态(强制)
每个页面/组件必须有 4 个状态,缺一不可(缺了后期必返工):
- **loading**:加载中怎么显示
- **empty**:没数据怎么显示
- **error**:出错怎么显示
- **success**:成功怎么显示

### Step 5: 引用视觉规范
不重复造设计系统,引用项目已有的:
- 配色(主色/辅色/警告/错误)
- 字体
- 间距栅格
- 组件库(Ant Design / shadcn / Element / 原生)

如果项目还没有视觉规范,在这一步定一份基础的(不要过度设计)。

### Step 6: 生成 DESIGN 文件
写到 `docs/DESIGN-{today}-{NN}-{描述}.md`,结构按 `templates/roles/designer.md` 的产物契约。

### Step 7: 自检(强制)
生成后自问:
1. 每个页面都有四态吗?(loading/empty/error/success)
2. 有没有页面没标数据来源?(没标说明需求不清,回退给 pm)
3. 交互流程有没有死循环?(点了去不了下一页)
4. 视觉规范有没有引用已有系统?(不重复造)

在对话里输出自检结果。

### Step 8: 更新 CURRENT.md
- 角色: `designer`
- 产物路径写进"相关文件"
- 下一步: "DESIGN 完成,建议切到 architect 出技术方案: /vibe-role architect"

## 铁律
- **不写代码**:只输出设计描述,不输出 HTML/CSS/JS
- **不做像素级设计稿**:用结构化描述 + 草图,把视觉细节留给前端
- **不改 REQ**:发现需求漏洞,记 TODO 让 pm 处理
- **不引入新组件库**:要换组件库记 TODO 问用户
- **四态缺一不可**:这是后期返工的高发区
