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

resource "google_project_service" "iot" {
  project = var.project
  service = "cloudiot.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}

resource "google_project_service" "cloud_run" {
  project = var.project
  service = "run.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}

module "iot-core" {
  source              = "./modules/cloudiot"
  registry_name       = terraform.workspace
  project             = var.project
  event_push_endpoint = "https://example.${terraform.workspace}.com/event"
  state_push_endpoint = "https://example.${terraform.workspace}.com/state"
}

module "cloud_run" {
  source  = "./modules/cloudrun"
  name    = "${terraform.workspace}-api"
  image   = "gcr.io/${var.project}/${terraform.workspace}-api"
  project = var.project
}
