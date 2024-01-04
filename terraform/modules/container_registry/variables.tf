variable "env" {
  description = "(Required) Specifies the name of the Container Registry. Changing this forces a new resource to be created."
  type        = string
}

variable "name" {
  description = "(Required) Specifies the name of the Container Registry. Changing this forces a new resource to be created."
  type        = string
  default     = "ntucacr"
}

variable "deployment_resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Container Registry. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
}

variable "admin_enabled" {
  description = "(Optional) Specifies whether the admin user is enabled. Defaults to false."
  type        = string
  default     = true
}

variable "sku" {
  description = "(Optional) The SKU name of the container registry. Possible values are Basic, Standard and Premium. Defaults to Basic"
  type        = string
  default     = "Premium"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "The container registry sku is invalid."
  }
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(any)
  default     = {}
}

variable "georeplication_locations" {
  description = "(Optional) A list of Azure locations where the container registry should be geo-replicated."
  type        = list(string)
  default     = []
}

# Log analytics
variable "log_analytics_workspace_id" {
  description = "Specifies the log analytics workspace id"
  type        = string
}

# variable "log_analytics_retention_days" {
#   description = "Specifies the number of days of the retention policy"
#   type        = number
#   default     = 7
# }

# DNS zone group
# variable "private_dns_zone_group_name" {
#   description = "Specifies the log analytics workspace id"
#   type        = string
# }
#
# variable "private_dns_zone_group_ids" {
#   description = "Specifies the number of days of the retention policy"
#   type        = list(any)
#   default     = []
# }

# Private endpoint
variable "subnet_id" {
  description = "Specifies the number of days of the retention policy"
  type        = string
}

variable "is_manual_connection" {
  description = "(Optional) Specifies whether the private endpoint connection requires manual approval from the remote resource owner."
  type        = string
  default     = false
}

variable "subresource_name" {
  description = "(Optional) Specifies a subresource name which the Private Endpoint is able to connect to."
  type        = string
  default     = "registry"
}

variable "request_message" {
  description = "(Optional) Specifies a message passed to the owner of the remote resource when the private endpoint attempts to establish the connection to the remote resource."
  type        = string
  default     = "AcrPrivateDnsZoneGroup"
}
