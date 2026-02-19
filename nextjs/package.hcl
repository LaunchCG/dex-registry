package {
  name        = "nextjs"
  version     = "0.2.1"
  description = "Next.js 16+ App Router expert: Server/Client Components, Server Actions, API routes, middleware, authentication, and data fetching patterns"
  platforms   = ["claude-code", "github-copilot"]
}

dependency "typescript" {
  version = ">=0.1.0"
}

# Rules files for consistent conventions
file "nextjs-conventions" {
  src  = "rules/nextjs-conventions.md"
  dest = "CLAUDE.md"
}

file "nextjs-testing" {
  src  = "rules/nextjs-testing.md"
  dest = "CLAUDE.md"
}

claude_skill "nextjs" {
  description = "Expert in Next.js 16+ App Router patterns, Server/Client Components, Server Actions, API routes, middleware, authentication, and data fetching. Use when implementing Next.js features, routing, or server-side logic."
  content     = file("skills/nextjs/SKILL.md")
}

file "tasks" {
  src  = "tasks.yaml"
  dest = ".runbook/nextjs.yaml"
}

mcp_server "runbook" {
  description = "Runbook task automation (https://runbookmcp.dev)"
  command     = "runbook"
}

claude_rule "nextjs-tasks-rule" {
  description = "Enforce MCP usage"
  content = "You must use the runbook MCP tools for all Next.js operations including dev server, building, linting, type checking, testing, and database operations. Never run next, vitest, playwright, or prisma commands directly via Bash."
}

claude_settings "mcp-permissions" {
  allow = [
    "mcp__runbook__*"
  ]
}

# GitHub Copilot Resources

copilot_skill "nextjs" {
  description = "Expert in Next.js 16+ App Router patterns, Server/Client Components, Server Actions, API routes, middleware, authentication, and data fetching. Use when implementing Next.js features, routing, or server-side logic."
  content     = file("skills/nextjs/SKILL.md")
}
