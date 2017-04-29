#!/bin/bash

##Initial config for Debian based systems i.e Ubuntu and installation of docker-ce
##open-vmtools should already be installed with ubuntu server

apt update && apt upgrade -y
sleep 15
apt install network-manager openssh-server -y
systemctl start NetworkManager && systemctl enable NetworkManager && systemctl start ssh & systemctl enable ssh
sleep 20
##Install AUFS storage driver
apt install linux-image-extra-$(uname -r) linux-image-extra-virtual -y
##Install all components required for docker-ce
apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update
##Now install docker-ce
apt install docker-ce -y
sleep 20
apt update
cat /run/motd.dynamic
echo Rebooting...
sleep 10
reboot
