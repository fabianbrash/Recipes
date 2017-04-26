#!/bin/bash

##Initial config for Debian based systems i.e Ubuntu and installation of docker-ce
##open-vmtools should already be installed with ubuntu server

apt update && apt upgrade
sleep 15
apt install -y network-manager openssh-server
systemctl start NetworkManager && systemctl enable NetworkManager && systemctl start ssh & systemctl enable ssh
sleep 20
##Install AUFS storage driver
apt install linux-image-extra-$(uname -r) linux-image-extra-virtual
##Install all components required for docker-ce
apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update
##Now install docker-ce
apt install docker-ce
sleep 20
apt update
