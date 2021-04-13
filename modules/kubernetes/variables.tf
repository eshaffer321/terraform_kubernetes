variable "default_node_pool_size" {
  description = "Amount of nodes to have in the default node pool"
  type        = number
}

# https://www.digitalocean.com/docs/platform/availability-matrix/
variable "region" {
  description = "Which datacenter to run in"
  type        = string
}

# https://slugs.do-api.dev/
variable "droplet_slug" {
  type = string
}

# https://developers.digitalocean.com/documentation/v2/
# Look for size under Load Balancers
variable "load_balancer_size" {
  type = string
}

variable "root_dns_name" {
  type = string
}

variable "do_token" {
  type        = string
  description = "Digital ocean access token"
}

variable "private_key" {
  description = "Certificate private key"
  type        = string
}

variable "full_keychain_pem" {
  description = "Full keychain pem"
  type        = string
}

variable "leaf_cert" {
  description = "leaf_cert"
  type        = string
}

variable "root_dns" {
  description = "root dns name for sites"
  type        = string
}

variable "kubernetes_version" {
  type        = string
  description = "Digital ocean slug of kubernetes version"
}
