# Harness Engineering & Evaluation Standards

Harness Engineering 是将 Spec 驱动开发（SDD）升维为自动化闭环流水线的核心手段。Spec 是标尺，Agent 是工人，Harness 则是自动化检测台与防护栏。

## 1. 核心四大维度
1. **Spec 到 Harness 自动化转化 (Executable Specs):** `specs/modules/*.spec.md` 中的场景断言必须映射并生成 `harness/` 中的测试夹具与桩服务。
2. **隔离与运行沙盒 (Sandboxed Execution Harness):** 通过 `harness/docker-compose.yml` 与沙盒隔离运行环境，防止测试污染与边缘异常漏检。
3. **结构化诊断反馈闭环 (Diagnostic Telemetry Feedback):** Harness 报错时自动过滤杂乱 Log，生成格式化的 `Expected vs Actual` 诊断报告并写回 `.agents/TASK.md`。
4. **Agent Evals (能力评估与基准测试):**
   - **Pass@1 成功率:** 统计代码首次生成即通过 Harness 校验的比例。
   - **回归率 (Regression Rate):** 检查修复问题时是否破坏既有 Spec 场景。
   - **Spec 覆盖率 (Spec Coverage):** 统计 `specs/` 场景中被 Harness 实际覆盖的比例。

## 2. 目录职责分工
- `harness/fixtures/`: 自动化测试用例静态数据与 Mock 存根 Schema。
- `harness/mocks/`: 外部依赖、数据库与 RPC 接口桩服务。
- `harness/runners/`: BDD 场景套件执行器与不变量断言点。
- `harness/docker-compose.yml`: 容器化测试沙盒定义。
