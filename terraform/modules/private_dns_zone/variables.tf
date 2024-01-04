variable "env" {
  description = "(Required) Specifies the name of the private dns zone"
  type        = string
}

variable "private_dns_zone_acr_name" {
  description = "(Required) Specifies the name of the private dns zone"
  type        = string
  default     = "privatelink.azurecr.io"
}

variable "private_dns_zone_key_vault_name" {
  description = "(Required) Specifies the name of the private dns zone"
  type        = string
  default     = "privatelink.vaultcore.azure.net"
}

variable "private_dns_zone_blob_name" {
  description = "(Required) Specifies the name of the private dns zone"
  type        = string
  default     = "privatelink.blob.core.windows.net"
}

variable "deployment_resource_group_name" {
  description = "(Required) Specifies the resource group name of the private dns zone"
  type        = string
}

variable "tags" {
  description = "(Optional) Specifies the tags of the private dns zone"
  type        = map(any)
  default     = {}
}

variable "virtual_networks_to_link" {
  description = "(Optional) Specifies the subscription id, resource group name, and name of the virtual networks to which create a virtual network link"
  type        = map(any)
  default     = {}
}
