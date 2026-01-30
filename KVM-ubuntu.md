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

#### You might have to do some work on your interfaces


```Ubuntu 24.04```

#### Bring up an interface even if you will not configure an IP on it.


````
sudo ip link set ens192 up  ## TEMPORARY

````

````
sudo nano /etc/netplan/01-netcfg.yaml

OR

sudo nano /etc/netplan/50-cloud-init.yaml

````

````
network:
  version: 2
  renderer: networkd
  ethernets:
    ens160:
      dhcp4: true
    ens192:
      dhcp4: no
      dhcp6: no
      # This tells the system to bring the link up 
      # even without an IP configuration.

````

#### My config


````
network:
  version: 2
  ethernets:
    ens192:
      dhcp4: true
    ens160:
      addresses:
      - "192.168.99.17/24"
      nameservers:
        addresses:
        - 192.168.99.100
        search:
        - fbclouddemo.us
      routes:
      - to: "default"
        via: "192.168.99.1"

````

````
sudo netplan try

sudo netplan apply
````

