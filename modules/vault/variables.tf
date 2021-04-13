variable "root_dns" {
  type        = string
  description = "Root dns name"
}

variable "lb_ip" {
  type        = string
  description = "Load balancer ip address"
}

variable "kms_id" {
  type        = string
  description = "AWS KMS Id for vault server"
}

variable "tls_secret_name" {
  description = "TLS secret name"
  type        = string
}

variable "cluster_issuer_name" {
  description = "Name of the kubernetes Cluster issuer resourcer"
  type        = string
}

variable "crypto_key" {
  description = "Name of GCP KMS crypto key"
}

variable "key_ring" {
  description = "Name of GCP KMS key ring"
}

variable "kms_region" {
  description = "Region that KMS is in"
}

variable "gcp_project_id" {
  description = "Name of the gcp project ID to use with cloud KMS"
}

variable "kubernetes_secret_gcp_creds" {
  description = "Name of the kubernetes secret that contains gcp creds"
}
