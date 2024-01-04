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

dependency "database" {
  config_path = "../database"
  mock_outputs = {
    name = "dump"
    fqdn = "dump"
  }

  mock_outputs_merge_strategy_with_state = "shallow"
}

dependency "secrets" {
  config_path = "../secrets"
  mock_outputs = {
    secrets = {
      databaseMasterUsername = "dump"
      databaseMasterPassword = "dump"
      databaseMasterName     = "dump"
    }
  }

  mock_outputs_merge_strategy_with_state = "shallow"
}

dependency "virtual_machine" {
  config_path = "../virtual_machine"
  mock_outputs = {
    public_ip_address = "1.2.3.4"
  }

  mock_outputs_merge_strategy_with_state = "shallow"
}

dependencies {
  paths = ["../resource_group", "../database", "../secrets", "../virtual_machine"]
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../modules//sql"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

inputs = {
  deployment_resource_group_name = dependency.resource_group.outputs.name
  db_master_username             = dependency.secrets.outputs.secrets["databaseMasterUsername"]
  db_master_password             = dependency.secrets.outputs.secrets["databaseMasterPassword"]
  db_master_name                 = dependency.secrets.outputs.secrets["databaseMasterName"]

  db_server_name   = dependency.database.outputs.name
  db_host          = dependency.database.outputs.fqdn
  secrets          = dependency.secrets.outputs.secrets
  provisioner_host = dependency.virtual_machine.outputs.public_ip_address
  # Overrides variables from env.hcl
}
