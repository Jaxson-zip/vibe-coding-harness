---
name: vibe-execute
description: Execute tasks one by one with strict TDD red-green-stop discipline. Run AFTER /vibe-tasks. Reads current task from CURRENT.md, self-proves necessity, writes test first, minimal impl to pass, then STOPS (no refactor/optimize). Triggers on: "execute task", "TDD", "implement task", "执行 task", "/vibe-execute".
---

按 task 清单逐个执行,严格 TDD 红绿,绿了就停,防止 AI 顺手发散。

## 执行步骤

### Step 0: 开工前必读
**【强制】** 先读:
1. `docs/CURRENT.md` — 确认当前 task、当前角色
2. 当前 task 的完整定义(从 tasks 文件里找对应 task-XXX)
3. `AGENTS.md` 的防发散条款(第 1.1 节)和任务交接条款(第 9 节,含 9.1 心跳式更新)

### Step 1: 定位当前 task
- 从 `docs/CURRENT.md` 的"当前 Task"段读出 task-XXX
- 从 tasks 文件里读出该 task 的 goals / success_criteria / files_touched / out_of_scope
- 如果 CURRENT.md 显示状态是 blocked,先解决卡点再开工

### Step 2: 自证必要性(防发散第一道关)
动手前,在对话里输出:
```
本次要做的:
- Task: task-XXX <标题>
- 目标: <goals>
- 验收标准: <success_criteria>
- 涉及文件: <files_touched>
- 不做: <out_of_scope>

准备开工,先写测试。
```
等用户说"开干"或默认继续。

**前端可视化区块特例**:如果本 task 是写可见的 UI 区块(导航/Hero/卡片等),且 DESIGN 文档里没有明确的视觉参考,动手写代码前先找 2-3 个同类网站样例让用户确认风格。开发者往往不知道自己想要什么,凭空写返工率极高。详见 `/vibe-design` Step 2.5。

### Step 3: TDD 红绿循环
对当前 task 的每条 success_criteria:

1. **红**:写一条测试,跑,确认失败(测试本身是对的,实现还没写)
2. **绿**:写最小实现让测试通过,**只写够通过的最少代码**
3. **停**:绿了立即停这个循环,**不许**:
   - 顺手重构
   - 顺手抽函数
   - 顺手加新抽象
   - 顺手优化性能(除非 task 显式要求)
4. 下一条 success_criteria → 回到步骤 1

### Step 4: 防发散检查(强制)
每个 task 做完后,自问并在对话输出:
1. 我改的每个文件都在 files_touched 清单里吗?(不在,说明发散了,回滚或记 TODO)
2. 我引入新依赖了吗?(引入了且 task 没声明,回滚,记 TODO 询问用户)
3. 我做了 out_of_scope 里的东西吗?(做了就回滚)
4. 测试全绿了吗?(没绿不能算完)

### Step 5: 跑验证
- 文件级:typecheck / lint / 单文件测试(快速反馈)
- task 级:全量测试(确保没破坏其他)
- 都绿了才进下一步

### Step 6: 更新文档(强制,三件套)
1. 把 task 状态改成 done,写进 tasks 文件
2. 更新 `docs/CURRENT.md`:
   - 当前 Task 推进到下一个
   - "已完成"段记录本次成果
   - "下一步"精确到下一个 task 的第一个动作
3. 追加 `docs/PROG-{today}.md`:做了什么、遇到什么、遗留什么、下一步

### Step 7: 循环或停
- 如果还有下一个 task,问用户:"task-XXX 完成,继续 task-YYY 吗?"
- 用户同意 → 回到 Step 1 处理下一个 task
- 用户停 → 确保 CURRENT.md 已更新(交接完整),结束

## 铁律
- **绿了就停**,这是防发散的核心。YAGNI。
- **单文件原则**:只动 files_touched 里的文件,跨文件改动需在 plan 里声明过。
- **新依赖零容忍**:task 没声明的新依赖,一律记 TODO 问用户,不许自己装。
- **每次改动自证**:对应哪条 success_criteria?不对应就不做。
- **CURRENT.md 必须更新**:没更新 = 任务没交接 = 下次切换 agent 会断档。
- **心跳式更新**:每完成一个文件改动 / 每跑完一次 TDD 红绿循环,立即更新 CURRENT.md,防被动中断。
