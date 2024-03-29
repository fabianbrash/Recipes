# Note this is the old tkg cli which was replaced by the tanzu cli and deploys what is now called TKGm also as of TKG(m) 1.2 the capv haproxy was replaced with AVI LB

### TKG and TKG CLI information

[Tanzu-VMware Cloud](https://www.virtuallyghetto.com/2020/03/sneak-peak-at-deploying-tanzu-kubernetes-grid-plus-on-vsphere-vmware-cloud-on-aws.html)

[Tanzu](https://cloud.vmware.com/community/2020/03/12/containers-kubernetes-vmcaws-tanzu/)

[Cluster API](https://github.com/kubernetes-sigs/cluster-api-provider-vsphere)

[YT-Video](https://www.youtube.com/watch?v=GxvTtf-1mVo)

### First you need to download the tkg cli tool

[TKG cli download](https://my.vmware.com/web/vmware/details?downloadGroup=TKG-100&productId=988&rPId=45068)

### Grab the photon OS from the above as well as the ova's I downloaded from the below did not work

[Cluster API - vSphere](https://github.com/kubernetes-sigs/cluster-api-provider-vsphere)

### Download the ha-proxy ova as well

### the tkg file is a .gz(why ooh why) so use gunzip to strip off the .gz
### tkg-linux-amd64-v1.0.0_vmware.1.gz will become tkg-linux-amd64-v1.0.0_vmware.1

````
mv tkg-linux-amd64-v1.0.0_vmware.1 tkg
sudo mv tkg /usr/local/bin
````

### the system you run this from must have kubectl and docker installed, you should know how to do that
### also the network that you deploy this into must have DHCP configured

````
tkg init --ui
````

### The above will launch a web browser to localhost:8080
### obvsiously select "Deploy on VSPHERE" and answer all the questions

### If everything went well you should now have a TKG management cluster now let's deploy a guest cluster

````
tkg create cluster tkg-cluster-0 --plan=dev --worker-machine-count=2
````

### for more options tkg create cluster --help

### Let's list our guest clusters

````
tkg get cluster


tkg get mc ## get mgmt cluster
````

### once done the 2 contexts will be merged(I'm not good with k8s contexts yet) if you need get the actual kube-config file
### ssh into the controller VM(s) ssh capv@1.1.1.1 then you can cp /etc/kubernetes/admin.conf again this is upstream k8s

````
##let's now scale our worker nodes
tkg scale cluster tkg-cluster-0 -w 5

##of course we can scale down
tkg scale cluster tkg-cluster-0 -w 1

###Note you must be @ the tkg-mgmt context to operate on tkg guests

##Now let's delete our guest cluster, again make sure you are @ the mgmt context
kubectl config get-contexts
kubectl config use-context "context name"
````

### or you can use kubectx
[kubectx download](https://github.com/ahmetb/kubectx)

````
tkg delete cluster tkg-cluster-0

###We can also delete the mgmt cluster

tkg delete management-cluster
````

### Context issues

#### So I consolidated my contexts and unfortunately I deleted the context file that TKG merged
#### So in your home directory there is a .tkg folder and in there is a config.yaml file @ the end of the file
#### is the name and path to config file that is being used, change it to the new file, but that's not all
#### if you read the error message it's looking for a specific context name in the config file change the name
#### to what its looking for, I have an example in my kubernetes recipe.

### Once I did those 2 things, things started to work again, but now I have to re-merge my config files with the new 
### changes so I can switch contexts(I hope it works)


### Learned you can also do this

````
tkg get credentials czdevtest(this is the name of the cluster) --export-file czdevtest.kubeconfig
````

### Advanced deployments

````
VSPHERE_NUM_CPUS=6 VSPHERE_DISK_GIB=50 vSPHERE_MEM_MIB=16384 tkg create cluster myclust -p prod -c 3 -w 5 --dry-run > /tmp/clust.yaml
````





