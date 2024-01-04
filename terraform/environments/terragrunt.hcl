# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

locals {
  subscription_vars = read_terragrunt_config(find_in_parent_folders("subscription.hcl", "fallback.hcl"))                     # Automatically load subscription-level variables
  location_vars     = read_terragrunt_config(find_in_parent_folders("location.hcl", find_in_parent_folders("fallback.hcl"))) # Automatically load region-level variables
  environment_vars  = read_terragrunt_config(find_in_parent_folders("env.hcl", find_in_parent_folders("fallback.hcl")))      # Automatically load environment-level variables
  subscription_id   = local.subscription_vars.locals.subscription_id
  tenant_id         = local.subscription_vars.locals.tenant_id
  client_id         = local.subscription_vars.locals.client_id
  container_name    = local.subscription_vars.locals.container_name
  # deployment_resource_group_name  = local.location_vars.locals.deployment_resource_group_name
  resource_group_name  = local.location_vars.locals.resource_group_name
  storage_account_name = local.location_vars.locals.storage_account_name
  storage_account_key  = local.location_vars.locals.storage_account_name
  location             = local.location_vars.locals.location
}

# Generate an Azure provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }

    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
  subscription_id = "${local.subscription_id}"
}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an Blob Storage container
remote_state {
  backend = "azurerm"
  config = {
    subscription_id      = "${local.subscription_id}"
    resource_group_name  = "${local.resource_group_name}"
    storage_account_name = "${local.storage_account_name}"
    container_name       = "${local.container_name}"
    key                  = "${path_relative_to_include()}/terraform.tfstate"
    tenant_id            = "${local.tenant_id}"
    client_id            = "${local.client_id}"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.environment_vars.locals,
  local.location_vars.locals,
  local.subscription_vars.locals
)
