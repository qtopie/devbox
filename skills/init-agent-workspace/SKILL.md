---
name: init-agent-workspace
description: "一键初始化基于 Spec 驱动开发 (SDD) 与 Harness Engineering (测试套件/评估工程) 的 AI-Native 项目规范目录与 Agent 规则体系。"
inputs:
  project_name:
    type: string
    description: "项目名称"
  primary_language:
    type: string
    description: "主要编程语言 (例如: Go, TypeScript, Java, Rust)"
---

# Skill: Init Agent Workspace (with Harness Engineering)

本 Skill 旨在为项目提供基于 **Spec 驱动开发 (Spec-Driven Development, SDD)** 与 **Harness Engineering (测试套件/评估工程)** 的 AI-Native 脚手架初始化能力。
通过将 Spec 作为“标尺”、Harness 作为“自动化检测台”与 Agent 作为“开发主体”，构建具备**自动化夹具、沙盒隔离运行、结构化诊断反馈 (Diagnostic Telemetry) 与闭环纠错**的高可靠 AI 协作系统。

---

## 架构能力增强 (Enhancement Architecture)

- **对 LLM**: 注入 `AGENTS.md` 规则总控、Harness 闭环门禁及语言规范。
- **对 Planning**: 提供确定性的脚手架搭建步骤（Step 1 ~ Step 6）及 `.agents/TASK.md` 动态进度看板管理（带 Harness 诊断日志节点）。
- **对 Memory**: 提供结构化的上下文模版、设计契约（`specs/`、`rfcs/`、`bugs/`）与 `harness/` 夹具存根。
- **对 Tools & Sandbox**: 部署 `harness/docker-compose.yml` 沙盒环境与 `./scripts/check-harness.sh` 自动化测试评估管线。

---

## 核心流程 (Core Workflow)

当用户调用此 Skill 时，请顺序执行以下 6 个步骤：

### Step 1: 建立目录骨架
依次创建以下工程文件夹：
- `.agents/skills`
- `specs/apis`
- `specs/schemas`
- `specs/modules`
- `harness/fixtures`
- `harness/mocks`
- `harness/runners`
- `docs/rfcs`
- `docs/bugs`
- `docs/references`
- `docs/testing`
- `testings`
- `scripts`

### Step 2: 部署 Agent 配置与 MCP 软链接
1. 读取本 Skill 的 `assets/agentsignore` 内容，生成项目 `.agents/.agentsignore`。
2. 在项目 `.gitignore` 中写入/追加规则：
   ```text
   .agents/TASK.md
   ```
3. 读取本 Skill 的 `assets/mcp_config.json`，生成项目 `.agents/mcp_config.json`。
4. 在 `.agents/` 目录下创建软链接（同时兼容 Antigravity 与 GitHub Copilot 命名约定）：
   ```bash
   ln -sf mcp_config.json .agents/mcp-config.json
   ```

### Step 3: 初始化动态看板与规则总控
1. 将本 Skill 的 `assets/TASK.md` 复制为项目 `.agents/TASK.md`（带 Harness 诊断反馈区）。
2. 将本 Skill 的 `assets/AGENTS.md` 复制为项目根目录 `AGENTS.md`（Agent 核心总控、Spec 门禁及 Harness 测试门禁）。

### Step 4: 部署工程模版、测试指南与 Harness 夹具
按如下映射关系，将本 Skill `assets/` 目录中的模版部署至目标项目：
- `assets/specs/template.spec.md` ➔ `specs/modules/template.spec.md` (包含 `Mapped Test` 断言映射模板)
- `assets/harness/docker-compose.yml` ➔ `harness/docker-compose.yml`
- `assets/harness/runners/spec_runner.sh` ➔ `harness/runners/spec_runner.sh`
- `assets/harness/mocks/README.md` ➔ `harness/mocks/README.md`
- `assets/docs/harness-engineering.md` ➔ `docs/testing/harness-engineering.md`
- `assets/docs/testing-guidelines.md` ➔ `docs/testing/guidelines.md` (替换 `{{primary_language}}`)
- `assets/docs/rfc.template.md` ➔ `docs/rfcs/template.md`
- `assets/docs/bug.template.md` ➔ `docs/bugs/template.md`
- `assets/docs/code-conventions.md` ➔ `docs/references/code-conventions.md` (替换 `{{primary_language}}`)
- `assets/docs/system-design.md` ➔ `docs/system-design.md`
- `assets/docs/project-layout.md` ➔ `docs/project-layout.md`

### Step 5: 部署 Harness 校验工具链
1. 将本 Skill `scripts/` 目录下的 `check.sh`、`check-harness.sh` 与 `check-spec-drift.sh` 复制至项目的 `scripts/` 目录。
2. 为脚本赋予可执行权限：
   ```bash
   chmod +x scripts/check.sh scripts/check-harness.sh scripts/check-spec-drift.sh
   ```

### Step 6: 确认与汇报
列出所有已成功初始化的目录与文件，并向用户汇报：
> “初始化完成！基于 SDD 与 Harness Engineering (沙盒/夹具/诊断反馈) 的 AI-Native 项目架构已建立。请在 `docs/system-design.md` 和 `docs/testing/harness-engineering.md` 中补充具体项目的技术细节。”

---

## SOP 开发流水线

```text
[1. 需求与方案]
  └── 撰写 RFC ➔ 编写/更新 specs/ (契约与场景断言)

[2. 夹具准备 (Harness Eng)]
  └── 根据 spec 自动生成或更新 harness/ 下的 Mock & Fixtures ➔ 获得测试断言脚本

[3. 代码实现 (Agent Coding)]
  └── Agent 在 isolated harness 环境中编写业务逻辑

[4. 自动校验与诊断 (Harness Feedback)]
  └── Harness 运行断言 ➔ 成功则通过 ➔ 失败则生成 Diagnostic Report 回传给 .agents/TASK.md

[5. 归档与合并]
  └── 代码通过 Harness 全量验证 ➔ 更新 TASK.md 状态 ➔ 提交 PR
```

---

## 规则与红线 (Rules & Guardrails)

1. **Spec-First Gate**: 遵循 Single Source of Truth (SSOT)，无 Sign-off 的 Spec 前严禁直接编写业务逻辑代码。
2. **Harness & Testing Gate**: 必须通过 Harness 夹具与沙盒测试校验，严禁硬编码外部依赖，外部 I/O 必须 Mock。
3. **Structured Telemetry**: 校验失败时优先读取 `.agents/TASK.md` 中的 Harness Failure Report 进行精准修复。
4. **Dynamic Checkpoint**: 任何开发任务启动时必须更新 `.agents/TASK.md`，保障中断后可随时恢复上下文。
5. **Mandatory Self-Validation**: 代码变更完成后，必须运行 `./scripts/check.sh` (或 `./scripts/check-harness.sh`) 确保测试通过。
6. **Safety First**: 禁止强推 `git push --force` 或破坏性清除文件命令。
