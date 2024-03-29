```USING NGINX AS A LB, REVERSE PROXY, CACHING AND SSL TERMINATION SERVER```

````
cd /etc/nginx
##A couple of important directories here are sites-available and sites-enabled(sites-enabled gets loaded 
##when nginx starts or reloads)
cd /etc/nginx/sites-available
sudo vim app-name

#######BASIC REVERSE PROXY SETTINGS##############################
#########CONTENTS OF app-name file##########################
server {
          listen 80;
          location / {
           proxy_pass "http://127.0.0.1:3000"
         }
}

````

#### you may want to check and see if seLinux is blocking your proxy

[https://stackoverflow.com/questions/23948527/13-permission-denied-while-connecting-to-upstreamnginx](https://stackoverflow.com/questions/23948527/13-permission-denied-while-connecting-to-upstreamnginx)

````
sudo cat /var/log/audit/audit.log | grep nginx | grep denied
````

#### if you are being blocked you can set SELinux to permissive or use the below

````
sudo setsebool -P httpd_can_network_connect 1
sudo systemctl reload nginx
````


#### I assume the above will survive a reboot but I have not checked yet

```END FILE CONTENTS```



```CONFIGURING MULTIPLE APPS BY URL REWRITE```

```CONTENTS OF app-name file```

````
server {
          listen 80;
          location / {
           proxy_pass "http://127.0.0.1:3000"
         }
         
         location /app1(Your URL would go here) {
          rewrite ^/app1(.*) $1 break;
          proxy_pass "http://127.0.0.1:3001";
          }
          location /app2 {
          rewrite ^/app2(.*) $1 break;
          proxy_pass "http://127.0.0.1:3002";
          }
          
}
####NOTE the above code requires a ULR rewrite because the app is expecting traffic on /, if the app was expecting
#####traffic on /app1 then I don't think the rewrite was would be required, using / is a common practice for Node apps




######CONFIGURING MULTIPLE HOSTNAMES#################

#########CONTENTS OF app-name file##########################
server {
          listen 80;
          server_name abc.com www.abc.com *.abc.com;
          location / {
           proxy_pass http://127.0.0.1:3000;
           }
             
}

server {
          listen 80;
          server_name def.com www.def.com;
          location / {
           proxy_pass http://127.0.0.1:3001;
           //Let's send some data back to our backend nodes remember nginx is only doing reverse proxy here it's not your web server
           proxy_set_header     x-real-IP           $remote_addr;
           proxy_set_header     x-forwarded-for     $proxy_add_x_forwarded_for;
           proxy_set_header     host                $host;
           }
}

````

```END FILE CONTENTS```

````

sudo ln -s /etc/nginx/sites-available/app-name /etc/nginx/sites-enabled/node-app
sudo systemctl reload nginx
````

```REVERSE PROXY WITH SSL```

```CONTENTS OF app-name file```

````
server {
          listen 80;
          server_name *.abc.com;
          location / {
           proxy_pass "http://127.0.0.1:3000"
         }
}

server {
          listen 443;
          server_name *.abc.com;
          ssl_certificate       /etc/nginx/certs/cert.crt;
          ssl_certificate_key   /etc/nginx/certs/cert.key;
          ssl on;
          ssl_protocols TLSv1 TLSv1.1 TLSV1.2;
          location / {
            proxy_pass https://127.0.0.1:3001;
           //Let's send some data back to our backend nodes remember nginx is only doing reverse proxy here it's not your web server
           proxy_set_header     x-real-IP           $remote_addr;
           proxy_set_header     x-forwarded-for     $proxy_add_x_forwarded_for;
           proxy_set_header     host                $host;
           }
}

````

```END FILE CONTENTS```


```LOAD BALANCE```

```TYPES OF LB```
````
round-robin
   default

least-connected
  least_conn;

ip-hash
ip_hash; (used for sticky sessions)

upstream backend_nodes {
              ip_hash; /make connections sticky
              server 192.168.1.5;
              server 192.168.1.6;
              server 192.168.1.7;
}


server {
          listen 80;
          
          location / {
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; (send the IP of the client to the backend nodes)
            proxy_pass http://backend_nodes;
            }
 }
 
 
````         
           
```BASIC NGINX SETUP TO SERVE AN API THIS CASE JUST A .json file```


```Server used ubuntu should be pretty similar on centos```

````
sudo apt install -y nginx
cat /etc/nginx/mime.types | grep -i json  ##make certain this is defined
cd sites-available
sudo cp default api
sudo mv default default.ORIGINAL
cd /etc/nginx/sites-enabled
sudo ln -s /etc/nginx/site-available/api api

cd /var/www/html
sudo mkdir api  ##copy your .json file here



#####Start File 'api'#############################

##
# You should look at the following URL's in order to grasp a solid understanding
# of Nginx configuration files in order to fully unleash the power of Nginx.
# http://wiki.nginx.org/Pitfalls
# http://wiki.nginx.org/QuickStart
# http://wiki.nginx.org/Configuration
#
# Generally, you will want to move this file somewhere, and start with a clean
# file but keep this around for reference. Or just disable in sites-enabled.
#
# Please see /usr/share/doc/nginx-doc/examples/ for more detailed examples.
##

# Default server configuration
#
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        # SSL configuration
        #
        # listen 443 ssl default_server;
        # listen [::]:443 ssl default_server;
        #
        # Note: You should disable gzip for SSL traffic.
        # See: https://bugs.debian.org/773332
        #
        # Read up on ssl_ciphers to ensure a secure configuration.
        # See: https://bugs.debian.org/765782
        #
        # Self signed certs generated by the ssl-cert package
        # Don't use them in a production server!
        #
        # include snippets/snakeoil.conf;

        root /var/www/html/api;

        # Add index.php to the list if you are using PHP
        index index.html index.htm index.nginx-debian.html;

        server_name _;

        location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files $uri $uri/ =404;
        }

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        #location ~ \.php$ {
        #       include snippets/fastcgi-php.conf;
        #
        #       # With php7.0-cgi alone:
        #       fastcgi_pass 127.0.0.1:9000;
        #       # With php7.0-fpm:
        #       fastcgi_pass unix:/run/php/php7.0-fpm.sock;
        #}

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #       deny all;
        #}
}


# Virtual Host configuration for example.com
#
# You can move that to a different file under sites-available/ and symlink that
# to sites-enabled/ to enable it.
#
#server {
#       listen 80;
#       listen [::]:80;
#
#       server_name example.com;
#
#       root /var/www/example.com;
#       index index.html;
#
#       location / {
#               try_files $uri $uri/ =404;
#       }
#}



###############END FILE########################

````

#### You can also add a new disk to your VM partition and format it and mount it and server your web data from that mount point




```CENTOS7/RHEL7```

[https://www.digitalocean.com/community/tutorials/how-to-set-up-nginx-server-blocks-on-centos-7](https://www.digitalocean.com/community/tutorials/how-to-set-up-nginx-server-blocks-on-centos-7)

#### After installing nginx from epel-release you might have to create both the sites-available and sites-enabled folders

````
cd /etc/nginx

sudo mkdir sites-available
sudo mkdir sites-enabled

sudo vim nginx.conf
````

#### Add the below to the end of the http{} directive

````
include /etc/nginx/sites-enabled/*.conf;
server_names_hash_bucket_size 64; #REF:http://nginx.org/en/docs/http/server_names.html
````

#### Note because of the above config your config files in /etc/nginx/sites-available must end with .conf

#### Then create a .conf file and symlink it in /etc/nginx/sites-enabled

#### Note a simple conf file to serve up a sailsjs api would look like this

```Contents of api.conf```

````
###I'm no expert here but maybe I don't need the 1337 in the proxy_pass directive, but hell it works so who cares####

server {
         listen 1337;
         location / {
           proxy_pass "http://127.0.0.1:1337"
         }
}
````

```End file contents```


#### Then as I said symlink that conf file and make certain to reload nginx and open that port in your firewall

````
sudo firewall-cmd --zone=public --permanent --add-port=1337/tcp 
sudo firewall-cmd --reload
````


```CENTOS7```

#### In order to setup nginx as a reverse proxy make certain you've allowed the appropriate ports in firewalld as well

#### As make certain SELinux IS IN Permissive mode as this will prevent RP from working, I will need to 

#### firgure out how to get this to work with SELinux on

````
sudo setenforce Permissive
sestatus
````


##### NOTE: During reboot this will change back

````
cd /etc/selinux ##On centos check your linux flavor
vi config ##and change the default to permissive
````

###### ALSO I SET MY RP CONFIG IN TEH MAIN nginx.conf file in CENTOS7 I will have to figure out
###### How to create my own file as when you install nginx from upstream in Cent7 sites-available and sites-enabled
##### Folders are not present and I had to create them manually



```NGINX TLS termination```


##### These instructions are for centos 7.4+ Debian/Ubuntu could be different

[https://docs.nginx.com/nginx/admin-guide/security-controls/terminating-ssl-tcp/](https://docs.nginx.com/nginx/admin-guide/security-controls/terminating-ssl-tcp/)

#### look @ /etc/nginx.conf

````
sudo mkdir /etc/pki/nginx
sudo mkdir -p /etc/pki/nginx/private
cp public.crt /etc/pki/nginx
cp private.key /etc/pki/nginx/private
````


###### You would think you would need to chown the above pki/nginx to the nginx user but you don't


##### Settings for a TLS enabled server.

````
    server {
        listen       443 ssl http2 default_server;
        listen       [::]:443 ssl http2 default_server;
        server_name  _;
        root         /usr/share/nginx/html;

        ssl_certificate "/etc/pki/nginx/public.crt";
        ssl_certificate_key "/etc/pki/nginx/private/private.key";
        ssl_session_cache shared:SSL:1m;
        ssl_session_timeout  10m;
        ssl_ciphers HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers on;
        ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!3DES:!MD5:!PSK';
        ssl_dhparam /etc/ssl/certs/dhparam.pem;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;  # drop SSLv3 (POODLE vulnerability)
        

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        location / {
           proxy_pass http://127.0.0.1:1337;
        }

        error_page 404 /404.html;
            location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }
    
   ````
   
   
  ##### Making the above changes to your /etc/nginx.conf should do the trick
  
  ````
  sudo firewall-cmd --add-service=https --permanent
  sudo firewall-cmd --reload
  ````
  
  ##### That should be it
  
  ##### Now let's forward all HTTP -> HTTPS
  
 ````
  server {
        listen       80 default_server;
        listen       [::]:80 default_server;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        location / {
            proxy_pass http://127.0.0.1:1337;

        }

        error_page 404 /404.html;
            location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
        return 301 https://$host$request_uri;
    }
    
 ````
    
````
sudo systemctl reload nginx
````
    
    
[https://bjornjohansen.no/redirect-to-https-with-nginx](https://bjornjohansen.no/redirect-to-https-with-nginx)



```Some differences between nginx on centos & on ubuntu```


###### config

````
/etc/nginx #for both
/etc/nginx/sites-available && /etc/nginx/sites-enabled ##there by default on ubuntu, not on centos

/etc/nginx/sites-available/default ##on ubuntu this is the default server and location block
/etc/nginx/nginx.conf ##available on both ubuntu and centos but on centos this is the default server and location block
````


#### Note on both ubuntu and centos /etc/nginx/nginx.conf is the "main" config file this is where worker processes and the nginx user is defined

#### Also on centos there is a /etc/nginx/default.d where you can place a .conf file for default server block

#### directoy list for a specific folder

#### so I needed to enable directory list for a specific folder and the commands I found online were still giving me a 404

[https://serverfault.com/questions/347815/issues-with-nginx-autoindex](https://serverfault.com/questions/347815/issues-with-nginx-autoindex)

````
location /myfolder/ {
     autoindex on;
     autoindex_exact_size off;
  }
  
## the above still generates a 404

location /myfolder/ {
     root /usr/share/nginx/html;
     autoindex on;
     autoindex_exact_size off;
}

## the above now works, I guess you have to tell nginx the relative path


location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    location /myfolder/ {
        root        /usr/share/nginx/html;
        autoindex   on;
        autoindex_exact_size off;
    }
````
    
#### the above is a more complete server block

#### So the above came up again and why is this so hard!!!!

#### in the above example the /myfolder/ is relative to /usr/share/nginx/html so just stick a folder under html called myfolder but what if myfolder is on the / path


````
location /myfolder/ {
        root        /;
        autoindex   on;
        autoindex_exact_size off;
    }
````

````
setenforce permissive  ##note this is required you can check /var/log/messages and you will see seLinux errors is seLinux is set to enforcing
sudo systemctl restart nginx
````


#### but the above might still give you an error if you append a / http://server/myfolder/

#### so to fix that

````
location /myfolder {
        root        /;
        autoindex   on;
        autoindex_exact_size off;
    }
````

````
sudo systemctl restart nginx
````


#### I'm sure this is not the end of this but atleast I understand it a little morea also you do not have to change the permissions on the folder

#### I saw that until I edit this and tell you to change the permissions on the folder... the stuff can be so hard sometimes.


```CUSTOM 404```


[https://www.digitalocean.com/community/tutorials/how-to-configure-nginx-to-use-custom-error-pages-on-ubuntu-14-04](https://www.digitalocean.com/community/tutorials/how-to-configure-nginx-to-use-custom-error-pages-on-ubuntu-14-04)

````
error_page 404 /custom_404.html;
        location = /custom_404.html {
                root /usr/share/nginx/html;
                internal;
        }
````

##### I didn't use the internal keyword, not sure what that's for


#### Use the below link to enable ssl on nginx, pretty comprehensive and up-to-date, obviously you need to make some adjustments

[DO-Nginx-selfsigned-cert](https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-20-04-1)


```Check Nginx config```


````
 sudo nginx -t

````


```Working config as of 03-09-2023```



````
##
# You should look at the following URL's in order to grasp a solid understanding
# of Nginx configuration files in order to fully unleash the power of Nginx.
# https://www.nginx.com/resources/wiki/start/
# https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/
# https://wiki.debian.org/Nginx/DirectoryStructure
#
# In most cases, administrators will remove this file from sites-enabled/ and
# leave it as reference inside of sites-available where it will continue to be
# updated by the nginx packaging team.
#
# This file will automatically load configuration files provided by other
# applications, such as Drupal or Wordpress. These applications will be made
# available underneath a path with that package name, such as /drupal8.
#
# Please see /usr/share/doc/nginx-doc/examples/ for more detailed examples.
##

# Default server configuration
#
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        # SSL configuration
        #
        # listen 443 ssl default_server;
        # listen [::]:443 ssl default_server;
        #
        # Note: You should disable gzip for SSL traffic.
        # See: https://bugs.debian.org/773332
        #
        # Read up on ssl_ciphers to ensure a secure configuration.
        # See: https://bugs.debian.org/765782
        #
        # Self signed certs generated by the ssl-cert package
        # Don't use them in a production server!
        #
        # include snippets/snakeoil.conf;

        root /var/www/html;

        # Add index.php to the list if you are using PHP
        index index.html index.htm index.nginx-debian.html;

        server_name _;

        location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files $uri $uri/ =404;
        }
        return 301 https://$host$request_uri;

        # pass PHP scripts to FastCGI server
        #
        #location ~ \.php$ {
        #       include snippets/fastcgi-php.conf;
        #
        #       # With php-fpm (or other unix sockets):
        #       fastcgi_pass unix:/run/php/php7.4-fpm.sock;
        #       # With php-cgi (or other tcp sockets):
        #       fastcgi_pass 127.0.0.1:9000;
        #}

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #       deny all;
        #}
}

    server {
        listen       443 ssl http2 default_server;
        listen       [::]:443 ssl http2 default_server;
        server_name  _;

        root         /var/www/html;

        ssl_certificate "/etc/nginx/certs/editorial.crt";
        ssl_certificate_key "/etc/nginx/certs/editorial.open.key";
        ssl_session_cache shared:SSL:1m;
        ssl_session_timeout  10m;
        ssl_ciphers HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers on;
        ssl_dhparam /etc/nginx/conf.d/dhparams.pem;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;  # drop SSLv3 (POODLE vulnerability)


        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        location / {
                 # First attempt to serve request as file, then
                 # as directory, then fall back to displaying a 404.
                 try_files $uri $uri/ =404;
        }

        error_page 404 /404.html;
            location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }


# Virtual Host configuration for example.com
#
# You can move that to a different file under sites-available/ and symlink that
# to sites-enabled/ to enable it.
#
#server {
#       listen 80;
#       listen [::]:80;
#
#       server_name example.com;
#
#       root /var/www/example.com;
#       index index.html;
#
#       location / {
#               try_files $uri $uri/ =404;
#       }
#}

````
