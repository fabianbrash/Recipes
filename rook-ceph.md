```Rook-ceph stuff here```



#### Create a NS called rook-ceph and install both the rook-ceph as well as the rook-ceph-cluster helm charts, note the order of operation is rook-ceph, then rook-ceph-cluster

##### Sample values.yaml file

````
operatorNamespace: rook-ceph

cephClusterSpec:
  cephVersion:
    image: quay.io/ceph/ceph:v18.2.1
  
  # Dashboard must be at the same indentation level as cephVersion
  dashboard:
    enabled: true
    ssl: false

  placement:
    all:
      nodeAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
          nodeSelectorTerms:
            - matchExpressions:
                - key: storage-node
                  operator: In
                  values:
                    - "true"

  storage:
    useAllNodes: true
    useAllDevices: true

````

#### In the above example we are enabling the dashboard UI so to access it we need to

````
kubectl -n rook-ceph port-forward svc/rook-ceph-mgr-dashboard 8443:7000

kubectl -n rook-ceph get secret rook-ceph-dashboard-password -o jsonpath="{['data']['password']}" | base64 --decode && echo  ## Get the password, username by default is 'admin'

````

#### Once you've installed both helm charts


````

kubectl -n rook-ceph get pods -l app=rook-ceph-osd

kubectl -n rook-ceph get cephcluster -o jsonpath='{.items[0].status.ceph.capacity}'

kubectl -n rook-ceph logs -l app=rook-discover

kubectl -n rook-ceph exec $(kubectl -n rook-ceph get pod -l app=rook-ceph-operator -o name) -- ceph status

````

#### On a node you can validate with

````
sudo blkid /dev/sdb

````


##### Also from Ai


````

That is a very sharp observation! What you are seeing is actually the difference between old Ceph (Filestore) and modern Ceph (Bluestore).

Why you don't see partitions

In older versions of Ceph or certain installation tools, Ceph would create a partition table (GPT) and a small partition for the journal or metadata, which is why you saw /dev/sdb1.

However, the modern Rook-Ceph uses Bluestore. Bluestore is designed to be a "raw" storage backend. It consumes the entire raw block device directly without a traditional Linux partition table or filesystem (like XFS or Ext4) underneath it.

````

````
kubectl apply -f https://raw.githubusercontent.com/rook/rook/master/deploy/examples/toolbox.yaml -n rook-ceph

kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- bash

````


### Once you've execed into the pod you can run a few smoke tests



````

ceph status – View cluster health.

ceph osd status – See the health and latency of individual disks.

ceph df – View detailed breakdown of used vs. available space.

ceph osd device ls

ceph osd df

````
