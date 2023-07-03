```GCP info goes here```


````
# list all my k8s clusters in my current project
gcloud container clusters list

# list available k8s version on a region

gcloud container get-server-config --region=us-central1-a --flatten=channels --filter="channels.channel=REGULAR" --format="value(channels.defaultVersion)"


gcloud container get-server-config --region=us-east1-a --flatten=channels --filter="channels.channel=REGULAR" --format="value(channels.defaultVersion)"


gcloud container get-server-config
````
