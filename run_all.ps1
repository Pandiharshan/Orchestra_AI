# OrchestraAI - Full Multi-Agent System Runner
Write-Host "🎼 OrchestraAI: Multi-Agent Orchestration" -ForegroundColor Cyan
Write-Host "-------------------------------------------"

# Launch Backend in a new window
Write-Host "🚀 Launching Backend in a new window..."
Start-Process powershell -ArgumentList "-NoExit -Command .\run_backend.ps1"

# Launch Frontend in a new window
Write-Host "🎨 Launching Frontend in a new window..."
Start-Process powershell -ArgumentList "-NoExit -Command .\run_frontend.ps1"

Write-Host "✅ Both services are starting. Please check the new terminal windows." -ForegroundColor Green
