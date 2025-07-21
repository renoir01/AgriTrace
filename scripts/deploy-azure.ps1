# AgriTrace Azure Deployment Script
# This script handles the complete Azure deployment process

param(
    [string]$Environment = "dev",
    [string]$AzureLocation = "East US",
    [string]$ResourceGroupName = ""
)

# Configuration
$ProjectName = "agritrace"
$ErrorActionPreference = "Stop"

# Colors for output
$Colors = @{
    Red = "Red"
    Green = "Green"
    Yellow = "Yellow"
    Blue = "Blue"
    White = "White"
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

# Check prerequisites
function Test-Prerequisites {
    Write-Info "Checking prerequisites..."
    
    # Check if required tools are installed
    $tools = @("az", "docker", "terraform", "git")
    foreach ($tool in $tools) {
        if (!(Get-Command $tool -ErrorAction SilentlyContinue)) {
            Write-Error "$tool is required but not installed. Please install it first."
            Write-Info "Install Azure CLI: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
            Write-Info "Install Docker: https://www.docker.com/products/docker-desktop/"
            Write-Info "Install Terraform: https://www.terraform.io/downloads"
            exit 1
        }
    }
    
    # Check Azure login
    try {
        $account = az account show --query "name" -o tsv 2>$null
        if (!$account) {
            Write-Error "Not logged into Azure. Please run 'az login' first."
            exit 1
        }
        Write-Info "Logged into Azure as: $account"
    }
    catch {
        Write-Error "Azure CLI not configured. Please run 'az login' first."
        exit 1
    }
    
    Write-Success "Prerequisites check passed"
}

# Initialize and apply Terraform
function Deploy-Infrastructure {
    Write-Info "Deploying infrastructure with Terraform..."
    
    Push-Location infrastructure/azure
    
    try {
        # Initialize Terraform
        terraform init
        
        # Plan the deployment
        terraform plan -var-file="terraform.tfvars" -out=tfplan
        
        # Apply the plan
        Write-Info "Applying Terraform plan..."
        terraform apply tfplan
        
        # Get outputs
        $script:AcrLoginServer = terraform output -raw container_registry_login_server
        $script:AcrUsername = terraform output -raw container_registry_admin_username
        $script:AcrPassword = terraform output -raw container_registry_admin_password
        $script:ApplicationUrl = terraform output -raw application_url
        
        Write-Success "Infrastructure deployed successfully"
        Write-Host "Container Registry: $script:AcrLoginServer"
        Write-Host "Application URL: $script:ApplicationUrl"
    }
    finally {
        Pop-Location
    }
}

# Build and push Docker images
function Build-AndPushImages {
    Write-Info "Building and pushing Docker images to Azure Container Registry..."
    
    # Login to ACR
    Write-Info "Logging into Azure Container Registry..."
    $script:AcrPassword | docker login $script:AcrLoginServer --username $script:AcrUsername --password-stdin
    
    # Get current git commit hash
    $GitHash = git rev-parse --short HEAD
    
    # Build and push backend image
    Write-Info "Building backend image..."
    docker build -t "$ProjectName-backend" ./backend
    docker tag "$ProjectName-backend:latest" "$script:AcrLoginServer/agritrace-backend:latest"
    docker tag "$ProjectName-backend:latest" "$script:AcrLoginServer/agritrace-backend:$GitHash"
    
    Write-Info "Pushing backend image..."
    docker push "$script:AcrLoginServer/agritrace-backend:latest"
    docker push "$script:AcrLoginServer/agritrace-backend:$GitHash"
    
    # Build and push frontend image
    Write-Info "Building frontend image..."
    docker build -t "$ProjectName-frontend" ./frontend
    docker tag "$ProjectName-frontend:latest" "$script:AcrLoginServer/agritrace-frontend:latest"
    docker tag "$ProjectName-frontend:latest" "$script:AcrLoginServer/agritrace-frontend:$GitHash"
    
    Write-Info "Pushing frontend image..."
    docker push "$script:AcrLoginServer/agritrace-frontend:latest"
    docker push "$script:AcrLoginServer/agritrace-frontend:$GitHash"
    
    Write-Success "Docker images built and pushed successfully"
}

# Update Container Instances
function Update-ContainerInstances {
    Write-Info "Updating Azure Container Instances..."
    
    # Get resource group name from Terraform output
    Push-Location infrastructure/azure
    $ResourceGroup = terraform output -raw resource_group_name
    Pop-Location
    
    # Restart backend container group to pull new image
    Write-Info "Restarting backend container group..."
    az container restart --name "$ProjectName-$Environment-backend-ci" --resource-group $ResourceGroup
    
    # Restart frontend container group to pull new image
    Write-Info "Restarting frontend container group..."
    az container restart --name "$ProjectName-$Environment-frontend-ci" --resource-group $ResourceGroup
    
    Write-Success "Container instances updated successfully"
}

# Wait for containers to be ready
function Wait-ForContainers {
    Write-Info "Waiting for containers to be ready..."
    
    # Get resource group name
    Push-Location infrastructure/azure
    $ResourceGroup = terraform output -raw resource_group_name
    Pop-Location
    
    # Wait for backend container
    Write-Info "Checking backend container status..."
    do {
        $backendState = az container show --name "$ProjectName-$Environment-backend-ci" --resource-group $ResourceGroup --query "containers[0].instanceView.currentState.state" -o tsv
        if ($backendState -eq "Running") {
            Write-Success "Backend container is running"
            break
        }
        Write-Info "Backend container state: $backendState. Waiting..."
        Start-Sleep -Seconds 10
    } while ($true)
    
    # Wait for frontend container
    Write-Info "Checking frontend container status..."
    do {
        $frontendState = az container show --name "$ProjectName-$Environment-frontend-ci" --resource-group $ResourceGroup --query "containers[0].instanceView.currentState.state" -o tsv
        if ($frontendState -eq "Running") {
            Write-Success "Frontend container is running"
            break
        }
        Write-Info "Frontend container state: $frontendState. Waiting..."
        Start-Sleep -Seconds 10
    } while ($true)
    
    Write-Success "All containers are ready"
}

# Test application health
function Test-ApplicationHealth {
    Write-Info "Testing application health..."
    
    try {
        # Test if application is responding
        $response = Invoke-WebRequest -Uri $script:ApplicationUrl -Method GET -TimeoutSec 30
        if ($response.StatusCode -eq 200) {
            Write-Success "Application is responding successfully!"
        }
    }
    catch {
        Write-Warning "Application health check failed, but deployment completed. Please check manually."
        Write-Info "Application URL: $script:ApplicationUrl"
    }
}

# Main deployment function
function Start-AzureDeployment {
    Write-Info "Starting AgriTrace Azure deployment..."
    
    Test-Prerequisites
    Deploy-Infrastructure
    Build-AndPushImages
    Update-ContainerInstances
    Wait-ForContainers
    Test-ApplicationHealth
    
    Write-Success "Azure deployment completed successfully! 🎉"
    Write-Info "Application URL: $script:ApplicationUrl"
    Write-Info "Next steps:"
    Write-Info "1. Update your phase.md with the application URL"
    Write-Info "2. Take screenshots of Azure resources"
    Write-Info "3. Complete your peer review"
}

# Run main function
Start-AzureDeployment
