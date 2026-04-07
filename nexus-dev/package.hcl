meta {
  name        = "nexus-dev"
  version     = "1.0.0"
  description = "Core Nexus AI-SDLC methodology with Definition of Ready, Definition of Done, TDD workflow, documentation assessment, and security scanning"
  platforms   = ["claude-code", "github-copilot"]
}

dependency "base-dev" {
  version = ">=1.0.0"
}

skill "nexus-methodology" {
  description = "Launch Consulting Nexus AI-SDLC methodology - Director/Verifier model with DoR, TDD, and DoD quality gates"
  content     = file("skills/nexus-methodology/SKILL.md")
}

skill "dor-validation" {
  description = "Validates work items meet Definition of Ready criteria before sprint planning or development"
  content     = file("skills/dor-validation/SKILL.md")
}

skill "dod-validation" {
  description = "Validates work meets Definition of Done before merge to ensure quality and completeness"
  content     = file("skills/dod-validation/SKILL.md")
}

skill "doc-assessment" {
  description = "Assesses documentation completeness and quality for code changes and features"
  content     = file("skills/doc-assessment/SKILL.md")
}

skill "security-scan" {
  description = "Scans for security vulnerabilities in code changes and dependencies before deployment"
  content     = file("skills/security-scan/SKILL.md")
}
