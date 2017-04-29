#!/bin/bash

##Initial config for Debian based systems i.e Ubuntu
##open-vmtools should already be installed with ubuntu server

apt update && apt upgrade -y
sleep 15
apt install network-manager openssh-server -y
systemctl start NetworkManager && systemctl enable NetworkManager && systemctl start ssh & systemctl enable ssh
sleep 20
apt update
sleep 15
cat /run/motd.dynamic
echo Rebooting...
reboot
