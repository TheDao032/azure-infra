variable "location" {
  description = "location"
  type        = string
}

variable "env" {
  description = "(Required) Environment"
  type        = string
}

variable "tags" {
  description = "(Optional) Specifies the tags of the log analytics workspace"
  type        = map(any)
  default     = {}
}

# Resource group name
variable "deployment_resource_group_name" {
  description = "(Required) Specifies the resource group name"
  type        = string
}

# Log analytics variables
variable "name" {
  description = "(Required) Specifies the name of the log analytics workspace"
  default     = "AksLogWorkspace"
  type        = string
}

variable "sku" {
  description = "(Optional) Specifies the sku of the log analytics workspace"
  type        = string
  default     = "PerGB2018"

  validation {
    condition     = contains(["Free", "Standalone", "PerNode", "PerGB2018"], var.sku)
    error_message = "The log analytics sku is incorrect."
  }
}

variable "retention_in_days" {
  description = "(Optional) Specifies the workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730."
  type        = number
  default     = 30
}

variable "solution_plan_map" {
  description = "(Optional) Specifies the map structure containing the list of solutions to be enabled."
  type        = map(any)
  default = {
    ContainerInsights = {
      product   = "OMSGallery/ContainerInsights"
      publisher = "Microsoft"
    }
  }
}
