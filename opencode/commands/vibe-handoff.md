---
description: Generate a handoff package for switching to another AI tool (e.g. Codex→Claude Code). Produces a concise bundle so the next tool can resume without losing context.
agent: general
---

跨工具交接命令:生成一份精简交接包,让另一个 AI 工具(Claude Code / Codex / Cursor)能无缝接上当前任务,不依赖会话记忆。

## 什么时候用
- 当前工具上下文快爆了,想换一个工具继续
- 想用不同工具做不同角色(如 Codex 写后端,Claude Code 审代码)
- 当前工具卡住了,想换一个试试

## 执行步骤

### Step 1: 读当前状态
- `docs/CURRENT.md` — 当前 feature / 角色 / task / 卡点
- `docs/PROG-{today}.md` — 今天做了什么
- 当前 task 的定义(从 DEV 文件查)

### Step 2: 生成交接包
在对话里输出一段**可直接复制粘贴到新工具**的交接文本。结构:

```
## 任务交接包(复制到新工具开头)

### 一句话上下文
我在用 vibe-coding-harness 做 <feature 名>,当前角色是 <role>,做到 task-XXX <标题>。

### 你需要先读这些文件(按顺序)
1. AGENTS.md — 项目行为规范(尤其是第 1.1 防发散、第 9 交接、第 10 角色协作)
2. docs/CURRENT.md — 当前任务状态(必须第一个读)
3. docs/REQ-{today}-{NN}-*.md — 当前 feature 需求
4. docs/DEV-{today}-{NN}-*.md — 技术方案 + task 清单(只读当前 task 段)
5. templates/roles/<role>.md — 你的角色定义(按角色读对应文件)
6. <当前 task 涉及的代码文件,从 files_touched 摘>

### 当前状态(从 CURRENT.md 摘)
- 当前 Feature: <feature 名>
- 当前角色: <role>
- 当前 Task: task-XXX <标题>,状态 <in-progress/blocked>
- 已完成: <具体做了什么>
- 卡点: <无 / 具体卡在哪>
- 下一步: <下一步具体做什么,精确到文件和函数>

### 铁律(必须遵守)
- 每次改动前自证:对应 task-XXX 的哪条 success_criteria?不对应就不做。
- TDD 红绿停:测试红→最小实现→绿→立即停,不优化不重构。
- 新依赖零容忍:task 没声明的新包,记 TODO 问用户。
- 只动 files_touched 里的文件。
- 结束前必须更新 docs/CURRENT.md 和 docs/PROG-{today}.md。

### 立即开始
请先按上面顺序读完文件,然后告诉我:你的角色、当前 task、下一步要做什么。确认无误后我们继续。
```

### Step 3: 更新 CURRENT.md
在 CURRENT.md 的"当前角色"段加一行:
```markdown
- 上次交接: YYYY-MM-DD HH:MM,从 <工具 A> 交接给 <工具 B>
- 交接原因: <如"上下文快爆"/"换工具做 reviewer 交叉审">
```

### Step 4: 提醒用户
在对话里输出:
```
交接包已生成(见上)。

操作步骤:
1. 复制上面的"任务交接包"整段
2. 打开 <目标工具,如 Claude Code>
3. 在项目目录启动,粘贴交接包作为第一句话
4. 新工具会按交接包读文件,无缝接上

⚠️ 注意:
- 新工具必须能访问项目目录(读 docs/ 和代码)
- 新工具建议用与当前工具不同的模型(交叉审查/互补盲区)
- 交接后,原工具的对话可以归档,但不要急着删(以防回滚)
```

## 铁律
- **交接包要精简**:只列必读文件 + 当前状态 + 铁律,不要把整个对话历史塞进去。
- **新工具必须读 CURRENT.md**:这是唯一真相源,不读等于没交接。
- **交接不等于完成**:交接后必须更新 CURRENT.md 记录交接事实,否则下次会断档。
- **跨工具角色推荐**:如果用户没指定新工具,按 SKILL.md 的"跨工具角色推荐表"建议。
