# Getting Started - Azure Container Apps Platform

**Complete setup guide from zero to running platform in 10 minutes.**

## Prerequisites (2 minutes)

1. **Azure CLI** installed and logged in:
   ```bash
   az login
   ```

2. **Terraform** installed (v1.0+):
   ```bash
   terraform --version
   ```

3. **Set Azure credentials**:
   ```bash
   # Create Service Principal (one-time setup)
   az ad sp create-for-rbac --name "terraform-sp" --role="Contributor" --scopes="/subscriptions/$(az account show --query id -o tsv)"
   
   # Set environment variables (copy from output above)
   export ARM_CLIENT_ID="your-appId"
   export ARM_CLIENT_SECRET="your-password"
   export ARM_TENANT_ID="your-tenant"
   export ARM_SUBSCRIPTION_ID="$(az account show --query id -o tsv)"
   ```

## Step 1: Configure Project (2 minutes)

```bash
# Clone and navigate
git clone <your-repo>
cd Azure-container-apps-jenkins

# Configure shared infrastructure
cd infra/shared-infrastructure
cp terraform.tfvars.example terraform.tfvars
# Edit: admin_email = "your-email@company.com"

# Configure dev environment  
cd ../envs/dev
cp terraform.tfvars.example terraform.tfvars
# Edit: admin_email = "your-email@company.com"
```

## Step 2: Deploy Shared Infrastructure (3 minutes)

```bash
cd ../../shared-infrastructure
terraform init
terraform plan
terraform apply -auto-approve
```

**What this creates:**
- Container Registry (shared across environments)
- Log Analytics Workspace (centralized logging)
- Application Insights (monitoring)
- Action Groups (alerting)

## Step 3: Deploy Development Environment (3 minutes)

```bash
cd ../envs/dev
terraform init
terraform plan
terraform apply -auto-approve
```

**What this creates:**
- Container Apps Environment
- Sample API service
- Key Vault (dev-specific)
- Monitoring alerts

## Step 4: Test Your Deployment (1 minute)

```bash
# Get the app URL
APP_URL=$(terraform output -raw container_app_fqdn)
echo "Your app is running at: https://$APP_URL"

# Test the API
curl "https://$APP_URL/health"
curl "https://$APP_URL/api/info"
```

## That's It! 🎉

You now have:
- ✅ **Running Container App** with auto-scaling
- ✅ **Shared monitoring** and logging
- ✅ **Security** with Key Vault integration
- ✅ **Enterprise architecture** with proper resource separation

## Next Steps

- **Deploy to staging/prod**: Repeat Step 3 with `../envs/staging` or `../envs/prod`
- **Set up Azure DevOps**: Follow [docs/AZURE_DEVOPS_SETUP.md](docs/AZURE_DEVOPS_SETUP.md) for full enterprise pipeline
- **Deploy your own app**: Update `container_image` in terraform.tfvars

## Troubleshooting

**Terraform fails?** 
- Check Azure credentials: `az account show`
- Verify permissions: Your Service Principal needs Contributor access

**Container not starting?**
- Check logs: `az containerapp logs show --name ca-api-dev-aue --resource-group rg-containerapp-dev-aue`

**Need help?** See [README.md](README.md) for detailed documentation.

---

**Total time: ~10 minutes** | **Cost: ~$20/month for dev environment**