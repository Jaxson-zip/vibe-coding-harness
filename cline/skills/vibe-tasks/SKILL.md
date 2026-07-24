---
name: vibe-tasks
description: Break a feature spec into tasks with strong fields (goals/success_criteria/files_touched/out_of_scope). Run AFTER /vibe-spec and /vibe-clarify. Produces docs/DEV-{date}-{NN}-{feature}-tasks.md. Triggers on: "break down tasks", "task list", "拆 task", "task 清单", "/vibe-tasks".
---

把 feature 拆成可执行的 task 清单。每个 task 带强字段,让 AI 知道"何时算完",防止无限做下去。

## 执行步骤

### Step 1: 读上下文
读:
- 当前 feature 的 spec(`docs/REQ-{today}-{NN}-*.md`)
- clarify 的决策记录
- `docs/CURRENT.md`
- 相关现有代码(沿用已有模式)

### Step 2: 拆分原则
- **最小纵向切片**:每个 task 是一个端到端可验证的小闭环,不是横向分层(不是"先写完所有 model 再写所有 API")。
- **2-8 小时一个 task**:太大就拆,太小就合。
- **依赖明确**:task 之间标依赖关系,无依赖的可以并行。
- **测试 task 单列**:每个功能 task 配一个测试 task,或测试内嵌在功能 task 里(二选一,在 plan 里声明)。

### Step 3: 生成 task 清单文件
写到 `docs/DEV-{today}-{NN}-{feature描述}-tasks.md`,每个 task 必须包含以下强字段:

```markdown
# Feature: <feature 名> — Task 清单

## task-001: <task 标题>
- 状态: todo
- 目标(goals):
  - <这个 task 要达成什么,1-2 句>
- 验收标准(success_criteria,必须可测试):
  - <当 X 时,应 Y>
  - <当 X 时,应 Y>
- 涉及文件(files_touched):
  - <路径> — <作用>
  - <路径> — <作用>
- 依赖(dependencies): [task-XXX, ...]
- 不做(out_of_scope,防发散):
  - <不做什么>
  - <不做什么>
- 预估: <2h / 4h / 8h>

## task-002: ...
(同上结构)
```

### Step 4: 自检(强制)
生成后,自问:
1. 每个 task 的 success_criteria 是不是都可测试?(不可测试就改写)
2. 每个 task 的 out_of_scope 是不是真的挡住了"顺手做"的可能?
3. 有没有循环依赖?(有就重新拆)
4. 有没有 task 太大(超 8 小时)?(有就拆)
5. 第一个 task 是不是无依赖、能立刻开工?(不是就重排)

在对话里输出自检结果。

### Step 5: 更新 CURRENT.md
把完整 task 清单复制到 CURRENT.md 的"待办 Task 清单"段,把第一个 task 设为"当前 Task"。

## 铁律
- **禁止拆得过细**:小于 1 小时的 task 合并到相邻 task。
- **禁止拆得过粗**:超 8 小时的必须拆。
- **每个 task 必须有 out_of_scope 段**,哪怕只有一条。
- task 文件要 git 纳管,它是执行期的真相源。
