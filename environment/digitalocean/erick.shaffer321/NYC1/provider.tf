terraform {
  required_version = ">= 0.14.3"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "1.13.3"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.3.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.0.1"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.9.4"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.0.0"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "./kube_config.yaml"
  }
}

provider "digitalocean" {
  token = var.do_token
}

provider "kubernetes" {
  config_path = "./kube_config.yaml"
}
