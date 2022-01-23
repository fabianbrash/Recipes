

## JUST SOME EXPERIMENTATION WITH sed

[Sed Help](http://www.grymoire.com/Unix/Sed.html)

[Sed examples](http://www.theunixschool.com/2014/08/sed-examples-remove-delete-chars-from-line-file.html)

````
sed -i.bak 's/This/sed/' sed_test  ###make a backup of sed_test and call it sed_test.bak and then s(subsitute) This with sed

sed -i.bak2 's/s//' sed_test ###make a backup with .bak2 extension and replace the 1st occurence of 's'

sed -i.bak3 's/s//g' sed_test ###make a backup with .bak3 extension and replace all occurences of 's'
````

## Replace all occurrences of DHCP=yes to DHCP=no 

````
sed -i 's/DHCP=yes/DHCP=no/g' /etc/systemd/network/99-dhcp-en.network
````
## Remove the spurious CR characters. You can do it with the following command:

````
sed -i -e 's/\r$//' create_mgw_3shelf_6xIPNI1P.sh
````

## Replace the image used in our k8s deployment yaml file

````
sed -i 's/- image: nginx:1.20/- image: nginx:1.21.5-alpine/g' sed-ng.yaml
````
