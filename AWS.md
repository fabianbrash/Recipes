```AWS info here```

### So I needed to do an export of my route53 dns entries and shockingly there is an import but no export

### so I had to install the aws cli and run the below

````
aws route53 list-resource-record-sets --hosted-zone-id your zone id goes here > /Users/fabianbrash/Desktop/Misc/rackspace-email-migration/fabianbrash_zone.json
````

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

#### Create a cluster

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
