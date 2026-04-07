meta {
  name        = "azure-devops"
  version     = "1.0.0"
  description = "Azure DevOps integration using Microsoft's official MCP server for work item management, boards, and sprint tracking"
  platforms   = ["claude-code", "github-copilot"]
}

mcp_server "azure-devops" {
  description = "Microsoft Azure DevOps MCP server for work items, boards, sprints, and pipelines"
  command     = "npx"
  args        = ["-y", "@azure-devops/mcp", "$${AZURE_DEVOPS_ORG}"]
}

settings "mcp-permissions" {
  claude {
    allow = [
      "mcp__azure-devops__*"
    ]
  }
}
