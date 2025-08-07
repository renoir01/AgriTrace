# AgriTrace Deployment Script for Windows PowerShell
# This script handles the complete deployment process

param(
    [string]$Environment = "dev",
    [string]$AwsRegion = "us-east-1"
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
    $tools = @("aws", "docker", "terraform", "git")
    foreach ($tool in $tools) {
        if (!(Get-Command $tool -ErrorAction SilentlyContinue)) {
            Write-Error "$tool is required but not installed. Please install it first."
            exit 1
        }
    }
    
    # Check AWS credentials
    try {
        aws sts get-caller-identity | Out-Null
    }
    catch {
        Write-Error "AWS credentials not configured. Run 'aws configure' first."
        exit 1
    }
    
    Write-Success "Prerequisites check passed"
}

# Initialize and apply Terraform
function Deploy-Infrastructure {
    Write-Info "Deploying infrastructure with Terraform..."
    
    Push-Location infrastructure
    
    try {
        # Initialize Terraform
        terraform init
        
        # Plan the deployment
        terraform plan -var-file="terraform.tfvars" -out=tfplan
        
        # Apply the plan
        Write-Info "Applying Terraform plan..."
        terraform apply tfplan
        
        # Get outputs
        $script:EcrBackendUri = terraform output -raw ecr_backend_repository_url
        $script:EcrFrontendUri = terraform output -raw ecr_frontend_repository_url
        
        Write-Success "Infrastructure deployed successfully"
        Write-Host "Backend ECR: $script:EcrBackendUri"
        Write-Host "Frontend ECR: $script:EcrFrontendUri"
    }
    finally {
        Pop-Location
    }
}

# Build and push Docker images
function Build-AndPushImages {
    Write-Info "Building and pushing Docker images..."
    
    # Get AWS account ID
    $AwsAccountId = (aws sts get-caller-identity --query Account --output text)
    
    # Get ECR login token
    $LoginCommand = aws ecr get-login-password --region $AwsRegion
    $LoginCommand | docker login --username AWS --password-stdin "$AwsAccountId.dkr.ecr.$AwsRegion.amazonaws.com"
    
    # Get current git commit hash
    $GitHash = git rev-parse --short HEAD
    
    # Build and push backend image
    Write-Info "Building backend image..."
    docker build -t "$ProjectName-backend" ./backend
    docker tag "$ProjectName-backend:latest" "$script:EcrBackendUri:latest"
    docker tag "$ProjectName-backend:latest" "$script:EcrBackendUri:$GitHash"
    
    Write-Info "Pushing backend image..."
    docker push "$script:EcrBackendUri:latest"
    docker push "$script:EcrBackendUri:$GitHash"
    
    # Build and push frontend image
    Write-Info "Building frontend image..."
    docker build -t "$ProjectName-frontend" ./frontend
    docker tag "$ProjectName-frontend:latest" "$script:EcrFrontendUri:latest"
    docker tag "$ProjectName-frontend:latest" "$script:EcrFrontendUri:$GitHash"
    
    Write-Info "Pushing frontend image..."
    docker push "$script:EcrFrontendUri:latest"
    docker push "$script:EcrFrontendUri:$GitHash"
    
    Write-Success "Docker images built and pushed successfully"
}

# Update ECS services
function Update-Services {
    Write-Info "Updating ECS services..."
    
    # Force new deployment for backend service
    aws ecs update-service `
        --cluster "$ProjectName-$Environment-cluster" `
        --service "$ProjectName-$Environment-backend" `
        --force-new-deployment `
        --region $AwsRegion
    
    # Force new deployment for frontend service
    aws ecs update-service `
        --cluster "$ProjectName-$Environment-cluster" `
        --service "$ProjectName-$Environment-frontend" `
        --force-new-deployment `
        --region $AwsRegion
    
    Write-Success "ECS services updated successfully"
}

# Wait for deployment to complete
function Wait-ForDeployment {
    Write-Info "Waiting for deployment to complete..."
    
    # Wait for backend service to be stable
    aws ecs wait services-stable `
        --cluster "$ProjectName-$Environment-cluster" `
        --services "$ProjectName-$Environment-backend" `
        --region $AwsRegion
    
    # Wait for frontend service to be stable
    aws ecs wait services-stable `
        --cluster "$ProjectName-$Environment-cluster" `
        --services "$ProjectName-$Environment-frontend" `
        --region $AwsRegion
    
    Write-Success "Deployment completed successfully"
}

# Get application URL
function Get-ApplicationUrl {
    Push-Location infrastructure
    try {
        $ApplicationUrl = terraform output -raw application_url
        Write-Success "Application is available at: $ApplicationUrl"
    }
    finally {
        Pop-Location
    }
}

# Main deployment function
function Start-Deployment {
    Write-Info "Starting AgriTrace deployment..."
    
    Test-Prerequisites
    Deploy-Infrastructure
    Build-AndPushImages
    Update-Services
    Wait-ForDeployment
    Get-ApplicationUrl
    
    Write-Success "Deployment completed successfully! 🎉"
}

# Run main function
Start-Deployment
