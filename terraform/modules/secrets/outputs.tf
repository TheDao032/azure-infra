output "secrets" {
  description = "list of secrets"
  value = local.secrets
  sensitive = true
}
