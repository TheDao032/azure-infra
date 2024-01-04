output "name" {
  description = "Specifies the name of the storage account"
  value       = azurerm_storage_account.main.name
}

output "id" {
  description = "Specifies the resource id of the storage account"
  value       = azurerm_storage_account.main.id
}

output "primary_access_key" {
  description = "Specifies the primary access key of the storage account"
  value       = azurerm_storage_account.main.primary_access_key
  sensitive   = true
}

output "principal_id" {
  description = "Specifies the principal id of the system assigned managed identity of the storage account"
  value       = azurerm_storage_account.main.identity[0].principal_id
}

output "primary_blob_endpoint" {
  description = "Specifies the primary blob endpoint of the storage account"
  value       = azurerm_storage_account.main.primary_blob_endpoint
}
