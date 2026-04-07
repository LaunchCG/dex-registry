meta {
  name        = "python-dev"
  version     = "1.0.0"
  description = "Python development toolkit with style guidelines, type hints, testing patterns, and code quality standards"
  platforms   = ["claude-code", "github-copilot"]
}

skill "python-style" {
  description = "Expert guidance for Python code style, PEP 8, type hints, and formatting with Ruff"
  content     = file("skills/python-style/SKILL.md")
}

skill "python-testing" {
  description = "Expert guidance for Python testing with pytest, fixtures, mocking, and test organization"
  content     = file("skills/python-testing/SKILL.md")
}

rules "python" {
  description = "Python development standards: code style, formatting, and testing requirements"

  file {
    src  = "rules/python-style.md"
    dest = "python-style.md"
  }

  file {
    src  = "rules/python-formatting.md"
    dest = "python-formatting.md"
  }

  file {
    src  = "rules/python-testing.md"
    dest = "python-testing.md"
  }
}

agent "python-tester" {
  description = "Specialized agent for Python testing, debugging, and test automation"
  content     = file("agents/python-tester.md")
}

# Task automation via MCP
file "tasks" {
  src  = "tasks.yaml"
  dest = ".runbook/python-dev.yaml"
}

mcp_server "runbook" {
  description = "Runbook task automation (https://runbookmcp.dev)"
  command     = "runbook"
}

rule "python-tasks-rule" {
  description = "Enforce MCP usage"
  content = "You must use the runbook MCP tools for all Python linting, formatting, and type checking operations. Never run ruff, mypy, black, or isort commands directly via Bash."
}

settings "mcp-permissions" {
  claude {
    allow = [
      "mcp__runbook__*"
    ]
  }
}
