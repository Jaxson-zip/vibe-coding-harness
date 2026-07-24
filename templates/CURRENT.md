# 当前任务状态（交接单）

> 切换 Agent / 切换角色时,先读这个文件。这是唯一的"现在在哪"真相源。
> 覆盖式更新,只存当前状态,不存历史(历史走 PROG)。

---

## 当前 Feature
- Feature 名称: <feature 名,如"用户登录">
- REQ 文档: docs/REQ-YYYYMMDD-XX-xxx.md
- DEV 文档: docs/DEV-YYYYMMDD-XX-xxx.md
- 所在 Phase: Phase X

## 当前角色
- 角色标识: <frontend | backend | pm | designer | tester | devops>
- 切换前角色: <上一个角色,如 backend>
- 切换原因: <如"前端 UI 写完,切后端写 API">

## 当前 Task
- Task ID: task-XXX
- 标题: <task 标题>
- 状态: todo | in-progress | blocked | done
- 已完成: <具体做了什么,写到能直接接的程度>
- 卡点: <无 / 具体卡在哪,缺什么信息或依赖>
- 下一步: <下一步具体做什么,精确到文件和函数,如"在 src/auth/lock.ts 写 lockUser() 函数,实现 15 分钟锁定">

## 待办 Task 清单
- [x] task-001 <标题>
- [x] task-002 <标题>
- [ ] task-003 <标题> ← 当前
- [ ] task-004 <标题>

## 相关文件(打开这些就能接上)
- <文件路径> — <作用,如"主逻辑文件">
- <文件路径> — <作用>
- <文件路径> — <作用>

## 相关验收标准(从 spec 摘出当前 task 对应的)
- <可测试语句 1,如"输错密码 5 次 → 锁定 15 分钟">
- <可测试语句 2>

## 最后更新
- 时间: YYYY-MM-DD HH:MM
- Agent / 角色: <如 Claude Code / backend>
- 一句话总结: <本次做了什么,下次接什么>
