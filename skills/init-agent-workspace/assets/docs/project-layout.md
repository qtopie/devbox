# Project Layout & Module Boundaries

## Directory Structure
- `specs/`: Single Source of Truth (SSOT) 规范与契约
- `docs/`: 方案设计、RFCs、Bug RCA、规范文档
- `testings/`: 自动化测试集
- `scripts/`: 构建与校验自动化工具链

## Module Dependencies Rule
- 模块间依赖必须保持单向流转，禁止循环依赖。
- 业务代码实现必须时刻保持与 `specs/` 契约一致。
