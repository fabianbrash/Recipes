```Rook-ceph stuff here```



#### Create a NS called rook-ceph and install both the rook-ceph as well as the rook-ceph-cluster helm charts, note the order of operation is rook-ceph, then rook-ceph-cluster



````
kubectl apply -f https://raw.githubusercontent.com/rook/rook/master/deploy/examples/toolbox.yaml -n rook-ceph

kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- bash
````
