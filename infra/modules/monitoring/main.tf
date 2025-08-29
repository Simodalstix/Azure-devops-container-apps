# Monitoring module for alerts and action groups

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Action Group for alerts
resource "azurerm_monitor_action_group" "main" {
  name                = var.action_group_name
  resource_group_name = var.resource_group_name
  short_name          = var.action_group_short_name

  email_receiver {
    name          = "admin-email"
    email_address = var.admin_email
  }

  tags = var.tags
}

# CPU Alert - Container App CPU > 70% for 10 minutes
resource "azurerm_monitor_metric_alert" "cpu_high" {
  name                = "${var.container_app_name}-cpu-high"
  resource_group_name = var.resource_group_name
  scopes              = [var.container_app_id]
  description         = "Alert when CPU usage is greater than 70% for 10 minutes"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT15M"

  criteria {
    metric_namespace = "Microsoft.App/containerApps"
    metric_name      = "CpuPercentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 70
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = var.tags
}

# HTTP 5xx Error Rate Alert
resource "azurerm_monitor_metric_alert" "http_5xx_errors" {
  name                = "${var.container_app_name}-http-5xx-errors"
  resource_group_name = var.resource_group_name
  scopes              = [var.container_app_id]
  description         = "Alert when HTTP 5xx error rate exceeds threshold"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT5M"

  criteria {
    metric_namespace = "Microsoft.App/containerApps"
    metric_name      = "Requests"
    aggregation      = "Count"
    operator         = "GreaterThan"
    threshold        = var.http_5xx_threshold

    dimension {
      name     = "StatusCodeCategory"
      operator = "Include"
      values   = ["5xx"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = var.tags
}

# Container Restart Alert
resource "azurerm_monitor_metric_alert" "container_restarts" {
  name                = "${var.container_app_name}-container-restarts"
  resource_group_name = var.resource_group_name
  scopes              = [var.container_app_id]
  description         = "Alert when container restart count spikes"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT5M"

  criteria {
    metric_namespace = "Microsoft.App/containerApps"
    metric_name      = "RestartCount"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = var.restart_threshold
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = var.tags
}

# Log Analytics queries for custom alerts
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "application_errors" {
  name                = "${var.container_app_name}-application-errors"
  resource_group_name = var.resource_group_name
  location            = var.location

  evaluation_frequency = "PT5M"
  window_duration      = "PT15M"
  scopes               = [var.log_analytics_workspace_id]
  severity             = 2

  criteria {
    query                   = <<-QUERY
      ContainerAppConsoleLogs_CL
      | where ContainerAppName_s == "${var.container_app_name}"
      | where Log_s contains "ERROR" or Log_s contains "Exception"
      | summarize count() by bin(TimeGenerated, 5m)
      | where count_ > ${var.error_log_threshold}
    QUERY
    time_aggregation_method = "Count"
    threshold               = 1
    operator                = "GreaterThanOrEqual"

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  action {
    action_groups = [azurerm_monitor_action_group.main.id]
  }

  tags = var.tags
}
