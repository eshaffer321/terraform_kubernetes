resource "helm_release" "nginx_ingress" {
  chart      = "nginx-ingress"
  name       = "nginx-ingress-controller"
  repository = "https://helm.nginx.com/stable"
  version    = "0.7.1"

  values     = [file("${path.module}/values.yaml")]
}