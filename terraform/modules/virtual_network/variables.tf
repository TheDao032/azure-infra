variable "deployment_resource_group_name" {
  description = "rg_name"
  type        = string
}

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

# Route table variables
variable "route_table_name" {
  description = "route table name"
  type        = string
  default     = "DefaultRouteTable"
}

# variable "firewall_private_ip" {
#   description = "firewall private ip"
#   default     = ["10.1.0.0/24"]
#   type        = list(string)
# }

# VirtualNetwork vnet_name
variable "hub_vnet_name" {
  description = "vnet name"
  type        = string
  default     = "HubVNet"
}

variable "aks_vnet_name" {
  description = "vnet name"
  type        = string
  default     = "AksVNet"
}

variable "hub_firewall_subnet_name" {
  description = "hub-firewall-subnet-name"
  type        = string
  default     = "AzureFirewallSubnet"
}

variable "hub_bastion_subnet_name" {
  description = "hub-bastion-subnet-name"
  type        = string
  default     = "AzureBastionSubnet"
}

variable "aks_system_subnet_name" {
  description = "aks-default-subnet-name"
  type        = string
  default     = "SystemSubnet"
}

variable "aks_user_subnet_name" {
  description = "aks-additional-subnet-name"
  type        = string
  default     = "UserSubnet"
}

variable "aks_vm_subnet_name" {
  description = "aks-additional-subnet-name"
  type        = string
  default     = "VMSubnet"
}

variable "aks_sql_subnet_name" {
  description = "aks-sql-subnet-name"
  type        = string
  default     = "SQLDatabaseSubnet"
}

variable "hub_firewall_address_prefix" {
  description = "cidr-hub-firewall"
  type        = list(string)
  default     = []
}

variable "hub_bastion_address_prefix" {
  description = "cidr-hub-bastion"
  type        = list(string)
  default     = []
}

variable "aks_system_address_prefix" {
  description = "cidr-aks-default"
  type        = list(string)
  default     = []
}

variable "aks_user_address_prefix" {
  description = "cidr-aks-additional"
  type        = list(string)
  default     = []
}

variable "aks_vm_address_prefix" {
  description = "cidr-aks-vm"
  type        = list(string)
  default     = []
}

variable "aks_sql_address_prefix" {
  description = "cidr-aks-sql"
  type        = list(string)
  default     = []
}

variable "hub_address_space" {
  description = "address space"
  default     = []
  type        = list(string)
}

variable "aks_address_space" {
  description = "address space"
  default     = []
  type        = list(string)
}

variable "aks_subnet_service_endpoints" {
  description = "Aks subnet service endpoints"
  default     = ["Microsoft.KeyVault", "Microsoft.Sql"]
  type        = list(string)
}

# Log analytics variables
variable "log_analytics_workspace_id" {
  description = "log analytics workspace id"
  type        = string
}

# Firewall variables
variable "zones" {
  description = "Specifies the availability zones of the Azure Firewall"
  default     = ["1", "2", "3"]
  type        = list(string)
}

variable "public_ip_name" {
  description = "Specifies the firewall public IP name"
  type        = string
  default     = "azure-fw-ip"
}

variable "threat_intel_mode" {
  description = "(Optional) The operation mode for threat intelligence-based filtering. Possible values are: Off, Alert, Deny. Defaults to Alert."
  default     = "Alert"
  type        = string

  validation {
    condition     = contains(["Off", "Alert", "Deny"], var.threat_intel_mode)
    error_message = "The threat intel mode is invalid."
  }
}

variable "sku_name" {
  description = "(Required) SKU name of the Firewall. Possible values are AZFW_Hub and AZFW_VNet. Changing this forces a new resource to be created."
  default     = "AZFW_VNet"
  type        = string

  validation {
    condition     = contains(["AZFW_Hub", "AZFW_VNet"], var.sku_name)
    error_message = "The value of the sku name property of the firewall is invalid."
  }
}

variable "sku_tier" {
  description = "(Required) SKU tier of the Firewall. Possible values are Premium, Standard, and Basic."
  default     = "Standard"
  type        = string

  validation {
    condition     = contains(["Premium", "Standard", "Basic"], var.sku_tier)
    error_message = "The value of the sku tier property of the firewall is invalid."
  }
}

variable "aks_egress_policy_rule_cg_name" {
  description = "aks egress policy rule cg name"
  default     = "AksEgressPolicyRuleCollectionGroup"
  type        = string
}
