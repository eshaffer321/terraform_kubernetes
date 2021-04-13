terraform {
  required_version = ">= 0.14.3"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.3.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.0.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.0.0"
    }
  }
}
