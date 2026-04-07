meta {
  name        = "vite"
  version     = "1.0.0"
  description = "Vite expert: lightning-fast dev server, HMR, production builds, framework integration, and modern build optimization"
  platforms   = ["claude-code", "github-copilot"]
}

dependency "typescript" {
  version = ">=1.0.0"
}

skill "vite" {
  description = "Expert in Vite development: native ES modules, HMR, Rollup-based builds, framework integration (React, Vue, Svelte), environment variables, and build optimization. Use when working with Vite projects or build tooling."
  content     = file("skills/vite/SKILL.md")
}

file "tasks" {
  src  = "tasks.yaml"
  dest = ".runbook/vite.yaml"
}

mcp_server "runbook" {
  description = "Runbook task automation (https://runbookmcp.dev)"
  command     = "runbook"
}

rule "vite-tasks-rule" {
  description = "Enforce MCP usage"
  content = "You must use the runbook MCP tools for all Vite operations including dev server, building, previewing, and type checking. Never run vite or tsc commands directly via Bash."
}

settings "mcp-permissions" {
  claude {
    allow = [
      "mcp__runbook__*"
    ]
  }
}
