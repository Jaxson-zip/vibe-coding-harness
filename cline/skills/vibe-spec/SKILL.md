---
name: vibe-spec
description: Create a feature-level spec document with Out-of-Scope section. Use BEFORE writing any feature code, when starting a new feature, to prevent rework and scope creep. Produces docs/REQ-{date}-{NN}-{feature}.md. Triggers on: "write spec", "feature spec", "requirements doc", "feature requirements", "我要做新功能", "/vibe-spec".
---

为单个 feature 编写需求规格文档(spec)。这是动手写代码前的第一步,目的是把"做什么/不做什么/怎么算完工"写清楚,防止返工和发散。

## 执行步骤

### Step 1: 读上下文
先读:
- `docs/CURRENT.md`(看当前项目状态,避免重复)
- `AGENTS.md` 第一部分(行为规范,尤其防发散条款 1.1)
- 相关的 `docs/REQ-*.md`(项目级需求,看这个 feature 属于哪条)

### Step 2: 询问用户(必问项)
向用户确认:
1. **Feature 名字**:一句话能说清(如"用户登录")
2. **做什么**:这个 feature 要解决什么问题
3. **不做什么(关键)**:明确哪些**不**在本次范围,引导用户拒绝过度设计

### Step 3: 生成 spec 文件
写到 `docs/REQ-{today}-{NN}-{feature简短描述}.md`,结构如下(必须包含全部段落):

```markdown
# Feature: <feature 名>

## 做什么
<2-3 句话说清这个 feature 要解决什么问题>

## 为什么
<业务理由,1-2 句>

## 验收标准(必须可测试)
- 当 <输入/条件> 时,应 <行为>,则 <结果>
- 当 <输入/条件> 时,应 <行为>,则 <结果>
- (每条都用"当...应...则..."句式,后面能直接转测试)

## Out-of-Scope(本 feature 不做,关键防发散)
- 不做 <X> — 原因: <为什么不在本次>
- 不做 <Y> — 原因: <为什么不在本次>
- 不做 <Z> — 原因: <为什么不在本次>
- (把所有可能"顺手做"的东西都列出来挡住)

## 相关文件(预估,写代码前参考)
- <路径> — <作用>
- <路径> — <作用>

## 依赖
- <前置 feature / 外部服务 / 数据库表>
```

### Step 4: 自检(强制)
生成 spec 后,自问自答这 3 个问题,在对话里输出:
1. 有没有哪条验收标准是不可测试的?(如果有,改写成可测试的)
2. Out-of-Scope 段是否真的把"AI 容易顺手做的东西"都挡住了?(至少列 3 条)
3. 这个 feature 依赖的前置条件是否都具备?(不具备的加到"依赖"段)

### Step 5: 更新 CURRENT.md
把当前 feature 信息写进 `docs/CURRENT.md` 的"当前 Feature"段,角色设为 `pm`。

## 输出
- 文件:`docs/REQ-{today}-{NN}-{描述}.md`
- 对话里输出:自检 3 问的答案
- 提示用户:下一步用 `/vibe-clarify` 列歧义点
