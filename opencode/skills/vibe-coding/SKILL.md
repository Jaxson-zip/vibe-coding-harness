---
name: vibe-coding
description: Use for starting new projects, retrofitting existing projects with engineering harness, project refactoring, defining code boundaries, Vibe Coding workflows, project initialization, long-term project maintenance, engineering management, setting up AGENTS.md, creating document governance (PRD/REQ/PROG/BUG/BIZ/DEV), scope freezing, and phase-based development. Use ONLY when the user talks about creating a new project from scratch, retrofitting an existing project, setting up engineering practices, or wants to Vibe Code with proper harness/management.
---

# Vibe Coding 工程化工作流

当用户要开始一个新项目或对现有项目建立工程化规范时，按以下流程执行。

## 核心原则

1. **规划永远比写代码重要** — 在写一行代码之前，先用最强模型把需求文档和技术方案写清楚。
2. **先写前端，再写后端** — 让用户最短时间内看到产品长什么样，获取即时成就感。
3. **范围冻结** — v1 要做什么/不做什么，一开始就写死，防止 AI 顺手加功能。
4. **分阶段推进** — 大项目拆成 Phase 0~N，每阶段有明确 DoD，不达标不进下一阶段。
5. **文档即上下文外挂** — AI 每次对话前先读相关文档，不会丢失上下文。

## 项目初始化流程 (Phase 0)

当用户要开始一个新项目时，按顺序执行：

### 第一步：创建文档目录结构

```
docs/
├── REQ-YYYYMMDD-XX-<简短描述>.md   # 需求文档
├── DEV-YYYYMMDD-XX-<简短描述>.md   # 技术方案
├── PROG-YYYYMMDD.md                # 进度日志（每日）
├── BUG-YYYYMMDD-XX-<简短描述>.md   # 缺陷记录
└── BIZ-YYYYMMDD-XX-<简短描述>.md   # 业务决策
```

### 第二步：编写 AGENTS.md

在项目根目录创建 `AGENTS.md`，内容包含两大块：**行为规范**（告诉 AI 怎么做事）和 **项目配置**（告诉 AI 项目是什么）。根据项目实际情况替换 `<...>` 占位符。

```markdown
# AGENTS.md — <项目名称>

本文件规定 AI 编码 Agent 在此项目中的行为规范和项目配置。产品需求、技术方案和实施细节由 `docs/` 中的项目文档维护，本文件不重复抄写。

---

# 第一部分：行为规范

## 1. 基本行为
- 始终使用中文回复；代码、标识符、API、数据库字段和提交信息使用英文。
- 先查项目文档、现有代码和测试，再决定如何实现。文档已有答案时，不重复询问用户。
- 只修改当前任务涉及的内容，不顺手做无关重构，不为尚未发生的需求提前建设复杂抽象。
- 不能在当前任务中完成的部分要明确说明，不承诺后台交付。

## 2. 权威文档
- 优先读取 `docs/` 中的 Markdown 版本：PRD（做什么）、技术设计文档（怎么设计）、实施文档（怎么推进）、进度文档（现在做到哪里）。
- 冲突优先级：AGENTS.md → 用户本次明确要求 → PRD → 技术设计 → 实施文档 → 进度文档 → 现有代码。
- 发现代码与文档不一致时，不得静默猜测，按高优先级文档确认目标，说明差异并同步修正。

## 3. 开始任务前必须自主查询
- 查看进度文档，确认当前阶段、下一任务、前置依赖和阻塞。
- 在 PRD 中搜索相关页面、功能名和验收标准。
- 在技术设计中搜索相关模块、表、API、外部依赖和约束。
- 检查受影响代码、迁移和测试，沿用仓库已有模式。

## 4. Vibe Coding 工作流
- 每个任务按最小纵向切片完成：文档定位 → 数据模型/迁移 → 后端服务 → API → UI → 测试 → 文档与进度。
- 数据库变化先写迁移和约束，再改 ORM、服务和 API。
- 需要改变产品范围、架构、表结构或实施顺序时，先更新对应文档，再编码。
- 一次优先交付一个可验证闭环，不并行铺开大量半成品。

## 5. 安全与权限
- **允许无需确认的操作**：读文件、搜索代码、查看文档、单文件类型检查/格式化/测试、创建分支和提交
- **需要明确批准的操作**：安装新依赖、修改配置文件、全量构建/测试、git push、删除文件/目录、修改数据库结构、修改环境变量
- **禁止操作**：提交 .env* 及密钥、强制推送、未经授权推送 release

## 6. 完成标准
- 相关测试通过；数据库迁移可从空库执行也能从上一版本升级。
- 外部 Provider 的失败、超时、空数据和过期状态已处理。
- 完成后必须更新进度文档的状态、证据、遗留问题和下一任务。
- "代码能运行"不等于完成；测试、文档和进度没有同步时，任务仍未完成。

## 7. Git 规范
- 未经用户明确授权，不推送远程、不发布版本。
- 提交只包含当前任务相关修改，不混入无关格式化或重构。
- Commit 格式: `type(scope): description`，类型: feat/fix/docs/style/refactor/test/chore。
- 分支命名: `feature/<描述>` / `fix/<描述>` / `hotfix/<描述>`。
- AGENTS.md 只维护 Agent 行为和代码边界，不复制项目文档的细节。

## 8. 遇到不确定时
- 先提 clarifying questions，不要猜测用户意图
- 复杂改动先出方案再写代码
- 参考项目现有模式保持一致性
- 先从最小可行方案开始，再迭代
- 修 bug 或加功能时先写测试

---

# 第二部分：项目配置

## 项目概览
- **架构**: <单体/微服务/前后端分离>
- **领域**: <电商/金融/工具/SaaS/其他>
- **规模**: <MVP/小规模/正式生产>

## 技术栈
- **语言**: <TypeScript / Python / Go / ...>
- **前端框架**: <React / Vue / Next.js / ...>
- **后端框架**: <FastAPI / Express / Spring Boot / ...>
- **数据库**: <PostgreSQL / MySQL / MongoDB / ...>
- **缓存**: <Redis / 无>
- **包管理器**: <pnpm / npm / pip / poetry / ...>
- **ORM**: <Prisma / SQLAlchemy / GORM / ...>

## 开发工具
- **Linter**: <ESLint / Ruff / ...>
- **Formatter**: <Prettier / Black / ...>
- **类型检查**: <TypeScript / mypy / ...>
- **测试框架**: <Vitest / pytest / JUnit / ...>

## 常用命令

```bash
# 安装依赖
<install command>

# 配置环境
cp .env.example .env
# 编辑 .env 填入必需值

# 数据库迁移
<migration commands>

# 启动开发服务器
<dev command>
```

### 文件级命令（优先使用，快速）
```bash
# 单文件类型检查
<command> <file>

# 单文件格式化
<command> <file>

# 单文件 Lint
<command> <file>

# 单文件测试
<command> <file>
```

### 项目级命令（仅在明确要求或最终提交前使用）
```bash
# 全量类型检查
<command>

# 全量测试
<command>

# 全量构建
<command>
```

## 代码风格

### 命名规范
- **文件**: <小写短横线 / PascalCase / camelCase>
- **变量**: <camelCase / snake_case>
- **函数**: <camelCase / snake_case，动词开头>
- **类/组件**: <PascalCase>
- **常量**: <UPPER_SNAKE_CASE>

### 格式
- **缩进**: <2空格 / 4空格 / Tab>
- **引号**: <单引号 / 双引号>
- **分号**: <必须 / 禁止>

### 推荐做法
- <项目特有的最佳实践1>
- <项目特有的最佳实践2>

### 应避免的做法
- <项目特有的反模式1>
- <项目特有的反模式2>

## 项目目录结构

```
/
├── src/              # 源代码
│   ├── components/   # UI 组件
│   ├── pages/        # 页面/路由
│   ├── services/     # 业务逻辑 / API 调用
│   ├── hooks/        # 自定义 hooks
│   ├── utils/        # 工具函数
│   └── types/        # 类型定义
├── docs/             # 项目文档（PRD、DEV、PROG、BUG、BIZ）
├── tests/            # 测试文件
└── .env.example      # 环境变量模板
```

## 测试规范
- **单元测试**: `<位置>`，使用 `<框架>`
- **集成测试**: `<位置>`，使用 `<框架>`
- **覆盖率目标**: `<80% / 85% / 90%>`
- **测试文件命名**: `<*.test.ts / *.spec.ts / test_*.py>`
- 测试文件放在源文件旁边或统一 `tests/` 目录
- 外部 API 和数据库一律 mock

## 安全要求
- 所有用户输入在客户端和服务端均需校验
- 数据库查询必须使用参数化，禁止拼接 SQL
- 密码使用 bcrypt 哈希
- 生产环境强制 HTTPS
- CORS 正确配置
- PII 数据加密存储
- **绝不提交** .env、密钥、API key、证书到版本控制
```

### 第三步：编写需求文档 (PRD)

用最强模型（如 Claude Opus 或 GPT 5.6）撰写，明确：
- 项目愿景与目标用户
- **v1 范围**：要做什么
- **明确不进 v1 的**：不做什么（范围冻结）
- 核心功能清单与验收标准
- 页面/路由结构
- 技术选型

### 第四步：创建进度日志

创建 `docs/PROG-YYYYMMDD.md`，记录：
- 当前所在 Phase
- 进度摘要
- 遗留问题
- 下一任务

## 写代码的先后顺序

**先写前端，再写后端。** 具体做法：

1. 把完整需求文档发给 AI，沟通需要多少个页面及每个页面的详细功能
2. 出原型图 — 用 Claude Design 或 GPT Image，跑起来看到页面效果
3. 根据数据库表 DDL 在前端模拟数据，验证页面是否全是动态渲染的
4. 确认前端能跑通后，再按 API 契约开发后端

## 分阶段推进模板

| 阶段 | 内容 | DoD |
|------|------|-----|
| Phase 0 | 文档体系初始化 | AGENTS.md、README.md、docs/ 结构就绪 |
| Phase 1 | 后端骨架 | 服务可启动、配置可读、数据库可初始化 |
| Phase 2 | 核心链路 1 | 端到端链路跑通 |
| Phase 3 | 核心链路 2 | 同上 |
| Phase 4 | 业务 API | 接口字段对齐、错误响应统一 |
| Phase 5 | 前端工程化 | 拆页拆组件、接入真实 API |
| Phase 6 | 通知与配置 | 链路闭环、热重载 |
| Phase 7 | 打包上线 | Dockerfile、持久化、基础回归 |

## 文档治理关联规则

- **PROG 必须引用相关 REQ/BUG**，保证进度可追溯
- **BUG 必须引用来源 REQ**，知道 bug 从哪个需求引入
- **BIZ 必须引用对应 REQ**，业务决策不能悬空
- 每天结束时更新 PROG 日志

## 已有项目规范化（Retrofit）

当用户要对一个**已有项目**建立工程化规范、重构、或者划清边界时，按以下流程执行。

### 核心区别

| | 新项目 (vibe-init) | 已有项目 (vibe-retrofit) |
|---|---|---|
| 起点 | 零代码 | 已有代码和架构 |
| 文档 | 从零撰写 | 从代码反推 + 补全 |
| 范围 | v1 冻结 | 理清当前范围 + 锁定边界 |
| 阶段 | 从 Phase 0 开始 | 从当前实际状态开始 |
| 代码 | 先设计再编码 | 先分析已有代码再规范 |

### 第一步：代码库扫描

先用工具扫描项目，摸清现有情况：

1. **识别技术栈**：读取 `package.json`、`requirements.txt`、`Cargo.toml`、`go.mod` 等，列出所有依赖和版本。
2. **分析目录结构**：列出所有顶层目录和关键子目录，理解分层。
3. **查找现有配置**：检查是否已有 `.cursor/rules/`、`CLAUDE.md`、`.windsurfrules`、`AGENTS.md` 等，有则合并而非覆盖。
4. **检查命令**：读取 `package.json` 的 scripts、Makefile、`docker-compose.yml` 等，提取常用命令。
5. **梳理测试情况**：找到测试文件位置、测试框架和覆盖率情况。
6. **检查代码风格**：读取 `.eslintrc`、`.prettierrc`、`pyproject.toml` 等配置文件。

### 第二步：诊断问题点

在生成文档之前，先帮用户诊断：

- 哪些目录结构不合理？（层级过深、命名混乱、无分层）
- 有没有重复代码或死代码？（同名函数出现在多处）
- 依赖是否过期或有安全隐患？
- 有没有 `.env` 文件被提交到 git 的历史？
- 接口/组件之间耦合是否过度？（改一处需要改五处）

把诊断结果写进 `docs/BIZ-{today}-01-现有问题诊断.md`，别直接改了——先列出来让用户确认。

### 第三步：反推生成文档

基于扫描结果，生成/补全以下文件：

**1. AGENTS.md**：填入自动检测到的内容
- 第二部分"项目配置"直接填入扫描结果（技术栈、目录结构、命令、工具链）
- 第一部分"行为规范"使用标准模板，但根据项目已有风格调整（比如项目习惯 4 空格缩进就别写成 2 空格）
- 如果有旧版 `.cursorrules` 等，把其中仍有价值的内容合并进去

**2. docs/ 目录**（如果不存在）：
- `docs/PROG-{today}.md`：记录当前实际状态（已完成了哪些功能、当前有哪些问题）
- `docs/DEV-{today}-01-现有架构分析.md`：记录当前架构、表结构、API 列表

**3. 反向 PRD**：从现有代码反推功能清单（已有功能 → 写成需求文档格式），然后请用户确认：
- 哪些是 v1 已有功能
- 哪些其实是半成品/废弃功能
- 后续版本想做什么

### 第四步：划定边界

这是最关键的一步——让用户知道什么东西能改、什么东西不能动：

- **不动的部分**：已稳定运行的核心模块、被多处引用的公共组件、已有测试覆盖的代码
- **需要重构的部分**：耦合严重、重复代码、命名混乱但逻辑正确的模块。每个重构目标写一个 `DEV-{date}-XX-{模块}重构方案.md`
- **可以删除的部分**：死代码、废弃路由、无引用的组件/函数
- **外部依赖边界**：明确哪些是第三方服务（支付、短信、OSS），AI 不能随意改动对接方式

在 AGENTS.md 里加一个"重构边界"章节：

```markdown
## 9. 重构边界（本项目的雷区地图）

### 不可修改的核心模块
- <模块路径> — 原因：<为什么不能动>
- <模块路径> — 原因：<为什么不能动>

### 允许重构但需谨慎的区域
- <模块路径> — 重构目标：<要达成什么>
- <模块路径> — 重构目标：<要达成什么>

### 外部依赖（不可随意改动对接方式）
- <支付服务> — 配置文件：<路径>
- <第三方 API> — 调用入口：<路径>
```

### 第五步：锁定范围，冻结后续需求

跟新项目一样，也要有一个"从现在开始 v1 做什么、不做什么"的清单：

- **当前版本 (v1.x)**：修 bug + 划定边界内的重构
- **下个版本 (v2.0)**：新功能、大重构，开新 REQ 文档

每次 AI 想"顺手"改边界外的东西时，直接说："不在当前版本范围，先记 REQ。"

---

## 上下文管理策略

- 每个对话最多实现 3~4 个需求，防止频繁压缩导致准确度丢失
- 按需加载：只把当前任务相关的文件喂给 AI
- 对历史对话进行摘要压缩，保留关键决策

## 工具与模型建议

- **Agent 工具**：Codex/OpenCode（主力，自动注入 AGENTS.md）、Cursor（轻量改动）、Claude Code（复杂任务）
- **模型策略**：最强模型做规划和设计文档，中高模型做编码实现
- **原型图**：Claude Design > GPT Image

## 多工具同步（一份 AGENTS.md 通吃所有 AI IDE）

AGENTS.md 是跨工具通用标准，原生支持 Codex、Cursor、Copilot、Cline、Zed、Gemini CLI、Aider。但不同工具读的文件名不同，需要做 soft link 或硬链接让它们都指向同一份文件。

### 各工具对应的文件名

| AI 工具 | 配置文件 | 同步方式 |
|---------|----------|----------|
| **Codex / OpenCode** | `AGENTS.md` | 原生读取，无需额外操作 |
| **Cursor** | `AGENTS.md` 或 `.cursor/rules/*.mdc` | 原生支持 AGENTS.md |
| **GitHub Copilot** | `AGENTS.md` 或 `.github/copilot-instructions.md` | 原生支持 AGENTS.md |
| **Claude Code** | `CLAUDE.md` + `.claude/rules/` | 需要 symlink |
| **Cline** | `AGENTS.md` 或 `.clinerules` | 原生支持 AGENTS.md |
| **Windsurf** | `.windsurfrules` | 需要 symlink |
| **Zed AI** | `.rules` | 原生支持 AGENTS.md |
| **Gemini CLI** | `GEMINI.md` | 需要 symlink |
| **Aider** | `conventions.md` + `.aider.conf.yml` | 需要 symlink |
| **Kiro** | 跟随 IDE（通常 AGENTS.md 或 .cursor/rules/） | 视具体基于哪个 IDE |
| **Continue.dev** | `.continue/rules/*.md` | 需要创建规则文件 |

### 同步方案

初始化或 retrofitting 时，在项目根目录创建以下 symlink（Windows 用 hard link 或 copy）：

```bash
# macOS / Linux — symlink 方式
ln -sf AGENTS.md CLAUDE.md
ln -sf AGENTS.md GEMINI.md
ln -sf AGENTS.md .windsurfrules
ln -sf AGENTS.md .clinerules
ln -sf AGENTS.md conventions.md

# Windows PowerShell — 优先用 New-Item 创建 hard link
New-Item -ItemType HardLink -Path "CLAUDE.md" -Target "AGENTS.md" -Force
New-Item -ItemType HardLink -Path "GEMINI.md" -Target "AGENTS.md" -Force
New-Item -ItemType HardLink -Path ".windsurfrules" -Target "AGENTS.md" -Force
New-Item -ItemType HardLink -Path ".clinerules" -Target "AGENTS.md" -Force
New-Item -ItemType HardLink -Path "conventions.md" -Target "AGENTS.md" -Force
```

如果 hard link 不可用（跨盘符等情况），退而求其次用 copy。

### .gitignore 策略

- `AGENTS.md` — 提交到 git（源文件，你编辑的）
- 所有 symlink 文件（`CLAUDE.md`、`.windsurfrules` 等）— 也提交（链接本身占空间极小，保证团队成员拉下来就能用）
- 或者在 `.gitignore` 中排除并让每个开发者自行执行 sync 脚本

推荐前者（提交 symlink），开箱即用。

## 数据库设计原则

- 让 AI 出方案后，**必须 review 表的设计**
- 能用一个表解决的，就不要用多个表
- 考虑后续拓展功能，防止频繁增删字段甚至重构
