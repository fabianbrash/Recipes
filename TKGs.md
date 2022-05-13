## TKGs info goes here


#### Deploy a cluster

[TKC YAML specs](https://docs.vmware.com/en/VMware-vSphere/7.0/vmware-vsphere-with-tanzu/GUID-B1034373-8C38-4FE2-9517-345BF7271A1E.html#GUID-B1034373-8C38-4FE2-9517-345BF7271A1E__section_kgn_h31_3pb)

[How to install vSphere with Tanzu with vSphere Networking](https://little-stuff.com/2020/10/07/how-to-install-vsphere-with-tanzu-with-vsphere-networking/)


[Network Topology](https://docs.vmware.com/en/VMware-vSphere/7.0/vmware-vsphere-with-tanzu/GUID-489A842E-1A74-4A94-BC7F-354BDB780751.html)


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