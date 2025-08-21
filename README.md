# Azure Container Apps with Terraform + Azure DevOps Enterprise Pipeline

A comprehensive, production-ready Azure Container Apps platform built with Terraform Infrastructure as Code (IaC) and automated through Azure DevOps pipelines. This project demonstrates enterprise-grade best practices for deploying containerized applications on Azure with proper compliance, change management, monitoring, and security.

## Getting Started

**New to this project?** Start with the [Quick Start Guide](QUICK_START.md) to get running in 15 minutes.

**Need detailed information?** Continue reading this comprehensive documentation.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                                Azure Subscription                                │
├─────────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────────────┐         │
│  │ Dev Environment │  │Staging Environment│  │   Prod Environment      │         │
│  │  ┌─────────────────────┐│    │ ┌─────────────────────┐ │                     │
│  │  │   Resource Group    ││    │ │   Resource Group    │ │                     │
│  │  │                     ││    │ │                     │ │                     │
│  │  │ ┌─────────────────┐ ││    │ │ ┌─────────────────┐ │ │                     │
│  │  │ │ Container Apps  │ ││    │ │ │ Container Apps  │ │ │                     │
│  │  │ │   Environment   │ ││    │ │ │   Environment   │ │ │                     │
│  │  │ │                 │ ││    │ │ │                 │ │ │                     │
│  │  │ │ ┌─────────────┐ │ ││    │ │ │ ┌─────────────┐ │ │ │                     │
│  │  │ │ │ API Service │ │ ││    │ │ │ │ API Service │ │ │ │                     │
│  │  │ │ │   (1-3x)    │ │ ││    │ │ │ │   (2-10x)   │ │ │ │                     │
│  │  │ │ └─────────────┘ │ ││    │ │ │ └─────────────┘ │ │ │                     │
│  │  │ └─────────────────┘ ││    │ │ └─────────────────┘ │ │                     │
│  │  │                     ││    │ │                     │ │                     │
│  │  │ ┌─────────────────┐ ││    │ │ ┌─────────────────┐ │ │                     │
│  │  │ │ Container       │ ││    │ │ │ Container       │ │ │                     │
│  │  │ │ Registry (ACR)  │ ││    │ │ │ Registry (ACR)  │ │ │                     │
│  │  │ └─────────────────┘ ││    │ │ └─────────────────┘ │ │                     │
│  │  │                     ││    │ │                     │ │                     │
│  │  │ ┌─────────────────┐ ││    │ │ ┌─────────────────┐ │ │                     │
│  │  │ │ Key Vault       │ ││    │ │ │ Key Vault       │ │ │                     │
│  │  │ └─────────────────┘ ││    │ │ └─────────────────┘ │ │                     │
│  │  │                     ││    │ │                     │ │                     │
│  │  │ ┌─────────────────┐ ││    │ │ ┌─────────────────┐ │ │                     │
│  │  │ │ Log Analytics   │ ││    │ │ │ Log Analytics   │ │ │                     │
│  │  │ │ Workspace       │ ││    │ │ │ Workspace       │ │ │                     │
│  │  │ └─────────────────┘ ││    │ │ └─────────────────┘ │ │                     │
│  │  │                     ││    │ │                     │ │                     │
│  │  │ ┌─────────────────┐ ││    │ │ ┌─────────────────┐ │ │                     │
│  │  │ │ Application     │ ││    │ │ │ Application     │ │ │                     │
│  │  │ │ Insights        │ ││    │ │ │ Insights        │ │ │                     │
│  │  │ └─────────────────┘ ││    │ │ └─────────────────┘ │ │                     │
│  │  └─────────────────────┘│    │ └─────────────────────┘ │                     │
│  └─────────────────────────┘    └─────────────────────────┘                     │
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │                        Shared Resources                                 │   │
│  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────────────┐ │   │
│  │  │ Storage Account │  │ Action Groups   │  │ Azure Dashboard         │ │   │
│  │  │ (Terraform      │  │ (Alerts)        │  │ (Monitoring)            │ │   │
│  │  │  State)         │  │                 │  │                         │ │   │
│  │  └─────────────────┘  └─────────────────┘  └─────────────────────────┘ │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│                         Enterprise CI/CD Pipeline                              │
├─────────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐      │
│  │   GitHub    │───▶│Azure DevOps │───▶│  Terraform  │───▶│   Azure     │      │
│  │ Repository  │    │  Pipelines  │    │   Apply     │    │ Container   │      │
│  │             │    │             │    │             │    │    Apps     │      │
│  └─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘      │
│                           │                                                     │
│                           ▼                                                     │
│                    ┌─────────────┐                                             │
│                    │Enterprise   │                                             │
│                    │Quality Gates│                                             │
│                    │ • TFLint    │                                             │
│                    │ • Checkov   │                                             │
│                    │ • Compliance│                                             │
│                    │ • Approvals │                                             │
│                    └─────────────┘                                             │
└─────────────────────────────────────────────────────────────────────────────────┘
```

## Features

### Infrastructure

- **Multi-Environment Support**: Separate dev and prod environments with shared modules
- **Azure Container Apps**: Serverless container platform with auto-scaling
- **Azure Container Registry**: Private container registry with admin access
- **Key Vault Integration**: Secure secret management
- **Log Analytics & Application Insights**: Comprehensive monitoring and observability

### Security

- **Least Privilege Access**: Service Principal with minimal required permissions
- **Secret Management**: All sensitive data stored in Azure Key Vault
- **Network Security**: Private container registry and secure ingress
- **Security Scanning**: Checkov integration for infrastructure security

### Monitoring & Alerting

- **Real-time Monitoring**: CPU, memory, request rate, error rate tracking
- **Proactive Alerting**: Email notifications for critical issues
- **Custom Dashboards**: Azure Dashboard with key metrics
- **Health Checks**: Liveness and readiness probes

### Enterprise CI/CD Pipeline

- **Infrastructure as Code**: Terraform with proper state management
- **Multi-Environment**: Dev → Staging → Production workflow
- **Quality Gates**: Format checking, linting, security scanning
- **Compliance**: Manual approvals, change management, audit trails
- **Security**: Least privilege access, secret management
- **Automated Testing**: Post-deployment validation

## Project Structure

```
├── infra/                          # Terraform infrastructure code
│   ├── modules/                    # Reusable Terraform modules
│   │   ├── shared/                 # Shared infrastructure components
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   ├── container-app/          # Container Apps module
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   └── monitoring/             # Monitoring and alerting module
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       └── outputs.tf
│   └── envs/                       # Environment-specific configurations
│       ├── dev/                    # Development environment
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   ├── outputs.tf
│       │   └── terraform.tfvars.example
│       ├── staging/                # Staging environment
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   ├── outputs.tf
│       │   └── terraform.tfvars.example
│       └── prod/                   # Production environment
│           ├── main.tf
│           ├── variables.tf
│           ├── outputs.tf
│           └── terraform.tfvars.example
├── .azure-pipelines/               # Azure DevOps pipeline configuration
│   ├── infrastructure-pipeline.yml # Infrastructure deployment pipeline
│   ├── application-pipeline.yml    # Application deployment pipeline
│   ├── templates/                  # Reusable pipeline templates
│   ├── variable-groups.yml         # Variable group configurations
│   └── branch-policies.yml         # Branch protection policies
├── monitoring/                     # Monitoring and observability
│   ├── azure-dashboard.json        # Azure Dashboard configuration
│   └── kusto-queries.kql          # KQL queries for monitoring
├── src/                            # Sample Node.js application (12-factor compliant)
│   ├── server.js                   # Express.js API server
│   ├── package.json               # Node.js dependencies
│   └── Dockerfile                 # Container image definition
├── docs/                           # Documentation
│   └── AZURE_DEVOPS_SETUP.md      # Azure DevOps setup guide
└── README.md                      # This file
```

## Prerequisites

### Required Tools

- **Azure CLI** (v2.50+)
- **Terraform** (v1.0+)
- **Azure DevOps** organization
- **Docker** (v20.10+)
- **Node.js** (v18+) - for sample application

### Azure Resources

- Azure Subscriptions (dev, staging, prod) with Contributor access
- Azure Service Principals for each environment
- Storage Account for Terraform state
- Azure Container Registry

### Azure DevOps Setup

- Service connections for each environment
- Variable groups for configuration
- Environment approvals and gates
- Branch policies and protection rules

## Quick Start

### 1. Azure Service Principal Setup

Create a Service Principal for Terraform authentication:

```bash
# Login to Azure
az login

# Create Service Principal
az ad sp create-for-rbac --name "terraform-sp" --role="Contributor" --scopes="/subscriptions/YOUR_SUBSCRIPTION_ID"

# Note down the output:
# - appId (CLIENT_ID)
# - password (CLIENT_SECRET)
# - tenant (TENANT_ID)
```

### 2. Azure DevOps Configuration

#### Create Service Connections:

1. Go to **Project Settings** → **Service connections**
2. Create Azure Resource Manager connections:
   - `azure-dev-connection`: Development subscription
   - `azure-staging-connection`: Staging subscription  
   - `azure-prod-connection`: Production subscription
   - `acr-connection`: Container Registry connection

#### Setup Variable Groups:

1. Go to **Pipelines** → **Library**
2. Create variable groups as defined in `variable-groups.yml`
3. Link Azure Key Vault for sensitive values

### 3. Terraform Backend Initialization

Initialize the Terraform backend storage:

```bash
# Create resource group for Terraform state
az group create --name "rg-terraform-state" --location "australiaeast"

# Create storage account
az storage account create \
  --name "sttfstatedevops001" \
  --resource-group "rg-terraform-state" \
  --location "australiaeast" \
  --sku "Standard_LRS"

# Create container
az storage container create \
  --name "tfstate" \
  --account-name "sttfstatedevops001"
```

### 4. Environment Configuration

#### Development Environment:

```bash
cd infra/envs/dev
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars with your values:
# - admin_email
# - container_image (optional, defaults to hello-world)
```

#### Production Environment:

```bash
cd infra/envs/prod
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars with your values
```

### 5. Azure DevOps Pipeline Setup

1. Create **Infrastructure Pipeline**:
   - Source: `/.azure-pipelines/infrastructure-pipeline.yml`
   - Triggers: Changes to `/infra/**`
2. Create **Application Pipeline**:
   - Source: `/.azure-pipelines/application-pipeline.yml`  
   - Triggers: Changes to `/src/**`
3. Configure environment approvals and branch policies

### 6. Deploy Infrastructure

#### Via Azure DevOps (Recommended):

1. Push changes to develop branch (deploys to dev)
2. Create PR to main branch (triggers staging)
3. Approve staging deployment
4. Approve production deployment

#### Via Command Line:

```bash
# Navigate to environment directory
cd infra/envs/dev

# Initialize Terraform
terraform init

# Plan deployment
terraform plan -out=tfplan

# Apply changes
terraform apply tfplan
```

## Monitoring and Observability

### Azure Dashboard

Import the dashboard configuration:

```bash
az portal dashboard import --input-path monitoring/azure-dashboard.json
```

### Key Metrics Monitored

- **Request Rate**: Requests per minute
- **Error Rate**: HTTP 5xx errors
- **Response Time**: P95 latency
- **CPU Usage**: Container CPU utilization
- **Replica Count**: Auto-scaling metrics
- **Alert Status**: Active alerts

### Log Analytics Queries

Use the provided KQL queries in `monitoring/kusto-queries.kql` for:

- Performance analysis
- Error investigation
- Capacity planning
- Security monitoring

## Operational Runbooks

### Secret Rotation

#### Rotate Service Principal Secret:

```bash
# Generate new secret
az ad sp credential reset --id YOUR_CLIENT_ID

# Update Azure DevOps service connections
# Update Key Vault secrets if stored there
```

#### Rotate Application Secrets:

```bash
# Update secrets in Key Vault
az keyvault secret set --vault-name "kv-containerapp-dev-aue" --name "api-key" --value "new-secret"

# Restart container app to pick up new secrets
az containerapp revision restart --name "ca-api-dev-aue" --resource-group "rg-containerapp-dev-aue"
```

### Terraform State Recovery

#### Backup State:

```bash
# Download current state
az storage blob download \
  --account-name "sttfstatedevops001" \
  --container-name "tfstate" \
  --name "dev/terraform.tfstate" \
  --file "terraform.tfstate.backup"
```

#### Restore State:

```bash
# Upload backup state
az storage blob upload \
  --account-name "sttfstatedevops001" \
  --container-name "tfstate" \
  --name "dev/terraform.tfstate" \
  --file "terraform.tfstate.backup" \
  --overwrite
```

### Alert Response

#### High CPU Usage:

1. Check current replica count
2. Review application logs for performance issues
3. Consider scaling limits adjustment
4. Investigate memory leaks or inefficient code

#### HTTP 5xx Errors:

1. Check application logs for exceptions
2. Verify external dependency health
3. Review recent deployments
4. Check resource constraints

#### Container Restarts:

1. Review container logs before restart
2. Check resource limits (CPU/memory)
3. Verify health check configuration
4. Investigate application crashes

## Security Best Practices

### Infrastructure Security

- Service Principal with minimal required permissions
- Network security groups and private endpoints
- Key Vault for all sensitive data
- Regular security scanning with Checkov

### Application Security

- Non-root container user
- Security headers (Helmet.js)
- Input validation and sanitization
- Regular dependency updates

### Operational Security

- Encrypted Terraform state storage
- Audit logging enabled
- Regular access reviews
- Incident response procedures

## Testing

### Infrastructure Testing

```bash
# Validate Terraform configuration
terraform validate

# Security scanning
checkov -d infra/

# Linting
tflint infra/
```

### Application Testing

```bash
cd sample-app

# Install dependencies
npm install

# Run tests
npm test

# Build and test container
docker build -t test-app .
docker run -p 3000:3000 test-app
```

## Troubleshooting

### Common Issues

#### Terraform State Lock:

```bash
# Force unlock (use with caution)
terraform force-unlock LOCK_ID
```

#### Container App Not Starting:

1. Check container logs: `az containerapp logs show`
2. Verify image exists in ACR
3. Check environment variables and secrets
4. Review resource allocation

#### Azure DevOps Pipeline Failures:

1. Check pipeline logs in Azure DevOps
2. Verify service connection permissions
3. Confirm Terraform version compatibility
4. Review variable group configurations

### Support Contacts

- **Infrastructure Issues**: DevOps Team
- **Application Issues**: Development Team
- **Security Issues**: Security Team

## Additional Resources

- [Azure Container Apps Documentation](https://docs.microsoft.com/en-us/azure/container-apps/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure DevOps Pipelines Documentation](https://docs.microsoft.com/en-us/azure/devops/pipelines/)
- [Azure Monitor KQL Reference](https://docs.microsoft.com/en-us/azure/azure-monitor/logs/kql-quick-reference)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Built for Azure Container Apps**
