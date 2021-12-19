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
  source_file = "../secrets/${terraform.workspace}.yaml"
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

module "kms" {
  source  = "terraform-google-modules/kms/google"
  version = "~> 1.2"

  project_id         = var.project
  location           = var.region
  keyring            = "ava-keyring"
  keys               = ["ava-main"]
}

locals {
  onprem = [data.sops_file.secrets.data["onprem_host"]]
}

// Setup SQL Instances
resource "google_sql_database_instance" "ava_main" {
  name             = "ava-main-${terraform.workspace}"
  database_version = "POSTGRES_11"
  region           = var.region
  project = var.project

  settings {
    tier = "db-f1-micro"

    ip_configuration {

      dynamic "authorized_networks" {
        for_each = local.onprem
        iterator = onprem

        content {
          name  = "onprem-${onprem.key}"
          value = onprem.value
        }
      }
    }
  }
}

resource "google_sql_database_instance" "ava_shadow" {
  name             = "ava-shadow-${terraform.workspace}"
  database_version = "POSTGRES_11"
  region           = var.region
  project = var.project

  settings {
    tier = "db-f1-micro"

    ip_configuration {

      dynamic "authorized_networks" {
        for_each = local.onprem
        iterator = onprem

        content {
          name  = "onprem-${onprem.key}"
          value = onprem.value
        }
      }
    }
  }
}

// Setup SQL Database
resource "google_sql_database" "main_database" {
  name     = "ava"
  instance = google_sql_database_instance.ava_main.name
  project = var.project
}

resource "google_sql_database" "shadow_database" {
  name     = "ava"
  instance = google_sql_database_instance.ava_shadow.name
  project = var.project
}

// Setup SQL users
resource "google_sql_user" "main_users" {
  name     = data.sops_file.secrets.data["POSTGRESQL_USER"]
  instance = google_sql_database_instance.ava_main.name
  password = data.sops_file.secrets.data["POSTGRESQL_PASSWORD"]
  project = var.project
}

resource "google_sql_user" "shadow_users" {
  name     = data.sops_file.secrets.data["POSTGRESQL_USER"]
  instance = google_sql_database_instance.ava_shadow.name
  password = data.sops_file.secrets.data["POSTGRESQL_PASSWORD"]
  project = var.project
}