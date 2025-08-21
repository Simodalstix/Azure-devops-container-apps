# Quick Start Guide

Get your Azure Container Apps platform running in 15 minutes.

## Prerequisites

- Azure CLI installed and logged in
- Jenkins server with required plugins
- Git repository access

## Step 1: Azure Setup (5 minutes)

```bash
# Login to Azure
az login

# Create Service Principal
az ad sp create-for-rbac --name "terraform-sp" --role="Contributor" --scopes="/subscriptions/YOUR_SUBSCRIPTION_ID"

# Save the output - you'll need:
# - appId (CLIENT_ID)
# - password (CLIENT_SECRET)
# - tenant (TENANT_ID)

# Create Terraform state storage
az group create --name "rg-terraform-state" --location "australiaeast"
az storage account create --name "sttfstatedevops001" --resource-group "rg-terraform-state" --location "australiaeast" --sku "Standard_LRS"
az storage container create --name "tfstate" --account-name "sttfstatedevops001"
```

## Step 2: Jenkins Configuration (5 minutes)

1. **Add Credentials** in Jenkins (Manage Jenkins → Manage Credentials):

   - `azure-client-id`: Your Service Principal appId
   - `azure-client-secret`: Your Service Principal password
   - `azure-tenant-id`: Your tenant ID
   - `azure-subscription-id`: Your subscription ID
   - `admin-email`: Your email for alerts

2. **Install Plugins**:
   - Azure Credentials Plugin
   - Terraform Plugin
   - Pipeline Plugin

## Step 3: Configure Environment (2 minutes)

```bash
# Clone this repository
git clone <your-repo-url>
cd Azure-container-apps-jenkins

# Configure dev environment
cd infra/envs/dev
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars - only required field:
admin_email = "your-email@company.com"
```

## Step 4: Deploy (3 minutes)

### Option A: Jenkins Pipeline (Recommended)

1. Create new Pipeline job in Jenkins
2. Set Pipeline from SCM → Point to your repository
3. Script Path: `ci/Jenkinsfile`
4. Build with Parameters:
   - Environment: `dev`
   - Destroy: `false`
5. Review plan and approve

### Option B: Command Line

```bash
cd infra/envs/dev
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

## Step 5: Verify Deployment

```bash
# Get the container app URL from outputs
terraform output container_app_url

# Test the API
curl https://your-container-app-url/health
```

## What You Get

- **Container App**: Auto-scaling API service
- **Monitoring**: CPU, memory, error rate alerts
- **Security**: Key Vault integration, private registry
- **CI/CD**: Full Jenkins pipeline with quality gates

## Next Steps

- Deploy to production: Change environment to `prod` in Jenkins
- Customize monitoring: Edit `monitoring/kusto-queries.kql`
- Deploy your app: Update `container_image` in terraform.tfvars
- View dashboard: Import `monitoring/azure-dashboard.json`

## Troubleshooting

**Pipeline fails?** Check Jenkins credentials and Azure permissions.

**Container not starting?** Verify the container image exists and health endpoints work.

**Need help?** See the full [README.md](README.md) for detailed documentation.

---

**Total time: ~15 minutes** | **Resources created: ~12 Azure resources**
