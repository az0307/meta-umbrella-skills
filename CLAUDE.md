# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Meta Umbrella Skills** is an intelligent, multi-layered **task-orchestration framework for Claude Desktop**. It defines a library of role-based "skills" (Markdown skill definitions) coordinated by a meta-orchestrator, plus the setup tooling to install them into Claude Desktop via MCP configuration.

The deliverables here are primarily **Markdown skill specs, configuration, and setup/maintenance scripts** — not a compiled application. `package.json` carries only metadata (no build).

## Structure

```
skills/                      # The skill library (Markdown skill definitions), grouped by domain:
├── meta-orchestrator.md     # top-level coordinator that routes work to skills
├── compliance/              # ethics-advisor, legal-reviewer, security-auditor
├── creative/                # brand-designer, content-writer, pdf-generator, ux-designer
├── development/             # code-architect, build-engineer, debug-specialist, deploy-manager,
│                            #   container-manager, database-administrator, git-operations-manager, web-automator
├── operations/              # automation-engineer, context-manager, documentation-specialist,
│                            #   project-manager, team-communicator
└── research/                # data-analyst, market-researcher, search-specialist,
                             #   technical-researcher, web-researcher-enhanced
config/claude_desktop_config.json   # MCP config to drop into Claude Desktop
agent.md                     # agent-guidance entry (AGENTS.md-style)
scripts/                     # PowerShell tooling: backup-system.ps1, advanced-test.ps1, ...
autonomous-systems/diagnostics.ps1
health-check.ps1
create_files.py / setup_generator.py   # generators for scaffolding skill files
Taskfile.yml                 # task runner targets
archives/ , backups/         # zipped + timestamped snapshots of the skill set (historical)
README.md, QUICK_START.md, CHANGELOG.md, CONTRIBUTING.md, SECURITY.md, INSTALLATION_TOOLS.md
```

## Quick Start (from README)

1. Copy `.env.example` → `.env` and add your API tokens.
2. Copy `config/claude_desktop_config.json` into your Claude Desktop config.
3. Restart Claude Desktop.

`Taskfile.yml` provides task-runner targets (run `task --list` if [Task](https://taskfile.dev) is installed). PowerShell scripts (`health-check.ps1`, `scripts/*.ps1`) handle diagnostics, testing, and backups.

## Working Conventions

- **Skills are Markdown.** To add a capability, create a new `skills/<domain>/<name>.md` following the structure of an existing skill in the same domain, and wire it into `skills/meta-orchestrator.md` so it is routable.
- **`backups/` and `archives/` are snapshots** — don't treat them as the live source. Edit the top-level `skills/`; a snapshot under `backups/backup-*/skills/` mirrors an earlier state and should not be hand-edited.
- Keep the domain grouping (compliance / creative / development / operations / research) consistent.
- Record changes in `CHANGELOG.md`; follow `CONTRIBUTING.md` and `SECURITY.md`.
- Never commit `.env` or real API tokens — only `.env.example`.

## Related Repos

- `meta-power-user-workflow` — companion power-user tips / AGENTS.md guidance.
- `meta-automation-hub` — n8n/VPS automation infrastructure.
