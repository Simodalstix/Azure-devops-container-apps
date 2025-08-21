# Azure Icons for Excalidraw Architecture Diagram

This document lists all the Azure icons needed to create an architecture diagram for the Azure Container Apps platform.

## Core Azure Services Icons

### Container & Compute

- **Azure Container Apps** - Main containerized application platform
- **Azure Container Registry (ACR)** - Private container registry
- **Azure Container Instances** - For showing scaling concepts

### Security & Identity

- **Azure Key Vault** - Secret and certificate management
- **Azure Active Directory** - Service Principal authentication

### Monitoring & Observability

- **Azure Monitor** - Overall monitoring service
- **Application Insights** - Application performance monitoring
- **Log Analytics Workspace** - Centralized logging
- **Azure Dashboard** - Custom monitoring dashboards

### Storage

- **Azure Storage Account** - Terraform state storage
- **Azure Blob Storage** - Blob container for tfstate

### Networking

- **Azure Virtual Network** - Network isolation (optional)
- **Azure Application Gateway** - WAF and advanced routing (optional upgrade)
- **Azure Load Balancer** - Internal load balancing (optional)
- **Built-in Load Balancing** - Container Apps native load balancing (current implementation)

## CI/CD & DevOps Icons

### Source Control & CI/CD

- **GitHub** - Source code repository
- **Jenkins** - CI/CD automation server
- **Azure DevOps** - Alternative CI/CD platform

### Infrastructure as Code

- **Terraform** - Infrastructure provisioning
- **Azure Resource Manager (ARM)** - Azure resource management

## Additional Context Icons

### General Azure

- **Azure Subscription** - Top-level container
- **Resource Group** - Resource organization
- **Azure Region/Location** - Geographic deployment

### Alerting & Notifications

- **Azure Action Groups** - Alert notification groups
- **Email Notifications** - Alert delivery method
- **Azure Alerts** - Monitoring alerts

### Development Tools

- **Docker** - Container technology
- **Node.js** - Sample application runtime
- **Visual Studio Code** - Development environment

## Diagram Layout Recommendations

### Structure Hierarchy

1. **Azure Subscription** (outermost container)
2. **Environment Containers** (Dev and Prod)
3. **Resource Groups** (within each environment)
4. **Service Groupings**:
   - Container Services (Container Apps, ACR)
   - Security Services (Key Vault, AAD)
   - Monitoring Services (App Insights, Log Analytics)
   - Storage Services (Storage Account)

### Flow Representation

- **CI/CD Pipeline**: Horizontal flow (GitHub → Jenkins → Terraform → Azure)
- **Data Flow**: Arrows showing service connections
- **Network Flow**: Container Apps to external services

### Color Coding Suggestions

- **Blue**: Core Azure services
- **Green**: CI/CD pipeline components
- **Orange**: Monitoring and alerting
- **Purple**: Security components
- **Gray**: Infrastructure components

## Icon Sources

### Official Microsoft Sources

- **Azure Architecture Icons** - Official SVG icon set
- **Microsoft Cloud Adoption Framework** - Architecture patterns
- **Azure Well-Architected Framework** - Best practice icons

### Excalidraw Libraries

- Search "Azure" in Excalidraw libraries
- Community-contributed Azure icon packs
- Microsoft official Excalidraw library (if available)

### Alternative Sources

- **Draw.io Azure Icons** - Can be converted for Excalidraw
- **Lucidchart Azure Icons** - Reference for styling
- **Visio Azure Stencils** - Microsoft official stencils

## Diagram Sections to Include

### Environment Separation

- Clear visual separation between Dev and Prod
- Shared resources section
- CI/CD pipeline spanning both environments

### Service Dependencies

- Arrows showing data flow
- Dotted lines for optional connections
- Bold lines for critical paths

### Security Boundaries

- Dashed boxes for security zones
- Key Vault connections to all services
- Service Principal authentication flows

This icon list covers all components in the Azure Container Apps platform and provides guidance for creating a comprehensive architecture diagram.
