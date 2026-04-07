meta {
  name        = "nextjs"
  version     = "1.0.0"
  description = "Next.js 16+ App Router expert: Server/Client Components, Server Actions, API routes, middleware, authentication, and data fetching patterns"
  platforms   = ["claude-code", "github-copilot"]
}

dependency "typescript" {
  version = ">=1.0.0"
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

skill "nextjs" {
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

rule "nextjs-tasks-rule" {
  description = "Enforce MCP usage"
  content = "You must use the runbook MCP tools for all Next.js operations including dev server, building, linting, type checking, testing, and database operations. Never run next, vitest, playwright, or prisma commands directly via Bash."
}

settings "mcp-permissions" {
  claude {
    allow = [
      "mcp__runbook__*"
    ]
  }
}
