# Autonomous Self-Diagnostics System
# Monitors health, detects issues, and auto-repairs

function Test-SystemHealth {
    Write-Host "🏥 Running system diagnostics..." -ForegroundColor Cyan
    
    $results = @{
        MCPs = Test-MCPHealth
        Skills = Test-SkillValidity  
        APIs = Test-APIConnectivity
        Storage = Test-StorageCapacity
        Performance = Test-SystemPerformance
    }
    
    $score = ($results.Values | Measure-Object -Average).Average
    
    Write-Host "`n📊 Health Score: $([math]::Round($score * 100))%" -ForegroundColor $(if ($score -gt 0.8) { "Green" } else { "Yellow" })
    
    if ($score -lt 0.8) {
        Write-Host "⚠️  System health below threshold, initiating auto-repair..." -ForegroundColor Yellow
        Invoke-AutoRepair -Results $results
    }
    
    return $results
}

function Test-MCPHealth {
    $mcps = @("filesystem", "github", "memory", "brave-search", "postgres", "slack")
    $healthy = 0
    
    Write-Host "`n🔌 Testing MCP servers..." -ForegroundColor Gray
    
    foreach ($mcp in $mcps) {
        try {
            $test = npm list -g "@modelcontextprotocol/server-$mcp" 2>&1
            if ($LASTEXITCODE -eq 0) { 
                $healthy++
                Write-Host "  ✅ $mcp" -ForegroundColor Green
            } else {
                Write-Host "  ❌ $mcp (not installed)" -ForegroundColor Red
            }
        } catch {
            Write-Host "  ❌ $mcp (error)" -ForegroundColor Red
        }
    }
    
    return $healthy / $mcps.Count
}

function Test-SkillValidity {
    Write-Host "`n📚 Validating skills..." -ForegroundColor Gray
    
    $skills = Get-ChildItem -Path "skills" -Filter "*.md" -Recurse
    $valid = 0
    
    foreach ($skill in $skills) {
        $content = Get-Content $skill.FullName -Raw
        
        $hasRequired = $content -match "## Purpose" -and 
                      $content -match "## Capabilities" -and
                      $content -match "## Process"
        
        if ($hasRequired) {
            $valid++
        }
    }
    
    Write-Host "  ✅ $valid/$($skills.Count) skills valid" -ForegroundColor Green
    
    return if ($skills.Count -gt 0) { $valid / $skills.Count } else { 0 }
}

function Test-APIConnectivity {
    Write-Host "`n🌐 Testing API connectivity..." -ForegroundColor Gray
    
    $tests = 0
    $passed = 0
    
    # Test Brave Search
    if ($env:BRAVE_API_KEY) {
        $tests++
        try {
            $response = Invoke-WebRequest -Uri "https://api.search.brave.com/res/v1/web/search?q=test" `
                -Headers @{ "X-Subscription-Token" = $env:BRAVE_API_KEY } `
                -TimeoutSec 5 -ErrorAction Stop
            if ($response.StatusCode -eq 200) {
                $passed++
                Write-Host "  ✅ Brave Search API" -ForegroundColor Green
            }
        } catch {
            Write-Host "  ❌ Brave Search API" -ForegroundColor Red
        }
    }
    
    # Test GitHub
    if ($env:GITHUB_PERSONAL_ACCESS_TOKEN) {
        $tests++
        try {
            $response = Invoke-WebRequest -Uri "https://api.github.com/user" `
                -Headers @{ "Authorization" = "token $env:GITHUB_PERSONAL_ACCESS_TOKEN" } `
                -TimeoutSec 5 -ErrorAction Stop
            if ($response.StatusCode -eq 200) {
                $passed++
                Write-Host "  ✅ GitHub API" -ForegroundColor Green
            }
        } catch {
            Write-Host "  ❌ GitHub API" -ForegroundColor Red
        }
    }
    
    return if ($tests -gt 0) { $passed / $tests } else { 0.5 }
}

function Test-StorageCapacity {
    Write-Host "`n💾 Checking storage..." -ForegroundColor Gray
    
    $drive = Get-PSDrive -Name (Split-Path $PSScriptRoot -Qualifier).TrimEnd(':')
    $freeSpaceGB = [math]::Round($drive.Free / 1GB, 2)
    $usedPercent = [math]::Round((1 - ($drive.Free / ($drive.Used + $drive.Free))) * 100, 2)
    
    Write-Host "  Free space: $freeSpaceGB GB ($usedPercent% used)" -ForegroundColor Cyan
    
    if ($freeSpaceGB -lt 1) {
        return 0.5
    } elseif ($freeSpaceGB -lt 5) {
        return 0.8
    } else {
        return 1.0
    }
}

function Test-SystemPerformance {
    Write-Host "`n⚡ Checking performance..." -ForegroundColor Gray
    
    $cpu = Get-Counter '\Processor(_Total)\% Processor Time' | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue
    $memory = Get-Counter '\Memory\% Committed Bytes In Use' | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue
    
    Write-Host "  CPU: $([math]::Round($cpu, 2))%" -ForegroundColor Cyan
    Write-Host "  Memory: $([math]::Round($memory, 2))%" -ForegroundColor Cyan
    
    if ($cpu -gt 80 -or $memory -gt 80) {
        return 0.6
    } elseif ($cpu -gt 60 -or $memory -gt 60) {
        return 0.8
    } else {
        return 1.0
    }
}

function Invoke-AutoRepair {
    param($Results)
    
    Write-Host "`n🔧 Auto-repair initiated..." -ForegroundColor Yellow
    
    if ($Results.MCPs -lt 0.8) {
        Write-Host "  🔄 Reinstalling MCP servers..." -ForegroundColor Yellow
        $mcps = @("filesystem", "github", "memory", "brave-search")
        foreach ($mcp in $mcps) {
            npm install -g "@modelcontextprotocol/server-$mcp" 2>&1 | Out-Null
        }
    }
    
    if ($Results.Performance -lt 0.7) {
        Write-Host "  🧹 Clearing caches..." -ForegroundColor Yellow
        if (Test-Path "workspace/cache") {
            Remove-Item "workspace/cache/*" -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
    
    if ($Results.Storage -lt 0.7) {
        Write-Host "  📁 Cleaning old logs..." -ForegroundColor Yellow
        if (Test-Path "logs") {
            Get-ChildItem "logs" -Filter "*.log" | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-7) } | Remove-Item -Force
        }
    }
    
    Write-Host "  ✅ Auto-repair complete" -ForegroundColor Green
}

Export-ModuleMember -Function Test-SystemHealth, Invoke-AutoRepair
