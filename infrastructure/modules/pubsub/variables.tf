variable "endpoint" {
  type        = string
  description = "The endpoint to hit when a publish action has been triggered"
}

variable "topic_name" {
  type        = string
  description = "The name of topic to create"
}

variable "project" {
  type        = string
  description = "The name of the project to create the pub/sub in"
}
