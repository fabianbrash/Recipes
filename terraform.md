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

```variables.tf```

````

variable "name" {
  type    = set(string)
  default = ["jade-webserver", "jade-lbr", "jade-app1", "jade-agent", "jade-app2"]

}
variable "ami" {
  default = "ami-0c9bfc21ac5bf10eb"
}
variable "instance_type" {
  default = "t2.nano"
}
variable "key_name" {
  default = "jade"

}

````

```main.tf```


````
resource "aws_instance" "ruby" {
  ami           = var.ami
  instance_type = var.instance_type
  for_each      = var.name
  key_name      = var.key_name
  tags = {
    Name = each.value
  }
}
output "instances" {
  value = aws_instance.ruby
}

````


```main.tf```

````

resource "aws_iam_user" "cloud" {
     name = split(":",var.cloud_users)[count.index]
     count = length(split(":",var.cloud_users))
}
resource "aws_s3_bucket" "sonic_media" {
     bucket = var.bucket
  
}

resource "aws_s3_object" "upload_sonic_media" {
     bucket = aws_s3_bucket.sonic_media.id
     key =  substr(each.value, 7, 20)
     source = each.value
     for_each = var.media 
}

resource "aws_instance" "mario_servers" {
  ami = var.ami
  tags = {
    Name = var.name
  }
  instance_type = var.name == "tiny" ? var.small : var.large
}

````

```variables.tf```

````

variable "region" {
  default = "ca-central-1"
}
variable "cloud_users" {
     type = string
     default = "andrew:ken:faraz:mutsumi:peter:steve:braja"
  
}
variable "bucket" {
  default = "sonic-media"
  
}

variable "media" {
  type = set(string)
  default = [ 
    "/media/tails.jpg",
    "/media/eggman.jpg",
    "/media/ultrasonic.jpg",
    "/media/knuckles.jpg",
    "/media/shadow.jpg",
      ]
  
}
variable "sf" {
  type = list
  default = [
    "ryu",
    "ken",
    "akuma",
    "seth",
    "zangief",
    "poison",
    "gen",
    "oni",
    "thawk",
    "fang",
    "rashid",
    "birdie",
    "sagat",
    "bison",
    "cammy",
    "chun-li",
    "balrog",
    "cody",
    "rolento",
    "ibuki"

  ]
}

````

```main.tf```

````

module "payroll_app" {
  source = "/root/terraform-projects/modules/payroll-app"
  app_region = lookup(var.region, terraform.workspace)
  ami        = lookup(var.ami, terraform.workspace)
}

````

```variables.tf```

````
variable "region" {
    type = map
    default = {
        "us-payroll" = "us-east-1"
        "uk-payroll" = "eu-west-2"
        "india-payroll" = "ap-south-1"
    }

}
variable "ami" {
    type = map
    default = {
        "us-payroll" = "ami-24e140119877avm"
        "uk-payroll" = "ami-35e140119877avm"
        "india-payroll" = "ami-55140119877avm"
    }
}
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

terraform import aws_instance.webserver-2 <attribute>
terraform import aws_instance.jade-mw i-10a49cef4b2cb75dc

terraform get  #get remote modules from terraform

terraform console

terraform workspace new ProjectA

terraform workspace list

terraform workspace select ProjectA
````

```debugging```


````
export TF_LOG
export TF_LOG_PATH=/tmp/ProjectA.log

````

```terrafrom modules```


````

module "iam_iam-user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "5.28.0"
  # insert the 1 required variable here
}

````

````
module "iam_iam-user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "5.28.0"
  # insert the 1 required variable here
  name = "max"
  create_user = true
  create_iam_access_key = false
  create_iam_user_login_profile = false
}
````
