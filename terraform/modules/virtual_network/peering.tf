locals {
  hub_vnet_name = "${var.hub_vnet_name}-${var.env}"
  aks_vnet_name = "${var.aks_vnet_name}-${var.env}"
}

resource "azurerm_virtual_network_peering" "forward" {
  name                         = "${var.hub_vnet_name}-${var.aks_vnet_name}-${var.env}"
  resource_group_name          = var.deployment_resource_group_name
  virtual_network_name         = local.hub_vnet_name
  remote_virtual_network_id    = azurerm_virtual_network.aks.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  depends_on = [azurerm_virtual_network.hub, azurerm_virtual_network.aks]
}

resource "azurerm_virtual_network_peering" "trace_back" {
  name                         = "${var.aks_vnet_name}-${var.hub_vnet_name}-${var.env}"
  resource_group_name          = var.deployment_resource_group_name
  virtual_network_name         = local.aks_vnet_name
  remote_virtual_network_id    = azurerm_virtual_network.hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  depends_on = [azurerm_virtual_network.hub, azurerm_virtual_network.aks]
}
