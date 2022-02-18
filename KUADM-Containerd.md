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

#### (Install containerd)
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

### Let's see what versions are available

````
apt-cache madison kubeadm
````

### Install kubelet, kubeadm, kubectl and deps etc..
```
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
```
```
sudo apt-get update && sudo apt-get install -y kubelet kubeadm kubectl && sudo apt-mark hold kubelet kubeadm kubectl
```
##

### On the control-plane node
```
kubeadm init --apiserver-advertise-address xxx.xxx.xxx.xxx --pod-network-cidr=10.244.0.0/16
```

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
### I will hopefully soon turn this into a bash script and then an ansible playbook
