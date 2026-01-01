```AWS info here```

### So I needed to do an export of my route53 dns entries and shockingly there is an import but no export

### so I had to install the aws cli and run the below


```aws cli```


````
aws configure

aws configure --profile user1

aws s3 ls --profile profile1
aws ec2 describe-instances --profile user1 --region us-west-2

aws configure list-profiles

aws configure list
````

```Example of aws configure output```

````
aws configure
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: us-west-2
Default output format [None]: json


````

```Credentials file example```

````
[default]
aws_access_key_id=AKIAIOSFODNN7EXAMPLE
aws_secret_access_key=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
aws_session_token = IQoJb3JpZ2luX2IQoJb3JpZ2luX2IQoJb3JpZ2luX2IQoJb3JpZ2luX2IQoJb3JpZVERYLONGSTRINGEXAMPLE
````

```Config file example```

````

[default]
region=us-west-2
output=json

[profile user1]
role_arn=arn:aws:iam::777788889999:role/user1role
source_profile=default
role_session_name=session_user1
region=us-east-1
output=text

````

[https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)

````
aws route53 list-resource-record-sets --hosted-zone-id your zone id goes here > /Users/fabianbrash/Desktop/Misc/rackspace-email-migration/fabianbrash_zone.json


aws eks update-kubeconfig --region region-code --name cluster-name


````

[aws eks commands](https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html)

### but the output is in JSON so not nice to import also *.domain.com comes out as \\052.domain.com

[Tool to transfer Route53 entries](https://github.com/cosmin/route53-transfer)

### you can install via pip

````
route53-transfer --access-key-id=your_access_key --secret-key=your_secrey_key dump fabianbrash.com backup.csv

````


### and then you will need to replace \052 with a *


### Permissions to host a static site on s3

[Hosting Websites on S3](https://docs.aws.amazon.com/AmazonS3/latest/dev/HostingWebsiteOnS3Setup.html)

````
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::example.com/*"
            ]
        }
    ]
}

````

### had an issue where serving a static site over cloudfront would not render mydomain/about it's supposed to see and render the index.html file

### but it does not, this fixed it

[set-default-root-object](https://stackoverflow.com/questions/31017105/how-do-you-set-a-default-root-object-for-subdirectories-for-a-statically-hosted)

### basically point to the s3 bucket URL and not the bucket object, of course you have to set the bucket up to serve a website first.


```eksctl```

#### Cluster management

````

eksctl create cluster

eksctl create cluster --name my-cluster

eksctl create cluster -f cluster.yaml

eksctl delete cluster my-tap-cluster

eksctl delete cluster my-tap-cluster --force


````

```cluster.yaml```


````

apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: basic-cluster
  region: us-east-1

nodeGroups:
  - name: ng-1
    instanceType: m5.large
    desiredCapacity: 10
  - name: ng-2
    instanceType: m5.xlarge
    desiredCapacity: 2

````

````
aws sts get-caller-identity

aws sts get-caller-identity --profile fbrash2
````

```more aws commands```

````
aws iam create-user --user-name lucy


aws iam attach-user-policy --user-name mary --policy-arn arn:aws:iam::aws:policy/AdministratorAccess --endpoint-url http://aws:4566 #we are taking advantage of https://www.localstack.cloud/

aws iam create-group --group-name project-sapphire-developers --endpoint-url http://aws:4566

aws iam add-user-to-group --user-name jill --group-name project-sapphire-developers --endpoint-url http://aws:4566

aws --endpoint http://aws:4566 iam list-attached-group-policies --group-name project-sapphire-developers

aws --endpoint http://aws:4566 iam list-attached-user-policies --user-name jack

aws ec2 describe-instances --endpoint http://aws:4566

````

```get eks kubeconfig```

````

aws eks update-kubeconfig --region us-west-2 --name my-eks-cluster

aws eks update-kubeconfig --region us-west-2 --name my-eks-cluster --profile=profile1
````

```Get available k8s version```


````
eksctl version -o json | jq -r '.EKSServerSupportedVersions[]'

aws eks describe-addon-versions | jq -r ".addons[] | .addonVersions[] | .compatibilities[] | .clusterVersion" | sort | uniq

````

[https://stackoverflow.com/questions/68049761/aws-eks-get-available-kubernetes-versions](https://stackoverflow.com/questions/68049761/aws-eks-get-available-kubernetes-versions)



```EKS```

### Create gp3 storageclass and set it as default

````
    apiVersion: storage.k8s.io/v1
    kind: StorageClass
    metadata:
      name: gp3
      annotations:
        # Optional: Set this as the default storage class
        storageclass.kubernetes.io/is-default-class: "true" 
    provisioner: ebs.csi.eks.amazonaws.com
    volumeBindingMode: WaitForFirstConsumer
    parameters:
      type: gp3
      encrypted: "true" # Optional: Encrypt the volumes
      # iopsPerGB: "3000" # Optional: Specify IOPS (default is 3000)
      # throughput: "125" # Optional: Specify throughput (default is 125 MiB/s)
    allowVolumeExpansion: true
````


```AWS CLI commands```


#### Get all ubuntu images from a region

````
aws ec2 describe-images \
    --owners 099720109477 \
    --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-*-*-amd64-server-*" \
    --query "sort_by(Images, &CreationDate)[].Name" \
    --region us-east-1
````

#### Now let's get the AMI id

````
aws ec2 describe-images \
    --owners 099720109477 \
    --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20250603" \
    --query "Images[*].ImageId" \
    --output text \
    --region us-east-1
````


```AWS Certificate Manager```


##### AWS CM now allows you to export certificates so you can use them with non-aws apps.  Below are some gotchas

1. private key is encrypted so you need to use openssl to decrypt
2. you have to build the full-chain yourself, all you have to do though is just add your certificate to the top of a new full-chain file, i.e. create a new file copy in there full-chain contents and then add your cert at the top


##### This site uses such a certificate https://harbor.fbclouddemo.us/
