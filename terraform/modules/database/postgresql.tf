resource "random_string" "main" {
  length  = 8
  special = false
  lower   = true
  upper   = false
  numeric  = false
}

resource "azurerm_postgresql_server" "main" {
  name                = "${var.postgresql_name_prefix}-${random_string.main.result}"
  location            = var.location
  resource_group_name = var.deployment_resource_group_name

  administrator_login          = var.db_username
  administrator_login_password = var.db_password

  sku_name   = var.sku
  version    = var.posgresql_version
  storage_mb = var.storage_mb

  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled
  auto_grow_enabled            = var.auto_grow_enabled

  public_network_access_enabled    = var.public_network_access_enabled
  ssl_enforcement_enabled          = var.ssl_enforcement_enabled
  ssl_minimal_tls_version_enforced = var.ssl_minimal_tls_version_enforced
}

# resource "azurerm_postgresql_database" "main" {
#   name                = var.db_name
#   resource_group_name = var.deployment_resource_group_name
#   server_name         = azurerm_postgresql_server.main.name
#   charset             = "UTF8"
#   collation           = "English_United States.1252"
#
#   # prevent the possibility of accidental data loss
#   lifecycle {
#     prevent_destroy = true
#   }
# }

resource "azurerm_postgresql_virtual_network_rule" "aks_system" {
  name                                 = "${azurerm_postgresql_server.main.name}-aks-system-vnet-rule"
  resource_group_name                  = var.deployment_resource_group_name
  server_name                          = azurerm_postgresql_server.main.name
  subnet_id                            = var.aks_system_subnet_id
  # ignore_missing_vnet_service_endpoint = true
}

resource "azurerm_postgresql_virtual_network_rule" "aks_user" {
  name                                 = "${azurerm_postgresql_server.main.name}-aks-user-vnet-rule"
  resource_group_name                  = var.deployment_resource_group_name
  server_name                          = azurerm_postgresql_server.main.name
  subnet_id                            = var.aks_user_subnet_id
  # ignore_missing_vnet_service_endpoint = true
}

resource "azurerm_postgresql_virtual_network_rule" "aks_vm" {
  name                                 = "${azurerm_postgresql_server.main.name}-aks-vm-vnet-rule"
  resource_group_name                  = var.deployment_resource_group_name
  server_name                          = azurerm_postgresql_server.main.name
  subnet_id                            = var.aks_vm_subnet_id
  # ignore_missing_vnet_service_endpoint = true
}

resource "azurerm_postgresql_virtual_network_rule" "aks_sql_database" {
  name                                 = "${azurerm_postgresql_server.main.name}-aks-sql-database-vnet-rule"
  resource_group_name                  = var.deployment_resource_group_name
  server_name                          = azurerm_postgresql_server.main.name
  subnet_id                            = var.aks_sql_subnet_id
  # ignore_missing_vnet_service_endpoint = true
}

resource "azurerm_postgresql_firewall_rule" "aks_system" {
  name                = "AllowSubnetAccess_${var.aks_system_subnet_name}"
  resource_group_name = var.deployment_resource_group_name
  server_name         = azurerm_postgresql_server.main.name
  start_ip_address    = cidrhost(var.aks_system_subnet_address_prefix, 0)
  end_ip_address      = cidrhost(var.aks_system_subnet_address_prefix, -1)
}

resource "azurerm_postgresql_firewall_rule" "aks_user" {
  name                = "AllowSubnetAccess_${var.aks_user_subnet_name}"
  resource_group_name = var.deployment_resource_group_name
  server_name         = azurerm_postgresql_server.main.name
  start_ip_address    = cidrhost(var.aks_user_subnet_address_prefix, 0)
  end_ip_address      = cidrhost(var.aks_user_subnet_address_prefix, -1)
}

resource "azurerm_postgresql_firewall_rule" "aks_vm" {
  name                = "AllowSubnetAccess_${var.aks_vm_subnet_name}"
  resource_group_name = var.deployment_resource_group_name
  server_name         = azurerm_postgresql_server.main.name
  start_ip_address    = cidrhost(var.aks_vm_subnet_address_prefix, 0)
  end_ip_address      = cidrhost(var.aks_vm_subnet_address_prefix, -1)
}

resource "azurerm_postgresql_firewall_rule" "aks_sql_database" {
  name                = "AllowSubnetAccess_${var.aks_sql_subnet_name}"
  resource_group_name = var.deployment_resource_group_name
  server_name         = azurerm_postgresql_server.main.name
  start_ip_address    = cidrhost(var.aks_sql_subnet_address_prefix, 0)
  end_ip_address      = cidrhost(var.aks_sql_subnet_address_prefix, -1)
}

resource "azurerm_private_endpoint" "main" {
  name                = azurerm_postgresql_server.main.name
  location            = var.location
  resource_group_name = var.deployment_resource_group_name
  subnet_id           = var.aks_sql_subnet_id
  tags = merge(
    { Name = azurerm_postgresql_server.main.name },
    { Environment = var.env },
    var.tags
  )

  private_service_connection {
    name                           = "${azurerm_postgresql_server.main.name}Connection"
    private_connection_resource_id = azurerm_postgresql_server.main.id
    is_manual_connection           = var.is_manual_connection
    subresource_names              = try([var.subresource_name], null)
    # request_message                = try(var.request_message, null)
  }

  # private_dns_zone_group {
  #   name                 = var.private_dns_zone_group_name
  #   private_dns_zone_ids = var.private_dns_zone_group_ids
  # }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }

  depends_on = [azurerm_postgresql_server.main]
}

