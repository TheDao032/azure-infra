# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  env = "staging"

  aks_address_space = ["10.100.0.0/16"]
  hub_address_space = ["10.1.0.0/16"]

  aks_network_dns_service_ip = "10.0.0.10"
  aks_network_service_cidr = "10.0.0.0/24"

  aks_system_address_prefix = ["10.100.10.0/24"]
  aks_user_address_prefix = ["10.100.11.0/24"]
  aks_vm_address_prefix = ["10.100.12.0/24"]
  aks_sql_address_prefix = ["10.100.13.0/24"]

  hub_firewall_address_prefix = ["10.1.0.0/24"]
  hub_bastion_address_prefix = ["10.1.1.0/24"]

  secrets = {
    dumpuserDatabaseUsername = "dumpuserservice"
    dumpuserDatabasePassword = "{ _RANDOM_ = 18 }"
  }
}
