```TAP info goes here```




```TAP Tanzu Postgres Operator Workaround```


##### This workaround only applies if you used the Tanzu Postgres Operator to prisvision your postgres instance(s)



````
kubectl exec -n postgres-databases -it pg-tap-0 -c pg-container -- bash -c psql


alter user postgres with superuser; and then \q

````


```update pg_hba.conf```


````
kubectl exec -n postgres-databases -it pg-tap-0 -c pg-container -- bash

    cd /pgsql/data
    echo “host all all all md5" >> pg_hba.conf
    echo “host all ‘pgadmin’ all md5” >> pg_hba.conf
    psql
    select pg_reload_conf();
    select pg_read_file(‘pg_hba.conf’);
    \q
    exit

````

```MetadataStore config```


[https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.4/tap/scst-store-using-encrypted-connection.html#additional-resources](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.4/tap/scst-store-using-encrypted-connection.html#additional-resources)


[https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.4/tap/scst-store-use-node-port.html](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.4/tap/scst-store-use-node-port.html)


````
kubectl get secret ingress-cert -n metadata-store -o json | jq -r '.data."ca.crt"' | base64 -d > insight-ca.crt #Grab cert


export METADATA_STORE_PORT=$(kubectl get service/metadata-store-app --namespace metadata-store -o jsonpath="{.spec.ports[0].port}")
export METADATA_STORE_DOMAIN="metadata-store-app.metadata-store.svc.cluster.local"

# delete any previously added entry
sudo sed -i '' "/$METADATA_STORE_DOMAIN/d" /etc/hosts  #OPTIONAL

echo "127.0.0.1 $METADATA_STORE_DOMAIN" | sudo tee -a /etc/hosts > /dev/null   #NOT OPTIONAL



kubectl port-forward service/metadata-store-app 8443:8443 -n metadata-store


tanzu insight health

````


##### Now let's retrieve our token to add to our TAP values file

[https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.4/tap/scst-store-configure-access-token.html](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.4/tap/scst-store-configure-access-token.html)

````

export METADATA_STORE_ACCESS_TOKEN=$(kubectl get secrets metadata-store-read-write-client -n metadata-store -o jsonpath="{.data.token}" | base64 -d)

````
