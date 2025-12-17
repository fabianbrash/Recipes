```Rook-ceph stuff here```



#### Create a NS called rook-ceph and install both the rook-ceph as well as the rook-ceph-cluster helm charts, note the order of operation is rook-ceph, then rook-ceph-cluster



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

````
