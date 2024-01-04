variable "tags" {
  description = "(Optional) Specifies the tags of the storage account"
  type        = map(any)
  default     = {}
}

variable "sql_dir" {
  description = "sql scripts directory"
  type        = string
  default     = "./scripts"
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

variable "db_server_name" {
  description = "(Required) Specifies the db_server_name where the postgres server will be deployed."
  type        = string
}

variable "secrets" {
  description = "(Required) Specifies the secrets where the postgres server will be deployed."
  type        = map(any)
}

variable "db_host" {
  description = "(Required) Specifies the db_host where the postgres server will be deployed."
  type        = string
  default     = "postgres"
}

variable "db_port" {
  description = "(Required) Specifies the db_host where the postgres server will be deployed."
  type        = string
  default     = "5432"
}

variable "db_master_name" {
  description = "(Required) Specifies the db_host where the postgres server will be deployed."
  type        = string
}

variable "db_master_password" {
  description = "(Required) Specifies the db_master_password where the postgres server will be deployed."
  type        = string
}

variable "db_master_username" {
  description = "(Required) Specifies the db_master_password where the postgres server will be deployed."
  type        = string
}

variable "provisioner_host" {
  description = "(Required) Specifies the provisioner_host"
  type        = string
}
