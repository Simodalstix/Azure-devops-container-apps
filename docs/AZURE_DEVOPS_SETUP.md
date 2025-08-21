# Azure DevOps Setup Guide

## Overview
This guide walks through setting up the enterprise-grade Azure DevOps pipeline with proper compliance, approvals, and change management.

## Prerequisites
- Azure DevOps organization
- Azure subscriptions (dev, staging, prod)
- Azure CLI access
- Terraform backend storage account

## 1. Service Connections Setup

### Create Service Principals
```bash
# Development environment
az ad sp create-for-rbac --name "sp-containerapp-dev" \
  --role="Contributor" \
  --scopes="/subscriptions/DEV_SUBSCRIPTION_ID"

# Staging environment  
az ad sp create-for-rbac --name "sp-containerapp-staging" \
  --role="Contributor" \
  --scopes="/subscriptions/STAGING_SUBSCRIPTION_ID"

# Production environment
az ad sp create-for-rbac --name "sp-containerapp-prod" \
  --role="Contributor" \
  --scopes="/subscriptions/PROD_SUBSCRIPTION_ID"
```

### Configure Service Connections in Azure DevOps
1. Go to **Project Settings** → **Service connections**
2. Create **Azure Resource Manager** connections:
   - `azure-dev-connection`
   - `azure-staging-connection` 
   - `azure-prod-connection`
   - `acr-connection`

## 2. Variable Groups Setup

Create these variable groups in **Pipelines** → **Library**:

### terraform-backend
- `tfStateResourceGroup`: rg-terraform-state
- `tfStateStorageAccount`: sttfstatedevops001
- `tfStateContainer`: tfstate

### container-registry
- `acrName`: acrcontainerappdevops001

### Environment-specific groups
- `dev-environment`
- `staging-environment`
- `prod-environment`

## 3. Environment Setup

Create environments in **Pipelines** → **Environments**:

### Development Environment
- Name: `dev`
- No approvals required
- Auto-deploy on successful build

### Staging Environment  
- Name: `staging`
- Required approvers: DevOps Team
- Timeout: 1 hour

### Production Environment
- Name: `production`
- Required approvers: DevOps Team, Security Team, Product Owner
- Timeout: 24 hours
- Business hours only: Yes

## 4. Pipeline Creation

### Infrastructure Pipeline
1. Create new pipeline from `/.azure-pipelines/infrastructure-pipeline.yml`
2. Configure triggers for `infra/**` path changes
3. Set up branch policies for main/develop branches

### Application Pipeline
1. Create new pipeline from `/.azure-pipelines/application-pipeline.yml`
2. Configure triggers for `src/**` path changes
3. Link to container registry service connection

## 5. Branch Policies

Configure branch policies for `main` branch:

### Pull Request Requirements
- Minimum 2 reviewers
- Dismiss stale reviews
- Require code owner reviews
- Check for linked work items

### Build Validation
- Infrastructure pipeline (for infra changes)
- Application pipeline (for src changes)
- Security scanning
- Code quality checks

### Status Checks
- All builds must pass
- Security scan must pass
- No active pull request comments

## 6. Security Configuration

### Secrets Management
- Store sensitive values in Azure Key Vault
- Reference Key Vault secrets in variable groups
- Use managed identities where possible

### Least Privilege Access
- Service principals have minimal required permissions
- Environment-specific service connections
- Separate subscriptions for each environment

## 7. Monitoring Setup

### Pipeline Monitoring
- Enable build notifications
- Set up failure alerts
- Configure deployment dashboards

### Infrastructure Monitoring
- Application Insights integration
- Log Analytics workspace
- Custom dashboards and alerts

## 8. Compliance Features

### Audit Trail
- All deployments logged
- Approval history maintained
- Change tracking enabled

### Change Management
- Required approvals for production
- Business hours deployment windows
- Rollback procedures documented

### Security Scanning
- Terraform security scanning (Checkov)
- Container image scanning
- Dependency vulnerability scanning

## 9. Testing Strategy

### Development Environment
- Automated deployment on develop branch
- Integration testing
- Performance baseline testing

### Staging Environment
- Production-like configuration
- User acceptance testing
- Load testing
- Security testing

### Production Environment
- Manual approval required
- Blue-green deployment capability
- Immediate rollback procedures

## 10. Operational Procedures

### Deployment Process
1. Feature development on feature branch
2. Pull request to develop branch
3. Automated deployment to dev environment
4. Merge to main branch triggers staging deployment
5. Manual approval for production deployment

### Incident Response
1. Immediate rollback capability
2. Automated alerting
3. Incident tracking integration
4. Post-incident review process

### Maintenance Windows
- Scheduled maintenance notifications
- Automated backup procedures
- Health check validation
- Service restoration verification