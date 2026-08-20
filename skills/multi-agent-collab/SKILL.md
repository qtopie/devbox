---
name: multi-agent-collab
description: "多Agent协作：驱动基于 Spec-First 与三方协作分工（首席架构师/编码工程师/Tech Lead）的标准开发工作流，涵盖需求拆解、Spec/Harness 制定、审批门禁、编码调度与质量验收。"
inputs:
  feature_name:
    type: string
    description: "功能特性或任务名称"
  spec_path:
    type: string
    description: "可选。指定已有的 spec 文件路径，若无则自动根据需求起草"
  subagent_role:
    type: string
    description: "可选。用于编码的 Subagent/CodeBuddy 角色定位（默认：编码工程师）"
---

# Skill: 多Agent协作工作流 (Multi-Agent Collaboration Workflow)

本 Skill 用于固化并驱动基于 **Spec-First** 理念与多 Agent 明确分工的协同开发流水线。通过将 **Antigravity (首席架构师)** 的高层设计与质量把控、**CodeBuddy / Subagents (编码工程师)** 的精准执行以及 **User (产品负责人 / Tech Lead)** 的方向决策深度结合，实现高质量、强契约、零漂移的代码交付。

---

## 🤝 协作角色与分工 (Team Roles & Responsibilities)

| 角色 | 担当 | 核心职责 |
| :--- | :--- | :--- |
| **架构与规划 (我 - Antigravity)** | 首席架构师 / 技术主管 (Architect & Tech Lead) | • 编写 RFC 架构方案与产品规划<br>• 制定严密的 `specs/*.spec.md` 接口与行为契约<br>• 搭建测试桩与 Harness 验收标准 (`harness/`, `testings/`)<br>• 构造精准任务指令调度 CodeBuddy/Subagents 编码<br>• 审查代码 Diff 并执行 `./scripts/check.sh` 质量门禁 |
| **编码实现 (CodeBuddy / Subagents)** | 编码工程师 (Software Engineer) | • 根据架构师提供的精确 Spec 和 Prompt 执行代码编写与修改<br>• 实现具体的 Go / TypeScript / Python 等业务逻辑与单元测试<br>• 保持最小改动原则 (Minimal Diff)，不越权修改 Spec 与架构 |
| **决策与方向 (您 - User)** | 产品负责人 / Tech Lead (Product Owner) | • 确认需求范围与业务设计偏好<br>• 对 RFC 与 Spec 方案执行 **APPROVE 审批门禁**<br>• 对核心设计决策与方向变更进行仲裁 |

---

## 🔄 标准协作流程 (Spec-First 工作流)

```text
       [您 (User / Tech Lead)]
           │ 提出需求 / 审批
           ▼
[我 (Antigravity 架构规划)]
  ├── 1. 拆解需求，起草 Spec (`specs/*.spec.md`) 与 Harness 测试桩 (`harness/`, `testings/`)
  ├── 2. 征得您的 APPROVE 批准
  ├── 3. 构造精准任务指令，调用 CodeBuddy 执行编码 ──▶ [CodeBuddy / Subagent 编码]
  │                                                            │ 提交代码
  │   ┌────────────────────────────────────────────────────────┘
  ▼   ▼
[我 (Antigravity 验收审查)]
  ├── 4. 运行 `./scripts/check.sh` 与自动化测试
  ├── 5. 代码 Diff 审查与边界条件校验
  └── 6. 更新任务进度 (.agents/TASK.md)，向您汇报产出
```

---

## 📋 标准执行步骤 (Standard Operating Procedure)

当执行功能开发或代码重构任务时，严格按照以下 6 个阶段顺序执行：

### Step 1: 需求拆解与架构设计 (Spec & Harness Drafting)
1. **更新看板**：在 `.agents/TASK.md` 登记当前任务与目标。
2. **起草契约**：在 `specs/modules/<feature>.spec.md` (或 `specs/apis/`, `docs/rfcs/`) 编写接口契约、行为场景与断言列表。
3. **准备测试桩 (Test Rig & Harness)**：在 `harness/fixtures/`、`harness/mocks/` 或 `testings/` 搭建对应验收测试用例骨架（Mapped Tests）。

### Step 2: 审批门禁 (User APPROVE Gate)
1. 将起草好的 Spec 和设计要点呈现给用户。
2. **强制暂停与等待**：明确请求用户确认方案。
   > ⚠️ **红线门禁**：在用户明确回复 `APPROVE` 或确认同意之前，**严禁**直接编写或调度编写业务实现代码。

### Step 3: 精确任务下发与编码调度 (CodeBuddy Invocation)
1. 获得用户批准后，构建清晰、包含边界上下文的 Prompt：
   - 附带目标 `specs/<feature>.spec.md` 契约路径
   - 附带待实现代码文件路径与项目代码规范 (`docs/references/code-conventions.md`)
   - 声明最小改动原则与错误处理要求
2. 通过 `invoke_subagent` 启动编码子代理 (CodeBuddy/Subagent)，或在受控环境下严格按架构指令实施编码。

### Step 4: 自动化门禁校验 (Harness & Check Gate)
1. 子代理/编码工程师完成代码编写后，架构师接管控制权。
2. 运行项目质量门禁脚本：
   ```bash
   ./scripts/check.sh
   # 或运行沙盒测试验证
   ./scripts/check-harness.sh
   ```
3. 检查编译、静态分析（Linter）、Race 竞争检测及单元测试覆盖。若存在失败：
   - 提取结构化失败信息与日志。
   - 调度针对性修复，累计重试 > 3 次须停下向用户汇报并寻求决策。

### Step 5: 代码审查与边界校验 (Diff & Architecture Review)
1. **Diff 审查**：检查改动范围是否超出 Spec 授权，杜绝未经允许的大规模重构与非相关代码改动。
2. **边界与安全检查**：校验空指针、并发安全、资源泄露、错误传播及 Mock 规范。
3. **Spec 一致性核对**：确保代码逻辑与 `specs/*.spec.md` 契约 100% 对齐。

### Step 6: 状态同步与交付汇报 (Progress Update & Handover)
1. 更新 `.agents/TASK.md`，标记已完成任务与交付物路径。
2. 向用户汇报交付成果，列出：
   - 实现的 Spec 契约与核心代码文件链接
   - `./scripts/check.sh` 质量门禁执行结果
   - 遗留事项或下一阶段建议
