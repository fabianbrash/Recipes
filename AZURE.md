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





