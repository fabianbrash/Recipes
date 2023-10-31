#### CREATE A SELF-SIGNED CERT WITH SAN(Subject Alternative Name) use in conjunction with openssl.ps1

[DO-openssl-essentials-working-with-ssl-certificates-private-keys-and-csrs](https://www.digitalocean.com/community/tutorials/openssl-essentials-working-with-ssl-certificates-private-keys-and-csrs)

[https://www.digitalocean.com/community/tutorials/openssl-essentials-working-with-ssl-certificates-private-keys-and-csrs#generating-ssl-certificates](https://www.digitalocean.com/community/tutorials/openssl-essentials-working-with-ssl-certificates-private-keys-and-csrs#generating-ssl-certificates)

[Soarez-Gist](https://gist.github.com/Soarez/9688998)

[fntlnz-Gist](https://gist.github.com/fntlnz/cf14feb5a46b2eda428e000157447309)
[https://www.golinuxcloud.com/openssl-subject-alternative-name/](https://www.golinuxcloud.com/openssl-subject-alternative-name/)


```Create root private key or any private key```

````
openssl genrsa -des3 -out rootCA.key 4096
````

```Create and self-sign root CA```

````
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1024 -out rootCA.crt
````

## Note a su - to root to do the above for optimal security???


```BEGIN FILE```

````
[ req ]
default_bits       = 2048
distinguished_name = req_distinguished_name
x509_extensions     = v3_req
prompt             = no
[ req_distinguished_name ]
countryName                 = "US"
stateOrProvinceName         = "Virginia"
localityName                = "Richmond"
organizationName            = "Blah Company"
organizationalUnitName      = "Blah"
commonName                  = "blah.io"
emailAddress                = "blah@blah.io"
[ v3_req ]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = blah.io
DNS.2 = blah.com
DNS.3 = blah.net

````

##### Apparently the above uses 'dataEncipherment' apparently Chrome does not like that, and we need to use the below, note we have replaced it with 'digitalSignature'

````
[ req ]
default_bits       = 2048
distinguished_name = req_distinguished_name
x509_extensions     = v3_req
prompt             = no
[ req_distinguished_name ]
countryName                 = "US"
stateOrProvinceName         = "Virginia"
localityName                = "Richmond"
organizationName            = "Blah Company"
organizationalUnitName      = "Blah"
commonName                  = "blah.io"
emailAddress                = "blah@blah.io"
[ v3_req ]
keyUsage = keyEncipherment, digitalSignature
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = blah.io
DNS.2 = blah.com
DNS.3 = blah.net

````

[https://superuser.com/questions/1451895/err-ssl-key-usage-incompatible-solution](https://superuser.com/questions/1451895/err-ssl-key-usage-incompatible-solution)


[Citrix Article](https://support.citrix.com/article/CTX135602)

## Save the above file with a .cnf extension

## If you only have one DNS name that's fine but the SAN is now required by Google as of Chrome 58+####
## THANKS GOOGLE!!!!!!!

## If you use the above you need to use the below to generate your cert if you don't your SAN will not get populated


````

openssl x509 -req -in harbor-01.csr -CA harbor-root.crt -CAkey harbor-root.key -CAcreateserial -out harbor-01.crt -days 365 -extensions v3_req -extfile harbor.cnf

# verify

openssl x509 -in harbor-01.crt -noout -text

openssl x509 -in harbor-01.crt -noout -text | grep -i dns

````

```harbor.cnf```


````
[ req ]
default_bits       = 2048
distinguished_name = req_distinguished_name
x509_extensions     = v3_req
prompt             = no
[ req_distinguished_name ]
countryName                 = "US"
stateOrProvinceName         = "Virginia"
localityName                = "Richmond"
organizationName            = "IT"
organizationalUnitName      = "IT"
commonName                  = "harborh2o.h2o.io"
emailAddress                = "blah@blah.io"
[ v3_req ]
keyUsage = keyEncipherment, digitalSignature
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = harborh2o.h2o.io

````

##### Let's create our csr, then let's create the crt signed by our CA and finally test it to make sure it's all okay, note we are using the above cnf file.

````

openssl req -out harbor-h2o.csr -newkey rsa:2048 -nodes -keyout harbor-h2o.key -config harbor.cnf

#alternatively

openssl req  -newkey rsa:2048 -nodes -keyout harbor-h2o.key -out harbor-h2o.csr -subj "/C=US/ST=Virginia/L=Richmond/O=IT/CN=harborh2o.h2o.io"



openssl x509 -req -in harbor-h2o.csr -CA CA.crt -CAkey CA.key -CAcreateserial -out harbor-h2o.crt -days 90 -extensions v3_req -extfile harbor.cnf

openssl x509 -in harbor-h2o.crt -noout -text | grep -i DNS #test it
````


```OPENSSL COMMANDS```

#### Check to see if our cert is ASCII or BINARY(DER), if you get back text out then it's ASCII

````
openssl x509 -in cert.crt -text -noout
openssl x509 -in cert.cer -text -noout
````

#### View DER encoded certificates

````
openssl x509 -in certificate.der -inform der -text -noout

###Verify cert
openssl verify cert.crt
````

[Serverfault-what is a pemfile](https://serverfault.com/questions/9708/what-is-a-pem-file-and-how-does-it-differ-from-other-openssl-generated-key-file)

[Add new trusted CA](https://blog.confirm.ch/adding-a-new-trusted-certificate-authority/)


```Creat a self-signed certificate without generating a CSR first```

````
openssl req -x509 -newkey rsa:4096 -sha256 -nodes -keyout key.pem -out cert.pem -days 365

openssl req -x509 -newkey rsa:2048 -sha256 -nodes -keyout key.pem -out cert.pem -days 365

##Another option
openssl req -x509 -newkey rsa:4096 -sha256 -nodes -keyout key.key -out cert.crt -days 365

### Option with a SAN .cnf file(note I would recommend this for all certs)

openssl req -x509 -newkey rsa:4096 -sha256 -nodes -keyout key.key -out cert.crt -days 365 -config path_to_cnf/cert.cnf

````

```Adding ssl certs ubuntu```

[Add ssl certs ubuntu](https://askubuntu.com/questions/645818/how-to-install-certificates-for-command-line)

### copy .crt file to
````
sudo cp public.crt /usr/local/share/ca-certificates
sudo update-ca-certificates
##You should see outout 1 added...
#then go to
cd /etc/ssl/certs
##and you should see your cert there
###Note of your file is .pem you should be able to easily just rename it to .crt but I need to test that out
mv cert.pem cert.crt
````


```GENERATE DIFFIE-HELMAN```

````
openssl dhparam -out dhparams.pem 2048(can also be 1024, 4096 ofcourse higher is better)
#or
openssl dhparam -out /etc/nginx/conf.d/dhparams.pem 2048

````

[weakdh.org](https://weakdh.org/sysadmin.html)

[cipherli.st](https://cipherli.st/)

[Mozilla - ssl-config-generator](https://mozilla.github.io/server-side-tls/ssl-config-generator/)

## nginx add this point to our above generated file

````
ssl_dhparam /etc/nginx/certs/dhparam.pem;
````

## Generate DH parameters with at least 2048 bits. If you use 4096 bits for your TLS certificate you should match it in DH parameters too.

[Medium - how to properly configure nginx tls](https://medium.com/@mvuksano/how-to-properly-configure-your-nginx-for-tls-564651438fe0)

#### Please check your webserver docs to configure DH i.e. apache etc.#####



```INTERCHANGEABLE FILES```

### For the most part you can rename a .crt to .pem for import into Linux systems(there are exceptions)
### Also you can rename .pfx to .p12 to also import into Linux

```convert .p7b to .pem```

[Digicert](https://knowledge.digicert.com/solution/SO26449)

````
openssl pkcs7 -print_certs -in certificatename.p7b -out certificatename.pem
````


```EXPORT PRIVATE KEY FROM .PFX FILE```

## Export private key from pfx file

````
openssl pkcs12 -in C:\keys\filename.pfx -nocerts -out C:\keys\key.pem
##Make sure you can remember your passwords...

##Extract public key##
openssl pkcs12 -in C:\keys\filename.pfx -clcerts -nokeys -out C:\keys\cert.pem

##Remove password from private key
openssl rsa -in C:\keys\key.pem -out C:\keys\server.pem

### Check cert

openssl x509 -noout -text -in yourcert.cert
````

### Combine public key and private key into a .PFX file

````
openssl pkcs12 -export -out certificate.pfx -inkey privateKey.key -in certificate.crt -certfile CACert.crt
````

## Note the -certfile CACert.crt is optional and references if your have intermediate certificates

[Serverfault - iis7-import publickey-privkey](https://serverfault.com/questions/114795/iis7-how-to-import-public-key-and-private-key-as-two-seperate-files)

### Convert a DER encoded .cer file to .crt#####
## Note in Windows when you go to export a CA you are given 2 choices, Der encoded or BASE64
## The below is if you selected the first option; I need to see if you select the 2nd choice
## If you can just rename the file from .cer to .crt

````
openssl x509 -inform DER -in ssl_certificate.cer -out ssl_certificate.crt
````

### Convert .cer to .pem####

[Convert cer to pem](https://support.aerofs.com/hc/en-us/articles/205007260-How-Do-I-Convert-My-SSL-Certificate-File-To-PEM-Format-)

````
openssl x509 -inform der -in certificate.cer -out certificate.pem
````

```-nodes option```

### -nodes: Create a certificate that does not require a passphrase. If this option is excluded, you will be required to enter the passphrase in the console each time the application using it is restarted.

```more openssl options```

````
openssl x509 -in cert.crt(or cert.pem) -noout -text(note this is the public key)

````

```Check what cert a DC is using```

````
openssl s_client -connect myldapsserver.domain.com:636

openssl s_client -connect DC_DNS_OR_IP:636 < /dev/null | openssl x509 -out dc.pem
````


### I just learned you can hash passwords with

```` 
openssl passwd -1 "MyPassword"

openssl rand -base64 6
```` 
### and put it together

[Encrypted password just add salt](https://edvoncken.net/2011/03/tip-encrypted-passwords-just-add-salt/)

````
openssl passwd -1 -salt $(openssl rand -base64) mypassword
 
##OR
openssl passwd -1 -salt $(openssl rand -base64 6) mypassword
 
##OR
openssl passwd -1 -salt $(openssl rand -base64 6) "Press Enter and you will be prompted for the password to encrypt"
 
````

```Generate random password```

````
openssl rand -base64 14

###the above creates a random 14 character password

## or 

openssl rand -hex 20

## or

openssl rand -base64 21
````


```CIPHERS```

[https://www.openssl.org/docs/man1.0.2/man1/ciphers.html](https://www.openssl.org/docs/man1.0.2/man1/ciphers.html)

## Verbose listing of all OpenSSL ciphers including NULL ciphers
openssl ciphers -v 'ALL:eNULL'

##### Include all ciphers except NULL and anonymous DH then sort by strength

````
openssl ciphers -v 'ALL:!ADH:@STRENGTH'
````

### OpenSSL and ECDSA(Elliptical Curve...)

[https://superuser.com/questions/1103401/generate-an-ecdsa-key-and-csr-with-openssl/1103530](https://superuser.com/questions/1103401/generate-an-ecdsa-key-and-csr-with-openssl/1103530)

## For a list of possible curve names

````
openssl ecparam -list_curves
````

## Then pick 1??

````
openssl ecparam -name secp521r1 -genkey -noout -out rootCAECDSA.key
````

### Create and self-sign root CA

````
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1024 -out rootCAECDSA.crt
````

## Create a cert for a user

````
openssl req -new -key john.key -out john.csr -subj "/CN=john/O=finance"

Note in the above the O=finance is crucial as it basically says john is a member of the finance group
So we can then use that to create permission for groups of users and not just john
````

## Now let's sign johns cert with our CA

````
openssl x509 -req -in john.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out john.crt -days 365


openssl x509 -req -in harbor-01.csr -signkey harbor-root.key -CAcreateserial -out harbor-01.crt -days 365

# The above also works by create the cert and signing it with the -signkey I think I prefer the first option though

````

```NOTES```


````
Note the above will sign our cert from our root certificate so if you import the root cert into Linux or Windows any cert 

signed by the ca will be trusted, I prefer it that way, but you can also use openssl to just create a self-signed cert that is not signed by any

CA; then you will have to import that cert into your trusted root, the issue with doing it that way is that if you have 20 certs you have to 

import 20 into your trusted root store; while in the above all you have to is install the 1 root and then everything singed by it is 

automatically trusted; of course make sure you don't just install any random root cert into your trusted store; also it is very

very important that all downstream certs MUST HAVE A SAN, both chrome and k8s require it, the root cert itself 

does not need it but all downstreams do!!!

````

```get certs```

````
openssl s_client -connect fabianbrash.com:443

## Generate random 32 bit hex value

openssl rand -hex 32
````

### Note when you assemble a cert bundle and you add in your actual .crt file make sure it's at the top not the bottom

### Also make sure your private key is not encrypted if it is you need to use openssl to decrypt it with the password you created at creation


```Create a SAN CSR OpenSSL```

[GeekFlare-SAN-SSL](https://geekflare.com/san-ssl-certificate/)

````
touch san.cnf

````

````
[ req ]
default_bits       = 2048
distinguished_name = req_distinguished_name
req_extensions     = req_ext
[ req_distinguished_name ]
countryName                 = "US"
stateOrProvinceName         = "Virginia"
localityName                = "Richmond"
organizationName            = "My Company"
organizationalUnitName      = "IT"
commonName                  = "bestflare.com"
emailAddress                = "blah@blah.io"
[ req_ext ]
subjectAltName = @alt_names
[alt_names]
DNS.1   = bestflare.com
DNS.2   = usefulread.com
DNS.3   = chandank.com

````

````
openssl req -out sslcert.csr -newkey rsa:2048 -nodes -keyout private.key -config san.cnf

````

### Let's verify

````
openssl req -noout -text -in sslcert.csr | grep DNS

````

```Create wildcard csr openssl```

````
openssl req –new –newkey rsa:2048 –nodes –keyout server.key –out server.csr

# The above gave me errors so I used my old command

openssl req –newkey rsa:2048 –keyout server.key –out server.csr

# SSls had this

openssl req -new -newkey rsa:2048 -nodes -keyout STAR_alexanderbrash_dev.pem -out STAR_alexanderbrash_dev.csr -subj /CN=*.alexanderbrash.dev; cat STAR_alexanderbrash_dev.csr

# We can also do this, more complete we just can't add a SAN or SAN's this way

openssl req -new -newkey rsa:2048 -nodes -keyout STAR_tap_alexanderbrash_dev.pem -out STAR_tap_alexanderbrash_dev.csr \
-subj "/C=US/ST=Virginia/L=Richmond/O=IT/OU=IT/CN=*.tap.alexanderbrash.dev"; cat STAR_tap_alexanderbrash_dev.csr

Common name – Fully qualified domain name of the website you are securing. Since we need wildcard certificate for all subdomains, use asterisk (*) in place of subdomain name *.example.com

````

[Digicert-openssl-quick-reference](https://www.digicert.com/kb/ssl-support/openssl-quick-reference-guide.htm)


```Check cert chain```

````

openssl s_client -connect google.com:443 -showcerts

openssl s_client -connect google.com:443

````

```Check chain I need to research this more```


````

openssl verify -show_chain -CAfile star-tap-alexanderbrash-dev-bundle.crt star-tap-alexanderbrash-dev.crt

````

#### Check our CSR; not I still did not see my SAN but more on that later

````

openssl req -noout -text -in harbor-01.csr

````

#### Now let's check out cert

````

openssl x509 -in harbor-01.crt -noout -text

````

##### From the above I did see the SAN

#### More checks...

````

#Check a CSR
openssl req -text -noout -verify -in CSR.csr

#Check a private key
openssl rsa -in privateKey.key -check

#Check a certificate
openssl x509 -in certificate.crt -text -noout

#Check a PKCS#12 file (.pfx or .p12)
openssl pkcs12 -info -in keyStore.p12

````
[https://www.xolphin.com/support/OpenSSL/Frequently_used_OpenSSL_Commands](https://www.xolphin.com/support/OpenSSL/Frequently_used_OpenSSL_Commands)
