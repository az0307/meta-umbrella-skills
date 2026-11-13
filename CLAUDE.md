# CLAUDE.md

Guidance for Claude Code in this repository.

## What this is

A prompt library, not an application: 42 Markdown skill files under `skills/` (two orchestrators at the
top level, 40 role skills in `compliance/`, `creative/`, `development/`, `operations/`, `research/`),
plus Windows PowerShell scripts that install them for Claude Desktop. The shipped
`config/claude_desktop_config.json` registers only the filesystem MCP server; `agent.md` lists the
other MCPs it expects (GitHub, Memory, Brave Search, Postgres) — add them yourself.

There is no build, no test suite, and no CI. `package.json` has no scripts.

## Conventions for skill files

- One skill per file, kebab-case filename, `# Title` then a one-line purpose and a `Capabilities:` line.
- Put new skills in the matching category folder and mention them in `skills/meta-orchestrator.md` /
  `skills/omni-meta-orchestrator.md` so the router can pick them.
- Don't edit `backups/` — it's a frozen 2025-10-25 snapshot.

## Scripts

- `scripts/deployment/deploy-all.ps1` — installer; writes `%APPDATA%\Claude\claude_desktop_config.json`
  after backing it up. Assumes the repo lives at `~/.claude/skills/meta-umbrella-skills`.
- `Taskfile.yml` is currently broken (bad indentation; points at missing `skill-testing.ps1` /
  `quick-enhancement.ps1`). Fix both before relying on `task test`.

## Secrets (important — this repo is public)

- `.env.example` lists names only (`GITHUB_PERSONAL_ACCESS_TOKEN`, `POSTGRES_CONNECTION_STRING`,
  `SLACK_BOT_TOKEN`, …). Never commit `.env`, tokens, or archives of the working directory.
- This repo is **public**: treat anything committed (including history) as published.
  Open draft PR #4 (secrets hygiene) is pending Aaron's review.
- Keep `config/claude_desktop_config.json` free of real keys — use env var references.
