# Staging Environment - Production-like configuration for final validation
terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    # Backend configuration provided by pipeline
  }
}

provider "azurerm" {
  features {}
}

# Local values for staging environment
locals {
  environment = "staging"
  location    = "australiaeast"
  
  # Staging uses production-like settings but smaller scale
  container_app_config = {
    min_replicas = 1
    max_replicas = 5
    cpu_requests = "0.25"
    memory_requests = "0.5Gi"
  }
  
  tags = {
    Environment = local.environment
    Project     = "container-apps-devops"
    ManagedBy   = "terraform"
  }
}

# Shared infrastructure module
module "shared" {
  source = "../../modules/shared"
  
  environment = local.environment
  location    = local.location
  tags        = local.tags
  
  # Staging-specific overrides
  log_retention_days = 30
  admin_email       = var.admin_email
}

# Container app module
module "container_app" {
  source = "../../modules/container-app"
  
  environment = local.environment
  location    = local.location
  tags        = local.tags
  
  # Dependencies from shared module
  resource_group_name           = module.shared.resource_group_name
  container_apps_environment_id = module.shared.container_apps_environment_id
  container_registry_name       = module.shared.container_registry_name
  key_vault_id                 = module.shared.key_vault_id
  
  # Staging configuration
  container_image = var.container_image
  min_replicas   = local.container_app_config.min_replicas
  max_replicas   = local.container_app_config.max_replicas
  cpu_requests   = local.container_app_config.cpu_requests
  memory_requests = local.container_app_config.memory_requests
}

# Monitoring module
module "monitoring" {
  source = "../../modules/monitoring"
  
  environment = local.environment
  location    = local.location
  tags        = local.tags
  
  # Dependencies
  resource_group_name     = module.shared.resource_group_name
  log_analytics_workspace_id = module.shared.log_analytics_workspace_id
  application_insights_id = module.shared.application_insights_id
  container_app_name     = module.container_app.container_app_name
  
  # Staging alerting
  admin_email = var.admin_email
}