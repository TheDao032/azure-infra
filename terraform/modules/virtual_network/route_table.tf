data "azurerm_client_config" "current" {
}

resource "azurerm_route_table" "main" {
  name                = "${var.route_table_name}-${var.env}"
  location            = var.location
  resource_group_name = var.deployment_resource_group_name
  tags = merge(
    { Name = "${var.env}-rt-main" },
    var.tags
  )

  # route {
  #   name                   = "kubenetfw_fw_r"
  #   address_prefix         = "0.0.0.0/0"
  #   next_hop_type          = "VirtualAppliance"
  #   next_hop_in_ip_address = azurerm_firewall.main.ip_configuration[0].private_ip_address
  # }

  lifecycle {
    ignore_changes = [
      tags
      # route
    ]
  }
}

resource "azurerm_subnet_route_table_association" "aks_system" {
  subnet_id      = azurerm_subnet.aks_system.id
  route_table_id = azurerm_route_table.main.id
}

resource "azurerm_subnet_route_table_association" "aks_user" {
  subnet_id      = azurerm_subnet.aks_user.id
  route_table_id = azurerm_route_table.main.id
}

resource "azurerm_subnet_route_table_association" "aks_vm" {
  subnet_id      = azurerm_subnet.aks_vm.id
  route_table_id = azurerm_route_table.main.id
}

resource "azurerm_subnet_route_table_association" "aks_sql_database" {
  subnet_id      = azurerm_subnet.aks_sql_database.id
  route_table_id = azurerm_route_table.main.id
}
