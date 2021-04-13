# Leaving this disabled. Use this if you need to test drone credentails locally
# and need an API endpoint to use

# resource "kubernetes_ingress" "nginx_ingress_routing_drone_vault" {
#   metadata {
#     name = "nginx-ingress-routing-drone-vault"
#     annotations = {
#       "kubernetes.io/ingress.class"                    = "nginx"
#       "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
#       "certmanager.k8s.io/cluster-issuer" : var.cluster_issuer_name
#     }
#     namespace = kubernetes_namespace.drone.metadata[0].name
#   }

#   spec {
#     backend {
#       service_name = "drone-vault"
#       service_port = 3000
#     }

#     rule {
#       host = format("%s.%s", "drone-vault", var.root_dns)
#       http {
#         path {
#           backend {
#             service_name = "drone-vault"
#             service_port = 3000
#           }
#         }
#       }
#     }

#     tls {
#       secret_name = var.tls_secret_name
#       hosts       = [format("%s.%s", "drone-vault", var.root_dns)]
#     }
#   }
# }

# resource "digitalocean_record" "vault_drone_a_record" {
#   domain = var.root_dns
#   type   = "A"
#   name   = "drone-vault"
#   value  = var.lb_ip
# }

