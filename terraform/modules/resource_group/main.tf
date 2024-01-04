resource "azurerm_resource_group" "main" {
  name     = "${var.deployment_resource_group_name}-${var.env}"
  location = var.location
  tags = merge(
    { Name = "${var.env}-rg-main" },
    var.tags
  )
}
