variable "root_dns" {
  type        = string
  description = "Root dns name"
}

variable "lb_ip" {
  type        = string
  description = "Load balancer ip address"
}

variable "tls_secret_name" {
  description = "TLS secret name"
  type        = string
}

variable "cluster_issuer_name" {
  description = "Name of the kubernetes Cluster issuer resourcer"
  type        = string
}

variable "nexus_admin_intial_password" {
  description = "Intial admin password for nexus"
  type        = string
}

variable "nexus_password_drone" {
  description = "Intial nexus password for drone"
  type        = string
}
