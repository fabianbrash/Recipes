### I'm finally getting around to creating a terraform knowledge dump

##

````
mkdir terraform-infra

cd terraform-infra

touch main.tf
````

#### Once you add your code to main.tf

````
terraform init

terraform plan

terraform apply

terraform destroy

terraform fmt

terraform validate

terraform show

````

[terraform docs docker](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started)

[terraform docs aws](https://learn.hashicorp.com/tutorials/terraform/aws-build)

##

#### terraform variables are defined in a file called variables.tf

[terraform variables](https://learn.hashicorp.com/tutorials/terraform/aws-variables?in=terraform/aws-get-started)


```variables```


````
variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "ExampleAppServerInstance"
}


````

```variables.tf```

````
variable "ami" {
  type = string
  default = "ami-06178cf087598769c"
}

variable "region" {
    type = string
    default = "eu-west-2"
}

variable "instance_type" {
    type = string
    default = "m5.large"
}

````

#### Now we can consume those variables

```main.tf```

````
resource "aws_instance" "cerberus" {
  ami = var.ami
  instance_type = var.instance_type
  tags = {
        Name = "projectb_webserver"
        Description = "Oversized Webserver"
    }
  key_name = "cerberus"
  user_data = file("./install-nginx.sh")

#You can also use variable for key_name
resource "aws_key_pair" "cerberus-key" {
    key_name = "cerberus"
    public_key = file(".ssh/cerberus.pub")
}

resource "aws_eip" "eip" {
  instance = aws_instance.cerberus.id
  vpc = true
  provisioner "local-exec" {
    command = "echo ${aws_eip.eip.public_dns} >> /root/cerberus_public_dns.txt"
    
  }
}

````

#### Am example of install-nginx.sh

````
#!/bin/bash
sudo yum update -y
sudo yum install nginx -y
sudo systemctl start nginx

````

##### For user_data we can also do this

````
resource "aws_instance" "cerberus" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = "cerberus"
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install nginx -y
              sudo systemctl start nginx
              EOF
````

#### An Example of a provider.tf file that uses a local version of the AWS API


```provider.tf```


````

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.15.0"
    }
  }
}
provider "aws" {
  region                      = var.region
  skip_credentials_validation = true
  skip_requesting_account_id  = true

  endpoints {
    ec2 = "http://aws:4566"
  }
}

[localStack](https://www.localstack.cloud/)

````


```useful commands```


````
terraform show

terraform state list

terraform state show my_resource

terraform state pull  #pull remote state

terraform state rm resource_to_remove  #then you can remove it from your terraform file i.e. main.tf or resources.tf

terraform state mv resource_to_move

terraform taint resource

terraform untaint resource

terraform untaint aws_instance.ProjectB

````

```debugging```


````
export TF_LOG
export TF_LOG_PATH=/tmp/ProjectA.log

````

