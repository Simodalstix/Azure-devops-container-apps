# Outputs for the shared infrastructure module

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_id" {
  description = "ID of the resource group"
  value       = azurerm_resource_group.main.id
}

output "location" {
  description = "Azure region"
  value       = azurerm_resource_group.main.location
}

output "storage_account_name" {
  description = "Name of the Terraform state storage account"
  value       = azurerm_storage_account.tfstate.name
}

output "storage_account_primary_key" {
  description = "Primary access key for the storage account"
  value       = azurerm_storage_account.tfstate.primary_access_key
  sensitive   = true
}

output "container_registry_name" {
  description = "Name of the shared Azure Container Registry"
  value       = data.azurerm_container_registry.shared.name
}

output "container_registry_login_server" {
  description = "Login server URL for the shared Azure Container Registry"
  value       = data.azurerm_container_registry.shared.login_server
}

output "container_registry_admin_username" {
  description = "Admin username for the shared Azure Container Registry"
  value       = data.azurerm_container_registry.shared.admin_username
  sensitive   = true
}

output "container_registry_admin_password" {
  description = "Admin password for the shared Azure Container Registry"
  value       = data.azurerm_container_registry.shared.admin_password
  sensitive   = true
}

output "key_vault_name" {
  description = "Name of the Azure Key Vault"
  value       = azurerm_key_vault.main.name
}

output "key_vault_uri" {
  description = "URI of the Azure Key Vault"
  value       = azurerm_key_vault.main.vault_uri
}

output "log_analytics_workspace_id" {
  description = "ID of the shared Log Analytics Workspace"
  value       = data.azurerm_log_analytics_workspace.shared.id
}

output "log_analytics_workspace_name" {
  description = "Name of the shared Log Analytics Workspace"
  value       = data.azurerm_log_analytics_workspace.shared.name
}

output "application_insights_id" {
  description = "ID of the shared Application Insights"
  value       = data.azurerm_application_insights.shared.id
}

output "application_insights_name" {
  description = "Name of the shared Application Insights instance"
  value       = data.azurerm_application_insights.shared.name
}

output "application_insights_instrumentation_key" {
  description = "Instrumentation key for shared Application Insights"
  value       = data.azurerm_application_insights.shared.instrumentation_key
  sensitive   = true
}

output "application_insights_connection_string" {
  description = "Connection string for shared Application Insights"
  value       = data.azurerm_application_insights.shared.connection_string
  sensitive   = true
}

output "container_app_environment_id" {
  description = "ID of the Container Apps Environment"
  value       = azurerm_container_app_environment.main.id
}

output "container_app_environment_name" {
  description = "Name of the Container Apps Environment"
  value       = azurerm_container_app_environment.main.name
}

output "container_app_environment_default_domain" {
  description = "Default domain of the Container Apps Environment"
  value       = azurerm_container_app_environment.main.default_domain
}
