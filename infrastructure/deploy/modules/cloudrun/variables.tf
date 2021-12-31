variable "name" {
  type        = string
  description = "The name of the cloud run service"
}

variable "project" {
  type        = string
  description = "The project to deploy to"
}

variable "sql_instance" {
  type        = string
  description = "The SQL instance for this cloud run service"
}