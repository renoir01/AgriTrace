# Fix Frontend Container Deployment Script
# This script forces recreation of the frontend container with updated configuration
# Run this script from the infrastructure/azure directory

Write-Host "Starting Frontend Container Fix Deployment..." -ForegroundColor Green

# Step 1: Check current backend health
Write-Host "Step 1: Checking Application Gateway Backend Health..." -ForegroundColor Yellow
az network application-gateway show-backend-health --resource-group agritrace-dev-rg --name agritrace-dev-appgw --query "backendAddressPools[].backendHttpSettingsCollection[].servers[].{address:address,health:health}" --output table

# Step 2: Check current frontend container logs
Write-Host "`nStep 2: Checking Frontend Container Logs..." -ForegroundColor Yellow
az container logs --resource-group agritrace-dev-rg --name agritrace-dev-frontend-ci --container-name frontend

# Step 3: Taint the frontend container to force recreation
Write-Host "`nStep 3: Tainting Frontend Container for Recreation..." -ForegroundColor Yellow
terraform taint azurerm_container_group.frontend

# Step 4: Apply Terraform to recreate the frontend container with new configuration
Write-Host "`nStep 4: Applying Terraform to Recreate Frontend Container..." -ForegroundColor Yellow
terraform apply -auto-approve

# Step 5: Wait for container to start
Write-Host "`nStep 5: Waiting for Container to Start (60 seconds)..." -ForegroundColor Yellow
Start-Sleep -Seconds 60

# Step 6: Check new frontend container logs
Write-Host "`nStep 6: Checking New Frontend Container Logs..." -ForegroundColor Yellow
az container logs --resource-group agritrace-dev-rg --name agritrace-dev-frontend-ci --container-name frontend

# Step 7: Check backend health again
Write-Host "`nStep 7: Checking Application Gateway Backend Health Again..." -ForegroundColor Yellow
az network application-gateway show-backend-health --resource-group agritrace-dev-rg --name agritrace-dev-appgw --query "backendAddressPools[].backendHttpSettingsCollection[].servers[].{address:address,health:health}" --output table

# Step 8: Test the application
Write-Host "`nStep 8: Getting Application URL..." -ForegroundColor Yellow
$publicIp = terraform output -raw application_gateway_public_ip
$appUrl = "http://$publicIp"
Write-Host "Application URL: $appUrl" -ForegroundColor Green

# Step 9: Display final status
Write-Host "`nStep 9: Final Status Check..." -ForegroundColor Yellow
Write-Host "If both backend (10.0.2.5) and frontend (10.0.2.4) show as 'Healthy', your application should be working!" -ForegroundColor Green
Write-Host "Visit: $appUrl" -ForegroundColor Cyan

# Optional: Open browser (uncomment if desired)
# Start-Process $appUrl

Write-Host "`nDeployment script completed!" -ForegroundColor Green
Write-Host "If the frontend is still unhealthy, check the container logs above for errors." -ForegroundColor Yellow
