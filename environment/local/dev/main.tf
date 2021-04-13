resource "kind_cluster" "default" {
  name        = "dev-cluster"
  node_image  = "kindest/node:v1.19.3"
  kind_config = <<KIONF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
KIONF

}

# local test deployment
# resource "helm_release" "example" {
#   name       = "my-local-chart"
#   chart      = "./charts/example"
#   values = [
#     "${file("/path/to/a/values.yaml")}"
#   ]
# }
