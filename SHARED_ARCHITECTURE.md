# Shared Resources Architecture

## Overview
The project now uses a **shared resources pattern** for enterprise-grade cost efficiency and centralized management.

## Architecture Changes

### Shared Resources (Single Instance)
- **Container Registry (ACR)**: `acrcontainerappdevops001`
- **Log Analytics Workspace**: `law-containerapp-shared-aue`
- **Application Insights**: `ai-containerapp-shared-aue`
- **Action Groups**: `ag-containerapp-shared-aue`
- **Terraform State Storage**: `sttfstatedevops001`

### Environment-Specific Resources
- **Resource Groups**: Separate per environment
- **Key Vault**: Environment-specific secrets
- **Container Apps Environment**: Isolated per environment
- **API Service Instances**: Separate scaling per environment

## Deployment Order

1. **Deploy Shared Infrastructure First**:
   ```bash
   # Run shared-infrastructure-pipeline.yml
   cd infra/shared-infrastructure
   terraform apply
   ```

2. **Deploy Environment-Specific Infrastructure**:
   ```bash
   # Run infrastructure-pipeline.yml for each environment
   # Dev → Staging → Production
   ```

## Benefits

### Cost Efficiency
- **Single ACR** instead of 3 (saves ~$150/month)
- **Centralized Log Analytics** (consolidated billing)
- **Shared monitoring** infrastructure

### Operational Excellence
- **Consistent container images** across environments
- **Centralized vulnerability scanning**
- **Unified monitoring dashboards**
- **Single point of image governance**

### Security
- **Centralized access control** for container registry
- **Consistent security policies** across environments
- **Audit trail** for all image deployments

## Configuration

### Shared Infrastructure Variables
```hcl
# infra/shared-infrastructure/terraform.tfvars
admin_email = "admin@yourcompany.com"
log_retention_days = 90
```

### Environment References
Each environment now references shared resources:
```hcl
# Environment configurations reference shared resources
shared_resource_group_name = "rg-containerapp-shared-aue"
shared_acr_name = "acrcontainerappdevops001"
shared_log_analytics_name = "law-containerapp-shared-aue"
shared_application_insights_name = "ai-containerapp-shared-aue"
```

## Pipeline Updates

### New Pipeline: Shared Infrastructure
- **File**: `.azure-pipelines/shared-infrastructure-pipeline.yml`
- **Trigger**: Changes to `infra/shared-infrastructure/**`
- **Deployment**: Must run before environment pipelines

### Updated Environment Pipelines
- **Dependencies**: Now reference shared resources via data sources
- **Reduced complexity**: No longer create ACR, Log Analytics, App Insights
- **Faster deployments**: Less resources to provision per environment