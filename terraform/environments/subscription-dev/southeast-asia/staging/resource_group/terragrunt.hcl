locals {
  # Automatically load environment-level variables
  deployment_resource_group_name = "AKSNTUC"
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../modules//resource_group"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

inputs = {
  # Overrides variables from env.hcl
  deployment_resource_group_name = local.deployment_resource_group_name
}
