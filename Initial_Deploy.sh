#!/bin/bash

##Initial config for a minimal CentOS install

yum group install "Development Tools" -y && yum install wget ntp vim firewalld epel-release open-vm-tools pciutils -y
