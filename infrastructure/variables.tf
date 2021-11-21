variable "project" {
  default = "ava-ai-322720"
}

variable "region" {
  default = "us-central1"
  description = "Region to deploy to"
}

variable "zone" {
  default = "us-central1-c"
  description = "Zone to deploy to"
}

variable "auth0_domain" {
  type = string
  description = "Auth0 domain"
}

variable "auth0_client_id" {
  type = string
  description = "Auth0 client id"
}

variable "auth0_client_secret" {
  type = string
  description = "Auth0 client secret"
}