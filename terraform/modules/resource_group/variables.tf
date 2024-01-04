variable "location" {
  description = "location"
  type        = string
}

variable "tags" {
  description = "tags"
  type        = map(any)
  default     = {}
}

variable "env" {
  description = "environment"
  type        = string
}

# Resource group name
variable "deployment_resource_group_name" {
  description = "resource group name"
  type        = string
}
