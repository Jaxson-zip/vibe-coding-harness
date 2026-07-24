# 角色系统

这个目录定义了一人公司多 AI agent 协作的所有角色。每个角色一份 `.md` 文件,定义该角色的职责边界、输入/产物契约、工作流和禁止行为。

## 为什么需要角色系统

vibe-coding 的核心痛点之一是 AI 发散——一个 agent 什么都做,从需求到代码到测试,容易越界。角色系统通过**职责边界 + 产物契约**强制每个 agent 只做自己的事,产物按固定格式传给下一个角色,形成流水线。

## 角色清单

| 角色 ID | 文件 | 一句话定位 | 上游 | 下游 |
|---|---|---|---|---|
| `pm` | `pm.md` | 把模糊想法拆成可执行需求 | 用户(CEO) | designer, architect |
| `designer` | `designer.md` | 出页面结构和交互流程 | pm | architect, frontend |
| `architect` | `architect.md` | 出技术方案和 task 清单 | pm, designer | backend, frontend |
| `backend` | `backend.md` | 写后端代码、API、迁移 | architect | reviewer, tester, devops |
| `frontend` | `frontend.md` | 写前端代码、页面、交互 | architect, designer | reviewer, tester |
| `tester` | `tester.md` | 写测试、验质量、出报告 | pm(验收标准), backend, frontend | devops |
| `reviewer` | `reviewer.md` | 只读不改,按 checklist 审代码 | backend, frontend | backend, frontend, 用户 |
| `devops` | `devops.md` | 打包、部署、监控 | backend, tester | 上线 |

## 角色切换协议

切换角色时通过 `/vibe-role <id>` 命令:

1. Agent 读 `roles/<id>.md` 加载该角色定义
2. Agent 按"输入契约"只读必要的上下文文件(不读无关文件,防爆)
3. Agent 在 `docs/CURRENT.md` 的"当前角色"段记录角色和切换原因
4. 工作完成后按"产物契约"输出固定格式的文件,供下游角色消费

## 跨工具交接

切换 AI 工具(Claude Code / Codex / Cursor)时用 `/vibe-handoff` 命令:
- 生成精简交接包(必读文件 + 当前状态 + 铁律)
- 用户复制交接包到新工具,无缝接上
- 不依赖会话记忆,只依赖 docs/ 文件

**关键:reviewer 和 tester 必须用与实现者不同的工具**(交叉审查补盲区)。

## Human Checkpoint

以下情况必须暂停等用户拍板:
- Reviewer 报告 P0 问题
- 有 2+ 个 P1 问题
- 改数据库结构 / 引入新依赖
- 上线部署
- 核心链路第一个 task
- 范围变更(改 REQ/Out-of-Scope)

## 人与 AI 的分工

| 角色 | 谁来做 |
|---|---|
| CEO / 决策者 | 👤 你自己(战略、商业判断、拍板) |
| Tech Lead / 技术拍板 | 👤 你自己(选型、架构决策) |
| PM / Designer / Architect / Backend / Frontend / Tester / DevOps | 🤖 AI 为主,你审核 |

## 产物传递链

```
👤 你(CEO,一句话需求)
   ↓
🤖 pm → docs/REQ-*.md
   ↓
🤖 designer → docs/DESIGN-*.md
   ↓
🤖 architect → docs/DEV-*.md (含 tasks)
   ↓
🤖 backend → 后端代码 + 迁移
🤖 frontend → 前端代码 + 页面
   ↓
🤖 tester → 测试代码 + 测试报告
   ↓
🤖 devops → Dockerfile + CI + 部署脚本
   ↓
👤 你验收上线
```

## 角色记忆(可选,跨项目沉淀)

每个角色可有一份长期记忆文件 `docs/roles/<id>/memory.md`,记录该角色跨项目积累的方法论和经验。与项目状态(CURRENT.md)分离,避免上下文爆炸。

## 完整产物传递链

```
👤 你(CEO,一句话需求)
   ↓
🤖 pm → docs/REQ-*.md
   ↓
🤖 designer → docs/DESIGN-*.md
   ↓
🤖 architect → docs/DEV-*.md (含 tasks)
   ↓
🤖 backend → 后端代码 + 迁移
   ↓ /vibe-review (交叉工具)
🤖 reviewer → docs/REVIEW-*.md (有 P0 回修,无 P0 继续)
   ↓
🤖 frontend → 前端代码 + 页面
   ↓ /vibe-review (交叉工具)
🤖 reviewer → docs/REVIEW-*.md
   ↓
🤖 tester → docs/TEST-*.md + docs/BUG-*.md
   ↓ (有 bug 回修,没 bug 继续)
   ↓
🤖 devops → Dockerfile + CI + docs/OPS-*.md
   ↓
👤 你验收上线
```

## Human Checkpoint 触发点

在传递链中,以下节点强制人工介入:
- backend/frontend 完成后 → reviewer 审,有 P0 触发 Checkpoint
- architect 改数据库结构 → 触发 Checkpoint
- 任何角色引入新依赖 → 触发 Checkpoint
- devops 上线前 → 触发 Checkpoint(必须用户授权)
