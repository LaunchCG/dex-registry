# /story

Generates DoR-compliant user stories from descriptions or validates existing stories.

## Usage

```bash
# Build mode - Generate new story
/story [build] <description>

# Test mode - Validate existing story
/story test <story-key>
```

## Parameters

- **description**: Natural language feature description (build mode)
- **story-key**: Story key to validate (test mode, e.g., PROJ-123)

## Execution Instructions

**CRITICAL: When this command is invoked, you MUST follow these steps exactly:**

### Step 1: Parse Arguments and Determine Mode

Extract the mode and content from command arguments:
- Mode: `build` (default) or `test`
- Content: Description (build mode) or story-key (test mode)

**Examples:**
- `/story build User authentication` -> mode="build", content="User authentication"
- `/story User authentication` -> mode="build" (default), content="User authentication"
- `/story test PROJ-123` -> mode="test", content="PROJ-123"

### Step 1.5A: Parse Epic Reference (Build Mode Only)

**If build mode:** Check if description contains epic reference

**Pattern to detect:** `(from EPIC-XXX)` or `from EPIC-XXX`
**Regex:** `\(from ([A-Z][A-Z0-9]+-\d+)\)|from ([A-Z][A-Z0-9]+-\d+)`

**Processing:**
1. Search description for epic reference pattern
2. If found: Extract epic key (e.g., "EPIC-456")
3. If found: Remove epic reference from description (create clean_description)
4. If epic found: Proceed to Step 1.5B
5. If no epic: Skip to Step 2 (Build Mode - No Epic case)

**Examples:**
- `"User auth (from EPIC-456)"` -> epic_key="EPIC-456", clean_description="User auth"
- `"User auth from EPIC-456"` -> epic_key="EPIC-456", clean_description="User auth"
- `"User auth"` -> No epic, clean_description="User auth"

### Step 1.5B: Fetch Epic Data (Build Mode with Epic)

**If epic was referenced in build mode, fetch it before invoking agent**

1. **Validate epic-key format:** `^[A-Z][A-Z0-9]+-[0-9]+$`
2. **Fetch epic data** using available tracker integration (if installed)
3. **Store the epic data** returned
4. **If no tracker available or fetch fails:** Ask user to provide epic context directly

### Step 1.5C: Fetch Story Data (Test Mode)

**If test mode, fetch the story before invoking agent**

1. **Extract story-key** from content
2. **Validate story-key format:** `^[A-Z][A-Z0-9]+-[0-9]+$`
3. **Fetch story data** using available tracker integration (if installed)
4. **Store the story data** returned
5. **If no tracker available or fetch fails:** Ask user to provide story content directly

### Step 2: Invoke Agent with Pre-Fetched Data (REQUIRED)

Choose the appropriate invocation based on mode and data availability:

#### Build Mode (No Epic):
```
Task tool with:
  subagent_type: "ai-sdlc:story"
  description: "Generate user story"
  prompt: """
Mode: build
Description: <description>

Generate a new story from this description.
"""
```

#### Build Mode (With Epic):
```
Task tool with:
  subagent_type: "ai-sdlc:story"
  description: "Generate user story with epic context"
  prompt: """
Mode: build
Description: <clean_description>
Epic Key: <epic-key>

=== EPIC CONTEXT (PRE-FETCHED) ===
<paste epic JSON or formatted data from Step 1.5B>
=== END EPIC CONTEXT ===

IMPORTANT: Epic context is already fetched. DO NOT fetch it again.
Generate story within this epic's context.
"""
```

#### Test Mode:
```
Task tool with:
  subagent_type: "ai-sdlc:story"
  description: "Validate user story"
  prompt: """
Mode: test
Story Key: <story-key>

=== STORY DATA (PRE-FETCHED) ===
<paste story JSON or formatted data from Step 1.5C>
=== END STORY DATA ===

IMPORTANT: Story data is already fetched. DO NOT fetch it again.
Validate this story against DoR standards.
"""
```

### Step 3: What NOT to Do (CRITICAL)

- **DO NOT** invoke skills directly (e.g., `story-test-create`, `story-build`, `story-test-verify`)
- **DO NOT** generate the story yourself
- **DO NOT** call MCP tools directly
- **DO NOT** create tracker issues yourself
- **DO NOT** validate DoR criteria yourself
- **DO NOT** fetch story or epic again (already provided to agent)

### Step 4: Wait for Agent Results

The `ai-sdlc:story` agent will:
1. Parse pre-fetched data from prompt (if applicable)
2. **Build mode**: Generate story from description
3. **Test mode**: Validate against DoR using provided story data
4. Retry up to 3 times if validation fails
5. Return results with quality scores

### Step 5: Present Results to User

Once the agent completes, present its results to the user without modification.

---

## What This Command Does

Generates DoR-compliant user stories or validates existing ones:

- **Build mode** (default): Generate story using templates
  - Optional: Include epic context by adding `(from EPIC-XXX)` to description
- **Test mode**: Validate existing story against DoR standards

**Workflow:**

**Build Mode (No Epic):**
1. Parse description from arguments
2. Pass to story agent
3. Agent generates DoR-compliant story
4. Agent presents story to user

**Build Mode (With Epic):**
1. Parse description and detect epic reference
2. Fetch epic data via available tracker integration
3. Pass clean description + epic context to agent
4. Agent generates story aligned with epic goals
5. Agent presents story to user

**Test Mode:**
1. Parse story-key from arguments
2. Fetch story data via available tracker integration
3. Pass story data to agent
4. Agent validates against DoR standards
5. Agent presents feedback to user

**Story includes:**
- User story format (As a... I want... So that...)
- Acceptance criteria (testable, measurable)
- Technical approach
- DoR compliance validation
