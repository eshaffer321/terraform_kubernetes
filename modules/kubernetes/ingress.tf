resource "digitalocean_loadbalancer" "public" {
  name                   = "main-cluster-load-balancer"
  region                 = var.region
  size                   = var.load_balancer_size
  redirect_http_to_https = true

  forwarding_rule {
    entry_port     = 443
    entry_protocol = "https"

    target_port     = 30081
    target_protocol = "https"

    certificate_name = digitalocean_certificate.cert.name
  }

  healthcheck {
    port     = 22
    protocol = "tcp"
  }

  droplet_ids = digitalocean_kubernetes_cluster.main_cluster.node_pool[0].nodes.*.droplet_id
}

resource "digitalocean_firewall" "k8s" {
  name = "only-22-and-443-from-lb-to-cluster"

  droplet_ids = digitalocean_kubernetes_cluster.main_cluster.node_pool[0].nodes.*.droplet_id

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = [digitalocean_loadbalancer.public.ip]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = [digitalocean_loadbalancer.public.ip]
  }
}
