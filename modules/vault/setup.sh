#!/bin/sh

# Initalize
vault operator init -recovery-shares=1 -recovery-threshold=1

# Copy files from polices/* to the vault container

# Secrets Engines
vault secrets enable -path=secret/ kv

# Policies
vault policy write admin admin-policy.hcl
vault policy write drone drone.hcl

# Create a drone token
vault token create -format=json -policy="drone"

# Auth methods
vault auth enable approle

echo "[INFO] Creating drone approle"
vault write auth/approle/role/drone \
	secret_id_ttl=0m \
	token_num_uses=100000000 \
	token_ttl=0m \
	token_max_ttl=0m \
	token_policies="drone" \
	secret_id_num_uses=100000000

vault kv put secret/docker \
	username=drone \
	password=$DRONE_PASSWORD \
	x-drone-repos=badass-budget-project/*

# Create the drone creds
vault read auth/approle/role/drone/role-id
vault write -f auth/approle/role/drone/secret-id
