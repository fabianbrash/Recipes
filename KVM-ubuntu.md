### Installing KVM on Ubuntu 21.10


```packages```

````
sudo apt install -y cpu-checker

sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst virt-manager

````


```commands```

````

kvm-ok  ## see if virtualization is available on or processor

sudo systemctl is-active libvirtd

sudo usermod -aG libvirt myuser

sudo usermod -aG kvm myuser

sudo reboot now
````



### After all this time, KVM is not viable as Broadcom has purchased VMware



```clean up install```


````
sudo virsh net-destroy default
sudo virsh net-undefine default

# Bring them down first
sudo ip link set br31 down
sudo ip link set br41 down

# Delete the bridges
sudo ip link delete br31 type bridge
sudo ip link delete br41 type bridge

# Delete the VLAN sub-interfaces
sudo ip link delete vlan31
sudo ip link delete vlan41

````


```useful virsh command```


````
virsh list
virsh console 1
virsh list --all
````
