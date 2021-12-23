resource "google_pubsub_topic" "event_topic" {
  name    = "${terraform.workspace}-event"
  project = var.project
}

resource "google_pubsub_topic" "state_topic" {
  name    = "${terraform.workspace}-state"
  project = var.project
}

resource "google_cloudiot_registry" "ava_registry" {
  name    = var.registry_name
  project = var.project
  region  = var.region

  event_notification_configs {
    pubsub_topic_name = google_pubsub_topic.event_topic.id
    subfolder_matches = "event"
  }

  state_notification_config = {
    pubsub_topic_name = google_pubsub_topic.state_topic.id
  }

  mqtt_config = {
    mqtt_enabled_state = "MQTT_ENABLED"
  }

  http_config = {
    http_enabled_state = "HTTP_DISABLED"
  }

  log_level = "INFO"
}

resource "google_pubsub_subscription" "ava_event_subscription" {
  name    = "${var.registry_name}-event-subscription"
  project = var.project
  topic   = google_pubsub_topic.event_topic.id

  ack_deadline_seconds = 20

  push_config {
    push_endpoint = var.event_push_endpoint
  }
}

resource "google_pubsub_subscription" "ava_state_subscription" {
  name    = "${var.registry_name}-state-subscription"
  project = var.project
  topic   = google_pubsub_topic.state_topic.id

  ack_deadline_seconds = 20

  push_config {
    push_endpoint = var.state_push_endpoint
  }
}
