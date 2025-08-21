# Variables for the monitoring module

variable "action_group_name" {
  description = "Name of the action group"
  type        = string
}

variable "action_group_short_name" {
  description = "Short name of the action group (max 12 characters)"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "admin_email" {
  description = "Admin email address for alerts"
  type        = string
}

variable "container_app_name" {
  description = "Name of the container app to monitor"
  type        = string
}

variable "container_app_id" {
  description = "ID of the container app to monitor"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  type        = string
}

variable "http_5xx_threshold" {
  description = "Threshold for HTTP 5xx errors"
  type        = number
  default     = 5
}

variable "restart_threshold" {
  description = "Threshold for container restarts"
  type        = number
  default     = 3
}

variable "error_log_threshold" {
  description = "Threshold for error logs in application"
  type        = number
  default     = 10
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
