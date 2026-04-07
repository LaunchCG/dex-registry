meta {
  name        = "tailwind-css"
  version     = "1.0.0"
  description = "Comprehensive Tailwind CSS toolkit with Material Design 3 patterns, design tokens, dark mode support, and testing standards"
  platforms   = ["claude-code", "github-copilot"]
}

skill "tailwind-css" {
  description = "Expert guidance for Tailwind CSS v4 with Material Design 3, design tokens, dark mode, and responsive patterns"
  content     = file("skills/tailwind-css/SKILL.md")
}

rules "tailwind" {
  description = "Tailwind CSS standards: design tokens, component patterns, and testing requirements"

  file {
    src  = "rules/tailwind-classes.md"
    dest = "tailwind-classes.md"
  }

  file {
    src  = "rules/tailwind-components.md"
    dest = "tailwind-components.md"
  }

  file {
    src  = "rules/tailwind-testing.md"
    dest = "tailwind-testing.md"
  }
}
