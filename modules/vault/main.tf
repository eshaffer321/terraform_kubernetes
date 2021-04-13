resource "kubernetes_namespace" "vault" {
  metadata {
    name = "vault"
  }
}

resource "kubernetes_ingress" "nginx_ingress_routing_vault" {
  metadata {
    name = "nginx-ingress-routing"
    annotations = {
      "certmanager.k8s.io/cluster-issuer": var.cluster_issuer_name
      "kubernetes.io/ingress.class"                    = "nginx"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
    }
    namespace = "vault"
  }

  spec {
    backend {
      service_name = "vault"
      service_port = 80
    }

    rule {
      host = format("%s.%s", "vault", var.root_dns)
      http {
        path {
          backend {
            service_name = "vault"
            service_port = 80
          }
        }
      }
    }

    tls {
      secret_name = var.tls_secret_name
      hosts = [format("%s.%s", "vault", var.root_dns)]
    }
  }
}

resource "digitalocean_record" "a_record" {
  domain = var.root_dns
  type   = "A"
  name   = "vault"
  value  = var.lb_ip
}

resource "helm_release" "vault" {
  name = "vault"
  chart = "https://helm.releases.hashicorp.com/vault-0.9.0.tgz"
  namespace = "vault"
  values = [
    <<EOT
server:
  extraVolumes:
     - type: secret
       name: ${var.kubernetes_secret_gcp_creds}

  standalone:
    enabled: "-"

    config: |
      ui = true

      listener "tcp" {
        tls_disable = 1
        address = "[::]:8200"
        cluster_address = "[::]:8201"
      }
      storage "file" {
        path = "/vault/data"
      }

      seal "gcpckms" {
         credentials = "/vault/userconfig/${var.kubernetes_secret_gcp_creds}/config.json"
         project     = "${var.gcp_project_id}"
         region      = "${var.kms_region}"
         key_ring    = "${var.key_ring}"
         crypto_key  = "${var.crypto_key}"
      }

  EOT
    ,
    file("${path.module}/vault-values.yaml")
  ]
}
