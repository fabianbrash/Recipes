#### Tanzu RabbitMQ info goes here


```Install Operator```


[https://rabbitmq.com/kubernetes/operator/quickstart-operator.html](https://rabbitmq.com/kubernetes/operator/quickstart-operator.html)

````

kubectl apply -f "https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml"

````

```Modify Operator```

##### If you need to change where the images are being pulled from, read below, i.e. your own private registry

[https://rabbitmq.com/kubernetes/operator/configure-operator-defaults.html](https://rabbitmq.com/kubernetes/operator/configure-operator-defaults.html)

```Create your first cluster```


````

kubectl apply -f https://raw.githubusercontent.com/rabbitmq/cluster-operator/main/docs/examples/hello-world/rabbitmq.yaml

````

#### A more realistic cluster definition

````

apiVersion: rabbitmq.com/v1beta1
kind: RabbitmqCluster
metadata:
  name: rabbitmqcluster-sample
spec:
  replicas: 3
  service:
    type: LoadBalancer

````


[https://rabbitmq.com/kubernetes/operator/using-operator.html#examples](https://rabbitmq.com/kubernetes/operator/using-operator.html#examples)


#### Let's get our username, password and clusterIP

````

username="$(kubectl get secret hello-world-default-user -o jsonpath='{.data.username}' | base64 --decode)"
echo "username: $username"

password="$(kubectl get secret hello-world-default-user -o jsonpath='{.data.password}' | base64 --decode)"
echo "password: $password"

service="$(kubectl get service hello-world -o jsonpath='{.spec.clusterIP}')"

````

#### In our example we are using a service of type LB so we can get to the UI with http://LB_IP:15672

```Load Test```


````

kubectl run perf-test --image=pivotalrabbitmq/perf-test -- --uri amqp://$username:$password@$service

````
