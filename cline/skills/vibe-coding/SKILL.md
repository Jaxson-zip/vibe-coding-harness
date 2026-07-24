---
name: vibe-coding
description: Vibe Coding engineering harness entry point. Use when starting a new project, retrofitting an existing project with engineering discipline, or whenever the user mentions "vibe coding", "engineering harness", "防返工", "防发散", "防断档". Provides workflow overview, 12 sub-command index (vibe-init/spec/clarify/tasks/execute/role/design/test/review/handoff/resume), 8-role collaboration system, and 3-protection mechanisms against rework/scope-creep/context-loss.
---

# Vibe Coding 工程化工作流(主入口)

本 skill 是 **vibe-coding-harness** 的主调度入口。它不直接执行任何具体任务,而是:

1. 告诉你整个工作流怎么走
2. 列出 12 个子命令何时用
3. 说明 8 个角色怎么协作
4. 指引用户从当前状态出发的下一步

## 三个核心痛点 + 三防机制

| 痛点 | 机制 | 用什么命令 |
|---|---|---|
| **防返工**(写完发现做错) | 写需求 + 动手前列歧义点 | `/vibe-spec` → `/vibe-clarify` |
| **防发散**(AI 顺手做没用的) | Out-of-Scope + 强字段 task + TDD 红绿停 | `/vibe-tasks` → `/vibe-execute` |
| **防断档**(切换 agent 丢上下文) | `docs/CURRENT.md` 任务交接单 + 心跳更新 | `/vibe-handoff` / `/vibe-resume` |

## 工作流总览

### Phase 0 — 项目初始化(整个项目跑 1 次)

| 场景 | 命令 |
|---|---|
| 空目录,从零开始 | `/vibe-init` |
| 已有代码,要建立规范 | `/vibe-retrofit` |

两者都会创建:
- `docs/` 目录(REQ/DEV/PROG/BUG/BIZ/REVIEW/TEST/OPS/CURRENT)
- `AGENTS.md`(行为规范 + 项目配置)
- 多工具 symlink(`CLAUDE.md`、`.windsurfrules`、`.clinerules` 等)

详见 [docs/multi-tool-sync.md](docs/multi-tool-sync.md)。

### Feature 级闭环(每个 feature 跑一遍)

```
/vibe-spec → /vibe-clarify → /vibe-tasks → /vibe-execute → /vibe-review → /vibe-test
                                                                        ↓
                                                              (有 P0/bug 回修)
```

### 跨工具 / 中断恢复

| 场景 | 命令 |
|---|---|
| 主动换工具(上下文快爆、做交叉审查) | `/vibe-handoff` |
| 被动中断(额度爆、断网、崩溃) | `/vibe-resume` |

## 命令索引(12 个子命令)

### 项目级
- `/vibe-init` — 空目录初始化新项目(docs/、AGENTS.md、symlink)
- `/vibe-retrofit` — 已有代码建立工程化规范(扫描 + 诊断 + 反推文档 + 划边界)

### Feature 级
- `/vibe-spec` — 写 feature 需求规格(含 Out-of-Scope 防发散)
- `/vibe-clarify` — 列歧义点逼用户拍板(防返工)
- `/vibe-tasks` — 拆 task 清单(goals/success_criteria/files_touched/out_of_scope 强字段)
- `/vibe-execute` — 按 task 执行,TDD 红绿停

### 角色级
- `/vibe-role <id>` — 切换角色(8 个角色之一)
- `/vibe-design` — designer 出 DESIGN.md(页面/交互/四态)
- `/vibe-test` — tester 出 TEST.md + BUG.md
- `/vibe-review` — reviewer 出 REVIEW.md(6 大类 checklist,P0/P1/P2 + Human Checkpoint)
- `/vibe-handoff` — 主动跨工具交接
- `/vibe-resume` — 被动中断恢复

## 角色系统(8 个角色,一人公司协作)

| 角色 ID | 一句话定位 | 上游 | 下游 |
|---|---|---|---|
| `pm` | 把模糊想法拆成可执行需求 | 用户(CEO) | designer, architect |
| `designer` | 出页面结构和交互流程 | pm | architect, frontend |
| `architect` | 出技术方案和 task 清单 | pm, designer | backend, frontend |
| `backend` | 写后端代码、API、迁移 | architect | reviewer, tester, devops |
| `frontend` | 写前端代码、页面、交互 | architect, designer | reviewer, tester |
| `tester` | 写测试、验质量、出报告 | pm, backend, frontend | devops |
| `reviewer` | 只读不改,按 checklist 审代码 | backend, frontend | backend, frontend, 用户 |
| `devops` | 打包、部署、监控 | backend, tester | 上线 |

**产物传递链:**
```
👤 你(CEO)→ pm(REQ)→ designer(DESIGN)→ architect(DEV+tasks)
  → backend/frontend(代码)→ reviewer(REVIEW)→ tester(TEST/BUG)→ devops(OPS)→ 👤 你验收
```

切换角色用 `/vibe-role <id>`,角色定义详见 `vibe-role/docs/<id>.md`。

## Human Checkpoint(强制人工拍板)

以下情况任何角色必须暂停,等用户明确同意才能继续:

- Reviewer 报告 P0 问题
- 有 2+ 个 P1 问题
- 改数据库结构
- 引入新依赖
- 上线部署
- 核心链路(登录、支付、权限等)第一个 task
- 范围变更(改 REQ / Out-of-Scope)

## 从当前状态开始的下一步

按当前项目状态选起点:

1. **空目录** → 跑 `/vibe-init`
2. **已有代码没规范** → 跑 `/vibe-retrofit`
3. **已初始化,要做新 feature** → 跑 `/vibe-spec`
4. **feature spec 写好了** → 跑 `/vibe-clarify`
5. **歧义点拍板了** → 跑 `/vibe-tasks`
6. **task 清单有了** → 跑 `/vibe-role <id>` 切角色,再 `/vibe-execute`
7. **代码写完了** → 跑 `/vibe-role reviewer` + `/vibe-review`(建议换工具交叉审查)
8. **review 通过** → 跑 `/vibe-role tester` + `/vibe-test`
9. **测试通过** → 跑 `/vibe-role devops`(部署前 `/vibe-handoff` 给用户授权)
10. **上下文快爆** → 跑 `/vibe-handoff` 生成交接包
11. **被动中断恢复** → 跑 `/vibe-resume`

## 核心原则

1. **规划优先** — 写代码前用最强模型写需求文档和技术方案
2. **先前端再后端** — 原型图先跑起来,不写好 API 契约不动后端
3. **范围冻结** — v1 做什么/不做什么一开始就写死
4. **分阶段推进** — 拆 Phase,每阶段有 DoD,不达标不进下一阶段
5. **文档即上下文外挂** — AI 每次对话前先读相关文档
6. **Feature 级闭环** — 每个 feature 走 spec→clarify→tasks→execute 四步
7. **防发散优先** — 测试绿了就停,YAGNI,新依赖零容忍,超出 task 只记 TODO

## 详细参考(按需加载)

- [docs/workflow.md](docs/workflow.md) — 完整工作流、Phase 模板、文档治理关联规则、数据库设计原则
- [docs/retrofit.md](docs/retrofit.md) — 已有项目规范化(Retrofit)详细流程
- [docs/multi-tool-sync.md](docs/multi-tool-sync.md) — 一份 AGENTS.md 通吃 10+ AI 工具的 symlink 策略

## 模型与工具建议

- **规划/设计文档**:用最强模型(Claude Opus / GPT 5.x)
- **编码实现**:中高模型即可
- **审查**:必须用与实现者**不同的工具**(交叉审查补盲区)
- **原型图**:Claude Design > GPT Image

## 铁律

- **CURRENT.md 是唯一真相源** — 每次开始新对话先读,每次结束前必更新
- **绿了就停** — TDD 红绿后立即停,不许顺手重构/优化/抽组件
- **新依赖零容忍** — task 没声明的新包,记 TODO 问用户,不许自己装
- **单文件原则** — 只动 files_touched 里的文件
- **每次改动自证** — 对应哪条 success_criteria?不对应就不做
