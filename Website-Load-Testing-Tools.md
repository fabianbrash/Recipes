

```I WILL ADD TOOLS HERE THAT I'VE USED TO LOAD TEST A WEBSITE```


##### curl-loader @http://curl-loader.sourceforge.net/
##### Has to be compiled from source but it wasn't too bad I just need to run
##### My system did not have the below package
##### Note this was tested in POP_OS which is a flavor of ubuntu in my case 17.10(Artful)


````
sudo apt install -y libssl-dev 
sudo make
##The above should compile and create a binary curl-loader, which can then be run with
sudo ./curl-load -f /pathto/configfile.conf
````


```EXAMPLE CONF FILE THAT WORKED FOR ME```

````
########### GENERAL SECTION ################################
BATCH_NAME= 6
CLIENTS_NUM_MAX=6
CLIENTS_NUM_START=1
CLIENTS_RAMPUP_INC=2
INTERFACE   =enp2s0
NETMASK=24
IP_ADDR_MIN= 192.168.5.230
IP_ADDR_MAX= 192.168.5.235  #Actually - this is for self-control
CYCLES_NUM= -1
URLS_NUM= 1

########### URL SECTION ####################################

URL=http://localhost/wp-login.php
#URL=http://localhost/ACE-INSTALL.html
URL_SHORT_NAME="local-index"
REQUEST_TYPE=GET
TIMER_URL_COMPLETION = 5000      # In msec. When positive, Now it is enforced by cancelling url fetch on timeout
TIMER_AFTER_URL_SLEEP =20


##########END CONFIG FILE####################################
````

##### Please pay attention to the INTERFACE(this must match yours) NETMASK(much match) IP_ADDR_MIN(Must be real IP's on your subnet) IP_ADDR_MAX(Must be real)



##### ANOTHER GREAT TOOL IS Siege located @ https://www.joedog.org/siege-home/

````
##Simply run
cd siege_folder
sudo ./configure
sudo make
sudo make install
````

##### siege will be installed by default to /usr/local/bin

##### USAGE the max -c is 255 so adjust the retrys#########

````
siege -u http://website -d1 -r10 -c50
siege -u https://website -d1 -r50 -c 255

##Log files are sent to /usr/local/var/siege.log
##If /usr/local/var does not exists, create it then run
sudo siege -u http://website -d1 -r10 -c50
sudo siege -u https://website -d1 -r50 -c 255
````
