# OrchestraAI - Backend Runner
Write-Host "🚀 Starting OrchestraAI Backend..." -ForegroundColor Cyan

# Check if Python is installed
if (!(Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Python is not installed or not in PATH." -ForegroundColor Red
    exit 1
}

# Navigate to backend directory
Set-Location -Path "backend"

# Create virtual environment if it doesn't exist
if (!(Test-Path "venv")) {
    Write-Host "📦 Creating virtual environment..."
    python -m venv venv
}

# Activate virtual environment
Write-Host "🔋 Activating virtual environment..."
.\venv\Scripts\Activate.ps1

# Install dependencies
Write-Host "📥 Installing dependencies (this may take a minute)..."
pip install -r requirements.txt --quiet

# Start the server
Write-Host "✅ Backend is starting on http://127.0.0.1:8000" -ForegroundColor Green
python -m uvicorn app:app --host 127.0.0.1 --port 8000 --reload
