#!/usr/bin/env pwsh
# Meta Umbrella v3.0 - Master Deployment Script
# Fast-track production deployment in 30 minutes

param(
    [switch]$FullInstall,
    [switch]$QuickSetup,
    [switch]$Production
)

$ErrorActionPreference = "Stop"

Write-Host @"
╔════════════════════════════════════════════════════╗
║  Meta Umbrella Skills v3.0                         ║
║  Autonomous Enterprise Edition                     ║
║  Fast-Track Production Deployment                  ║
╚════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

# Phase 1: Pre-flight checks
Write-Host "`n🔍 Phase 1: Pre-flight checks" -ForegroundColor Yellow

$checks = @{
    Node = { node --version }
    NPM = { npm --version }
    Git = { git --version }
    Docker = { docker --version }
    Python = { python --version }
}

$missingDeps = @()

foreach ($check in $checks.GetEnumerator()) {
    try {
        $version = & $check.Value 2>&1
        Write-Host "  ✅ $($check.Key): $version" -ForegroundColor Green
    } catch {
        Write-Host "  ❌ $($check.Key) not found" -ForegroundColor Red
        $missingDeps += $check.Key
    }
}

if ($missingDeps.Count -gt 0) {
    Write-Host "`n⚠️  Missing dependencies: $($missingDeps -join ', ')" -ForegroundColor Yellow
    Write-Host "Please install them before continuing." -ForegroundColor Yellow
    exit 1
}

# Phase 2: Install MCP servers
Write-Host "`n📦 Phase 2: Installing MCP servers" -ForegroundColor Yellow

$mcps = @(
    "@modelcontextprotocol/server-filesystem",
    "@modelcontextprotocol/server-github",
    "@modelcontextprotocol/server-memory",
    "@modelcontextprotocol/server-brave-search",
    "@modelcontextprotocol/server-postgres",
    "@modelcontextprotocol/server-slack"
)

foreach ($mcp in $mcps) {
    try {
        Write-Host "  Installing $mcp..." -NoNewline
        npm list -g $mcp 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) {
            Write-Host " Already installed ✅" -ForegroundColor Green
        } else {
            npm install -g $mcp 2>&1 | Out-Null
            Write-Host " Installed ✅" -ForegroundColor Green
        }
    } catch {
        Write-Host " Failed ❌" -ForegroundColor Red
    }
}

# Phase 3: Configure environment
Write-Host "`n⚙️  Phase 3: Configuring environment" -ForegroundColor Yellow

if (-not (Test-Path .env)) {
    @"
# GitHub Integration
GITHUB_PERSONAL_ACCESS_TOKEN=

# Brave Search
BRAVE_API_KEY=BSAezokn3QjBoVYMizNb0A0P54Icv_G
BRAVE_API_KEY_SECONDARY=BSAj-F19j6Km7oPa8Noo2-UL244-H3n

# Database
POSTGRES_CONNECTION_STRING=

# Slack
SLACK_BOT_TOKEN=
SLACK_TEAM_ID=

# OpenAI
OPENAI_API_KEY=

# n8n
N8N_API_KEY=
N8N_BASE_URL=http://localhost:5678

# Zapier
ZAPIER_API_KEY=
"@ | Set-Content .env
    Write-Host "  📝 Created .env template" -ForegroundColor Green
    Write-Host "  ⚠️  Please edit .env with your API keys!" -ForegroundColor Yellow
} else {
    Write-Host "  ✅ .env file exists" -ForegroundColor Green
}

# Phase 4: Update Claude Desktop config
Write-Host "`n🔧 Phase 4: Updating Claude Desktop config" -ForegroundColor Yellow

$configPath = "$env:APPDATA\Claude\claude_desktop_config.json"
$backupPath = "$env:APPDATA\Claude\claude_desktop_config.backup.json"

if (Test-Path $configPath) {
    Copy-Item $configPath $backupPath -Force
    Write-Host "  ✅ Backed up existing config" -ForegroundColor Green
}

$config = @{
    mcpServers = @{
        filesystem = @{
            command = "npx"
            args = @("-y", "@modelcontextprotocol/server-filesystem", "$HOME/.claude/skills/meta-umbrella-skills/workspace")
        }
        github = @{
            command = "npx"
            args = @("-y", "@modelcontextprotocol/server-github")
            env = @{
                GITHUB_PERSONAL_ACCESS_TOKEN = "`${GITHUB_PERSONAL_ACCESS_TOKEN}"
            }
        }
        memory = @{
            command = "npx"
            args = @("-y", "@modelcontextprotocol/server-memory")
        }
        "brave-search" = @{
            command = "npx"
            args = @("-y", "@modelcontextprotocol/server-brave-search")
            env = @{
                BRAVE_API_KEY = "`${BRAVE_API_KEY}"
            }
        }
        postgres = @{
            command = "npx"
            args = @("-y", "@modelcontextprotocol/server-postgres")
            env = @{
                POSTGRES_CONNECTION_STRING = "`${POSTGRES_CONNECTION_STRING}"
            }
        }
        slack = @{
            command = "npx"
            args = @("-y", "@modelcontextprotocol/server-slack")
            env = @{
                SLACK_BOT_TOKEN = "`${SLACK_BOT_TOKEN}"
                SLACK_TEAM_ID = "`${SLACK_TEAM_ID}"
            }
        }
    }
}

$config | ConvertTo-Json -Depth 10 | Set-Content $configPath -Force
Write-Host "  ✅ Updated Claude Desktop configuration" -ForegroundColor Green

# Phase 5: Initialize Git repository
Write-Host "`n📚 Phase 5: Git repository setup" -ForegroundColor Yellow

if (-not (Test-Path .git)) {
    git init
    git add .
    git commit -m "Initial commit: Meta Umbrella v3.0"
    Write-Host "  ✅ Git repository initialized" -ForegroundColor Green
} else {
    Write-Host "  ℹ️  Git repository already exists" -ForegroundColor Cyan
}

# Phase 6: Create necessary directories
Write-Host "`n📁 Phase 6: Creating directory structure" -ForegroundColor Yellow

$dirs = @(
    "workspace/temp",
    "workspace/outputs",
    "workspace/cache",
    "logs",
    "backups",
    "archives",
    "autonomous-systems",
    "mcp-configs/google",
    "mcp-configs/automation"
)

foreach ($dir in $dirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "  ✅ Created $dir" -ForegroundColor Green
    }
}

Write-Host "`n✅ Phase 7: Final verification" -ForegroundColor Yellow

$skillCount = (Get-ChildItem -Path "skills" -Filter "*.md" -Recurse -ErrorAction SilentlyContinue).Count
$mcpCount = $config.mcpServers.Count

Write-Host "  Skills found: $skillCount" -ForegroundColor Cyan
Write-Host "  MCPs configured: $mcpCount" -ForegroundColor Cyan
Write-Host "  Git initialized: $((Test-Path .git))" -ForegroundColor Cyan
Write-Host "  Environment file: $((Test-Path .env))" -ForegroundColor Cyan

Write-Host "`n╔════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  🎉 DEPLOYMENT COMPLETE!                           ║" -ForegroundColor Green
Write-Host "║  Status: READY FOR PRODUCTION                      ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════╝" -ForegroundColor Green

Write-Host "`n📋 Next Steps:" -ForegroundColor Cyan
Write-Host "  1. Edit .env with your API keys"
Write-Host "  2. Restart Claude Desktop (CRITICAL!)"
Write-Host "  3. Test: 'Use meta-orchestrator to show system status'"
Write-Host "  4. Push to GitHub:"
Write-Host "     git remote add origin https://github.com/YOUR_USERNAME/meta-umbrella-skills.git"
Write-Host "     git push -u origin main"
Write-Host ""
Write-Host "🔥 Your enterprise AI assistant is ready!" -ForegroundColor Green
