#!/usr/bin/env bash
# Run tests for the project

set -euo pipefail

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

# Run bats tests
echo "Running format-fix.sh tests..."
mise exec -- bats "$PROJECT_ROOT/tests/format-fix.bats"
