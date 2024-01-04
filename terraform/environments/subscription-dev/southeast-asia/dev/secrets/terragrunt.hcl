locals {
  # Automatically load environment-level variables
}

dependency "key_vault" {
  config_path = "../key_vault"
  mock_outputs = {
    id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.KeyVault/vaults/vaultValue"
  }

  mock_outputs_merge_strategy_with_state = "shallow"
}

dependencies {
  paths = ["../key_vault"]
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../modules//secrets"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

inputs = {
  key_vault_id = dependency.key_vault.outputs.id
  # Overrides variables from env.hcl
}
