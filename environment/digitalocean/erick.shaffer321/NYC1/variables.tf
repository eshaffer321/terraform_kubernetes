variable "drone_user_filter" {
  description = "Users that are allowed access system"
  default     = "badass-budget-project"
}

variable "drone_user_create" {
  description = "Inital admin user to create (github user)"
  default     = "username:eshaffer321\\,admin:true"
}

variable "drone_proto" {
  description = "Protocol for drone to use"
  default     = "https"
}

variable "cluster_issuer_name" {
  description = "Name of the kubernetes cluster issuer name"
  default = "letsencrypt-staging"
}

variable "tls_secret_name" {
  description = "Kubernetes TLS secret name"
  default = "letsencrypt-staging-key"
}

variable "cert_email_address" {
  description = "Email to recieve emails about TLS certs"
  default = "erick.shaffer321@gmail.com"
}

variable "gcp_project_id" {
  description = "Project ID of GCP project"
  default = "budget-project-244300"
}

variable "gcp_region" {
  description = "GCP region"
  default = "us-central1"
}

variable "key_ring_name" {
  description = "Name of GCP key ring"
  default = "test"
}

variable "crypto_key_name" {
  description = "Name of a crypto key in GCP"
  default = "vault-test"
}

variable "key_location" {
  description = "Location of crypto key"
  default = "global"
}

variable "vault_kubernetes_secret_gcp_creds_name" {
  description = "Name of the kubernetes secret that contains GCP credentials for vault KMS"
  default = "vault-gcp-creds"
}
