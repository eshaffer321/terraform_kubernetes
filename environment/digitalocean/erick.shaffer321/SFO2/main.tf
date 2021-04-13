locals {
  root_dns_name = "commandyourmoney.co"
}

module "kubernetes_cluster" {
  source                 = "../../../../modules/kubernetes"
  do_token               = var.do_token
  region                 = var.digitalocean_region
  kubernetes_version     = var.kubernetes_version
  droplet_slug           = "s-2vcpu-4gb"
  default_node_pool_size = 1
  load_balancer_size     = "lb-small"
  root_dns               = local.root_dns_name

  root_dns_name     = local.root_dns_name
  private_key       = var.private_key
  full_keychain_pem = var.full_keychain_pem
  leaf_cert         = var.leaf_cert
}

module "drone" {
  source                    = "../../../../modules/drone"
  root_dns                  = local.root_dns_name
  lb_ip                     = module.kubernetes_cluster.load_balancer_ip_address
  drone_proto               = var.drone_proto
  drone_shared_secret       = var.drone_shared_secret
  drone_vault_shared_secret = var.drone_vault_shared_secret
  github_client_id          = var.drone_github_client_id
  github_client_secret      = var.drone_github_client_secret
  drone_user_filter         = var.drone_user_filter
  drone_user_create         = var.drone_user_create
  tls_secret_name           = var.tls_secret_name
  cluster_issuer_name       = var.cluster_issuer_name
  vault_approle_id          = var.vault_approle_id
  vault_approle_secret      = var.vault_approle_secret
  depends_on                = [module.kubernetes_cluster]
}

module "nexus" {
  source                      = "../../../../modules/nexus"
  root_dns                    = local.root_dns_name
  lb_ip                       = module.kubernetes_cluster.load_balancer_ip_address
  tls_secret_name             = var.tls_secret_name
  cluster_issuer_name         = var.cluster_issuer_name
  nexus_admin_intial_password = var.nexus_admin_intial_password
  nexus_password_drone        = var.drone_nexus_password
  depends_on                  = [module.kubernetes_cluster]
}

module "argocd" {
  source                  = "../../../../modules/argocd"
  root_dns                = local.root_dns_name
  lb_ip                   = module.kubernetes_cluster.load_balancer_ip_address
  argocd_github_client_id = var.argocd_client_id
  argocd_github_secret    = var.argocd_client_secret
  tls_secret_name         = var.tls_secret_name
  cluster_issuer_name     = var.cluster_issuer_name
  depends_on              = [module.kubernetes_cluster]
}

module "monitoring" {
  source                   = "../../../../modules/monitoring"
  root_dns                 = local.root_dns_name
  lb_ip                    = module.kubernetes_cluster.load_balancer_ip_address
  grafana_github_client_id = var.grafana_client_id
  grafana_github_secret    = var.grafana_client_secret
  tls_secret_name          = var.tls_secret_name
  cluster_issuer_name      = var.cluster_issuer_name
  depends_on               = [module.kubernetes_cluster]
}

module "gcp_cloud_kms" {
  source                = "../../../../modules/gcp-kms"
  gcp_project_id        = var.gcp_project_id
  gcp_region            = var.gcp_region
  key_ring_name         = var.key_ring_name
  crypto_key_name       = var.crypto_key_name
  keyring_location      = var.key_location
  vault_service_account = var.vault_service_account
}

module "vault" {
  source                      = "../../../../modules/vault"
  root_dns                    = local.root_dns_name
  lb_ip                       = module.kubernetes_cluster.load_balancer_ip_address
  kms_id                      = var.kms_id
  tls_secret_name             = var.tls_secret_name
  cluster_issuer_name         = var.cluster_issuer_name
  crypto_key                  = module.gcp_cloud_kms.crypto_key_name
  key_ring                    = module.gcp_cloud_kms.key_ring_name
  kms_region                  = module.gcp_cloud_kms.kms_region
  gcp_project_id              = var.gcp_project_id
  kubernetes_secret_gcp_creds = var.vault_kubernetes_secret_gcp_creds_name
  depends_on                  = [module.kubernetes_cluster]
}

module "postgres" {
  source              = "../../../../modules/postgres"
  root_dns            = local.root_dns_name
  postgres_database   = var.postgres_database
  postgres_password   = var.postgres_password
  cluster_issuer_name = var.cluster_issuer_name
  tls_secret_name     = var.tls_secret_name
  depends_on          = [module.kubernetes_cluster]
}

module "nginx" {
  source     = "../../../../modules/nginx"
  depends_on = [module.kubernetes_cluster]
}

module "cert_manager" {
  source              = "../../../../modules/cert-manager"
  cert_email_address  = var.cert_email_address
  tls_secret_name     = var.tls_secret_name
  cluster_issuer_name = var.cluster_issuer_name
  depends_on          = [module.kubernetes_cluster]
}
