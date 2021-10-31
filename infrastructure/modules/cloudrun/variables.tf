variable "name" {
  type        = string
  description = "The name of the cloud run service"
}

variable "image" {
  type        = string
  description = "The image to deploy"
}

variable "project" {
  type        = string
  description = "The project to deploy to"
}
