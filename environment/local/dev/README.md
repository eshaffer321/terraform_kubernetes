# Local development kind cluster

This bootstraps a local kind cluster with an nginx-ingress controller.

https://kind.sigs.k8s.io/docs/user/ingress/


## Create kind cluster
After running
```
terraform plan -out=tfplan
terraform apply tfplann
```

## Install nginx ingress
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
```

## Wait for resources to be created
```
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s
```

## (Optional) Apply a hellow world app and service
```
kubectl apply -f https://kind.sigs.k8s.io/examples/ingress/usage.yaml
```

Vist the above link to see the example service

### Test it out by
```

curl localhost/foo
```
