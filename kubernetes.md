
#### My kubernetes journey

[https://kubernetes.io/docs/tasks/](https://kubernetes.io/docs/tasks/)

[https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.17/#-strong-api-overview-strong-](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.17/#-strong-api-overview-strong-)

[https://kubernetes.io/blog/2019/07/18/api-deprecations-in-1-16/](https://kubernetes.io/blog/2019/07/18/api-deprecations-in-1-16/)

[https://kubernetes.io/docs/reference/](https://kubernetes.io/docs/reference/)

[https://mauilion.dev/posts/kind-metallb/](https://mauilion.dev/posts/kind-metallb/)


````
kubectl version
kubectl version --short
kubectl api-versions

kubectl get apiservices

kubectl get apiservice| grep False

kubectl version --client --short

kubectl get namespaces
kubectl get namespaces -A ##get all namespaces even system namespaces by default all your pods are created in the default namespace
kubectl get pods
kubectl get deployments
kubectl get services or kubectl get svc

kubectl get all -o wide

watch kubectl get all -o wide

kubectl get events # get all events
````

## Label a node

````
kubectl label node mymode1 ssdpresent=true
````


## find nodes with a label

````
kubectl get nodes -l ssdpresent=true 

kubectl get node node1 --show-labels

kubectl get ingress
#or 
kubectl get ing 
kubectl describe ing 
````


## Get current context

````
kubectl config view
kubectl config current-context

kubectl config get-contexts

kubectl get - list resources
kubectl describe - show detailed information about a resource
kubectl logs - print the logs from a container in a pod
kubectl exec - execute a command on a container in a pod
````

#### After you create a deployment you can create a service so external users can access it
## But first after we deploy our deployment lets get the IP of the pods

````
kubectl get pods -o wide
````

````
### or to specify a label from our deployment
kubectl get pods -l app=nginx -o wide

##you can expose the service with
kubectl expose deployment/nginx-deployment

##Or you can do 
kubectl expose deployment mydeployment --type=NodePort

##or with a yaml file check my yaml repo

####Run a simple deployment without a yaml file
kubectl run kubernetes-bootcamp --image=gcr.io/google-samples/kubernetes-bootcamp:v1 --port=8080

kubectl run myshell -it --image busybox -- sh 

kubectl run myshell -it --rm --image busybox -- sh 

#Also
kubectl create deployment ng1 --image=nginx:stable-alpine

kubectl scale deployment ng1 --replicas 2

kubectl run ng1 --image=nginx --replicas 2

##OR the new way

kubectl run --generator=run-pod/v1 busybox --image=busybox:1.28

#then we can do this
kubectl expose deploy ng1 --port 80 --type= NodePort
````


#### delete the deployment

````
kubectl get deployments
kubectl delete deployement 'our deployment name'

##Also let's delete deployment and service for ng1 and ng2##
kubectl delete deployment,service ng1 ng2

kubectl delete pod mypod 
#note the above only works if you created the pod with
#a yaml file and the type was pod, if you use
#kubectl run ... this actually creates a deployment
#on the fly so you will have to use kubectl delete deployment 


###you can run the kubectl proxy command but it's best to look at services
kubectl proxy ##run in a different terminal
curl http://localhost:8001/version

kubectl port-forward podname 8080:80


###delete deployment
kubectl delete deployment my-deployment
````

### Create a custom namespace

[https://www.assistanz.com/steps-to-create-custom-namespace-in-the-kubernetes/](https://www.assistanz.com/steps-to-create-custom-namespace-in-the-kubernetes/)

````
kubectl create namespace mynamespace

##services##
#we can edit a service with
kubectl edit svc ng1
#also if we are editing a service in a different namespace 
kubectl -n mynamespace edit svc ng1 

kubectl -n kube-system get pod coredns-345ab -o yaml 

kubectl edit namespace dev

kubectl get cs ##component status

kubectl get pv # get persistence volume

kubectl exec pod/container name ls 

````

```YAML```

````
apiVersion: v1
kind: Namespace
metadata:
   name: mynamespace
   
````

### Deploy a pod into our namespace

````
kubectl run ns-pod --image=nginx --port=80 --generator=run-pod/v1 -n mynamespace

kubectl get pods --namespace mynamespace

##Delete the pods in the namespace
kubectl delete pods --all --namespace mynamespace

##Delete namespace
kubectl delete namespace mynamespace

kubectl describe podname 

#get all pods with the label run=ng1
kubectl get pods -l run=ng1 

kubectl scale deployment ng1 --replicas=3

````

### To get kubectl up and running you need to copy the admin.conf file from
#### /etc/kubernetes on one of the master nodes into a directory ~/.kube
#### in your home directory and then you need to rename admin.conf to config

#### the above will scale our deployment but u should update your YAML file


#### Add to our .kube/config so we can switch namespaces

[https://kubernetes.io/docs/tasks/administer-cluster/namespaces-walkthrough/](https://kubernetes.io/docs/tasks/administer-cluster/namespaces-walkthrough/)

```Get current context```

````
kubectl config view
kubectl config current-context
````

#### You populate the below from the results of the 2 commands above

````
kubectl config set-context dev --namespace=development \
  --cluster=lithe-cocoa-92103_kubernetes \
  --user=lithe-cocoa-92103_kubernetes

kubectl config set-context prod --namespace=production \
  --cluster=lithe-cocoa-92103_kubernetes \
  --user=lithe-cocoa-92103_kubernetes


kubectl config view

kubectl config use-context dev

kubectl config current-context

####Now switch to prod
kubectl config use-context prod

##Set context to ns elastic-stack
kubectl config set-context --current --namespace=elastic-stack
````


### Rolling upgrades

````
kubectl rollout status deployment my-deploy

kubectl rollout history deploy my-deploy

kubectl set image deploy my-deploy nginx=1.15  ##upgrade the version of nginx in our deployment

kubectl annotate deploy my-deploy kubernetes.io/change-cause="Updated to version 1.15" ## annotate the change

##Or###
kubectl set image deploy my-deploy nginx=1.15 --record

kubectl rollout history deploy my-deploy --revision 1  ##lookup revision 1

##Undo a rolling upgrade and specify to what revision

kubectl rollout undo deploy my-deploy --to-revision=2 

###Pause rollout

kubectl rollout pause deploy my-deploy
kubectl rollout resume deploy my-deploy
````

```Create a registry pull secret```

````
kubectl create secret generic harborcred \
    --from-file=.dockerconfigjson=/home/myuser/.docker/config.json \
    --type=kubernetes.io/dockerconfigjson
````


````

kubectl create secret docker-registry my-secret --docker-server=DOCKER_REGISTRY_SERVER --docker-username=DOCKER_USER
--docker-password=DOCKER_PASSWORD --docker-email=DOCKER_EMAIL



kubectl create secret docker-registry harbor-creds --docker-server=https://harbor.fbclouddemo.us --docker-username=tapuser --docker-password="mypassword"

````

#### Note in the above email is optional

```KUBERNETES INSTALL NOTES```

#### I will turn this into a bash script soon and then hopefully an ansible playbook

[https://github.com/justmeandopensource/kubernetes/blob/master/docs/install-cluster.md](https://github.com/justmeandopensource/kubernetes/blob/master/docs/install-cluster.md)

````
su -

##edit hosts file
cat >>/etc/hosts<<EOF
192.168.50.104 k8master.itbu.ad.enterprise.com k8master
192.168.50.105 k8worker01.itbu.ad.enterprise.com k8worker01
EOF

##Install docker
yum install -y yum-utils device-mapper-persistent-data lvm2

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

yum install -y docker-ce

systemctl enable docker
systemctl start docker

##disable selinux
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux

##Ubuntu 18.04
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

##By defualt it seems 18.04 is set to permissive which should work for us

##Disable firewalld
systemctl disable firewalld
systemctl stop firewalld

##Disable swap
sed -i '/swap/d' /etc/fstab
swapoff -a

##Update sysctl settings for Kubernetes networking

cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system


###Note the above is not required on Debian based systems i.e. Ubuntu, to make sure 
sysctl net.bridge.bridge-nf-call-iptables
sysctl net.bridge.bridge-nf-call-ip6tables


##Kubernetes Setup

##Add yum repository
##Note the indentation for gpgkey is vital or this will fail installing kubelet

cat >>/etc/yum.repos.d/kubernetes.repo<<EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

##Install kubernetes
yum install -y kubeadm kubelet kubectl

## Enable and Start kubelet service
systemctl enable kubelet
systemctl start kubelet


##Initialize Kubernetes Cluster

kubeadm init --apiserver-advertise-address=192.168.50.104 --pod-network-cidr=10.244.0.0/16


##Run the command as root our using sudo

kubeadm join 192.168.50.104:6443 --token jpffga.v6rwru1tv5euqj2n \
    --discovery-token-ca-cert-hash sha256:df00931ffc172d6206eeccf9edf40ca632e7ce6ebeed2eab4e5b2989b4481976



###Copy kube config
##To be able to use kubectl command to connect and interact with the cluster, the user needs kube config file.

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

##Deploy flannel network
##this is done with the above user
##Note if you have more than 1 interfaces then you will have to first download the yml file and make an edit to it
## find --iface and set to eth1(or whatever)
##modified yml file @ 


####Look for
containers:
      - name: kube-flannel
        image: quay.io/coreos/flannel:v0.10.0-amd64
        command:
        - /opt/bin/flanneld
        args:
        - --ip-masq
        - --kube-subnet-mgr
        - --iface=eth1
###################################################################



https://raw.githubusercontent.com/justmeandopensource/kubernetes/master/vagrant-provisioning/kube-flannel.yml

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml



###Cluster join command
##If you didn't save the output from the cluster creation
kubeadm token create --print-join-command
````

#### ALL done

````
kubectl get pods
kubectl version --short
kubectl get componentstatus or kubectl get cs


###kubectl run interactive####
kubectl run -i --tty busybox --image=busybox --restart=Never -- sh

##The above is equivalent to docker run -it busybox sh

## this also works

kubectl exec -it nfs-nginx-766d4bf45f-jn4b6 bash

## also 

kubectl run myshell -it --rm --image=busybox -- sh # this gave me issues but the above worked
````

#### Be careful you don't create a deployment instead of a pod note if you create a deployment
#### then the pod won't be called myshell but instead myshell-xyz so you can't shell into myshell
#### because it doesn't exist


```Drain a node```

````
kubectl drain worker-0
````

#### The difference between port and target port

[https://matthewpalmer.net/kubernetes-app-developer/articles/kubernetes-ports-targetport-nodeport-service.html](https://matthewpalmer.net/kubernetes-app-developer/articles/kubernetes-ports-targetport-nodeport-service.html)

#### obviously NodePort: xxx is the port we use to access our service from outside of our k8s cluster
#### "port" is the port that services inside the cluster can communicate on to your svc
#### and "targetPort" is the port that the container is actually listening on

```Example```

````
ports:
  - nodePort: 32321
    port: 443
    targetPort: 8443
````

#### The above sample says we can access the svc externally on 32321 i.e. http://worker-0:32321
#### the "port" says within the k8s cluster other pods/deployments/anything can access on port 443
#### and "targetPort" is the actaully exposed port in the container 8443 so if another pod 
#### within the cluster accesses the deployment/pod on 443 it should roll to 8443 on the target pod(s)

```Create a config file for a user```

````
kubectl --kubeconfig john.kubeconfig config set-cluster mycluster --server https://IP_OF_API_SERVER:6443 --certificate-authority=ca.crt
kubectl --kubeconfig john.kubeconfig config set-credentials john --client-certificate /home/john/john.crt -client-key /home/john/john.key
kubectl --kubeconfig john.kubeconfig config set-context john-kubernetes --cluster mycluster --namespace finance --user john
````

#### Note if you look at john.kubeconfig and the current-context is not set you need to set it

````
current-context: john-kubernetes

##and then save it and give it to john
````

```Create a role```

````
kubectl create role john-finance --verb=get --verb=list --verb=watch --resource=pods --namespace=finance

##Or

apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: finance
  name: john-finance
rules:
- apiGroups: [""] # "" indicates the core API group
  resources: ["pods"]
  verbs: ["get", "watch", "list"]



kind: Role
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  namespace: finance
  name: john-finance
rules:
- apiGroups: ["", "extensions", "apps"]
  resources: ["deployments", "replicasets", "pods"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"] # You can also use ["*"]
  
````
  
```Create a role-binding```

````
kubectl create rolebinding john-finance-rolebinding --role=john-finance --user=john --namespace=finance

##Or

kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: john-finance-rolebinding
  namespace: finance
subjects:
- kind: User
  name: john
  apiGroup: ""
roleRef:
  kind: Role
  name: john-finance
  apiGroup: ""
````

#### Note a role called john-finance has to exist to do this


#### So I had an interesting issue when deploying golang and alpine in my k82 cluster the image would get pulled and then it would go into a crash loop, but if I ran and nginx or a mariadb pod, everything was fine, then it hit me thise images are minimal the do nothing unlike docker where you would see 'exited' k8s just goes in a loop trying to restart the pod(odd since this was a pod spec why didn't it just start and then terminate the pod, maybe the default restart policy is in play here) anyways the fix was to run the pod with a sleep of 10000 and viola it worked.


```K8s RBAC```

````
kubectl auth can-i create pods
kubectl auth can-i create services
kubectl auth can-i create deployments

kubectl auth can-i create pods --as=john
kubectl auth can-i list pods --as=john

````

##### You get the idea



```Kubernetes secrets```

[https://kubernetes.io/docs/concepts/configuration/secret/#creating-a-secret-manually](https://kubernetes.io/docs/concepts/configuration/secret/#creating-a-secret-manually)

#### PAY VERY CLOSE ATTENTION TO HOW THE PASSWORD IS ENCODED FROM THE ABOVE REF 

````
echo -n 'admin' | base64

echo -n '1f2d1e2e67df' | base64
````

```Kubernetes has the ability to sign certificates```

[https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster/](https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster/)

````
kubectl get csr --all-namespaces

kubectl get csr

kubectl certificate approve css-saa
````

#### NOTE THE -n WITHOUT WHICH STANDS FOR 'do not output trailing new line'
### WITHOUT THAT YOU'RE PASSWORDS WILL BE WRONG I USED THIS FOR A MARIADB INSTANCE
## AND I MADE THE MISTAKE OF NOT USING -n AND EVERY TIME I ATTEMPTED TO LOGIN IN A GOT INCORRECT PASSWORD


```TLS Secrets```

````
kubectl create secret tls ${CERT_NAME} --key ${KEY_FILE} --cert ${CERT_FILE}

##example
kubectl create secret tls my_cert --key cert-key.pem --cert cert.pem
````



```Contexts```

[https://kubernetes.io/docs/reference/kubectl/cheatsheet/#kubectl-context-and-configuration](https://kubernetes.io/docs/reference/kubectl/cheatsheet/#kubectl-context-and-configuration)

[https://ahmet.im/blog/mastering-kubeconfig/](https://ahmet.im/blog/mastering-kubeconfig/)

[https://www.jacobtomlinson.co.uk/posts/2019/how-to-merge-kubernetes-kubectl-config-files/](https://www.jacobtomlinson.co.uk/posts/2019/how-to-merge-kubernetes-kubectl-config-files/)

````
kubectl config view # Show Merged kubeconfig settings.

# use multiple kubeconfig files at the same time and view merged config
KUBECONFIG=~/.kube/config:~/.kube/kubconfig2 

kubectl config view

# get the password for the e2e user
kubectl config view -o jsonpath='{.users[?(@.name == "e2e")].user.password}'

kubectl config view -o jsonpath='{.users[].name}'    # display the first user
kubectl config view -o jsonpath='{.users[*].name}'   # get a list of users
kubectl config get-contexts                          # display list of contexts 
kubectl config current-context                       # display the current-context
kubectl config use-context my-cluster-name           # set the default context to my-cluster-name

# add a new user to your kubeconf that supports basic auth
kubectl config set-credentials kubeuser/foo.kubernetes.com --username=kubeuser --password=kubepassword

# permanently save the namespace for all subsequent kubectl commands in that context.
kubectl config set-context --current --namespace=ggckad-s2

# set a context utilizing a specific username and namespace.
kubectl config set-context gce --user=cluster-admin --namespace=foo \
  && kubectl config use-context gce
 
kubectl config unset users.foo # delete user foo



##Let's merge all of our config files to 1 master 1, make sure to backup your config file first

KUBECONFIG=~/.kube/config:/path/to/new/config kubectl config view --flatten > ~/.kube/config
````

```Duplicate users```

#### You will also probably also run into clusters with the same name and if you attempt to switch everything will looke fine until you run the kubectl command and you get unauthorized error it depends on the order you combined your file, the first 1 will win so you will be able to connect to the first cluster but get an error for the second, to fix just do the below

[https://imti.co/kubectl-remote-context/](https://imti.co/kubectl-remote-context/)

````
contexts:
- context:
    cluster: leave as is
    user: change to something else(I use the cluster name)
  name: user@leave original
  ....
  
  users:
  - name: change to the same as user
  ...
  
  
  ##Example
  
  contexts:
- context:
    cluster: leave as is
    user: gke-0
  name: gke-0@leave original
  ....
  
  users:
  - name: gke-0
  ...
  
````


```access api via kubectl```

````

kubectl get --raw "/apis/metrics.k8s.io/v1beta1/nodes"

kubectl get --raw "/apis/metrics.k8s.io/v1beta1/pods"


##show labels

kubectl get ns default --show-labels


####rollout & restart

kubectl rollout restart deploy my-deploy

kubectl rollout restart -n mynamespace

##Annotate a ns

kubectl annotate -n default release=dev
````


```Autoscaling```

[https://cloud.google.com/kubernetes-engine/docs/how-to/horizontal-pod-autoscaling#api-versions](https://cloud.google.com/kubernetes-engine/docs/how-to/horizontal-pod-autoscaling#api-versions)

[https://cloud.google.com/kubernetes-engine/docs/how-to/vertical-pod-autoscaling](https://cloud.google.com/kubernetes-engine/docs/how-to/vertical-pod-autoscaling)

```v2beta2```

````
kubectl edit hpa.v2beta2.autoscaling myhpa

kubectl get hpa.v2beta2.autoscaling myhpa
````

```bash completion```

[https://kubernetes.io/docs/reference/kubectl/cheatsheet/#kubectl-autocomplete](https://kubernetes.io/docs/reference/kubectl/cheatsheet/#kubectl-autocomplete)

````
source <(kubectl completion bash) # setup autocomplete in bash into the current shell, bash-completion package should be installed first.
echo "source <(kubectl completion bash)" >> ~/.bashrc # add autocomplete permanently to your bash shell.
````


#### So I had an issue where I was deleted some namespaces but it just stayed in a terminationg state I left over night and still they were stuck,so after a little Googling I found the below

[https://medium.com/@craignewtondev/how-to-fix-kubernetes-namespace-deleting-stuck-in-terminating-state-5ed75792647e](https://medium.com/@craignewtondev/how-to-fix-kubernetes-namespace-deleting-stuck-in-terminating-state-5ed75792647e)

````
kubectl get namespace fixme -o json > fixme.json

##Then find "kubernetes" under "finalizers" and delete it("kubernetes") leave finalizers array empty

##Then

kubectl replace --raw "/api/v1/namespaces/fixme/finalize" -f fixme.json

###Note according to the article this should work on other resources including pods,deployments,services,etc.
````


```Remove linkerd from deployments```

[https://linkerd.io/2/reference/cli/uninject/](https://linkerd.io/2/reference/cli/uninject/)

````
# Uninject all the deployments in the default namespace.
kubectl get deploy -o yaml | linkerd uninject - | kubectl apply -f -

# Download a resource and uninject it through stdin.
curl http://url.to/yml | linkerd uninject - | kubectl apply -f -

# Uninject all the resources inside a folder and its sub-folders.
linkerd uninject <folder> | kubectl apply -f -

````

```Troubleshoting```

````
kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get --show-kind --show-all --ignore-not-found -n test-ns
````

#### The above might also generate a unknown flag: --show-all


#### But we are looking for below, which looks like linkerd is causing our issue

#### error: unable to retrieve the complete list of server APIs: packages.operators.coreos.com/v1:the server is currently unable to handle the request, tap.linkerd.io/v1alpha1: the server is currently unable to handle the request

````
kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get -n test-ns

kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get --show-kind --show-all --ignore-not-found -n test-ns

#Then from the out put above

kubectl get APIService v1.packages.operators.coreos.com

##This was causing my cluster to not delete namespaces
kubectl delete APIService v1alpha1.tap.linkerd.io
````

```Ingress 503 error```

#### So I moved a deployment,svc,secret,ing from the defauly namespace over to a new namespace and I kept receiving a 503 I couldn't figure it out and then I had a look @ another ingress that was working and then I noticed the issue doing a kubectl describe ing ingname under Rules, Backends in the parenthesis there as nothing for bad ing and for the good ing there were the pod IPs that were behind the deployment, then I realized the the service definition had the wrong selector so it wasn't findin the correct deployment hence no backends to serve up my page, onces fixed everything was good; again garbage in, garbage out.



```KIND & NodePort```

#### So I installed KIND and was having issues getting to an exposed deploy via a service then I found a github comment reminding me About port-forwarding, so the below worked like a champ for me

````
kubectl port-forward --address 0.0.0.0 service/gql 5000:5000
````

#### the above we are port-forwarding on all interfaces the service gql on 5000 on the host and 5000 on the service, note the 0.0.0.0 is required in our case because kind runs inside docker so we can't use the default of 127.0.0.1(loopback) we need it on all interfaces as I am running kind on a headless ubuntu machine and accessing the app via my workstation/laptop


```UPDATE```

#### Since we are going to use port-forward we can make a change to how we deploy the above service I was using the below

````
kubectl expose deploy gql --port=5000 --type=NodePort
````

#### But we can just use

````
kubectl expose deploy gql --port=5000
````

#### The above will create a service of type ClusterIP and then we can just port-forward into it, it's a bit more secure As it does not open up a port on each host, again this is just a little hack for KIND, in a "real" cluster we would Have access to NodePort or even a loadbalancer, or an ingress

````
kubectl get cm -A
````

#### Decode kubernetes dashboard user token I wonder if I just get the secret and do a base64 decode I would get the same result??

````
kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/my-dashboard-svc -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"
````

```ISSUES DELETING HUNG CRD'S```

[https://www.2vcps.io/2019/04/19/namespace-issues-when-removing-crd-operators/](https://www.2vcps.io/2019/04/19/namespace-issues-when-removing-crd-operators/)

````
kubectl patch crd/contours.operator.projectcontour.io -p '{"metadata":{"finalizers":[]}}' --type=merge

kubectl delete crd contours.operator.projectcontour.io
````

```Get endpoints```

````
kubectl get endpoints -n fabianbrash-com
kubectl get endpoints -A
kubectl get endpoints
````


```Webhook best practices```

#### So in DO they have a Linter to check your cluster before an ugrade and I kept getting webhook errors so I finally decided to To dig into it and see what I could fix, and in there documentation they had 2 recommendations

````
1. Webhook timeouts should be less than 30 seconds

kubectl get validatingwebhookconfigurations
kubectl get mutatingwebhookconfigurations
````

#### The above will get you all your webhooks, look at them and see what the timeouts are configured for and change as per best practice < 30s

````
2. Failure Policy should be set to 'Ignore'

##Again run the kubectl command and fix any webhook that doesn't have an 'Ignore'

### Set default storage class

kubectl patch storageclass gold -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

### the above assumes a storage class called 'gold' has already been deployed in the cluster

kubectl get sc

## OR you can do this
````

````
kubectl edit my-sc

...
metadata:
  annotations:
    some annotion
    some other annotatiom
    storageclass.kubernetes.io/is-default-class: "true"
````

#### Create a clusterrolebinding imperatively, also here we have LDAPS configured in our k8s cluster

````
kubectl create clusterrolebinding rbac-admin --clusterrole cluster-admin --user user@addomain

````

#### Cleaning up

````

kubectl config get-contexts


kubectl config unset clusters # this will delete all clusters and delete your config file

cat /home/user/.kube/config # have a look at your kubeconfig file and then start unsetting contexts, clusters, and users 

kubectl config unset contexts.tap-onprem-admin@tap-onprem. #unset context first, then look at your ~/.kube/config file and unset cluster(s) then user(s)

kubectl config unset clusters.tap-onprem #from kubeconfig file

kubectl config unset users.tkg-mgmt-1-admin #from kubeconfig file


````

[https://stackoverflow.com/questions/37016546/kubernetes-how-do-i-delete-clusters-and-contexts-from-kubectl-config](https://stackoverflow.com/questions/37016546/kubernetes-how-do-i-delete-clusters-and-contexts-from-kubectl-config)


```TAINTS```

````

kubectl taint nodes minikube-m02 gpu:NoSchedule-


kubectl taint nodes $(hostname) node-role.kubernetes.io/master:NoSchedule-


kubectl taint nodes controlplane node-role.kubernetes.io/master:NoSchedule-

kubectl taint nodes --all node-role.kubernetes.io/control-plane-

kubectl taint nodes --all node-role.kubernetes.io/master-  #I think the above was replaced with this

````

[https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)



```Retrieve cert or password```


````

kubectl get secret app-tls-cert -n metadata-store -ojson | jq -r '.data."tls.crt"' | base64 -d > app-tls-cert.crt


kubectl get secret hello-world-default-user -o jsonpath='{.data.username}' | base64 --decode



````



```kubectl debug```


````
kubectl get nodes

kubectl debug node/mynode -it --image=ubuntu

````

[https://kubernetes.io/docs/tasks/debug/debug-cluster/kubectl-node-debug/](https://kubernetes.io/docs/tasks/debug/debug-cluster/kubectl-node-debug/)



```kodekloud efk course```


````
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-elasticsearch
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /data/elasticsearch
---
kind: Service
apiVersion: v1
metadata:
  name: elasticsearch
  namespace: elastic-stack
spec:
  selector:
    app: elasticsearch
  ports:
  - port: 9200
    targetPort: 9200
    nodePort: 30200  
    name: port1

  - port: 9300
    targetPort: 9300
    nodePort: 30300  
    name: port2
  type: NodePort

````

```elastic search stafefuleset```

````
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: elasticsearch
  namespace: elastic-stack  
spec:
  serviceName: "elasticsearch"
  selector:
    matchLabels:
      app: elasticsearch
  template:
    metadata:
      labels:
        app: elasticsearch
    spec:
      containers:
      - name: elasticsearch
        image: docker.elastic.co/elasticsearch/elasticsearch:7.1.0
        ports:
        - containerPort: 9200
          name: port1
        - containerPort: 9300
          name: port2
        env:
        - name: discovery.type
          value: single-node
        volumeMounts:
        - name: es-data
          mountPath: /usr/share/elasticsearch/data
      initContainers:
      - name: fix-permissions
        image: busybox
        command: ["sh", "-c", "chown -R 1000:1000 /usr/share/elasticsearch/data"]
        securityContext:
            privileged: true
        volumeMounts:
        - name: es-data
          mountPath: /usr/share/elasticsearch/data
  volumeClaimTemplates:
  - metadata:
      name: es-data
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 5Gi

````

```Fluentd directives```

1. source: Input sources.
2. match: Output destinations.
3. filter: Event processing pipelines.
4. system: System-wide configuration.
5. label: Group the output and filter for internal routing.
6. worker: Limit to the specific workers.
7. @include: Include other files.


````
apiVersion: v1
kind: ServiceAccount
metadata:
  name: fluentd
  namespace: elastic-stack
  labels:
    app: fluentd
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: fluentd
  labels:
    app: fluentd
rules:
- apiGroups:
  - ""
  resources:
  - pods
  - namespaces
  verbs:
  - get
  - list
  - watch
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: fluentd
roleRef:
  kind: ClusterRole
  name: fluentd
  apiGroup: rbac.authorization.k8s.io
subjects:
- kind: ServiceAccount
  name: fluentd
  namespace: elastic-stack
---

````


```fluent.conf```

````
<label @FLUENT_LOG>
  <match fluent.**>
    @type null
    @id ignore_fluent_logs
  </match>
</label>
<source>
  @type tail
  @id in_tail_container_logs
  path "/var/log/containers/*.log"
  pos_file "/var/log/fluentd-containers.log.pos"
  tag "kubernetes.*"
  exclude_path /var/log/containers/fluent*
  read_from_head true
  <parse>
    @type "/^(?<time>.+) (?<stream>stdout|stderr)( (?<logtag>.))? (?<log>.*)$/"
    time_format "%Y-%m-%dT%H:%M:%S.%NZ"
    unmatched_lines
    expression ^(?<time>.+) (?<stream>stdout|stderr)( (?<logtag>.))? (?<log>.*)$
    ignorecase false
    multiline false
  </parse>
</source>
<match **>
  @type elasticsearch
  @id out_es
  @log_level "info"
  include_tag_key true
  host "elasticsearch.elastic-stack.svc.cluster.local"
  port 9200
  path ""
  scheme http
  ssl_verify false
  ssl_version TLSv1_2
  user
  password xxxxxx
  reload_connections false
  reconnect_on_error true
  reload_on_failure true
  log_es_400_reason false
  logstash_prefix "fluentd"
  logstash_dateformat "%Y.%m.%d"
  logstash_format true
  index_name "logstash"
  target_index_key
  type_name "fluentd"
  include_timestamp false
  template_name
  template_file
  template_overwrite false
  sniffer_class_name "Fluent::Plugin::ElasticsearchSimpleSniffer"
  request_timeout 5s
  application_name default
  suppress_type_name true
  enable_ilm false
  ilm_policy_id logstash-policy
  ilm_policy {}
  ilm_policy_overwrite false
  <buffer>
    flush_thread_count 8
    flush_interval 5s
    chunk_limit_size 2M
    queue_limit_length 32
    retry_max_interval 30
    retry_forever true
  </buffer>
</match>

````
