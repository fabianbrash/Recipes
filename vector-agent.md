```Vector agent stuff goes here```


[Vector](https://vector.dev/docs/setup/installation/package-managers/helm/)


````
podAnnotations:
  dynatrace.com/inject: "false"            # The "Master Switch" (Disables all mutations)
  oneagent.dynatrace.com/inject: "false"   # Specifically for the Code Module
  metadata.dynatrace.com/inject: "false"   # Disables Metadata Enrichment

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
    memory: 512Mi

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
      bootstrap_servers: "db-kafka-nyc3-02353-do-user-166554456-0.e.db.ondigitalocean.com:25073"
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


##### The below assumes no security on the Kafka instance


````
role: Agent

# 1. PERMISSIONS: Required for MKS to allow writing to the host/data_dir
containerSecurityContext:
  readOnlyRootFilesystem: false
  runAsUser: 0

securityContext:
  readOnlyRootFilesystem: false

# 2. RESOURCES: 1Gi limit to handle spikes when Kafka is slow
resources:
  requests:
    cpu: 100m
    memory: 256Mi
  limits:
    cpu: 500m
    memory: 1Gi

# 3. SERVICE: Disabled as the agent is a producer-only pod
service:
  enabled: false

serviceAccount:
  create: true
rbac:
  create: true

customConfig:
  # Redirect data dir to a writable location for MKS
  data_dir: "/tmp/vector"

  sources:
    kubernetes_logs:
      type: kubernetes_logs

  transforms:
    # Basic Metadata Injection
    enrich_logs:
      type: remap
      inputs: ["kubernetes_logs"]
      source: |
        .pod = .kubernetes.pod_name
        .container = .kubernetes.container_name
        .namespace = .kubernetes.pod_namespace
        .node = .kubernetes.node_name

  sinks:
    kafka_sink:
      type: kafka
      inputs: ["enrich_logs"]
      # UPDATED: No security protocol (PLAINTEXT) usually uses port 9092
      bootstrap_servers: "YOUR_INTERNAL_KAFKA_IP:9092"
      topic: "k8s-logs"
      encoding:
        codec: json
      
      # SASL and TLS blocks have been removed for a "No Security" setup
      
      buffer:
        type: disk
        max_size: 300000000 
        when_full: block

````
