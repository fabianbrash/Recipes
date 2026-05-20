```vLLM information here```


#### vLLM CPU


#### First we need to build a custom image


````
docker build -f docker/Dockerfile.cpu \
  --tag vllm-cpu:v0.19.0 \
  --target vllm-openai \
  --shm-size=4g \
  --build-arg max_jobs=8 \
  .
````


#### Then we can push this into a registry, I have a pre-built CPU image here.

````
# custom vLLM image
harbor.fbclouddemo.us/public/vllm-cpu@sha256:8d1a17e09948c13a58323b5399901f4c38f3f39a9f0cdbc36fcd28f5be00a7c4

````

#### Now we need to run this on a machine or k8s as long as AVX512 is enabled


````
grep -o 'avx512[^ ]*' /proc/cpuinfo | sort -u

or

kubectl get nodes -o json | grep -o 'avx512[^ ",]*' | sort -u

````

#### And we cam run it like this


````
# Environment variables
VLLM_TARGET_DEVICE=cpu
VLLM_CPU_KVCACHE_SPACE=5
VLLM_CPU_OMP_THREADS_BIND=0-4

# Serve command
vllm serve Qwen/Qwen2.5-0.5B-Instruct \
  --dtype bfloat16 \
  --max-model-len 8192 \
  --api-key your-secret-key

````
