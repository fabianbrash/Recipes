## TKGs info goes here


#### Deploy a cluster

[TKC YAML specs](https://docs.vmware.com/en/VMware-vSphere/7.0/vmware-vsphere-with-tanzu/GUID-B1034373-8C38-4FE2-9517-345BF7271A1E.html#GUID-B1034373-8C38-4FE2-9517-345BF7271A1E__section_kgn_h31_3pb)

[How to install vSphere with Tanzu with vSphere Networking](https://little-stuff.com/2020/10/07/how-to-install-vsphere-with-tanzu-with-vsphere-networking/)


[Network Topology](https://docs.vmware.com/en/VMware-vSphere/7.0/vmware-vsphere-with-tanzu/GUID-489A842E-1A74-4A94-BC7F-354BDB780751.html)



````

apiVersion: run.tanzu.vmware.com/v1alpha1      #TKGS API endpoint
kind: TanzuKubernetesCluster                   #required parameter
metadata:
  name: tkgs-cluster-1                         #cluster name, user defined
  namespace: tgks-cluster-ns                   #vsphere namespace
spec:
  distribution:
    version: v1.20                             #Resolves to latest TKR 1.20
  topology:
    controlPlane:
      count: 1                                 #number of control plane nodes
      class: best-effort-medium                #vmclass for control plane nodes
      storageClass: vwt-storage-policy         #storageclass for control plane
    workers:
      count: 1                                 #number of worker nodes
      class: best-effort-medium                #vmclass for worker nodes
      storageClass: vwt-storage-policy         #storageclass for worker nodes

````

````

apiVersion: run.tanzu.vmware.com/v1alpha1      
kind: TanzuKubernetesCluster                   
metadata:
  name: tkgs-cluster-5                         
  namespace: tgks-cluster-ns                   
spec:
  distribution:
    version: v1.20                            
  topology:
    controlPlane:
      count: 3                                 
      class: best-effort-medium                 
      storageClass: vwt-storage-policy
      volumes:
        - name: etcd
          mountPath: /var/lib/etcd
          capacity:
            storage: 4Gi       
    workers:
      count: 3                                 
      class: best-effort-medium                 
      storageClass: vwt-storage-policy        
      volumes:
        - name: containerd
          mountPath: /var/lib/containerd
          capacity:
            storage: 16Gi

````

````

apiVersion: run.tanzu.vmware.com/v1alpha1
kind: TanzuKubernetesCluster
metadata:
  name: fb-wcp-2
  namespace: fb-ns
spec:
  distribution:
    fullVersion: v1.20.12+vmware.1-tkg.1.b9a42f3
    version: "" 
  topology:                               
    controlPlane:
      count: 3
      class: best-effort-2xlarge
      storageClass: vc01cl01-t0compute
      volumes: #optional setting for high-churn control plane component (such as etcd)
        - name: etcd-0
          mountPath: /var/lib/etcd
          capacity:
            storage: 40Gi 
    workers:                              
      count: 9
      class: guaranteed-large
      storageClass: vc01cl01-t0compute
      volumes: #optional setting for high-churn worker node component (such as containerd)
        - name: containerd-0
          mountPath: /var/lib/containerd
          capacity:
            storage: 120Gi             
  settings: #all spec.settings are optional
    storage: #optional storage settings
      classes: ["vc01cl01-t0compute"]
      defaultClass: vc01cl01-t0compute
    network: #optional network settings
      cni: #override default cni set in the tkgservicesonfiguration spec
        name: antrea
      #pods: custom pod network
        #cidrBlocks: [<array of pod cidr blocks>]
      #services: custom service network
        #cidrBlocks: [<array of service cidr blocks>]
      #serviceDomain: <custom service domain>
      
      #trust: trust fields for custom public certs for tls
        #additionalTrustedCAs:
          #- name: <first-cert-name>
            #data: <base64-encoded string of PEM encoded public cert 1>
          #- name: <second-cert-name>
            #data: <base64-encoded string of PEM encoded public cert 2>


````

### Use a different version of k8s here 1.20.12

````
apiVersion: run.tanzu.vmware.com/v1alpha1
kind: TanzuKubernetesCluster
metadata:
  name: fb-onprem3-1-20
  namespace: devns5
spec:
  distribution:
    fullVersion: 1.20.12+vmware.1-tkg.1.b9a42f3
    version: "" 
  topology:                               
    controlPlane:
      count: 1
      class: cust-best-controlplane
      storageClass: goldsp
      volumes: #optional setting for high-churn control plane component (such as etcd)
        - name: etcd-0
          mountPath: /var/lib/etcd
          capacity:
            storage: 40Gi 
    workers:                              
      count: 4
      class: best-effort-small
      storageClass: goldsp
      volumes: #optional setting for high-churn worker node component (such as containerd)
        - name: containerd-0
          mountPath: /var/lib/containerd
          capacity:
            storage: 90Gi             
  settings: #all spec.settings are optional
    storage: #optional storage settings
      classes: ["goldsp"]
      defaultClass: "goldsp"
    network: #optional network settings
      cni: #override default cni set in the tkgservicesonfiguration spec
        name: antrea
      #pods: custom pod network
        #cidrBlocks: [<array of pod cidr blocks>]
      #services: custom service network
        #cidrBlocks: [<array of service cidr blocks>]
      #serviceDomain: <custom service domain>
      
      #trust: trust fields for custom public certs for tls
        #additionalTrustedCAs:
          #- name: <first-cert-name>
            #data: <base64-encoded string of PEM encoded public cert 1>
          #- name: <second-cert-name>
            #data: <base64-encoded string of PEM encoded public cert 2>

````

```v1alpha2 clusters```

##### use this version on newer vCenter 7u3+ environments

````
apiVersion: run.tanzu.vmware.com/v1alpha2
kind: TanzuKubernetesCluster
metadata:
  name: tkgs-tap
  namespace: dev
spec:
  topology:
    controlPlane:
      replicas: 1
      vmClass: best-effort-cpu-intensive-2xlarge
      storageClass: goldsp
      volumes:
        - name: etcd
          mountPath: /var/lib/etcd
          capacity:
            storage: 25Gi
      tkr:  
        reference:
          name: v1.23.8---vmware.3-tkg.1
    nodePools:
    - name: worker-nodepool-a1
      replicas: 4
      vmClass: best-effort-cpu-intensive-large
      storageClass: goldsp
      volumes:
        - name: containerd
          mountPath: /var/lib/containerd
          capacity:
            storage: 125Gi
      tkr:  
        reference:
          name: v1.23.8---vmware.3-tkg.1
    #- name: worker-nodepool-a2
      #replicas: 2
      #vmClass: guaranteed-medium
      #storageClass: vwt-storage-policy
      #tkr:  
        #reference:
          #name: v1.21.2---vmware.1-tkg.1.ee25d55
    #- name: worker-nodepool-a3
      #replicas: 1
      #vmClass: guaranteed-small
      #storageClass: vwt-storage-policy
      #tkr:  
        #reference:
          #name: v1.21.2---vmware.1-tkg.1.ee25d55
  settings:
    storage:
      defaultClass: goldsp
    network:
      cni:
        name: antrea
      #services:
        #cidrBlocks: ["198.53.100.0/16"]
      #pods:
        #cidrBlocks: ["192.0.5.0/16"]
      #serviceDomain: cluster.local
      #proxy:
        #httpProxy: http://<user>:<pwd>@<ip>:<port>
        #httpsProxy: http://<user>:<pwd>@<ip>:<port>
        #noProxy: [10.246.0.0/16,192.168.144.0/20,192.168.128.0/20]
      #trust:
        #additionalTrustedCAs:
          #- name: CompanyInternalCA-1
            #data: LS0tLS1C...LS0tCg==
          #- name: CompanyInternalCA-2
            #data: MTLtMT1C...MT0tPg==

````

```vCenter8```


````
apiVersion: run.tanzu.vmware.com/v1alpha3
kind: TanzuKubernetesCluster
metadata:
  name: tkc-custom-storage
  namespace: tkg2-cluster-ns
spec:
  topology:
    controlPlane:
      replicas: 3
      vmClass: guaranteed-medium
      storageClass: tkg2-storage-policy
      tkr:
        reference:
          name: v1.23.8---vmware.2-tkg.2-zshippable
      volumes:
      - name: etcd
        mountPath: /var/lib/etcd
        capacity:
          storage: 4Gi
    nodePools:
    - replicas: 3
      name: worker-np
      vmClass: guaranteed-medium
      storageClass: tkg2-storage-policy
      tkr:
        reference:
          name: v1.23.8---vmware.2-tkg.2-zshippable
      volumes:
      - name: containerd
        mountPath: /var/lib/containerd
        capacity:
          storage: 50Gi
      - name: kubelet
        mountPath: /var/lib/kubelet
        capacity:
          storage: 50Gi
  settings:
    storage:
      defaultClass: tkg2-storage-policy

````


```Ubuntu```


````
apiVersion: run.tanzu.vmware.com/v1alpha3
kind: TanzuKubernetesCluster
metadata:
  name: tkc-ubuntu-gpu
  namespace: tkg2-cluster-ns
  annotations:
    run.tanzu.vmware.com/resolve-os-image: os-name=ubuntu
spec:
   topology:
     controlPlane:
       replicas: 3
       storageClass: tkg2-storage-policy
       vmClass: guaranteed-large
       tkr:
         reference:
           name: v1.23.8---vmware.2-tkg.2-zshippable
       volumes:
       - name: etcd
         mountPath: /var/lib/etcd
         capacity:
           storage: 4Gi
     nodePools:
     - name: nodepool-a100-primary
       replicas: 3
       storageClass: tkg2-storage-policy
       vmClass: vgpu-a100
       tkr:
         reference:
           name: v1.23.8---vmware.2-tkg.2-zshippable
       volumes:
       - name: containerd
         mountPath: /var/lib/containerd
         capacity:
           storage: 70Gi
       - name: kubelet
         mountPath: /var/lib/kubelet
         capacity:
           storage: 70Gi
     - name: nodepool-a100-secondary
       replicas: 3
       storageClass: tkg2-storage-policy
       vmClass: vgpu-a100
       tkr:
         reference:
           name: v1.23.8---vmware.2-tkg.2-zshippable
       volumes:
       - name: containerd
         mountPath: /var/lib/containerd
         capacity:
           storage: 70Gi
       - name: kubelet
         mountPath: /var/lib/kubelet
         capacity:
           storage: 70Gi
   settings:
     storage:
       defaultClass: tkg2-storage-policy
     network:
       cni:
        name: antrea
       services:
        cidrBlocks: ["198.51.100.0/12"]
       pods:
        cidrBlocks: ["192.0.2.0/16"]
       serviceDomain: cluster.local

````

[https://docs.vmware.com/en/VMware-vSphere/8.0/vsphere-with-tanzu-tkg/GUID-D09930F7-9EC9-40D5-9349-4FC49E9EA5FB.html](https://docs.vmware.com/en/VMware-vSphere/8.0/vsphere-with-tanzu-tkg/GUID-D09930F7-9EC9-40D5-9349-4FC49E9EA5FB.html)


```classy clusters officially clusterclass```


````
---
apiVersion: cluster.x-k8s.io/v1beta1
kind: Cluster
#define the cluster
metadata:
  #user-defined name of the cluster; string
  name: cluster-default
  #kubernetes namespace for the cluster; string
  namespace: tkg2-cluster-ns
#define the desired state of cluster
spec:
  #specify the cluster network; required, there is no default
  clusterNetwork:
    #network ranges from which service VIPs are allocated
    services:
      #ranges of network addresses; string array
      #CAUTION: must not overlap with Supervisor
      cidrBlocks: ["198.51.100.0/12"]
    #network ranges from which Pod networks are allocated
    pods:
      #ranges of network addresses; string array
      #CAUTION: must not overlap with Supervisor
      cidrBlocks: ["192.0.2.0/16"]
    #domain name for services; string
    serviceDomain: "cluster.local"
  #specify the topology for the cluster
  topology:
    #name of the ClusterClass object to derive the topology
    class: tanzukubernetescluster
    #kubernetes version of the cluster; format is TKR NAME
    version: v1.23.8---vmware.2-tkg.2-zshippable
    #describe the cluster control plane
    controlPlane:
      #number of control plane nodes; integer 1 or 3
      replicas: 3
    #describe the cluster worker nodes
    workers:
      #specifies parameters for a set of worker nodes in the topology
      machineDeployments:
        #node pool class used to create the set of worker nodes
        - class: node-pool
          #user-defined name of the node pool; string
          name: node-pool-1
          #number of worker nodes in this pool; integer 0 or more
          replicas: 3
    #customize the cluster
    variables:
      #virtual machine class type and size for cluster nodes
      - name: vmClass
        value: guaranteed-medium
      #persistent storage class for cluster nodes
      - name: storageClass
        value: tkg2-storage-policy
      # default storageclass for control plane and worker node pools
      - name: defaultStorageClass
        value: tkg2-storage-policy

````



[https://docs.vmware.com/en/VMware-vSphere/8.0/vsphere-with-tanzu-tkg/GUID-607BA980-E3E3-4167-ABC8-B9FCDCF44746.html](https://docs.vmware.com/en/VMware-vSphere/8.0/vsphere-with-tanzu-tkg/GUID-607BA980-E3E3-4167-ABC8-B9FCDCF44746.html)

### Adding certs after the fact

[Adding trusted certs to nodes on TKGS 7.0 U2](https://brianragazzi.wordpress.com/tag/tanzu-kubernetes-grid-service/)


````

apiVersion: run.tanzu.vmware.com/v1alpha2
kind: TkgServiceConfiguration
metadata:
  name: tkg-service-configuration
spec:
  defaultCNI: antrea

  trust:
    additionalTrustedCAs:
      - name: first-cert-name
        data: base64-encoded string of a PEM encoded public cert 1
      - name: second-cert-name
        data: base64-encoded string of a PEM encoded public cert 2

````

### Note the new behavior for the above is that it will automatically kick off a rolling upgrade of the cluster; if for some reason you are using the older version then you have to trigger a rolling upgrade, or delete the cluster(s) and re-create it/them; rolling upgrade is obviously preferred

### Prior to vSphere 7U3 if you want to add your supervisor cluster to TMC you need to run the below


````

kubectl get ns  #Look for something like svc-tmc-xxx

````

````

---
apiVersion: installers.tmc.cloud.vmware.com/v1alpha1
kind: AgentInstall
metadata:
  name: tmc-agent-installer-config
  namespace: svc-tmc-c8  #Your's will be different get the name from the above command
spec:
  operation: INSTALL
  registrationLink: THIS_IS_THE_LINK_GENERATED_FROM_TMC

````

### By default the PSP is extremely strict so if you are not using TMC you need to do the below

````

kubectl create clusterrolebinding default-tkg-admin-privileged-binding --clusterrole=psp:vmware-system-privileged --group=system:authenticated

````

```Deploy TKGs with HAPROXY```

### This blog post was a huge help as I messed up my subnetting and would not have found my issue

[https://rguske.github.io/post/vsphere-with-tanzu-troubleshooting-haproxy/](https://rguske.github.io/post/vsphere-with-tanzu-troubleshooting-haproxy/)

```troubleshoot```

````

ssh root@haproxy-vm

systemctl list-units --state=failed

systemctl status anyip-routes.service

cat /etc/vmware/anyip-routes.cfg #make sure this has the correct subnet

````


```my subnet```

````

192.168.182.170/26 #subnet, make sure this is correct in /etc/vmware/anyip-routes.cfg on the haproxy VM

192.168.182.128-192.168.182.191 #actual range, make sure you enter the correct range

````


### And then I just followed these 2 posts from Cormac

[https://cormachogan.com/2020/09/25/deploy-ha-proxy-for-vsphere-with-tanzu/#google_vignette](https://cormachogan.com/2020/09/25/deploy-ha-proxy-for-vsphere-with-tanzu/#google_vignette)

[https://cormachogan.com/2020/09/28/enabling-vsphere-with-tanzu-using-ha-proxy/](https://cormachogan.com/2020/09/28/enabling-vsphere-with-tanzu-using-ha-proxy/)


#### Log into our supervisor cluster

````

kubectl vsphere login --vsphere-username user@domain --server=10.0.1.10 --insecure-skip-tls-verify

kubectl vsphere login -u user@domain --server=https://10.0.1.10 --insecure-skip-tls-verify


kubectl-vsphere login -u user@domain --server=https://10.0.1.10 --insecure-skip-tls-verify

````


#### Now let's log into our namespace and workload cluster

````

kubectl vsphere login -u user@domain --server=https://10.0.1.10 --insecure-skip-tls-verify --tanzu-kubernetes-cluster-name my-cluster --tanzu-kubernetes-cluster-namespace my-ns

````
#### If you run kubectl get tkr and nothing comes back, log into the VAMI and try restarting the content library service


#### I ran into some issues doing a Supervisor upgrade, this was very helpful

[https://blog.ukotic.net/2021/07/15/supervisorcontrolplanevm-in-a-not-ready-state-on-vsphere-with-tanzu/](https://blog.ukotic.net/2021/07/15/supervisorcontrolplanevm-in-a-not-ready-state-on-vsphere-with-tanzu/)


```Add custom Certs```

````
---
apiVersion: run.tanzu.vmware.com/v1alpha1 #v1alpha2
kind: TkgServiceConfiguration
metadata:
  name: tkg-service-configuration
spec:
  defaultCNI: antrea
  #proxy:
  #  httpProxy: http://<user>:<pwd>@<ip>:<port>

  trust:
    additionalTrustedCAs:
      - name: harbor-01-root-cert
        data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUZhekNDQTFPZ0F3SUJBZ0lSQUlJUXo3RFNRT05aUkdQZ3UyT0Npd0F3RFFZSktvWklodmNOQVFFTEJRQXcKVHpFTE1Ba0dBMVVFQmhNQ1ZWTXhLVEFuQmdOVkJBb1RJRWx1ZEdWeWJtVjBJRk5sWTNWeWFYUjVJRkpsYzJWaApjbU5vSUVkeWIzVndNUlV3RXdZRFZRUURFd3hKVTFKSElGSnZiM1FnV0RFd0hoY05NVFV3TmpBME1URXdORE00CldoY05NelV3TmpBME1URXdORE00V2pCUE1Rc3dDUVlEVlFRR0V3SlZVekVwTUNjR0ExVUVDaE1nU1c1MFpYSnUKWlhRZ1UyVmpkWEpwZEhrZ1VtVnpaV0Z5WTJnZ1IzSnZkWEF4RlRBVEJnTlZCQU1UREVsVFVrY2dVbTl2ZENCWQpNVENDQWlJd0RRWUpLb1pJaHZjTkFRRUJCUUFEZ2dJUEFEQ0NBZ29DZ2dJQkFLM29KSFAwRkRmem01NHJWeWdjCmg3N2N0OTg0a0l4dVBPWlhvSGozZGNLaS92VnFidllBVHlqYjNtaUdiRVNUdHJGai9SUVNhNzhmMHVveG15RisKMFRNOHVrajEzWG5mczdqL0V2RWhta3ZCaW9aeGFVcG1abXlQZmp4d3Y2MHBJZ2J6NU1EbWdLN2lTNCszbVg2VQpBNS9UUjVkOG1VZ2pVK2c0cms4S2I0TXUwVWxYaklCMHR0b3YwRGlOZXdOd0lSdDE4akE4K28rdTNkcGpxK3NXClQ4S09FVXQrend2by83VjNMdlN5ZTByZ1RCSWxESENOQXltZzRWTWs3QlBaN2htL0VMTktqRCtKbzJGUjNxeUgKQjVUMFkzSHNMdUp2VzVpQjRZbGNOSGxzZHU4N2tHSjU1dHVrbWk4bXhkQVE0UTdlMlJDT0Z2dTM5NmozeCtVQwpCNWlQTmdpVjUrSTNsZzAyZFo3N0RuS3hIWnU4QS9sSkJkaUIzUVcwS3RaQjZhd0JkcFVLRDlqZjFiMFNIelV2CktCZHMwcGpCcUFsa2QyNUhON3JPckZsZWFKMS9jdGFKeFFaQktUNVpQdDBtOVNUSkVhZGFvMHhBSDBhaG1iV24KT2xGdWhqdWVmWEtuRWdWNFdlMCtVWGdWQ3dPUGpkQXZCYkkrZTBvY1MzTUZFdnpHNnVCUUUzeERrM1N6eW5UbgpqaDhCQ05BdzFGdHhOclFIdXNFd01GeEl0NEk3bUtaOVlJcWlveW1DekxxOWd3UWJvb01EUWFIV0JmRWJ3cmJ3CnFIeUdPMGFvU0NxSTNIYWFkcjhmYXFVOUdZL3JPUE5rM3NnckRRb28vL2ZiNGhWQzFDTFFKMTNoZWY0WTUzQ0kKclU3bTJZczZ4dDBuVVc3L3ZHVDFNME5QQWdNQkFBR2pRakJBTUE0R0ExVWREd0VCL3dRRUF3SUJCakFQQmdOVgpIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJSNXRGbm1lN2JsNUFGemdBaUl5QnBZOXVtYmJqQU5CZ2txCmhraUc5dzBCQVFzRkFBT0NBZ0VBVlI5WXFieXlxRkRRRExIWUdta2dKeWtJckdGMVhJcHUrSUxsYVMvVjlsWkwKdWJoekVGblRJWmQrNTB4eCs3TFNZSzA1cUF2cUZ5RldoZkZRRGxucnp1Qlo2YnJKRmUrR25ZK0VnUGJrNlpHUQozQmViWWh0RjhHYVYwbnh2d3VvNzd4L1B5OWF1Si9HcHNNaXUvWDErbXZvaUJPdi8yWC9xa1NzaXNSY09qL0tLCk5GdFkyUHdCeVZTNXVDYk1pb2d6aVV3dGhEeUMzKzZXVndXNkxMdjN4TGZIVGp1Q3ZqSElJbk56a3RIQ2dLUTUKT1JBekk0Sk1QSitHc2xXWUhiNHBob3dpbTU3aWF6dFhPb0p3VGR3Sng0bkxDZ2ROYk9oZGpzbnZ6cXZIdTdVcgpUa1hXU3RBbXpPVnl5Z2hxcFpYakZhSDNwTzNKTEYrbCsvK3NLQUl1dnRkN3UrTnhlNUFXMHdkZVJsTjhOd2RDCmpOUEVscHpWbWJVcTRKVWFnRWl1VERrSHpzeEhwRktWSzdxNCs2M1NNMU45NVIxTmJkV2hzY2RDYitaQUp6VmMKb3lpM0I0M25qVE9RNXlPZisxQ2NlV3hHMWJRVnM1WnVmcHNNbGpxNFVpMC8xbHZoK3dqQ2hQNGtxS09KMnF4cQo0Umdxc2FoRFlWdlRIOXc3alhieUxlaU5kZDhYTTJ3OVUvdDd5MEZmLzl5aTBHRTQ0WmE0ckYyTE45ZDExVFBBCm1SR3VuVUhCY25XRXZnSkJRbDluSkVpVTBac252Z2MvdWJoUGdYUlI0WHEzN1owajRyN2cxU2dFRXp3eEE1N2QKZW15UHhnY1l4bi9lUjQ0L0tKNEVCcytsVkRSM3ZleUptK2tYUTk5YjIxLytqaDVYb3MxQW5YNWlJdHJlR0NjPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
      - name: harbor-01-intermediate-cert
        data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUZGakNDQXY2Z0F3SUJBZ0lSQUpFckNFclBEQmluVS9iV0xpV25YMW93RFFZSktvWklodmNOQVFFTEJRQXcKVHpFTE1Ba0dBMVVFQmhNQ1ZWTXhLVEFuQmdOVkJBb1RJRWx1ZEdWeWJtVjBJRk5sWTNWeWFYUjVJRkpsYzJWaApjbU5vSUVkeWIzVndNUlV3RXdZRFZRUURFd3hKVTFKSElGSnZiM1FnV0RFd0hoY05NakF3T1RBME1EQXdNREF3CldoY05NalV3T1RFMU1UWXdNREF3V2pBeU1Rc3dDUVlEVlFRR0V3SlZVekVXTUJRR0ExVUVDaE1OVEdWMEozTWcKUlc1amNubHdkREVMTUFrR0ExVUVBeE1DVWpNd2dnRWlNQTBHQ1NxR1NJYjNEUUVCQVFVQUE0SUJEd0F3Z2dFSwpBb0lCQVFDN0FoVW96UGFnbE5NUEV1eU5WWkxEK0lMeG1hWjZRb2luWFNhcXRTdTV4VXl4cjQ1citYWElvOWNQClI1UVVWVFZYako2b29qa1o5WUk4UXFsT2J2VTd3eTdiamNDd1hQTlpPT2Z0ejJud1dnc2J2c0NVSkNXSCtqZHgKc3hQbkhLemhtKy9iNUR0RlVrV1dxY0ZUempUSVV1NjFydTJQM21CdzRxVlVxN1p0RHBlbFFEUnJLOU84WnV0bQpOSHo2YTR1UFZ5bVorREFYWGJweWIvdUJ4YTNTaGxnOUY4Zm5DYnZ4Sy9lRzNNSGFjVjNVUnVQTXJTWEJpTHhnClozVm1zL0VZOTZKYzVsUC9Pb2kyUjZYL0V4anFtQWwzUDUxVCtjOEI1ZldtY0JjVXIyT2svNW16azUzY1U2Y0cKL2tpRkhhRnByaVYxdXhQTVVnUDE3VkdoaTlzVkFnTUJBQUdqZ2dFSU1JSUJCREFPQmdOVkhROEJBZjhFQkFNQwpBWVl3SFFZRFZSMGxCQll3RkFZSUt3WUJCUVVIQXdJR0NDc0dBUVVGQndNQk1CSUdBMVVkRXdFQi93UUlNQVlCCkFmOENBUUF3SFFZRFZSME9CQllFRkJRdXN4ZTNXRmJMcmxBSlFPWWZyNTJMRk1MR01COEdBMVVkSXdRWU1CYUEKRkhtMFdlWjd0dVhrQVhPQUNJaklHbGoyNlp0dU1ESUdDQ3NHQVFVRkJ3RUJCQ1l3SkRBaUJnZ3JCZ0VGQlFjdwpBb1lXYUhSMGNEb3ZMM2d4TG1rdWJHVnVZM0l1YjNKbkx6QW5CZ05WSFI4RUlEQWVNQnlnR3FBWWhoWm9kSFJ3Ck9pOHZlREV1WXk1c1pXNWpjaTV2Y21jdk1DSUdBMVVkSUFRYk1Ca3dDQVlHWjRFTUFRSUJNQTBHQ3lzR0FRUUIKZ3Q4VEFRRUJNQTBHQ1NxR1NJYjNEUUVCQ3dVQUE0SUNBUUNGeWs1SFBxUDNoVVNGdk5WbmVMS1lZNjExVFI2VwpQVE5sY2xRdGdhRHF3KzM0SUw5ZnpMZHdBTGR1Ty9aZWxON2tJSittNzR1eUErZWl0Ulk4a2M2MDdUa0M1M3dsCmlrZm1aVzQvUnZUWjhNNlVLKzVVemhLOGpDZEx1TUdZTDZLdnpYR1JTZ2kzeUxnamV3UXRDUGtJVno2RDJRUXoKQ2tjaGVBbUNKOE1xeUp1NXpsenlaTWpBdm5uQVQ0NXRSQXhla3JzdTk0c1E0ZWdkUkNuYldTRHRZN2toK0JJbQpsSk5Yb0IxbEJNRUtJcTRRRFVPWG9SZ2ZmdURnaGplMVdyRzlNTCtIYmlzcS95Rk9Hd1hEOVJpWDhGNnN3Nlc0CmF2QXV2RHN6dWU1TDNzejg1SytFQzRZL3dGVkROdlpvNFRZWGFvNlowZitsUUtjMHQ4RFFZemsxT1hWdThycDIKeUpNQzZhbExiQmZPREFMWnZZSDduN2RvMUFabHM0STlkMVA0am5rRHJRb3hCM1VxUTloVmwzTEVLUTczeEYxTwp5SzVHaEREWDhvVmZHS0Y1dStkZWNJc0g0WWFUdzdtUDNHRnhKU3F2MyswbFVGSm9pNUxjNWRhMTQ5cDkwSWRzCmhDRXhyb0wxKzdtcnlJa1hQZUZNNVRnTzlyMHJ2WmFCRk92VjJ6MGdwMzVaMCtMNFdQbGJ1RWpOL2x4UEZpbisKSGxVanI4Z1JzSTNxZkpPUUZ5LzlyS0lKUjBZLzhPbXd0LzhvVFdneTFtZGVIbW1qazdqMW5Zc3ZDOUpTUTZadgpNbGRsVFRLQjN6aFRoVjErWFdZcDZyamQ1SlcxemJWV0VrTE54RTdHSlRoRVVHM3N6Z0JWR1A3cFNXVFVUc3FYCm5MUmJ3SE9vcTdoSHdnPT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
      - name: harbor-01-leaf-cert
        data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUZTVENDQkRHZ0F3SUJBZ0lTQkRORHRPaG5UUktwMGZ5YkdvM3Z0ekhqTUEwR0NTcUdTSWIzRFFFQkN3VUEKTURJeEN6QUpCZ05WQkFZVEFsVlRNUll3RkFZRFZRUUtFdzFNWlhRbmN5QkZibU55ZVhCME1Rc3dDUVlEVlFRRApFd0pTTXpBZUZ3MHlNakV3TWpZeE9UTTFOVE5hRncweU16QXhNalF4T1RNMU5USmFNQzB4S3pBcEJnTlZCQU1UCkltaGhjbUp2Y2kwd01TNW9NbTh0TkMweU1qQXVhREp2TG5adGQyRnlaUzVqYjIwd2dnRWlNQTBHQ1NxR1NJYjMKRFFFQkFRVUFBNElCRHdBd2dnRUtBb0lCQVFDaklrM1FJODFPelFOeTJpMmZScUR0dE5BTDVQSEtKbExaQm5sMwpIQTdlYzYwRjZOaHFZcnFNTWVTQklVVTRadTZvTDZ1SFM3Y1lpN0V4azcyTkFGZjZzM05jakh5cVNuL2pDZ1ZHCkxqaVlRRGQ4YUdxelBTM3RKY3o0YTZxdTdFZWhoZHIxQmVwbE5XUTFTM2hGYWNmWGZkZkJwcEl3SWZyL2lyQncKUUF5RFJ2eE52TXliWG9oZjBYdG1rZnJ3Rno2TEs1M094QzFrcDdJNTk1TTZrY3NpdHhlMldYZnM5aFg1VUZHaQo5RVNzVnlSdDZVRlRHZU9rdTNtbGhkektudHVTN2VsTnV4Vjh6Q0hLYzRMeE1jbFhEaFBTbm5LRlVPS2lKczVUCkl4WGV2N294MzNjaXlLejQrWGlHNzNOMTdqOWl1a0tTeUtsWWxEbld4dnhuT2ZLUEFnTUJBQUdqZ2dKY01JSUMKV0RBT0JnTlZIUThCQWY4RUJBTUNCYUF3SFFZRFZSMGxCQll3RkFZSUt3WUJCUVVIQXdFR0NDc0dBUVVGQndNQwpNQXdHQTFVZEV3RUIvd1FDTUFBd0hRWURWUjBPQkJZRUZBZkdNWG1semlTT3RJMklHdHRpSHJvVzBzZDBNQjhHCkExVWRJd1FZTUJhQUZCUXVzeGUzV0ZiTHJsQUpRT1lmcjUyTEZNTEdNRlVHQ0NzR0FRVUZCd0VCQkVrd1J6QWgKQmdnckJnRUZCUWN3QVlZVmFIUjBjRG92TDNJekxtOHViR1Z1WTNJdWIzSm5NQ0lHQ0NzR0FRVUZCekFDaGhabwpkSFJ3T2k4dmNqTXVhUzVzWlc1amNpNXZjbWN2TUMwR0ExVWRFUVFtTUNTQ0ltaGhjbUp2Y2kwd01TNW9NbTh0Ck5DMHlNakF1YURKdkxuWnRkMkZ5WlM1amIyMHdUQVlEVlIwZ0JFVXdRekFJQmdabmdRd0JBZ0V3TndZTEt3WUIKQkFHQzN4TUJBUUV3S0RBbUJnZ3JCZ0VGQlFjQ0FSWWFhSFIwY0RvdkwyTndjeTVzWlhSelpXNWpjbmx3ZEM1dgpjbWN3Z2dFREJnb3JCZ0VFQWRaNUFnUUNCSUgwQklIeEFPOEFkUUI2TW94VTJMY3R0aURxT09CU0h1bUVGbkF5CkU0Vk5POUlyd1RwWG8xTHJVZ0FBQVlRV0FqT25BQUFFQXdCR01FUUNJQWdCNnp0N1BEaGVlTFJjeEo4YVQzeTYKY0d4QW5rb3RjMXNDdVREQk42T3ZBaUIyWjRVR3IwcTBFd2pPK2JZU2VsM21Nc0NFRkhrRDJUZXhUWHR1dmpCNQpiZ0IyQU9nKzBObys5UVkxTXVkWEtMeUphOGtEMDh2UkVXdnM2Mm5oZDMxdEJyMXVBQUFCaEJZQ00zVUFBQVFECkFFY3dSUUlnS3JuOEQyWXA1UG1nVVdoamNYcEdnZ3kvK2FQcFNBR0dMWnRXZVhpdGFDTUNJUURRRFlJVTVkUGcKcmxTMy9rU0d1M1lHd1F4b2lCTHdadjRVZEs4WmFGWEdTVEFOQmdrcWhraUc5dzBCQVFzRkFBT0NBUUVBbnIzTQp4dVJKQi9oTmpQeDV0N1MzVDFQZE5MQThYdk5LMHhVekNEbkRKYmppQm9vOHRidCtqb21SZUIzWDBORFJUaVg3CnNRS1NCS2Q3MFJxUGRIL3VDUG5FdE5ONFhRd0wzbkpSN3gxWTNHMW81YWRmVVVRVURhT1VUYnhEVm1DNUF4a08KZVZabVlPL0pRT1dObGFPM2FIVW5xMUR1bFo0cFhKcFRFSVo3QktmUmdjQnlrT0ZRM0E2b2hzbklaQkNqVmJyVQpITFZKdWhZQ3RCMXB0dEY4R1FPcXA4cThkY1JiZHJFRDEyQTYxRUtFT2loWGp4cHQ0QnlFeGo2VkFTVlhrZEpmCjN4K3lkZVRqZEdRdTNQaXg0ZUVyYjhrNFNBby9JejJBdm1HVWFqT0RweWRsbkpRMG8zblFiUEVhVzN1S3BqRW4KcUgvMWRVWHJQbEFlbVIyUFBBPT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=


````



```SSH into Supervisor nodes```


[https://williamlam.com/2020/10/how-to-ssh-to-tanzu-kubernetes-grid-tkg-cluster-in-vsphere-with-tanzu.html](https://williamlam.com/2020/10/how-to-ssh-to-tanzu-kubernetes-grid-tkg-cluster-in-vsphere-with-tanzu.html)


##### Option 1

1. SSH into VCSA
2. /usr/lib/vmware-wcp/decryptK8Pwd.py
3. ssh as root@SUPER_VM_IP

```ssh into workload cluster nodes```

##### From the above you have access to the namespaces and secrets so run

````
kubectl get secrets -n MY_VSPHERE_NAMESPACE

kubectl -n MY_VSPHERE_NAMESPACE get secrets MY_CLUSTER_NAME-ssh-password -o jsonpath={.data.ssh-passwordkey} | base64 -d

````

##### Now you can ssh into any of the workload cluster nodes for that cluster with the user vmware-system-user and the password from above
