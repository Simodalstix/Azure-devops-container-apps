# Shared infrastructure module for Azure Container Apps platform
# This module contains resources shared across environments

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

# Storage Account for Terraform state
resource "azurerm_storage_account" "tfstate" {
  name                     = var.tfstate_storage_account_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  blob_properties {
    versioning_enabled = true
  }

  tags = var.tags
}

# Storage Container for Terraform state
resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

# Reference to shared Container Registry
data "azurerm_container_registry" "shared" {
  name                = var.shared_acr_name
  resource_group_name = var.shared_resource_group_name
}

# Key Vault
resource "azurerm_key_vault" "main" {
  name                = var.key_vault_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "List", "Create", "Delete", "Update", "Purge", "Recover"
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Purge", "Recover"
    ]

    certificate_permissions = [
      "Get", "List", "Create", "Delete", "Update", "Purge", "Recover"
    ]
  }

  tags = var.tags
}

# Reference to shared Log Analytics Workspace
data "azurerm_log_analytics_workspace" "shared" {
  name                = var.shared_log_analytics_name
  resource_group_name = var.shared_resource_group_name
}

# Reference to shared Application Insights
data "azurerm_application_insights" "shared" {
  name                = var.shared_application_insights_name
  resource_group_name = var.shared_resource_group_name
}

# Container Apps Environment
resource "azurerm_container_app_environment" "main" {
  name                       = var.container_app_environment_name
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.shared.id

  tags = var.tags
}

# Diagnostic Settings for Container Apps Environment
resource "azurerm_monitor_diagnostic_setting" "container_app_env" {
  name                       = "container-app-env-diagnostics"
  target_resource_id         = azurerm_container_app_environment.main.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.shared.id

  enabled_log {
    category = "ContainerAppConsoleLogs"
  }

  enabled_log {
    category = "ContainerAppSystemLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# Data source for current client configuration
data "azurerm_client_config" "current" {}
