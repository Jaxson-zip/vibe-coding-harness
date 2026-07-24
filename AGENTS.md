# AGENTS.md — vibe-coding-harness

本文件规定 AI 编码 Agent 在此项目中的行为规范和项目配置。产品需求、技术方案和实施细节由 `docs/` 中的项目文档维护,本文件不重复抄写。

---

# 第一部分:行为规范

## 1. 基本行为
- 始终使用中文回复;代码、标识符、API、数据库字段和提交信息使用英文。
- 先查项目文档、现有代码和测试,再决定如何实现。文档已有答案时,不重复询问用户。
- 只修改当前任务涉及的内容,不顺手做无关重构,不为尚未发生的需求提前建设复杂抽象。
- 不能在当前任务中完成的部分要明确说明,不承诺后台交付。
- **【强制】每次完成一个任务(改文档、修 bug、加功能),必须在对话结束前更新 `docs/PROG-{today}.md`。记录:本次做了什么、遇到了什么问题、遗留了什么、下一步是什么。写完 PROG 才算完成任务。**

### 1.1 防发散条款(强制)
- **每次改动前必须自证必要性**:先回答"这次改动对应 task-XXX 的哪条验收标准?不对应就不做。"
- **禁止引入新依赖**:除非当前 task 显式声明,否则一律不装新包、不加新框架,记到 TODO 询问。
- **测试绿了就停**:测试红→写最小实现→绿→立即停,不允许"顺手优化""顺手重构""顺手抽组件"。YAGNI。
- **超出 task 范围的只能记 TODO**:发现顺手可优化/可重构的地方,写进 `docs/PROG-{today}.md` 的"遗留项",不在当前 task 里做。
- **单文件原则**:一个 task 只动当前 task 必需的文件,配置/无关文件不动,跨文件改动需在 plan 里声明。

## 2. 权威文档
- 优先读取 `docs/` 中的 Markdown 版本:REQ(做什么)、DEV(怎么设计)、PROG(现在做到哪里)、CURRENT(当前状态)。
- 冲突优先级:AGENTS.md → 用户本次明确要求 → REQ → DEV → PROG → 现有代码。
- 发现代码与文档不一致时,不得静默猜测,按高优先级文档确认目标,说明差异并同步修正。

## 3. 开始任务前必须自主查询
- 查看 `docs/CURRENT.md`,确认当前 feature / 角色 / task / 卡点 / 下一步。
- 在 REQ 中搜索相关功能名和验收标准。
- 在 DEV 中搜索相关模块和约束。
- 检查受影响文件,沿用仓库已有模式(opencode/ vs cline/ 的格式差异)。

## 4. Vibe Coding 工作流
- 每个任务按最小纵向切片完成:文档定位 → 实现 → 验证格式 → 更新 CURRENT/PROG。
- 需要改变产品范围或实施顺序时,先更新对应文档,再编码。
- 一次优先交付一个可验证闭环,不并行铺开大量半成品。

## 5. 安全与权限
- **允许无需确认的操作**:读文件、搜索代码、查看文档、创建分支和提交
- **需要明确批准的操作**:git push、删除文件/目录、修改 GitHub 仓库设置
- **禁止操作**:提交 .env* 及密钥、强制推送、未经授权推送 release

## 6. 完成标准(DoD — Definition of Done)
- **第一条:已更新 `docs/PROG-{today}.md`。** 没写进度日志 = 任务没完成。
- 相关文件格式验证通过(Cline skill 的 name 一致、description <1024、SKILL.md <5k tokens)。
- "文档能写出来"不等于完成;格式验证和进度没有同步时,任务仍未完成。

## 7. Git 规范
- 未经用户明确授权,不推送远程、不发布版本。
- 提交只包含当前任务相关修改,不混入无关格式化或重构。
- Commit 格式: `type(scope): description`,类型: feat/fix/docs/style/refactor/test/chore。
- 分支命名: `feature/<描述>` / `fix/<描述>` / `hotfix/<描述>`。

## 8. 遇到不确定时
- 先提 clarifying questions,不要猜测用户意图
- 复杂改动先出方案再写代码
- 参考项目现有模式保持一致性(opencode/ 和 cline/ 的命名/格式差异)
- 先从最小可行方案开始,再迭代

## 9. 任务交接(防切换 Agent / 角色丢上下文)
- **【强制】每次开始新对话,第一步必须读 `docs/CURRENT.md`**,确认当前 feature / 角色 / task / 卡点 / 下一步,再开始干活。
- **【强制】每次暂停或结束对话前,必须更新 `docs/CURRENT.md`**:改了什么、卡在哪、下一步具体做什么(写到能直接执行的程度)、相关文件路径、当前角色。没更新 CURRENT 就算任务没交接。
- CURRENT.md 是**覆盖式更新,只存"当前状态"**,不存历史。历史走 PROG。
- 角色切换时,CURRENT.md 里明确记录"切换前角色"和"切换原因",保证接得上。

### 9.1 心跳式更新(防被动中断)
- **【强制】每完成一个文件改动(写完一个文件 / 跑完一次验证 / 改完一个段落),立即更新 `docs/CURRENT.md` 的"已完成"段和"下一步"段**,即使任务还没结束。
- 更新粒度:写到"下一个动作能直接执行"的程度。
- **被动中断后恢复**:新工具第一句话跑 `/vibe-resume`,从 docs/ + git diff 推断状态,不依赖任何交接包。

## 10. 角色协作(一人公司多角色模式)
- 每个角色有明确职责边界,不在角色间互相越界。
- 角色间产物通过文件契约传递:PM 产出 REQ → Architect 产出 DEV+tasks → Developer 产代码/文档 → (本仓库无 reviewer/tester/devops,由用户人工验收)。
- 角色切换时,新角色必须先读 CURRENT.md + 上一个角色的产物文件,再开工。

---

# 第二部分:项目配置

## 项目概览
- **架构**: 单仓库,多工具适配(opencode/ + cline/ + templates/)
- **领域**: AI 编程工程化工具
- **规模**: 工具仓库(Markdown 文档 + 脚本,非应用)

## 技术栈
- **语言**: Markdown(文档)+ PowerShell/Bash(脚本)
- **框架**: 无
- **数据库**: 无
- **包管理器**: 无
- **ORM**: 无

## 开发工具
- **Linter**: 无(文档项目)
- **Formatter**: 无
- **类型检查**: 无
- **测试框架**: 手动验证(Cline skill 格式:name 一致、description<1024、SKILL.md<5k tokens)

## 常用命令

```bash
# 克隆仓库
git clone https://github.com/Jaxson-zip/vibe-coding-harness.git

# 验证 Cline skill 格式(手动,见 cline/README.md)
# 验证项:每个 skill 目录有 SKILL.md、name 与目录一致、description<1024 字符、SKILL.md<5k tokens

# 无构建/测试命令(纯文档项目)
```

## 代码风格

### 命名规范
- **文件**: 小写短横线(vibe-spec.md、vibe-status.md)
- **目录**: kebab-case(vibe-spec/、vibe-coding/)
- **skill name 字段**: 与目录名完全一致

### 格式
- **缩进**: 2 空格(Markdown 代码块内)
- **引号**: 双引号
- **中英文混排**: 中文用中文,代码/标识符用英文,中间加空格

### 推荐做法
- opencode/ 和 cline/ 两版本保持内容等价,格式适配各自工具
- 新增命令时同步更新两版本 + README 命令清单 + vibe-coding 主 skill 索引

### 应避免的做法
- 不要让 opencode/ 和 cline/ 内容漂移(改一处忘改另一处)
- 不要在 SKILL.md 里塞超过 5k tokens(拆到 docs/)

## 项目目录结构

```
/
├── AGENTS.md            # 本文件(项目行为规范)
├── README.md            # 仓库总览
├── docs/                # 项目文档(CURRENT/REQ/DEV/PROG)
├── opencode/            # OpenCode 版适配
│   ├── commands/        # 12 个 /vibe-* 命令
│   └── skills/vibe-coding/SKILL.md
├── cline/               # Cline 版适配
│   ├── README.md
│   └── skills/          # 13 个 vibe-* skill(含 docs/)
├── templates/           # 通用模板
│   ├── AGENTS.md        # AGENTS.md 模板
│   ├── CURRENT.md       # CURRENT.md 模板
│   └── roles/           # 8 个角色定义模板
└── scripts/             # 初始化脚本
    ├── init.cmd / init.ps1 / init.sh
```

## 测试规范
- **单元测试**: 无(文档项目)
- **集成测试**: 无
- **手动验证**: 新增/修改 skill 后,检查格式(name 一致、description<1024、SKILL.md<5k tokens)

## 安全要求
- 不提交 .env、密钥、API key
- 不在文档里硬编码任何凭证
