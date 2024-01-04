variable "secrets" {
  description = "secrets"
  type        = map(any)
}

variable "key_vault_id" {
  description = "keyvault id"
  type        = string
}

variable "min_lower" {
  description = "min lower case"
  type        = number
  default     = 1
}

variable "min_upper" {
  description = "min upper case"
  type        = number
  default     = 1
}

variable "min_numeric" {
  description = "min number"
  type        = number
  default     = 1
}

variable "min_special" {
  description = "min special charactor"
  type        = number
  default     = 1
}

variable "tags" {
  description = "(Optional) Specifies the tags of the storage account"
  type        = map(any)
  default     = {}
}
