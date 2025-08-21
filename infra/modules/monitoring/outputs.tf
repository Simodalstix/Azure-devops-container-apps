# Outputs for the monitoring module

output "action_group_id" {
  description = "ID of the action group"
  value       = azurerm_monitor_action_group.main.id
}

output "action_group_name" {
  description = "Name of the action group"
  value       = azurerm_monitor_action_group.main.name
}

output "cpu_alert_id" {
  description = "ID of the CPU high alert"
  value       = azurerm_monitor_metric_alert.cpu_high.id
}

output "http_5xx_alert_id" {
  description = "ID of the HTTP 5xx errors alert"
  value       = azurerm_monitor_metric_alert.http_5xx_errors.id
}

output "container_restarts_alert_id" {
  description = "ID of the container restarts alert"
  value       = azurerm_monitor_metric_alert.container_restarts.id
}

output "application_errors_alert_id" {
  description = "ID of the application errors alert"
  value       = azurerm_monitor_scheduled_query_rules_alert_v2.application_errors.id
}
