locals {
  storage_account_prefix = "ntuc"
}

# Generate randon name for storage account
resource "random_string" "main" {
  length  = 8
  special = false
  lower   = true
  upper   = false
  numeric  = false
}

resource "azurerm_storage_account" "main" {
  name                = "${local.storage_account_prefix}${random_string.main.result}"
  resource_group_name = var.deployment_resource_group_name

  location                 = var.location
  account_kind             = var.account_kind
  account_tier             = var.account_tier
  account_replication_type = var.replication_type
  is_hns_enabled           = var.is_hns_enabled

  tags = merge(
    { Name = var.env },
    var.tags
  )

  # network_rules {
  #   default_action             = (length(var.ip_rules) + length(var.virtual_network_subnet_ids)) > 0 ? "Deny" : var.default_action
  #   ip_rules                   = var.ip_rules
  #   virtual_network_subnet_ids = var.virtual_network_subnet_ids
  # }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_private_endpoint" "main" {
  name                = azurerm_storage_account.main.name
  location            = var.location
  resource_group_name = var.deployment_resource_group_name
  subnet_id           = var.subnet_id
  tags                = merge(
    { Name = var.env},
    var.tags
  )

  private_service_connection {
    name                           = "${azurerm_storage_account.main.name}Connection"
    private_connection_resource_id = azurerm_storage_account.main.id
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
}
