locals {
  # Automatically load environment-level variables
}

dependency "resource_group" {
  config_path = "../resource_group"
  mock_outputs = {
    name = "dump"
  }

  mock_outputs_merge_strategy_with_state = "shallow"
}

dependency "secrets" {
  config_path = "../secrets"
  mock_outputs = {
    secrets = {
      dumpuserDatabaseUsername = "dump"
      dumpuserDatabasePassword = "dump"
    }
  }

  mock_outputs_merge_strategy_with_state = "shallow"
}

dependency "virtual_network" {
  config_path = "../virtual_network"
  mock_outputs = {
    aks_sql_subnet_id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.OperationalInsights/workspaces/workspaceValue"
  }

  mock_outputs_merge_strategy_with_state = "shallow"
}

dependencies {
  paths = ["../resource_group", "../secrets", "../virtual_network"]
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../modules//database"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

inputs = {
  deployment_resource_group_name = dependency.resource_group.outputs.name

  db_username = dependency.secrets.outputs.secrets["dumpuserDatabaseUsername"]
  db_password = dependency.secrets.outputs.secrets["dumpuserDatabasePassword"]

  subnet_id = dependency.virtual_network.outputs.aks_sql_subnet_id
  # Overrides variables from env.hcl
}
