### Splunk Info

##

#### Choose our forwarder = sourcetype=iis host="YourHost"

````
sourcetype=iis host="YourHost"
Useful Splunk IIS Searches
````
##

````
Number of Visits by Day/Time - sourcetype=iis | timechart count(c_ip) as "Number of Visits”
Unique Visitors by Day/Time - sourcetype=iis | timechart dc(c_ip) as "Unique Visitors”
Number of Hits - sourcetype=iis | stats count(cs_uri_stem) as “Hits"
Total and Unique Visitors - sourcetype=iis | stats count(c_ip) as "total visitors" dc(c_ip) as "unique visitors” 
Total and Unique Visitors by Day/Time - sourcetype=iis | timechart count(c_ip) as "total visitors" dc(c_ip) as "unique visitors"
Page Errors by Day/Time - sourcetype=iis sc_status > 400 | timechart count by sc_status
Top 10 Referring Sites - sourcetype=iis | top 10 cs_Referer
````

### Self created Splunk searches

#### Show only users that requested the proxy pac file

````
sourcetype=iis "/proxy00.pac" | top c_ip | table c_ip, count | rename c_ip as "Users" count as "Visits"

Show top 5 web browsers

sourcetype=iis "/proxy00.pac" | top limit=5 cs_User_Agent | rename cs_User_Agent as "Browser"
````

```DOCKER INFO```

````
docker exec -it 'containerID or name' entrypoint.sh splunk version
###LETS Clean all data from our indexer#############
docker exec -it 'containerID or name' entrypoint.sh splunk stop
docker exec -it 'containerID or name' entrypoint.sh splunk clean eventdata
docker exec -it 'containerID or name' entrypoint.sh splunk start
#####Splunk not being run as a container
splunk stop
splunk clean eventdata
splunk start
````

```Search commands```

````
index=my_firewall* src_ip=192.168.1.1 | table _time dvc src_ip src_ip_hostname dest_ip dest_ip_hostname dest_port server_ip transport action

index=my_firewall* src_ip=192.168.1.1 action=blocked | table _time dvc src_ip src_ip_hostname dest_ip dest_ip_hostname dest_port server_ip transport action
````
