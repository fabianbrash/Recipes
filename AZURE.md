```Notes for deploying resources into AZURE, hopefully this will help me to take and pass the```


#### "Micosoft Azure Administrator AZ-103" 

[https://docs.microsoft.com/en-us/azure/virtual-machines/windows/tutorial-manage-vm](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/tutorial-manage-vm)

[https://docs.microsoft.com/en-us/powershell/module/azurerm.compute/?view=azurermps-6.13.0#vm_images](https://docs.microsoft.com/en-us/powershell/module/azurerm.compute/?view=azurermps-6.13.0#vm_images)

```BASIC DEPLOYMENT```


#### Create a ResourceGroup > Virtual Networks > Global Network > Subnets > Network Security Group(Under Network Interfaces) > Public IP > VM

##### I am using the Az moduels are they are build on .Net core and Powerrshell core and are cross-platform but there are

#### Azure(old powershell modules), AzureRM(new modules), and then Az(newest modules based on .net core and PS core)

```Let's log into our Azure account```

````
LoginAzAccount

Get-AzVM ###If you have 1 resourcegroup this is fine

Get-AzVM -ResourceGroupName "Test"

###Also
Get-AzVM -Status

##Create a resource Group
New-AzResourceGroup -Name TestResourceGroup -Location centralus


####Let's delete a VM#####
Remove-AzVM -ResourceGroupName "Test" -Name "MYVM" -Confirm:$false -Force


###Let's logout####
Logout-AzAccount
````

```Get all our resources from a resource group```

````

Get-AzResource -ResourceGroupName "Test" | ft


##Get network resources

Get-AzNetworkInterface

##Now let's remove a network interface
Remove-AzNetworkInterface -ResourceGroupName "Test" -Name WebServers -Confirm:$false -Force

##Get our security group(s)
Get-AzNetworkSecurityGroup

##Get our Virtual Network
Get-AzVirtualNetwork -ResourceGroupName "Test"


##Get all image publishers in the central region###
Get-AzVMImagePublisher -Location "CentralUS"

##From East US etc...
Get-AzVMImagePublisher -Location "EastUS"

##Get Image offer publisher name is required but you get that from the above command##
##Note for Microsoft they have a ton so look around####

Get-AzVMImageOffer -Location "CentralUS" -PublisherName MicrosoftWindowsServer 

###Now let's get our SKU#####

Get-AzVMImageSku -PublisherName MicrosoftWindowsServer -Location "centralus" -Offer WindowsServer
````

```Now we can deploy a VM with the below```

````
$cred = Get-Credential

New-AzVm `
    -ResourceGroupName "myResourceGroupVM" `
    -Name "myVM2" `
    -Location "CentralUS" `
    -VirtualNetworkName "myVnet" `
    -SubnetName "mySubnet" `
    -SecurityGroupName "myNetworkSecurityGroup" `
    -PublicIpAddressName "myPublicIpAddress2" `
    -ImageName "MicrosoftWindowsServer:WindowsServer:2016-Datacenter-with-Containers:latest" `
    -Credential $cred `
    -AsJob
````

````
New-AzVm `
    -ResourceGroupName "Lab" `
    -Name "PBCJMP01" `
    -Location "EastUS" `
    -VirtualNetworkName "LabNetwork" `
    -SubnetName "Jumphosts" `
    -SecurityGroupName "jumphostsRDP" `
    -PublicIpAddressName "jumphost" `
    -ImageName "MicrosoftWindowsServer:WindowsServer:2016-Datacenter-with-Containers:latest" `
    -Credential $cred `
    -AsJob
````

```Create a new empty resource group and tag it```

````
New-AzResourceGroup -Name "Lab" -Location "eastus" -Tag @{Name="Lab"} 

$mgmtsubnet = New-AzVirtualNetworkSubnetConfig -Name "Jumphosts" -AddressPrefix "10.0.99.0/24"

$infrasubnet = New-AzVirtualNetworkSubnetConfig -Name "Infra" -AddressPrefix "10.0.40.0/24"

New-AzVirtualNetwork -Name "LabNetwork" -ResourceGroupName "Lab" -Location "eastus" -AddressPrefix "10.0.0.0/16" -Subnet $mgmtsubnet,$infrasubnet


##View public IP addresses

Get-AzPublicIpAddress -ResourceGroupName "Alexander" 

Get-AzPublicIpAddress -ResourceGroupName "Alexander" -Name *Web*


##View the IPprefix this only works if you have running VM's as they will have public IP's assigned

Get-AzPublicIpPrefix -ResourceGroupName "Alexander" -Name *Web*

Get-AzPublicIpPrefix -ResourceGroupName "Alexander"

##New public IP address
New-AzPublicIpAddress -ResourceGroupName "Lab" -Name "jumphost"  -Location "eastus" -IpAddressVersion "IPv4" -AllocationMethod Dynamic 

###See all network security groups##

Get-AzNetworkSecurityGroup -ResourceGroupName "Alexander"

Get-AzNetworkSecurityGroup -ResourceGroupName "Alexander" -Name *Mgmt*
````

```build one```

````
##First let's define a rule#####
$RuleRDP = New-AzNetworkSecurityRuleConfig -Name rdp-rule -Description "Allow RDP from my IP only" -Access Allow -Protocol Tcp -Direction Inbound -Priority 100 -SourceAddressPrefix "72.82.
60.19/32" -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389

##Then we can apply it to our Network Security Group
##Note the -SecurityRules can accept a comma separated list of rules

New-AzNetworkSecurityGroup -ResourceGroupName "Lab" -Location "eastus" -Name "jumphostsRDP" -SecurityRules $RuleRDP
````

```Get VM sizes in a region```

````
Get-AzVMSize -Location "eastus"
````

```Azure cli(aka azure bash)```

````
PowerShell vs CLI in Azure

PS                                                  CLI
—                                                   —-
Get-Az					                            az verb list
New-Az					                            az verb create
Delete-Az                                           az verb delete
````



#### Also we can have verbs that are sub of something else like

````
az network vnet list vnet is a sub of network
az —help will get you help
#az returns JSON
#You can also do 

az group list ##Note group is the top level to see all resource groups, or to delete

##az group
    \
     \
      resource

az group list —help

az group list -o table

az resource list -o table ###resource is below group

az resource list --resource-group LAB -o table
````

##### The above will return everything in table format

````
-o or —output can be json, jsonc, none, table, tsv, yaml. Default is json
````
#### Now let's delete a resource group and all it's resources
##### Our resource group name is Lab

[https://docs.microsoft.com/en-us/cli/azure/group?view=azure-cli-latest#az-group-delete](https://docs.microsoft.com/en-us/cli/azure/group?view=azure-cli-latest#az-group-delete)

````
az group delete -n Lab --yes
````

#### Azure works under a premise of Resource providers in order to use some services you must have that resource provider registered with your account

[https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-manager-register-provider-errors](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-manager-register-provider-errors)

##### GUI can be used as well

````
Get-AzResourceProvider | ft
````

##### See what location support the Microsoft.Web provider###

````
((Get-AzResourceProvider -ProviderNamespace Microsoft.Web).ResourceTypes | Where-Object ResourceTypeName -eq sites).Locations

##Get supported API version
((Get-AzResourceProvider -ProviderNamespace Microsoft.Web).ResourceTypes | Where-Object ResourceTypeName -eq sites).ApiVersions

##Let's register the Microsoft CDN Provider to our account

Register-AzResourceProvider -ProviderNamespace Microsoft.Cdn
````

```Azure CLI```

[az aks commands](https://learn.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest)
````
az provider list -o table

##Register Microsoft CDN
az provider register --namespace Microsoft.Cdn

##using cli to list VM skus available to you####

az vm image list -o table

az vm image list -o table --all ##Note the --all will download the latest list, and take a while

az vm image list --all --offer WindowsServer -o table

az group create -l eastus -n rg1

az group list

az aks list --resource-group my_resource_group | jq .

az aks delete --name fb-azure-tap --resource-group TAP --no-wait --yes

az aks get-os-options --location westus2

az aks get-versions --location westus2

az aks create -g TAP -n fb-tap-azure-1 --ssh-key-value /Users/joe/.ssh/id_rsa.pub \
--kubernetes-version 1.25.6 --nodepool-name tapworkers --node-count 3 --os-sku Ubuntu --node-osdisk-size 100 \
--node-vm-size Standard_D4_v3 --location westus2 \
--network-plugin kubenet \
--network-policy calico


az aks get-credentials --name fb-tap-azure-1 -g TAP --admin
````

```Remove Network security rule```

````
$nsg = Get-AzNetworkSecurityGroup -Name "NSG-DevOPS" -ResourceGroupName "DevOPS"    

Remove-AzNetworkSecurityRuleConfig -Name "rdp-rule" -NetworkSecurityGroup $nsg | Set-AzNetworkSecurityGroup
````


##### Make all Windows VM's "B2s"  "Standard_B2s" if available in the region I am deploying in(2vCPUs, 4GB RAM Also a "Standard_B1MS" is a another low cost option(1vCPUs, 2GB RAM)




```AZURE BLOBS Endpoints```

````
https://containerblobs.blob.core.windows.net/installers/FreeNAS-11.3-U1.iso

https://containerblobs.blob.core.windows.net/installers/kubectl

https://containerblobs.blob.core.windows.net/installers/umds-Msft.zip

https://containerblobs.blob.core.windows.net/rpms/minikube-1.6.2.rpm

https://containerblobs.blob.core.windows.net/installers/cfssl

https://containerblobs.blob.core.windows.net/installers/cfssljson
````


```azure RHOS```

````

az aro list-credentials --name MY_CLUSTER_NAME --resource-group MY_RG_NAME

az aro show --name MY_CLUSTER_NAME --resource-group MY_RG_NAME --query "consoleProfile.url" -o tsv


az aro show -g MY_RG_NAME  -n MY_CLUSTER_NAME --query apiserverProfile.url -o tsv

apiServer=$(az aro show -g MY_RG_NAME  -n MY_CLUSTER_NAME --query apiserverProfile.url -o tsv)

oc login $apiServer -u kubeadmin -p <kubeadmin password>
````


[https://learn.microsoft.com/en-us/azure/openshift/tutorial-connect-cluster](https://learn.microsoft.com/en-us/azure/openshift/tutorial-connect-cluster)


```Azure PS```

#### Make sure you install the correct PS module

````
Install-Module -Name Az

##NOT
Install-Module -Name Azure # THIS IS OLD AND WILL BREAK ALL YOUR SCRIPTS

````

#### Also let's connect to Azure prior to running our scripts and make sure we connect to the correct Subscription

````
Connect-AzAccount -SubscriptionId 'yyyyyyyy-yyyyyyyyyy-yyyyyyyy-yyyyyyyyyyyy-yyyyyyyyyyy'

#OR

Connect-AzAccount -Tenant 'xxxx-xxxx-xxxx-xxxx' -SubscriptionId 'xxxx-xxxx-xxxx-xxxx' ## Make sure we connect to the correct tenant and subscription

````

```Agent Pools```

### I would say the directions from the URL got me 90% of the way, I did have a few hiccups

#### Make sure in Azure Devops(ADO) that you add your users under ORG Settings > Agent Pools > Security I made my users "Administrators" probably not a good idea but...

#### The one gotcha is you can't be logged in as yourself and add yourself to any roles, so log in as another admin and assign it as that user, I also used a PAT for authentication

[https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/windows-agent?view=azure-devops](https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/windows-agent?view=azure-devops)

[https://medium.com/@shekhartarare/creating-a-self-hosted-agent-for-azure-pipelines-a-step-by-step-guide-a1cbd1c683d1](https://medium.com/@shekhartarare/creating-a-self-hosted-agent-for-azure-pipelines-a-step-by-step-guide-a1cbd1c683d1)

[https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/personal-access-token-agent-registration?view=azure-devops](https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/personal-access-token-agent-registration?view=azure-devops)

#### A few other things, when you install the agent it will ask for a working directory I left mine as the default _work so that's where everything will be and a good place to look when troubleshooting

#### Also under Default the "New Agent" Button is how you download the agent and it also has some instructions for you to follow

```Setting up ADO Pipeline```

### This also had some gotchas but the error messages were pretty good, below you will find a pipeline sample that will connect to the Default pool where I have a Windows VM waiting to accept jobs

### And I have the Java JDK, Maven, and Git installed(actually a bunch more dev stuff is installed on the machine) and we are going to build our Java APP and push it to an APP Service

### You also have to add a a Capability manually to your agent this is under Agent Pools > Default > Agents > YOUR_AGENT > Capabilities I had to add Name: maven Value: maven 

### This will be under "User-defined capabilities" just hit the "+" and add it, again this came from the pretty useful error message from the failed build


```azure-pipelines.yml```

````
# Starter pipeline
# Start with a minimal pipeline that you can customize to build and deploy your code.
# Add steps that build, run tests, deploy, and more:
# https://aka.ms/yaml

trigger:
- main

pool:
  name: Default
  demands: Agent.Name -equals wus-apipeline


steps:
#- script: echo Hello, world!
#  displayName: 'Run a one-line script'

#- script: |
#    echo Add other tasks to build, test, and deploy your project.
#    echo See https://aka.ms/yaml
#  displayName: 'Run a multi-line script'
  
- task: Maven@4
  inputs:
    mavenPomFile: 'pom.xml'
    publishJUnitResults: true
    testResultsFiles: '**/surefire-reports/TEST-*.xml'
    javaHomeOption: 'JDKVersion'
    mavenVersionOption: 'Default'
    mavenAuthenticateFeed: false
    effectivePomSkip: false
    sonarQubeRunAnalysis: false
    sqMavenPluginVersionChoice: 'pom'

- task: AzureRmWebAppDeployment@4
  inputs:
    ConnectionType: 'AzureRM'
    azureSubscription: 'Lab-Subscription (91f9999999-d832-9999-9999-99999999)-9999'
    appType: 'webApp'
    WebAppName: 'tanzu-java-web'
    packageForLinux: '$(System.DefaultWorkingDirectory)/**/*.jar.'

````

#### The - task you see was written by little builder tool in Azure Pipelines, it was pretty helpful, another issue I ran into was the Subscription, it had multiple entries with the same name

#### I checked picked one until the tanzu-java-web populated, also the packageForLinux was an odd name, because this ran on a Windows machine, the example above is for a maven build that produces a .jar file

#### If you run a build that produces .war files, then you need to change that

[https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/pool-demands?view=azure-pipelines](https://learn.microsoft.com/en-us/azure/devops/pipelines/yaml-schema/pool-demands?view=azure-pipelines)


```Useful PWSH Commands```

````
Login-AzAccount -UseDeviceAuthentication
Connect-AzAccount -SubscriptionId 'xxxx-xxxx-xxxx-xxxx'
Connect-AzAccount -Tenant 'xxxx-xxxx-xxxx-xxxx' -SubscriptionId 'xxxx-xxxx-xxxx-xxxx'
Get-AzSubscription
Get-AzStorageAccount
Set-AzContext -Subscription 'xxxx-xxxx-xxxx-xxxx'(You can use the second command to do the same and save a step)
New-AzResourceGroup -Name arm-test -Location "eastus"
New-AzResourceGroupDeployment -Name "deployment1" -ResourceGroup "arm-test" -TemplateFile .\myfile.json
New-AzResourceGroupDeployment -Name spot-deploy -ResourceGroupName Lab-West -TemplateFile .\template.json -TemplateParameterFile .\parameters.json


````

```Useful CLI commands```


````
az login
az logout
az account show
az account list -o table
az account set --subscription 'xxxx-xxxx-xxxx-xxxx'
az deployment group create --name 'bicep-demo' -g 'arm-test' --template-file ./storage.bicep --parameters part=bicep

az role assignment list --assignee 69da75bc-58cc-4265-b45a-53fd01483a19 --query "[].{role:roleDefinitionName, scope:scope}" -o table

az ad sp list --filter "appId eq '78c2b680-4cfd-4cff-a479-7ba06b4ebb57'" --query "[].{DisplayName:displayName, ObjectID:id}" -o table

az account show --query "{user: user.name, id: user.id}"

az aks show --resource-group eus-aks-blue-green-rg --name aks-blue --query "identity" -o json

az aks show --resource-group eus-aks-blue-green-rg --name aks-blue --query "identity" -o json

az aks get-credentials --resource-group aks-blue-green-rg --name aks-green

az aks get-credentials --resource-group aks-blue-green-rg --name aks-green

````

```List VM Quota```


````
az vm list-usage --location "East US" -o table

az vm list-usage --location "East US" -o table | grep NC

````
