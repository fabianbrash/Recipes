#### Tanzu SQL with Postgres info goes here


[Tanzu Docs](https://docs.vmware.com/en/VMware-SQL-with-Postgres-for-Kubernetes/index.html)

[Install docs](https://docs.vmware.com/en/VMware-Tanzu-SQL-with-Postgres-for-Kubernetes/1.9/tanzu-postgres-k8s/GUID-install-operator.html)

##### Note: cert-manager is required in the cluster prior to installing any postgres instance

````

---
apiVersion: sql.tanzu.vmware.com/v1
kind: Postgres
metadata:
  name: pg-mypostgres
  namespace: postgres-databases
spec:
  memory: 800Mi
  cpu: "0.8"
  #storageClassName: standard
  postgresVersion:
    name: postgres-13
  storageSize: 10G
  highAvailability:
    enabled: false

````


````

apiVersion: sql.tanzu.vmware.com/v1
kind: Postgres
metadata:
  name: postgres-ha-sample
  namespace: postgres-databases
spec:
  memory: 800Mi
  cpu: "0.8"
  postgresVersion:
    name: postgres-14
  #storageClassName: standard
  storageSize: 800M
  serviceType: LoadBalancer
  highAvailability:
    enabled: true

````
