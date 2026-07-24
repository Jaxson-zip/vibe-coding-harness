---
name: vibe-clarify
description: List ambiguities and open questions before writing any code. Must run AFTER /vibe-spec to prevent rework — surfaces 3+ decision points with 2+ candidates each, forces user to pick. Triggers on: "clarify", "ambiguities", "open questions", "歧义点", "拍板", "/vibe-clarify".
---

在写代码前,主动列出当前 feature spec 里的歧义点和技术决策点,逼用户拍板。把"返工"从"写完才发现"提前到"写之前 5 分钟"。

## 执行步骤

### Step 1: 读 spec
读当前 feature 的 `docs/REQ-{today}-{NN}-*.md`(从 `docs/CURRENT.md` 里查文件名)。

### Step 2: 主动列歧义点(强制,至少 3 条)
扫一遍 spec,找出所有"可以这么理解,也可以那么理解"的点。覆盖这些维度:

- **技术选型**:用什么库/算法/数据结构?有没有两个候选需要用户选?
- **边界情况**:spec 没写清楚的极端输入(空值、超长、并发)怎么处理?
- **数据模型**:某个字段类型?某个表关系?索引建不建?
- **交互细节**:错误提示文案?跳转路径?UI 状态?
- **性能/安全**:需要限流吗?需要加密吗?缓存策略?

### Step 3: 输出格式
在对话里这样输出,等用户回答:

```
## 在动手前,我列了 N 个需要你拍板的点:

1. [技术选型] 密码加密用什么?
   - 候选 A: bcrypt(简单)
   - 候选 B: argon2(更安全,但要装新依赖)
   - 我的建议: A,因为 <理由>

2. [边界情况] 登录失败 5 次后,锁定是按用户还是按 IP?
   - 候选 A: 按用户
   - 候选 B: 按 IP
   - 我的建议: A,因为 <理由>

3. [数据模型] users 表要不要单独加一个 login_attempts 表?
   ...
```

每条必须:
- 给出 2 个以上候选
- 给出 AI 自己的建议(附理由)
- 不要只问不给方案

### Step 4: 把答案回写 spec
用户回答后,把决策追加到 spec 文件的"验收标准"或新增"决策记录"段。不要让决策只留在对话里(对话会丢)。

### Step 5: 更新 CURRENT.md
在 CURRENT.md 的"当前 task"段记一句:"clarify 完成,已确定 <N> 个决策点"。

## 铁律
- **不动手写代码**,只问问题和记答案。
- 如果 spec 已经足够清晰没有歧义(罕见),也要明确说"我扫了一遍,没有歧义点,可以进入 /vibe-tasks"。
- 至少列 3 条歧义点,除非 feature 极简(2 行代码那种)。
