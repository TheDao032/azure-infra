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

dependency "log_analytics" {
  config_path = "../log_analytics"
  mock_outputs = {
    id                 = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.OperationalInsights/workspaces/workspaceValue"
    primary_shared_key = "dump"
    workspace_id       = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.OperationalInsights/workspaces/workspaceValue"
  }

  mock_outputs_merge_strategy_with_state = "shallow"
}

dependency "virtual_network" {
  config_path = "../virtual_network"
  mock_outputs = {
    key_vault_access_virtual_network_subnet_ids = tolist(["/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.OperationalInsights/workspaces/workspaceValue"])
    aks_vm_subnet_id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.OperationalInsights/workspaces/workspaceValue"
  }

  mock_outputs_merge_strategy_with_state = "shallow"
}

dependencies {
  paths = ["../resource_group", "../log_analytics", "../virtual_network"]
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../modules//container_registry"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

inputs = {
  log_analytics_workspace_id          = dependency.log_analytics.outputs.workspace_id
  log_analytics_workspace_key         = dependency.log_analytics.outputs.primary_shared_key
  log_analytics_workspace_resource_id = dependency.log_analytics.outputs.id

  deployment_resource_group_name = dependency.resource_group.outputs.name

  virtual_network_subnet_ids = dependency.virtual_network.outputs.key_vault_access_virtual_network_subnet_ids
  subnet_id = dependency.virtual_network.outputs.aks_vm_subnet_id
  # Overrides variables from env.hcl
}
