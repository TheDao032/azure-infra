resource "azurerm_private_dns_zone" "acr" {
  name                = var.private_dns_zone_acr_name
  resource_group_name = var.deployment_resource_group_name

  tags = merge(
    { Name = var.env },
    var.tags
  )

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_private_dns_zone" "key_vault" {
  name                = var.private_dns_zone_key_vault_name
  resource_group_name = var.deployment_resource_group_name

  tags = merge(
    { Name = var.env },
    var.tags
  )

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_private_dns_zone" "blob" {
  name                = var.private_dns_zone_blob_name
  resource_group_name = var.deployment_resource_group_name

  tags = merge(
    { Name = var.env },
    var.tags
  )

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "acr" {
  for_each = var.virtual_networks_to_link

  name                  = "link_to_${lower(basename(each.key))}"
  resource_group_name   = var.deployment_resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.acr.name
  virtual_network_id    = each.value

  tags = merge(
    { Name = var.env },
    var.tags
  )

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "key_vault" {
  for_each = var.virtual_networks_to_link

  name                  = "link_to_${lower(basename(each.key))}"
  resource_group_name   = var.deployment_resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.key_vault.name
  virtual_network_id    = each.value

  tags = merge(
    { Name = var.env },
    var.tags
  )

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob" {
  for_each = var.virtual_networks_to_link

  name                  = "link_to_${lower(basename(each.key))}"
  resource_group_name   = var.deployment_resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = each.value

  tags = merge(
    { Name = var.env },
    var.tags
  )

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
