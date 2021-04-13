resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "kubernetes_ingress" "nginx_ingress_routing_monitoring" {
  metadata {
    name = "nginx-ingress-routing-monitoring"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "certmanager.k8s.io/cluster-issuer": var.cluster_issuer_name
    }
    namespace = "monitoring"
  }

  spec {
    backend {
      service_name = "monitoring-grafana"
      service_port = 80
    }

    rule {
      host = format("%s.%s", "grafana", var.root_dns)
      http {
        path {
          backend {
            service_name = "monitoring-grafana"
            service_port = 80
          }
        }
      }
    }

    tls {
      secret_name = var.tls_secret_name
      hosts = [format("%s.%s", "grafana", var.root_dns)]
    }
  }
}

resource "digitalocean_record" "a_record" {
  domain = var.root_dns
  type   = "A"
  name   = "grafana"
  value  = var.lb_ip
}

# The kube stack bootstraps grafana, prometheus, and the alert app.
resource "helm_release" "monitoring" {
  name       = "monitoring"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "12.10.4"
  namespace  = "monitoring"
  depends_on = [kubernetes_namespace.monitoring]
  values = [
    file("${path.module}/values.yaml"),
    <<EOT
grafana: 
  grafana.ini: 
    auth.github: 
      allow_sign_up: true
      allowed_organizations: badass-budget-project
      api_url: "https://api.github.com/user"
      auth_url: "https://github.com/login/oauth/authorize"
      client_id: "${var.grafana_github_client_id}"
      client_secret: "${var.grafana_github_secret}"
      enabled: true
      scopes: "user:email,read:org"
      team_ids: ~
      token_url: "https://github.com/login/oauth/access_token"
    server: 
      root_url: "https://${format("%s.%s", "grafana", var.root_dns)}"
  EOT
  ]
}
