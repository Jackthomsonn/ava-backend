variable "name" {
  type = string
  description = "The name of the connection"
}

variable "strategy" {
  type = string
  description = "The strategy to be used for the connection"
  default = "auth0"
}

variable "enabled_clients" {
  type = list(string)
  description = "The enabled clients for the connection"
}