#!/bin/bash

##Initial config for Debian based systems i.e Ubuntu
##open-vmtools should already be installed with ubuntu server

apt update && apt upgrade
sleep 15
apt install -y network-manager openssh-server
systemctl start NetworkManager && systemctl enable NetworkManager
sleep 20
apt update
