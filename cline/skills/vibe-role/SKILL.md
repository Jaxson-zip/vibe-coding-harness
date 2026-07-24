---
name: vibe-role
description: Switch to a role (pm/designer/architect/backend/frontend/tester/reviewer/devops) for one-person-multi-role collaboration. Loads role definition from bundled docs/, reads only the role's required context, updates CURRENT.md for handoff. Triggers on: "switch role", "切角色", "as pm", "as backend", "vibe-role", "/vibe-role".
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
- `reviewer` — 代码审查员
- `devops` — 运维工程师

如果用户没给 role-id,列出 8 个角色和一句话定位让用户选。

### Step 2: 读角色定义文件
读本 skill 内置的 `docs/<role-id>.md`(相对于本 skill 目录)。例如切到 backend 就读 `docs/backend.md`。

如果项目根目录有 `roles/<role-id>.md`,**优先读项目内的**(项目可覆盖默认角色定义)。

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
| reviewer | CURRENT.md + REQ-*.md + DEV-*.md + files_touched 代码 + AGENTS.md 第二部分 |
| devops | CURRENT.md + DEV-*.md + TEST-*.md + 项目配置 |

### Step 4: 输出角色切换确认
在对话里输出:

```
## 角色切换: <role-id>

已加载角色定义: docs/<role-id>.md

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

## 角色系统概览

8 个角色的产物传递链:
```
👤 你(CEO)→ pm(REQ)→ designer(DESIGN)→ architect(DEV+tasks)
  → backend/frontend(代码)→ reviewer(REVIEW)→ tester(TEST/BUG)→ devops(OPS)→ 👤 你验收
```

每个角色的详细定义(职责/输入契约/产物契约/禁止行为)见本 skill 的 `docs/` 目录:
- `docs/README.md` — 角色系统总览
- `docs/pm.md` / `docs/designer.md` / `docs/architect.md` / `docs/backend.md`
- `docs/frontend.md` / `docs/tester.md` / `docs/reviewer.md` / `docs/devops.md`

## 铁律
- **切换角色 = 上下文重置**:只带新角色"输入契约"里列的文件,不带旧角色的对话历史。
- **CURRENT.md 必须更新**:不更新就等于没交接,下次切换会断档。
- **角色边界不可越**:切换到 backend 就不许改 REQ,切换到 tester 就不许改业务代码,即使看到了问题也只记 TODO。
- **切换前必须确认上一个角色已交接**:如果 CURRENT.md 显示上一个 task 状态是 in-progress,先提醒用户"上一个角色还有未完成的 task,是否要先更新 CURRENT 再切换"。

## Human Checkpoint 触发点

切换到 reviewer 后遇到 P0、切换到 devops 准备部署、任何角色要改数据库/加新依赖 → 必须暂停等用户拍板。
