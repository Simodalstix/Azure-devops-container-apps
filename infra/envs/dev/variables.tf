# Variables for the development environment

variable "container_image" {
  description = "Container image to deploy"
  type        = string
  default     = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}

variable "min_replicas" {
  description = "Minimum number of replicas"
  type        = number
  default     = 1
}

variable "max_replicas" {
  description = "Maximum number of replicas"
  type        = number
  default     = 3
}

variable "cpu_cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 0.25
}

variable "memory_size" {
  description = "Memory size in Gi"
  type        = string
  default     = "0.5Gi"
}

variable "database_connection_string" {
  description = "Database connection string"
  type        = string
  sensitive   = true
  default     = ""
}

variable "admin_email" {
  description = "Admin email address for alerts"
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
