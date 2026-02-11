---
description: Implement user stories using TDD methodology (RED-GREEN-REFACTOR) with comprehensive test coverage
---

# /code

Implements user stories using Test-Driven Development with automatic retry cycles.

## Usage

```bash
# Build mode (default) - Full TDD implementation
/code [build] <story-key>

# Test mode - Validate existing implementation
/code test <story-key>
```

## Parameters

- **story-key** (required): Story key (e.g., PROJ-123)

## Execution Instructions

**CRITICAL: When this command is invoked, you MUST follow these steps exactly:**

### Step 1: Parse Arguments

Extract the mode and story-key from the command arguments:
- Mode: `build` (default) or `test`
- Story Key: The story identifier (e.g., PROJ-123)

**Examples:**
- `/code build PROJ-123` -> mode="build", story_key="PROJ-123"
- `/code PROJ-123` -> mode="build" (default), story_key="PROJ-123"
- `/code test PROJ-123` -> mode="test", story_key="PROJ-123"

### Step 1.5: Fetch Story Data (REQUIRED)

**CRITICAL: Before invoking the agent, fetch the story data**

1. **Validate story-key format:** `^[A-Z][A-Z0-9]+-[0-9]+$`
2. **Fetch story data** using available tracker integration (if installed)
3. **Store the story data** returned
4. **If no tracker available or fetch fails:** Ask user to provide story content directly

### Step 2: Invoke Agent with Pre-Fetched Data (REQUIRED)

Use the **Task tool** to invoke the specialized agent WITH the pre-fetched story data:

```
Task tool with:
  subagent_type: "ai-sdlc:code"
  description: "Implement story using TDD"
  prompt: """
Mode: <mode>
Story Key: <story-key>

=== STORY DATA (PRE-FETCHED) ===
<paste full story JSON or formatted data from Step 1.5>
=== END STORY DATA ===

IMPORTANT: The story data above is already fetched.
DO NOT attempt to fetch it again.

Execute the TDD workflow using the provided story data.
"""
```

**Example:**
- User types: `/code build PROJ-123`
- You invoke: Skill tool to fetch story, then Task tool with pre-fetched data in prompt

### Step 3: What NOT to Do (CRITICAL)

**DO NOT** invoke skills directly (e.g., `code-test-create`, `code-build`, `code-test-verify`)
**DO NOT** implement the TDD workflow yourself
**DO NOT** call MCP tools directly
**DO NOT** write test or implementation code yourself
**DO NOT** create scripts or analyze files
**DO NOT** fetch the story again (it's already provided to the agent)

### Step 4: Wait for Agent Results

The `ai-sdlc:code` agent will:
1. Parse pre-fetched story data from prompt
2. Review documentation context
3. Execute full TDD cycle (RED-GREEN-REFACTOR)
4. Retry up to 3 times if tests fail
5. Commit changes when complete
6. Return comprehensive results

### Step 5: Present Results to User

Once the agent completes, present its results to the user without modification.

---

## What This Command Does

Implements user stories using Test-Driven Development:

- **Build mode** (default): Full TDD cycle with implementation
- **Test mode**: Validate existing implementation only

**Workflow:**
1. Parse command arguments (mode + story-key)
2. Fetch story data via available tracker integration
3. Pass story data to code agent
4. Agent generates failing tests (RED)
5. Agent implements code (GREEN)
6. Agent verifies all tests pass
7. Retry up to 3 times if needed
8. Commit changes when complete
