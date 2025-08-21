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

# Environment-specific infrastructure module (references shared resources)
module "shared" {
  source = "../../modules/shared"
  
  # Environment-specific resources
  resource_group_name            = "rg-containerapp-${local.environment}-aue"
  location                       = local.location
  tfstate_storage_account_name   = "stcontainerappstaging001"
  key_vault_name                 = "kv-containerapp-${local.environment}-aue"
  container_app_environment_name = "cae-containerapp-${local.environment}-aue"

  # References to shared resources
  shared_resource_group_name       = "rg-containerapp-shared-aue"
  shared_acr_name                 = "acrcontainerappdevops001"
  shared_log_analytics_name       = "law-containerapp-shared-aue"
  shared_application_insights_name = "ai-containerapp-shared-aue"

  tags = local.tags
}

# Container app module
module "container_app" {
  source = "../../modules/container-app"
  
  container_app_name                     = "ca-api-${local.environment}-aue"
  container_app_environment_id           = module.shared.container_app_environment_id
  resource_group_name                    = module.shared.resource_group_name
  location                               = module.shared.location
  container_image                        = var.container_image
  min_replicas                           = local.container_app_config.min_replicas
  max_replicas                           = local.container_app_config.max_replicas
  cpu_cores                              = "0.25"
  memory_size                            = "0.5Gi"
  environment                            = local.environment
  database_connection_string             = ""
  application_insights_connection_string = module.shared.application_insights_connection_string
  key_vault_id                           = module.shared.key_vault_uri
  application_insights_id                = module.shared.application_insights_id

  tags = local.tags
}

# Monitoring module
module "monitoring" {
  source = "../../modules/monitoring"

  action_group_name          = "ag-containerapp-${local.environment}-aue"
  action_group_short_name    = "ag-${local.environment}"
  resource_group_name        = module.shared.resource_group_name
  location                   = module.shared.location
  admin_email                = var.admin_email
  container_app_name         = module.container_app.container_app_name
  container_app_id           = module.container_app.container_app_id
  log_analytics_workspace_id = module.shared.log_analytics_workspace_id
  http_5xx_threshold         = 10
  restart_threshold          = 5
  error_log_threshold        = 20

  tags = local.tags
}