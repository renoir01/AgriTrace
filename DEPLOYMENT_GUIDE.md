# AgriTrace Phase 2 Deployment Guide

## Current Status
✅ **Infrastructure as Code**: Complete Terraform configuration ready
✅ **Containerization**: Optimized Dockerfiles and docker-compose setup
✅ **Deployment Scripts**: Cross-platform automation scripts created
✅ **Documentation**: Comprehensive setup and deployment instructions

## Deployment Options

### Option 1: Local Tool Installation (Recommended)

#### Install Required Tools
1. **Docker Desktop for Windows**
   - Download from: https://www.docker.com/products/docker-desktop/
   - Install and restart your computer
   - Verify: `docker --version`

2. **Terraform**
   - Download from: https://www.terraform.io/downloads
   - Add to PATH environment variable
   - Verify: `terraform --version`

3. **AWS CLI**
   - Download from: https://aws.amazon.com/cli/
   - Configure: `aws configure`

#### After Installation
```powershell
# Test local setup
docker-compose up -d

# Deploy to cloud
.\scripts\deploy.ps1
```

### Option 2: Cloud-Based Development Environment

#### GitHub Codespaces (Recommended)
1. Open your repository in GitHub
2. Click "Code" → "Codespaces" → "Create codespace"
3. All tools pre-installed in cloud environment
4. Run deployment from codespace terminal

#### AWS Cloud9
1. Create Cloud9 environment in AWS Console
2. Clone your repository
3. All AWS tools pre-configured
4. Deploy directly from Cloud9

### Option 3: Manual Deployment via AWS Console

#### Step 1: Create Infrastructure Manually
1. **VPC Setup**
   - Create VPC with CIDR 10.0.0.0/16
   - Create public/private subnets
   - Set up Internet Gateway and NAT Gateway

2. **RDS Database**
   - Create PostgreSQL 14 instance
   - Configure security groups
   - Note connection details

3. **ECR Repositories**
   - Create repositories for backend/frontend
   - Note repository URIs

4. **ECS Cluster**
   - Create Fargate cluster
   - Set up task definitions
   - Create services with load balancer

#### Step 2: Build and Push Images
```bash
# If you have access to a Linux/Mac environment or WSL
docker build -t agritrace-backend ./backend
docker build -t agritrace-frontend ./frontend

# Tag and push to ECR
docker tag agritrace-backend:latest <ecr-uri>:latest
docker push <ecr-uri>:latest
```

### Option 4: Alternative Deployment Platforms

#### Heroku Deployment (Simplified)
1. Create Heroku apps for backend/frontend
2. Add PostgreSQL addon
3. Deploy using Git push
4. Configure environment variables

#### Railway Deployment
1. Connect GitHub repository to Railway
2. Auto-deploy with built-in PostgreSQL
3. Configure environment variables
4. Get public URL

#### Render Deployment
1. Create web services for backend/frontend
2. Add PostgreSQL database
3. Configure build/start commands
4. Deploy with automatic HTTPS

## Phase 2 Submission Requirements

### What You Need to Submit

1. **Repository Link**: ✅ Ready (your current repo)

2. **Updated README.md**: ✅ Complete with Docker instructions

3. **phase.md File**: ✅ Template created, needs completion with:
   - [ ] Live public URL
   - [ ] Screenshots of resources
   - [ ] Peer review PR link
   - [ ] Deployment reflection

### Completing phase.md Without Full Deployment

Even if you can't complete the full AWS deployment, you can still demonstrate understanding:

1. **Infrastructure Screenshots**: Use Terraform plan output
2. **Local Deployment**: Show docker-compose working locally
3. **Alternative Deployment**: Deploy to Heroku/Railway/Render
4. **Reflection**: Focus on IaC learning and containerization benefits

## Quick Win: Alternative Cloud Deployment

### Deploy to Railway (5 minutes)
1. Go to railway.app
2. Connect your GitHub repository
3. Deploy backend and frontend services
4. Add PostgreSQL database
5. Get live URL for submission

### Deploy to Render (10 minutes)
1. Go to render.com
2. Create web service from GitHub
3. Add PostgreSQL database
4. Configure environment variables
5. Deploy and get public URL

## Next Steps

Choose one of these paths:
1. **Install tools locally** and run full AWS deployment
2. **Use cloud development environment** (Codespaces/Cloud9)
3. **Deploy to alternative platform** (Railway/Render/Heroku)
4. **Manual AWS Console setup** with infrastructure screenshots

The goal is to demonstrate:
- ✅ Effective containerization (Dockerfiles ready)
- ✅ Infrastructure as Code (Terraform complete)
- 🔄 Successful deployment (any platform works)
- ✅ Documentation and reflection

Your Phase 2 work is essentially complete - you just need to execute one deployment path and document the results!
