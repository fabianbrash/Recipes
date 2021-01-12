## Let's replace Docker with containerd

[Install containerd](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd)

[Install KubeADM](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)

```
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter
```

