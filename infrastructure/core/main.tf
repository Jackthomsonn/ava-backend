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
    "${var.project}=>roles/cloudkms.cryptoKeyDecrypter",
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

module "kms" {
  source  = "terraform-google-modules/kms/google"
  version = "~> 1.2"
  project_id         = var.project
  location           = var.region
  keyring            = "ava-main-keyring"
  keys               = ["ava-main"]
}