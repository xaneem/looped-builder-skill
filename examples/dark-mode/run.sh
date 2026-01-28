#!/bin/bash

# Looped Builder - Dark Mode Implementation
# Usage: ./run.sh [max_iterations]

set -e

MAX_ITERATIONS=${1:-50}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
FEATURE_NAME=$(basename "$SCRIPT_DIR")

BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# Verify required files exist
if [ ! -f "$SCRIPT_DIR/prompt.md" ]; then
  echo "Error: prompt.md not found in $SCRIPT_DIR"
  exit 1
fi

if [ ! -f "$SCRIPT_DIR/implementation_plan.md" ]; then
  echo "Error: implementation_plan.md not found in $SCRIPT_DIR"
  exit 1
fi

cd "$PROJECT_DIR"

echo ""
echo -e "${BOLD}$FEATURE_NAME${NC}"
echo -e "${DIM}Project: $PROJECT_DIR${NC}"
echo ""

for i in $(seq 1 $MAX_ITERATIONS); do
  echo -e "${BOLD}--- Iteration $i / $MAX_ITERATIONS ---${NC}"
  echo ""

  OUTPUT=$(claude --dangerously-skip-permissions --print < "$SCRIPT_DIR/prompt.md" 2>&1 | tee /dev/stderr) || {
    echo ""
    echo "Error in iteration $i, continuing..."
    sleep 2
    continue
  }

  if echo "$OUTPUT" | grep -q "<promise>COMPLETE</promise>"; then
    echo ""
    echo -e "${BOLD}Done.${NC} Completed in $i iteration(s)."
    exit 0
  fi

  echo ""
  sleep 2
done

echo ""
echo "Reached max iterations ($MAX_ITERATIONS). Check implementation_plan.md for remaining steps."
exit 1
