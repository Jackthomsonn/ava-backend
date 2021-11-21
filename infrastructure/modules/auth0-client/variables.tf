variable "name" {
  type = string
  description = "The name of the app"
}

variable "is_first_party" {
  type = bool
  description = "Determines if this app is a first party client"
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
}