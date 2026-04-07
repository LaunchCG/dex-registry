meta {
  name        = "frontend-qa"
  version     = "1.0.0"
  description = "Comprehensive QA toolkit with adversarial testing mindset, Playwright E2E testing, TDD enforcement, and exploratory testing techniques"
  platforms   = ["claude-code", "github-copilot"]
}

dependency "base-dev" {
  version = ">=1.0.0"
}

# QA mindset skill - adversarial testing approach
skill "qa-mindset" {
  description = "Adopt the adversarial mindset of a professional QA tester - break things, find edge cases, and thoroughly test every interaction"
  content     = file("skills/qa-mindset.md")
}

# Playwright testing skill
skill "playwright-testing" {
  description = "Expert in Playwright E2E testing with focus on best practices and test reliability"
  content     = file("skills/playwright-testing.md")
}

# TDD enforcement rule
rule "test-driven-development" {
  description = "Mandatory TDD workflow - tests must be written before implementation"
  content     = file("rules/test-driven-development.md")
}

# QA agent for E2E testing
agent "frontend-qa" {
  description = "E2E testing specialist with Playwright expertise"
  content     = file("agents/frontend-qa.md")
}

# Test command
command "test" {
  description = "Run Playwright E2E tests"
  content     = file("commands/test.md")
}
