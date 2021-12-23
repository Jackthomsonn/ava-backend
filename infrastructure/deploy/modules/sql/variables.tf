variable "project" {
  type        = string
  description = "The name of the project"
}

variable "region" {
  type        = string
  description = "The region to deploy to"
}

variable "database_name" {
  type        = string
  description = "The name of the database to create"
}

variable "database_version" {
  type        = string
  description = "The version of the database to create"
  default = "POSTGRES_11"
}

variable "db_user" {
  type        = string
  description = "The username for the database"
}

variable "db_password" {
  type        = string
  description = "The password for the database"
}

variable "allowed_ips" {
  type        = list(string)
  description = "The IP addresses allowed to connect to the database"
}