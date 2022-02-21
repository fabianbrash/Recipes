### Installing KVM on Ubuntu 21.10


```packages```

````
sudo apt install cpu-checker

kvm-ok  ## see if virtualization is available on or processor

sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst virt-manager

````


```commands```

````
sudo systemctl is-active libvirtd

sudo usermod -aG libvirt myuser

sudo usermod -aG kvm myuser

sudo reboot now
````
