#!/bin/bash

##Initial config for a minimal CentOS install

yum upgrade -y && yum group install "Development Tools" -y && yum install wget ntp vim firewalld epel-release open-vm-tools pciutilssudo  -y
sleep 15
systemctl start vmtoolsd && systemctl enable vmtoolsd
systemctl start ntpd && systemctl enable ntpd
firewall-cmd --add-service=ntp --permanent
firewall-cmd --reload
