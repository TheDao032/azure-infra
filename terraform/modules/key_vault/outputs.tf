output "name" {
  description = "Specifies the name of the key vault."
  value = azurerm_key_vault.main.name
}

output "id" {
  description = "Specifies the resource id of the key vault."
  value = azurerm_key_vault.main.id
}
