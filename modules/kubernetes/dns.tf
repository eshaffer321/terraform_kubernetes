resource "digitalocean_domain" "default" {
  name = var.root_dns_name
}

resource "digitalocean_certificate" "cert" {
  name              = "cluster-cert"
  type              = "custom"
  private_key       = var.private_key
  leaf_certificate  = var.leaf_cert
  certificate_chain = var.full_keychain_pem
  depends_on        = [digitalocean_domain.default]
  lifecycle {
    create_before_destroy = true
  }
}

