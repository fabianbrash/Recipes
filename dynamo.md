```Dynamo stuff here```




```Dynamo helm chart```

````

export NAMESPACE=dynamo-system
export RELEASE_VERSION=1.3.0  # check https://github.com/ai-dynamo/dynamo/releases for latest

helm fetch https://helm.ngc.nvidia.com/nvidia/ai-dynamo/charts/dynamo-platform-$RELEASE_VERSION.tgz

helm install dynamo-platform dynamo-platform-$RELEASE_VERSION.tgz \
  --namespace $NAMESPACE \
  --create-namespace

````


### Please note the name of the Helm release it's called 'dynamo-platform' if you change this you will run into an issue where the svc in cluster will be created and the frontend pod will not be able to communicate as it's expecting the service name to match dynamo-system...

```Images used```


````
nvcr.io/nvidia/ai-dynamo/vllm-runtime:1.1.1

registry.dev.rafay-edge.net/tf/dynamo-frontend:1.3.0-tool-fix   ## fixed for tool calling

nvcr.io/nvidia/ai-dynamo/dynamo-frontend:1.3.0  ## frontend image

````
