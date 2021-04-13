variable "root_dns" {
  type        = string
  description = "Root dns name"
}

variable "lb_ip" {
  type        = string
  description = "Load balancer ip address"
}

variable "argocd_github_client_id" {
  description = "Github oauth client id"
  type        = string
}

variable "argocd_github_secret" {
  description = "Github oauth client secret"
  type        = string
}

variable "tls_secret_name" {
  description = "TLS secret name"
  type = string
}

variable "cluster_issuer_name" {
  description = "Name of the kubernetes Cluster issuer resourcer"
  type = string
}
