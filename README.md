# AgriTrace - Phase 3: Full Automated Deployment

[![CI/CD Pipeline](https://github.com/renoir01/AgriTrace/workflows/AgriTrace%20CI/CD%20Pipeline/badge.svg)](https://github.com/renoir01/AgriTrace/actions)
[![Security Scan](https://img.shields.io/badge/security-scanned-green.svg)](https://github.com/renoir01/AgriTrace/actions)
[![Deployment](https://img.shields.io/badge/deployment-automated-blue.svg)](https://github.com/renoir01/AgriTrace/actions)

Agricultural supply chain traceability platform - bringing transparency from farm to consumer.

## 🌐 Live Application URLs

### Production Environment
- **Frontend**: https://agritrace-prod.eastus.azurecontainer.io
- **Backend API**: https://agritrace-api.eastus.azurecontainer.io:8000
- **API Documentation**: https://agritrace-api.eastus.azurecontainer.io:8000/swagger/
- **Admin Panel**: https://agritrace-api.eastus.azurecontainer.io:8000/admin/
- **Health Check**: https://agritrace-api.eastus.azurecontainer.io:8000/api/health/

### Staging Environment
- **Frontend**: https://agritrace-staging.eastus.azurecontainer.io
- **Backend API**: https://agritrace-staging-api.eastus.azurecontainer.io:8000
- **API Documentation**: https://agritrace-staging-api.eastus.azurecontainer.io:8000/swagger/
- **Health Check**: https://agritrace-staging-api.eastus.azurecontainer.io:8000/api/health/

## 🎥 Video Demonstration

**Phase 3 Video Demonstration**: [Video Link - To be uploaded]

*Professional video demonstration showcasing the complete CI/CD pipeline, security scanning, automated deployment, and monitoring system functionality.*

## Project Overview

AgriTrace is a comprehensive platform designed to enhance transparency and traceability in agricultural supply chains. By leveraging modern technology, AgriTrace connects farmers, distributors, retailers, and consumers in a transparent ecosystem that tracks agricultural products from their origin to the end consumer.

### Key Features

- **Farm Registration & Management**: Register farms, track production practices, and manage certifications
- **Product Traceability**: Track agricultural products through the entire supply chain with unique identifiers
- **Quality Assurance**: Record and verify quality checks at each stage of the supply chain
- **Consumer Interface**: Allow consumers to scan products and view their complete journey
- **Analytics Dashboard**: Gain insights into supply chain efficiency and sustainability metrics
- **Blockchain Integration**: Ensure data integrity and immutability of supply chain records

## Technology Stack

### Core Application
- **Backend**: Python/Django REST Framework
- **Frontend**: React.js with Material-UI
- **Database**: PostgreSQL Flexible Server
- **Authentication**: JWT (JSON Web Tokens)
- **Containerization**: Docker with multi-stage builds

### DevOps & Infrastructure
- **CI/CD Pipeline**: GitHub Actions with automated deployment
- **Container Registry**: Azure Container Registry (ACR)
- **Cloud Platform**: Microsoft Azure
- **Infrastructure as Code**: Terraform
- **Container Orchestration**: Azure Container Instances (ACI)
- **Load Balancing**: Azure Application Gateway
- **Monitoring**: Azure Monitor with custom dashboards
- **Security Scanning**: 
  - Dependency scanning with Safety (Python)
  - Container image scanning with Trivy
  - NPM audit for frontend dependencies

### Deployment Architecture
- **Production**: Azure Container Instances with Application Gateway
- **Staging**: Separate container instances for testing
- **Database**: Azure PostgreSQL Flexible Server with private networking
- **Storage**: Azure Container Registry for secure image storage
- **Networking**: Virtual Network with private subnets and NSG rules

## Project Structure

```
AgriTrace/
├── backend/            # Django REST API
├── frontend/           # React.js web application
├── mobile/             # Mobile application (React Native)
├── docs/               # Documentation
├── infrastructure/     # IaC (Infrastructure as Code)
└── scripts/            # Utility scripts
```

## Getting Started

### Prerequisites

**For Docker Development (Recommended):**

- Docker Desktop
- Docker Compose
- Git

**For Local Development:**

- Python 3.10+
- Node.js 18+
- PostgreSQL 14+
- Redis 7+

**For Cloud Deployment:**

- AWS CLI
- Terraform 1.0+
- Docker

### Quick Start with Docker

1. **Clone the repository**

   ```bash
   git clone https://github.com/renoir01/AgriTrace.git
   cd AgriTrace
   ```

1. **Set up environment variables**

   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

1. **Build and start the application**

   ```bash
   # Build images locally (optional)
   ./scripts/build-local.sh  # Linux/Mac
   # or
   .\scripts\build-local.ps1  # Windows PowerShell
   
   # Start all services
   docker-compose up -d
   ```

1. **Access the application**
   - Frontend: <http://localhost:3000>
   - Backend API: <http://localhost:8000>
   - Admin Panel: <http://localhost:8000/admin>

### Development Setup

#### Using Docker Compose (Recommended)

The Docker Compose setup includes:
- **PostgreSQL 14** with health checks
- **Redis 7** for caching and sessions
- **Django Backend** with hot reload
- **React Frontend** with hot reload
- **Optimized networking** and dependency management

```bash
# Start development environment
docker-compose up

# View logs
docker-compose logs -f backend
docker-compose logs -f frontend

# Run database migrations
docker-compose exec backend python manage.py migrate

# Create superuser
docker-compose exec backend python manage.py createsuperuser

# Run tests
docker-compose exec backend python manage.py test
docker-compose exec frontend npm test
```

## Cloud Deployment

### Prerequisites for Cloud Deployment

1. **AWS Account** with appropriate permissions
2. **AWS CLI** configured with your credentials
3. **Terraform** installed (version 1.0+)
4. **Docker** for building and pushing images

### Infrastructure Provisioning

1. **Configure Terraform variables**

   ```bash
   cd infrastructure
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your specific configuration
   ```

2. **Deploy infrastructure**

   ```bash
   # Initialize Terraform
   terraform init
   
   # Plan the deployment
   terraform plan
   
   # Apply the infrastructure
   terraform apply
   ```

### Application Deployment

#### Automated Deployment (Recommended)

```bash
# Linux/Mac
./scripts/deploy.sh

# Windows PowerShell
.\scripts\deploy.ps1
```

#### Manual Deployment Steps

1. **Build and push Docker images**

   ```bash
   # Get ECR login token
   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com
   
   # Build and tag images
   docker build -t agritrace-backend ./backend
   docker build -t agritrace-frontend ./frontend
   
   # Tag for ECR
   docker tag agritrace-backend:latest <ecr-backend-uri>:latest
   docker tag agritrace-frontend:latest <ecr-frontend-uri>:latest
   
   # Push to ECR
   docker push <ecr-backend-uri>:latest
   docker push <ecr-frontend-uri>:latest
   ```

2. **Update ECS services**

   ```bash
   # Force new deployment
   aws ecs update-service --cluster agritrace-dev-cluster --service agritrace-dev-backend --force-new-deployment
   aws ecs update-service --cluster agritrace-dev-cluster --service agritrace-dev-frontend --force-new-deployment
   ```

### Environment Configuration

Create a `.env` file based on `.env.example`:

```env
# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=agritrace
DB_USER=postgres
DB_PASSWORD=postgres

# Django Configuration
SECRET_KEY=your-secret-key-here
DEBUG=False
ALLOWED_HOSTS=localhost,127.0.0.1,your-domain.com

# Redis Configuration
REDIS_URL=redis://localhost:6379/0

# AWS Configuration (for production)
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_STORAGE_BUCKET_NAME=your-s3-bucket
AWS_S3_REGION_NAME=us-east-1
```

### Local Development Setup

1. **Clone the repository**

```bash
git clone https://github.com/renoir01/AgriTrace.git
cd AgriTrace
```

2. **Set up the backend**

```bash
cd backend
python -m venv venv
venv\Scripts\activate  # On Windows
source venv/bin/activate  # On Unix/macOS
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

3. **Set up the frontend**

```bash
cd frontend
npm install
npm start
```

4. **Access the application**

Open your browser and navigate to http://localhost:3000

### Docker Setup

```bash
docker-compose up -d
```

## Contributing

1. Create a feature branch from `develop`
2. Make your changes
3. Submit a pull request to the `develop` branch
4. Ensure CI checks pass
5. Request a code review

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Project Board

[AgriTrace Project Board](https://github.com/renoir01/AgriTrace/projects)
