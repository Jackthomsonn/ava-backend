terraform {
  required_providers {
    auth0 = {
      source  = "alexkappa/auth0"
      version = "~> 0.16.0"
    }
  }
}

resource "auth0_connection" "connection" {
  name     = var.name
  strategy = var.strategy
  options {
    password_policy        = "excellent"
    brute_force_protection = true
    disable_signup = var.disable_signup
  }
  enabled_clients = var.enabled_clients
}
