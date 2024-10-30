```Okay I have had soo much issue with this that I am creating a separate Recipe for it```


[https://computingforgeeks.com/extending-root-filesystem-using-lvm-linux/](https://computingforgeeks.com/extending-root-filesystem-using-lvm-linux/)

### So to extend the root LVM partition use the below and this will work on both CentOS and Ubuntu(should)

```CentOS```

````
sudo yum install -y cloud-utils-growpart
````

```Ubuntu```
````
sudo apt-get install -y cloud-guest-utils
````

### Great tool I will add this to my base templates and to m ansible playbook

````
fdisk -l

lsblk
````

### Note obviously you need to do the following steps after you've added space to the VM

#### after looking @ lsblk I can see that root partition is partition 2 i.e. I'm going to add
## space to sda2 that's where root and swap lives note sda1 is /boot

````
sudo growpart /dev/sda 2

sudo pvresize /dev/sda2

pvs
##both of these are for display purposes only
vgs

sudo lvextend /dev/mapper/centos-root /dev/sda2
````


### note the above /dev/mapper/centos-root you can see from df -h

````
xfs_growfs /

##or
resize2fs /dev/mapper/centos-root

df -h
````


#### Both the latest Ubuntu and CentOS moved to xfs so xfs_growfs is going to be your command going forward

#### This was tested on centOS 7.7.x


```mounting the finished product```


````
sudo mkdir /mnt/disk2-part1

sudo mount /dev/sdc1 /mnt/disk2-part1

sudo '/dev/sdc1   /mnt/disk2-part1  ext4   defaults    0   0' >> /etc/fstab (edit /etc/fstab file)

sudo reboot now


sudo blkid

sudo mkdir /datadrive

sudo mount /dev/sdc1 /datadrive

echo 'UUID=33333333-3b3b-3c3c-3d3d-3e3e3e3e3e3e   /datadrive   xfs   defaults,nofail   1   2' >> /etc/fstab  ##uuid comes from the above command

#or
echo 'UUID=33333333-3b3b-3c3c-3d3d-3e3e3e3e3e3e   /datadrive   ext4   defaults,nofail   1   2' >> /etc/fstab  ##uuid comes from the above command

lsblk -o NAME,HCTL,SIZE,MOUNTPOINT | grep -i "sd"

````

