variable "tls_secret_name" {
  description = "TLS secret name"
  type = string
}

variable "cert_email_address" {
  description = "Email associated with SSL certs"
  type = string
}

variable "cluster_issuer_name" {
  description = "Name of the kubernetes Cluster issuer resourcer"
  type = string
}
