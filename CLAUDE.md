# Looped Builder Skill Instructions

When the user invokes this skill (e.g., "Using the looped builder skill, help me..."), follow these instructions to scaffold a large implementation task.

## Your Goal

Create scaffolding files that enable iterative, autonomous implementation of a complex feature or task using Claude in a bash loop.

## Process

### 1. Understand the Request

First, gather enough information to create a solid plan:

- **What** is being built? (feature, refactor, exploration, etc.)
- **Where** is the target codebase? (ask for path if not obvious)
- **Why** is it needed? (context helps make better decisions)
- **What constraints** exist? (performance, compatibility, patterns to follow)

Ask clarifying questions using the AskUserQuestion tool if the request is vague.

### 2. Explore the Codebase

Before writing any plans, explore the target codebase to understand:

- Project structure (directories, key files)
- Existing patterns (how similar features are implemented)
- Relevant code locations (what will need to change)
- Build and test commands

Use the Explore agent or direct file reading to gather this context.

### 3. Determine Feature Directory

Create the scaffolding files in a dedicated directory. Common locations:
- `docs/<feature-name>/`
- `.claude/builds/<feature-name>/`
- Ask the user if unclear

### 4. Create spec.md

Write a detailed specification including:

```markdown
# [Feature Name] - Specification

## Overview
[1-2 paragraphs describing what we're building and why]

## User Stories
[3-5 user stories in "As a X, I want Y, so that Z" format]

## Functional Requirements
[Grouped, specific requirements with FR1, FR2, etc. labels]

## Technical Requirements
[Technical constraints and patterns to follow]

## Non-Functional Requirements
[Performance, security, UX requirements]

## Out of Scope
[Explicit list of what this feature does NOT include]

## Success Criteria
[Measurable criteria to verify completion]
```

### 5. Create implementation_plan.md

This is the most critical file. Create phases with atomic steps:

**Context Window Rule**: Each step must be completable within 50-60% of Claude's context window. This means:
- Exploration steps focus on ONE specific area
- Implementation steps touch 1-3 files maximum
- Each step is self-contained

**Phase Structure**:

```markdown
# [Feature Name] - Implementation Plan

## Overview
[One sentence]

---

## Phase 1: Codebase Exploration
[Steps to discover and document relevant code locations]

## Phase 2-N: Implementation - [Component]
[Small, atomic implementation steps]

## Final Phase: Testing & Verification
[Build, test, verify steps]

---

## Notes
[Build commands, key files discovered during exploration]
```

**Step Format**:
```markdown
- [ ] **[Specific action verb] [specific thing]**
  - [Detailed instruction]
  - [Another instruction if needed]

  **Findings:** or **Implementation:**
  <!-- Filled in during execution -->
```

**Good Steps** (small, atomic):
- "Add PREF_FONT_SIZE constant to Settings.java"
- "Create FontSizeSlider component in components/"
- "Wire font size preference to keyboard view in KeyboardView.java"

**Bad Steps** (too broad):
- "Implement the settings UI"
- "Set up the data layer"
- "Add the feature"

### 6. Create prompt.md

The prompt that drives each iteration:

```markdown
# [Feature Name] - Implementation Prompt

You are implementing [brief description]. Read the spec and implementation plan, then execute the next step.

## Step 1: Check Progress
Read `[path]/implementation_plan.md` and find the first unchecked item (- [ ]).
If all complete, output: <promise>COMPLETE</promise>

## Step 2: Implement the Step
Complete ONLY that one step. Follow existing code patterns.

## Step 3: Update Progress
- Change - [ ] to - [x]
- Add findings/implementation notes
- Add new steps if discovered during work

## Step 4: Report
Output summary with: step completed, files modified, next step.

## Rules
1. One step per run
2. Read before writing
3. Follow existing patterns
4. Mark completion
5. No placeholders
```

### 7. Create run.sh

```bash
#!/bin/bash
set -e

MAX_ITERATIONS=${1:-50}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="[ADJUST THIS PATH]"
FEATURE_NAME=$(basename "$SCRIPT_DIR")

BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

cd "$PROJECT_DIR"

echo -e "${BOLD}$FEATURE_NAME${NC}"
echo -e "${DIM}Project: $PROJECT_DIR${NC}"

for i in $(seq 1 $MAX_ITERATIONS); do
  echo -e "${BOLD}--- Iteration $i / $MAX_ITERATIONS ---${NC}"

  OUTPUT=$(claude --dangerously-skip-permissions --print < "$SCRIPT_DIR/prompt.md" 2>&1 | tee /dev/stderr) || continue

  if echo "$OUTPUT" | grep -q "<promise>COMPLETE</promise>"; then
    echo -e "${BOLD}Done.${NC} Completed in $i iteration(s)."
    exit 0
  fi

  sleep 2
done

echo "Reached max iterations. Check implementation_plan.md."
exit 1
```

Adjust `PROJECT_DIR` to point from the feature directory to the project root.

### 8. Present for Review

After creating all files, summarize:

```
## Scaffolding Complete

Created in `[directory]/`:

**spec.md** - [brief summary]

**implementation_plan.md** - [N] phases, [M] total steps:
- Phase 1: Exploration ([n] steps)
- Phase 2: [name] ([n] steps)
...

**prompt.md** - Iteration prompt
**run.sh** - Execution script

---

**Important:** Run this script directly in your terminal, not through Claude Code. The script runs multiple iterations that can take a long time to complete, which will exceed Claude Code's execution timeout.

To execute:
```bash
cd [directory]
chmod +x run.sh
./run.sh
```

Review the spec and plan. Let me know if you'd like any adjustments.
```

## Important Guidelines

1. **Exploration before implementation** - Always include exploration phases that document the codebase structure first

2. **Testing is required** - Every plan must end with testing/verification steps

3. **Step granularity matters** - If in doubt, make steps smaller rather than larger

4. **Paths must be correct** - Ensure paths in prompt.md and run.sh are accurate

5. **Follow existing patterns** - During exploration, identify patterns to follow in implementation

6. **Be specific** - Vague steps lead to inconsistent execution

7. **Document discoveries** - The Findings sections capture context for later steps
