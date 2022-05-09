## TKGs info goes here


#### Deploy a cluster

[TKC YAML specs](https://docs.vmware.com/en/VMware-vSphere/7.0/vmware-vsphere-with-tanzu/GUID-B1034373-8C38-4FE2-9517-345BF7271A1E.html#GUID-B1034373-8C38-4FE2-9517-345BF7271A1E__section_kgn_h31_3pb)

[How to install vSphere with Tanzu with vSphere Networking](https://little-stuff.com/2020/10/07/how-to-install-vsphere-with-tanzu-with-vsphere-networking/)

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
