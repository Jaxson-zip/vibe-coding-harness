# Vibe Coding Harness

一套可跨 AI 工具的工程化管理方案 —— 给 AI 配上项目级"游戏规则"。

**一份 `AGENTS.md`，通吃 10+ 个 AI 编程工具**：Codex、Cursor、Claude Code、Windsurf、Copilot、Cline、Gemini CLI、Zed、Aider、OpenCode。

## 快速开始

### 方式一：运行初始化脚本（推荐）

在项目根目录执行：

**Windows (CMD — 双击即可):**
```cmd
path\to\vibe-coding-harness\scripts\init.cmd
```

**Windows (PowerShell):**
```powershell
& "path\to\vibe-coding-harness\scripts\init.ps1"
```

**macOS / Linux:**
```bash
bash path/to/vibe-coding-harness/scripts/init.sh
```

脚本会自动：
1. 创建 `docs/` 文档目录
2. 生成 `AGENTS.md`（含行为规范 + 项目配置模板）
3. 创建多工具软链接（`CLAUDE.md`、`.windsurfrules`、`GEMINI.md` 等）

然后只需把 `AGENTS.md` 里的 `<...>` 占位符替换成你项目的实际内容。

### 方式二：手动复制模板

直接把 `templates/AGENTS.md` 复制到项目根目录，编辑填入项目信息。

## 配套命令

项目级(用 1 次):
| 命令 | 场景 |
|------|------|
| `vibe-init` | 空目录，从零开始新项目 |
| `vibe-retrofit` | 已有代码，要理顺、划边界、建立规范 |

Feature 级(每个 feature 跑一遍):
| 命令 | 场景 |
|------|------|
| `vibe-spec` | 写单个 feature 需求,带 Out-of-Scope(防发散) |
| `vibe-clarify` | 动手前列歧义点,逼用户拍板(防返工) |
| `vibe-tasks` | 拆 task,带 goals/success_criteria/files_touched 强字段 |
| `vibe-execute` | 按 task 执行,TDD 红绿停,绿了就停 |

角色级(一人公司多角色协作):
| 命令 | 场景 |
|------|------|
| `vibe-role <id>` | 切换角色(pm/designer/architect/backend/frontend/tester/reviewer/devops) |
| `vibe-design` | 设计师出 DESIGN.md(页面结构、交互流程、四态) |
| `vibe-review` | 代码审查,出 REVIEW.md(6 大类 checklist,P0/P1/P2) |
| `vibe-test` | 测试出 TEST.md + BUG.md(按验收标准测) |
| `vibe-handoff` | 主动跨工具交接(生成交接包,粘贴到新工具) |
| `vibe-resume` | 被动中断恢复(额度爆/断网/崩溃,从 docs+git 推断状态) |

### OpenCode 用户

将 `opencode/` 下的文件复制到 `~/.config/opencode/`：

```
opencode/skills/vibe-coding/SKILL.md  →  ~/.config/opencode/skills/vibe-coding/SKILL.md
opencode/commands/vibe-init.md        →  ~/.config/opencode/commands/vibe-init.md
opencode/commands/vibe-retrofit.md    →  ~/.config/opencode/commands/vibe-retrofit.md
opencode/commands/vibe-spec.md        →  ~/.config/opencode/commands/vibe-spec.md
opencode/commands/vibe-clarify.md     →  ~/.config/opencode/commands/vibe-clarify.md
opencode/commands/vibe-tasks.md       →  ~/.config/opencode/commands/vibe-tasks.md
opencode/commands/vibe-execute.md     →  ~/.config/opencode/commands/vibe-execute.md
opencode/commands/vibe-role.md       →  ~/.config/opencode/commands/vibe-role.md
opencode/commands/vibe-design.md      →  ~/.config/opencode/commands/vibe-design.md
opencode/commands/vibe-review.md      →  ~/.config/opencode/commands/vibe-review.md
opencode/commands/vibe-test.md        →  ~/.config/opencode/commands/vibe-test.md
opencode/commands/vibe-handoff.md     →  ~/.config/opencode/commands/vibe-handoff.md
opencode/commands/vibe-resume.md     →  ~/.config/opencode/commands/vibe-resume.md
```

重启 opencode 后:
- 新项目说 `/vibe-init`,旧项目说 `/vibe-retrofit`
- 每个 feature 走 `/vibe-spec` → `/vibe-clarify` → `/vibe-tasks` → `/vibe-execute`
- 多角色协作:`/vibe-role <id>` 切换角色,配合 `/vibe-design` `/vibe-review` `/vibe-test`
- 跨工具切换:`/vibe-handoff`(主动)或 `/vibe-resume`(被动中断)

## 工程化管理体系

```
docs/
├── CURRENT.md                 # 当前任务状态(覆盖式,切换 agent 先读这个)
├── REQ-YYYYMMDD-XX-*.md       # 需求文档(pm 产出,含 Out-of-Scope)
├── DESIGN-YYYYMMDD-XX-*.md    # 设计文档(designer 产出,页面/交互/四态)
├── DEV-YYYYMMDD-XX-*.md       # 技术方案 + task 清单(architect 产出)
├── REVIEW-YYYYMMDD-XX-*.md    # 代码审查报告(reviewer 产出,P0/P1/P2)
├── TEST-YYYYMMDD-XX-*.md      # 测试报告(tester 产出)
├── BUG-YYYYMMDD-XX-*.md       # 缺陷记录(tester 产出)
├── OPS-YYYYMMDD-XX-*.md       # 部署说明(devops 产出)
├── PROG-YYYYMMDD.md            # 进度日志（每日流水账）
└── BIZ-YYYYMMDD-XX-*.md       # 业务决策
```

**角色产物传递链**:
```
pm → REQ → designer → DESIGN → architect → DEV
  → backend/frontend → 代码 → reviewer → REVIEW → tester → TEST/BUG → devops → OPS
```

**关联规则**：PROG 引用 REQ/BUG，BUG 引用来源 REQ，BIZ 引用对应 REQ，CURRENT 引用当前 REQ/DEV/task 文件路径。

**切换 Agent 不丢上下文**：CURRENT.md 是唯一真相源,每次对话开始读、结束更新,跨工具兼容。

**Human Checkpoint**:P0 问题 / 改数据库 / 新依赖 / 上线部署 → 强制暂停等用户拍板。

## 核心原则

1. **规划优先** — 写代码前用最强模型写需求文档和技术方案
2. **先前端再后端** — 原型图先跑起来，不写好 API 契约不动后端
3. **范围冻结** — v1 做什么/不做什么一开始就写死
4. **分阶段推进** — 拆 Phase，每阶段有 DoD，不达标不进下一阶段
5. **文档即上下文外挂** — AI 每次对话前先读相关文档
6. **Feature 级闭环** — 每个 feature 走 spec→clarify→tasks→execute 四步
7. **防发散优先** — 测试绿了就停,YAGNI,新依赖零容忍,超出 task 只记 TODO

## 防返工 / 防发散 / 防断档 三防机制

| 痛点 | 机制 |
|---|---|
| **防返工**(写完发现做错) | `/vibe-spec` 写清需求 + `/vibe-clarify` 动手前列歧义点 |
| **防发散**(AI 顺手做没用的) | spec 的 Out-of-Scope 段 + task 的强字段 + `/vibe-execute` 的 TDD 红绿停 + AGENTS.md 防发散条款 |
| **防断档**(切换 agent 丢上下文) | `docs/CURRENT.md` 任务交接单 + AGENTS.md 交接铁律 |

## 多工具兼容

| 工具 | 配置文件 | 原生支持 AGENTS.md |
|------|---------|-------------------|
| Codex / OpenCode | `AGENTS.md` | 是 |
| Cursor | `AGENTS.md` | 是 |
| GitHub Copilot | `AGENTS.md` | 是 |
| Cline | `AGENTS.md` | 是 |
| Zed AI | `AGENTS.md` | 是 |
| Claude Code | `CLAUDE.md` | 需要 symlink |
| Windsurf | `.windsurfrules` | 需要 symlink |
| Gemini CLI | `GEMINI.md` | 需要 symlink |
| Aider | `conventions.md` | 需要 symlink |
| Kiro | 跟随 IDE | 视具体基于哪个 IDE |

初始化脚本会自动创建这些 symlink/hard link。

## 技术选型

- **模型策略**：最强模型做规划和设计文档，中高模型做编码实现
- **原型图**：Claude Design > GPT Image
- **Agent 工具**：OpenCode/Codex（主力）、Cursor（轻量改动）、Claude Code（复杂任务）

## License

MIT
