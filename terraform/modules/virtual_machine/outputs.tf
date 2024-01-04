output "id" {
  description = "Specifies the name of the hub virtual network"
  value       = azurerm_linux_virtual_machine.main.id
}

output "public_ip_address" {
  description = "Specifies the name of the hub virtual network"
  value       = data.azurerm_public_ip.public_ip_data.ip_address
}
