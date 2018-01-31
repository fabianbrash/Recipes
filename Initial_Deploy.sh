#!/bin/bash

##Initial config for a minimal CentOS install

yum upgrade -y && yum group install "Development Tools" -y && yum install wget ntp vim firewalld epel-release open-vm-tools pciutils tree yum-utils -y
sleep 15
yum install -y openssh-server
systemctl start vmtoolsd && systemctl enable vmtoolsd
systemctl start ntpd && systemctl enable ntpd
firewall-cmd --add-service=ntp --permanent
firewall-cmd --reload
sleep 30
yum upgrade -y

#####Docker installation for CENTOS 7.x#####
###Uncommnet if you would like docker ce installed
#yum install -y yum-utils \
#device-mapper-persistent-data \
#lvm2

#yum-config-manager \
#--add-repo \
#https://download.docker.com/linux/centos/docker-ce.repo

#yum install docker-ce -y
#systemctl start docker && systemctl enable docker

#REF: https://docs.docker.com/install/linux/docker-ce/centos/#set-up-the-repository
