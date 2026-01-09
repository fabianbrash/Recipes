```KAFKA stuff here```


#### I am using vector for my agent in my k8s cluster

[Vector Helm Instructions](https://vector.dev/docs/setup/installation/package-managers/helm/)



```values.yaml```



````
role: Agent

# 1. PERMISSIONS & OOM FIX
containerSecurityContext:
  readOnlyRootFilesystem: false
  runAsUser: 0

securityContext:
  readOnlyRootFilesystem: false

# Increasing Memory to prevent OOMKill during connection spikes
resources:
  requests:
    cpu: 100m
    memory: 256Mi
  limits:
    cpu: 500m
    memory: 1Gi

service:
  enabled: false

serviceAccount:
  create: true
rbac:
  create: true

env:
  - name: KAFKA_PASSWORD
    valueFrom:
      secretKeyRef:
        name: kafka-credentials
        key: password

customConfig:
  data_dir: "/tmp/vector"
  sources:
    kubernetes_logs:
      type: kubernetes_logs

  transforms:
    # Simplified: No complex logic or regex for now
    enrich_logs:
      type: remap
      inputs: ["kubernetes_logs"]
      source: |
        .pod = .kubernetes.pod_name
        .container = .kubernetes.container_name

  sinks:
    kafka_sink:
      type: kafka
      inputs: ["enrich_logs"]
      bootstrap_servers: "db-kafka-nyc3-88382-do-user-139256-0.j.db.ondigitalocean.com:25073"
      topic: "k8s-logs"
      encoding:
        codec: json
      sasl:
        enabled: true
        mechanism: "SCRAM-SHA-256"
        username: "vector-producer"
        password: "${KAFKA_PASSWORD}"
      tls:
        enabled: true
        # FIX: Bypass SSL verification for the initial connection test
        verify_certificate: false
        verify_hostname: false
      
      buffer:
        type: disk
        max_size: 300000000 
        when_full: block

````



#### With the above we need to create a secret in the vector namespace so we can access our DigitalOcean Kafka instance


````

apiVersion: v1
kind: Secret
metadata:
  name: kafka-credentials
  namespace: vector # Ensure this matches the namespace where Vector is installed
type: Opaque
data:
  # The password must be Base64 encoded
  password: QVZOU19mUjA1b1YyQnRsallJV051445456gtdgfd

````


#### Once the vector is installed and running we can access our topic with a pod like below


````

kubectl --kubeconfig=mks-1-ztka-config.yaml run kafka-consumer -it --image=edenhill/kcat:1.7.1 --rm -- \
  kcat -b db-kafka-nyc3-88382-do-user-139256-0.j.db.ondigitalocean.com:25073 \
  -X security.protocol=SASL_SSL \
  -X sasl.mechanisms=SCRAM-SHA-256 \
  -X sasl.username='admin' \
  -X sasl.password=${KAFKA_PASSWORD} \
  -X enable.ssl.certificate.verification=false \
  -t k8s-logs -C -o beginning

````
