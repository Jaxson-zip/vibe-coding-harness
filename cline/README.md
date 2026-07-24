# Vibe Coding Harness — Cline 适配

把 [vibe-coding-harness](https://github.com/Jaxson-zip/vibe-coding-harness) 的 12 个 `/vibe-*` 命令 + 8 个角色定义适配成 **Cline skills**。装一次,所有项目通用。

## 为什么用 Cline 版本

OpenCode 版的 12 个 `/vibe-*` 命令在 Cline 里没有原生对应物。Cline 的 skill 系统**就是 slash command 系统**——每个 skill 自动注册为 `/<skill-name>` 命令。本目录把每个 `/vibe-*` 命令转成独立 Cline skill,用户在 Cline 里直接输入 `/vibe-spec` `/vibe-clarify` 等即可触发。

## 安装

### 方式一:全局安装(推荐,跨项目复用)

把 `cline/skills/` 下的所有子目录复制到 Cline 全局 skills 目录:

**Windows PowerShell:**
```powershell
$src = "G:\vibe-coding\vibe-coding-harness\cline\skills"
$dst = "$env:USERPROFILE\.cline\skills"
if (-not (Test-Path $dst)) { New-Item -ItemType Directory -Path $dst -Force }
Copy-Item -Path "$src\vibe-*" -Destination $dst -Recurse -Force
Write-Output "Installed to $dst"
```

**macOS / Linux:**
```bash
cp -r G:/vibe-coding/vibe-coding-harness/cline/skills/vibe-* ~/.cline/skills/
```

### 方式二:项目级安装(团队共享,提交到 git)

把 `cline/skills/` 复制到项目根目录的 `.cline/skills/`:

```bash
cp -r cline/skills/vibe-* /your/project/.cline/skills/
```

提交到 git,团队成员拉下来即可用。

### 启用

重启 Cline。点击 Cline 面板左下角的秤图标,切到 **Skills** 标签页,应该能看到 13 个 vibe-* skill。默认全部启用。

## 命令清单

### 主入口(1 个)

| 命令 | 作用 |
|---|---|
| `/vibe-coding` | 主调度入口。工作流总览、命令索引、3 防机制说明、从哪开始 |

### 项目级(用 1 次)

| 命令 | 场景 |
|---|---|
| `/vibe-init` | 空目录,从零开始新项目 |
| `/vibe-retrofit` | 已有代码,要理顺、划边界、建立规范 |

### Feature 级(每个 feature 跑一遍)

| 命令 | 场景 |
|---|---|
| `/vibe-spec` | 写单个 feature 需求,带 Out-of-Scope(防发散) |
| `/vibe-clarify` | 动手前列歧义点,逼用户拍板(防返工) |
| `/vibe-tasks` | 拆 task,带 goals/success_criteria/files_touched 强字段 |
| `/vibe-execute` | 按 task 执行,TDD 红绿停,绿了就停 |

### 角色级(一人公司多角色协作)

| 命令 | 场景 |
|---|---|
| `/vibe-role <id>` | 切换角色(pm/designer/architect/backend/frontend/tester/reviewer/devops) |
| `/vibe-design` | 设计师出 DESIGN.md(页面结构、交互流程、四态) |
| `/vibe-test` | 测试出 TEST.md + BUG.md(按验收标准测) |
| `/vibe-review` | 代码审查,出 REVIEW.md(6 大类 checklist,P0/P1/P2 + Human Checkpoint) |
| `/vibe-handoff` | 主动跨工具交接(生成交接包,粘贴到新工具) |
| `/vibe-resume` | 被动中断恢复(额度爆/断网/崩溃,从 docs+git 推断状态) |

## 典型工作流

### 新项目从零开始

```
1. /vibe-init            ← 创建 docs/、AGENTS.md、多工具 symlink
2. /vibe-coding          ← 看工作流总览,选下一步
3. /vibe-spec            ← 写第一个 feature 的需求
4. /vibe-clarify         ← 列歧义点,等用户拍板
5. /vibe-tasks           ← 拆 task 清单
6. /vibe-role backend    ← 切后端角色
7. /vibe-execute         ← TDD 红绿停,逐个 task
8. /vibe-role reviewer   ← 切审查员(建议换 Claude Code 交叉审查)
9. /vibe-review          ← 出 REVIEW.md,有 P0 触发 Human Checkpoint
10. /vibe-role tester     ← 切测试
11. /vibe-test            ← 出 TEST.md + BUG.md
12. /vibe-role devops     ← 切运维
13. (部署前) /vibe-handoff ← 交接给用户授权部署
```

### 中断恢复

额度爆了/浏览器崩了/网络断了 → 重启 Cline,第一句话:
```
/vibe-resume
```
会从 `docs/CURRENT.md` + git diff 推断状态,不依赖任何交接包。

## 三防机制

| 痛点 | 机制 |
|---|---|
| **防返工**(写完发现做错) | `/vibe-spec` 写清需求 + `/vibe-clarify` 动手前列歧义点 |
| **防发散**(AI 顺手做没用的) | spec 的 Out-of-Scope 段 + task 的强字段 + `/vibe-execute` 的 TDD 红绿停 + AGENTS.md 防发散条款 |
| **防断档**(切换 agent 丢上下文) | `docs/CURRENT.md` 任务交接单 + AGENTS.md 交接铁律 + 心跳式更新 |

## 与 OpenCode 版本的关系

| 项 | OpenCode | Cline |
|---|---|---|
| 配置载体 | `~/.config/opencode/commands/*.md` + `~/.config/opencode/skills/vibe-coding/SKILL.md` | `~/.cline/skills/vibe-*/SKILL.md` |
| 触发方式 | `/vibe-*` slash command | `/vibe-*` slash command(同名) |
| 角色定义位置 | `templates/roles/*.md`(项目模板) | `vibe-role/docs/*.md`(skill 内置,按需加载) |
| 主入口 | `vibe-coding` skill | `vibe-coding` skill |
| 项目级行为规范 | `AGENTS.md` + symlink | `AGENTS.md` + `.clinerules` symlink |

两者**完全等价**,可以混用。OpenCode 跑一半切 Cline,只要 `docs/CURRENT.md` 更新过,`/vibe-resume` 即可接上。

## 卸载

```powershell
# Windows
Remove-Item -Recurse -Force "$env:USERPROFILE\.cline\skills\vibe-*"
```

```bash
# macOS / Linux
rm -rf ~/.cline/skills/vibe-*
```

## License

MIT
