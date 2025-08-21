# Shared Infrastructure Outputs
output "resource_group_name" {
  description = "Name of the shared resource group"
  value       = azurerm_resource_group.shared.name
}

output "container_registry_name" {
  description = "Name of the shared container registry"
  value       = azurerm_container_registry.shared.name
}

output "container_registry_login_server" {
  description = "Login server for the shared container registry"
  value       = azurerm_container_registry.shared.login_server
}

output "container_registry_admin_username" {
  description = "Admin username for the shared container registry"
  value       = azurerm_container_registry.shared.admin_username
  sensitive   = true
}

output "container_registry_admin_password" {
  description = "Admin password for the shared container registry"
  value       = azurerm_container_registry.shared.admin_password
  sensitive   = true
}

output "log_analytics_workspace_id" {
  description = "ID of the shared Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.shared.id
}

output "log_analytics_workspace_key" {
  description = "Primary shared key for the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.shared.primary_shared_key
  sensitive   = true
}

output "application_insights_id" {
  description = "ID of the shared Application Insights"
  value       = azurerm_application_insights.shared.id
}

output "application_insights_connection_string" {
  description = "Connection string for the shared Application Insights"
  value       = azurerm_application_insights.shared.connection_string
  sensitive   = true
}

output "application_insights_instrumentation_key" {
  description = "Instrumentation key for the shared Application Insights"
  value       = azurerm_application_insights.shared.instrumentation_key
  sensitive   = true
}

output "action_group_id" {
  description = "ID of the shared action group"
  value       = azurerm_monitor_action_group.shared.id
}