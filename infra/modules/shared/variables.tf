# Variables for the shared infrastructure module

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "australiaeast"
}

variable "tfstate_storage_account_name" {
  description = "Name of the storage account for Terraform state"
  type        = string
}

variable "shared_resource_group_name" {
  description = "Name of the shared resource group containing ACR, Log Analytics, etc."
  type        = string
}

variable "shared_acr_name" {
  description = "Name of the shared Azure Container Registry"
  type        = string
}

variable "shared_log_analytics_name" {
  description = "Name of the shared Log Analytics Workspace"
  type        = string
}

variable "shared_application_insights_name" {
  description = "Name of the shared Application Insights instance"
  type        = string
}

variable "key_vault_name" {
  description = "Name of the environment-specific Azure Key Vault"
  type        = string
}

variable "container_app_environment_name" {
  description = "Name of the Container Apps Environment"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "azure-container-apps"
    ManagedBy   = "terraform"
  }
}
