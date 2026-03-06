# Migrating Claude Code Plugins to Dex Packages

This guide covers converting Claude Code plugins (plugin.json + command files) to dex packages (package.hcl + skills/agents/rules).

## plugin.json to package.hcl Mapping

Plugin commands are standalone markdown files with YAML frontmatter — there's no manifest to convert. Create the `package{}` block from scratch:

```hcl
package {
  name        = "my-package"
  version     = "0.1.0"
  description = "Migrated from my-plugin"
  platforms   = ["claude-code", "github-copilot"]
}
```

## Command File Migration

Plugin commands are markdown files with YAML frontmatter:

```markdown
---
description: "What the command does"
argument-hint: [file-path]
allowed-tools: Read, Grep, Glob
model: opus
---

$IF($1,
  Read and review @$1,
  Review from current conversation context.
)

Command content here...
```

### Step-by-step conversion:

1. **`description`** — Move to the HCL block's `description` field
2. **Content body** — Move to a separate `.md` file, referenced via `file()`
3. **`$IF($1,...)`** — Flatten to plain markdown. Dex has no conditional argument syntax. Write instructions that work with or without arguments.
4. **`argument-hint`** — No equivalent. Document expected inputs inline in the content.
5. **`allowed-tools`** — No per-skill tool restriction in dex. Use `claude_settings` for MCP-level permissions only.
6. **`model: opus`** — No equivalent. Omit. Dex doesn't control model selection.
7. **`@$1` file references** — Replace with instructions to read relevant files. The `@` syntax doesn't exist in dex.

### Choosing the right block type:

| Plugin command pattern | Dex block |
|------------------------|-----------|
| Interactive slash command (user invokes directly) | `claude_command` |
| Expertise/guidance (passive knowledge) | `claude_skill` |
| Autonomous workflow | `claude_subagent` |
| Always-active constraint | `claude_rule` |

Most plugin commands map to `claude_skill` since dex skills are automatically available when relevant.

## Worked Example: staff-engineer Plugin

> **Note:** The `staff-engineer` plugin is an external Claude Code plugin not included in this repository.

The `staff-engineer` plugin has 4 commands: `challenge`, `review-design`, `review-plan`, and `root-cause`. Each uses `allowed-tools`, `model: opus`, `$IF($1,...)`, and `argument-hint`.

### Original plugin command (`challenge.md`):

```markdown
---
description: "Devil's advocate — stress-test assumptions and surface hidden risks"
argument-hint: [topic-or-file]
allowed-tools: Read, Grep, Glob
model: opus
---

$IF($1,
  Read and challenge the approach described in @$1,
  Challenge the approach or decision from the current conversation context.
)

You are playing devil's advocate. Your job is NOT to agree...
```

### Converted dex package:

**`staff-engineer/package.hcl`:**

```hcl
package {
  name        = "staff-engineer"
  version     = "0.1.0"
  description = "Staff engineer review skills: challenge assumptions, review designs, plans, and root causes"
  platforms   = ["claude-code", "github-copilot"]
}

claude_skill "challenge" {
  description = "Devil's advocate — stress-test assumptions and surface hidden risks"
  content     = file("skills/challenge/SKILL.md")
}

# ... repeat for review-design, review-plan, root-cause

# Copilot mirrors
copilot_skill "challenge" {
  description = "Devil's advocate — stress-test assumptions and surface hidden risks"
  content     = file("skills/challenge/SKILL.md")
}

# ... repeat for review-design, review-plan, root-cause
```

**`staff-engineer/skills/challenge/SKILL.md`** (converted from command):

```markdown
# Challenge — Devil's Advocate

Stress-test assumptions and surface hidden risks in a proposed approach.

If a specific file or topic is provided, read and challenge that approach.
Otherwise, challenge the approach from the current conversation context.

## Process

### Step 1: Understand the Position
Before challenging, clearly state what is being proposed. Steelman the
position before attacking it.

### Step 2: Challenge Through 5 Lenses
1. **Hidden Assumptions** — What are we taking for granted?
2. **Optimizing X at Cost of Y** — Name the tradeoffs explicitly.
3. **Alternative Perspectives** — Strongest counterargument?
4. **Worst Case** — Worst realistic outcome and recovery plan?
5. **Premature Decisions** — Deciding too early or deferring too long?

### Step 3: Deliver Structured Output
- **Assumptions Challenged** — Each with a counterpoint
- **Hidden Risks** — Not discussed in the original proposal
- **Strongest Counterargument** — Single best argument against
- **What I'd Want Answered** — Specific go/no-go questions
```

### What changed:

| Before (plugin) | After (dex) |
|------------------|-------------|
| `allowed-tools: Read, Grep, Glob` | Removed — skills can use any tool |
| `model: opus` | Removed — no model control in dex |
| `$IF($1, Read @$1, ...)` | Plain prose: "If provided, read that; otherwise use context" |
| `argument-hint: [topic-or-file]` | Documented inline in the skill content |
| 4 command files in `commands/` | 4 skill files in `skills/*/SKILL.md` |
| No Copilot support | `copilot_skill` mirrors added |
