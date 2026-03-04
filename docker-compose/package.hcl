package {
  name        = "docker-compose"
  version     = "0.2.2"
  description = "Docker Compose skill with MCP task automation"
  platforms   = ["claude-code", "github-copilot"]
}

claude_skill "docker-compose" {
  description = "Docker Compose configuration and multi-container orchestration"
  content     = file("skills/docker-compose/SKILL.md")
}

claude_rule "docker-compose-rule" {
  description = "Enforce MCP usage"
  content = "You must use the runbook MCP tools for all docker compose operations. Never run docker compose commands directly via Bash."
}

file "tasks" {
  src  = "tasks.yaml"
  dest = ".runbook/docker-compose.yaml"
}

mcp_server "runbook" {
  description = "Runbook task automation (https://runbookmcp.dev)"
  command     = "runbook"
}

claude_settings "mcp-permissions" {
  allow = [
    "mcp__runbook__*"
  ]
}

# GitHub Copilot Resources

copilot_skill "docker-compose" {
  description = "Docker Compose configuration and multi-container orchestration"
  content     = file("skills/docker-compose/SKILL.md")
}
