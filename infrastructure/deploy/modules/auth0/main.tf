# API's (resource servers)
module "ava_api" {
  source = "../auth0-resource"

  name   = "Ava API"
  identifier = "https://api-route.com"
  skip_consent_for_verifiable_first_party_clients = true
  scopes = [{
    name = "get:devices"
    description = "Get all devices"
  }]
}

# Applications
module "ava_app" {
  source = "../auth0-client"

  name   = "Ava App"
  description = "The web app for Ava"
  app_type = "regular_web"
  callbacks = ["http://localhost:3000/api/auth/callback", "https://ava-app.vercel.app/api/auth/callback"]
  allowed_logout_urls = ["http://localhost:3000", "https://ava-app.vercel.app"]
  token_endpoint_auth_method = "client_secret_post"
}

# Connections (database)
module "main_auth0_connection" {
  source = "../auth0-connection"

  name   = "main-connection"
  strategy = "auth0"
  enabled_clients = [module.ava_app.id]
}

#Roles
module "admin_role" {
  source = "../auth0-role"

  name   = "admin"
  description = "The administrator role"
  permissions = [{
    name = "get:devices"
    resource_server_identifier = module.ava_api.identifier
  }]
}