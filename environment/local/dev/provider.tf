terraform {
  required_providers {
    kind = {
      source  = "unicell/kind"
      version = "0.0.2-u2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "1.13.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.0.1"
    }
  }
}

# Configure the Kind Provider
provider "kind" {}

provider "kubernetes" {
  # Configuration options
}

provider "helm" {
  kubernetes {
    config_path = kind_cluster.default.kubernetesubeconfig_path
  }
}
