```Kali Linux```


````
hydra -l frjb -P /usr/share/wordlists/metasploit/unix_passwords.txt -u -s 22 IP_ADDRESS_TO_SCAN

hydra -l <username> -P <path/to/wordlist.txt> ssh://<target_ip_address>


nmap IP_ADDRESS_TO_SCAN -p 22,25,80,443,445,3389 --open
````
