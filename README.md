# Looped Builder Skill

A Claude Code plugin for scaffolding large, complex implementation tasks that run iteratively using Claude in a bash loop.

## Installation

### Option 1: Install from GitHub (Recommended)

```bash
# Add the marketplace
claude plugin marketplace add github:xaneem/looped-builder-skill

# Install the plugin
claude plugin install looped-builder@looped-builder
```

### Option 2: Install from Local Directory

```bash
# Clone the repository
git clone https://github.com/xaneem/looped-builder-skill.git

# Add as a local marketplace
claude plugin marketplace add /path/to/looped-builder-skill

# Install the plugin
claude plugin install looped-builder@looped-builder
```

### Verify Installation

```bash
claude plugin list
```

You should see `looped-builder@looped-builder` with status `enabled`.

## What It Does

When you have a big feature, refactor, or exploration that's too large for a single Claude session, this skill helps you:

1. **Create a detailed spec** - Clear requirements and success criteria
2. **Generate a phased implementation plan** - Small, atomic steps sized for Claude's context window
3. **Set up iterative execution** - A bash loop that runs Claude repeatedly until done

## Usage

In any Claude Code session, invoke the skill:

```
/looped-builder
```

Or describe your task naturally:

```
Using the looped builder skill, help me implement [feature description] in [project]
```

Claude will:
1. Ask clarifying questions if needed
2. Explore your codebase to understand patterns
3. Generate `spec.md`, `implementation_plan.md`, `prompt.md`, and `run.sh`
4. Ask you to review before execution

Then run:
```bash
cd [feature-directory]
chmod +x run.sh
./run.sh
```

## How It Works

The bash loop:
1. Reads `prompt.md` and sends it to Claude
2. Claude finds the first unchecked `- [ ]` item in `implementation_plan.md`
3. Claude implements that one step and marks it `- [x]`
4. Loop repeats until all steps are done or max iterations reached

## Key Design Principles

### Context Window Management
Each step is designed to fit within 50-60% of Claude's context window. This means:
- Exploration steps focus on one area at a time
- Implementation steps touch 1-3 files max
- Each step is self-contained with enough context

### Exploration Before Implementation
The plan always starts with exploration phases that document:
- File locations and line numbers
- Existing patterns to follow
- Integration points

This information is captured in the plan itself, providing context for later steps.

### Atomic Steps
Steps are small and specific:
- "Add constant `PREF_X` to Settings.java"
- "Create getter method for X"
- NOT: "Implement the settings system" (too broad)

## Files Generated

| File | Purpose |
|------|---------|
| `spec.md` | Requirements, user stories, success criteria |
| `implementation_plan.md` | Phased checklist with atomic steps |
| `prompt.md` | Instructions for each iteration |
| `run.sh` | Bash loop that runs Claude iteratively |

## Directory Structure

The skill creates files in a dedicated feature directory:

```
your-project/
  docs/
    feature-name/
      spec.md
      implementation_plan.md
      prompt.md
      run.sh
```

Or:
```
your-project/
  .claude/
    builds/
      feature-name/
        ...
```

## Configuration

In `run.sh`, adjust:
- `MAX_ITERATIONS` - Default 50, increase for very large tasks
- `PROJECT_DIR` - Path to project root (script runs Claude from here)

## Tips

1. **Review the plan** before running - adjust step granularity if needed
2. **Run in tmux/screen** for long executions
3. **Check progress** anytime by reading `implementation_plan.md`
4. **Pause and resume** - just run `./run.sh` again, it continues from last completed step

## Repository Structure

```
looped-builder-skill/
├── .claude-plugin/
│   ├── plugin.json          # Plugin metadata
│   └── marketplace.json     # Marketplace manifest
├── skills/
│   └── looped-builder/
│       └── SKILL.md         # The skill instructions
├── templates/               # Template files for reference
├── examples/                # Example implementations
└── README.md
```

## License

MIT
