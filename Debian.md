### So there are a few differences between Debian and Ubuntu and there derivatives

#### First when I installed Debian11 from the DVD sudo is not installed by default again it's a more secure OS and it wants you to su to root also when I tried to run apt update
#### I ran into another issue where it gave an error similar to cdrom:\\Debian 11 ... not found the fix for that is below

````
su -
vi /etc/apt/sources.list
````

#### Maybe also here as well even though I didn't have to go here

````
or files in /etc/apt/sources.list.d/
````

#### Comment out any line that references the install DVD once you do that

#### Now let's install sudo 


````
su -

apt update && apt install -y sudo
````

#### More then likely your user will not be in the sudoers file so we need to add them

````
su -
usermod -aG sudo myuser
````

#### You might have to log out and back in again or

````
su myuser

sudo fdisk -l
````

##

### Set a static ip address

````
su -
cd /etc/network
cp interfaces interfaces.OLD

vim interfaces

## under #Primary network interface
auto (whatever the name is here)
iface adapter_name_here) inet static
  address 192.168.1.250
  netmask 255.255.255.0
  gateway 192.168.1.1
  dns-domain domain.com
  dns-nameservers 8.8.8.8

````

````
su -
systemctl restart networking
reboot now  ## note I had to reboot for this to take effect I gotta figure out why restaring the service doesn't do it

ip -c addr show
ip -c addr show my_network_device
````
