# Outputs for the production environment

# Shared infrastructure outputs
output "resource_group_name" {
  description = "Name of the resource group"
  value       = module.shared.resource_group_name
}

output "container_registry_login_server" {
  description = "Login server URL for the Azure Container Registry"
  value       = module.shared.container_registry_login_server
}

output "key_vault_uri" {
  description = "URI of the Azure Key Vault"
  value       = module.shared.key_vault_uri
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics Workspace"
  value       = module.shared.log_analytics_workspace_name
}

output "application_insights_name" {
  description = "Name of the Application Insights instance"
  value       = module.shared.application_insights_name
}

# Container App outputs
output "container_app_name" {
  description = "Name of the container app"
  value       = module.container_app.container_app_name
}

output "container_app_url" {
  description = "URL of the container app"
  value       = module.container_app.container_app_url
}

output "container_app_fqdn" {
  description = "Fully qualified domain name of the container app"
  value       = module.container_app.container_app_fqdn
}

# Monitoring outputs
output "action_group_name" {
  description = "Name of the action group"
  value       = module.monitoring.action_group_name
}

# Environment information
output "environment" {
  description = "Environment name"
  value       = "prod"
}

output "location" {
  description = "Azure region"
  value       = module.shared.location
}
