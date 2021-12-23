resource "google_sql_database_instance" "database" {
  name             = "${var.database_name}-${terraform.workspace}"
  database_version = var.database_version
  region           = var.region
  project          = var.project

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled = true

      dynamic "authorized_networks" {
        for_each = var.allowed_ips
        iterator = onprem

        content {
          name  = "onprem-${onprem.key}"
          value = onprem.value
        }
      }
    }
  }
}

resource "google_sql_database" "database" {
  name     = var.database_name
  instance = google_sql_database_instance.database.name
  project = var.project
}

resource "google_sql_user" "main_users" {
  name     = var.db_user
  instance = google_sql_database_instance.database.name
  password = var.db_password
  project = var.project
}

resource "google_sql_database_instance" "shadow_database" {
  name             = "shadow-${var.database_name}-${terraform.workspace}"
  database_version = var.database_version
  region           = var.region
  project          = var.project

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled = true

      dynamic "authorized_networks" {
        for_each = var.allowed_ips
        iterator = onprem

        content {
          name  = "onprem-${onprem.key}"
          value = onprem.value
        }
      }
    }
  }
}

resource "google_sql_database" "shadow_database" {
  name     = var.database_name
  instance = google_sql_database_instance.shadow_database.name
  project = var.project
}

resource "google_sql_user" "shadow_main_users" {
  name     = var.db_user
  instance = google_sql_database_instance.shadow_database.name
  password = var.db_password
  project = var.project
}