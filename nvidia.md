```NVIDIA```


````
nvidia-smi
nvidia-smi -L

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
