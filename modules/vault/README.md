# Inital setup
Initialze and store the root token somewhere safe (E.g password manager)
```
vault operator init \
    -recovery-shares=1 \
    -recovery-threshold=1
```
# GCP KMS Guide
https://github.com/hashicorp/vault-guides/tree/master/operations/gcp-kms-unseal

# Create a kubernetes secert
`kubectl create secret generic vault-gcp-creds --from-file=config.json --namespace=vault`

# Run the commands inside the vault container
```
setup.sh
```

