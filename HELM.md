```HELM info```

#### Please note everything below relates to helm 3.x

[https://helm.sh/](https://helm.sh/)

#### Follow instructions on how to install HELM from above, this is a go app so just download the latest binary and copy to your path

```ADD a repo```

````
helm repo add stable https://kubernetes-charts.storage.googleapis.com/

##Search the repo

helm search repo stable

helm repo update    # Make sure we get the latest list of charts
helm install stable/mysql --generate-name

##OR

helm install mysql stable/mysql

##You get a simple idea of the features of this MySQL chart by running 
helm show chart stable/mysql. 
##Or you could run 

helm show all stable/mysql 
##to get all information about the chart.

helm ls  ##note this only looks in the default namespace

helm ls -n mysnamespace

##uninstall a release
helm uninstall smiling-penguin #again you might -n mynamespace

````

````
helm search hub 
## searches the Helm Hub, which comprises helm charts from dozens of different repositories

helm search repo 
##searches the repositories that you have added to your local helm client (with helm repo add). 
#This search is done over local data, and no public network connection is needed.


###Okay so the biggest thing to get with helm are values, and values allow you to make changes
##to how a chart is deployed, this has changed since version 2.x


helm show values stable/mariadb

##More importantly

helm show values stable/mariadb > /tmp/mariadb.yaml

##You can then make changes to the outputted file and once you are satisfied

helm install mariadb -f /tmp/mariadb.yaml stable/mariadb --namespace db

helm install mariadb my-mariadb-chart/ --values my-mariadb-chart/values.yaml -f my-mariadb-chart/values-dev.yaml -n dev
````

#### With helm we can also upgrade and rollback charts ref below

[https://helm.sh/docs/intro/using_helm/](https://helm.sh/docs/intro/using_helm/)


```Helm values.yaml```

````
you may see in the values.yaml file something like args:[]
the additional args should look args:["arg1"] or args:["--myexpectedarg1=false"]
And I think args:["arg1=true","--arg2=false"]
````


[https://phoenixnap.com/kb/helm-install-command](https://phoenixnap.com/kb/helm-install-command)


```create helm releases```

````
helm create demo

helm install my-release demo/

helm install my-release .  #if you are already in demo


````


```helm upgrade```

````
helm upgrade my-release .

helm upgrade my-release demo/ --values demo/values.yaml

````

```helm rollback```

````

helm rollback my-release 1  #the 1 is the revision number you can see it with helm ls -a command
````
