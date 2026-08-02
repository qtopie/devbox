---
name: init-agent-workspace
description: "一键初始化基于 Spec 驱动开发 (SDD) 的 AI-Native 项目规范目录与 Agent 规则体系。包含完整的模版资源、总控规则与校验脚本。"
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
根据 **Agent Skill 最佳实践**（按需增强 `LLM / Planning / Memory / Tools`），本 Skill 将引导 Agent 按照确定性步骤完成规范架构部署。

---

## 能力增强说明

- **对 LLM**: 注入 `AGENTS.md` 规则总控、安全红线及针对 `{{primary_language}}` 的代码规范。
- **对 Planning**: 提供确定性的脚手架搭建步骤（Step 1 ~ Step 6）及 `.agents/TASK.md` 动态进度看板管理。
- **对 Memory**: 提供结构化的上下文模版与设计契约（`specs/`、`rfcs/`、`bugs/`、`system-design.md`）。
- **对 Tools**: 部署 `./scripts/check.sh` 与 `./scripts/check-spec-drift.sh` 通用自动化校验链。

---

## 核心流程 (Core Workflow)

当用户调用此 Skill 时，请顺序执行以下 6 个步骤：

### Step 1: 建立目录骨架
依次创建以下工程文件夹：
- `.agents/mcp`
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
2. 将本 Skill 的 `assets/AGENTS.md` 复制为项目根目录 `AGENTS.md`（Agent 核心总控与 Spec 门禁）。

### Step 4: 部署工程模版文件
按如下映射关系，将本 Skill `assets/` 目录中的模版部署至目标项目：
- `assets/specs/template.spec.md` ➔ `specs/modules/template.spec.md`
- `assets/docs/rfc.template.md` ➔ `docs/rfcs/template.md`
- `assets/docs/bug.template.md` ➔ `docs/bugs/template.md`
- `assets/docs/code-conventions.md` ➔ `docs/references/code-conventions.md`（并将文件中的 `{{primary_language}}` 占位符替换为用户传入的实际语言）
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
> “初始化完成！基于 SDD 的 AI-Native 项目架构已建立。请在 `docs/system-design.md` 和 `docs/references/code-conventions.md` 中补充具体项目的技术细节。”

---

## 资源组织 (Skill Resources)

- **`assets/`**: 包含所有项目脚手架的初始化模版文件（`AGENTS.md`、`TASK.md`、`specs/` 及 `docs/` 模版）。
- **`scripts/`**: 包含随 Skill 打包的自动化校验脚本，供安装部署至目标项目。

---

## 规则与红线 (Rules & Guardrails)

1. **Spec-First Gate**: 遵循 Single Source of Truth (SSOT)，无 Sign-off 的 Spec 前严禁直接编写业务逻辑代码。
2. **Dynamic Checkpoint**: 任何开发任务启动时必须更新 `.agents/TASK.md`，保障中断后可随时恢复上下文。
3. **Safety First**: 禁止强推 `git push --force` 或破坏性清除文件命令。
