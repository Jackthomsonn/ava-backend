terraform {
  required_providers {
    auth0 = {
      source  = "alexkappa/auth0"
      version = "~> 0.16.0"
    }
  }
}

resource "auth0_client" "auth0-client" {
  name            = var.name
  description     = var.description
  app_type        = var.app_type
  callbacks       = var.callbacks
  oidc_conformant = true

  jwt_configuration {
    alg = "RS256"
  }
}