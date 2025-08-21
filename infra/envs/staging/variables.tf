# Staging Environment Variables - 12-Factor App compliance
variable "admin_email" {
  description = "Administrator email for alerts and notifications"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.admin_email))
    error_message = "Admin email must be a valid email address."
  }
}

variable "container_image" {
  description = "Container image to deploy (follows immutable infrastructure)"
  type        = string
  default     = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}