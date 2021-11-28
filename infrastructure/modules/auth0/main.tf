# API's (resource servers)
module "ava_api" {
  source = "../auth0-resource"

  name   = "Ava API"
  identifier = "https://api-route.com"
  skip_consent_for_verifiable_first_party_clients = true
  scopes = [{
    name = "send:command"
    description = "Send commands to Ava"
  },
  {
    name = "get:command"
    description = "Get commands for Ava"
  }]
}

# Applications
module "ava_spa" {
  source = "../auth0-client"

  name   = "Ava Spa"
  description = "The SPA for Ava"
  app_type = "spa"
  callbacks = ["http://localhost:3000/callback"]
  token_endpoint_auth_method = "client_secret_post"
}

module "ava_api_explorer" {
  source = "../auth0-client"
  
  name = "Ava API Explorer"
  description = "The API Explorer for Ava"
  app_type = "non_interactive"
  token_endpoint_auth_method = "client_secret_post"

  client_grants = [{
      client_id = module.ava_api_explorer.id
      audience  = module.ava_api.identifier
      scope = ["send:command", "get:command"]
  }]
}

# Connections (database)
module "main_auth0_connection" {
  source = "../auth0-connection"

  name   = "main-connection"
  strategy = "auth0"
  enabled_clients = [module.ava_spa.id]
}

#Roles
module "admin_role" {
  source = "../auth0-role"

  name   = "admin"
  description = "The administrator role"
  permissions = [{
    name = "send:command"
    resource_server_identifier = module.ava_api.identifier
  },
  {
    name = "get:command"
    resource_server_identifier = module.ava_api.identifier
  }]
}