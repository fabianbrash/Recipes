## Installing Harbor Registry in a lab environment

### Deploy a linux flavor I used Ubuntu and then install docker and docker-compose

## Harbor docs are [here](https://goharbor.io/docs/2.0.0/install-config/download-installer/)

### Grab a release from [here](https://github.com/goharbor/harbor/releases)

### Configure your YML file I have a sample I used [here](https://github.com/fabianbrash/YAML/blob/master/harbor.yml)

### Docs on how to configure is [here](https://goharbor.io/docs/2.0.0/install-config/configure-yml-file/)

##

### Then run the install script docs [here](https://goharbor.io/docs/2.0.0/install-config/run-installer-script/) by default now Harbor installs with trivy as it's security scanner

### `` NOTE ``
### I thought trivy was configured by default but apparently not, so the command to use is

````
sudo ./install.sh --with-trivy
````
### You might have to cleanup before you install so just do the below, make sure you know where your data resides

````
docker-compuse down
````

##

### That should be it


