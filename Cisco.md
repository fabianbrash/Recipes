### All these command have help (?) or have autocomplete


```LIST ALL PORTS```

````
show ip interface
#####SHOW VLAN INFO########
show vlan brief
#####DISPLAY WHAT'S IN FLASH
show flash
####SET DATE AND TIME#######
clock set hh:mm:ss 10 December 2016
````


```COPY RUNNING CONFIG TO STARTUP```

````
copy running-config startup-config
````


```SHOW LICENSE INFO```

````
show license
````

#### CHANGE SWITCH HOSTNAME MUST BE RUN FROM GLOBAL CONFIG

````
hostname CORE1
````
```CONFIGURE AN INTERFACE```

````
interface FastEthernet0
ip address 192.168.x.x 255.255.x.x
no shut
````

```KEEP AN INTERFACE UP```

````
interface FastEthernet0
no shut(conversely you can shut down an interface with shut)
````


#### Show interface status see if something is connected to a port

````
show interfaces status
````

```SETUP PASSWORD```

````
enable password 'your password'
enable secret 'your password'can't be the same as enable password
````


```CONFIGURE TELNET PASSWORD```

````
config t
line console 0
password 'your password'

###THIS WORKED FOR ME########
config t
line vty 0
password 'your password'
login
login synchronous
exec-timeout 40(optional)
motd-banner(optional)
````

#### ADD NEW USER AND SET PRIVILEGE THERE ARE WAYS TO ENCRYPT THE PASSWORD TYPE ? AFTER PASSWORD 0 5 7?

````
username fb privilege 15 password 'your password'
````


```CONFIGURE SSH```

````
conf t
line vty 0 4
login local
transport input ssh
````


```CONFIGURE MULTIPLE INTERFACE```

````
conf t
interface range GigabitEthernet1/0/1-28
no shut
no shut
````


```Configure a VLAN```

````
enable
config t
vlan "vlan number"
name Mgmt
````

#### Show information about a VLAN

````
show run interface vlan 101
````

```Extended VLAN issues```

#### So it seems on older Cisco switches you can only create VLANs up to 1005 above that it's considered extended VLANs


````
show vtp status
````

#### You need to enable "Transparent" mode

````
conf t
vtp mode transparent
````


```script to recreate a VLAN```


````
! 1. Create the new Layer 2 VLAN first
vlan 1101
 name VLAN1101
 exit

! 2. Remove the old Layer 3 Interface to free up the IP
no interface vlan 101

! 3. Create the new Layer 3 Interface
interface vlan 1101
 ip address 192.168.101.1 255.255.255.0
 description Renamed from Vlan101
 no shut
 exit

! 4. (Optional) Remove the old Layer 2 VLAN
no vlan 101
````

#### Now lets place a port or ports into the VLAN

````
config t
interface Gi1/0/24
switchport mode access
switchport access vlan "vlan number"
````

#### Setup up a Trunk for use with Virtualization on a VSS or vDS

````
config t
interface Gi1/0/23
switchport trunk encapsulation dot1q
switchport mode trunk
switchport trunk allowed vlan remove 1-4094
switchport trunk allowed vlan add 30,40,50
switchport trunk native vlan 99
#Did not work as expected with this command "switchport mode trunk encapsulation dot1q"

````
```SHOW VLAN INFORMATION ON A PORT```

````
show interfaces Gi1/0/13 switchport
````


#### SHOW VLAN IP INFORMATION(HELPFUL TO SEE DHCP HELPER ADDRESS

````
show ip interface vlan 60
````


```ADD IP HELPER ADDRESS TO A VLAN```

````
conf t
int vlan 10
ip helper-address x.x.x.x
````


#### SHOW RUNNING CONFIG FOR A SPECIFIC PORT

````
show run int gi1/0/13
````

```SHOW TRUNK INFORMATION```

````
show interfaces trunk

#ALSO
show interfaces Gi1/0/13 trunk
````

#### ABOVE COMMAND WILL ONLY SHOW DATA IF TRAFFIC IS ACTIVELY PASSING(STATUS LET'S YOU KNOW IT SHOULD SAY 'TRUNKING')

```DELETE A VLAN```

````
conf t
vlan
no vlan 3(delete VLAN 3)
````

#### Remove a vlan from a trunk

````
switchport trunk allowed vlan remove 1

````

#### Note on the above, I had vlan 1 in my config, vlan 1 is also my vlan back to my FIOS router so I had some odd behaviours so either configure a native vlan on the trunk or remove or not add vlan 1 at all

```REMOVE TRUNKING FROM A PORT OR PORTS```

````
conf t
interface Gi1/0/19(or whatever port(s)
no switchport trunk encapsulation
no switchport trunk native vlan 'your vlan number'
no switchport trunk allowed vlan 'your vlan range'
````


```SHOW TRUNK INFO```

````
show interfaces trunk
````


```REMOVE FROM VLAN```

````
conf t
interface vlan 'vlan id'
no ip address 'assigned Ip' 'subnet mask'
````


```REMOVE A CONFIGURATION LINE FROM A PORT OR PORTS```

````
conf t
interface Gi1/0/1
default switchport access vlan
````

```Remove access port from switchport```

````
no switchport access vlan 99  #remove the port from being access prepping it to be a trunk port

````

````
#####################################################################################################################################
                          THE 3750-E USES A X2 INTERFACE WHICH USES SC FIBRE SO WE NEED A LC-SC CABLE AND THEN 
                          A LC MODULE FOR THE SFP+ PORT ON A 10GB SFP+ NIC(OR CAN YOU PLUG IT IN WITHOUT A COVERTER)
                          XFP AND SFP+ USES LC CABLES


#####################################################################################################################################
````

```SHOW MAC ADDRESS TABLE```

````
show or sh mac-address-table
show arp table - can only be used once routing has been enabled on the switch
````


```IP ROUTING ENABLING L3```

````
conf t
ip routing

conf t
interface vlan 'your vlan number'
ip address 192.168.xx.1 255.255.255.0
````


```CISCO ESXI TRUNK CONFIGURATION```

````
conf t
interface range Gi1/0/10-20
 switchport trunk encapsulation dot1q
 switchport trunk native vlan 99
 switchport trunk allowed vlan 1,30,40,50,99
 switchport mode trunk
 switchport nonegotiate
 spanning-tree portfast trunk
````
 
 #### NOTE YOU MUST RUN THE BELOW COMMANDS TOGETHER OR YOU WILL RECEIVE AN ERROR
 
````
 switchport mode trunk
 switchport nonegotiate
````



```CONFIGURE JUMBO FRAMES```

````
show system mtu
conf t
system mtu jumbo 9198(This is the max, or > 1500)

system mtu 9198(or > 1500)
system mtu routing 9198(or > 1500)
reload
````

```REMOVE```

````
no system mtu jumbo
reload
````


```CONFIGURE PORT SPEED```

````
conf t
int Gi1/0/10
speed ?
duplex ?
````


```ALLOW CISCO SWITCH TO ACCEPT 3RD PARTY SFP+ MODULES```

````
service unsupported-transceiver
no errdisable detect cause gbic-invalid
#####shut the interface and then bring it back up again####
````


[https://info.hummingbirdnetworks.com/blog/forcing-cisco-switches-to-use-3rd-party-sfp](https://info.hummingbirdnetworks.com/blog/forcing-cisco-switches-to-use-3rd-party-sfp)



#### Show running config of a vlan or interface

````
en or enable
conf t
vlan xx
do sh run int vlan xx

###For interface
en or enable
conf t
int Gi1/0/22
do sh run int Gi1/0/22
````

```configure static routes```


````
conf t

ip route 0.0.0.0 0.0.0.0 192.168.1.1

conf t

ip route 10.1.1.0 255.255.255.0 192.168.50.11

show ip route

no ip route 10.1.1.0 255.255.255.0 192.168.50.11

show ip route

````


```show arp```


````
show arp
````


```tftp backup```


````

copy running-config tftp:
````

#### tftp no longer works for me, so I had to use SCP


````
copy running-config scp://ubuntu@192.168.181.11/sw1-core-config.txt
````

### But you will probably receive an error if your switch is using an older version of ssh so you will have to edit /etc/ssh/ssh_config


````
# Legacy support for older Cisco Switches
Ciphers +aes256-cbc,aes128-cbc,3des-cbc
KexAlgorithms +diffie-hellman-group1-sha1,diffie-hellman-group14-sha1
HostKeyAlgorithms +ssh-rsa
````
