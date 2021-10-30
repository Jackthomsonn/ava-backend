variable "registry_name" {
  type        = string
  description = "The name of the registry to create"
}

variable "project" {
  type        = string
  description = "The name of the project"
}

variable "event_push_endpoint" {
  type        = string
  description = "The endpoint an event should be pushed to"
}

variable "state_push_endpoint" {
  type        = string
  description = "The endpoint an state should be pushed to"
}
