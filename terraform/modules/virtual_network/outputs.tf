output "hub_vnet_name" {
  description = "Specifies the name of the hub virtual network"
  value       = azurerm_virtual_network.hub.name
}

output "aks_vnet_name" {
  description = "Specifies the name of the aks virtual network"
  value       = azurerm_virtual_network.aks.name
}

output "hub_vnet_id" {
  description = "Specifies the resource id of the hub virtual network"
  value       = azurerm_virtual_network.hub.id
}

output "aks_vnet_id" {
  description = "Specifies the resource id of the virtual network"
  value       = azurerm_virtual_network.aks.id
}

# output "hub_firewall_subnet_id" {
#   description = "Contains a list of the the resource id of the hub firewall subnet id"
#   value       = azurerm_subnet.hub_firewall.id
# }

output "hub_bastion_subnet_id" {
  description = "Contains a list of the the resource id of the hub bastion subnet id"
  value       = azurerm_subnet.hub_bastion.id
}

output "aks_system_subnet_id" {
  description = "Contains a list of the the resource id of the aks system subnet id"
  value       = azurerm_subnet.aks_system.id
}

output "aks_user_subnet_id" {
  description = "Contains a list of the the resource id of the aks user subnet id"
  value       = azurerm_subnet.aks_user.id
}

output "aks_vm_subnet_id" {
  description = "Contains a list of the the resource id of the aks virtual machine subnet id"
  value       = azurerm_subnet.aks_vm.id
}

output "aks_sql_subnet_id" {
  description = "Contains a list of the the resource id of the aks virtual machine subnet id"
  value       = azurerm_subnet.aks_sql_database.id
}

output "aks_system_subnet_name" {
  description = "Contains a list of the the resource id of the aks system subnet id"
  value       = azurerm_subnet.aks_system.name
}

output "aks_user_subnet_name" {
  description = "Contains a list of the the resource id of the aks user subnet id"
  value       = azurerm_subnet.aks_user.name
}

output "aks_vm_subnet_name" {
  description = "Contains a list of the the resource id of the aks virtual machine subnet id"
  value       = azurerm_subnet.aks_vm.name
}

output "aks_sql_subnet_name" {
  description = "Contains a list of the the resource id of the aks virtual machine subnet id"
  value       = azurerm_subnet.aks_sql_database.name
}

output "aks_sql_subnet_address_prefix" {
  description = "Contains a list of the the resource id of the aks virtual machine subnet id"
  value       = azurerm_subnet.aks_sql_database.address_prefixes[0]
}

output "aks_vm_subnet_address_prefix" {
  description = "Contains a list of the the resource id of the aks virtual machine subnet id"
  value       = azurerm_subnet.aks_vm.address_prefixes[0]
}

output "aks_user_subnet_address_prefix" {
  description = "Contains a list of the the resource id of the aks virtual machine subnet id"
  value       = azurerm_subnet.aks_user.address_prefixes[0]
}

output "aks_system_subnet_address_prefix" {
  description = "Contains a list of the the resource id of the aks virtual machine subnet id"
  value       = azurerm_subnet.aks_system.address_prefixes[0]
}

# output "private_ip_address" {
#   description = "Specifies the private IP address of the firewall."
#   value       = azurerm_firewall.main.ip_configuration[0].private_ip_address
# }

output "key_vault_access_virtual_network_subnet_ids" {
  description = "Specifies the private IP address of the firewall."
  value       = local.key_vault_access_subnet_ids
}
