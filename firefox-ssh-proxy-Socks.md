```Configure Firefox for SOCKs v5```



How to configure Firefox
Once that command is running, you have to tell Firefox to use that tunnel:

Go to Settings in Firefox.

Search for "Proxy" and click Settings... at the bottom.

Select Manual proxy configuration.

Find the SOCKS Host field and enter 127.0.0.1 and Port 1080.

Ensure SOCKS v5 is selected.

Critical Step: Check the box that says "Proxy DNS when using SOCKS v5". This ensures your DNS queries also go through the tunnel (keeping your browsing private from your local network).



```SSH config```


````
ssh -D 1080 -N -f username@remote-server-ip

````
