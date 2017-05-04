#!/bin/bash

##Initial config for Debian based systems i.e Ubuntu
##open-vmtools should already be installed with ubuntu server
##I am removing the install of network-manager as I found it to be buggy

apt update && apt upgrade -y
sleep 15
apt install openssh-server -y
systemctl start ssh & systemctl enable ssh
sleep 20
apt update
sleep 15
cat /run/motd.dynamic
echo Rebooting...
reboot
