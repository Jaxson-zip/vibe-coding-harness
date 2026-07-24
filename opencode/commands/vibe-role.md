---
description: Switch to a role (pm/designer/architect/backend/frontend/tester/devops). Loads the role definition and updates CURRENT.md for handoff.
agent: general
---

切换到指定角色,载入该角色的定义文件,只带该角色必需的上下文,更新 CURRENT.md。这是"一人公司多角色协作"的核心交接命令。

## 执行步骤

### Step 1: 接收角色 ID
用户输入格式:`/vibe-role <role-id>`,role-id 必须是以下之一:
- `pm` — 产品经理
- `designer` — 设计师
- `architect` — 架构师
- `backend` — 后端工程师
- `frontend` — 前端工程师
- `tester` — 测试工程师
- `devops` — 运维工程师

如果用户没给 role-id,列出 7 个角色和一句话定位让用户选。

### Step 2: 读角色定义文件
读 `templates/roles/<role-id>.md`(或项目内的 `roles/<role-id>.md`,优先项目内)。

搞清楚这个角色:
- 职责边界(做什么/不做什么)
- 输入契约(该读哪些文件)
- 产物契约(该输出什么)
- 禁止行为

### Step 3: 读必要上下文(只读这个角色需要的)
按角色定义的"输入契约"读文件,**不要读无关文件**(防爆):

| 角色 | 必读 |
|---|---|
| pm | AGENTS.md + CURRENT.md + 用户需求 |
| designer | CURRENT.md + REQ-*.md |
| architect | CURRENT.md + REQ-*.md + DESIGN-*.md + AGENTS.md 第二部分 |
| backend | CURRENT.md + DEV-*.md(只读当前 task 相关段) + AGENTS.md 第 1.1 节 |
| frontend | CURRENT.md + DEV-*.md + DESIGN-*.md + AGENTS.md 第 1.1 节 |
| tester | CURRENT.md + REQ-*.md + DEV-*.md + 当前代码 |
| devops | CURRENT.md + DEV-*.md + TEST-*.md + 项目配置 |

### Step 4: 输出角色切换确认
在对话里输出:

```
## 角色切换: <role-id>

已加载角色定义: roles/<role-id>.md

### 我的职责
- <一句话定位>
- ✅ 负责: <职责 1>, <职责 2>
- ❌ 不负责: <边界 1>, <边界 2>

### 已读上下文
- <文件 1>
- <文件 2>

### 当前状态(来自 CURRENT.md)
- 当前 Feature: <feature 名>
- 当前 Task: <task-XXX, 状态>
- 卡点: <无/具体>

### 下一步
按角色工作流,我接下来应该:
<1. ... 2. ... 3. ...>

准备好了,告诉我开始。
```

### Step 5: 更新 CURRENT.md
更新 `docs/CURRENT.md` 的"当前角色"段:

```markdown
## 当前角色
- 角色标识: <role-id>
- 切换前角色: <上一个角色,从 CURRENT.md 读>
- 切换原因: <用户本次切换的目的,如"REQ 写完,切 designer 出设计">
```

## 铁律
- **切换角色 = 上下文重置**:只带新角色"输入契约"里列的文件,不带旧角色的对话历史。
- **CURRENT.md 必须更新**:不更新就等于没交接,下次切换会断档。
- **角色边界不可越**:切换到 backend 就不许改 REQ,切换到 tester 就不许改业务代码,即使看到了问题也只记 TODO。
- **切换前必须确认上一个角色已交接**:如果 CURRENT.md 显示上一个 task 状态是 in-progress,先提醒用户"上一个角色还有未完成的 task,是否要先更新 CURRENT 再切换"。
