```Get all updates```

````
sudo apt-get update -y && sudo apt-get upgrade -y
##I usually install aptitude
sudo apt-get install aptitude -y
sudo aptitude upgrade
service --status-all
sudo systemctl status ssh(Same as RHEL/CentOS)

####Searching
sudo apt-cache search packagename
apt-cache search cockpit ##find all cockpit packages
sudo aptitude search all network | less
````

#### Let's find what package provides the killall utility
#### This did not work in a docker container of ubuntu
##### I need to test in a full blown ubuntu install

````
sudo apt-get update && apt-cache search killall

###Get info about package
sudo apt-cache show cockpit
apt-cache show cockpit
````

#### If you have dependency issues with dpkg or apt

````
sudo apt-get -f install
````

#### The above should find all dependencies and install them and then install your app


#### UPGRADE TO A NEW RELEASE ESPECIALLY IF YOU ARE NOT ON AN LTS VERSION

````
sudo do-release-upgrade
````

```Set root password```
````
sudo passwd
````

### set another user password

````
sudo passwd (if other user's are on the system it will ask for which user)
````

```INSTALL NMTUI/NETWORKMANAGER```

````
sudo aptitude install network-manager
sudo systemctl start NetworkManager && sudo systemctl enable NetworkManager
sudo nmtui
####once installed you need to head to backup and then edit /etc/network/interfaces
##And comment out the lines with 'iface' and 'auto'
###Because ubuntu's network-manager will still be managing those devices you can check with the below command
sudo nmcli d 'you will see unmanaged'
##then restart the system
sudo reboot
##Then Active the interface
sudo nmtui
##Then select activate interface and select your adapter
###Add your network info and then reboot
sudo reboot
###You should now see the IP that you configured
````

###### NOTE NMTUI GAVE ME A TON OF ISSUES ON UBUNTU SO I REMOVED IT AND JUST DID IT THROUGH THE CONFIG

````
sudo systemctl stop NetworkManager
sudo apt remove network-manager
###Then reverse the changes we made /etc/network/interfaces
sudo reboot
###Then re-edit /etc/network/interfaces
````
```Actual File```

#### This file describes the network interfaces available on your system and how to activate them. For more information, see interfaces(5).

````
source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto enp3s0
#iface enp3s0 inet dhcp
iface enp3s0 inet static
	address 192.168.1.100
	network 255.255.255.0
	gateway 192.168.1.254

dns-nameservers 8.8.8.8
````
```END File contents```

##### There is a bug in 16.04 so a reboot is required

````
sudo reboot
````

```INSTALL .deb packages```
````
sudo dpkg -i package_1_1.deb
###remove
sudo dpkg --remove webmin #or whatever package
sudo dpkg --purge webmin #or whatever package

###UPGRADE PACKAGE#####
sudo dpkg -i package_1.2.deb

sudo dpkg -l | grep 'app looking for'
sudo dpkg -l | grep plex
````

[https://help.ubuntu.com/community/UFW](https://help.ubuntu.com/community/UFW)

````
###ubuntu uses ufw
sudo ufw status
sudo ufw enable
sudo ufw status verbose
sudo ufw show raw
##Lets allow ssh from any device#########
sudo ufw allow 22/tcp or sudo ufw allow ssh
####Let's deny a port
sudo ufw deny 53/tcp

###Delete an existing rule
ufw deny 80/tcp
sudo ufw delete deny 80/tcp

sudo ufw allow from 192.168.1.25/32 to any port 22 proto tcp(only allow that IP to access port 22)
````


```Alternatively```

````
sudo ufw deny from 207.46.232.182
sudo ufw deny from 192.168.0.1 to any port 22

sudo ufw deny from 192.168.0.1 to any port 22
sudo ufw deny from 192.168.0.7 to any port 22
sudo ufw allow from 192.168.0.0/24 to any port 22 proto tcp
````

````
######CPU INFO##########################################
cat /proc/cpuinfo


#######MEMORY INFO###################################
cat /proc/meminfo


####FOLDER SIZE INFO######
###got to the folder location you want to gather size information on and then run
sudo du -sh * | sort -n
###Or you can 
sudo du -h


###################UBUNTU MOTD#################################
cd /run
cat motd.dynamic
````


```INSTALL DOCKER```

````
####Install the AUFS storage driver
sudo apt install linux-image-extra-$(uname -r) linux-image-extra-virtual

####Install official REPOS###########################
sudo apt install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
    
 ####ADD Dockers' KEYS#########################
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
 
 ####ADD stable repo###################
 sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
   
#####ADD edge repo###############
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   edge"
   
##Then run###
sudo apt update or sudo apt-get update
###Then run (optional)
sudo apt list --upgradeable (see all available updates) 

 #####See available versions##########################
 apt-cache madison docker-ce
 
 ###Install specific versions
 sudo apt-get install docker-ce=<VERSION>
 
 #########Example##################
 sudo apt install docker-ce=17.03.1~ce-0~ubuntu-xenial
 
 ###Install Docker Compose############################
 ##First su to root
 su -
 sudo curl -L https://github.com/docker/compose/releases/download/1.12.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
````

```INSTALL WEBMIN```

````
##Let's download it first
curl -O -L http://prdownloads.sourceforge.net/webadmin/webmin_1.831_all.deb
sudo apt install -f /path-to-webmin/webmin_1.831_all_deb (-f will get all dependencies required)

###IF ufw is running you need to open port 10000
sudo ufw allow 10000/tcp
````

```/boot runs out of space```

````
###First check to see how much free space is available @ /boot
df -h
####If you are @ 100% then you will have to manually remove some files########
cd /boot

###and remove the matching peers(DO NOT DELETE ALL VERSIONS LEAVE A FEW)
sudo rm abi-4.8.0-53-generic && sudo rm config-4.8.0-53-generic && sudo rm initrd.img-4.8.0-53-generic && sudo rm System.map-4.8.0-53-generic && sudo rm vmlinuz-4.8.0-53-generic
##Do the above for a few version 4.8.0-55(like that) until and then check /boot again
df -h
##then you can run either
sudo apt-get -f install or sudo apt-get autoremove(this will remove old kernels and free up space)
###OR
sudo apt autoremove(same as above)

##after that you should now be able to update your system
###you can also @ install time manually create your partitions and create a larger /boot partition

###To see all your kernels#####
sudo dpkg -l | grep linux-image or dpkg -l linux-image-\* | grep ^ii
##See linux headers
sudo dpkg -l | grep linux-headers
````

```FLUSH DNS UBUNTU 17.X MIGHT WORK ON 16.X AS WELL```

````
sudo systemd-resolve --flush-caches
##or
sudo systemctl restart systemd-resolved
````

```EXTEND A VM STORAGE THAT SITS ON LVM```

### So the first part I am going to cheat download GParted live CD and format your new extent with lvm pv then boot back into your ubuntu/debian vm(or any other distro that uses LVM)

#### Then get some information

````
sudo pvdisplay
sudo vgdisplay
sudo lvs
````

#### Then first let's extend the volume group(VG for short)

````
sudo vgextend ubuntu-srv-vg /dev/sda3 (Or whatever your new extent is you should see this from pvdisplay)
````

#### Now second let's extend the logical volume(LV which you get from sudo lvs)

````
sudo lvextend /dev/ubuntu-srv-vg/root /dev/sda3
````

### Now third let's resize our filesystem

````
sudo resize2fs /dev/ubuntu-srv-vg/root 
sudo xfs_growfs /dev/centos/root  ##for centos machines tested on centos 7.7
sudo xfs_growfs /  
````

#### Note a received an error with the above on centos 8.1(assume 8.0 also) so I had to use the above

[https://serverfault.com/questions/972385/xfs-growfs-is-not-a-mounted-xfs-filesystem-when-trying-to-grow-ol-root](https://serverfault.com/questions/972385/xfs-growfs-is-not-a-mounted-xfs-filesystem-when-trying-to-grow-ol-root)

#### And that should work
#### You can also use lvextend to just add some not all space to the logical volume

````
sudo lvextend -L8G(Check the docs)
````

[https://unix.stackexchange.com/questions/284424/increasing-a-volume](https://unix.stackexchange.com/questions/284424/increasing-a-volume)

[https://www.howtogeek.com/howto/40702/how-to-manage-and-use-lvm-logical-volume-management-in-ubuntu/](https://www.howtogeek.com/howto/40702/how-to-manage-and-use-lvm-logical-volume-management-in-ubuntu/)

## IF THE FILE SYSTEM IS NOT LVM THEN YOU CAN USE GPARTED

[https://www.youtube.com/watch?v=cDgUwWkvuIY](https://www.youtube.com/watch?v=cDgUwWkvuIY)

```EXTEND PARTITION GPARTED```

````
#boot into gparted
##if swap is on turn it off
##then extend the 'extended partition to fill up new space'
##then 'resize/move' the swap partition to the end
##then click on 'extended' and resize it to the end
##then click on your root partition and resize it
````

```More disk expansion goodness```

#### So even after using gparted to extend the logical volume you night still not see the storage when you run df -h this will resolve that

````
df -h

sudo vgdisplay # We are looking for Alloc PE/Size vs Free PE/Size, mine showed Free  PE / Size       27577 / 107.72 GiB

````

#### From the above we can see that over 100 GB has not been added to the logical volume, so let's fix that

````
sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv #the /dev/ubuntu.. comes from sudo lvdisplay

sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv # the /dev/mapper/.. comes from just running df -h

````

### So I've figured out why I had to do the above on 1 of my ubuntu 22.04 instance, it's the type of partition I guess how this would be considered, what I mean is the above had to done on an instance that uses LVM, but on the instance that did not use LVM gparted can do everything for you, so when I extended the partition in gparted and rebooted the machine and ran df -h, everything looked good

```non-lvm instance```

````
/dev/sda1       124G   14G  111G  12% /
````

```lvm instance```

````
/dev/mapper/ubuntu--vg-ubuntu--lv  121G   12G  105G  10% /

````

#### The non lvm instance was actually downloaded directly from Ubuntu's repos

[https://cloud-images.ubuntu.com/jammy/current/](https://cloud-images.ubuntu.com/jammy/current/)

#### So is lvm not a good idea for server OS's and only good for the desktop flavor of Ubuntu??

#### Everything should not be good and when you run df -h again you should now the new capacity, so gparted got us some of the just to the entire way

[How to Extend Logical Volumes on Ubuntu Server](https://www.makeuseof.com/extend-logical-volumes-lvm-ubuntu-server/)

```MOUNT NFS```
````
sudo apt install nfs-common
su -
mkdir /mynfs
mount -t nfs serverIPorDNS:/mntpoint /mynfs
````

```MOUNT SMB SHARE```

````
sudo apt install cifs-utils
#1. If your'e joined to a domain create a domain service account(smbtest)
#2. Give Everyone full control for share access and then give the service account Modify or Full for NTFS
#3. Now on linux
#4. Make a directory for our mount point
sudo /localmntpoint
````

## Add a user with UID of 5000

````
sudo useradd smbtest -u 5000
sudo useradd smbtest -m ## Add user and create home directory
##Now create a group to add users to that will have access to
sudo groupadd -g 6000 sharegroup
##Now add all users that will have access to the share to that group
sudo usermod -G sharegroup -a smbtest && sudo usermod -G sharegroup -a user2
##Now your ready to mount
sudo mount.cifs \\\\server_DNS_OR_IP\\share /localmntpoint -o user=smbtest,uid=5000,gid=6000,domain=yourdomain
####NOTE THE DOMAIN IS VERY VERY IMPORTANT OR IT WILL FAIL, FOR ME THAT IS###########################
####NOTE FOR PERMISSIONS TO PROPAGATE PROPERLY MAKE CERTAIN THE USER ON WINDOWS MACHINE HAS A MATCHING ACCOUNT
####ON THE LINUX SYSTEM OR YOU WILL HAVE PERMISSION ISSUES##############
````

```MOUNT USB DRIVE```

````
sudo /mnt/USB ##create a mount point
sudo fdisk -l ##find your device
##mount it
sudo mount /dev/sdb1 /mnt/USB

###unmount it#########
sudo umount /dev/sdb1
or
sudo umount /mnt/USB
````

#### PACKAGES WITH MULTIPLE .DEB FILES

#### I ran into an isssue while attempting to install LibreOffice6, it came with a ton of .deb files
#### So I didn't know which one to start with, after reading the docs I found out you can do this.

````
cd /directorywithdebs
sudo dpkg -i *.deb

##Simple
````

```ADD A NEW ROOT CA ON UBUNTU```


#### First let's make a directory for our root CA(s)
### NOTE THIS WAS DONE USING UBUNTU 17.10

````
sudo mkdir /usr/share/ca-certificates/extra ###extra being the name of our new folder
##Shouldn't the above be ??
suod mkdir -p /usr/share/ca-certificates/extra
sudo cp /certs/my.crt /usr/share/ca-certificates/extra
sudo dpkg-reconfigure ca-certificates ##Follow prompts to add your new root CA
````

### NOTE: EVEN AFTER YOU'VE DONE THIS YOU WILL STILL HAVE TO ADD THE CERT(S) TO FIREFOX AND CHROME

```UPDATE SELECT PACKAGES```

#### So I had an interesting thing to happen I'm using a flavor of ubuntu called Pop_OS from System76, usually I just run sudo apt update and then sudo apt ugrade -y but this time I kept getting an error in regards

#### To to libfreerdp so the system wouldn't just skip over that and install the rest of the packages.  So I needed to upgrade/install specific packages.

````
sudo apt install packagename

##For me I just ran apt list --upgradable and then select the packages I wanted to upgrade/install
sudo apt install pop-shop -y ##This will upgrade to the latest version also
sudo apt install -y pop-shop && sudo apt install -y udev ##this works also
````


```FIND PORTS THAT ARE BEING LISTENED ON```

### THIS WOULD BE EASIER IF EVERYTHING WAS CONTAINERIZED

````
sudo netstat -tulpn | grep LISTEN
sudo lsof -i -P -n | grep LISTEN
````

```EXPORT PATH ZSH```

````
export PATH=/home/david/pear/bin:$PATH
````

```Check SHA256 of a file```

````
sha256sum /dir/file/iso
````


```Add a user```

````
sudo adduser user ###Instead of useradd this is more user friendly it will create a home directory for you
````


```INSTALL DOCKER UBUNTU 18.04 LTS```

````
###NOTE DO NOT FOLLOW MY ABOVE INSTALL METHOD OR DOCKERS'
sudo apt-get install -y docker.io  ##should be the latest stable build####
````


```Add folder to your $PATH zsh```
````
vim ~user/.zshrc

###Add
export PATH=/usr/local/go/bin:$PATH
##Here we are adding go to our PATH
##Then simply launch another terminal window and the changes so show up
echo $PATH

###On BASH something like this should work
export PATH=/usr/local/go/bin:$PATH
````

#### I need to check to see if the above would be permanent or like zsh there is a file we need to edit

```Using find```

````
cd /
sudo find . -name "*.go" ##find all golang files on the system
sudo find . -name "go"   ##find anyting with go on the system
````

#### quick note I added a user to the docker group and when I logged off and back on again I still couldn't run docker commands so I found this

[https://stackoverflow.com/questions/48568172/docker-sock-permission-denied](https://stackoverflow.com/questions/48568172/docker-sock-permission-denied)

````
newgrp docker

##Also you can do this
usermod -aG docker username
systemctl restart docker
````

```check sha256sum```

````
sha256sum ubuntu-9.10-dvd-i386.iso
````

```ubuntu 16.04 more networking issues```

#### so I edited /etc/network/interface and I had to add the below

````
10.0.0.20/24
255.255.255.0
##if you just added the subnet mask it wrongly assumed the network is a /8 why
##when the subnet says its a /24
````

```cgroups note everything below should work on most all distros```

[https://www.linuxjournal.com/content/everything-you-need-know-about-linux-containers-part-i-linux-control-groups-and-process](https://www.linuxjournal.com/content/everything-you-need-know-about-linux-containers-part-i-linux-control-groups-and-process)

````
cd /sys/fs/cgroup
````

```NETPLAN Ubuntu 18.04/19.04```

[https://raw.githubusercontent.com/fabianbrash/YAML/master/01-netcfg.yaml](https://raw.githubusercontent.com/fabianbrash/YAML/master/01-netcfg.yaml)

[https://computingforgeeks.com/how-to-configure-static-ip-address-on-ubuntu/](https://computingforgeeks.com/how-to-configure-static-ip-address-on-ubuntu/)

#### netplan is the new way of confguring IP's on ubuntu systems

````
cd /etc/netplan
sudo vim 01-netcfg.yaml
##make changes as per references
sudo netplan apply
````

```Down an interface tested on ubuntu 18.04```

````
ifconfig

ip link set s1(or whatever interface you want down) down
````

```searching for what provides a package```

#### this only works if the package is installed on your system

````
sudo dpkg -S which ping
sudo dpkg -S which nslookup
````

#### this is useful if you are using a docker image which has most packages removed and you need to add some back


### So I ran into an issue when installing cerbot with snap on Ubuntu 20.04, the issue occured when I tried to install the route-53 dns plugin with pip3 it found a conflict and tried to install an older version of acme and certbot, so deleted the snap version but when I tried to delete the versions that pip had installed I received this odd error message


````/usr/lib/python3/dist-packages, outside environment /usr
````

#### So I did a little Googling and found this
[https://askubuntu.com/questions/926911/unable-to-uninstall-programs-using-sudo-pip](https://askubuntu.com/questions/926911/unable-to-uninstall-programs-using-sudo-pip)

##### So run

````
sudo dpkg -S certbot
````

#### returned aa bunch of entries for python3-certbot so then

````
sudo apt remove python3-certbot -y
##then I did the same for acme
sudo dpkg -S acme
##returned
python3-acme
## so 
sudo apt remove python3-acme -y

sudo pip3 list

##the above should no show both acme and certbot is gone

sudo pip3 list --outdated  ## list all outdated packages
````

#### Once all this done I re-installed certbot with apt instead of snap then you will need to upgrade

````
sudo pip3 install --upgrade certbot
````

```USING hostnamectl```

[https://www.cyberciti.biz/faq/rhel-redhat-centos-7-change-hostname-command/](https://www.cyberciti.biz/faq/rhel-redhat-centos-7-change-hostname-command/)

### Please note all above commands require NetworkManager to be installed, which should be the default for centos installs

````
hostnamectl status # list current host name
hostnamectl set-hostname newhstname --static ##set new hostname
sudo systemctl restart systemd-hostnamed  ##Restart service
````

```Give user sudo rights```

[https://www.digitalocean.com/community/tutorials/how-to-create-a-new-sudo-enabled-user-on-ubuntu-18-04-quickstart] (https://www.digitalocean.com/community/tutorials/how-to-create-a-new-sudo-enabled-user-on-ubuntu-18-04-quickstart)

````
usermod -aG sudo sammy
````


```SETTING AND USING ENV VARS```

#### set a var to some value

````
GIT_TAG=v0.7.6
````
##Let's see it
echo $GIT_TAG

##Now let's use that var with a command note the use if the curlies
git tag ${GIT_TAG}

###And now we can use this in a bash script
#/bin/bash
git tag ${GIT_TAG}

etc...
etc...

#Note for this to work you have either export the variable or source it when you run the script i.e.

. ./myscript.sh ##Note the period and then the space this will run the script under the current shell which has access to the non-exported env variables.


####Flush DNS#####
sudo systemd-resolve --flush-caches


##### cat,more,less, grep .gz files ######
##REF:https://www.cyberciti.biz/faq/unix-linux-cat-gz-file-command/

zcat resume.txt.gz

zmore access_log_1.gz

zless access_log_1.gz

zgrep '1.2.3.4' access_log_1.gz



###Shred 

##Shred the file forcefully and also remove it

shred -f -u myfile.txt



##GPG
##Note this is the simpliest way to use GPG please read up on how to do this properly

gpg -c myfile.txt ## You will be prompted for a passphrase

gpg -d myfile.txt.gpg  ## This will decrypt the file and display contents to stdout

gpg myfile.txt.gpg     ##This will create a decrypted file on the filesystem


###Find spaces in a file when you need tabs
##REF:https://unix.stackexchange.com/questions/125757/make-complains-missing-separator-did-you-mean-tab

vim Makefile

:%s/^[ ]\+/^I/

##You should then see '^I' delete all of them and then re-save the file, then start using tabs

### List all services

systemctl list-units --type=service
systemctl --type=service

## Install desktop/gui on a server
#REF: https://phoenixnap.com/kb/how-to-install-a-gui-on-ubuntu

sudo apt-get install tasksel -y

sudo apt-get install slim -y

## or

sudo apt-get install lightdm -y

## You just need 1 from the above

tasksel ## pick desktop environment

## or

sudo tasksel install ubuntu-mate-core

## You might have to do this

sudo service slim start

## Or
sudo service lightdm start

## All depending on which 1 you installed


sudo tasksel install lubuntu-core


sudo tasksel install xubuntu-core



## See how many active connections are on port 2379
## REF: https://serverfault.com/questions/421310/check-the-number-of-active-connections-on-port-80

netstat -anp | grep -i 2379 | grep ESTABLISHED | wc -l


## Fix broken deps you don't want to install
## REF:https://www.makeuseof.com/how-to-find-and-fix-broken-packages-on-linux/

````
sudo apt --fix-missing update

sudo apt update

sudo apt install -f

sudo apt clean


## echo out to /etc/hosts using tee

echo '192.168.56.32  node-2' | sudo tee -a /etc/hosts
````



#### Add to path

````

echo $PATH > ~/path.current   # back things up first

nano ~/.bashrc

export PATH="$HOME/bin:$PATH"  # Add to the end of the file; not here we are adding our folder to the beginning we can also do this

export PATH="$PATH:$HOME/bin" # Add to the end of the path

````

### See what ports are listening, lsof was installed even on photonOS

[cyberciti-check ports](https://www.cyberciti.biz/faq/unix-linux-check-if-port-is-in-use-command/)

````
lsof -i -P -n | grep -i listen

````

```ufw Nginx```


````
sudo ufw app list

sudo ufw allow 'Nginx Full'

sudo ufw status
````

[https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-22-04](https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-22-04)


```Extend LVM```

[https://askubuntu.com/questions/498709/how-can-i-resize-an-active-lvm-partition](https://askubuntu.com/questions/498709/how-can-i-resize-an-active-lvm-partition)


#### I'm making an assumption that you have downloaded Gparted Live and you've already extended the partition and rebooted the system


````
df -h  #take note of the name of /

sudo pvs

sudo lvs

sudo pvdisplay -m

sudo lvresize ubuntu-vg/ubuntu-lv -L +35g  #From the info you get from pvdisplay -m under Physical Segments - Logical volume note we don't need the /dev part, we are adding 35GB

sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv  # again we can see the name from the df -h command

````


```pci/gpu work```

##### list all pci devices

````
sudo lspci

sudo lshw -numeric -C display

sudo lspci -vnn | grep VGA
````

````
sudo apt search nvidia-driver

sudo apt install -y ubuntu-drivers-common

ubuntu-drivers devices

ubuntu-drivers list --gpgpu

sudo ubuntu-drivers autoinstall
````

```tar```

##### untar .bz2

````
tar -xvjf rctl-linux-amd64.tar.bz2
````

