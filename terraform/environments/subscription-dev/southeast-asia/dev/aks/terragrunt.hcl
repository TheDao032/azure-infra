locals {
  # Automatically load environment-level variables
  subscription_vars = read_terragrunt_config(find_in_parent_folders("subscription.hcl", find_in_parent_folders("fallback.hcl"))) # Automatically load subscription-level variables
  environment_vars  = read_terragrunt_config(find_in_parent_folders("env.hcl", find_in_parent_folders("fallback.hcl")))          # Automatically load environment-level variables

  # aks_ssh_public_key = get_env("AKS_SSH_PUBLIC_KEY")
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

dependency "virtual_network" {
  config_path = "../virtual_network"
  mock_outputs = {
    aks_system_subnet_id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.Network/virtualNetworks/virtualNetworksValue/subnets/subnetValue"
    aks_user_subnet_id   = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.Network/virtualNetworks/virtualNetworksValue/subnets/subnetValue"
  }

  mock_outputs_merge_strategy_with_state = "shallow"
}

dependencies {
  paths = ["../resource_group", "../log_analytics", "../virtual_network"]
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../modules//aks"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

inputs = {
  log_analytics_workspace_id     = dependency.log_analytics.outputs.id
  deployment_resource_group_name = dependency.resource_group.outputs.name

  aks_system_subnet_id = dependency.virtual_network.outputs.aks_system_subnet_id
  aks_user_subnet_id   = dependency.virtual_network.outputs.aks_user_subnet_id

  # ssh_public_key = local.aks_ssh_public_key
  admin_group_object_ids = [local.subscription_vars.locals.object_id]

  network_dns_service_ip = local.environment_vars.locals.aks_network_dns_service_ip
  network_service_cidr   = local.environment_vars.locals.aks_network_service_cidr

  # Overrides variables from env.hcl
}
