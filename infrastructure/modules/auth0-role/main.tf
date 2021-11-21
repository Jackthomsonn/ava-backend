terraform {
  required_providers {
    auth0 = {
      source  = "alexkappa/auth0"
      version = "~> 0.16.0"
    }
  }
}

resource "auth0_role" "role" {
  name        = var.name
  description = var.description

  dynamic "permissions" {
    for_each = var.permissions
    content {
      resource_server_identifier = permissions.value.resource_server_identifier
      name = permissions.value.name
    }
  }
}