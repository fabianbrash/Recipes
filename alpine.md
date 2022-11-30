```alpine info```


[https://wiki.alpinelinux.org/wiki/Install_Alpine_on_VMware_Workstation](https://wiki.alpinelinux.org/wiki/Install_Alpine_on_VMware_Workstation)

```update system```


##### First let's enable community repos

````
vi /etc/apk/repositories

## uncomment http://dl-cdn.alpinelinux.org/alpine/v3.16_OR_YOUR_VERSION/community
## Also change to https for both community and non-community packages

apk update
apk upgrade

#OR
apk -U upgrade

````
[https://wiki.alpinelinux.org/wiki/Repositories](https://wiki.alpinelinux.org/wiki/Repositories)



```Install a Package```


````

apk add openssh
apk add openssh openntp vim

````


```Enable and Start a service```


````
rc-status

rc-status --list

rc-status --manual   #list all manual services

rc-status --crashed

rc-service --list  #list all available services
rc-service --list | grep -i nginx

rc-update add apache2  # Add service to run at boot time
# OR

rc-update add apache2 default

rc-service {service-name} start
 
# OR

/etc/init.d/{service-name} start

rc-service {service-name} stop

/etc/init.d/{service-name} stop

rc-service {service-name} restart

/etc/init.d/{service-name} restart
 

````

[https://www.cyberciti.biz/faq/how-to-enable-and-start-services-on-alpine-linux/](https://www.cyberciti.biz/faq/how-to-enable-and-start-services-on-alpine-linux/)



```Install open-vm-tools```


````

apk add open-vm-tools
apk add open-vm-tools-guestinfo
apk add open-vm-tools-deploypkg


rc-service open-vm-tools start

rc-update add open-vm-tools default


````

##### From the above I got the servce name by running the below


````
rc-service --list | grep -i open

# OR

rc-service --list | more

````
