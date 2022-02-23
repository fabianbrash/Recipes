## Let's replace Docker with containerd

[Install containerd](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd)

[Install KubeADM](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)

##

### Load kernel modules
```
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter
```

##

### Setup required sysctl params, these persist across reboots.

```
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
```
### Apply sysctl params without reboot

```
sudo sysctl --system
```
##

#### Ubuntu 18.04/20.04

```Install containerd```

```
sudo apt-get update && sudo apt-get install -y containerd
```
### Configure containerd
```
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
```
### Restart containerd
```
sudo systemctl restart containerd
```
### Enable it if it isn't already
```
sudo systemctl enable containerd
```
##

### Note theirs information on the site about configuring cgroups let's see if we really need to do that... so far no!!

### Disable swap

```
sed -i '/swap/d' /etc/fstab
swapoff -a
```
### This is optional but if you want to use NFS in cluster it's mandatory also let's install a tool and check sestatus

```
sudo apt install -y nfs-common cloud-guest-utils policycoreutils && sudo sestatus
```

```prereqs```

````
sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl

````

````
##curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
##cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
##deb https://apt.kubernetes.io/ kubernetes-xenial main
##EOF
````

### Updated as of 02-18-2022 if you use the above you will get a warning about apt-key being deprecated so the below resolves that

````
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

````

### Let's see what versions are available

````
apt-cache madison kubeadm
````

### Install kubelet kubeadm kubectl on all nodes note if you want you can eliminate the kubectl install on the worker nodes

### And if you want you can also eliminate the kubelete install on the control plane nodes, note if you do that you won't see them with the kubectl get nodes command

````
sudo apt-get update && sudo apt-get install -y kubelet kubeadm kubectl && sudo apt-mark hold kubelet kubeadm kubectl
````

### Or we can install a specific version

````
sudo apt-get update && sudo apt-get install -y kubelet=1.20.0-00 kubeadm=1.20.0-00 kubectl=1.20.0-00 && sudo apt-mark hold kubelet kubeadm kubectl
````

### Let's make sure we don't update these randomly

````
sudo apt-mark hold kubelet kubeadm kubectl
````

##

```On the control-plane node```

````
sudo kubeadm init --apiserver-advertise-address xxx.xxx.xxx.xxx --pod-network-cidr=10.244.0.0/16 --kubernetes-version=v1.20.0

or

sudo kubeadm init --config=config.yaml
````

#### If you don't give a version we will get the latest patch of 1.20.0 and you'll have a mismatch when you run kubectl version --short note the below config file also specifies a version

```config.yaml```

````
apiVersion: kubeadm.k8s.io/v1beta1
kind: InitConfiguration
localAPIEndpoint:
  advertiseAddress: 192.168.1.220
  bindPort: 6443
---
apiVersion: kubeadm.k8s.io/v1beta1
kind: ClusterConfiguration
kubernetesVersion: v1.20.0
networking:
  podSubnet: 10.244.0.0/16
---
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
serverTLSBootstrap: true
````

##

### Now let's install Calico as our overlay/pod network
### Note I'm only installing the version for 50 nodes or less
```
curl https://docs.projectcalico.org/manifests/calico.yaml -O

kubectl apply -f calico.yaml
```
##
### I would recommend installing metrics-server next
[Metrics-Server(mine)](https://github.com/fabianbrash/YAML/blob/master/metrics-server-latest.yaml)
##

### The below is an explanation as to why metrics-server does not work out of the box with kubeadm and a remedy for it

[Make metrics-server work out of the box with kubeadm](https://particule.io/en/blog/kubeadm-metrics-server/)

#### The TL;DR is basically kubeadm uses a self-signed cert to sign the kubelet(and probably all components) and we need to have the kubelet cert signed by the k8s CA so it trusts the kubelet cert; or also we use a trusted cert from a public CA

### I will hopefully soon turn this into a bash script and then an ansible playbook

### Check a few things

````
sudo cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep image:

dpkg -l |grep -i kube

sudo kubeadm certs check-expiration #check when our certs expire
````

##

```Optional```

#### Install a SC

[Rancher - localStorage](https://github.com/rancher/local-path-provisioner)

##


```Upgrade our cluster```

#### First we start with our control plane node(s)

```Control Plane nodes```

````
kubectl drain controller-1 --ignore-daemonsets

## I will assume you have su -

apt-cache madison kubeadm ## Let's see what's out there for us

## We've chosen the latest build of 1.21, 1.21.10

kubeadm version

kubeadm upgrade plan

apt-mark unhold kubeadm && \
apt-get update && apt-get install -y kubeadm=1.21.10-00 && \
apt-mark hold kubeadm

kubeadm upgrade plan

kubeadm apply upgrade plan v1.21.10

## If that was successful then we need to upgrade kubelet and kubectl to match

apt-mark unhold kubelet kubectl && \
apt-get update && apt-get install -y kubelet=1.21.10-00 kubectl=1.21.10-00 && \
apt-mark hold kubelet kubectl

systemctl daemon-reload
systemctl restart kubelet

kubectl uncordon controller-1

````

```Worker nodes```

````
kubectl drain worker-1 --ignore-daemonsets

apt-mark unhold kubeadm && \
apt-get update && apt-get install -y kubeadm=1.21.10-00 && \
apt-mark hold kubeadm

kubeadm upgrade node

apt-mark unhold kubelet kubectl && \
apt-get update && apt-get install -y kubelet=1.21.10-00 kubectl=1.21.10-00 && \
apt-mark hold kubelet kubectl

systemctl daemon-reload
systemctl restart kubelet

kubectl uncordon worker-1

````

#### Rinse and repeat for all your worker node(s)
