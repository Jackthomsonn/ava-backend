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
    sops = {
      source = "carlpett/sops"
      version = "~> 0.5"
    }
  }
}

provider "google-beta" {
  credentials = file("service-account.json")

  project = var.project
  region  = var.region
  zone    = var.zone
}

data "sops_file" "secrets" {
  source_file = "../../secrets/${terraform.workspace}.yaml"
}

provider "auth0" {
  domain        = data.sops_file.secrets.data["auth0_domain"]
  client_id     = data.sops_file.secrets.data["auth0_client_id"]
  client_secret = data.sops_file.secrets.data["auth0_client_secret"]
}

module "auth0" {
  source = "./modules/auth0"
}

module "project_services" {
  source     = "terraform-google-modules/project-factory/google//modules/project_services"
  version    = "3.3.0"
  project_id = var.project

  activate_apis = [
    "cloudiot.googleapis.com",
    "run.googleapis.com",
    "cloudkms.googleapis.com",
    "servicenetworking.googleapis.com"
  ]

  disable_services_on_destroy = true
  disable_dependent_services  = true
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

module "sql" {
  source = "./modules/sql"

  project = var.project
  region = var.region
  database_name = "ava"
  database_version = "POSTGRES_11"
  db_user = data.sops_file.secrets.data["POSTGRES_USER"]
  db_password = data.sops_file.secrets.data["POSTGRES_PASSWORD"]
  allowed_ips = [data.sops_file.secrets.data["onprem_host"]]
}