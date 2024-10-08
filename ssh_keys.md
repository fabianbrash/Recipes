[https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys--2](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys--2)

[https://security.stackexchange.com/questions/143442/what-are-ssh-keygen-best-practices](https://security.stackexchange.com/questions/143442/what-are-ssh-keygen-best-practices)

[https://www.brandonchecketts.com/archives/its-2023-you-should-be-using-an-ed25519-ssh-key-and-other-current-best-practices](https://www.brandonchecketts.com/archives/its-2023-you-should-be-using-an-ed25519-ssh-key-and-other-current-best-practices)

```GENERATING SSH KEYS TO SSH INTO SERVERS```

````
ssh-keygen -t rsa
###You can also associate it with your email
ssh-keygen -t rsa -C "me@me.com"(-C is for comments)

## UPDATED GUIDANCE

ssh-keygen -t ed25519 -a 100

ssh-keygen -t rsa -b 4096 -o -a 100 # use on older systems Ubuntu <=14.04 or RHEL/CENT <=6.x

##Also you can use
ssh-keygen -t rsa -b 4096(-b bits)

## Also

ssh-keygen -t ed25519 -f ./work-github -C "fabian@blah.com" -a 100

## The above will produce 2 files work-github and work-github.pub

##then answer the presented questions#########
###you can enter a passphrase for your key if you like but if you do then you will need to enter it everytime you ssh into your server
######Once completed your keys should be in a location like this###
MAC - /Users/me/.ssh

LINUX - /home/me/.ssh

####File Names#####
id_rsa - private key this is the one you keep
id_rsa.pub - public key the one that gets uploaded to your server
````

```Copy ssh keys to server```

````
ssh-copy-id user@123.45.56.78
##or###
ssh-copy-id -i /users/home/mykey.pub user@123.45.56.78(-i specifies the identity file to use default 
##is /users/home/.ssh/id_rsa.pub)
###this should copy the keys to /home/user/.ssh/authorized_keys

##You might have to use ssh-add 'your private key' . ### I don't this is correct your private key stays on your machine
##and shouldn't be sent to anyone else
````


```SSH BANNERS```
````
#Create a file called issue.net it can be located anywhere
sudo vim /etc/ssh/issue.net
###Add content to file then restart sshd
sudo systemctl restart sshd
````


```SSH MOTD```
````
sudo vim /etc/motd
````

```ADDING SSH KEYS TO SSH-AGENT```

````
ssh-agent bash ##launch a bash shell for ssh-agent
ssh-add ##adds a private key to be managed
ssh-add /location/name_of_private_key ##add a non default key
ssh-add -l ##List all managed keys.
````

[http://sshkeychain.sourceforge.net/mirrors/SSH-with-Keys-HOWTO/SSH-with-Keys-HOWTO-6.html](http://sshkeychain.sourceforge.net/mirrors/SSH-with-Keys-HOWTO/SSH-with-Keys-HOWTO-6.html)

```CHANGE SSH PORT```

````
vi /etc/sshd_config  ##Make sure you are confuguring the correct file
##Find line 
#Port 22 and change to whatever make certain that port is free and that you allow it through the firewall
##iptables, firewalld, or ufw(ubuntu)

ssh user@server -p 1000

###Remove host from known_hosts#######

ssh-keygen -f "/home/user/.ssh/known_hosts" -R "host_DNS_OR_IP"
````

```Disable SSH host key checking```

````
cd ~user/.ssh
touch config

##In the file add

Host *
   StrictHostKeyChecking no
   UserKnownHostsFile=/dev/null
   
 #The above will do this for all hosts VERY VERY DANGEROUS!!!!!!!!
 
##You can do this

Host 192.168.1.5
   StrictHostKeyChecking no
   UserKnownHostsFile=/dev/null
   
 ##Just that host or
 
 Host 192.168.0.*
   StrictHostKeyChecking no
   UserKnownHostsFile=/dev/null
   
 ##The entire 192.168.0.0/24
````

 
 ##### I haven't fully tested the above yet

 
 [https://www.shellhacks.com/disable-ssh-host-key-checking/](https://www.shellhacks.com/disable-ssh-host-key-checking/)
 
 
 ### Also I had an odd issue when I attempted to ssh into a server I kept getting asked to accept the key And everytime I accepted the key it would ask again, but it did tell me that the offending key
 in known_hosts was line 32, and the matching key was line 44, so I used vim and turned on number
 ### with 'esc' ':' 'set line' and deleted line 32 and now it's all happy
 
 
 ```Show VisualHostKey```

 ````
 ssh -o VisualHostKey=yes user@server   ##Will show the VisualHostkey
 
 ###Or you can add this to your user/.ssh/config file
 ````
 
 ```SSH Log file location```

````
 cd /var/log/auth.log
 cat /var/log/auth.log | grep -i sshd  ##Just give me ssh related entries
````

```locking down ssh private key```


````

chmod 600 ~/.ssh/id_rsa

````


[https://stackoverflow.com/questions/9270734/ssh-permissions-are-too-open](https://stackoverflow.com/questions/9270734/ssh-permissions-are-too-open)
