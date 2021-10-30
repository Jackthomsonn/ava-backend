resource "google_pubsub_topic" "generic_topic" {
  name = "${terraform.workspace}-${var.topic_name}"
}

resource "google_pubsub_subscription" "generic_subscription" {
  name  = "${google_pubsub_topic.generic_topic.name}-subscription"
  topic = google_pubsub_topic.generic_topic.name

  ack_deadline_seconds = 20

  push_config {
    push_endpoint = var.endpoint
  }
}
