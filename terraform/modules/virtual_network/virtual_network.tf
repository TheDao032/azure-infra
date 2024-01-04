resource "azurerm_virtual_network" "hub" {
  name                = "${var.hub_vnet_name}-${var.env}"
  address_space       = var.hub_address_space
  location            = var.location
  resource_group_name = var.deployment_resource_group_name
  tags = merge(
    { Name = "${var.env}-vnet-main" },
    var.tags
  )

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_virtual_network" "aks" {
  name                = "${var.aks_vnet_name}-${var.env}"
  address_space       = var.aks_address_space
  location            = var.location
  resource_group_name = var.deployment_resource_group_name
  tags = merge(
    { Name = "${var.env}-vnet-main" },
    var.tags
  )

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}


resource "azurerm_subnet" "hub_firewall" {
  name                 = var.hub_firewall_subnet_name
  resource_group_name  = var.deployment_resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = var.hub_firewall_address_prefix
}

resource "azurerm_subnet" "hub_bastion" {
  name                 = var.hub_bastion_subnet_name
  resource_group_name  = var.deployment_resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = var.hub_bastion_address_prefix
}

# resource "azurerm_monitor_diagnostic_setting" "hub" {
#   name                       = "${azurerm_virtual_network.hub.name}-diagnostics-settings"
#   target_resource_id         = azurerm_virtual_network.hub.id
#   log_analytics_workspace_id = var.log_analytics_workspace_id
#
#   enabled_log {
#     category = "VMProtectionAlerts"
#   }
#
#   metric {
#     category = "AllMetrics"
#   }
#
#   depends_on = [azurerm_virtual_network.hub]
# }

resource "azurerm_subnet" "aks_system" {
  name                 = var.aks_system_subnet_name
  resource_group_name  = var.deployment_resource_group_name
  virtual_network_name = azurerm_virtual_network.aks.name
  address_prefixes     = var.aks_system_address_prefix

  service_endpoints = var.aks_subnet_service_endpoints
}

resource "azurerm_subnet" "aks_user" {
  name                 = var.aks_user_subnet_name
  resource_group_name  = var.deployment_resource_group_name
  virtual_network_name = azurerm_virtual_network.aks.name
  address_prefixes     = var.aks_user_address_prefix

  service_endpoints = var.aks_subnet_service_endpoints
}

resource "azurerm_subnet" "aks_vm" {
  name                 = var.aks_vm_subnet_name
  resource_group_name  = var.deployment_resource_group_name
  virtual_network_name = azurerm_virtual_network.aks.name
  address_prefixes     = var.aks_vm_address_prefix

  service_endpoints = var.aks_subnet_service_endpoints
}

resource "azurerm_subnet" "aks_sql_database" {
  name                 = var.aks_sql_subnet_name
  resource_group_name  = var.deployment_resource_group_name
  virtual_network_name = azurerm_virtual_network.aks.name
  address_prefixes     = var.aks_sql_address_prefix

  service_endpoints = var.aks_subnet_service_endpoints
}

locals {
  key_vault_access_subnet_ids = [azurerm_subnet.aks_vm.id, azurerm_subnet.aks_user.id, azurerm_subnet.aks_system.id]
}

# resource "azurerm_monitor_diagnostic_setting" "aks" {
#   name                       = "${azurerm_virtual_network.aks.name}-diagnostics-settings"
#   target_resource_id         = azurerm_virtual_network.aks.id
#   log_analytics_workspace_id = var.log_analytics_workspace_id
#
#   enabled_log {
#     category = "VMProtectionAlerts"
#   }
#
#   metric {
#     category = "AllMetrics"
#   }
#
#   depends_on = [azurerm_virtual_network.aks]
# }
