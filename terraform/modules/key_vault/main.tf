data "azurerm_client_config" "current" {}

resource "random_string" "main" {
  length  = 8
  special = false
  lower   = true
  upper   = false
  numeric = false
}

resource "azurerm_key_vault" "main" {
  name                            = "${var.name_prefix}${random_string.main.result}${var.env}"
  location                        = var.location
  resource_group_name             = var.deployment_resource_group_name
  tenant_id                       = var.tenant_id
  sku_name                        = var.sku_name
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_rbac_authorization       = var.enable_rbac_authorization
  purge_protection_enabled        = var.purge_protection_enabled
  soft_delete_retention_days      = var.soft_delete_retention_days

  tags = merge(
    { Name = var.env },
    var.tags
  )

  # access_policy {
  #   tenant_id = data.azurerm_client_config.current.tenant_id
  #   object_id = data.azurerm_client_config.current.object_id
  #
  #   key_permissions = [
  #     "Create",
  #     "Get",
  #   ]
  #
  #   secret_permissions = [
  #     "Set",
  #     "Get",
  #     "Delete",
  #     "Purge",
  #     "Recover"
  #   ]
  # }

  network_acls {
    bypass                     = var.bypass
    default_action             = var.default_action
    ip_rules                   = var.ip_rules
    virtual_network_subnet_ids = var.virtual_network_subnet_ids
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_role_assignment" "main" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = var.role_definition_name
  principal_id         = data.azurerm_client_config.current.object_id

  depends_on = [azurerm_key_vault.main]
}

resource "azurerm_private_endpoint" "main" {
  name                = azurerm_key_vault.main.name
  location            = var.location
  resource_group_name = var.deployment_resource_group_name
  subnet_id           = var.subnet_id
  tags = merge(
    { Name = azurerm_key_vault.main.name },
    { Environment = var.env },
    var.tags
  )

  private_service_connection {
    name                           = "${azurerm_key_vault.main.name}Connection"
    private_connection_resource_id = azurerm_key_vault.main.id
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

  depends_on = [azurerm_key_vault.main]
}

resource "azurerm_key_vault_secret" "main" {
  for_each     = var.secret_keys
  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [azurerm_role_assignment.main]
}
