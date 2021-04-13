module "kubernetes_cluster" {
  source                    = "../../../modules/kubernetes"
  do_token                  = ""
  region                    = ""
  droplet_slug              = ""
  default_node_pool_size    = 1
  load_balancer_size        = ""
  kube_config_file_location = ""
  root_dns_name             = ""
}

module "drone" {
  source               = "../../../modules/drone"
  root_dns             = ""
  lb_ip                = ""
  drone_proto          = ""
  drone_shared_secret  = ""
  github_client_id     = ""
  github_client_secret = ""
  drone_user_filter    = ""
  drone_user_create    = ""
}

module "nexus" {
  source   = "../../../modules/nexus"
  root_dns = ""
  lb_ip    = ""
}
