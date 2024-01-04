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
    id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.OperationalInsights/workspaces/workspaceValue"
  }

  mock_outputs_merge_strategy_with_state = "shallow"
}

dependencies {
  paths = ["../resource_group", "../log_analytics"]
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../modules//virtual_network"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

inputs = {
  log_analytics_workspace_id     = dependency.log_analytics.outputs.id
  deployment_resource_group_name = dependency.resource_group.outputs.name
  # Overrides variables from env.hcl
}
