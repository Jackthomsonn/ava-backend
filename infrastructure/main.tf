terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google-beta" {
  credentials = file("service-account.json")

  project = var.project
  region  = var.region
  zone    = var.zone
}

module "project-services" {
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

module "iot-core" {
  source = "./modules/cloudiot"

  registry_name       = terraform.workspace
  project             = var.project
  event_push_endpoint = "https://example.${terraform.workspace}.com/event"
  state_push_endpoint = "https://example.${terraform.workspace}.com/state"
}

module "cloud-run" {
  source = "./modules/cloudrun"

  name    = "api"
  project = var.project
}
