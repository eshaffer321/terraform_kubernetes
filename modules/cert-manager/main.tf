resource "kubernetes_namespace" "vault" {
  metadata {
    name = "cert-manager"
  }
}


resource "helm_release" "cert-manager" {
  name = "cert-manager"
  chart = "https://charts.jetstack.io/charts/cert-manager-v1.2.0-alpha.0.tgz"
  namespace = "cert-manager"
  values = [
    file("${path.module}/values.yaml")]

}


resource "kubectl_manifest" "let_encrypt_staging_issuer" {
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: ${var.cluster_issuer_name}
spec:
  acme:
    # Email address used for ACME registration
    email: erick.shaffer321@gmail.com
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      # Name of a secret used to store the ACME account private key
      name: ${var.tls_secret_name}
    # Add a single challenge solver, HTTP01 using nginx
    solvers:
      - http01:
          ingress:
            class: nginx
YAML
}

//resource "kubectl_manifest" "let_encrypt_production_issuer" {
//  yaml_body = <<YAML
//apiVersion: cert-manager.io/v1alpha2
//kind: ClusterIssuer
//metadata:
//  name: ${var.cluster_issuer_name}
//spec:
//  acme:
//    # Email address used for ACME registration
//    email: erick.shaffer321@gmail.com
//    server: https://acme-v02.api.letsencrypt.org/directory
//    privateKeySecretRef:
//      # Name of a secret used to store the ACME account private key
//      name: ${var.tls_secret_name}
//    # Add a single challenge solver, HTTP01 using nginx
//    solvers:
//      - http01:
//          ingress:
//            class: nginx
//YAML
//}