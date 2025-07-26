# AgriTrace Azure Infrastructure as Code

This directory contains Terraform configurations for deploying the AgriTrace application infrastructure on Microsoft Azure. The infrastructure follows best practices for security, scalability, and maintainability.

## Architecture Overview

The infrastructure is designed with a multi-tier architecture:

- **Application Gateway**: Public-facing load balancer with SSL termination
- **Container Instances**: Private containers running Django backend and React frontend
- **PostgreSQL Database**: Managed database service with private networking
- **Container Registry**: Private registry for application images
- **Key Vault**: Secure storage for secrets and certificates
- **Virtual Network**: Segmented network with security groups

## Module Structure

The Terraform code is organized into logical modules for better maintainability:

```
infrastructure/azure/
├── main.tf                 # Root configuration and resource group
├── variables.tf            # Input variables with validation
├── outputs.tf              # Output values for integration
├── terraform.tfvars        # Environment-specific values
├── modules/
│   └── networking/         # Network infrastructure module
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── application_gateway.tf  # Load balancer configuration
├── container_instances.tf  # Application containers
├── container_registry.tf   # Docker registry
├── database.tf            # PostgreSQL configuration
└── networking.tf          # Network resources (legacy)
```

## Security Features

### Network Security
- **Private Subnets**: Application containers run in private subnets
- **Network Security Groups**: Restrictive firewall rules
- **Subnet Delegation**: Dedicated subnets for specific services
- **Private Endpoints**: Database accessible only from private network

### Access Control
- **Managed Identity**: Containers use managed identity for Azure services
- **Key Vault Integration**: Secrets stored securely and rotated
- **RBAC**: Role-based access control for all resources
- **SSL/TLS**: End-to-end encryption for all traffic

### Monitoring & Compliance
- **Health Checks**: Container health monitoring
- **Logging**: Centralized logging for all components
- **Tags**: Comprehensive tagging for governance
- **Backup**: Automated database backups

## Variables Configuration

### Required Variables
- `project_name`: Name of the project (default: "agritrace")
- `environment`: Environment name (dev/staging/prod)
- `azure_location`: Azure region for deployment

### Network Configuration
- `vnet_cidr`: Virtual network CIDR block
- `public_subnet_cidr`: Public subnet CIDR
- `private_subnet_cidr`: Private subnet CIDR
- `db_subnet_cidr`: Database subnet CIDR
- `appgw_subnet_cidr`: Application Gateway subnet CIDR

### Application Configuration
- `container_cpu`: CPU cores for containers
- `container_memory`: Memory allocation in GB
- `app_port`: Application port (default: 8000)
- `django_debug`: Enable debug mode (default: false)

### Database Configuration
- `db_sku_name`: PostgreSQL SKU
- `db_storage_mb`: Storage size in MB
- `db_admin_username`: Database admin username

## Deployment Instructions

### Prerequisites
1. Azure CLI installed and authenticated
2. Terraform >= 1.0 installed
3. Appropriate Azure permissions

### Initial Deployment
```bash
# Initialize Terraform
terraform init

# Plan the deployment
terraform plan -var-file="terraform.tfvars"

# Apply the configuration
terraform apply -var-file="terraform.tfvars"
```

### Import Existing Resources
If you have existing Azure resources, use the import script:
```powershell
# Run the import script
.\import_existing_resources.ps1
```

### Environment-Specific Deployments
```bash
# Development environment
terraform workspace new dev
terraform apply -var="environment=dev"

# Production environment
terraform workspace new prod
terraform apply -var="environment=prod" -var="django_debug=false"
```

## Resource Naming Convention

All resources follow a consistent naming pattern:
```
{project_name}-{environment}-{resource_type}
```

Examples:
- `agritrace-dev-rg` (Resource Group)
- `agritrace-prod-vnet` (Virtual Network)
- `agritrace-staging-acr` (Container Registry)

## Cost Optimization

### Development Environment
- Uses Basic SKUs for cost efficiency
- Smaller container allocations
- Shared resources where possible

### Production Environment
- Standard/Premium SKUs for performance
- Auto-scaling enabled
- High availability configurations
- Backup and disaster recovery

## Monitoring and Maintenance

### Health Checks
- Container health endpoints
- Database connectivity monitoring
- Application Gateway health probes

### Backup Strategy
- Automated database backups
- Container image versioning
- Infrastructure state backup

### Updates and Patches
- Rolling updates for containers
- Managed service automatic updates
- Security patch management

## Troubleshooting

### Common Issues
1. **Container startup failures**: Check environment variables and health checks
2. **Database connection issues**: Verify network security groups and firewall rules
3. **SSL certificate problems**: Check Key Vault permissions and certificate validity

### Debugging Commands
```bash
# Check Terraform state
terraform state list

# View resource details
terraform state show azurerm_container_group.backend

# Validate configuration
terraform validate

# Format code
terraform fmt -recursive
```

## Security Best Practices

1. **Never commit secrets**: Use Key Vault and environment variables
2. **Enable logging**: Monitor all resource access and changes
3. **Regular updates**: Keep Terraform and providers updated
4. **Access reviews**: Regularly review and rotate access keys
5. **Network segmentation**: Use private subnets and NSGs

## Contributing

When modifying the infrastructure:

1. Follow the established naming conventions
2. Add appropriate comments and documentation
3. Use variables instead of hardcoded values
4. Test changes in development environment first
5. Update this README with any new features

## Support

For infrastructure issues:
- Check Azure portal for resource status
- Review Terraform logs and state
- Consult Azure documentation
- Contact the DevOps team for assistance
