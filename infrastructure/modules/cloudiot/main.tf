resource "google_cloudiot_registry" "ava_registry" {
  name = var.registry_name

  event_notification_configs {
    pubsub_topic_name = "projects/${var.project}/topics/${var.registry_name}-event"
    subfolder_matches = "event"
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
  name  = "${var.registry_name}-event-subscription"
  topic = "${var.registry_name}-event"

  ack_deadline_seconds = 20

  push_config {
    push_endpoint = var.event_push_endpoint
  }
}

resource "google_pubsub_subscription" "ava_state_subscription" {
  name  = "${var.registry_name}-state-subscription"
  topic = "${var.registry_name}-state"

  ack_deadline_seconds = 20

  push_config {
    push_endpoint = var.state_push_endpoint
  }
}
