---
description: Write integration/e2e tests from REQ acceptance criteria, run them, and produce a test report. Run as tester role after backend/frontend implementation.
agent: general
---

测试角色命令:把 REQ 的验收标准转成测试用例,写集成/端到端测试,跑测试,出报告。不改业务代码。

## 前置条件
- 角色应为 `tester`(如果不是,提示用户先 `/vibe-role tester`)
- 当前 feature 的 REQ 文件存在(验收标准来源)
- backend/frontend 已实现代码(否则没东西可测)

## 执行步骤

### Step 1: 读上下文
- `docs/CURRENT.md`
- 当前 feature 的 `docs/REQ-{today}-{NN}-*.md`(验收标准)
- 当前 feature 的 `docs/DEV-{today}-{NN}-*.md`(API 契约)
- `templates/roles/tester.md`(角色定义)

### Step 2: 把验收标准转测试用例
从 REQ 的"验收标准"段,每条转成 1+ 个测试用例:

| 用例 ID | 对应 AC | 输入 | 期望 | 类型 |
|---|---|---|---|---|
| TC-001 | AC-1: 正确账号密码登录 | 合法账号+正确密码 | 200 + token | 集成 |
| TC-002 | AC-2: 错误密码 | 合法账号+错误密码 | 401 | 集成 |
| TC-003 | AC-3: 错误 5 次锁定 | 连续错 5 次 | 423 | 集成 |
| TC-004 | 完整登录流程 | 输入→提交→跳转 | 跳到 /home | E2E |

### Step 3: 写测试代码
- 集成测试: `tests/integration/{feature}-*.test.{ext}`
- E2E 测试: `tests/e2e/{feature}-*.spec.{ext}`
- 外部 API 和数据库一律 mock
- 用项目已有的测试框架,不引入新的

### Step 4: 跑测试
按 AGENTS.md 里的测试命令跑,记录:
- 通过数 / 失败数
- 覆盖率(如果能测)
- 失败的具体原因

### Step 5: 写 BUG 文档(如果有失败)
每个失败的用例写一份 `docs/BUG-{today}-{NN}-{描述}.md`:
- 关联 REQ(从哪个验收标准来)
- 复现步骤
- 期望 vs 实际
- 严重程度(P0/P1/P2)
- 建议给哪个角色修

### Step 6: 生成测试报告
写到 `docs/TEST-{today}-{NN}-{描述}.md`,结构按 `templates/roles/tester.md` 的产物契约。

### Step 7: 自检(强制)
1. 每条测试用例都能追溯到 REQ 的某条验收标准吗?(不能追溯的就是发散)
2. 有没有验收标准没被测到?(有就补)
3. 有没有擅自扩大测试范围?(测了 REQ 没要求的)
4. 测试用例有没有引入新测试框架?(有就回滚,记 TODO)

### Step 8: 更新 CURRENT.md + PROG
- CURRENT.md: 角色记为 `tester`,产物路径填 TEST 报告
- PROG.md: 追加"测试完成,X 通过 Y 失败,发现 N 个 bug"
- 下一步: 如果全绿 → "建议切到 devops 部署: /vibe-role devops";如果有 bug → "建议切到 backend/frontend 修 bug,BUG 文档见 docs/BUG-*.md"

## 铁律
- **不改业务代码**:发现 bug 只写 BUG 文档,让 backend/frontend 改
- **不扩大测试范围**:只测 REQ 里的验收标准
- **不引入新测试框架**:用项目已有的
- **每条用例可追溯**:必须对应 REQ 的某条验收标准
- **不擅自降低验收标准**:REQ 说啥就测啥,不能图省事改
