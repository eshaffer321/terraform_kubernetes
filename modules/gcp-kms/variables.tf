variable "gcp_project_id" {
  type        = string
  description = "Project ID of the GCP project"
}

variable "gcp_region" {
  type        = string
  description = "GCP region to provision resources"
}

variable "keyring_location" {
  description = "Localtion of the keyring"
  type        = string
}

variable "key_ring_name" {
  description = "Name of a GCP key ring"
  type        = string
}

variable "crypto_key_name" {
  type        = string
  description = "Name of a crypto key for GCP"
}

variable "vault_service_account" {
  type        = string
  description = "Name of the service account for vault"
}
