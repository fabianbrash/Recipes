# Dynatrace Kubernetes Monitoring Setup Guide

This guide provides a comprehensive walkthrough for installing the Dynatrace Operator and configuring full-stack monitoring for your Kubernetes cluster.

## 📋 Prerequisites
- **Dynatrace URL:** `https://oje58834.live.dynatrace.com/api`
- **Access Tokens:** You need an **Operator Token** and a **Data Ingest Token** generated from your Dynatrace Trial UI.

---

## 🛠️ Step 1: Create the Kubernetes Secret
Store your tokens securely in the cluster. This secret will be referenced by the DynaKube resource later.

````
# Create the namespace
kubectl create namespace dynatrace

# Create the secret (Replace placeholders with your actual tokens)
kubectl -n dynatrace create secret generic dynakube-tokens \
  --from-literal="apiToken=dt0c01.YOUR_OPERATOR_TOKEN" \
  --from-literal="dataIngestToken=dt0c01.YOUR_DATA_INGEST_TOKEN"
````


📦 Step 2: Install the Dynatrace Operator (Helm)
The Operator is the controller that manages the lifecycle of the monitoring agents.

````
# Add the Dynatrace Helm repository
helm repo add dynatrace https://raw.githubusercontent.com/Dynatrace/dynatrace-operator/main/config/helm/repos/stable
helm repo update

# Install the Operator
helm upgrade --install dynatrace-operator dynatrace/dynatrace-operator \
  -n dynatrace \
  --set installCRD=true \
  --atomic

````

📝 Step 3: Apply the DynaKube Configuration
The DynaKube is the Custom Resource (CR) that tells the Operator how to monitor your cluster.

Save the following content as dynakube.yaml and apply it:

````
apiVersion: dynatrace.com/v1beta5
kind: DynaKube
metadata:
  name: dynakube
  namespace: dynatrace
  annotations:
    # Automatically connects your K8s API to Dynatrace
    feature.dynatrace.com/automatic-kubernetes-api-monitoring: "true"
spec:
  # Connection Settings
  apiUrl: "https://oje58834.live.dynatrace.com/api"
  tokens: "dynakube-tokens"
  
  # Skip TLS verification (useful for proxies/private CAs)
  skipCertCheck: true

  # Monitoring Mode: Cloud Native Full Stack
  oneAgent:
    cloudNativeFullStack:
      nodeSelector: {}
      tolerations:
        - effect: NoSchedule
          operator: Exists

  # ActiveGate Capabilities (Metrics & Routing)
  activeGate:
    capabilities:
      - kubernetes-monitoring
      - routing
      - metrics-ingest
````

Apply the manifest:

````
kubectl apply -f dynakube.yaml
````

✅ Step 4: Verification
Monitor the rollout of the monitoring agents. It may take a few minutes for images to pull and pods to start.

1. Check the Custom Resource Status:

````
kubectl get dks -n dynatrace
````

2. Check the Monitoring Pods:

````
kubectl get pods -n dynatrace
````

🚀 Step 5: Activate Deep Monitoring
OneAgent injects into processes at startup. To see code-level data for applications that were already running, you must restart their pods:

````
# Example: Restart all deployments in a specific namespace
kubectl rollout restart deployment --all -n <your-app-namespace>
````

🔍 Useful Commands
Troubleshoot the Operator: kubectl exec -n dynatrace deployment/dynatrace-operator -- dynatrace-operator troubleshoot

View Operator Logs: kubectl logs -n dynatrace -l app.kubernetes.io/name=dynatrace-operator

````

kubectl get dks -A
````
