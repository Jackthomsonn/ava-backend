output "ci_cd_service_account_keys" {
  value     = module.ci_cd_service_account.keys
  sensitive = true
}

output "ci_cd_service_accounts" {
  value = module.ci_cd_service_account.service_accounts
}

output "elixir_app_service_account_keys" {
  value     = module.elixir_app_service_account.keys
  sensitive = true
}

output "elixir_app_service_accounts" {
  value = module.elixir_app_service_account.service_accounts
}
