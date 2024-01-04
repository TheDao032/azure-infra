output "acr_private_dns_id" {
  description = "Specifies the resource id of the private dns zone"
  value       = azurerm_private_dns_zone.acr.id
}

output "key_vault_private_dns_id" {
  description = "Specifies the resource id of the private dns zone"
  value       = azurerm_private_dns_zone.key_vault.id
}

output "blob_private_dns_id" {
  description = "Specifies the resource id of the private dns zone"
  value       = azurerm_private_dns_zone.blob.id
}
