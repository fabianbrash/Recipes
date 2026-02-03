```Configure Firefox for SOCKs v5```



#### How to configure Firefox
#### Once that command is running, you have to tell Firefox to use that tunnel:

1. Go to Settings in Firefox.

2. Search for "Proxy" and click Settings... at the bottom.

3. Select Manual proxy configuration.

4. Find the SOCKS Host field and enter 127.0.0.1 and Port 1080.

5. Ensure SOCKS v5 is selected.

6. Critical Step: Check the box that says "Proxy DNS when using SOCKS v5". This ensures your DNS queries also go through the tunnel (keeping your browsing private from your local network).



```SSH config```


````
ssh -D 1080 -N -f username@remote-server-ip

OR

ssh -p 5132 -D1100 <user_name>remote-server-ip ## simple way note here we're using port 5132 instead of 22

````
