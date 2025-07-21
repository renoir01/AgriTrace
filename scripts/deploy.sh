#!/bin/bash

# AgriTrace Deployment Script
# This script handles the complete deployment process

set -e

# Configuration
PROJECT_NAME="agritrace"
ENVIRONMENT="${ENVIRONMENT:-dev}"
AWS_REGION="${AWS_REGION:-us-east-1}"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check if required tools are installed
    command -v aws >/dev/null 2>&1 || { log_error "AWS CLI is required but not installed. Aborting."; exit 1; }
    command -v docker >/dev/null 2>&1 || { log_error "Docker is required but not installed. Aborting."; exit 1; }
    command -v terraform >/dev/null 2>&1 || { log_error "Terraform is required but not installed. Aborting."; exit 1; }
    
    # Check AWS credentials
    aws sts get-caller-identity >/dev/null 2>&1 || { log_error "AWS credentials not configured. Run 'aws configure' first."; exit 1; }
    
    log_success "Prerequisites check passed"
}

# Initialize and apply Terraform
deploy_infrastructure() {
    log_info "Deploying infrastructure with Terraform..."
    
    cd infrastructure
    
    # Initialize Terraform
    terraform init
    
    # Plan the deployment
    terraform plan -var-file="terraform.tfvars" -out=tfplan
    
    # Apply the plan
    log_info "Applying Terraform plan..."
    terraform apply tfplan
    
    # Get outputs
    ECR_BACKEND_URI=$(terraform output -raw ecr_backend_repository_url)
    ECR_FRONTEND_URI=$(terraform output -raw ecr_frontend_repository_url)
    
    cd ..
    
    log_success "Infrastructure deployed successfully"
    echo "Backend ECR: $ECR_BACKEND_URI"
    echo "Frontend ECR: $ECR_FRONTEND_URI"
}

# Build and push Docker images
build_and_push_images() {
    log_info "Building and pushing Docker images..."
    
    # Get ECR login token
    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
    
    # Build and push backend image
    log_info "Building backend image..."
    docker build -t $PROJECT_NAME-backend ./backend
    docker tag $PROJECT_NAME-backend:latest $ECR_BACKEND_URI:latest
    docker tag $PROJECT_NAME-backend:latest $ECR_BACKEND_URI:$(git rev-parse --short HEAD)
    
    log_info "Pushing backend image..."
    docker push $ECR_BACKEND_URI:latest
    docker push $ECR_BACKEND_URI:$(git rev-parse --short HEAD)
    
    # Build and push frontend image
    log_info "Building frontend image..."
    docker build -t $PROJECT_NAME-frontend ./frontend
    docker tag $PROJECT_NAME-frontend:latest $ECR_FRONTEND_URI:latest
    docker tag $PROJECT_NAME-frontend:latest $ECR_FRONTEND_URI:$(git rev-parse --short HEAD)
    
    log_info "Pushing frontend image..."
    docker push $ECR_FRONTEND_URI:latest
    docker push $ECR_FRONTEND_URI:$(git rev-parse --short HEAD)
    
    log_success "Docker images built and pushed successfully"
}

# Update ECS services
update_services() {
    log_info "Updating ECS services..."
    
    # Force new deployment for backend service
    aws ecs update-service \
        --cluster "$PROJECT_NAME-$ENVIRONMENT-cluster" \
        --service "$PROJECT_NAME-$ENVIRONMENT-backend" \
        --force-new-deployment \
        --region $AWS_REGION
    
    # Force new deployment for frontend service
    aws ecs update-service \
        --cluster "$PROJECT_NAME-$ENVIRONMENT-cluster" \
        --service "$PROJECT_NAME-$ENVIRONMENT-frontend" \
        --force-new-deployment \
        --region $AWS_REGION
    
    log_success "ECS services updated successfully"
}

# Wait for deployment to complete
wait_for_deployment() {
    log_info "Waiting for deployment to complete..."
    
    # Wait for backend service to be stable
    aws ecs wait services-stable \
        --cluster "$PROJECT_NAME-$ENVIRONMENT-cluster" \
        --services "$PROJECT_NAME-$ENVIRONMENT-backend" \
        --region $AWS_REGION
    
    # Wait for frontend service to be stable
    aws ecs wait services-stable \
        --cluster "$PROJECT_NAME-$ENVIRONMENT-cluster" \
        --services "$PROJECT_NAME-$ENVIRONMENT-frontend" \
        --region $AWS_REGION
    
    log_success "Deployment completed successfully"
}

# Get application URL
get_application_url() {
    cd infrastructure
    APPLICATION_URL=$(terraform output -raw application_url)
    cd ..
    
    log_success "Application is available at: $APPLICATION_URL"
}

# Main deployment function
main() {
    log_info "Starting AgriTrace deployment..."
    
    check_prerequisites
    deploy_infrastructure
    build_and_push_images
    update_services
    wait_for_deployment
    get_application_url
    
    log_success "Deployment completed successfully! 🎉"
}

# Run main function
main "$@"
