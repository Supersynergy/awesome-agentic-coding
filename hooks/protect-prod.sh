#!/bin/bash
# =============================================================================
# Production Protection Hook — Runs on PreToolUse (Write|Edit)
# Blocks edits to production configuration files
# =============================================================================

INPUT=$(cat)

FILE_PATH=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    print(data.get('tool_input', {}).get('file_path', ''))
except:
    print('')
" 2>/dev/null)

if [ -z "$FILE_PATH" ]; then
    exit 0
fi

# Production file patterns to protect
PROD_PATTERNS=(
    "prod\.config"
    "production\.config"
    "prod\.env"
    "\.env\.production"
    "docker-compose\.prod"
    "k8s/prod"
    "deploy/prod"
    "infrastructure/prod"
    "terraform/prod"
)

for pattern in "${PROD_PATTERNS[@]}"; do
    if echo "$FILE_PATH" | grep -qiE "$pattern"; then
        echo "BLOCKED: Cannot edit production file '$FILE_PATH'. Production configs require manual review. Edit staging/dev config instead, or ask user for explicit permission." >&2
        exit 2
    fi
done

exit 0
