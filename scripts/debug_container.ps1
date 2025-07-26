# Debug Container Deployment Script
# This script helps diagnose container deployment issues

Write-Host "=== AgriTrace Container Debugging ===" -ForegroundColor Green

# Check container group status
Write-Host "`nChecking backend container status..." -ForegroundColor Yellow
az container show --resource-group "agritrace-dev-rg" --name "agritrace-dev-backend-ci" --query "{name:name,state:containers[0].instanceView.currentState.state,restartCount:containers[0].instanceView.restartCount}" --output table

# Get container logs
Write-Host "`nGetting backend container logs..." -ForegroundColor Yellow
az container logs --resource-group "agritrace-dev-rg" --name "agritrace-dev-backend-ci" --container-name "backend"

# Check container events
Write-Host "`nChecking container events..." -ForegroundColor Yellow
az container show --resource-group "agritrace-dev-rg" --name "agritrace-dev-backend-ci" --query "containers[0].instanceView.events" --output table

# Test health endpoint directly
Write-Host "`nTesting health endpoint..." -ForegroundColor Yellow
$backendIP = az container show --resource-group "agritrace-dev-rg" --name "agritrace-dev-backend-ci" --query "ipAddress.ip" --output tsv
if ($backendIP) {
    Write-Host "Backend IP: $backendIP"
    try {
        $response = Invoke-WebRequest -Uri "http://$backendIP:8000/api/v1/health/" -TimeoutSec 10
        Write-Host "Health check response: $($response.StatusCode)" -ForegroundColor Green
        Write-Host "Response body: $($response.Content)"
    } catch {
        Write-Host "Health check failed: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "Could not get backend IP address" -ForegroundColor Red
}

# Check Application Gateway backend health
Write-Host "`nChecking Application Gateway backend health..." -ForegroundColor Yellow
az network application-gateway show-backend-health --resource-group "agritrace-dev-rg" --name "agritrace-dev-appgw" --query "backendAddressPools[?name=='backend-api-pool'].backendHttpSettingsCollection[0].servers[0].health" --output table

Write-Host "`n=== Debug Complete ===" -ForegroundColor Green
