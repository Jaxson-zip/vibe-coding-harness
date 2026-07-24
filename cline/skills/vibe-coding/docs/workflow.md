# Vibe Coding 完整工作流

本文件是 vibe-coding 主 skill 的详细参考,按需加载。

## 项目初始化(Phase 0)

新项目用 `/vibe-init`,已有项目用 `/vibe-retrofit`。两者都会创建:

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
├── PROG-YYYYMMDD.md           # 进度日志(每日流水账)
└── BIZ-YYYYMMDD-XX-*.md       # 业务决策
```

## AGENTS.md 两部分

### 第一部分:行为规范
1. 基本行为(中文回复 + 英文代码 + 不顺手重构)
2. **1.1 防发散条款**(强制:自证必要性 + 新依赖零容忍 + 绿了就停 + 单文件原则)
3. 权威文档(冲突优先级)
4. 开始任务前必查
5. Vibe Coding 工作流(最小纵向切片)
6. 安全与权限(允许/批准/禁止三档)
7. 完成标准 DoD(第一条:已更新 PROG)
8. 不确定时(先 clarifying questions)
9. 任务交接(强制读/更新 CURRENT.md)
10. **9.1 心跳式更新**(防被动中断:每完成一个动作立即更新 CURRENT)
11. 角色协作(一人公司多角色模式)

### 第二部分:项目配置
技术栈、开发工具、常用命令、代码风格、目录结构、测试规范、安全要求。

## 写代码的先后顺序

**先写前端,再写后端。**

1. 把完整需求文档发给 AI,沟通需要多少个页面及每个页面的详细功能
2. 出原型图 — 用 Claude Design 或 GPT Image,跑起来看到页面效果
3. 根据数据库表 DDL 在前端模拟数据,验证页面是否全是动态渲染的
4. 确认前端能跑通后,再按 API 契约开发后端

## 分阶段推进模板

| 阶段 | 内容 | DoD |
|---|---|---|
| Phase 0 | 文档体系初始化 | AGENTS.md、README.md、docs/ 结构就绪 |
| Phase 1 | 后端骨架 | 服务可启动、配置可读、数据库可初始化 |
| Phase 2 | 核心链路 1 | 端到端链路跑通 |
| Phase 3 | 核心链路 2 | 同上 |
| Phase 4 | 业务 API | 接口字段对齐、错误响应统一 |
| Phase 5 | 前端工程化 | 拆页拆组件、接入真实 API |
| Phase 6 | 通知与配置 | 链路闭环、热重载 |
| Phase 7 | 打包上线 | Dockerfile、持久化、基础回归 |

## 文档治理关联规则

- **PROG 必须引用相关 REQ/BUG**,保证进度可追溯
- **BUG 必须引用来源 REQ**,知道 bug 从哪个需求引入
- **BIZ 必须引用对应 REQ**,业务决策不能悬空
- **CURRENT 必须引用当前 REQ/DEV/task 文件路径**
- 每天结束时更新 PROG 日志

**切换 Agent 不丢上下文**:`CURRENT.md` 是唯一真相源,每次对话开始读、结束更新,跨工具兼容。

## 上下文管理策略

- 每个对话最多实现 3~4 个需求,防止频繁压缩导致准确度丢失
- 按需加载:只把当前任务相关的文件喂给 AI
- 对历史对话进行摘要压缩,保留关键决策

## 数据库设计原则

- 让 AI 出方案后,**必须 review 表的设计**
- 能用一个表解决的,就不要用多个表
- 考虑后续拓展功能,防止频繁增删字段甚至重构
