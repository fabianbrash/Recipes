```REFS```

[https://github.com/MicrosoftDocs/Virtualization-Documentation/tree/master/windows-container-samples](https://github.com/MicrosoftDocs/Virtualization-Documentation/tree/master/windows-container-samples)

[https://docs.docker.com/engine/reference/builder/#escape](https://docs.docker.com/engine/reference/builder/#escape)

[https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-docker/manage-windows-dockerfile](https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-docker/manage-windows-dockerfile)

[https://medium.com/@sebagomez/windows-containers-personal-cheat-sheet-95c1c4d6bdf5](https://medium.com/@sebagomez/windows-containers-personal-cheat-sheet-95c1c4d6bdf5)

[https://www.red-gate.com/simple-talk/sysadmin/containerization/working-windows-containers-docker-save-data/](https://www.red-gate.com/simple-talk/sysadmin/containerization/working-windows-containers-docker-save-data/)

[https://www.linuxjournal.com/content/everything-you-need-know-about-linux-containers-part-i-linux-control-groups-and-process](https://www.linuxjournal.com/content/everything-you-need-know-about-linux-containers-part-i-linux-control-groups-and-process)

[https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes](https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes)


```URLs```

[https://getcarina.com/docs/tutorials/data-volume-containers/](https://getcarina.com/docs/tutorials/data-volume-containers/)

```Get an image```

````
docker pull 'image name'
````

```Spawn a container from an image```

````
docker run 'image name'
````

```List all containers```

````
docker ps
docker ps -a (List even containers that are not running)
````

```List volumes```

````
docker volume ls
````

```Stop Container```

````
docker stop 'container ID or container name'
````

```Delete Container```

````
docker rm 'container ID or container name' -f(force)
####Delete an image#########
docker rmi 'image name | ID' -f

sudo docker stats
````

```The rest can be found around the web```

#### NOW let's do something interesting

````
docker run --name mycontainer --hostname mycontainer.org -d -p 80:80 --restart always --volume /srv/myapp/folderA:/opt/myapp/folderA:Z --volume /srv/myapp/folderB:/opt/myapp/folderB:Z 'image name or image ID'
####What's happing here
#### we are running a container with a friendly name of mycontainer and a hostname of mycontainer.org it's also detached(-d) and we are
mapping port 80 on the host with port 80 on the container we want the container to restart with the host(--restart always) and then
we get to the complex bit and that's how we are going to persist our cotainers storage what we are effectively doing here is using or 
photonOS or whatever linux host you are using as a DVC(Data Volume container) check here:https://getcarina.com/docs/tutorials/data-volume-containers/
what that means is that we are going to use our host as the persistent storage for our container and we are mapping the host
storage to the container storage i.e. /srv/myapp/folderA:/opt/myapp/folderA:Z(the:Z is for SELinux if it's on you need that)
The app venfor will usually list what folders need to be persisted---what this does is allow us to use in my case photonOS as a VM
and then I can backup at the VM level and I will be able to recover lost data...COOL
also we can create a container whose sole purpose is to be a DVC you could do this
docker run --name data -v /opt/splunk/etc -v /opt/splunk/var busybox
the above will create a new container using busybox as the base image and create the above mount points\
now we can do this
docker run --name myapp --volumes-from=data
For me the above is a more complex way of adding persistence to a container I prefer using the vm as the DVC so I just need to backup
the VM.
````

```Shell into a container```

````
docker exec -it 'containerID or name' /bin/bash
exit to quit

###also###
docker run -it --rm --name login local/loginui:1.0 sh
````


```LET'S SETUP SOME NETWORKING IN DOCKER```

````
sudo docker create network --driver=bridge br0
sudo docker run -d --name container1 --network=br0 mongo
````


#####GETTING DOCKER ON CENTOS7.X#########################################
###FIRST REMOVE THE OLD DOCKER IF YOU HAVE IT#####################
sudo yum remove docker docker-common container-selinux docker-selinux docker-engine

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum makecache fast

sudo yum install -y docker-ce

###########OPTIONAL EDGE BUILDS####################
sudo yum-config-manager --enable docker-ce-edge

###DISABLE EDGE BUILDS#################
sudo yum-config-manager --disable docker-ce-edge

################PLEASE NOTE##################3
#if you installed docker with the below command
sudo yum install docker -y
#####and then you remove it and intalled with the following command
sudo yum install -y docker-ce
###MAKE CERTAIN TO DELETE ALL IMAGES PRIOR AS YOU MIGHT HAVE ISSUES DELETING IMAGES THAT WERE PULLED FROM THE FIRST INSTALL###

###INSTALL INSTRUCTIONS FOR CENTOS#####
#https://docs.docker.com/engine/installation/linux/centos/#install-using-the-repository

#####RPM's are here###############
#https://download.docker.com/linux/centos/7/x86_64/stable/Packages/


######BUILDING YOUR FIRST DOCKER IMAGES##########################
sudo docker build -t firstimage . (the . denotes where your Dockerfile is in this case in the current working directory)

####Now let's push it to docker hub#############
docker login

##let's tag our image
docker tag firstimage your_docker_username/firstimage:1.0

##now let's push it
docker push your_docker_username/firstimage:1.0


##########SAMPLE DOCKER FILE#####################

FROM php:7.1.3-apache
COPY src/ /var/www/html/
EXPOSE 80


FROM nginx:1.11.13-alpine
COPY /html5up-forty/ /usr/share/nginx/html
EXPOSE 80



######SAMPLE DOCKER COMPOSE FILE################################
######docker-compose.yml#######################################

version: '2'

services:
  web:
    image: nginx:1.12.0-alpine
    ports:
      - "3000:80"

  cache:
    image: redis:3.2.8-alpine
    ports:
      - "6379:6379"
      
######################END CONTENT###########################################################
##Then Run##
sudo docker-compose up -d

##Take down stack###
sudo docker-compose down

########PLEASE NOTE SPACING IS VERY VERY VERY VERY VERY IMPORTANT WITH YML FILES#############

####The above example would launch a stack of 2 services, a nginx web server listening on port 3000 and a cache service that run
####redis on it's standard port of 6379
###Note 'image' and 'ports' must lineup as well as 'volumes' etc...


#####INSTALL DOCKER WINDOWS SERVER 2016#########################
#####Note I installed this on Server 2016 core
###Source: https://docs.microsoft.com/en-us/virtualization/windowscontainers/quick-start/quick-start-windows-server
##Get a Powershell Prompt
PS> Install-Module -Name DockerMsftProvider -Repository PSGallery -Force
PS> Install-Package -Name docker -ProviderName DockerMsftProvider (Select 'A')
PS> Restart-Computer -Force

###Get Installed Version
PS> Get-Package -Name Docker -ProviderName DockerMsftProvider
##Get Current Version from Repo
PS> Find-Package -Name Docker -ProviderName DockerMsftProvider

###Upgrade Docker##################
PS> Install-Package -Name Docker -ProviderName DockerMsftProvider -Update -Force
PS> Start-Service Docker


######Install docker Windows Server 2019###########
##REF:https://blog.sixeyed.com/getting-started-with-docker-on-windows-server-2019/
Install-Module -Name DockerMsftProvider -Repository PSGallery -Force

Install-Package -name docker -ProviderName DockerMsftProvider -Force ##You can also add -RequiredVersion 18.03 which would install 18.03
Start-Service -Name docker


######INSTALL DOCKER-COMPOSE WINDOWS####################

####Replace the version with the current version, as of this writing it's 1.13
Invoke-WebRequest "https://github.com/docker/compose/releases/download/1.13.0/docker-compose-Windows-x86_64.exe" -UseBasicParsing -OutFile $Env:ProgramFiles\docker\docker-compose.exe
docker-compose --version
##You should get the version output



####INSTALL DOCKER-COMPOSE LINUX#######################
##You will need to su first
su -
curl -L https://github.com/docker/compose/releases/download/1.13.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
exit su

###If you are on a custom linux flavor like say photonOS you can just do this instead
##got to: https://github.com/docker/compose/releases
curl -O -L https://github.com/docker/compose/releases/download/1.13.0/docker-compose-Linux-x86_64
mv docker-compose-Linux-x86_64 docker-compose
su -
cp docker-compose /usr/local/bin && chmod u+x docker-compose
exit

############DOCKER-COMPOSE WINDOWS#########################
####There are slight differences for the Windows platform

##########BEGIN FILE CONTENT##############################

version: '2.1'

services:
  web:
    image: microsoft/iis
    ports:
      - "3000:80"
networks:
  default:
    external:
      name: nat
      

#####END COMPOSE FILE#####################
####Minimum version here has to be 2.1 because of the version of the client and the version of compose that I have
####Also the biggest change is the addition of the default network, compose can't create networks on windows(as of this writing)
###So we have to use an existing network and set it to the default, here a network called 'nat' was created, so we have to use
###it




################SIMPLE APP STACK, MONGODB BACKEND AND A NODE APP AS THE FRONTEND####################

docker pull mongo:3.4.4

docker run -d --name mymongo mongo:3.4.4

docker pull sdelements/lets-chat

docker run -d --name mylc \
-p 8080:8080 \
-p 5222:5222 \
--link mymongo:mongo \
sdelements/lets-chat

###########END STACK#############################



##############PHOTONOS PERMISSION ISSUES#############
##Deploying a gitlab container on photonOS I had to chmod 0777 /Data in order for docker to have the rights
###to write to the path

##############GITLAB Gmail Email Config################

gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "smtp.gmail.com"
gitlab_rails['smtp_port'] = 587
gitlab_rails['smtp_user_name'] = "blah@gmail.com"
gitlab_rails['smtp_password'] = "password"
gitlab_rails['smtp_domain'] = "smtp.gmail.com"
gitlab_rails['smtp_authentication'] = "login"
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_tls'] = false

###! **Can be: 'none', 'peer', 'client_once', 'fail_if_no_peer_cert'**
###! Docs: http://api.rubyonrails.org/classes/ActionMailer/Base.html
#gitlab_rails['smtp_openssl_verify_mode'] = 'peer'

#####END CONFIG SNIPPET########################



#############GITLAB CONFIG######################
sudo docker exec mygitlab gitlab-ctl reconfigure (after editing gitlab.rb)
sudo docker restart mygitlab

#######Send a test email from gitlab##############
sudo docker exec mygitlab bash

gitlab-rails console

Notify.test_email('blah@gmail.com', 'Message Subject', 'Message Body').deliver_now


###################DOCKER SWARM AND STACKS#########################################
###REF: https://docs.docker.com/get-started/part3/#about-services
###REF: https://docs.docker.com/compose/compose-file/


##Let's have a look at some swarm commands
docker swarm init ##Initialize a swarm
####initialize a swarm with a specific interface(for hosts with multiple NICs)
docker swarm init --advertise-addr 192.168.1.xx 
docker swarm leave ##Leave a swarm
docker swarm join --token 'add token here'
docker swarm join-token manager ## get instructions to join Swarm as a manager
docker swarm join-token worker ## get instructions to join as a worker

docker node ls  #List all nodes in the swarm

##Let's create a service on the fly
docker service create --name redis --replicas=5 redis:3.0.6

docker service create --name redis --constraint 'node.role == worker' --publish 6379:6379 --replicas=5 redis:3.0.6


###Let's deploy a stack###########
docker stack deploy -c stackfile.yml mystack

docker service ls ## list all serivces in the stack
docker stack ps mystack ##List all process from the stack
docker stack ls #List all stacks
docker service logs my_service ##get logs for your service docker service ls will give you your service(s)
docker service logs -f my_service ##tail and follow the logs

##We can destroy our stack with####
docker stack rm my_stack

#################ACTUAL STACK FILE#######################################

version: '3'

services:
  web:
    image: nginx:latest
    ports:
      - "8080:80"
    networks:
      - webfront
    deploy:
      placement:
        constraints: [node.role == manager]
      replicas: 3
      restart_policy:
        condition: on-failure
      update_config:
        parallelism: 2
      resources:
        limits:
          cpus: "0.2"
          memory: 250M
  
  visualizer:
    image: dockersamples/visualizer:stable
    ports:
      - "8090:8080"
    stop_grace_period: 1m30s
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
    networks:
      - webfront


networks:
  webfront:
  
  
#######END FILE###################################


#####STACK FILE SAMPLE VOTING APP############

version: "3"
services:

  redis:
    image: redis:alpine
    ports:
      - "6379"
    networks:
      - frontend
    deploy:
      replicas: 2
      update_config:
        parallelism: 2
        delay: 10s
      restart_policy:
        condition: on-failure

  db:
    image: postgres:9.4
    volumes:
      - db-data:/var/lib/postgresql/data
    networks:
      - backend
    deploy:
      placement:
        constraints: [node.role == manager]

  vote:
    image: dockersamples/examplevotingapp_vote:before
    ports:
      - 5000:80
    networks:
      - frontend
    depends_on:
      - redis
    deploy:
      replicas: 2
      update_config:
        parallelism: 2
      restart_policy:
        condition: on-failure

  result:
    image: dockersamples/examplevotingapp_result:before
    ports:
      - 5001:80
    networks:
      - backend
    depends_on:
      - db
    deploy:
      replicas: 1
      update_config:
        parallelism: 2
        delay: 10s
      restart_policy:
        condition: on-failure

  worker:
    image: dockersamples/examplevotingapp_worker
    networks:
      - frontend
      - backend
    deploy:
      mode: replicated
      replicas: 1
      labels: [APP=VOTING]
      restart_policy:
        condition: on-failure
        delay: 10s
        max_attempts: 3
        window: 120s
      placement:
        constraints: [node.role == manager]

  visualizer:
    image: dockersamples/visualizer:stable
    ports:
      - "8080:8080"
    stop_grace_period: 1m30s
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
    deploy:
      placement:
        constraints: [node.role == manager]

networks:
  frontend:
  backend:

volumes:
  db-data:
  

#####END FILE##########################

#####WP STACK FILE W/SECRETS#######
version: '3.1'

services:

  mysql:
    image: mysql:5.7.21
    ports:
      - "3306:3306"
    volumes:
      - "/mysql:/var/lib/mysql"
    deploy:
      restart_policy:
        condition: on-failure
      resources:
        limits:
          cpus: '0.50'
          memory: 2048M
        reservations:
          cpus: '0.50'
          memory: 2048M
    networks:
      - wpnetwork
    environment:
      - MYSQL_ROOT_PASSWORD_FILE=/run/secrets/my_secret
    secrets:
      - my_secret

  wp:
    image: wordpress
    ports:
      - "80:80"
    volumes:
      - "/wp:/var/www/html"
    networks:
      - wpnetwork
    deploy:
      mode: replicated
      replicas: 3
    environment:
      - WORDPRESS_DB_PASSWORD_FILE=/run/secrets/my_secret
    secrets:
      - my_secret

  visualizer:
    image: dockersamples/visualizer:stable
    ports:
      - "8080:8080"
    stop_grace_period: 1m30s
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
    networks:
      - wpnetwork

secrets:
  my_secret:
    external: true

networks:
  wpnetwork:

###END FILE#############

###WORDPRESS REQUIRES THE DB SERVICE TO BE CALLED 'mysql' I need to learn how to change that
####maybe aliases??


######WORKING WP STACK FILE###################################


version: '3.1'

services:

  mysql:
    image: mysql:5.7.21
    ports:
      - "3306:3306"
    volumes:
      - "/mysql:/var/lib/mysql"
    deploy:
      restart_policy:
        condition: on-failure
      resources:
        limits:
          cpus: '0.50'
          memory: 2048M
        reservations:
          cpus: '0.50'
          memory: 2048M
      placement:
        constraints: [node.role == manager]
    networks:
      - wpnetwork
    environment:
      - MYSQL_ROOT_PASSWORD_FILE=/run/secrets/my_secret
    secrets:
      - my_secret

  wp:
    image: wordpress
    ports:
      - "80:80"
    volumes:
      - "/wp:/var/www/html"
    networks:
      - wpnetwork
    deploy:
      restart_policy:
        condition: on-failure
      update_config:
        parallelism: 3
      resources:
        limits:
          cpus: '0.25'
          memory: 128M
        reservations:
          cpus: '0.25'
          memory: 128M
      mode: replicated
      replicas: 5
    environment:
      - WORDPRESS_DB_PASSWORD_FILE=/run/secrets/my_secret
    secrets:
      - my_secret

  visualizer:
    image: dockersamples/visualizer:stable
    ports:
      - "8080:8080"
    stop_grace_period: 1m30s
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
    deploy:
      placement:
        constraints: [node.role == manager]
    networks:
      - wpnetwork

secrets:
  my_secret:
    external: true

networks:
  wpnetwork:


####END FILE################################################

###NOTE IN THE ABOVE I DIDN'T SPECIFY WHERE THE DB WAS BECAUSE THEY ARE IN THE SAME DEFINE NETWORK
###AND THE SERVICE IS CALLED mysql THERE IS SERVICE DISCOVERY, WE JUST NEED TO FEED IT THE SECRET FOR THE DB PASSWORD



##########DOCKER PERMISSIONS#####################################
##SO THE ABOVE STACK GAVE ME SOME ISSUES AND ALL RELATED TO PERMISSION###################
##It's always a good idea to check the docker file to see if there are any special permissions
##A LA jenkins that requires a user called jenkins with an id of 1000
##Wordpress uses the www-data user so that user must have R/W to the folder on the container host
##So what I did on photonOS was to create a group called 'docker' and assign it a GID of 999
##Then I created a group called 'www-data' and gave it a GID of 33
##Then a user called www-data ID of 33 and added the www-data user to the www-data group
##Now some of this is special for photonOS and I will test this on centOS and update this doc
##Then I gave www-data R+W to the folder that was exposed to the container
##Ex. -v /wp:/var/www or volume: - "/wp:/var/www"

##############CADVISOR############################################################################
##The ID's for docker in cadvisor are the container ID's this can be confusing if your stack has
##multiple replicas
docker ps -a 


##########DOCKER VOLUME COMMANDS#########################
docker volume create jenkins ##create a volume using default options
docker volume ls ##list all volumes

##Run a container using the volume###

docker run -d --name jdv -p 8080:8080 -p 50000:50000 \
-v jenkins:/var/jenkins_home \
de9cce074248



####Migrate to another volume############
##stop and destroy the above container
docker stop jdv && docker rm -f jdv

docker volume create jenkins2
cd /var/lib/docker/volumes/jenkins/data
cp -Rp . /var/lib/docker/volumes/jenkins2/_data ##-R(recursive) p(copy permissions)
docker volume rm jenkins

##Run a container using the new volume###

docker run -d --name jdv -p 8080:8080 -p 50000:50000 \
-v jenkins2:/var/jenkins_home \
de9cce074248



########MONGO WITH AUTHENTICATION################


docker run -d -p 27017:27017 --name mongo -v mongodata:/data/db -e MONGO_INITDB_ROOT_USERNAME='mongoadmin' -e MONGO_INITDB_ROOT_PASSWORD='secret_pass' 5651314706c2

#####NOTE THIS CAN ALSO BE DONE WITH SECRETS##########################



###############SIMPLE TRICK TO USE NFS WITH DOCKER CONTAINER###################################
#############NOTE THE PERFORMANCE OF THIS MIGHT BE TERRIBLE SO NO GOOD FOR PRODUCTION######
##REF: https://blog.leandot.com/2017/03/24/changing-storage-location-for-docker-volume.html

####Mount the NFS share on the container host
mkdir /nfs
mount -t nfs nfsIP_OR_DNS:/path /nfs

###CentOS install location of docker; check your linux distro
cd /
sudo find . -name docker

cd /var/lib/docker/volumes/
ln -s /nfs nfsserver ##volume-name
docker volume create --name nfsserver

##And now your files will be on the remote nfs server



###I USED THE DOCKER VOLUME PLUGIN FROM VMWARE AND I COULDN'T FINE WHERE MY DATA WAS, THEN I FIGURED IT OUT######
cd /var/lib/docker/plugins/'unique id will be here'/propagated-mount/your_volume_name@vsanDatastore

###Note the above assumes the use of vmware's photonOS for your docker host and I am using vSAN for my clusted storage



###SAMPLE DOCKERFILE##########################

##Contents of Dockerfile###########

FROM centos:7

RUN yum upgrade -y && yum install wget curl perl python -y

RUN mkdir /test
WORKDIR /test
COPY test.html .

EXPOSE 8080

CMD ["python", "-m", "SimpleHTTPServer", "8080"]


#####Let's get our docker process ID#####
##REF:https://docs.docker.com/engine/reference/commandline/ps/
docker ps --format {{".ID"}}

##We can store it in a variable###
containerid=$(docker ps --format {{".ID"}})
echo $containerid

##Let's get our service####
##REF:https://docs.docker.com/engine/reference/commandline/service_ls/
docker service ls --format {{".Name"}}
servicename=$(docker service ls --format {{".Name"}})

####Docker Swarm##################

docker service scale myservice=6
docker service scale myservice=1

###Run a command in a running container

docker exec -it container_NAME_OR_ID /usr/local/vmware-umds/bin/vmware-umds -D



###Clean up docker ############
##REF:https://docs.docker.com/engine/reference/commandline/system_prune/

docker system prune

docker system prune -f ##do not ask for permission


#####Swarm restart issues#################
##So I had an issue with a container I built it usesd nginx and when I rebooted the host the container
##failed to restart when I used docker run and set --restart always everything worked fine
##in my stack file I had restart_policy condition:on-failure
##I also had another stack that used python simplehttpserver and when I rebooted the host that stack came back up
##no issues, well I finally figured it out when nginx exited it exited with a 0 exit code(exited(0)) which
##will never restart the container because there was no failure so I changed the restart_policy to condition:any
##so be careful how your container exits because if they container does not fail and your condition
## is 'on-failure' then you are crap out of luck, note the default policy is 'any'


#########Specifying users in docker#####################
REF#https://stackoverflow.com/questions/27701930/add-user-to-docker-container

docker exec -it -user myuser containerid command


#####Docker storage issues#####################
##REF:https://docs.docker.com/storage/bind-mounts/
##using the -v /hostdata:/containerdata will only work if the containerdata is an empty folder
##if you say use /hostdata:/usr/sbin you will get an empty folder and the container will break
##note is you use a named volume you can do the above i.e. docker volume create container_sbin
##it seems this has been working for me out of dumb lock as I have been bind mounting directories in the container
##that were empty, so the question is how does docker want us to persist data
##Use a vendors volume driver, or we shouldn't be messing with the files in a container like /etc /usr ...
##But if that's the case then why does it work with a named volume.


###Using docker volume create on a device####

####First add a new disk to your VM or physical server and format I will use the example of
##/dev/sdb is the device and /dev/sdb1 is the ext4 partition
##then you can do this


docker volume create --driver local --opt type=ext4 --opt device=/dev/sdb1 volumedevice

##Now when you run docker volume inspect you will see that the mount point is still /var/lib/docker/volumes...

##Now do this

docker run -d -it --name sdb volumedevice:/data centos:7
docker exec -it sdb bash

cd /data

####This will also work####
docker volume create --driver local \
      --opt type=none \
      --opt device=/home/user/test \
      --opt o=bind \
      test_vol


###Now anything you save to /data will be stored on your physical device /dev/sdb
##Test with

dd if=/dev/zero of=text2.txt count=1024 bs=2048576
###create a few files and confirm that /dev/sdb1 is being filled up


##Get container ID###
docker ps --format {{".ID"}}


######docker history######
###REF:https://social.msdn.microsoft.com/Forums/en-US/eeba07f5-1ee1-41cb-b003-4fb2919e8bef/update-windows-containers?forum=windowscontainers
###This is quite helpful for windows containers to see what updates have been applied to the container image
##REF:https://docs.docker.com/engine/reference/commandline/history/


docker history <IMAGE ID or image name>
docker history --no-trunc <IMAGE ID or image name>
docker history --no-trunc --format "{{.ID}}: {{.CreatedBy}}" <IMAGE ID or image name>

####ELASTICSEARCH AND Container Host configuration####
###Note the below is only good as long as the system does not reboot
##To persist on most version of linux this should be located @ /etc/sysctl.conf
##Also check /proc/sys
##Note on photonOS that file does not exist
###I had issues with elasticsearch and memory you have to run the following command in linux

sysctl -w vm.max_map_count=262144

sysctl -p

sysctl --help

##The above worked on ubuntu, shoud work on centos and I will test on photonOS(sysctl is available 
###on photonOS so the above works)
##REF:https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html


###Running containers on port 53####
##So I had an issue running coredns on port 53 turns out that photonOS
##uses systemd-resolved, so you need to stop that service so you can bind on udp 53
systemctl stop systemd-resolved


##docker attach###
docker attach containername


##docker cp###

docker cp id_rsa.pub container1:/data

##Log rotation##
#REF:https://success.docker.com/article/how-to-setup-log-rotation-post-installation

cd /etc/docker
touch daemon.json

##Add the below

{
"log-driver": "json-file",
"log-opts": {
    "max-size": "10m",    
    "max-file": "3"    
    }
}

##This will apply to new containers not old ones so either restart all your containers or do this before
##running your first container

sudo systemctl restart docker



#####Docker save command###
##So I shot my self in the foot the other day, I use coredns as my dns in my homelab and I wanted to update the container
##to the latest version, so I stopped the container, deleted it and deleted the image, and then I attempted
##to download the lates image with docker pull, well see my issue, I have no DNS ANYMORE!!!
##Well docker save and docker load to the rescue

##On my laptop I simply pointed my dns to my router and then did a docker pull 
##Then I ran the below which saves the docker image to a tar file

docker save -o coredns-1.6.9.tar coredns/coredns:1.6.9

scp coredns-1.6.9.tar user@host:/

##then simply

docker load < coredns-1.6.9.tar

##Now my container host has the image and then I can run as usual

### Docker cred location #####

ls -la ~/.docker 

##File is called config.json


### Ran into an issue when building a dockerfile during the build it had to install tzdata which prompted for a question
#### I looked around and found that some installers will have a little TUI so we need to turn that off

````

FROM ubuntu:20.04

LABEL maintainer="Fabian Brash"

RUN apt-get update && apt-get upgrade -y && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --no-install-suggests -y \
curl \
ca-certificates \
dnsutils \
git \
hping3 \
iputils-ping \
net-tools \
nmap \
wget \
vim

````

#### Note the 'DEBIAN_FRONTEND=noninteractive' before we install out packages, some folks complained that did not work for them, so here is the thread

[Dockerfiles and packages that prompt](https://askubuntu.com/questions/909277/avoiding-user-interaction-with-tzdata-when-installing-certbot-in-a-docker-contai)


