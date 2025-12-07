```dd examples```


````

sudo dd if=/dev/zero of=/dd-test.img bs=1G count=8 oflag=direct status=progress

sudo rm -f /dd-test.img 

````
