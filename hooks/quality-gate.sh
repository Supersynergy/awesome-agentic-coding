#!/bin/bash
# =============================================================================
# Quality Gate Hook — Runs on Stop event
# Ensures tests pass before Claude "finishes" a task.
# If tests fail, Claude gets the error and must fix it.
# =============================================================================

# Detect project type and run appropriate tests
run_tests() {
    local result=""
    local exit_code=0

    # Node.js / npm
    if [ -f "package.json" ]; then
        if grep -q '"test"' package.json 2>/dev/null; then
            result=$(npm test 2>&1 | tail -20)
            exit_code=$?
            if [ $exit_code -ne 0 ]; then
                echo "npm test failed:" >&2
                echo "$result" >&2
                return 2
            fi
        fi
    fi

    # Python / pytest
    if [ -f "pytest.ini" ] || [ -f "pyproject.toml" ] || [ -f "setup.py" ] || [ -d "tests" ]; then
        if command -v python3 &>/dev/null; then
            result=$(python3 -m pytest --tb=short -q 2>&1 | tail -15)
            exit_code=$?
            if [ $exit_code -ne 0 ] && [ $exit_code -ne 5 ]; then
                # exit 5 = no tests collected (ok)
                echo "pytest failed:" >&2
                echo "$result" >&2
                return 2
            fi
        fi
    fi

    # Go
    if [ -f "go.mod" ]; then
        result=$(go test ./... 2>&1 | tail -15)
        exit_code=$?
        if [ $exit_code -ne 0 ]; then
            echo "go test failed:" >&2
            echo "$result" >&2
            return 2
        fi
    fi

    # Rust
    if [ -f "Cargo.toml" ]; then
        result=$(cargo test 2>&1 | tail -15)
        exit_code=$?
        if [ $exit_code -ne 0 ]; then
            echo "cargo test failed:" >&2
            echo "$result" >&2
            return 2
        fi
    fi

    return 0
}

# Only run if we're in a project directory with source files
if [ -f "package.json" ] || [ -f "pytest.ini" ] || [ -f "pyproject.toml" ] || [ -f "go.mod" ] || [ -f "Cargo.toml" ] || [ -d "tests" ]; then
    run_tests
    exit $?
fi

exit 0
