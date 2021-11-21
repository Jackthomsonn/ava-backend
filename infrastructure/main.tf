terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
    auth0 = {
      source  = "alexkappa/auth0"
      version = "~> 0.16.0"
    }
  }
}

provider "google-beta" {
  credentials = file("service-account.json")

  project = var.project
  region  = var.region
  zone    = var.zone
}

provider "auth0" {
  domain        = var.auth0_domain
  client_id     = var.auth0_client_id
  client_secret = var.auth0_client_secret
}

# Create the SPA application for AVA
module "ava_spa" {
  source = "./modules/auth0-client"

  name   = "Ava Spa"
  is_first_party = true
  description = "The SPA for Ava"
  app_type = "spa"
  callbacks = ["http://localhost:3000/callback"]
}

# Create connections here
module "main_auth0_connection" {
  source = "./modules/auth0-connection"

  name   = "main-connection"
  strategy = "auth0"
  enabled_clients = [module.ava_spa.id, var.auth0_client_id]
}

# Create the different resources for AVA here. Currently only ther AVA api exists
module "ava_api" {
  source = "./modules/auth0-resource"

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

# Create roles here
module "admin_role" {
  source = "./modules/auth0-role"

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

module "project_services" {
  source     = "terraform-google-modules/project-factory/google//modules/project_services"
  version    = "3.3.0"
  project_id = var.project

  activate_apis = [
    "cloudiot.googleapis.com",
    "run.googleapis.com",
  ]

  disable_services_on_destroy = true
  disable_dependent_services  = true
}

module "ci_cd_service_account" {
  source        = "terraform-google-modules/service-accounts/google"
  display_name  = "CI/CD Service Account"
  version       = "~> 3.0"
  project_id    = var.project
  generate_keys = true
  description   = "Service account for CI/CD client"
  names         = ["continuousintegration"]
  project_roles = [
    "${var.project}=>roles/run.admin",
    "${var.project}=>roles/storage.objectViewer",
    "${var.project}=>roles/storage.admin",
    "${var.project}=>roles/iam.serviceAccountUser",
  ]
}

module "elixir_app_service_account" {
  source        = "terraform-google-modules/service-accounts/google"
  display_name  = "Elixir Service Account"
  version       = "~> 3.0"
  project_id    = var.project
  generate_keys = true
  description   = "Service account for the Elixir App client"
  names         = ["elixirapp"]
  project_roles = [
    "${var.project}=>roles/editor"
  ]
}

module "iot_core" {
  source = "./modules/cloudiot"

  registry_name       = terraform.workspace
  project             = var.project
  region              = var.region
  event_push_endpoint = "https://example.${terraform.workspace}.com/event"
  state_push_endpoint = "https://example.${terraform.workspace}.com/state"
}

module "cloud_run" {
  source = "./modules/cloudrun"

  name    = "api"
  project = var.project
}
