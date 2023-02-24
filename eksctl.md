#### eksctl commands

[docs](https://eksctl.io/usage/creating-and-managing-clusters/)


```Create a cluster```

````
eksctl create cluster --name my-cluster

eksctl create cluster --name fb-clust-2 --region=us-east-1 --zones=us-east-1a,us-east-1b,us-east-1d

````


```Create a cluster from yml```


````

apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: basic-cluster
  region: eu-north-1
  version: "1.23"

nodeGroups:
  - name: ng-1
    instanceType: m5.large
    desiredCapacity: 10
    volumeSize: 80
    ssh:
      allow: true # will use ~/.ssh/id_rsa.pub as the default ssh key
  - name: ng-2
    instanceType: m5.xlarge
    desiredCapacity: 2
    volumeSize: 100
    ssh:
      publicKeyPath: ~/.ssh/ec2_id_rsa.pub


````

````

apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: my-cluster
  region: us-east-1
  version: "1.23"

nodeGroups:
  - name: ng-1
    instanceType: m5.xlarge
    desiredCapacity: 4
    volumeSize: 100

````


## Note EKS has made some significant changes to how EKS clusters work, TLDR; everything now requires a IAM account/policy/role so the below YAML should give you all that you need to run your cluster in the way you are used to it running, i.e. you can have dynamic pv provisioning, again this might not be the most secure, productiom reaady way of doing things, but it gets err done.


````
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: fb-eks-cluster-1
  region: us-east-1
  version: "1.23"
#iam:
  #withOIDC: true

nodeGroups:
  - name: ng-1
    iam:
      withAddonPolicies:
        imageBuilder: true
        autoScaler: true
        externalDNS: true
        certManager: true
        appMesh: true
        ebs: true
        fsx: true
        efs: true
        albIngress: true
        xRay: true
        cloudWatch: true
    instanceType: m5.xlarge
    desiredCapacity: 4
    volumeSize: 100
addons:
- name: aws-ebs-csi-driver
  #version: 1.7.5 optional

````

````

eksctl create cluster -f cluster.yaml

````
