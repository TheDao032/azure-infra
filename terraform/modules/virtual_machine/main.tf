resource "azurerm_public_ip" "main" {
  name                = "${var.name}-public-ip-${var.env}"
  location            = var.location
  resource_group_name = var.deployment_resource_group_name
  allocation_method   = "Dynamic"
  domain_name_label   = lower(var.domain_name_label)
  count               = var.public_ip ? 1 : 0

  tags = merge(
    { Name = "${var.env}-public-ip-main" },
    var.tags
  )

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_network_security_group" "main" {
  name                = "${var.name}-nsg-${var.env}"
  location            = var.location
  resource_group_name = var.deployment_resource_group_name
  tags                = var.tags

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_network_interface" "main" {
  name                = "${var.name}-nic-${var.env}"
  location            = var.location
  resource_group_name = var.deployment_resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "Configuration"
    subnet_id                     = var.aks_vm_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = try(azurerm_public_ip.main[0].id, null)
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }

  depends_on = [azurerm_public_ip.main]
}

resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.main.id
  depends_on                = [azurerm_network_security_group.main]
}

resource "azurerm_linux_virtual_machine" "main" {
  name                            = "${var.name}-${var.env}"
  location                        = var.location
  resource_group_name             = var.deployment_resource_group_name
  network_interface_ids           = [azurerm_network_interface.main.id]
  size                            = var.size
  computer_name                   = var.name
  admin_username                  = var.jumpbox_vm_username
  admin_password                  = var.jumpbox_vm_passwd
  tags                            = var.tags
  disable_password_authentication = false

  os_disk {
    name                 = "${var.name}-os-disk"
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_storage_account_type
  }

  source_image_reference {
    offer     = lookup(var.os_disk_image, "offer", null)
    publisher = lookup(var.os_disk_image, "publisher", null)
    sku       = lookup(var.os_disk_image, "sku", null)
    version   = lookup(var.os_disk_image, "version", null)
  }

  boot_diagnostics {
    storage_account_uri = var.boot_diagnostics_storage_account == "" ? null : var.boot_diagnostics_storage_account
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }

  depends_on = [
    azurerm_network_interface.main,
    azurerm_network_security_group.main
  ]
}

data "azurerm_public_ip" "public_ip_data" {
  name                = azurerm_public_ip.main[0].name
  resource_group_name = azurerm_linux_virtual_machine.main.resource_group_name
}

resource "azurerm_virtual_machine_extension" "custom_script" {
  name                 = "${var.name}-custom-script-${var.env}"
  virtual_machine_id   = azurerm_linux_virtual_machine.main.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = <<SETTINGS
    {
      "fileUris":
      ["https://${var.script_storage_account_name}.blob.core.windows.net/${var.container_name}/${var.script_name}"],
      "commandToExecute": "bash ${var.script_name} '${var.jumpbox_vm_username}' '${var.client_id}' '${var.client_secret}' '${var.tenant_id}' '${var.azure_devops_url}' '${var.azure_devops_pat}' '${var.azure_devops_agent_pool_name}' '${var.azure_devops_agent_name}' '${var.targetarch}' '${var.cr_password}' '${var.cr_name}'"
    }
  SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "storageAccountName": "${var.script_storage_account_name}",
      "storageAccountKey": "${var.script_storage_account_key}"
    }
  PROTECTED_SETTINGS

  lifecycle {
    ignore_changes = [
      tags,
      settings,
      protected_settings
    ]
  }
}

# resource "azurerm_virtual_machine_extension" "monitor_agent" {
#   name                       = "${var.name}-monitoring-agent-${var.env}"
#   virtual_machine_id         = azurerm_linux_virtual_machine.main.id
#   publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
#   type                       = "OmsAgentForLinux"
#   type_handler_version       = "1.12"
#   auto_upgrade_minor_version = true
#
#   settings = <<SETTINGS
#     {
#       "workspaceId": "${var.log_analytics_workspace_id}"
#     }
#   SETTINGS
#
#   protected_settings = <<PROTECTED_SETTINGS
#     {
#       "workspaceKey": "${var.log_analytics_workspace_key}"
#     }
#   PROTECTED_SETTINGS
#
#   lifecycle {
#     ignore_changes = [
#       tags
#     ]
#   }
#   depends_on = [azurerm_linux_virtual_machine.main]
# }
#
# resource "azurerm_virtual_machine_extension" "dependency_agent" {
#   name                       = "${var.name}-dependency-agent-${var.env}"
#   virtual_machine_id         = azurerm_linux_virtual_machine.main.id
#   publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
#   type                       = "DependencyAgentLinux"
#   type_handler_version       = "9.10"
#   auto_upgrade_minor_version = true
#
#   settings = <<SETTINGS
#     {
#       "workspaceId": "${var.log_analytics_workspace_id}"
#     }
#   SETTINGS
#
#   protected_settings = <<PROTECTED_SETTINGS
#     {
#       "workspaceKey": "${var.log_analytics_workspace_key}"
#     }
#   PROTECTED_SETTINGS
#
#   lifecycle {
#     ignore_changes = [
#       tags
#     ]
#   }
#   depends_on = [azurerm_virtual_machine_extension.monitor_agent]
# }

# resource "azurerm_monitor_diagnostic_setting" "main" {
#   name                       = "${azurerm_network_security_group.main.name}-diagnostics-settings"
#   target_resource_id         = azurerm_network_security_group.main.id
#   log_analytics_workspace_id = var.log_analytics_workspace_resource_id
#
#   enabled_log {
#     category = "NetworkSecurityGroupEvent"
#   }
#
#   enabled_log {
#     category = "NetworkSecurityGroupRuleCounter"
#   }
#   depends_on = [azurerm_network_security_group.main]
# }
