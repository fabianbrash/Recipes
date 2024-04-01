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
