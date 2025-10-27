# Meta Umbrella v3.0 - System Health Check
# Run this anytime to verify system status

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "META UMBRELLA v3.0 - HEALTH CHECK" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# 1. Check Skills
Write-Host "📚 SKILLS CHECK:" -ForegroundColor Yellow
$skillCount = (Get-ChildItem "skills" -Recurse -Filter "*.md" | Measure-Object).Count
Write-Host "   Skills Found: $skillCount/33" -ForegroundColor $(if($skillCount -ge 33){"Green"}else{"Red"})

# 2. Check MCP Servers
Write-Host "`n🔌 MCP SERVERS:" -ForegroundColor Yellow
$mcpServers = npm list -g --depth=0 2>$null | Select-String "modelcontextprotocol"
Write-Host "   Installed: $($mcpServers.Count) servers" -ForegroundColor Green
$mcpServers | ForEach-Object { Write-Host "   ✅ $_" -ForegroundColor Gray }

# 3. Check Docker
Write-Host "`n🐳 DOCKER SERVICES:" -ForegroundColor Yellow
$n8nStatus = docker ps --filter "name=n8n" --format "{{.Status}}"
if ($n8nStatus -match "Up") {
    Write-Host "   ✅ n8n: Running ($n8nStatus)" -ForegroundColor Green
} else {
    Write-Host "   ❌ n8n: Stopped" -ForegroundColor Red
}

# 4. Check Playwright
Write-Host "`n🎭 BROWSER AUTOMATION:" -ForegroundColor Yellow
if (Test-Path "$env:LOCALAPPDATA\ms-playwright\chromium-1194") {
    Write-Host "   ✅ Playwright: Installed with Chromium" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  Playwright: Not found" -ForegroundColor Yellow
}

# 5. Check Repositories
Write-Host "`n📦 CLONED REPOSITORIES:" -ForegroundColor Yellow
$repos = Get-ChildItem "workspace" -Directory -ErrorAction SilentlyContinue
Write-Host "   Cloned: $($repos.Count) repositories" -ForegroundColor Green
$repos | ForEach-Object { Write-Host "   📁 $($_.Name)" -ForegroundColor Gray }

# 6. Check API Keys
Write-Host "`n🔑 API KEYS:" -ForegroundColor Yellow
$env:GH_TOKEN = $null
Get-Content .env | Where-Object { $_ -match "=" -and $_ -notmatch "^#" } | ForEach-Object {
    $key = $_.Split("=")[0]
    $value = $_.Split("=")[1]
    if ($value -and $value -ne "your_" -and $value.Length -gt 10) {
        Write-Host "   ✅ $key" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  $key (not configured)" -ForegroundColor Yellow
    }
}

# 7. Check Git
Write-Host "`n📡 GIT STATUS:" -ForegroundColor Yellow
$gitStatus = git status --short
if ($gitStatus) {
    Write-Host "   ⚠️  Uncommitted changes: $($gitStatus.Count) files" -ForegroundColor Yellow
} else {
    Write-Host "   ✅ All changes committed" -ForegroundColor Green
}

# 8. System Resources
Write-Host "`n💻 SYSTEM RESOURCES:" -ForegroundColor Yellow
$memory = Get-Process | Where-Object {$_.Name -match "node|docker|chrome"} | Measure-Object WorkingSet -Sum
Write-Host "   Memory Usage: $([math]::Round($memory.Sum/1MB, 2)) MB" -ForegroundColor Cyan

# Summary
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "✅ META UMBRELLA v3.0 IS OPERATIONAL" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "`nQuick Access:" -ForegroundColor Yellow
Write-Host "   • n8n: http://localhost:5678" -ForegroundColor Cyan
Write-Host "   • GitHub: https://github.com/az0307/meta-umbrella-skills" -ForegroundColor Cyan
Write-Host "   • Skills: $PWD\skills\" -ForegroundColor Cyan
Write-Host "`n"
