# Simple Verification Script for AgriTrace Public Endpoints

param (
    [Parameter(Mandatory=$true)]
    [ValidateSet("prod", "production", "staging", "dev")]
    [string]$Environment
)

# Set URLs based on environment
if ($Environment -eq "prod" -or $Environment -eq "production") {
    $EnvName = "Production"
    $FrontendUrl = "http://agritrace-prod.centralus.azurecontainer.io"
    $ApiUrl = "http://agritrace-prod-api.centralus.azurecontainer.io:8000"
} elseif ($Environment -eq "staging" -or $Environment -eq "dev") {
    $EnvName = "Staging"
    $FrontendUrl = "http://agritrace-staging.centralus.azurecontainer.io"
    $ApiUrl = "http://agritrace-staging-api.centralus.azurecontainer.io:8000"
} else {
    Write-Output "Invalid environment specified"
    exit 1
}

Write-Output "=== AgriTrace $EnvName Verification ==="
Write-Output "Timestamp: $(Get-Date)"
Write-Output ""

# Check Frontend
Write-Output "Frontend Checks:"
Write-Output "- Main URL: $FrontendUrl"
try {
    $response = Invoke-WebRequest -Uri $FrontendUrl -UseBasicParsing -ErrorAction SilentlyContinue
    Write-Output "  Status: $($response.StatusCode)"
} catch {
    Write-Output "  Status: FAILED - $($_.Exception.Message)"
}

Write-Output "- Health endpoint: $FrontendUrl/health"
try {
    $response = Invoke-WebRequest -Uri "$FrontendUrl/health" -UseBasicParsing -ErrorAction SilentlyContinue
    Write-Output "  Status: $($response.StatusCode)"
} catch {
    Write-Output "  Status: FAILED - $($_.Exception.Message)"
}

# Check Backend
Write-Output ""
Write-Output "Backend API Checks:"
Write-Output "- API URL: $ApiUrl"
try {
    $response = Invoke-WebRequest -Uri $ApiUrl -UseBasicParsing -ErrorAction SilentlyContinue
    Write-Output "  Status: $($response.StatusCode)"
} catch {
    Write-Output "  Status: FAILED - $($_.Exception.Message)"
}

Write-Output "- Health endpoint: $ApiUrl/api/health/"
try {
    $response = Invoke-WebRequest -Uri "$ApiUrl/api/health/" -UseBasicParsing -ErrorAction SilentlyContinue
    Write-Output "  Status: $($response.StatusCode)"
} catch {
    Write-Output "  Status: FAILED - $($_.Exception.Message)"
}

Write-Output "- Ready endpoint: $ApiUrl/api/ready/"
try {
    $response = Invoke-WebRequest -Uri "$ApiUrl/api/ready/" -UseBasicParsing -ErrorAction SilentlyContinue
    Write-Output "  Status: $($response.StatusCode)"
} catch {
    Write-Output "  Status: FAILED - $($_.Exception.Message)"
}

Write-Output "- Live endpoint: $ApiUrl/api/live/"
try {
    $response = Invoke-WebRequest -Uri "$ApiUrl/api/live/" -UseBasicParsing -ErrorAction SilentlyContinue
    Write-Output "  Status: $($response.StatusCode)"
} catch {
    Write-Output "  Status: FAILED - $($_.Exception.Message)"
}

Write-Output ""
Write-Output "Verification complete for $EnvName environment"
