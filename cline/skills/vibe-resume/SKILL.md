---
name: vibe-resume
description: Resume work after passive interruption (quota exhausted / network down / crash / tab closed / reboot). Reconstructs state from docs/CURRENT.md + git diff + uncommitted changes, no handoff package needed. Use as the FIRST command when reopening Cline after any unplanned interruption. Triggers on: "resume", "继续上次", "恢复", "where was I", "上次做到哪", "/vibe-resume".
---

被动中断恢复命令:不依赖任何交接包,从 docs/ 文件 + git diff + 未提交改动推断当前状态,无缝接上。

## 什么时候用
- 上一个工具额度跑完了,没跑成 `/vibe-handoff`
- 网络断了 / 浏览器崩了 / tab 关了
- 重启电脑后回来继续
- 不确定上次做到哪了

## 执行步骤

### Step 1: 读所有状态文件(按顺序)
按这个顺序读,重建上下文:
1. `docs/CURRENT.md` — 最后一次心跳更新的状态(最重要)
2. `docs/PROG-{today}.md` — 今天做了什么
3. `AGENTS.md` — 行为规范(尤其第 1.1 防发散、第 9 交接、第 9.1 心跳更新)
4. 当前 feature 的 `docs/REQ-{today}-{NN}-*.md`(从 CURRENT 查路径)
5. 当前 feature 的 `docs/DEV-{today}-{NN}-*.md`(从 CURRENT 查路径,只读当前 task 段)
6. 角色定义:从 CURRENT 读当前角色,然后从 vibe-role skill 的 `docs/<role>.md` 读(或项目内 `roles/<role>.md`)

### Step 2: 检查 git 状态,找未提交改动
跑:
- `git status` — 看哪些文件改了没提交
- `git diff` — 看具体改了什么
- `git log --oneline -5` — 看最近提交

**关键:未提交的改动 = 上次中断时做到一半的工作**,要判断:
- 这些改动对应哪个 task?
- 改动完整吗?(有没有写到一半的函数)
- 能跑测试吗?

### Step 3: 跑测试验证当前状态
- 如果当前 task 有测试,跑一下,看红绿
- 绿 → 这个 sub-task 可能完成了,只是没提交
- 红 → 改动没做完,需要接着写实现

### Step 4: 推断当前状态,输出恢复报告
在对话里输出:

```
## 恢复报告

### 从 docs/ 读取的状态
- 当前 Feature: <feature 名>
- 当前角色: <role>
- 当前 Task: task-XXX <标题>
- CURRENT.md 记录的已完成: <X, Y>
- CURRENT.md 记录的下一步: <Z>

### 从 git 推断的实际情况
- 未提交改动:
  - <文件 1> — 改了 <什么>
  - <文件 2> — 改了 <什么>
- 最近提交: <commit hash> <message>

### 测试状态
- 跑了 <测试文件>: <红 / 绿>
- 推断: <这个 sub-task 可能完成但没提交 / 改动没做完>

### 推断:实际做到哪了
综合 docs 和 git,实际上次做到:
<如"task-003 的密码比对逻辑写完了,但 lock.ts 的锁定逻辑还没开始,因为 lock.ts 不在未提交改动里">

### 需要你确认
1. 这个推断对吗?(对 → 继续,不对 → 你告诉我实际做到哪)
2. 未提交的改动要保留吗?(保留 → 我接着做 / 丢弃 → git checkout 回滚)

### 下一步(确认后执行)
<精确到文件和函数,如"在 src/auth/lock.ts 写 lockUser(userId): boolean">
```

### Step 5: 等用户确认
**不要直接开始写代码**,先等用户确认推断对不对。因为:
- 被动中断可能留下半成品(写到一半的函数、没关的括号)
- 用户可能知道更多(如"我手动改了 XX,你别覆盖")

用户确认后:
- 推断对 → 继续按"下一步"干活
- 推断不对 → 用户告诉你实际状态,更新 CURRENT.md 后继续

### Step 6: 同步 CURRENT.md
如果推断和 CURRENT.md 记录的不一致(比如 CURRENT 说"下一步做 X",但 git 显示 X 已经做了),**以实际状态为准,更新 CURRENT.md**。

### Step 7: 继续工作
按角色工作流继续。第一个动作完成后,立即心跳更新 CURRENT.md(防再次中断)。

## 铁律
- **不依赖交接包**:这个命令就是为"没有交接包"的场景设计的。
- **以实际为准**:docs 和 git 不一致时,以 git 实际状态为准,回写 docs。
- **不擅自丢弃改动**:未提交的改动先问用户保留还是丢弃,不擅自 `git checkout`。
- **不直接开始写**:先输出恢复报告,等用户确认,防止在半成品上继续堆错误。
- **确认后立即心跳**:第一个动作做完就更新 CURRENT.md,防再次被动中断。

## 和 /vibe-handoff 的区别

| | /vibe-handoff | /vibe-resume |
|---|---|---|
| 场景 | 主动切换工具 | 被动中断,无法交接 |
| 依赖交接包 | 是(生成交接包) | 否(从 docs + git 推断) |
| 上下文来源 | 交接包明确指定 | docs + git diff 推断 |
| 需要用户确认 | 否(交接包已说清) | 是(推断可能不准) |
| 用在 | 想换工具 | 额度爆/崩溃/断网 |
