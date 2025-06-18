```Runai fake-gpu operator```



```fake-gpu-values.yaml```

````
topology:
  # nodePools is a map of node pool name to node pool configuration.
  # Nodes are assigned to node pools based on the node pool label's value (key is configurable via nodePoolLabelKey).
  #
  # For example, nodes that have the label "run.ai/simulated-gpu-node-pool: default"
  # will be assigned to the "default" node pool.
  nodePools:
    A100:
      gpuProduct: NVIDIA-A100
      gpuCount: 4
    H100:
      gpuProduct: NVIDIA-H100
      gpuCount: 4
    T400:
      gpuProduct: NVIDIA-T400
      gpuCount: 4

````


##### Then we need to label our node(s) correctly

````
kubectl label node mynode run.ai/simulated-gpu-node-pool=A100
````
