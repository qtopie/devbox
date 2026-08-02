# Project Layout & Module Boundaries

## Directory Structure
- `specs/`: Single Source of Truth (SSOT) 规范与契约
- `docs/`: 方案设计、RFCs、Bug RCA、规范文档
  - `docs/testing/guidelines.md`: 全局测试规范与工具链指引
- `testings/`: 自动化集成测试与 E2E 测试集
- `scripts/`: 构建与校验自动化工具链（`check.sh`, `check-spec-drift.sh`）

## Module Dependencies Rule
- 模块间依赖必须保持单向流转，禁止循环依赖。
- 业务代码实现必须时刻保持与 `specs/` 契约一致。
- 单元测试放在与被测代码同级的目录下；集成/E2E 测试统一放在 `testings/` 下。
