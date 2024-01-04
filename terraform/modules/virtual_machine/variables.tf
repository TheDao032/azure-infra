variable "env" {
  description = "environment"
  type        = string
}

variable "subscription_id" {
  description = "Subscription ID"
  type        = string
}

variable "location" {
  description = "location"
  type        = string
}

variable "location_path" {
  description = "location"
  type        = string
}

variable "container_name" {
  description = "container name"
  type        = string
}

variable "cr_password" {
  description = "container registry password"
  type        = string
}

variable "cr_name" {
  description = "container registry name"
  type        = string
}

variable "deployment_resource_group_name" {
  description = "resource group name"
  type        = string
}

variable "script_storage_account_name" {
  description = "script storage account name"
  type        = string
}

variable "script_storage_account_key" {
  description = "script storage account key"
  type        = string
}

variable "client_id" {
  description = "client id"
  type        = string
}

variable "client_secret" {
  description = "client secret"
  type        = string
}

variable "tenant_id" {
  description = "tenant id"
  type        = string
}

variable "azure_devops_url" {
  description = "azure devops url"
  type        = string
}

variable "azure_devops_pat" {
  description = "azure devops pat"
  type        = string
}

variable "azure_devops_agent_pool_name" {
  description = "azure devops agent pool name"
  type        = string
}

variable "azure_devops_agent_name" {
  description = "azure devops agent name"
  type        = string
  default     = "terraform-agent"
}

variable "targetarch" {
  description = "Targetarch"
  type        = string
  default     = "linux-x64"
}

# Virtual Machine variables
variable "name" {
  description = "virtual machine name"
  type        = string
  default     = "jumpbox-agent"
}

variable "size" {
  description = "size"
  type        = string
  default     = "Standard_DS1_v2"
}

variable "os_disk_image" {
  type        = map(string)
  description = "(Optional) Specifies the os disk image of the virtual machine"
  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

variable "os_disk_storage_account_type" {
  description = "tags"
  type        = string
  default     = "StandardSSD_LRS"


  validation {
    condition     = contains(["Premium_LRS", "Premium_ZRS", "StandardSSD_LRS", "StandardSSD_ZRS", "Standard_LRS"], var.os_disk_storage_account_type)
    error_message = "The storage account type of the OS disk is invalid."
  }
}

variable "jumpbox_vm_username" {
  description = "virtual machine user"
  type        = string
  default     = "adminuser"
}

variable "jumpbox_vm_passwd" {
  description = "admin password"
  type        = string
}

variable "boot_diagnostics_storage_account" {
  description = "boot diagnostics storage account"
  type        = string
  default     = ""
}

variable "script_name" {
  description = "admin ssh public key"
  type        = string
  default     = "configure_self_host_agent.sh"
}

variable "domain_name_label" {
  description = "admin ssh public key"
  type        = string
  default     = "jumpbox-agent-domain"
}

variable "public_ip" {
  description = "(Optional) Specifies whether create a public IP for the virtual machine"
  type        = bool
  default     = true
}

variable "aks_vm_subnet_id" {
  description = "(Optional) Specifies whether create a public IP for the virtual machine"
  type        = string
}

# Log analytics variables
variable "log_analytics_workspace_resource_id" {
  description = "log analytics workspace resource id"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "log analytics workspace resource id"
  type        = string
}

variable "log_analytics_workspace_key" {
  description = "log analytics workspace resource id"
  type        = string
}

variable "tags" {
  description = "tags"
  type        = map(any)
  default     = {}
}
