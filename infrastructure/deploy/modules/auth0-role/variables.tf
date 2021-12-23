variable "name" {
  type = string
  description = "The name of the role"
}

variable "description" {
  type      = string
  description = "The description of the role"  
}

variable "permissions" {
  type = list(object({
    resource_server_identifier = string
    name = string
  }))
}