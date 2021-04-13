[![Build Status](https://drone.commandyourmoney.co/api/badges/badass-budget-project/terraform-kubernetes/status.svg)](https://drone.commandyourmoney.co/badass-budget-project/terraform-kubernetes)
# terraform-kubernetes
This is a [terraform'd](https://www.terraform.io/) kubernetes cluster with boostraping of the following components

* Digital Ocean DNS record
* Digital Ocean host A Records
* Digital Ocean Cloud LoadBalacner
* Digital Ocean SSL Cert
* NGINX ingress controller deployed via helm

# Requirements

DO_TOKEN (digital ocean access token) is in your environment


## Modules

The following modules are available in the modules directory to be installed into the cluster

* Argocd
* Cert-manager
* Drone and Drone Kubernetes Runner
* Nexus Repository Manager
* Vault
* Prometheus

## Deploying changes
Change directory to project
`cd environment/digitalocean/erick.shaffer321`

Initialze terraform
`terraform init`

Plan the changes and review the output
`terraform plan -out=tfplan`

Apply the changes
`terraform apply tfplan`

