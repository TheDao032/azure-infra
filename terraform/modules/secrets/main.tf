locals {
  secrets_parameters            = { for k, v in var.secrets : k => v if contains(split(" ", v), "_RANDOM_") }
  secrets_resolve_parameters    = { for k, v in random_password.secrets : k => v.result }
  secrets                       = merge(var.secrets, local.secrets_resolve_parameters)
}

resource "random_password" "secrets" {
  for_each         = local.secrets_parameters
  length           = regex("[0-9]+", each.value)
  override_special = "!@#$%&*()-=+[]{}<>:?"
  min_lower        = var.min_lower
  min_upper        = var.min_upper
  min_numeric      = var.min_numeric
  min_special      = var.min_special

  lifecycle {
    ignore_changes = [
      override_special
    ]
  }
}

resource "azurerm_key_vault_secret" "secrets" {
  for_each     = local.secrets
  name         = each.key
  value        = each.value
  key_vault_id = var.key_vault_id
}

resource "null_resource" "vm_secrets" {
  provisioner "local-exec" {
    command = <<EOT
      echo "${local.secrets["jumpboxAgentUsername"]}: ${local.secrets["jumpboxAgentPassword"]}"
    EOT
  }

  depends_on = [random_password.secrets]
}
