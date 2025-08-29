# Shared Infrastructure - Enterprise pattern with centralized resources
terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  # backend "azurerm" {
  #   # Backend configuration provided by pipeline
  #   key = "shared.terraform.tfstate"
  # }
}

provider "azurerm" {
  features {}
}

# Local values for shared resources
locals {
  location = "australiaeast"

  tags = {
    Environment = "shared"
    Project     = "container-apps-devops"
    ManagedBy   = "terraform"
    Purpose     = "shared-resources"
  }
}

# Shared resource group
resource "azurerm_resource_group" "shared" {
  name     = "rg-containerapp-shared-aue"
  location = local.location
  tags     = local.tags
}

# Shared Container Registry - Enterprise pattern
resource "azurerm_container_registry" "shared" {
  name                = "acrcontainerappdevops001"
  resource_group_name = azurerm_resource_group.shared.name
  location            = azurerm_resource_group.shared.location
  sku                 = "Standard"
  admin_enabled       = true

  # Enterprise security features
  public_network_access_enabled = false
  network_rule_bypass_option    = "AzureServices"

  tags = local.tags
}

# Shared Log Analytics Workspace - Centralized logging
resource "azurerm_log_analytics_workspace" "shared" {
  name                = "law-containerapp-shared-aue"
  resource_group_name = azurerm_resource_group.shared.name
  location            = azurerm_resource_group.shared.location
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days

  tags = local.tags
}

# Shared Application Insights - Unified monitoring
resource "azurerm_application_insights" "shared" {
  name                = "ai-containerapp-shared-aue"
  resource_group_name = azurerm_resource_group.shared.name
  location            = azurerm_resource_group.shared.location
  workspace_id        = azurerm_log_analytics_workspace.shared.id
  application_type    = "web"

  tags = local.tags
}

# Shared Action Group - Centralized alerting
resource "azurerm_monitor_action_group" "shared" {
  name                = "ag-containerapp-shared-aue"
  resource_group_name = azurerm_resource_group.shared.name
  short_name          = "containerapp"

  email_receiver {
    name          = "admin-email"
    email_address = var.admin_email
  }

  tags = local.tags
}