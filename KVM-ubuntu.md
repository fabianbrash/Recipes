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
