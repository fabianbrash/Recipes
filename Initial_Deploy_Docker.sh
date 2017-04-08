#!/bin/bash

##Initial config for a minimal CentOS install

yum upgrade -y && yum group install "Development Tools" -y && yum install wget ntp vim firewalld epel-release open-vm-tools pciutils yum-utils  -y
sleep 15
systemctl start vmtoolsd && systemctl enable vmtoolsd
systemctl start ntpd && systemctl enable ntpd
firewall-cmd --add-service=ntp --permanent
firewall-cmd --reload
sleep 15
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum makecache fast
yum install -y docker-ce
sleep 15
systemctl start docker && systemctl enable docker
sleep 30
yum upgrade
