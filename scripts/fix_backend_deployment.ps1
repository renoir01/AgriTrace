# Fix Backend Deployment Script
# This script addresses common issues causing 404 errors in container deployment

param(
    [string]$ResourceGroup = "agritrace-dev-rg",
    [string]$ContainerGroup = "agritrace-dev-backend-ci",
    [string]$RegistryName = "agritracedevacr"
)

Write-Host "=== Fixing AgriTrace Backend Deployment ===" -ForegroundColor Green

# Step 1: Rebuild and push the backend image
Write-Host "`n1. Rebuilding backend Docker image..." -ForegroundColor Yellow
Set-Location "c:\Users\user\CascadeProjects\summ\AgriTrace\backend"

# Build the image with proper tags
docker build -t agritrace-backend:latest .
if ($LASTEXITCODE -ne 0) {
    Write-Host "Docker build failed!" -ForegroundColor Red
    exit 1
}

# Tag for ACR
$acrLoginServer = az acr show --name $RegistryName --query loginServer --output tsv
docker tag agritrace-backend:latest "$acrLoginServer/agritrace-backend:latest"

# Push to ACR
Write-Host "Pushing image to Azure Container Registry..." -ForegroundColor Yellow
az acr login --name $RegistryName
docker push "$acrLoginServer/agritrace-backend:latest"

# Step 2: Update Terraform configuration and redeploy
Write-Host "`n2. Applying Terraform updates..." -ForegroundColor Yellow
Set-Location "c:\Users\user\CascadeProjects\summ\AgriTrace\infrastructure\azure"

# Apply the updated Terraform configuration
terraform plan -out=tfplan
terraform apply tfplan

# Step 3: Force restart the container group
Write-Host "`n3. Restarting container group..." -ForegroundColor Yellow
az container restart --resource-group $ResourceGroup --name $ContainerGroup

# Step 4: Wait for container to be ready
Write-Host "`n4. Waiting for container to start..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# Step 5: Test the deployment
Write-Host "`n5. Testing deployment..." -ForegroundColor Yellow

# Get container IP
$containerIP = az container show --resource-group $ResourceGroup --name $ContainerGroup --query "ipAddress.ip" --output tsv

if ($containerIP) {
    Write-Host "Container IP: $containerIP" -ForegroundColor Green
    
    # Test health endpoint
    try {
        $healthResponse = Invoke-WebRequest -Uri "http://$containerIP:8000/api/v1/health/" -TimeoutSec 30
        Write-Host "✓ Health check passed: $($healthResponse.StatusCode)" -ForegroundColor Green
    } catch {
        Write-Host "✗ Health check failed: $($_.Exception.Message)" -ForegroundColor Red
        
        # Show container logs for debugging
        Write-Host "`nContainer logs:" -ForegroundColor Yellow
        az container logs --resource-group $ResourceGroup --name $ContainerGroup --container-name "backend"
    }
    
    # Test API root endpoint
    try {
        $apiResponse = Invoke-WebRequest -Uri "http://$containerIP:8000/api/v1/" -TimeoutSec 30
        Write-Host "✓ API root accessible: $($apiResponse.StatusCode)" -ForegroundColor Green
    } catch {
        Write-Host "✗ API root failed: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "✗ Could not get container IP address" -ForegroundColor Red
}

# Step 6: Test through Application Gateway
Write-Host "`n6. Testing through Application Gateway..." -ForegroundColor Yellow
$appGatewayIP = az network public-ip show --resource-group $ResourceGroup --name "agritrace-dev-appgw-pip" --query ipAddress --output tsv

if ($appGatewayIP) {
    Write-Host "Application Gateway IP: $appGatewayIP" -ForegroundColor Green
    
    try {
        $gatewayResponse = Invoke-WebRequest -Uri "http://$appGatewayIP/api/v1/health/" -TimeoutSec 30
        Write-Host "✓ Gateway health check passed: $($gatewayResponse.StatusCode)" -ForegroundColor Green
    } catch {
        Write-Host "✗ Gateway health check failed: $($_.Exception.Message)" -ForegroundColor Red
        
        # Check Application Gateway backend health
        Write-Host "Checking backend pool health..." -ForegroundColor Yellow
        az network application-gateway show-backend-health --resource-group $ResourceGroup --name "agritrace-dev-appgw"
    }
}

Write-Host "`n=== Deployment Fix Complete ===" -ForegroundColor Green
Write-Host "If issues persist, check the container logs and Application Gateway configuration." -ForegroundColor Yellow
