locals {
  nexus_hostname  = format("%s.%s", "nexus", var.root_dns)
  docker_hostname = format("%s.%s", "docker", var.root_dns)
}

resource "kubernetes_namespace" "nexus" {
  metadata {
    name = "nexus"
  }
}

resource "kubernetes_ingress" "nginx_ingress_routing_nexus" {
  metadata {
    name = "nginx-ingress-routing"
    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "certmanager.k8s.io/cluster-issuer" : var.cluster_issuer_name
    }
    namespace = "nexus"
  }

  spec {
    backend {
      service_name = "nexus-sonatype-nexus"
      service_port = 8080
    }

    rule {
      host = local.nexus_hostname
      http {
        path {
          backend {
            service_name = "nexus-sonatype-nexus"
            service_port = 8080
          }
        }
      }
    }

    tls {
      secret_name = var.tls_secret_name
      hosts       = [local.nexus_hostname]
    }
  }
}

resource "kubernetes_ingress" "nginx_ingress_routing_docker" {
  metadata {
    name = "nginx-ingress-routing-docker"
    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "nginx.org/client-max-body-size"                 = "0"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "certmanager.k8s.io/cluster-issuer" : var.cluster_issuer_name
    }
    namespace = "nexus"
  }

  spec {
    backend {
      service_name = "nexus-sonatype-nexus"
      service_port = 8080
    }

    rule {
      host = local.docker_hostname
      http {
        path {
          backend {
            service_name = "nexus-sonatype-nexus"
            service_port = 8080
          }
        }
      }
    }
    tls {
      secret_name = var.tls_secret_name
      hosts       = [local.docker_hostname]
    }
  }
}

resource "digitalocean_record" "a_record" {
  domain = var.root_dns
  type   = "A"
  name   = "nexus"
  value  = var.lb_ip
}

resource "digitalocean_record" "docker_a_record" {
  domain = var.root_dns
  type   = "A"
  name   = "docker"
  value  = var.lb_ip
}

resource "helm_release" "nexus" {
  name       = "nexus"
  repository = "https://oteemo.github.io/charts"
  chart      = "sonatype-nexus"
  version    = "4.2.0"
  namespace  = "nexus"
  depends_on = [kubernetes_namespace.nexus]

  values = [
    file("${path.module}/nexus-values.yaml")
  ]

  set {
    name  = "nexusProxy.env.nexusHttpHost"
    value = local.nexus_hostname
  }

  set {
    name  = "nexusProxy.env.nexusDockerHost"
    value = local.docker_hostname
  }

  set {
    name  = "nexusProxy.env.enforceHttps"
    value = true
  }

  set {
    name  = "nexusProxy.dockerPort"
    value = 5003
  }

}
