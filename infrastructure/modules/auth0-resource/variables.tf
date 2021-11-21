variable "name" {
  type = string
  description =  "The name of the resource"
}

variable "identifier" {
  type = string
  description = "The identifier of the resource"
}

variable "skip_consent_for_verifiable_first_party_clients" {
  type = bool
  description = "Whether to skip consent for verifiable first party clients"
}

variable "scopes" {
  type = list(object({
    name = string
    description = string
  }))
}