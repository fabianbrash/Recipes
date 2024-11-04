```cloud init info goes here```




#### Adding cloud-init to a VM is relatively simple, before you power on the VM you just need to add 2 entries to "VM Options > Advanced > Configuration Parameters"

````
guestinfo.userdata.encoding: base64
guestinfo.userdata: BASE64_ENCODED_DATA_GOES_HERE
````

##### Then simply power on the VM and that should do it


[https://www.youtube.com/watch?v=lhWQBz5oj8o](https://www.youtube.com/watch?v=lhWQBz5oj8o)
