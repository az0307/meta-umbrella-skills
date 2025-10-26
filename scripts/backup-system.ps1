# Backup System
Write-Host 'Creating backup...'
$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$backupDir = '$env:USERPROFILE\.claude\skills\meta-umbrella-skills\backups\backup-' + $timestamp
New-Item -ItemType Directory -Path $backupDir -Force
Copy-Item '$env:USERPROFILE\.claude\skills\meta-umbrella-skills\*' -Destination $backupDir -Recurse -Exclude 'backups','node_modules'
Write-Host 'Backup complete'
