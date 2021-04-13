variable "root_dns" {
  type        = string
  description = "Root dns name"
}

variable "lb_ip" {
  type        = string
  description = "Load balancer ip address"
}

variable "drone_proto" {
  description = "Protocol for drone to use (http/https)"
  type        = string
}

variable "drone_shared_secret" {
  description = "drone and drone runner shared secret"
  type        = string
}

variable "drone_vault_shared_secret" {
  description = "Shared secret between drone vault plugin and drone runner"
  type        = string
}

variable "github_client_id" {
  description = "github oauth client id"
  type        = string
}

variable "github_client_secret" {
  description = "github oauth client id"
  type        = string
}

variable "drone_user_filter" {
  description = "github oauth client id"
  type        = string
}

variable "drone_user_create" {
  description = "Inital admin user to create"
  type        = string
}

variable "tls_secret_name" {
  description = "TLS secret name"
  type        = string
}

variable "cluster_issuer_name" {
  description = "Name of the kubernetes Cluster issuer resourcer"
  type        = string
}

# DRONE VAULT
variable "vault_approle_id" {
  type        = string
  description = "Approle name from vault"
}

variable "vault_approle_secret" {
  type        = string
  description = "Approle secret from vault"
}
