```Kali Linux```



##### Hydra is primarily known as a brute-force password cracking tool, it can be used in conjunction with other tools like Nmap to gain a comprehensive understanding of open ports and potential vulnerabilities. 


````
hydra -l frjb -P /usr/share/wordlists/metasploit/unix_passwords.txt -u -s 22 IP_ADDRESS_TO_SCAN

hydra -l <username> -P <path/to/wordlist.txt> ssh://<target_ip_address>


nmap IP_ADDRESS_TO_SCAN -p 22,25,53,80,111,443,445,3389,2049 --open

nmap -A IP_ADDRESS_TO_SCAN -p 22,25,53,80,111,443,445,2049,3389 --open
````


##### Metasploit

##### After you launch the app in Kali Linux


````
use auxiliary/scanner/portscan/tcp

show options

set PORTS 22,25,80,110,21  ## add whatever else you would like to add here for ports

set RHOSTS IP_OF_SERVER

set THREADS 3

run

db_nmap -sV -p 80,22,110,25 192.168.94.134  ##nmap wrapped for Metasploit
````
