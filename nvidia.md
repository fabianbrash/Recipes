```NVIDIA```


````
nvidia-smi
nvidia-smi -L

nvidia-smi mig -lgip

````


````
apiVersion: v1
kind: Pod
metadata:
  name: nvidia-smi
spec:
  restartPolicy: OnFailure
  containers:
  - name: vectoradd
    image: nvcr.io/nvidia/k8s/cuda-sample:vectoradd-cuda11.1
    command: ["nvidia-smi"]
    resources:
      limits:
         nvidia.com/gpu: 1
````

````
kubectl logs nvidia-smi
````

[https://aws.amazon.com/blogs/containers/bottlerocket-support-for-nvidia-gpus/](https://aws.amazon.com/blogs/containers/bottlerocket-support-for-nvidia-gpus/)


````
apiVersion: v1
kind: Pod
metadata:
  name: h100-mig-test-sleep
spec:
  restartPolicy: OnFailure
  containers:
  - name: cuda-container
    image: nvidia/cuda:12.2.0-base-ubuntu22.04
    # Using /bin/bash -c to chain the commands
    command: ["/bin/bash", "-c"]
    args:
      - |
        echo "--- GPU Slice Information ---"
        nvidia-smi
        echo "--- End of nvidia-smi ---"
        echo "Pod will now sleep for 3600 seconds to allow for debugging."
        sleep 3600
    resources:
      limits:
        nvidia.com/mig-1g.10gb: 1
      requests:
        nvidia.com/mig-1g.10gb: 1
````

````
apiVersion: v1
kind: Pod
metadata:
  name: h100-mig-test-sleep-large
spec:
  restartPolicy: OnFailure
  containers:
  - name: cuda-container
    image: nvidia/cuda:12.2.0-base-ubuntu22.04
    # Using /bin/bash -c to chain the commands
    command: ["/bin/bash", "-c"]
    args:
      - |
        echo "--- GPU Slice Information ---"
        nvidia-smi
        echo "--- End of nvidia-smi ---"
        echo "Pod will now sleep for 3600 seconds to allow for debugging."
        sleep 3600
    resources:
      limits:
        nvidia.com/mig-3g.40gb: "1"
      requests:
        nvidia.com/mig-3g.40gb: "1"
````

### Note in the above we've set the mig mode as 'mixed', while in the below we've set it as 'single'

#### NOTE THE RESOURCE AND LIMIT SECTIONS AND HOW THEY ARE DEFINED, THESE ARE THE LITTLE GOTCHAS

````
apiVersion: v1
kind: Pod
metadata:
  name: mig-gpu-sleep
spec:
  restartPolicy: Never
  containers:
  - name: cuda
    image: nvidia/cuda:12.2.0-base-ubuntu22.04
    command:
      - sh
      - -c
      - |
        echo "=== NVIDIA-SMI OUTPUT ==="
        nvidia-smi
        echo "=== Sleeping for 1 hour ==="
        sleep 3600
    resources:
      limits:
        nvidia.com/gpu: 1
````
