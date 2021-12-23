variable "project" {
  type = string
  default = "ava-ai-322720"
}

variable "region" {
  type = string
  default = "us-central1"
  description = "Region to deploy to"
}

variable "zone" {
  type = string
  default = "us-central1-c"
  description = "Zone to deploy to"
}
