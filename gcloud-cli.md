```gcloud cli info here```



````
gcloud init --console-only # to setup default configuration
gcloud config configurations create zeus # creating custom config
gcloud config configurations list
gcloud info 


gcloud components list
gcloud components update

````


```create gke cluster```


````
gcloud container get-server-config --region=us-central1   # See what versions are avaiable to us

gcloud container clusters create zeus \
--disk-size=125GB \
--cluster-version=1.23.17-gke.2000 \
--machine-type n1-standard-4 \
--num-nodes 3 \
--zone us-central1-c


gcloud container clusters list

gcloud container clusters get-credentials zeus --zone us-central1-c --project zeus-python-app

````


[https://medium.com/techbull/gke-cluster-with-gcloud-utility-for-dummies-5e42bf01b739](https://medium.com/techbull/gke-cluster-with-gcloud-utility-for-dummies-5e42bf01b739)



```cleaning up```


````

gcloud container clusters delete zeus --zone us-central1-c

gcloud config configurations delete zeus

gcloud projects delete zeus-python-app

````
