# Azure Deployment Guide for AgriTrace

## 🚀 Complete Azure Infrastructure Setup

Your AgriTrace application now has a comprehensive Azure deployment configuration that includes:

### Azure Resources Created
- **Resource Group**: Container for all resources
- **Virtual Network**: Secure networking with public/private subnets
- **Azure Container Registry**: For storing Docker images
- **Azure Container Instances**: For running your containers
- **PostgreSQL Database**: Managed database service
- **Application Gateway**: Load balancer with intelligent routing
- **Key Vault**: Secure storage for secrets and connection strings
- **Private Endpoints**: Secure database connectivity

## 📋 Prerequisites

1. **Azure Account** with sufficient permissions
2. **Azure CLI** installed and configured
3. **Terraform** installed (version 1.0+)
4. **Docker Desktop** for building images
5. **Git** for version control

## 🛠️ Installation Steps

### 1. Install Required Tools

#### Azure CLI
```powershell
# Windows (using winget)
winget install Microsoft.AzureCLI

# Or download from: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
```

#### Terraform
```powershell
# Windows (using chocolatey)
choco install terraform

# Or download from: https://www.terraform.io/downloads
```

#### Docker Desktop
Download and install from: https://www.docker.com/products/docker-desktop/

### 2. Configure Azure Authentication

```bash
# Login to Azure
az login

# Set your subscription (if you have multiple)
az account set --subscription "your-subscription-id"

# Verify your login
az account show
```

## 🚀 Deployment Options

### Option 1: Automated Azure Deployment (Recommended)

```powershell
# Navigate to your project directory
cd AgriTrace

# Copy and configure variables
cd infrastructure/azure
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your settings

# Run the automated deployment script
cd ../..
.\scripts\deploy-azure.ps1
```

### Option 2: Manual Step-by-Step Deployment

#### Step 1: Configure Terraform Variables
```bash
cd infrastructure/azure
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars`:
```hcl
azure_location = "East US"
environment = "dev"
project_name = "agritrace"
vnet_cidr = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
private_subnet_cidr = "10.0.2.0/24"
db_sku_name = "B_Gen5_1"
db_storage_mb = 20480
container_cpu = 1
container_memory = 2
```

#### Step 2: Deploy Infrastructure
```bash
# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Apply the infrastructure
terraform apply
```

#### Step 3: Build and Push Docker Images
```bash
# Get ACR details from Terraform output
ACR_LOGIN_SERVER=$(terraform output -raw container_registry_login_server)
ACR_USERNAME=$(terraform output -raw container_registry_admin_username)
ACR_PASSWORD=$(terraform output -raw container_registry_admin_password)

# Login to ACR
echo $ACR_PASSWORD | docker login $ACR_LOGIN_SERVER --username $ACR_USERNAME --password-stdin

# Build and push backend
docker build -t agritrace-backend ./../../backend
docker tag agritrace-backend:latest $ACR_LOGIN_SERVER/agritrace-backend:latest
docker push $ACR_LOGIN_SERVER/agritrace-backend:latest

# Build and push frontend
docker build -t agritrace-frontend ./../../frontend
docker tag agritrace-frontend:latest $ACR_LOGIN_SERVER/agritrace-frontend:latest
docker push $ACR_LOGIN_SERVER/agritrace-frontend:latest
```

#### Step 4: Update Container Instances
```bash
# Get resource group name
RESOURCE_GROUP=$(terraform output -raw resource_group_name)

# Restart containers to pull new images
az container restart --name agritrace-dev-backend-ci --resource-group $RESOURCE_GROUP
az container restart --name agritrace-dev-frontend-ci --resource-group $RESOURCE_GROUP
```

#### Step 5: Get Application URL
```bash
# Get the public URL
APPLICATION_URL=$(terraform output -raw application_url)
echo "Application available at: $APPLICATION_URL"
```

## 🔍 Monitoring and Management

### View Resources in Azure Portal
1. Go to [Azure Portal](https://portal.azure.com)
2. Navigate to your resource group: `agritrace-dev-rg`
3. View all deployed resources

### Check Container Logs
```bash
# Backend logs
az container logs --name agritrace-dev-backend-ci --resource-group agritrace-dev-rg

# Frontend logs
az container logs --name agritrace-dev-frontend-ci --resource-group agritrace-dev-rg
```

### Database Management
```bash
# Connect to PostgreSQL (from within VNet)
psql "host=agritrace-dev-psql-server.postgres.database.azure.com port=5432 dbname=agritrace user=agritrace_admin sslmode=require"
```

## 💰 Cost Optimization

Your Azure setup uses cost-effective resources:
- **Container Instances**: Pay-per-second billing
- **PostgreSQL Basic**: Lowest-cost database tier
- **Application Gateway v2**: Standard tier for development
- **Container Registry Basic**: Suitable for development workloads

**Estimated monthly cost**: $50-100 USD (depending on usage)

## 🛡️ Security Features

- **Private networking**: Database in private subnet
- **Key Vault**: Secure secret storage
- **Private endpoints**: Encrypted database connections
- **Network Security Groups**: Traffic filtering
- **SSL enforcement**: Database connections encrypted

## 🔧 Troubleshooting

### Common Issues

1. **Container startup failures**
   ```bash
   # Check container events
   az container show --name agritrace-dev-backend-ci --resource-group agritrace-dev-rg
   ```

2. **Database connection issues**
   ```bash
   # Verify private endpoint configuration
   az network private-endpoint list --resource-group agritrace-dev-rg
   ```

3. **Application Gateway health probe failures**
   ```bash
   # Check backend health
   az network application-gateway show-backend-health --name agritrace-dev-appgw --resource-group agritrace-dev-rg
   ```

## 📸 Screenshots for Phase.md

Take screenshots of:
1. **Resource Group Overview**: All deployed resources
2. **Application Gateway**: Frontend IP and backend pools
3. **Container Registry**: Pushed images
4. **Container Instances**: Running containers
5. **PostgreSQL Server**: Database configuration
6. **Application URL**: Working application

## 🎯 Next Steps

1. **Deploy your application** using the automated script
2. **Test the live URL** and functionality
3. **Take screenshots** of Azure resources
4. **Update phase.md** with your results
5. **Complete peer review** requirement
6. **Submit your Phase 2 work**

Your Azure infrastructure is production-ready and follows best practices for security, scalability, and cost optimization!
