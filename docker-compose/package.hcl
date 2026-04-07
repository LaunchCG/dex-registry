meta {
  name        = "docker-compose"
  version     = "1.0.0"
  description = "Docker Compose skill with MCP task automation"
  platforms   = ["claude-code", "github-copilot"]
}

skill "docker-compose" {
  description = "Docker Compose configuration and multi-container orchestration"
  content     = file("skills/docker-compose/SKILL.md")
}

rule "docker-compose-rule" {
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

settings "mcp-permissions" {
  claude {
    allow = [
      "mcp__runbook__*"
    ]
  }
}
