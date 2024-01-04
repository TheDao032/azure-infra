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
      databaseMasterUsername = "dump"
      databaseMasterPassword = "dump"
      databaseMasterName     = "dump"
    }
  }

  mock_outputs_merge_strategy_with_state = "shallow"
}

dependency "virtual_network" {
  config_path = "../virtual_network"
  mock_outputs = {
    aks_sql_subnet_id    = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.Network/virtualNetworks/virtualNetworksValue/subnets/subnetValue"
    aks_system_subnet_id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.Network/virtualNetworks/virtualNetworksValue/subnets/subnetValue"
    aks_user_subnet_id   = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.Network/virtualNetworks/virtualNetworksValue/subnets/subnetValue"
    aks_vm_subnet_id     = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.Network/virtualNetworks/virtualNetworksValue/subnets/subnetValue"

    aks_sql_subnet_name    = "dump"
    aks_vm_subnet_name     = "dump"
    aks_user_subnet_name   = "dump"
    aks_system_subnet_name = "dump"

    aks_sql_subnet_address_prefix    = "10.0.13.0/24"
    aks_vm_subnet_address_prefix     = "10.0.12.0/24"
    aks_user_subnet_address_prefix   = "10.0.11.0/24"
    aks_system_subnet_address_prefix = "10.0.10.0/24"
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

  db_username = dependency.secrets.outputs.secrets["databaseMasterUsername"]
  db_password = dependency.secrets.outputs.secrets["databaseMasterPassword"]
  db_name     = dependency.secrets.outputs.secrets["databaseMasterName"]

  aks_sql_subnet_id    = dependency.virtual_network.outputs.aks_sql_subnet_id
  aks_system_subnet_id = dependency.virtual_network.outputs.aks_system_subnet_id
  aks_user_subnet_id   = dependency.virtual_network.outputs.aks_user_subnet_id
  aks_vm_subnet_id     = dependency.virtual_network.outputs.aks_vm_subnet_id

  aks_sql_subnet_name    = dependency.virtual_network.outputs.aks_sql_subnet_name
  aks_system_subnet_name = dependency.virtual_network.outputs.aks_system_subnet_name
  aks_user_subnet_name   = dependency.virtual_network.outputs.aks_user_subnet_name
  aks_vm_subnet_name     = dependency.virtual_network.outputs.aks_vm_subnet_name

  aks_sql_subnet_address_prefix    = dependency.virtual_network.outputs.aks_sql_subnet_address_prefix
  aks_system_subnet_address_prefix = dependency.virtual_network.outputs.aks_system_subnet_address_prefix
  aks_user_subnet_address_prefix   = dependency.virtual_network.outputs.aks_user_subnet_address_prefix
  aks_vm_subnet_address_prefix     = dependency.virtual_network.outputs.aks_vm_subnet_address_prefix
  # Overrides variables from env.hcl
}
