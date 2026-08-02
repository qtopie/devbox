#!/usr/bin/env bash
set -euo pipefail

echo "=== 1. 运行代码 Lint 校验 ==="
# Add lint / format execution commands here (e.g., golangci-lint / eslint / ruff)

echo "=== 2. 运行单元测试与集成测试 ==="
# Add test execution commands here (e.g., go test -v -race ./... / npm test / pytest)

echo "=== 3. 运行 Spec 漂移断言检查 ==="
if [ -f "./scripts/check-spec-drift.sh" ]; then
    ./scripts/check-spec-drift.sh
fi

echo "✅ 所有校验与测试已成功通过！"
