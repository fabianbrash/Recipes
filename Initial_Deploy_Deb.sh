#!/bin/bash

##Initial config for Debian based systems i.e Ubuntu
##open-vmtools should already be installed with ubuntu server
##I am removing the install of network-manager as I found it to be buggy

apt update && apt upgrade -y
sleep 15
apt install openssh-server tree -y
systemctl start ssh & systemctl enable ssh
####If you would like to install Development tools uncomment this line
#apt install build-essential -y
###Optionally if you would like webmin un-comment the line(s) below
#LOCATION=$PWD
##curl -O -L http://prdownloads.sourceforge.net/webadmin/webmin_1.831_all.deb
##apt install -f $LOCATION/webmin_1.831_all.deb -y
##Remove if you are on a VM  sudo apt-get install open-vm-tools
sleep 20
apt update
sleep 15
cat /run/motd.dynamic
echo Rebooting...
reboot
