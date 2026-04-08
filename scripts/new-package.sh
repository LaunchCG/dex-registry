#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/new-package.sh <package-name>
# Scaffolds a new dex package with an annotated package.hcl skeleton.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <package-name>"
  echo "Example: $0 my-package"
  exit 1
fi

PACKAGE_NAME="$1"
PACKAGE_DIR="$REPO_ROOT/$PACKAGE_NAME"

if [[ -d "$PACKAGE_DIR" ]]; then
  echo "Error: Directory '$PACKAGE_NAME' already exists at repo root."
  exit 1
fi

# Validate package name (lowercase, hyphens, no spaces)
if [[ ! "$PACKAGE_NAME" =~ ^[a-z][a-z0-9]*(-[a-z0-9]+)*$ ]]; then
  echo "Error: Package name must be lowercase alphanumeric with hyphens (e.g., 'my-package')."
  exit 1
fi

echo "Creating package: $PACKAGE_NAME"

mkdir -p "$PACKAGE_DIR/skills/example-skill/resources"
mkdir -p "$PACKAGE_DIR/agents"
mkdir -p "$PACKAGE_DIR/rules"
mkdir -p "$PACKAGE_DIR/commands"

# Create placeholder SKILL.md
cat > "$PACKAGE_DIR/skills/example-skill/SKILL.md" << 'SKILL_EOF'
# Example Skill

Replace this with your skill content. Skills provide expertise and process
guidance that Claude/Copilot can draw on when relevant.
SKILL_EOF

# Create annotated package.hcl
cat > "$PACKAGE_DIR/package.hcl" << HCL_EOF
# =============================================================================
# package.hcl for $PACKAGE_NAME
# =============================================================================
# Convention: directory name = package name = name field below.
# Every claude_* block should have a matching copilot_* block for
# cross-platform parity (see mapping table at the bottom of this file).

# -----------------------------------------------------------------------------
# Package block (REQUIRED)
# -----------------------------------------------------------------------------
package {
  name        = "$PACKAGE_NAME"
  version     = "0.1.0"
  description = "TODO: Describe your package"
  platforms   = ["claude-code", "github-copilot"]
}

# -----------------------------------------------------------------------------
# Dependencies — declare other dex packages this one requires
# -----------------------------------------------------------------------------
# dependency "base-dev" {
#   version = ">=0.1.0"
# }

# -----------------------------------------------------------------------------
# Skills — provide expertise and process guidance
# Content is loaded from a markdown file via file().
# Nested file{} blocks bundle resource files alongside the skill.
# -----------------------------------------------------------------------------
# claude_skill "example-skill" {
#   description = "TODO: What this skill provides"
#   content     = file("skills/example-skill/SKILL.md")
#
#   # Optional: bundle resource files with the skill
#   file {
#     src  = "skills/example-skill/resources/template.md"
#     dest = "resources/template.md"
#   }
# }
#
# copilot_skill "example-skill" {
#   description = "TODO: What this skill provides"
#   content     = file("skills/example-skill/SKILL.md")
# }

# -----------------------------------------------------------------------------
# Rule (singular) — always-active behavioral constraint
# Uses inline content (heredoc or string) or file().
# -----------------------------------------------------------------------------
# claude_rule "my-rule" {
#   description = "Enforce some behavior"
#   content     = file("rules/my-rule.md")
# }
#
# # Inline heredoc variant:
# claude_rule "inline-rule" {
#   description = "Short inline rule"
#   content     = <<-EOT
#     Always do X when Y happens.
#   EOT
# }
#
# copilot_instruction "my-rule" {
#   description = "Enforce some behavior"
#   content     = file("rules/my-rule.md")
# }

# -----------------------------------------------------------------------------
# Rules (plural) — collection of rule files bundled together
# GOTCHA: claude_rules uses file{} blocks only (no content field).
#         For Copilot, unroll each file into a separate copilot_instruction.
# See python-dev/package.hcl for the canonical example.
# -----------------------------------------------------------------------------
# claude_rules "my-standards" {
#   description = "Collection of development standards"
#
#   file {
#     src  = "rules/style.md"
#     dest = "style.md"
#   }
#
#   file {
#     src  = "rules/testing.md"
#     dest = "testing.md"
#   }
# }
#
# # Copilot: unroll each file into a separate instruction
# copilot_instruction "style" {
#   description = "Style standards"
#   content     = file("rules/style.md")
# }
#
# copilot_instruction "testing" {
#   description = "Testing standards"
#   content     = file("rules/testing.md")
# }

# -----------------------------------------------------------------------------
# Subagent — autonomous agent with a specific role
# -----------------------------------------------------------------------------
# claude_subagent "my-agent" {
#   description = "Specialized agent for X"
#   content     = file("agents/my-agent.md")
# }
#
# copilot_agent "my-agent" {
#   description = "Specialized agent for X"
#   content     = file("agents/my-agent.md")
# }

# -----------------------------------------------------------------------------
# Command — user-invocable slash command (Claude Code only)
# GOTCHA: claude_command has no direct Copilot equivalent.
#         Use copilot_agent as an alternative, or omit.
# -----------------------------------------------------------------------------
# claude_command "my-command" {
#   description = "Start some workflow"
#   content     = file("commands/my-command.md")
# }
#
# # Copilot alternative (agent, not command):
# copilot_agent "my-command" {
#   description = "Start some workflow"
#   content     = file("commands/my-command.md")
# }

# -----------------------------------------------------------------------------
# MCP Server — external tool integration
# GOTCHA: Use \$\${VAR} (double dollar) for environment variables.
#         Single \${VAR} is interpreted by HCL as interpolation and will error.
# See github-workflows/package.hcl for env var example.
# See docker-compose/package.hcl for simple example.
# -----------------------------------------------------------------------------
# mcp_server "my-server" {
#   description = "My MCP server"
#   command     = "npx"
#   args        = ["-y", "some-mcp-server@latest"]
#
#   # Environment variables — note the \$\${} escaping
#   env = {
#     API_TOKEN = "\$\${API_TOKEN}"
#   }
# }

# -----------------------------------------------------------------------------
# Settings — MCP tool permissions (Claude Code only, no Copilot equivalent)
# Convention: name it "mcp-permissions".
# Wildcards: "mcp__<server-name>__*" allows all tools from that server.
# -----------------------------------------------------------------------------
# claude_settings "mcp-permissions" {
#   allow = [
#     "mcp__my-server__*"
#   ]
# }

# -----------------------------------------------------------------------------
# Top-level file — deploy files to the consumer's workspace
# Commonly used for task automation (.runbook/) files.
# See typescript/package.hcl for example.
# -----------------------------------------------------------------------------
# file "tasks" {
#   src  = "tasks.yaml"
#   dest = ".runbook/$PACKAGE_NAME.yaml"
# }

# =============================================================================
# Cross-platform mapping reference:
#
#   Claude Code            | GitHub Copilot
#   -----------------------|---------------------------
#   claude_skill           | copilot_skill
#   claude_rule            | copilot_instruction
#   claude_rules (files)   | Multiple copilot_instruction (unrolled)
#   claude_subagent        | copilot_agent
#   claude_command          | copilot_agent (or omit)
#   claude_settings        | No equivalent (Claude-only)
#   mcp_server             | Shared (same block)
#   file                   | Shared (same block)
# =============================================================================
HCL_EOF

echo ""
echo "Package scaffolded at: $PACKAGE_NAME/"
echo ""
echo "Directory structure:"
echo "  $PACKAGE_NAME/"
echo "  ├── package.hcl            # Annotated skeleton — uncomment what you need"
echo "  ├── skills/"
echo "  │   └── example-skill/"
echo "  │       ├── SKILL.md       # Placeholder skill"
echo "  │       └── resources/"
echo "  ├── agents/"
echo "  ├── commands/"
echo "  └── rules/"
echo ""
echo "Next steps:"
echo "  1. Edit $PACKAGE_NAME/package.hcl — uncomment and fill in the blocks you need"
echo "  2. Write your skill/rule/agent content in the appropriate directories"
echo "  3. Run ./scripts/package.sh to test packaging"
echo "  4. Run ./deploy.sh to build and publish"
echo ""
echo "See CONTRIBUTING.md for the full package authoring guide."
