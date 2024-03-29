


[Github source](https://vmware.github.io/photon/)

```Start Docker```

````
systemctl start docker
systemctl enable docker
````


```Setup networking```

````
cd /etc/systemd/network
####Copy the existing file and create a new one using the static moniker
cp 10-dhcp-en.network 10-static-en.network
````


```Example File```

````
[Network]
Address=192.168.79.134/24
Gateway=192.168.79.2
DNS=8.8.8.8
Domains=photon.local
#####################################################################
########Add  your IP and remember afterword to rename the DHCP file################
mv 10-dhcp-en.network 10-dhcp-en.network.OLD
####chmod file#########
chmod 644 10-static-en.network
````


```Restart network```

````
systemctl restart systemd-networkd
````


```List network/adapter info```

````
networkctl
networkctl status eth0
````


```Allow root to ssh```

````
vim /etc/ssh/sshd_config (Find in the file PermitRootLogin and change to yes)
systemctl restart sshd
````

```FIREWALL```


##### photonOS uses iptables for it's firewall and it's on by default

````
systemctl status iptables
````

```PHOTONOS PERMISSION ISSUES```

##### Deploying a gitlab container on photonOS I had to chmod 0777 /Data in order for docker to have the rights to right to the path


```VERSION 2.0 CHANGES```


#### the 99-dhcp file that's generated will regenerate so make certain to set DHCP=no
#### also make certain your new file is 10-static... not 99-static...


```TDNF```

````
tdnf repolist            ##List all repos
tdnf clean all           ##clear all cache
tdnf check-update        ##check for updates
tdnf -y install gcc      ##install/update gcc only
tdnf distro-sync         ##synchronizes the machine's RPMs with the latest version of all the packages in the repository.
tdnf updateinfo info     ##Get info about updates that are available
````


```EXTEND ROOT PARTITION```

````
###Add additional space to the vmdk via GUI
tdnf install -y parted
````


##### Rescan device to see new space withour rebooting

````
echo 1 > /sys/class/block/sda/device/rescan

fdisk -l ##List all devices
####We are going to be working with /dev/sdb

parted /dev/sdb
````


#### If you get a message about the device not using all the space type "Fix"

````
print  ###To list the partition we will be extending the filesystem usually '2'

resizepart 2 100% ##Note this is for the root partition without the 100% is for second volume here /dev/sdb
Yes
38000 ###here we are making the disk size 38GB
quit

resize2fs /dev/sdb2

df -h
````


[https://myfabrix.com/community/tech-notes/photonos-expanding-disk-partition/](https://myfabrix.com/community/tech-notes/photonos-expanding-disk-partition/)

[https://www.tecmint.com/parted-command-to-create-resize-rescue-linux-disk-partitions/](https://www.tecmint.com/parted-command-to-create-resize-rescue-linux-disk-partitions/)

### Note in the first REF he uses the command 'resizepart 2 100%' that will generate an error


```Photon OS 1.x /root partition full```

##### Ran into an issue today in which our gitlab server running in a docker container using 
##### VMware's photonOS 1.x ran our of disk space on the /root partition by default this partition
##### is only ~15GB; while the container was still running and I could log into gitlab
##### I couldn't clone any repos.  The solution, simply add space to the disk in vCenter
##### and boot the Vm into GParted live an extend /dev/sda1 in my case, reboot, and all was good
##### Thank goodness for GParted Live


```ROOT PARTITION```


[https://unix.stackexchange.com/questions/358326/increase-root-size](https://unix.stackexchange.com/questions/358326/increase-root-size)

##### Add the space to the disk in vCenter or the web client

````
##Rescan device to see new space withour rebooting
echo 1 > /sys/class/block/sda/device/rescan

fdisk -l  ##You should see the newly added space

parted /dev/sda  ##this was the root parition for me

print

print free  ##this will show you you're free space pay attention to the "End" in my case 48.3GB

resizepart 2 100%  ##note the 100% threw an error just ignore it

##make the "End" what you saw from before my case 48.3GB you can use less of course

quit

resize2fs /dev/sda2  ##Again this will be unique to your environment

##This also assumes you are not using LVM

df -h
````

```SLOW BOOT TIMES FOR PHOTON OS 2.0```

[https://github.com/vmware/photon/issues/774](https://github.com/vmware/photon/issues/774)

````
## as root
systemd-analzye ## this will tell us what caused the long boot time
````

```ISSUES WITH CORPORATE NETWORKS```

[https://serverfault.com/questions/642981/docker-containers-cant-resolve-dns-on-ubuntu-14-04-desktop-host](https://serverfault.com/questions/642981/docker-containers-cant-resolve-dns-on-ubuntu-14-04-desktop-host)

[https://github.com/vmware/photon/issues/592](https://github.com/vmware/photon/issues/592)

##### The first issue is getting tdnf to work simply go to

````
cd /etc/yum/repos.d 
##and replace https with http in *.repo
##then try 
tdnf check-update
##then
tdnf upgrade -y
##then
tdnf install -y openssl-c_rehash
##Then copy your corporate root CA if it is self-signed to your photon os machine and run
## cp cert.pem file or files to /etc/ssl/certs 
##Note if you need to convert .cer to .pem I have a recipe for that also
##then 
/usr/bin/rehash_ca_certificates.sh
````
#### check /etc/pki/tls/certs/ca-bundle.crt to see if your certs are there using cat & grep I would still reboot

````
reboot
````
 
##### after the reboot check and see if you can run docker run hello-world if so your certs are good

##### again you only need to mess with the certs if your company is doing SSL inspection with a firewall/web filter appliance

##### Now once that is working you might run into another issue, even though you have set a DNS server in

##### /etc/systemd/networkd.10-static... when you run cat /etc/resolv.conf you see 127.xx address

##### if you do then docker exec into your container and run cat /etc/resolv.conf and you should see Googles DNS servers

##### 8.8.8.8 8.8.4.4

##### The quick fix for this is head over to /etc/docker and see if you have a daemon.json file if you don't

````
touch daemon.json
## and add
{
  "dns" : ["WHATEVER_MY_DNS_SERVER_IP_IS", "SECONDARY_IF_YOU_WANT"]
}

docker stop my_container
systemctl restart docker
docker restart my_container
````


```Getting Cron on photon OS```

````
tdnf install -y cronie

systemctl enable cron
systemctl start cron
sysetmctl status cron

####After that you can use crontab -e####
crontab -e

##Then
crontab -l  ##List our jobs
````


#### We can use [https://crontab-generator.org/](https://crontab-generator.org) to help us generate our jobs



```ELASTICSEARCH AND Container Host configuration```

##### Note the below is only good as long as the system does not reboot

##### To persist on most version of linux this should be located @ /etc/sysctl.conf

#####Also check /proc/sys

##### Note on photonOS that file does not exist

##### I had issues with elasticsearch and memory you have to run the following command in linux

````
sysctl -w vm.max_map_count=262144

###To make the above stick on systems that don't have /etc/syctl.conf

cd /etc/sysctl.d

touch local.conf

vim local.conf

##Add the below or what ever else you want to change
vm.max_map_count=262144

reboot

sysctl -p

sysctl --help
````

##### The above worked on ubuntu, shoud work on centos and I will test on photonOS(sysctl is available on photonOS so the above works)

[https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html](https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html)


```Install Powershell```

````
tdnf install -y powershell

pwsh
````

##### It seems this is a 64-bit version of Powershell so everything should work out of the box

````
Install-Module -Name VMware.PowerCLI
````

```Running containers on port 53```

[https://serverfault.com/questions/973868/how-do-i-bind-to-udp-port-53-in-gce-container-optimized-os](https://serverfault.com/questions/973868/how-do-i-bind-to-udp-port-53-in-gce-container-optimized-os)

##### So I had an issue running coredns on port 53 turns out that photon OS uses systemd-resolved, so you need to stop that service so you can bind on udp 53

````
systemctl stop systemd-resolved

##Also since this will permanently run DNS
systemctl disable systemd-resolved
````

###### If you don't do the above you will have weird dns issues on the host machine

```CABundle location```

````
/etc/pki/tls/certs
````
