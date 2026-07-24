# 多工具同步(一份 AGENTS.md 通吃 10+ AI IDE)

本文件是 vibe-coding 主 skill 的详细参考,按需加载。

## 为什么需要多工具同步

AGENTS.md 是跨工具通用标准,原生支持 Codex、Cursor、Copilot、Cline、Zed、Gemini CLI、Aider。但不同工具读的文件名不同,需要做 soft link 或硬链接让它们都指向同一份文件。

## 各工具对应的文件名

| AI 工具 | 配置文件 | 同步方式 |
|---|---|---|
| **Codex / OpenCode** | `AGENTS.md` | 原生读取,无需额外操作 |
| **Cursor** | `AGENTS.md` 或 `.cursor/rules/*.mdc` | 原生支持 AGENTS.md |
| **GitHub Copilot** | `AGENTS.md` 或 `.github/copilot-instructions.md` | 原生支持 AGENTS.md |
| **Claude Code** | `CLAUDE.md` + `.claude/rules/` | 需要 symlink |
| **Cline** | `AGENTS.md` 或 `.clinerules` | 原生支持 AGENTS.md |
| **Windsurf** | `.windsurfrules` | 需要 symlink |
| **Zed AI** | `.rules` | 原生支持 AGENTS.md |
| **Gemini CLI** | `GEMINI.md` | 需要 symlink |
| **Aider** | `conventions.md` + `.aider.conf.yml` | 需要 symlink |
| **Kiro** | 跟随 IDE(通常 AGENTS.md 或 .cursor/rules/) | 视具体基于哪个 IDE |
| **Continue.dev** | `.continue/rules/*.md` | 需要创建规则文件 |

## 同步方案

初始化或 retrofitting 时,在项目根目录创建以下 symlink(Windows 用 hard link 或 copy):

```bash
# macOS / Linux — symlink 方式
ln -sf AGENTS.md CLAUDE.md
ln -sf AGENTS.md GEMINI.md
ln -sf AGENTS.md .windsurfrules
ln -sf AGENTS.md .clinerules
ln -sf AGENTS.md conventions.md
```

```powershell
# Windows PowerShell — 优先用 New-Item 创建 hard link
New-Item -ItemType HardLink -Path "CLAUDE.md" -Target "AGENTS.md" -Force
New-Item -ItemType HardLink -Path "GEMINI.md" -Target "AGENTS.md" -Force
New-Item -ItemType HardLink -Path ".windsurfrules" -Target "AGENTS.md" -Force
New-Item -ItemType HardLink -Path ".clinerules" -Target "AGENTS.md" -Force
New-Item -ItemType HardLink -Path "conventions.md" -Target "AGENTS.md" -Force
```

如果 hard link 不可用(跨盘符等情况),退而求其次用 copy。

## .gitignore 策略

- `AGENTS.md` — 提交到 git(源文件,你编辑的)
- 所有 symlink 文件(`CLAUDE.md`、`.windsurfrules` 等)— 也提交(链接本身占空间极小,保证团队成员拉下来就能用)
- 或者在 `.gitignore` 中排除并让每个开发者自行执行 sync 脚本

推荐前者(提交 symlink),开箱即用。

## 跨工具交接的命令

- 主动换工具 → `/vibe-handoff` 生成交接包
- 被动中断恢复 → `/vibe-resume` 从 docs + git 推断状态

两个命令都不依赖会话记忆,只依赖 `docs/CURRENT.md` + git。

## 交叉审查推荐映射

reviewer 必须用与实现者**不同的工具**(同模型盲区测不出来):

| 实现工具 | 推荐审查工具 |
|---|---|
| Codex | Claude Code / Cursor |
| Claude Code | Codex / Cursor |
| Cursor | Claude Code / Codex |
| OpenCode | Claude Code / Codex |
| Cline | Claude Code / Codex |
