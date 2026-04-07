meta {
  name        = "github-workflows"
  version     = "1.0.0"
  description = "GitHub PR/issue automation and workflow management with MCP server"
  platforms   = ["claude-code", "github-copilot"]
}

dependency "base-dev" {
  version = ">=1.0.0"
}

dependency "sdlc-stories" {
  version = ">=1.0.0"
}

# GitHub MCP server (moved from base-dev@0.3.1)
mcp_server "github" {
  description = "GitHub MCP server for PR/issue management"
  command     = "npx"
  args        = ["-y", "@modelcontextprotocol/server-github"]

  env = {
    GITHUB_PERSONAL_ACCESS_TOKEN = "$${GITHUB_PERSONAL_ACCESS_TOKEN}"
  }
}

# GitHub MCP permissions (moved from base-dev@0.3.1)
settings "mcp-permissions" {
  claude {
    allow = [
      "mcp__github__*"
    ]
  }
}

# Skills for GitHub workflows
skill "pr-writing" {
  description = "Create high-quality pull requests with structured descriptions"
  content     = file("skills/pr-writing.md")
}

skill "github-operations" {
  description = "GitHub workflow automation and issue/PR management"
  content     = file("skills/github-operations.md")
}

skill "create-pr" {
  description = "Guide for creating pull requests via GitHub"
  content     = file("skills/create-pr.md")
}

skill "create-issue" {
  description = "Guide for creating GitHub issues"
  content     = file("skills/create-issue.md")
}

skill "work-on-issue" {
  description = "Comprehensive workflow for analyzing, planning, and implementing GitHub issues with plan mode"
  content     = file("skills/work-on-issue.md")
}

skill "my-issues" {
  description = "Guide for viewing assigned GitHub issues"
  content     = file("skills/my-issues.md")
}

# Rules for GitHub workflows
rule "github-prs" {
  description = "PR quality and workflow standards"
  content     = file("rules/github-prs.md")
}

rule "github-issues" {
  description = "Issue creation and management standards"
  content     = file("rules/github-issues.md")
}
