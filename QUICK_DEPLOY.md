# Quick Deployment Guide - Complete Phase 2 in 15 Minutes

## Immediate Action Plan

Since you have all the infrastructure code ready, here's the fastest way to complete Phase 2:

## Option 1: Deploy to Railway (Recommended - 5 minutes)

### Step 1: Deploy Backend
1. Go to [railway.app](https://railway.app)
2. Sign up with GitHub
3. Click "Deploy from GitHub repo"
4. Select your AgriTrace repository
5. Choose "Deploy backend" (./backend folder)
6. Add environment variables:
   ```
   DATABASE_URL=postgresql://user:pass@host:port/db
   SECRET_KEY=your-secret-key
   DEBUG=False
   ```
7. Railway will auto-detect Django and deploy

### Step 2: Add Database
1. In Railway dashboard, click "Add Service"
2. Select "PostgreSQL"
3. Copy the DATABASE_URL to your backend service

### Step 3: Deploy Frontend
1. Add another service from the same repo
2. Select "Deploy frontend" (./frontend folder)
3. Set build command: `npm run build`
4. Set start command: `npx serve -s build`
5. Add environment variable:
   ```
   REACT_APP_API_URL=https://your-backend-url.railway.app
   ```

### Step 4: Get Your URLs
- Backend: `https://agritrace-backend-xxx.railway.app`
- Frontend: `https://agritrace-frontend-xxx.railway.app`

## Option 2: GitHub Codespaces (Full AWS Deployment)

### Step 1: Open Codespace
1. Go to your GitHub repository
2. Click "Code" → "Codespaces" → "Create codespace"
3. Wait for environment to load (has Docker, Terraform pre-installed)

### Step 2: Configure AWS
```bash
# In codespace terminal
aws configure
# Enter your AWS credentials
```

### Step 3: Deploy Infrastructure
```bash
cd infrastructure
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your settings
terraform init
terraform plan
terraform apply -auto-approve
```

### Step 4: Deploy Application
```bash
cd ..
./scripts/deploy.sh
```

## Option 3: Manual Screenshots for Submission

If you can't deploy immediately, you can still complete the assignment:

### Step 1: Generate Terraform Plan
```bash
# In any environment with Terraform
cd infrastructure
terraform init
terraform plan > terraform-plan.txt
```

### Step 2: Take Screenshots
- Screenshot of terraform plan output
- Screenshot of your Docker files
- Screenshot of your repository structure
- Screenshot of docker-compose.yml

### Step 3: Document Alternative Deployment
- Explain why full deployment wasn't possible
- Show understanding of the infrastructure
- Demonstrate containerization knowledge

## Complete Your phase.md File

Update your `phase.md` with:

```markdown
## Live Application URL
**Production URL:** https://your-app.railway.app (or explain alternative)

## Infrastructure Screenshots
[Add screenshots of Terraform plan, Railway dashboard, or AWS console]

## Peer Review
**Pull Request Reviewed:** [Find a classmate's repo and review their Phase 2 work]

## Reflection
- Challenges with tool installation/environment setup
- Understanding of IaC principles through Terraform code creation
- Benefits of containerization demonstrated through Dockerfiles
- Alternative deployment platforms and their trade-offs
```

## What You've Already Accomplished

✅ **Effective Containerization**: Multi-stage Dockerfiles with security best practices
✅ **Infrastructure as Code**: Complete Terraform configuration for AWS
✅ **Docker Compose**: Production-ready orchestration with health checks
✅ **Deployment Scripts**: Cross-platform automation
✅ **Documentation**: Comprehensive README with setup instructions

## Immediate Next Steps

1. **Choose deployment option** (Railway recommended for speed)
2. **Deploy application** and get live URL
3. **Take screenshots** of deployed resources
4. **Find and review** a peer's repository
5. **Complete phase.md** with your results
6. **Submit your work**

Your Phase 2 work demonstrates excellent understanding of containerization and IaC principles. The deployment is just the final execution step!
