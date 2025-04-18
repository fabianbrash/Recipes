```Talos info goes here```

[https://www.talos.dev/v1.9/introduction/getting-started/](https://www.talos.dev/v1.9/introduction/getting-started/)

[Talos Image Factory](https://factory.talos.dev/)

#### The team also has a project called Omni, have a look 

[Omni](https://www.siderolabs.com/platform/saas-for-kubernetes/)



````
talosctl -n 192.168.0.2 get disks --insecure ##check to see what disk we need to install on defaults to /dev/sda

talosctl -n 192.168.181.99 -e 192.168.181.99 get disks --talosconfig ./talosconfig
````

#### Generate our config files, note the IP is the IP of the control plane node

````
 talosctl gen config mycluster https://192.168.0.2:6443
````

#### To make life easy let's export the IP of our control plane node and our worker(s)

````
export CONTROL_PLANE_IP="192.168.0.2"
export WORKER_NODE_IP="192.168.0.3"
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

talosctl logs -f -n $CONTROL_PLANE_IP -e $CONTROL_PLANE_IP --talosconfig ./talosconfig etcd
````

##### After a few moments, you will be able to download your Kubernetes client configuration and get started:

````
talosctl kubeconfig --nodes $CONTROL_PLANE_IP --endpoints $CONTROL_PLANE_IP \
--talosconfig=./talosconfig
````

##### If you would prefer the configuration to not be merged into your default Kubernetes configuration file, pass in a filename:

````
talosctl kubeconfig alternative-kubeconfig --nodes $CONTROL_PLANE_IP --endpoints $CONTROL_PLANE_IP \
--talosconfig=./talosconfig
````

##### Get dashboard

````
talosctl dashboard -n $CONTROL_PLANE_IP -e $CONTROL_PLANE_IP --talosconfig ./talosconfig
````

##### Get services

````
talosctl -n $CONTROL_PLANE_IP -e $CONTROL_PLANE_IP --talosconfig ./talosconfig services
````

### I can also patch my file like this, an examole would be I need to make the control-plane schedulable

````
talosctl apply-config \
--nodes $CONTROL_PLANE_IP -e $CONTROL_PLANE_IP \
--talosconfig ./talosconfig \
--file controlplane.yaml
````
