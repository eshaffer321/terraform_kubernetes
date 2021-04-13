resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_ingress" "nginx_ingress_routing_argocd" {
  metadata {
    name = "nginx-ingress-routing"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "certmanager.k8s.io/cluster-issuer": var.cluster_issuer_name
      "nginx.org/redirect-to-https" = true
    }
    namespace = "argocd"
  }

  spec {
    backend {
      service_name = "argocd-server"
      service_port = 80
    }

    rule {
      host = format("%s.%s", "argocd", var.root_dns)
      http {
        path {
          backend {
            service_name = "argocd-server"
            service_port = 80
          }
        }
      }
    }

    tls {
      secret_name = var.tls_secret_name
      hosts = [format("%s.%s", "argocd", var.root_dns)]
    }
  }
}

resource "digitalocean_record" "a_record" {
  domain = var.root_dns
  type   = "A"
  name   = "argocd"
  value  = var.lb_ip
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "2.11.0"
  namespace  = "argocd"
  depends_on = [kubernetes_namespace.argocd]
  values = [
    <<EOT
server:
  extraArgs:
  - --insecure
  config: 
    url: https://${format("%s.%s", "argocd", var.root_dns)}
    dex.config: |
      connectors:
        # GitHub example
        - type: github
          id: github
          name: GitHub
          config:
            clientID: ${var.argocd_github_client_id}
            clientSecret: ${var.argocd_github_secret}
            orgs:
            - name: badass-budget-project
  metrics:
    enabled: false
    service:
      annotations: {}
      labels: {}
      servicePort: 8083
    serviceMonitor:
      enabled: false
      selector:
        prometheus: kube-prometheus
      namespace: monitoring
      additionalLabels: {}

  EOT
  ]
}
