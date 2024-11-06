```cloud init info goes here```




#### Adding cloud-init to a VM is relatively simple, before you power on the VM you just need to add 2 entries to "VM Options > Advanced > Configuration Parameters"

````
guestinfo.userdata.encoding: base64
guestinfo.userdata: BASE64_ENCODED_DATA_GOES_HERE
````

##### Then simply power on the VM and that should do it


[https://www.youtube.com/watch?v=lhWQBz5oj8o](https://www.youtube.com/watch?v=lhWQBz5oj8o)


```user-data example```


````

#cloud-config
users:
  - name: ubuntu
    plain_text_passwd: 'mysupersecretpassword'
    sudo: ALL=(ALL) NOPASSWD:ALL
    lock_passwd: false
    shell: /bin/bash
    ssh-authorized-keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICVCsjZQUH0XerR9k+Fzu0Uex5NmLqUWVflF7DQ+c0Yz Fabian.B@Fabian.fios-router.home
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDurFwCUbO48/eMNCIA0ZOA28UHRUTaLy0b0xWOM8Bdeh8alsRg83gAKOhQMllt6O1w7BDBo9MizGDG+O/H4lu/9C+7x8mBF7ACxU+BUtWXBMWyUeiBuPopdTTdIm2LsGxfPtL4K9t+QIfxpwOcgiGQDYE7jlu8Ajqw2KsZyXyIpGjngbn08kaGRaUPsZTtQgojXeFXxFkIMYZ1QKyD43gYUOP/XKfPXkW6o4StRAQmVTSiRF4EE7D0bMFVciuygV1PLlsBUhhoH0vscJkumMCMKTX/FOuRUx5cokwX6/zMpuRbsVggl/+D5/3DbXIL72ESDaMKf+DLxRKOmV1RRwQ8gBNYiqZi8WJLH2dwDhxMuRp1pW1cGvKdMR7bAc5WKsn+bZJscJp74LgpSCwK0JH/CeypVZMTvGZFHA3x9l1SK264+Tf8C3re3ciCFVaOdqCse0yck7pBLnPYPMErIoC9zn9fQYILHU5+AZL/OKENXMvjaisX4dChPVB6qHSw1V61CZqFH0W6TcJnhkKULGwJsF9QAIv9uYD/ekSd6/+VIQAbYDFKummqXA1AWSD1qcrzjxxXI1nLMQhnNlJd/0tULOeVw8fA2BAwrULLURlOgg/VdY1ytikmQxKasleK781+mj4On7HVj3rDNusvu7Qm4slNNsZUlTEFw9QMf57GCw== fb-skytech-1
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIeVXcMbIRtYZ9gB6ZYOIkbMKnLDY790rE07KQJJqq77 frb79@fb-skytech-1
package_upgrade: true
packages:
- curl
- wget
- bzip2
- policycoreutils

runcmd:
- mkdir -p /home/ubuntu/scripts && cd /home/ubuntu/scripts && curl -LO https://raw.githubusercontent.com/fabianbrash/Bash/refs/heads/master/k3s.sh

````


```Azure VM and cloud-init```

[https://learn.microsoft.com/en-us/azure/virtual-machines/linux/cloudinit-add-user](https://learn.microsoft.com/en-us/azure/virtual-machines/linux/cloudinit-add-user)


````
#cloud-config
users:
  - default
  - name: myadminuser
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh-authorized-keys:
      - ssh-rsa AAAAB3<snip>

````


````
az group create --name myResourceGroup --location eastus

az vm create --resource-group myResourceGroup --name vmName --image imageCIURN \
--custom-data cloud_init_add_user.txt \
--generate-ssh-keys


az vm create --resource-group myResourceGroup \
--name ubuntu2204 --image Canonical:UbuntuServer:22_04-lts:latest \
--custom-data cloud-init.txt \
--generate-ssh-keys

````
