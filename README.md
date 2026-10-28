# Meta Umbrella Skills

A library of **42 Markdown "skill" prompts** plus two orchestrator prompts for Claude Desktop, with
PowerShell scripts that install them into `~/.claude/skills/meta-umbrella-skills` and add MCP servers
to the Claude Desktop config.

## Layout

| Path | Purpose |
|------|---------|
| `skills/meta-orchestrator.md`, `skills/omni-meta-orchestrator.md` | Router prompts that pick a skill for a task |
| `skills/{compliance,creative,development,operations,research}/` | 40 role skills (4 / 5 / 10 / 13 / 8) |
| `agent.md` | Orchestrator agent profile |
| `config/claude_desktop_config.json` | Example Claude Desktop MCP config |
| `scripts/deployment/deploy-all.ps1` | Installer: backs up and writes the Claude Desktop config, counts skills |
| `scripts/{advanced-test,backup-system,monitor}.ps1`, `health-check.ps1`, `autonomous-systems/diagnostics.ps1` | Test, backup, monitoring helpers (Windows) |
| `setup_generator.py`, `create_files.py` | Generators used to scaffold the repo |
| `backups/backup-20251025_062353/` | Old snapshot of the docs/skills — not used at runtime |
| `QUICK_START.md`, `INSTALLATION_TOOLS.md`, `NEXT_STEPS.txt`, `CHANGELOG.md`, `CONTRIBUTING.md`, `SECURITY.md` | Guides |

## Quick start (Windows / PowerShell)

1. Clone into `%USERPROFILE%\.claude\skills\meta-umbrella-skills`.
2. `Copy-Item .env.example .env` and fill in the tokens you use (GitHub PAT, optional Postgres/Slack). Never commit `.env`.
3. Run `.\scripts\deployment\deploy-all.ps1` (backs up your existing Claude Desktop config first).
4. Fully quit and reopen Claude Desktop.

See `QUICK_START.md` for the detailed walkthrough.

## Known issues

- `Taskfile.yml` is mis-indented (tasks parse as empty) and references `scripts/skill-testing.ps1` and
  `scripts/quick-enhancement.ps1`, which don't exist. Use the scripts above directly until it's fixed.
- `package.json` is metadata only (no scripts or dependencies).
