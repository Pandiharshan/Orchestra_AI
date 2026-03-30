# OrchestraAI - Frontend Runner
Write-Host "🎨 Starting OrchestraAI Flutter Frontend..." -ForegroundColor Cyan

# Check if Flutter is installed
if (!(Get-Command flutter -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Flutter is not installed or not in PATH." -ForegroundColor Red
    exit 1
}

# Navigate to frontend directory
Set-Location -Path "Orchestra_AI-main"

# Get dependencies
Write-Host "📥 Getting Flutter dependencies..."
flutter pub get

# Run the app (Windows desktop target)
Write-Host "🚀 Launching OrchestraAI on Windows..." -ForegroundColor Green
flutter run -d windows
