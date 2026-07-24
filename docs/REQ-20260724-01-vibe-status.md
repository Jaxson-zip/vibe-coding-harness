# Feature: vibe-status 命令

## 做什么
新增一个只读命令 `/vibe-status`,快速查看当前项目的 vibe-coding 状态(当前 feature / 角色 / task / 卡点 / 下一步 / 最近 PROG 摘要),一眼看完"现在在哪",不用手动翻 `docs/CURRENT.md`。同时产出 opencode 和 cline 两个版本。

## 为什么
每次开新对话或切角色时,用户/agent 第一件事是读 CURRENT.md 想知道"现在在哪"。但 CURRENT.md 是结构化模板,信息分散在多个段落,手动翻找慢。一个专门的只读 status 命令,把关键字段摘出来格式化输出,降低上下文重建成本,也作为 `/vibe-resume`(被动中断恢复)的轻量替代——没断档只是想看下状态时,不用跑重量级的 resume。

## 验收标准(必须可测试)
- 当 `docs/CURRENT.md` 存在且有效时,应输出当前 feature 名 / 角色 / 当前 task(含状态)/ 卡点 / 下一步,且不修改任何文件
- 当 `docs/CURRENT.md` 不存在时,应提示"项目未初始化,请先跑 `/vibe-init` 或 `/vibe-retrofit`",且不报错崩溃
- 当 `docs/PROG-{today}.md` 存在时,应附带显示最近一条进度摘要(最后一节的"下一步")
- 当在 opencode 环境时,应作为 slash command `/vibe-status` 触发(命令文件放 `opencode/commands/vibe-status.md`)
- 当在 cline 环境时,应作为 skill `/vibe-status` 触发(SKILL.md 放 `cline/skills/vibe-status/`,name 字段与目录一致,description <1024 字符,SKILL.md body <5k tokens)
- 当输出状态时,应明确标注"只读视图,未修改任何文件",区别于 /vibe-resume(会推断+问用户+检查 git)

## Out-of-Scope(本 feature 不做,关键防发散)
- 不修改任何文件(纯只读) — 原因:status 的职责是看不是改;改是 CURRENT/PROG 的事,改了就破坏"只读"承诺
- 不做 git 状态分析(git status / git diff / git log) — 原因:那是 `/vibe-resume` 的职责,resume 才需要检查未提交改动推断中断点;status 只看 docs 现状
- 不生成交接包 — 原因:那是 `/vibe-handoff` 的职责,status 不涉及跨工具
- 不做交互式问答或确认 — 原因:status 是一眼看完,不需要用户交互;`/vibe-clarify` 才问问题
- 不显示完整 CURRENT.md 原文 — 原因:太长,只摘关键段(feature/角色/task/卡点/下一步),原文让用户自己 cat
- 不做 task 状态修改或推进 — 原因:那是 `/vibe-execute` 的职责,status 只读不写
- 不显示角色定义内容 — 原因:那是 `/vibe-role` 的职责,status 只报当前角色标识,不加载角色定义

## 相关文件(预估,写代码前参考)
- `opencode/commands/vibe-status.md` — 新建,opencode 版命令
- `cline/skills/vibe-status/SKILL.md` — 新建,cline 版 skill
- `README.md` — 更新命令清单(项目级/feature 级/角色级表格各加一行)
- `opencode/skills/vibe-coding/SKILL.md` — 更新命令索引(12→13 个子命令)
- `cline/skills/vibe-coding/SKILL.md` — 更新命令索引(12→13 个子命令)
- `docs/CURRENT.md` — 参考(读取目标,不修改)

## 依赖
- 无前置 feature
- 运行时需要项目已初始化(`docs/CURRENT.md` 存在),否则提示用户初始化
- 参考 `/vibe-resume` 的输出格式(恢复报告),但精简且只读
