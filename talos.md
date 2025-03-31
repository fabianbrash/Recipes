```Talos info goes here```

[https://www.talos.dev/v1.9/introduction/getting-started/](https://www.talos.dev/v1.9/introduction/getting-started/)


````
talosctl -n 192.168.0.2 get disks --insecure ##check to see what disk we need to install on defaults to /dev/sda
````

#### Generate our config files, note the IP is the IP of the control plane node

````
 talosctl gen config mycluster https://192.168.0.2:6443
````

#### To make life easy let's export the IP of our control plane node and our worker(s)

````
export CONTROL_PLANE_IP = 192.168.0.2
export WORKER_NODE_IP = 192.168.0.3
````

#### Let's bootstrap our control-plane

````
talosctl apply-config --insecure \
--nodes $CONTROL_PLANE_IP \
--file controlplane.yaml

````

#### Let's bootstrap our worker

````
talosctl apply-config --insecure \
--nodes $WORKER_NODE_IP \
--file worker.yaml
````

#### Bootstrap k8s

````
talosctl bootstrap --nodes $CONTROL_PLANE_IP --endpoints $CONTROL_PLANE_IP \
--talosconfig=./talosconfig

````

##### etc.

##### For example, to see the containers running on node 192.168.0.200, by routing the containers command through the control plane endpoint 192.168.0.2:

````
talosctl -e 192.168.0.2 -n 192.168.0.200 containers
````

##### To see the etcd logs on both nodes 192.168.0.10 and 192.168.0.11:

````
talosctl -e 192.168.0.2 -n 192.168.0.10,192.168.0.11 logs etcd
````
