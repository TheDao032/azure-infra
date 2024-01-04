# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  location             = "Southeast Asia"
  location_path             = "southeast-asia"

  resource_group_name  = get_env("RESOURCE_GROUP_NAME")
  storage_account_name = get_env("STORAGE_ACCOUNT_NAME")

  script_storage_account_name = get_env("STORAGE_ACCOUNT_NAME")
  script_storage_account_key = get_env("STORAGE_ACCOUNT_KEY")
}
