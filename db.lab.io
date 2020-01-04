$ORIGIN lab.io.
@	3600 IN	SOA dns.lab.io. mail.lab.io. (
				2017042745 ; serial
				7200       ; refresh (2 hours)
				3600       ; retry (1 hour)
				1209600    ; expire (2 weeks)
				3600       ; minimum (1 hour)
				)

	; 3600 IN NS a.iana-servers.net.
	; 3600 IN NS b.iana-servers.net.

dns IN A 192.168.99.254
test IN A 192.168.99.253
; fluffdock2 IN A	192.168.28.202
; fluffcenter1 IN A 192.168.28.220
; fluffcenter2 IN A 192.168.28.221
; fluffesx1 IN A 192.168.28.230
; fluffesx2 IN A 192.168.28.231
; fluffesx3 IN A 192.168.28.232
