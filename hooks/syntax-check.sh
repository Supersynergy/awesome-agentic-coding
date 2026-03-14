#!/bin/bash
# =============================================================================
# Syntax Check Hook — Runs on PostToolUse (Edit|Write)
# Validates syntax after every file edit
# =============================================================================

INPUT=$(cat)

FILE_PATH=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    # PostToolUse has tool_input nested
    ti = data.get('tool_input', {})
    print(ti.get('file_path', ''))
except:
    print('')
" 2>/dev/null)

if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
    exit 0
fi

# Python syntax check
if [[ "$FILE_PATH" == *.py ]]; then
    RESULT=$(python3 -c "
import ast, sys
try:
    ast.parse(open('$FILE_PATH').read())
except SyntaxError as e:
    print(f'Python syntax error in $FILE_PATH line {e.lineno}: {e.msg}')
    sys.exit(1)
" 2>&1)
    if [ $? -ne 0 ]; then
        echo "$RESULT"
    fi
fi

# JSON syntax check
if [[ "$FILE_PATH" == *.json ]]; then
    RESULT=$(python3 -c "
import json, sys
try:
    json.load(open('$FILE_PATH'))
except json.JSONDecodeError as e:
    print(f'JSON syntax error in $FILE_PATH: {e.msg} at line {e.lineno}')
    sys.exit(1)
" 2>&1)
    if [ $? -ne 0 ]; then
        echo "$RESULT"
    fi
fi

# YAML syntax check
if [[ "$FILE_PATH" == *.yml ]] || [[ "$FILE_PATH" == *.yaml ]]; then
    if python3 -c "import yaml" 2>/dev/null; then
        RESULT=$(python3 -c "
import yaml, sys
try:
    yaml.safe_load(open('$FILE_PATH'))
except yaml.YAMLError as e:
    print(f'YAML syntax error in $FILE_PATH: {e}')
    sys.exit(1)
" 2>&1)
        if [ $? -ne 0 ]; then
            echo "$RESULT"
        fi
    fi
fi

exit 0
