$projectDir = "$env:USERPROFILE\.claude\skills\wechat-claude-code"
Set-Location $projectDir
Write-Host "Starting wechat-claude-code daemon..." -ForegroundColor Green
Write-Host "Press Ctrl+C to stop." -ForegroundColor Yellow
Write-Host ""
node dist/main.js
