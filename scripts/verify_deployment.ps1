# AgriTrace Deployment Verification Script (PowerShell version)
# This script checks the health and status of all AgriTrace deployment components

param (
    [Parameter(Mandatory=$true)]
    [ValidateSet("prod", "production", "staging", "dev")]
    [string]$Environment
)

# Text formatting
$Green = 'Green'
$Red = 'Red'
$Yellow = 'Yellow'
$White = 'White'

# Environment selection
if ($Environment -eq "prod" -or $Environment -eq "production") {
    $EnvName = "Production"
    $FrontendUrl = "http://agritrace-prod.centralus.azurecontainer.io"
    $ApiUrl = "http://agritrace-prod-api.centralus.azurecontainer.io:8000"
} elseif ($Environment -eq "staging" -or $Environment -eq "dev") {
    $EnvName = "Staging"
    $FrontendUrl = "http://agritrace-staging.centralus.azurecontainer.io"
    $ApiUrl = "http://agritrace-staging-api.centralus.azurecontainer.io:8000"
} else {
    Write-Host "Usage: .\verify_deployment.ps1 [prod|staging]" -ForegroundColor $Yellow
    Write-Host "Example: .\verify_deployment.ps1 prod"
    exit 1
}

Write-Host "AgriTrace $EnvName Deployment Verification" -ForegroundColor $White -BackgroundColor Blue
Write-Host "========================================" -ForegroundColor $White
Write-Host "Timestamp: $(Get-Date)" -ForegroundColor $White
Write-Host ""

# Function to check endpoint health
function Check-Endpoint {
    param (
        [string]$Url,
        [string]$Name,
        [int]$ExpectedStatus = 200
    )
    
    Write-Host "Checking $Name... " -NoNewline
    
    try {
        $response = Invoke-WebRequest -Uri $Url -Method Get -UseBasicParsing -ErrorAction SilentlyContinue
        $statusCode = $response.StatusCode
        
        if ($statusCode -eq $ExpectedStatus) {
            Write-Host "OK ($statusCode)" -ForegroundColor $Green
            return $true
        } else {
            Write-Host "FAILED ($statusCode)" -ForegroundColor $Red
            return $false
        }
    } catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        if ($statusCode -eq $ExpectedStatus) {
            Write-Host "OK ($statusCode)" -ForegroundColor $Green
            return $true
        } else {
            Write-Host "FAILED ($statusCode)" -ForegroundColor $Red
            return $false
        }
    }
}

# Check frontend endpoints
Write-Host "`nFrontend Checks:" -ForegroundColor $White -BackgroundColor DarkGray
Check-Endpoint -Url $FrontendUrl -Name "Frontend main page"
Check-Endpoint -Url "$FrontendUrl/health" -Name "Frontend health endpoint"

# Check backend API endpoints
Write-Host "`nBackend API Checks:" -ForegroundColor $White -BackgroundColor DarkGray
Check-Endpoint -Url "$ApiUrl/api/health/" -Name "API health endpoint"
Check-Endpoint -Url "$ApiUrl/api/ready/" -Name "API readiness probe"
Check-Endpoint -Url "$ApiUrl/api/live/" -Name "API liveness probe"
Check-Endpoint -Url "$ApiUrl/swagger/" -Name "API documentation"
Check-Endpoint -Url "$ApiUrl/admin/" -Name "Admin panel" -ExpectedStatus 302

# Check API functionality (basic)
Write-Host "`nAPI Functionality Checks:" -ForegroundColor $White -BackgroundColor DarkGray
Write-Host "Checking API farms endpoint... " -NoNewline
try {
    $farmsResponse = Invoke-RestMethod -Uri "$ApiUrl/api/farms/" -Method Get -UseBasicParsing -ErrorAction SilentlyContinue
    if ($farmsResponse.results -ne $null) {
        Write-Host "OK (API returned results)" -ForegroundColor $Green
    } else {
        Write-Host "FAILED (API did not return expected format)" -ForegroundColor $Red
    }
} catch {
    Write-Host "FAILED (Error: $($_.Exception.Message))" -ForegroundColor $Red
}

# Summary
Write-Host "`nDeployment Verification Summary:" -ForegroundColor $White -BackgroundColor Blue
Write-Host "Environment: $EnvName" -ForegroundColor $White
Write-Host "Frontend URL: $FrontendUrl" -ForegroundColor $White
Write-Host "API URL: $ApiUrl" -ForegroundColor $White
Write-Host "Timestamp: $(Get-Date)" -ForegroundColor $White
Write-Host ""
Write-Host "For detailed monitoring, visit the Azure Monitor dashboard." -ForegroundColor $Yellow
