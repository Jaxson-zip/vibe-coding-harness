---
description: Review code against checklist (contract/coverage/boundary/security/scope-creep/style). Read-only, produces REVIEW.md with P0/P1/P2. Must use a different tool than the implementer.
agent: general
---

代码审查命令:按 6 大类 checklist 审代码,出 REVIEW 报告。只读不改,发现问题写报告让原作者修。强制交叉工具审查。

## 前置条件
- 角色应为 `reviewer`(如果不是,提示用户先 `/vibe-role reviewer`)
- 当前 feature 已有实现代码
- **强烈建议**:本命令用与实现者不同的 AI 工具执行(交叉审查)

## 执行步骤

### Step 1: 读上下文
- `docs/CURRENT.md` — 当前 task
- `docs/REQ-{today}-{NN}-*.md` — 验收标准
- `docs/DEV-{today}-{NN}-*.md` — 技术方案、API 契约、数据模型、task 清单
- 当前 task 的 files_touched 清单里的所有代码文件
- `AGENTS.md` 第二部分 — 项目规范

### Step 2: 确认交叉审查
在对话里输出:
```
## 审查信息
- 审查工具: <本工具,如 Claude Code>
- 实现工具: <从 PROG/CURRENT 推断,如 Codex>
- 是否交叉: ✅ 不同工具 / ⚠️ 同工具(盲区未补,建议换工具重审)
```

### Step 3: 按 6 大类 checklist 审查
对当前 task 的每个文件,逐项过:

**1. 契约符合性**
- 数据模型字段/类型/约束符合 DEV?
- API 请求/响应格式符合 DEV?
- 改动都在 files_touched 里?(有越界?)

**2. 验收标准覆盖**
- REQ 每条验收标准都有对应实现?
- 有漏掉的?

**3. 边界情况**
- 空/null/undefined 处理?
- 超长/超大输入?
- 并发(如有共享状态)?
- 失败路径(外部服务超时、DB 错误、网络断)?

**4. 安全**
- SQL 参数化,没拼接?
- 用户输入有校验?
- 没硬编码密钥/凭证?
- 权限检查到位?

**5. 防发散检查**
- 有超出 task 范围的改动?(不该动的文件被改了)
- 引入未声明的新依赖?
- 过度抽象?(为未发生的需求建复杂结构)

**6. 代码风格**
- 符合 AGENTS.md 命名/格式规范?
- 沿用仓库已有模式?

### Step 4: 出 REVIEW 报告
写到 `docs/REVIEW-{today}-{NN}-{描述}.md`,结构按 `templates/roles/reviewer.md` 的产物契约。

问题分级:
- **P0 阻断** — 必须修才能继续(如:安全漏洞、数据丢失风险、契约不符、核心逻辑错)
- **P1 严重** — 上线前必须修(如:边界遗漏、错误处理缺失)
- **P2 建议** — 可不修(如:命名建议、可读性优化)

### Step 5: 触发 Human Checkpoint(如有)
**遇到以下情况必须暂停,等用户拍板:**
- 有任何 P0 问题
- 有 2 个以上 P1 问题
- 改动了数据库结构
- 引入了新依赖
- 改动了核心链路(登录、支付、权限等)

在对话里醒目输出:
```
⚠️ Human Checkpoint 触发
原因: <如发现 P0 安全问题>
需要你确认: <是否继续 / 是否回滚 / 是否让 backend 修>
```

### Step 6: 自检(强制)
1. 6 大类 checklist 都过了吗?(不能跳)
2. 每条问题都有文件:行号?
3. P0/P1 分级合理吗?(不要把 P2 标成 P0 制造恐慌)
4. 有没有擅自改代码?(改了就回滚,reviewer 只读)
5. 是不是跟实现者用了不同工具?(同工具要在顶部警告)

### Step 7: 更新 CURRENT.md + PROG
- CURRENT.md: 角色记为 `reviewer`,产物路径填 REVIEW
- PROG.md: 追加"审查完成,X P0 / Y P1 / Z P2"
- 下一步:
  - 有 P0 → "建议切到 <角色> 修 P0,详见 docs/REVIEW-*.md,修完重审"
  - 无 P0,有 P1 → "P1 建议修,或用户确认接受风险后继续"
  - 全通过 → "建议切到 tester 测试: /vibe-role tester"

## 铁律
- **绝不改代码**:只读,发现问题写 REVIEW
- **6 大类必过**:即使看着没问题也要逐项确认
- **P0 必触发 Human Checkpoint**:不放过任何阻断问题
- **强制交叉工具**:同工具审查要在顶部警告,建议用户换工具重审
- **不替用户决策**:技术选型/范围变更只建议,不擅自定
