## Certbot information


[Certbot - docs](https://certbot.eff.org/docs/using.html?highlight=dns)



### Okay let's install a cert completely manually

````
certbot certonly --manual --preferred-challenges dns
````

### Okay enter your CN and then add the TXT entry in your DNS provider

### OR

````
certbot certonly -d myservice.domain.com --manual --preferred-challenges dns
````

### Note the above command will also renew a cert that's about to expire
### We cannot use the renew feature of certbot because when we generated the original cert we use the --manual option
### Note I used the manual option for Windows, but on Linux I used the route53 plugin so I should be able to use the 
### auto-renew functionality.

### Install plugins centos 8 this works for the latest ubuntu you will need to tweak for centos7

````
sudo dnf install -y epel-release

sudo dnf install -y certbot
````

### Should already be there but just in case

````
sudo yum install python3-pip -y

certbot plugins  ## list all plugins

pip3 list  ## list all packages

sudo pip3 install certbot-dns-route53

certbot plugins  ## you should now see the route53 plugin

certbot certificates # list know certificates

````

### Now to use the route53 plugin create a directory

```config```

````
mkdir ~/.aws

cd .aws

touch config

[default]
aws_access_key_id=your_access_key
aws_secret_access_key=your_secret_access_key
````

````

##Note the [default is very important make sure you don't misspel it like I did and spend 40 minutes troubleshooting it

##Then you can re-run the tls_request I have here https://github.com/fabianbrash/Bash/blob/master/tls_request.sh

###Ubuntu SNAP install####

sudo snap install --classic certbot

sudo ln -s /snap/bin/certbot /usr/bin/certbot

````

### Manual DNS challenge

````
certbot certonly --manual --preferred-challenges dns \
-d fqdn_of_your_server \
-m test@testemail.com \
--agree-tos

````

