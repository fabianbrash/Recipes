```AVI Information```


##### To do anything worth while you need to SSH into the controller and then get into essentially enable mode


````

ssh admin@IP_OR_FQDN_OF_CONTROLLER

shell #enter into admin shell, the username and password will be the same as what you used to SSH into the appliance

TABTAB #will give you commands you can run

show license

show configuration audit tier essentials(or 'enterprise_16', 'enterprise', 'enterprise_18', 'basic', 'essentials')

bash

exit
exit
exit

````


- [ ] [https://avinetworks.com/docs/latest/cli-guide/](https://avinetworks.com/docs/latest/cli-guide/)

- [ ] [https://avinetworks.com/docs/20.1/cli-top-level-commands/](https://avinetworks.com/docs/20.1/cli-top-level-commands/)


```tkgs setup```


1. Deploy OVA
2. Apply all patches
3. Change license to Essentials if possible
4. Change out certificate
5. Add vCenter as a cloud
6. Add frontend network
7. Set VRF to 0.0.0.0/0 --> frontend GW
8. Setup SE pool
9. Setup frontend network pool
