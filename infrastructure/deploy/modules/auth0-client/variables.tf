variable "name" {
  type = string
  description = "The name of the app"
}

variable "is_first_party" {
  type = bool
  description = "Determines if this app is a first party client i.e is not used by third parties"
  default = true
}

variable "description" {
  type = string
  description = "The description of the app"
}

variable "app_type" {
  type = string
  description = "The type of app being setup"
}

variable "callbacks" {
  type = list(string)
  description = "The callback URLs for the app"
  default = []
}

variable "allowed_logout_urls" {
  type = list(string)
  description = "The allowed logout URLs for the app"
  default = []
}

variable "token_endpoint_auth_method" {
  type = string
  description = "The token endpoint authentication method"
  default = "none"
}

variable "client_grants" {
  type = list(object({
    client_id = string
    audience  = string
    scope = list(string)
  }))
  description = "The client grants to create"
  default = []
}