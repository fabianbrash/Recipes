```Create ext4 partition```


````

sudo fdisk -l 
OR
sudo parted -l

sudo parted /dev/sdb

mklabel msdos
mkpart > primary > ext4 > 1 > 90000(this is how big the disk is here 90GB+)
print
quit

sudo mkfs.ext4 /dev/sdc1(this comes from fdisk -l or parted -l)

sudo e4label /dev/sdc1 disk2-part1 (e4label is not installed on ubuntu 22.04 so I need to find what provides this)

sudo mkdir /mnt/disk2-part1

sudo mount /dev/sdc1 /mnt/disk2-part1

sudo '/dev/sdc1   /mnt/disk2-part1  ext4   defaults    0   0' >> /etc/fstab (edit /etc/fstab file)

sudo reboot now

````

[https://www.tecmint.com/create-new-ext4-file-system-partition-in-linux/](https://www.tecmint.com/create-new-ext4-file-system-partition-in-linux/)


```ext4/xfs Azure VM```

[https://learn.microsoft.com/en-us/azure/virtual-machines/linux/attach-disk-portal](https://learn.microsoft.com/en-us/azure/virtual-machines/linux/attach-disk-portal)


##### Note when I did this my disk changed from sdc1 to sda1??

##### After reboot it now shows /dev/sdc1 as it should??? maybe I should have followed the aboec Azure article from the beginning and this would not have happened


````
sudo su -
lsblk
sudo parted /dev/sdc --script mklabel gpt mkpart xfspart xfs 0% 100%
lsblk
sudo mkfs.xfs /dev/sdc1
sudo partprobe /dev/sdc1

#or

sudo parted /dev/sdc --script mklabel msdos mkpart primary ext4 0% 100%
lsblk
sudo mkfs.ext4 /dev/sdc1
sudo partprobe /dev/sdc1

````

````

sudo blkid

sudo mkdir /datadrive

sudo mount /dev/sdc1 /datadrive

echo 'UUID=33333333-3b3b-3c3c-3d3d-3e3e3e3e3e3e   /datadrive   xfs   defaults,nofail   1   2' >> /etc/fstab  ##uuid comes from the above command

#or
echo 'UUID=33333333-3b3b-3c3c-3d3d-3e3e3e3e3e3e   /datadrive   ext4   defaults,nofail   1   2' >> /etc/fstab  ##uuid comes from the above command

lsblk -o NAME,HCTL,SIZE,MOUNTPOINT | grep -i "sd"

````
