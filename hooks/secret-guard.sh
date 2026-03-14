#!/bin/bash
# =============================================================================
# Secret Guard Hook — Runs on PreToolUse (Write|Edit)
# Blocks writes to sensitive files (.env, .pem, credentials, keys)
# Exit 2 = block + send reason to Claude
# =============================================================================

INPUT=$(cat)

# Extract file_path from tool input
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

BASENAME=$(basename "$FILE_PATH")

# Block patterns for sensitive files
BLOCKED_PATTERNS=(
    "\.env$"
    "\.env\."
    "\.pem$"
    "\.key$"
    "\.p12$"
    "\.pfx$"
    "\.jks$"
    "credentials"
    "secrets?\."
    "\.secret"
    "id_rsa"
    "id_ed25519"
    "\.npmrc$"
    "\.pypirc$"
    "auth.*\.json$"
    "service.account.*\.json$"
    "token.*\.json$"
)

for pattern in "${BLOCKED_PATTERNS[@]}"; do
    if echo "$BASENAME" | grep -qiE "$pattern"; then
        echo "BLOCKED: Cannot write to sensitive file '$BASENAME'. This file likely contains secrets/credentials. If you need to modify it, ask the user to do it manually." >&2
        exit 2
    fi
done

# Also check file content for common secret patterns (only for new files)
if echo "$INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
content = data.get('tool_input', {}).get('content', '')
# Check for obvious secrets in new file content
import re
patterns = [
    r'(?:api[_-]?key|apikey)\s*[=:]\s*[\"'\'']\S{20,}',
    r'(?:secret|password|passwd|pwd)\s*[=:]\s*[\"'\'']\S{8,}',
    r'(?:aws_access_key_id|aws_secret_access_key)\s*=',
    r'-----BEGIN (?:RSA |EC )?PRIVATE KEY-----',
    r'sk-[a-zA-Z0-9]{20,}',
    r'ghp_[a-zA-Z0-9]{36}',
    r'gho_[a-zA-Z0-9]{36}',
]
for p in patterns:
    if re.search(p, content, re.IGNORECASE):
        print('HAS_SECRETS')
        sys.exit(0)
print('CLEAN')
" 2>/dev/null | grep -q "HAS_SECRETS"; then
    echo "WARNING: File content appears to contain API keys or secrets. Please review before writing." >&2
    # Don't block, just warn — exit 0 with stderr message
fi

exit 0
