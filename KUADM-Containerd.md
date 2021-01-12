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
