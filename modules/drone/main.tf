locals {
  port = 3000
}
resource "kubernetes_namespace" "drone" {
  metadata {
    name = "drone"
  }
}

resource "kubernetes_ingress" "nginx_ingress_routing_drone" {
  metadata {
    name = "nginx-ingress-routing"
    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "certmanager.k8s.io/cluster-issuer" : var.cluster_issuer_name
    }
    namespace = kubernetes_namespace.drone.metadata[0].name
  }

  spec {
    backend {
      service_name = "drone"
      service_port = 80
    }

    rule {
      host = format("%s.%s", "drone", var.root_dns)
      http {
        path {
          backend {
            service_name = "drone"
            service_port = 80
          }
        }
      }
    }

    tls {
      secret_name = var.tls_secret_name
      hosts       = [format("%s.%s", "drone", var.root_dns)]
    }
  }
}




resource "digitalocean_record" "a_record" {
  domain = var.root_dns
  type   = "A"
  name   = "drone"
  value  = var.lb_ip
}

resource "helm_release" "drone" {
  name       = "drone"
  repository = "https://charts.drone.io"
  chart      = "drone"
  version    = "0.1.7"
  namespace  = "drone"

  values = [
    <<EOT
podAnnotations:
  prometheus.io/scrape: "true"
  prometheus.io/port: "80"
  EOT
  ]

  set {
    name  = "env.DRONE_SERVER_HOST"
    value = format("%s.%s", "drone", var.root_dns)
  }

  set {
    name  = "env.DRONE_SERVER_PROTO"
    value = var.drone_proto
  }

  set_sensitive {
    name  = "env.DRONE_RPC_SECRET"
    value = var.drone_shared_secret
  }

  set {
    name  = "env.DRONE_GITHUB_CLIENT_ID"
    value = var.github_client_id
  }

  set_sensitive {
    name  = "env.DRONE_GITHUB_CLIENT_SECRET"
    value = var.github_client_secret
  }

  set {
    name  = "env.DRONE_USER_FILTER"
    value = var.drone_user_filter
  }

  set {
    name  = "env.DRONE_USER_CREATE"
    value = var.drone_user_create
  }

  set {
    name  = "env.DRONE_REPOSITORY_FILTER"
    value = var.drone_user_filter
  }

  depends_on = [kubernetes_namespace.drone]

}

# https://github.com/drone/drone-vault
resource "helm_release" "drone_vault" {
  name      = "drone-vault"
  chart     = "${path.module}/drone-vault"
  namespace = "drone"

  set {
    name  = "env.PORT"
    value = local.port
  }

  set_sensitive {
    name  = "env.DRONE_SECRET"
    value = var.drone_vault_shared_secret
  }

  set {
    name  = "env.VAULT_ADDR"
    value = "http://vault.vault.svc.cluster.local:8200"
  }

  set {
    name  = "env.VAULT_AUTH_TYPE"
    value = "approle"
  }

  set {
    name  = "env.VAULT_TOKEN_TTL"
    value = "72h"
  }

  set {
    name  = "env.VAULT_TOKEN_RENEWAL"
    value = "24h"
  }

  set {
    name  = "env.VAULT_APPROLE_ID"
    value = var.vault_approle_id
  }

  set {
    name  = "env.VAULT_APPROLE_SECRET"
    value = var.vault_approle_secret
  }

  set {
    name  = "service.port"
    value = local.port
  }

}


# https://github.com/drone/charts/tree/master/charts/drone-runner-kube
resource "helm_release" "drone_runner" {
  name       = "drone-runner"
  repository = "https://charts.drone.io"
  chart      = "drone-runner-kube"
  version    = "0.1.5"
  namespace  = "drone"

  values = [file("${path.module}/drone-runner-values.yaml")]

  set_sensitive {
    name  = "env.DRONE_RPC_SECRET"
    value = var.drone_shared_secret
  }

  set {
    name  = "env.DRONE_NAMESPACE_DEFAULT"
    value = "drone"
  }

  set {
    name  = "env.DRONE_SECRET_PLUGIN_ENDPOINT"
    value = "http://drone-vault.drone.svc.cluster.local:3000"
  }

  set {
    name  = "env.DRONE_SECRET_PLUGIN_TOKEN"
    value = var.drone_vault_shared_secret
  }

}

