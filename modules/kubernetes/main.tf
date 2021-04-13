resource "digitalocean_kubernetes_cluster" "main_cluster" {
  name   = "main"
  region = var.region
  # Grab the latest version slug from `doctl kubernetes options versions`
  version      = var.kubernetes_version
  auto_upgrade = true

  node_pool {
    name       = "worker-pool"
    size       = var.droplet_slug
    node_count = var.default_node_pool_size
  }
}

# Bring kube config to local file system to be used with helm provider
resource "local_file" "kube_config" {
  content         = digitalocean_kubernetes_cluster.main_cluster.kube_config.0.raw_config
  filename        = "./kube_config.yaml"
  file_permission = "600"
}
