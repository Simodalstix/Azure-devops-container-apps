# Outputs for the container app module

output "container_app_name" {
  description = "Name of the container app"
  value       = azurerm_container_app.api.name
}

output "container_app_id" {
  description = "ID of the container app"
  value       = azurerm_container_app.api.id
}

output "container_app_fqdn" {
  description = "Fully qualified domain name of the container app"
  value       = azurerm_container_app.api.latest_revision_fqdn
}

output "container_app_url" {
  description = "URL of the container app"
  value       = "https://${azurerm_container_app.api.latest_revision_fqdn}"
}

output "container_app_identity_principal_id" {
  description = "Principal ID of the container app managed identity"
  value       = azurerm_container_app.api.identity[0].principal_id
}

output "container_app_identity_tenant_id" {
  description = "Tenant ID of the container app managed identity"
  value       = azurerm_container_app.api.identity[0].tenant_id
}

output "availability_test_id" {
  description = "ID of the Application Insights availability test"
  value       = azurerm_application_insights_web_test.api_health.id
}
