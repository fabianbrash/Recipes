#!/bin/bash

##Initial config for a minimal CentOS install

yum upgrade -y && yum group install "Development Tools" -y && yum install wget ntp vim firewalld epel-release open-vm-tools pciutils tree -y
sleep 15
yum install -y openssh-server
systemctl start vmtoolsd && systemctl enable vmtoolsd
systemctl start ntpd && systemctl enable ntpd
firewall-cmd --add-service=ntp --permanent
firewall-cmd --reload
sleep 30
yum upgrade -y
