# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  subscription_id = get_env("SUBSCRIPTION_ID")
  container_name = get_env("CONTAINER_NAME")

  client_id = get_env("ARM_CLIENT_ID")
  client_secret = get_env("ARM_CLIENT_SECRET")
  tenant_id = get_env("ARM_TENANT_ID")
  object_id = get_env("ARM_OBJECT_ID")

  azure_devops_url = get_env("AZP_AGENT_URL")
  azure_devops_pat = get_env("AZP_TOKEN")
  azure_devops_agent_pool_name = get_env("AZP_POOL")
  azure_devops_agent_name = get_env("AZP_AGENT_NAME")
  targetarch = get_env("TARGETARCH")
  cr_password = get_env("CR_PASSWORD")
  cr_name = get_env("CR_NAME")
}
