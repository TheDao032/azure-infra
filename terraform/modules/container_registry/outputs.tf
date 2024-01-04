output "name" {
  description = "Specifies the name of the container registry."
  value       = azurerm_container_registry.main.name
}

output "id" {
  description = "Specifies the resource id of the container registry."
  value       = azurerm_container_registry.main.id
}

output "resource_group_name" {
  description = "Specifies the name of the resource group."
  value       = var.deployment_resource_group_name
}

output "login_server" {
  description = "Specifies the login server of the container registry."
  value = azurerm_container_registry.main.login_server
}

output "login_server_url" {
  description = "Specifies the login server url of the container registry."
  value = "https://${azurerm_container_registry.main.login_server}"
}

output "admin_username" {
  description = "Specifies the admin username of the container registry."
  value = azurerm_container_registry.main.admin_username
}

output "admin_password" {
  description = "Specifies the admin username of the container registry."
  sensitive = true
  value = azurerm_container_registry.main.admin_password
}


