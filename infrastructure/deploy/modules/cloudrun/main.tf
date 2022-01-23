module "cloud_run_service_account" {
  source       = "terraform-google-modules/service-accounts/google"
  display_name = "${var.name} cloud run service account"
  version      = "~> 3.0"
  project_id   = var.project
  description  = "Service account for ${var.name} Cloud Run instance"
  names        = ["${var.name}cloudrun-${terraform.workspace}"]
  project_roles = [
    "${var.project}=>roles/run.admin",
    "${var.project}=>roles/cloudsql.client"
  ]
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers"
    ]
  }
}

resource "google_cloud_run_service" "default" {
  project  = var.project
  name     = "${terraform.workspace}-${var.name}"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "gcr.io/${var.project}/${terraform.workspace}-${var.name}"
      }
      service_account_name = module.cloud_run_service_account.email
    }

    metadata {
      annotations = {
        "run.googleapis.com/cloudsql-instances" = var.sql_instance
        "autoscaling.knative.dev/maxScale" = 100
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  autogenerate_revision_name = true
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.default.location
  project  = google_cloud_run_service.default.project
  service  = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}
