data "azurerm_client_config" "current" {}

resource "azurerm_container_registry" "main" {
  name                     = "${var.name}${var.env}"
  resource_group_name      = var.deployment_resource_group_name
  location                 = var.location
  sku                      = var.sku  
  admin_enabled            = var.admin_enabled
  tags                     = merge(
    { Name = "${var.name}-${var.env}" },
    var.tags
  )

  # identity {
  #   type = "UserAssigned"
  #   identity_ids = [
  #     azurerm_user_assigned_identity.main.id
  #   ]
  # }

  dynamic "georeplications" {
    for_each = var.georeplication_locations

    content {
      location = georeplications.value
      tags     = var.tags
    }
  }

  lifecycle {
      ignore_changes = [
          tags
      ]
  }
}

# resource "azurerm_user_assigned_identity" "main" {
#   resource_group_name = var.deployment_resource_group_name
#   location            = var.location
#   tags                = var.tags
#
#   name = "${var.name}Identity"
#
#   lifecycle {
#     ignore_changes = [
#       tags
#     ]
#   }
# }

resource "azurerm_private_endpoint" "main" {
  name                = azurerm_container_registry.main.name
  location            = var.location
  resource_group_name = var.deployment_resource_group_name
  subnet_id           = var.subnet_id
  tags                = merge(
    { Name = "${var.name}-${var.env}"},
    var.tags
  )

  private_service_connection {
    name                           = "${var.name}Connection"
    private_connection_resource_id = azurerm_container_registry.main.id
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
