variable "tags" {
  description = "(Optional) Specifies the tags of the log analytics workspace"
  type        = map(any)
  default     = {}
}

variable "deployment_resource_group_name" {
  description = "(Required) Specifies the name of the resource group."
  type        = string
}

variable "env" {
  description = "(Required) Specifies the name of the environment"
  type        = string
}

variable "location" {
  description = "(Optional) Specifies the location where the postgres server will be deployed."
  type        = string
}

variable "postgresql_name_prefix" {
  description = "(Optional) Specifies the database username where the postgres server will be deployed."
  type        = string
  default     = "ntuc-pqslserver"
}


variable "db_username" {
  description = "(Optional) Specifies the database username where the postgres server will be deployed."
  type        = string
}

variable "db_password" {
  description = "(Optional) Specifies the database password where the postgres server will be deployed."
  type        = string
}

variable "db_name" {
  description = "(Optional) Specifies the database name where the postgres server will be deployed."
  type        = string
  default     = "postgres"
}

variable "sku" {
  description = "(Required) Specifies the sku where the postgres server will be deployed."
  type        = string
  default     = "GP_Gen5_2"
}

variable "posgresql_version" {
  description = "(Required) Specifies the version where the postgres server will be deployed."
  type        = string
  default     = "11"
}

variable "storage_mb" {
  description = "(Required) Specifies the version where the postgres server will be deployed."
  type        = string
  default     = 5120
}

variable "backup_retention_days" {
  description = "(Optional) Specifies the version where the postgres server will be deployed."
  type        = number
  default     = 7
}

variable "geo_redundant_backup_enabled" {
  description = "(Optional) Specifies the version where the postgres server will be deployed."
  type        = bool
  default     = false
}

variable "auto_grow_enabled" {
  description = "(Optional) Specifies the version where the postgres server will be deployed."
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "(Optional) Specifies the version where the postgres server will be deployed."
  type        = bool
  default     = true
}

variable "ssl_enforcement_enabled" {
  description = "(Optional) Specifies the version where the postgres server will be deployed."
  type        = bool
  default     = true
}

variable "ssl_minimal_tls_version_enforced" {
  description = "(Optional) Specifies the ssl version where the postgres server will be deployed."
  type        = string
  default     = "TLS1_2"
}

variable "aks_system_subnet_id" {
  description = "(Required) Specifies the aks system subnet id where the postgres server will be deployed."
  type        = string
}

variable "aks_user_subnet_id" {
  description = "(Required) Specifies the aks user subnet id where the postgres server will be deployed."
  type        = string
}

variable "aks_vm_subnet_id" {
  description = "(Required) Specifies the aks vm subnet id where the postgres server will be deployed."
  type        = string
}

variable "aks_sql_subnet_id" {
  description = "(Required) Specifies the aks sql subnet id where the postgres server will be deployed."
  type        = string
}

variable "aks_system_subnet_name" {
  description = "(Required) Specifies the aks system subnet name where the postgres server will be deployed."
  type        = string
}

variable "aks_user_subnet_name" {
  description = "(Required) Specifies the aks user subnet name where the postgres server will be deployed."
  type        = string
}

variable "aks_vm_subnet_name" {
  description = "(Required) Specifies the aks vm subnet name where the postgres server will be deployed."
  type        = string
}

variable "aks_sql_subnet_name" {
  description = "(Required) Specifies the aks sql subnet name where the postgres server will be deployed."
  type        = string
}

variable "aks_system_subnet_address_prefix" {
  description = "(Required) Specifies the subnet id where the postgres server will be deployed."
  type        = string
}

variable "aks_user_subnet_address_prefix" {
  description = "(Required) Specifies the subnet id where the postgres server will be deployed."
  type        = string
}

variable "aks_vm_subnet_address_prefix" {
  description = "(Required) Specifies the subnet id where the postgres server will be deployed."
  type        = string
}

variable "aks_sql_subnet_address_prefix" {
  description = "(Required) Specifies the subnet id where the postgres server will be deployed."
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
  default     = "postgresqlServer"
}
