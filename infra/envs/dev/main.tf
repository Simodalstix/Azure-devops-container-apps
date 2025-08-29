# Development environment configuration

terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "sttfstatedevops001"
    container_name       = "tfstate"
    key                  = "dev/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Local values for resource naming
locals {
  environment = "dev"
  project     = "containerapp"
  location    = "australiaeast"

  # Resource naming convention: {resource_type}-{project}-{environment}-{location_short}
  location_short = "aue"

  common_tags = {
    Environment = local.environment
    Project     = local.project
    ManagedBy   = "terraform"
    CreatedBy   = "jenkins"
  }
}

# Environment-specific infrastructure module (references shared resources)
module "shared" {
  source = "../../modules/shared"

  # Environment-specific resources
  resource_group_name            = "rg-${local.project}-${local.environment}-${local.location_short}"
  location                       = local.location
  tfstate_storage_account_name   = "st${local.project}tfstate${local.environment}${local.location_short}"
  key_vault_name                 = "kv-${local.project}-${local.environment}-${local.location_short}"
  container_app_environment_name = "cae-${local.project}-${local.environment}-${local.location_short}"

  # References to shared resources
  shared_resource_group_name       = "rg-containerapp-shared-aue"
  shared_acr_name                  = "acrcontainerappdevops001"
  shared_log_analytics_name        = "law-containerapp-shared-aue"
  shared_application_insights_name = "ai-containerapp-shared-aue"

  tags = local.common_tags
}

# Container App module
module "container_app" {
  source = "../../modules/container-app"

  container_app_name                     = "ca-api-${local.environment}-${local.location_short}"
  container_app_environment_id           = module.shared.container_app_environment_id
  resource_group_name                    = module.shared.resource_group_name
  location                               = module.shared.location
  container_image                        = var.container_image
  min_replicas                           = var.min_replicas
  max_replicas                           = var.max_replicas
  cpu_cores                              = var.cpu_cores
  memory_size                            = var.memory_size
  environment                            = local.environment
  database_connection_string             = var.database_connection_string
  application_insights_connection_string = module.shared.application_insights_connection_string
  key_vault_id                           = module.shared.key_vault_uri
  application_insights_id                = module.shared.application_insights_id

  tags = local.common_tags

  depends_on = [module.shared]
}

# Monitoring module
module "monitoring" {
  source = "../../modules/monitoring"

  action_group_name          = "ag-${local.project}-${local.environment}-${local.location_short}"
  action_group_short_name    = "ag-${local.environment}"
  resource_group_name        = module.shared.resource_group_name
  location                   = module.shared.location
  admin_email                = var.admin_email
  container_app_name         = module.container_app.container_app_name
  container_app_id           = module.container_app.container_app_id
  log_analytics_workspace_id = module.shared.log_analytics_workspace_id
  http_5xx_threshold         = var.http_5xx_threshold
  restart_threshold          = var.restart_threshold
  error_log_threshold        = var.error_log_threshold

  tags = local.common_tags

  depends_on = [module.shared, module.container_app]
}

# Store ACR credentials in Key Vault
resource "azurerm_key_vault_secret" "acr_username" {
  name         = "acr-username"
  value        = module.shared.container_registry_admin_username
  key_vault_id = module.shared.key_vault_uri

  depends_on = [module.shared]
}

resource "azurerm_key_vault_secret" "acr_password" {
  name         = "acr-password"
  value        = module.shared.container_registry_admin_password
  key_vault_id = module.shared.key_vault_uri

  depends_on = [module.shared]
}

# Store Application Insights connection string in Key Vault
resource "azurerm_key_vault_secret" "app_insights_connection_string" {
  name         = "app-insights-connection-string"
  value        = module.shared.application_insights_connection_string
  key_vault_id = module.shared.key_vault_uri

  depends_on = [module.shared]
}
