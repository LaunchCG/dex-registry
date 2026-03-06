# Contributing to nexus-registry

## Quick Start

```bash
# 1. Scaffold a new package
./scripts/new-package.sh my-package

# 2. Edit package.hcl — uncomment what you need, add content files
cd my-package && $EDITOR package.hcl

# 3. Test packaging
./scripts/package.sh

# 4. Deploy to registry
./deploy.sh
```

The scaffold script generates an annotated `package.hcl` with commented examples of every block type. Start there.

## Package Structure

```
my-package/
├── package.hcl            # Required: package manifest
├── skills/                # Skill definitions
│   └── my-skill/
│       ├── SKILL.md       # Skill content (required per skill)
│       └── resources/     # Templates, examples, reference docs (optional)
├── agents/                # Agent/subagent definitions (.md)
├── commands/              # Command definitions (.md) — Claude Code only
├── rules/                 # Rule definitions (.md)
└── tasks.yaml             # Optional: MCP task automation
```

**Convention:** directory name = package name = `name` field in package.hcl.

## HCL Block Types

Run `./scripts/new-package.sh my-package` — the generated `package.hcl` contains
annotated examples of every block type with inline documentation of fields and gotchas.

For real-world usage of each block type, see these existing packages:

| Block | Example Package |
|---|---|
| `package`, `claude_rule` (inline + file) | `base-dev` |
| `dependency` (multiple) | `sdlc-reviewer` |
| `claude_skill` + nested `file` | `code-review` |
| `claude_rules` (plural, file-only) | `python-dev` |
| `claude_subagent` | `base-dev` |
| `claude_command` | `sdlc-code` |
| `mcp_server` + `$${}` env escaping | `github-workflows` |
| `claude_settings` | `telemetry-mcp` |
| Top-level `file` | `typescript` |

## Cross-Platform Parity

Every `claude_*` block needs a `copilot_*` mirror. The mapping:

| Claude Code         | GitHub Copilot                         |
|---------------------|----------------------------------------|
| `claude_skill`      | `copilot_skill`                        |
| `claude_rule`       | `copilot_instruction`                  |
| `claude_rules`      | Multiple `copilot_instruction` (unrolled) |
| `claude_subagent`   | `copilot_agent`                        |
| `claude_command`    | `copilot_agent` (or omit)             |
| `claude_settings`   | No equivalent (Claude-only)           |
| `mcp_server`        | Shared                                 |
| `file`              | Shared                                 |

See `python-dev/package.hcl` for the canonical example of `claude_rules` to `copilot_instruction` unrolling.

## Testing & Deployment

1. **Validate** — `./scripts/package.sh` builds all packages and catches HCL errors
2. **Inspect** — `tar tzf` the generated archive to verify contents
3. **Deploy** — `./deploy.sh` publishes to the Azure Blob Storage registry
4. **Versioning** — Use semver. Bump `version` in package.hcl. The registry preserves old versions.

## Submitting Changes

1. Create a feature branch from `main`
2. Make your changes and test with `./scripts/package.sh`
3. Open a PR — CI auto-deploys on merge to `main`

For migrating existing Claude Code plugins to dex format, see [docs/plugin-migration.md](docs/plugin-migration.md).
