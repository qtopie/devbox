---
name: init-agent-workspace
description: "一键初始化基于 Spec 驱动开发 (SDD) 的 AI-Native 项目规范目录与 Agent 规则体系。包含完整的模版资源、双层测试规范、总控规则与校验脚本。"
inputs:
  project_name:
    type: string
    description: "项目名称"
  primary_language:
    type: string
    description: "主要编程语言 (例如: Go, TypeScript, Java, Rust)"
---

# Skill: Init Agent Workspace

本 Skill 旨在为项目提供基于 **Spec 驱动开发 (Spec-Driven Development, SDD)** 的 AI-Native 脚手架初始化能力。
根据 **Agent Skill 最佳实践**（按需增强 `LLM / Planning / Memory / Tools`），本 Skill 将引导 Agent 按照确定性步骤完成规范架构部署，并内置完整的**测试闭环规范体系**。

---

## 测试闭环三层架构

为了防止 Agent 写敷衍测试、滥用外部依赖或忽略测试执行，工程测试规范分布在以下 3 个关键位置：

1. **策略层 (`docs/testing/guidelines.md`)**: 定义测试工具链、单元测试/集成测试目录分层、Mock 原则及标准测试运行命令。
2. **场景层 (`specs/modules/*.spec.md`)**: 定义具体需求的 BDD 场景断言与 `Mapped Test` 测试用例文件映射。
3. **执行层 (`AGENTS.md` + `scripts/check.sh`)**: 约束 Agent 编码完成后必须运行 `./scripts/check.sh` 进行 Lint、全量测试与 Spec 漂移校验。

---

## 核心流程 (Core Workflow)

当用户调用此 Skill 时，请顺序执行以下 6 个步骤：

### Step 1: 建立目录骨架
依次创建以下工程文件夹：
- `.agents/skills`
- `specs/apis`
- `specs/schemas`
- `specs/modules`
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
1. 将本 Skill 的 `assets/TASK.md` 复制为项目 `.agents/TASK.md`（动态进度看板）。
2. 将本 Skill 的 `assets/AGENTS.md` 复制为项目根目录 `AGENTS.md`（Agent 核心总控、Spec 门禁及测试门禁）。

### Step 4: 部署工程模版与测试指南
按如下映射关系，将本 Skill `assets/` 目录中的模版部署至目标项目：
- `assets/specs/template.spec.md` ➔ `specs/modules/template.spec.md` (包含 `Mapped Test` 断言映射模板)
- `assets/docs/testing-guidelines.md` ➔ `docs/testing/guidelines.md` (并将文件中的 `{{primary_language}}` 替换为用户传入的实际语言)
- `assets/docs/rfc.template.md` ➔ `docs/rfcs/template.md`
- `assets/docs/bug.template.md` ➔ `docs/bugs/template.md`
- `assets/docs/code-conventions.md` ➔ `docs/references/code-conventions.md` (替换 `{{primary_language}}`)
- `assets/docs/system-design.md` ➔ `docs/system-design.md`
- `assets/docs/project-layout.md` ➔ `docs/project-layout.md`

### Step 5: 部署校验工具链
1. 将本 Skill `scripts/` 目录下的 `check.sh` 与 `check-spec-drift.sh` 复制至项目的 `scripts/` 目录。
2. 为脚本赋予可执行权限：
   ```bash
   chmod +x scripts/check.sh scripts/check-spec-drift.sh
   ```

### Step 6: 确认与汇报
列出所有已成功初始化的目录与文件，并向用户汇报：
> “初始化完成！基于 SDD 与双层测试规范的 AI-Native 项目架构已建立。请在 `docs/system-design.md` 和 `docs/testing/guidelines.md` 中补充具体项目的技术细节。”

---

## 资源组织 (Skill Resources)

- **`assets/`**: 包含所有项目脚手架的初始化模版文件（`AGENTS.md`、`TASK.md`、`testing-guidelines.md`、`specs/` 及 `docs/` 模版）。
- **`scripts/`**: 包含随 Skill 打包的自动化校验脚本（Lint + Unit Test + Spec Drift Check）。

---

## 规则与红线 (Rules & Guardrails)

1. **Spec-First Gate**: 遵循 Single Source of Truth (SSOT)，无 Sign-off 的 Spec 前严禁直接编写业务逻辑代码。
2. **Testing & Quality Gate**: 业务改动必须有测试覆盖，严禁硬编码外部依赖，外部 I/O 必须 Mock。
3. **Dynamic Checkpoint**: 任何开发任务启动时必须更新 `.agents/TASK.md`，保障中断后可随时恢复上下文。
4. **Mandatory Self-Validation**: 代码变更完成后，必须运行 `./scripts/check.sh` 确保测试通过后方可交付。
5. **Safety First**: 禁止强推 `git push --force` 或破坏性清除文件命令。
