### Installing etcd on a single host please ref to docs for setting up a cluster

````
curl -L -O https://github.com/coreos/etcd/releases/download/v3.3.0-rc.4/etcd-v3.3.0-rc.4-linux-amd64.tar.gz

tar -xzvf etcd-v3.3.0-rc.4-linux-amd64.tar.gz
cd etcd-v3.3.0-rc.4-linux-amd64
export ETCDCTL_API=3 ##Do not run with sudu
sudo ./etcd
````


### From another shell on the same system

````
cd etcd-v3.3.0-rc.4-linux-amd64
./etcdctl put foo bar
##Should return OK
./etcdctl get foo ##Again no sudo
````
