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

dependency "virtual_network" {
  config_path = "../virtual_network"
  mock_outputs = {
    hub_vnet_id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.Network/virtualNetworks/virtualNetworksValue"
    aks_vnet_id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.Network/virtualNetworks/virtualNetworksValue"
  }

  mock_outputs_merge_strategy_with_state = "shallow"
}

dependencies {
  paths = ["../resource_group", "../virtual_network"]
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../modules//private_dns_zone"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

inputs = {
  deployment_resource_group_name = dependency.resource_group.outputs.name

  virtual_networks_to_link = tomap({
    hub_vnet_name = dependency.virtual_network.outputs.hub_vnet_id
    aks_vnet_name = dependency.virtual_network.outputs.aks_vnet_id
  })
  # Overrides variables from env.hcl
}
