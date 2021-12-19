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
  allowed_logout_urls = var.allowed_logout_urls
  oidc_conformant = true
  token_endpoint_auth_method = var.token_endpoint_auth_method

  lifecycle {
    ignore_changes = [
      custom_login_page_preview
    ]
  }

  jwt_configuration {
    alg = "RS256"
  }
}

resource "auth0_client_grant" "client-grant" {
  count = length(var.client_grants)

  client_id = var.client_grants[count.index].client_id
  audience  = var.client_grants[count.index].audience
  scope = var.client_grants[count.index].scope
}