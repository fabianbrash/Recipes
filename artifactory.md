```Artifactory info goes here```


#### When we create a helm repo in Artifactory we have couple of options, the newer is OCI, but we can also create a legacy Helm repo, I prefer legacy for now until all tools can handle the new OCI url


````

helm repo add us1a-fb-helm-legacy https://frjb.jfrog.io/artifactory/api/helm/us1a-fb-helm-legacy --username fabian@fabianbrash.com --password YOUR_TOKEN_HERE


````


```UPLOAD```


````
curl -ufabian@fabianbrash.com:YOUR_TOKEN_HERE -T grafana-8.0.0.tgz "https://frjb.jfrog.io/artifactory/us1a-fb-helm-legacy/grafana-8.0.0.tgz"
````


```INSTALL```


````
helm repo update
helm install us1a-fb-helm-legacy/[chartName]
````
