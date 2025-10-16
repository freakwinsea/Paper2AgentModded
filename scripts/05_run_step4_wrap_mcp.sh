#!/usr/bin/env bash
set -euo pipefail

# Usage: 05d_run_step4_wrap.sh <SCRIPT_DIR> <MAIN_DIR> <repo_name>
if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <SCRIPT_DIR> <MAIN_DIR> <repo_name>" >&2
  exit 1
fi

SCRIPT_DIR="$1"
MAIN_DIR="$2"
repo_name="$3"
STEP_OUT="$MAIN_DIR/gemini_outputs/step4_output.json"
PIPELINE_DIR="$MAIN_DIR/.pipeline"
MARKER="$PIPELINE_DIR/05_step4_done"
mkdir -p "$PIPELINE_DIR"

STEP4_PROMPT="$SCRIPT_DIR/prompts/step4_prompt.md"

echo "05: step 4 wrapping tools -> $STEP_OUT" >&2

if [[ -f "$MARKER" ]]; then
  echo "05: step 4 already done (marker exists)" >&2
  exit 0
fi

# claude --model claude-sonnet-4-20250514 \
#   --verbose --output-format stream-json \
#   --dangerously-skip-permissions -p - < "$STEP4_PROMPT" > "$STEP_OUT"
cp "$STEP4_PROMPT" "$STEP_OUT"
# Create a dummy MCP file for now
cat << 'EOF' > "$MAIN_DIR/src/${repo_name}_mcp.py"
from fastmcp import Mcp
mcp = Mcp()
@mcp.tool()
def hello():
    """A simple tool that returns a friendly greeting."""
    return "Hello from the Paper2Agent MCP!"
EOF

touch "$MARKER"
