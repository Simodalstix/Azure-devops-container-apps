# Staging Environment Outputs
output "resource_group_name" {
  description = "Name of the resource group"
  value       = module.shared.resource_group_name
}

output "container_app_fqdn" {
  description = "Fully qualified domain name of the container app"
  value       = module.container_app.container_app_fqdn
}

output "container_registry_login_server" {
  description = "Login server for the container registry"
  value       = module.shared.container_registry_login_server
}

output "application_insights_connection_string" {
  description = "Application Insights connection string"
  value       = module.shared.application_insights_connection_string
  sensitive   = true
}