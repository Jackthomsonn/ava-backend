terraform {
  required_providers {
    auth0 = {
      source  = "alexkappa/auth0"
      version = "~> 0.16.0"
    }
  }
}

resource "auth0_resource_server" "resource-server" {
  name                                            = var.name
  identifier                                      = var.identifier
  skip_consent_for_verifiable_first_party_clients = var.skip_consent_for_verifiable_first_party_clients
  token_dialect                                   = "access_token_authz"
  enforce_policies                                = true

  dynamic "scopes" {
    for_each = var.scopes
    content {
      value = scopes.value.name
      description = scopes.value.description
    }
  }
}