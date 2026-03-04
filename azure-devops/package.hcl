package {
  name        = "azure-devops"
  version     = "0.1.1"
  description = "Azure DevOps integration using Microsoft's official MCP server for work item management, boards, and sprint tracking"
  platforms   = ["claude-code", "github-copilot"]
}

mcp_server "azure-devops" {
  description = "Microsoft Azure DevOps MCP server for work items, boards, sprints, and pipelines"
  command     = "npx"
  args        = ["-y", "@azure-devops/mcp", "$${AZURE_DEVOPS_ORG}"]
}

claude_settings "mcp-permissions" {
  allow = [
    "mcp__azure-devops__*"
  ]
}
