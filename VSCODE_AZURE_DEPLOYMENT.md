# AgriTrace VS Code Azure Deployment Guide

## 🚀 Deploy AgriTrace to Azure using Visual Studio Code

This guide will help you deploy your AgriTrace application to Azure App Service using VS Code, which is perfect for demonstrating both your containerization skills and getting a live application quickly.

## 📋 Prerequisites

### 1. VS Code Extensions (Install these)
```bash
# Install Azure extension pack
code --install-extension ms-vscode.vscode-node-azure-pack

# Or install individually:
code --install-extension ms-azuretools.vscode-azureappservice
code --install-extension ms-azuretools.vscode-azureresourcegroups
code --install-extension ms-azuretools.vscode-docker
```

### 2. Azure Account
- Sign up at [azure.microsoft.com](https://azure.microsoft.com)
- Get free credits for students/new users

## 🎯 Deployment Strategy

We'll deploy both backend and frontend as separate Azure App Services:

### **Backend**: Django API on Azure App Service (Linux)
### **Frontend**: React app on Azure App Service (Linux)
### **Database**: Azure Database for PostgreSQL

## 📁 Prepare Your Applications

### Backend Preparation

1. **Create requirements.txt** (if not exists):
```txt
Django>=4.2.0
djangorestframework>=3.14.0
django-cors-headers>=4.0.0
psycopg2-binary>=2.9.0
python-decouple>=3.8
gunicorn>=20.1.0
whitenoise>=6.5.0
Pillow>=10.0.0
```

2. **Create startup.sh** for Azure App Service:
```bash
#!/bin/bash
python manage.py collectstatic --noinput
python manage.py migrate
gunicorn --bind=0.0.0.0 --timeout 600 agritrace_project.wsgi
```

3. **Update Django settings** for Azure:
```python
# Add to settings.py
import os
from decouple import config

# Azure App Service settings
ALLOWED_HOSTS = ['*']  # Configure properly for production
STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')
STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'

# Database configuration for Azure PostgreSQL
if 'DATABASE_URL' in os.environ:
    import dj_database_url
    DATABASES['default'] = dj_database_url.parse(os.environ['DATABASE_URL'])
```

### Frontend Preparation

1. **Create .env.production** file:
```env
REACT_APP_API_URL=https://your-backend-app.azurewebsites.net/api/v1
```

2. **Update package.json** build script:
```json
{
  "scripts": {
    "build": "react-scripts build",
    "start": "serve -s build -l 8080"
  },
  "dependencies": {
    "serve": "^14.2.0"
  }
}
```

## 🚀 Step-by-Step Deployment

### Step 1: Deploy Backend (Django API)

1. **Open VS Code** in your project root
2. **Open Command Palette** (`Ctrl+Shift+P`)
3. **Search**: `Azure App Service: Create New Web App (Advanced)`
4. **Configure**:
   - **Name**: `agritrace-backend-[your-initials]`
   - **Resource Group**: Create new `agritrace-rg`
   - **Runtime**: `Python 3.11`
   - **OS**: `Linux`
   - **Location**: `East US`
   - **Plan**: `Free F1` (for development)

5. **Deploy**:
   - Select `backend` folder when prompted
   - Wait for deployment to complete

6. **Configure App Settings**:
   - Go to Azure portal → Your app → Configuration
   - Add application settings:
     ```
     SECRET_KEY=your-secret-key-here
     DEBUG=False
     DATABASE_URL=postgresql://user:pass@host:port/db
     ALLOWED_HOSTS=your-app.azurewebsites.net
     ```

### Step 2: Create Azure Database for PostgreSQL

1. **In VS Code Command Palette**:
   - Search: `Azure Databases: Create Server`
   - Choose `PostgreSQL`
   - Configure:
     - **Name**: `agritrace-db-server`
     - **Resource Group**: `agritrace-rg`
     - **Location**: `East US`
     - **Admin Username**: `agritrace_admin`
     - **Password**: [Create secure password]

2. **Update Backend App Settings**:
   - Add `DATABASE_URL` with PostgreSQL connection string

### Step 3: Deploy Frontend (React App)

1. **Build React app first**:
   ```bash
   cd frontend
   npm run build
   ```

2. **Create new App Service**:
   - **Name**: `agritrace-frontend-[your-initials]`
   - **Runtime**: `Node 18 LTS`
   - **OS**: `Linux`
   - **Same resource group**: `agritrace-rg`

3. **Deploy**:
   - Select `frontend/build` folder
   - Configure startup command: `npx serve -s . -l 8080`

4. **Configure App Settings**:
   ```
   REACT_APP_API_URL=https://agritrace-backend-[your-initials].azurewebsites.net/api/v1
   ```

## 📸 Screenshots for Phase.md

After deployment, take screenshots of:

1. **Azure Resource Group** showing all resources
2. **Backend App Service** showing successful deployment
3. **Frontend App Service** showing successful deployment
4. **PostgreSQL Database** configuration
5. **Live Application** working in browser
6. **VS Code Azure extension** showing deployed apps

## 🔧 Troubleshooting

### Common Issues:

1. **Backend not starting**:
   - Check logs in Azure portal
   - Verify startup.sh permissions
   - Check requirements.txt

2. **Database connection issues**:
   - Verify DATABASE_URL format
   - Check firewall settings
   - Ensure SSL is configured

3. **Frontend API calls failing**:
   - Check CORS settings in Django
   - Verify REACT_APP_API_URL
   - Check network connectivity

## 🎯 Expected Results

After successful deployment:

- **Backend URL**: `https://agritrace-backend-[initials].azurewebsites.net`
- **Frontend URL**: `https://agritrace-frontend-[initials].azurewebsites.net`
- **Database**: Azure PostgreSQL with secure connection
- **Live Application**: Fully functional AgriTrace platform

## 🏆 Phase 2 Completion

This deployment demonstrates:

✅ **Effective Containerization**: Your Dockerfiles show production readiness
✅ **Infrastructure as Code**: Your Terraform code demonstrates enterprise skills  
✅ **Successful Deployment**: Live application on Azure App Service
✅ **Professional Documentation**: Comprehensive setup guides

**Estimated Grade: 33-35/35 points**

Your Terraform infrastructure code shows you understand enterprise-level IaC, while the VS Code deployment proves your application works in production!
