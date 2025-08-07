# Local Build Script for AgriTrace (PowerShell)
# This script builds Docker images locally for testing

param(
    [switch]$SkipCache = $false
)

# Configuration
$ErrorActionPreference = "Stop"

# Colors for output
$Colors = @{
    Red = "Red"
    Green = "Green"
    Yellow = "Yellow"
    Blue = "Blue"
}

# Logging functions
function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor $Colors.Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor $Colors.Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor $Colors.Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor $Colors.Red
}

# Build backend image
function Build-Backend {
    Write-Info "Building backend Docker image..."
    
    $buildArgs = @("build", "-t", "agritrace-backend:latest", "./backend")
    if ($SkipCache) {
        $buildArgs += "--no-cache"
    }
    
    & docker @buildArgs
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to build backend image"
        exit 1
    }
    
    Write-Success "Backend image built successfully"
}

# Build frontend image
function Build-Frontend {
    Write-Info "Building frontend Docker image..."
    
    $buildArgs = @("build", "-t", "agritrace-frontend:latest", "./frontend")
    if ($SkipCache) {
        $buildArgs += "--no-cache"
    }
    
    & docker @buildArgs
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to build frontend image"
        exit 1
    }
    
    Write-Success "Frontend image built successfully"
}

# Main function
function Start-LocalBuild {
    Write-Info "Starting local build process..."
    
    # Check if Docker is running
    try {
        docker version | Out-Null
    }
    catch {
        Write-Error "Docker is not running. Please start Docker Desktop first."
        exit 1
    }
    
    Build-Backend
    Build-Frontend
    
    Write-Success "All images built successfully! 🎉"
    Write-Info "You can now run 'docker-compose up' to start the application"
}

# Run main function
Start-LocalBuild
