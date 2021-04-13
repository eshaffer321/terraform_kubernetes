output "main_cluster_ip_address" {
  value = digitalocean_kubernetes_cluster.main_cluster.ipv4_address
}

output "kube_config" {
  value = digitalocean_kubernetes_cluster.main_cluster.kube_config.0.raw_config
}

output "load_balancer_ip_address" {
  value = digitalocean_loadbalancer.public.ip
}
