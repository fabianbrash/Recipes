#### eksctl commands

[docs](https://eksctl.io/usage/creating-and-managing-clusters/)


```Create a cluster```

````
eksctl create cluster --name my-cluster

````


```Create a cluster from yml```


````

apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: basic-cluster
  region: eu-north-1

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

nodeGroups:
  - name: ng-1
    instanceType: m5.large
    desiredCapacity: 5
    volumeSize: 100

````
