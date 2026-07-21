# Vibe Coding Harness

一套可跨 AI 工具的工程化管理方案 —— 给 AI 配上项目级"游戏规则"。

**一份 `AGENTS.md`，通吃 10+ 个 AI 编程工具**：Codex、Cursor、Claude Code、Windsurf、Copilot、Cline、Gemini CLI、Zed、Aider、OpenCode。

## 快速开始

### 方式一：运行初始化脚本（推荐）

在项目根目录执行：

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

| 命令 | 场景 |
|------|------|
| `vibe-init` | 空目录，从零开始新项目 |
| `vibe-retrofit` | 已有代码，要理顺、划边界、建立规范 |

### OpenCode 用户

将 `opencode/` 下的文件复制到 `~/.config/opencode/`：

```
opencode/skills/vibe-coding/SKILL.md  →  ~/.config/opencode/skills/vibe-coding/SKILL.md
opencode/commands/vibe-init.md        →  ~/.config/opencode/commands/vibe-init.md
opencode/commands/vibe-retrofit.md    →  ~/.config/opencode/commands/vibe-retrofit.md
```

重启 opencode 后，在新项目里说 `/vibe-init`，在旧项目里说 `/vibe-retrofit`。

## 工程化管理体系

```
docs/
├── REQ-YYYYMMDD-XX-*.md   # 需求文档
├── DEV-YYYYMMDD-XX-*.md   # 技术方案
├── PROG-YYYYMMDD.md        # 进度日志（每日）
├── BUG-YYYYMMDD-XX-*.md   # 缺陷记录
└── BIZ-YYYYMMDD-XX-*.md   # 业务决策
```

**关联规则**：PROG 引用 REQ/BUG，BUG 引用来源 REQ，BIZ 引用对应 REQ。

## 核心原则

1. **规划优先** — 写代码前用最强模型写需求文档和技术方案
2. **先前端再后端** — 原型图先跑起来，不写好 API 契约不动后端
3. **范围冻结** — v1 做什么/不做什么一开始就写死
4. **分阶段推进** — 拆 Phase，每阶段有 DoD，不达标不进下一阶段
5. **文档即上下文外挂** — AI 每次对话前先读相关文档

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
