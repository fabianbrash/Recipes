```Sealed secrets info```


[https://github.com/bitnami-labs/sealed-secrets](https://github.com/bitnami-labs/sealed-secrets)

[https://github.com/bitnami-labs/sealed-secrets/releases](https://github.com/bitnami-labs/sealed-secrets/releases)


```Installation```


````

helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets
helm repo update

helm install sealed-secrets -n kube-system --set-string fullnameOverride=sealed-secrets-controller sealed-secrets/sealed-secrets

````


```First Sealed Secret```


````

kubectl create secret generic first-sealed --dry-run=client --from-literal=foo=bar -oyaml | kubeseal --format yaml > mysealedsecret.yaml

kubectl apply -f mysealedsecret.yaml

kubectl get secret first-sealed -oyaml

````


```More Examples```



````

 kubectl create secret generic secret-name --dry-run=client --from-literal=foo=bar -o [json|yaml] | \
    kubeseal \
      --controller-name=sealed-secrets-controller \
      --controller-namespace=kube-system \
      --format yaml > mysealedsecret.[json|yaml]


If you would rather not need access to the cluster to generate the sealed secret you can run:

    kubeseal \
      --controller-name=sealed-secrets-controller \
      --controller-namespace=kube-system \
      --fetch-cert > mycert.pem

to retrieve the public cert used for encryption and store it locally. You can then run 'kubeseal --cert mycert.pem' instead to use the local cert e.g.

    kubectl create secret generic secret-name --dry-run=client --from-literal=foo=bar -o [json|yaml] | \
    kubeseal \
      --controller-name=sealed-secrets-controller \
      --controller-namespace=kube-system \
      --format [json|yaml] --cert mycert.pem > mysealedsecret.[json|yaml]


````
