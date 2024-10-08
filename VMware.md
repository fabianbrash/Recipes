```VMware related info```

```REFS```


[https://docs.vmware.com/en/VMware-vSphere/6.7/com.vmware.esxi.upgrade.doc/GUID-61A14EBB-5CF3-43EE-87EF-DB8EC6D83698.html](https://docs.vmware.com/en/VMware-vSphere/6.7/com.vmware.esxi.upgrade.doc/GUID-61A14EBB-5CF3-43EE-87EF-DB8EC6D83698.html)

[https://be-virtual.net/automated-installation-with-vmware-esxi-5-56-06-5/](https://be-virtual.net/automated-installation-with-vmware-esxi-5-56-06-5/)

[https://blogs.vmware.com/vsphere/2019/02/using-the-vmware-update-manager-download-service-umds.html](https://blogs.vmware.com/vsphere/2019/02/using-the-vmware-update-manager-download-service-umds.html)

[https://code.vmware.com/forums/2530/vsphere-powercli#571112](https://code.vmware.com/forums/2530/vsphere-powercli#571112)

[https://docs.vmware.com/en/VMware-vSphere/6.7/com.vmware.esxi.install.doc/GUID-61A14EBB-5CF3-43EE-87EF-DB8EC6D83698.html](https://docs.vmware.com/en/VMware-vSphere/6.7/com.vmware.esxi.install.doc/GUID-61A14EBB-5CF3-43EE-87EF-DB8EC6D83698.html)

#### In case you have a failed PSC or failed VCSA we need to clean things up

````
cmsso-util unregister --node-pnid FQDN_of_failed_PSC_or_vCenter --username administrator@your_domain_name --passwd vCenter-Single-Sign-On-password
````

#### The above did not work for me but this did

````
/usr/lib/vmware-vmdir/bin/vdcleavefed -h lab-psc-01.lab.net -u administrator
````
#### List all PSC's in

````
/usr/lib/vmware-vmdir/bin/vdcrepadmin -f showservers -h lab-psc-01.lab.net -u administrator
or
cd /usr/lib/vmware-vmdir/bin
./vdcrepadmin -f showservers -h lab-psc-01.lab.net -u administrator
````

#### Show replication partners

````
./vdcrepadmin -f showpartners -h lab-psc-01.lab.net -u administrator
````

#### Show current replication status
````
./vdcrepadmin -f showpartnerstatus -h localhost -u administrator
````

#### Force remove PSC from replication

````
/usr/lib/vmware-vmdir/bin/vdcleavefed -h psc_FQDN -u administrator
````

### Note the above did not work for me I had an error while deploying a PSC 6.0 it failed on first boot so after trying all above I just re-deployed the appliance and it worked, I'm thinking it was a time issue with the first PSC being set to UTC instead of EST??


[https://techbrainblog.com/2015/10/02/issues-and-errors-when-decommissioning-the-vcenter-server-or-a-platform-services-controller-vcsa-6-0/](https://techbrainblog.com/2015/10/02/issues-and-errors-when-decommissioning-the-vcenter-server-or-a-platform-services-controller-vcsa-6-0/)

#### Display storage capabilities i.e. SCSI UNMAP

````
esxcli storage core device list (-d optional if you want to target a particulat device)
esxcli storage core device vaai status get
esxcli storage core plugin list
````


#### Connectin to the various VCSA and PSC appliances

````
https://psc-IP/psc - this is the SSO side of things
https://psc-IP:5480 - this is the appliance itself
https://vcsa-IP:5480 - this is the VCSA VAMI interface
````

#### Get NUMA information from a host

````
esxcli hardware memory get | grep NUMA
````

#### Get DCUI console from ssh, ssh into esxi host and type below
````
dcui
````

```VScsiStats```

````
#List all disks
vscsiStats -l
Start stats on a VM with World ID 76634 and disk ID 8192
vscsiStats -s -w 76634 -i 8192
````

````
#Display Stats ioLength
vscsiStats -p ioLength -c -w 76634 -i 8192

#Display Latency
vscsiStats -p latency -c -w 76634 -i 8192

#Stop logging
vscsiStats -x -w 76634 -i 8192
````

```Useful ESX commands```

````
esxcli software vib list | grep ams


/etc/init.d/hp-ams.sh stop

/etc/init.d/hp-ams.sh stop && chkconfig hp-ams.sh off && services.sh restart
chkconfig hp-ams.sh on && /etc/init.d/hp-ams.sh start
````

############Restart Management Agents######################################
/etc/init.d/hostd restart

/etc/init.d/vpxa restart



########Enable CDP###############################################################################################
esxcfg vswitch b vSwitch1
esxcfg vswitch B both vSwitch1
esxcfg vswitch b vSwitch1

##################STORAGE CONFIG COMMANDS######################################################################
##List all NFS Datastores
esxcli storage nfs list
/etc/init.d/storageRM stop
##Rescan all storage devices and then
/etc/init.d/storageRM start
##Now lets remove it
esxcli storage nfs remove -v "NFS volume name"

###List VMFS file system
esxcli storage filesystem list

##unmount vmfs filesystem
esxcli storage filesystem unmount -u or -l or -p

##If you get a failure filesystem is busy check to see where your esxi host is keeping it's scratch
###under advanced setting for the host look for this key ScratchConfig.ConfiguredScratchLocation

#####################VAAI CONFIG##################################################################################
esxcli storage core device vaai status get
esxtop select 'u' for devices

#########################UPDATE ESXI HOST SSH##################################################################
vim-cmd hostsvc/maintenace_mode_enter
esxcli software vib update -d "pathto .zip_offlinebundle e.g./vmfs/"(You might have to use -f or --force)
vim-cmd hostsvc/maintenance_mode_exit
reboot



###Get all VM ID's
vim-cmd vmsvc/getall
###Then if you like you can use the VM ID's to launch the VMRC
cd to the location of the VMRC installation
vmrc.exe vmrc://root@yourhostorvc/?moid='vmid'


#########################CREATING CUSTOM IMAGES WITH POERCLI##############################################
##You need the offline bundle to start with
####Also download your drivers and unzip so you just have your dirver offline bundle
##Get all available Profiles
Get-EsxImageProfile
##ADD a depot
Add-EsxSoftwareDepot -DepotURL C:\location\vmware-esxi6.5-depot.zip
###Get our newly added profiles
Get-EsxImageProfile
####Create an image profile
New-EsxImageProfile -CloneProfile 'pick one from above command' -Name "MyProfile"
#####Check to see what VIBs are included in the depot
Get-EsxSoftwarePackage
###Add our VIB
Add-EsxSoftwareDepot -DepotUrl C:\location\mlx.zip
###Lets now add it to our custom image
Add-EsxSoftwarePackage -ImageProfile MyProfile -SoftwarePackage 'packageName'
#####Check to see what VIBs are included in the depot
Get-EsxSoftwarePackage
#####Now let's export our ISO You can also export to an offline-bundle .zip file################
Export-EsxImageprofile -ImageProfile MyProfile -Filepath C:\images\MyProfile.iso -ExportToIso -Force -NoSignatureCheck

################ALTERNATIVE METHOD#################################################
Add-EsxSoftwareDepot -DepotUrl C:\depot\Esxi-6.0.zip
Add-EsxSoftwareDepot -DepotUrl C:\depot\vibs\fusion-io.zip
Get-EsxSoftwareDepot
Get-EsxImageProfile | Format-list (The Names are truncated so you will need this)
New-EsxImageProfile -CloneProfile "Esxi-6.0-standard" -Name "MyProfile"
Get-EsxImageProfile
Get-EsxSoftwarePackage
######Optionally we can remove unwanted packages or deprecated packages###################
Remove-EsxSoftwarePackage
#########When asked for an image profile use the profile you created above "MyProfile"
(Get-EsxImageProfile "MyProfile").viblist
Add-EsxSoftwarePackage
Export-EsxImageProfile -ImageProfile "MyProfile" -ExportToIso(or ExportToBundle) -FilePath C:\vmware\ISO\MyProfile.iso -Force -NoSignatureCheck

######################################WHAT WORKED FOR ME#################################################
Get-EsxImageProfile
Add-EsxSoftwareDepot -DepotUrl C:\VMware\esxi-depot.zip
Get-EsxImageProfile
Get-EsxSoftwareDepot
New-EsxImageProfile -CloneProfile "Then Name from the Get-EsxImageProfile | Format-list" -Name "MyProfileName"
[vendor]: Whatever you want
######LIST all VIBS in the package
Get-EsxSoftwarePackage
########ADD to the main depot
Add-EsxSoftwareDepot
DepotUrl[0]: C:\VMware\VIBS
#####Now a get will tell you if you successfully added the Depot
Get-EsxSoftwarePackage
#####Now lets add it to our Custom depot
Add-EsxSoftwarePackage -ImageProfile "MyProfile"
SoftwarePackage[0]: scsi-iomemory-vsl
####Now lets make certain the package was injected correctly
(Get-EsxImageProfile "MyProfile").viblist
Export-EsxImageProfile -ImageProfile "MyProfile" -Filepath C:\VMware\MyProfile.iso -ExportToIso -Force -noSignatureCheck
Export-EsxImageProfile -ImageProfile "MyProfile" -Filepath C:\VMware\MyProfile-offline-bundle.zip -ExportToBundle -Force -noSignatureCheck

################SET SAN POLICY WINDOWS VM's#####################################################
##Launch admin command prompt
diskpart
san
san policy=OnlineAll
exit

###Options san policy=OnlineAll | OfflineAll | OfflineShared



#################VIB INSTALL, LIST, UPDATE, DELETE################################

esxcli software vib install -v /path/to/vib/intel.vib
esxcli software vib install -d /path/to/zip/intel.zip
esxli sofware vib update -d /path/to/zip/intel.zip
esxcli software vib remove --vibname=name (get from esxcli software vib list or esxcli software vib list | grep intel)


######################VCSA/PSC CLI installation###################################################################
cd D: (or wherever your DVD is mounted)
cd vcsa-cli-installer\win32 (or if you are on Linux or MAC go to the folder)
.\vcsa-deploy.exe install --no-esx-ssl-verify --accept-eula --acknowledge-ceip C:\path\to\json\file\PSC_first_instance_on_ESXi.json
.\vcsa-deploy.exe install --no-esx-ssl-verify --accept-eula --acknowledge-ceip C:\path\to\json\file\vCSA_on_ESXi.json
.\vcsa-deploy.exe install --no-esx-ssl-verify --accept-eula --acknowledge-ceip --verify-only C:\path\to\json\file\vCSA_on_ESXi.json ##Verify file
.\vcsa-deploy.exe install --no-esx-ssl-verify --accept-eula --acknowledge-ceip --precheck-only C:\path\to\json\file\vCSA_on_ESXi.json ##As of 6.7+
#####Get supported deployment sizes great to see for different version of vcenter
.\vcsa-deploy --supported-deployment-sizes

##Get template examples help####
.\vcsa-deploy install --template-help
.\vcsa-deploy upgrade --template-help
.\vcsa-deploy migrate --template-help

##REF: https://www.vgemba.net/vmware/VCSA-CLI-Install/ 
##REF: https://www.altaro.com/vmware/vcenter-server-appliance-6-5-u1-linux/
##REF: https://docs.vmware.com/en/VMware-vSphere/6.7/vsphere-vcenter-server-67-installation-guide.pdf  

########################LIST ALL SERVICES##################################
chkconfig --list

#########Also useful
chkconfig -io


##############CHANGE IN ESXI 6.5#################################
##Please note in order to see services restart you will need to run an additional command

services.sh restart & tail -f /var/log/jumpstart-stdout.log

##Instead of######
services.sh restart

###########INSTALL THE NEW POWERCLI MODULES REFERENCE:https://blogs.vmware.com/PowerCLI/2017/04/powercli-install-process-powershell-gallery.html##
###Launch Powershell

######FIRST MAKE CERTAIN YOU REMOVE ALL REMNANCE OF THE OLD INSTALL######
###AFTER REMOVAL OF THE APP MAKE CERTAIN THE BELOW DIRECTRY HAS BEEN DELETED#####

##C:\Program Files (x86)\VMware\Infrastructure\

Find-Module -Name VMware.PowerCLI

####If you haven't installed NuGet you will be prompted to do so######
Install-Module -Name VMware.PowerCLI -Scope AllUsers(-Scope CurrentUser can also be used)

Get-Module VMware* -ListAvailable

####Then you can get the modules by#####
Import-Module VMware.PowerCLI

###Update to the latest version###
Update-Module -Name VMware.PowerCLI


####Now you can also import the individual modules into your scripts#####

#####See what modules and version is currently installed###########
Get-PowerCLIVersion ##This is going away and you should use Get-Module instead

Get-Module VMware.* | Select-Object -Property Name, Version

###########KILL a VM that won't shutdown############################

###List all VM processes on a host###########
esxcli vm process list

#Now let's kill the process
esxcli vm process kill --type= [soft,hard,force] --world-id= WorldNumber
esxcli vm process kill --type=hard --world-id=1234567

###Reference:  https://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=1014165




#################STORAGE DEEP DIVE##############################
####AHCI BASED SSD'S#########################
1 I/O = 27,000 cpu cycles
1 million IOPS = 27,000,000,000(that's 27 Billion)

##Intel E5-2630 V4 = 10 cores @ 2.20GHZ = 10x2.2billion Cycles = 22 Billion
##OR you need ~13 cores to push 1 million IOPS

###Another way of doing this##############
##2.20GHZ / 27,000 = 81,482 IOPS per core
##1,000,000 / 81,482 = ~12.27 cores required to push 1 million IOPS or 
##In a server with 2 E5-2630 V4's you would use an entire socket leaving 1 socket for actualy VM's

#####NVME BASED SSD'S##################
1 I/O = 9100 cpu cycles
1 million IOPS = 9100 x 1,000,000 = 9,100,000,000(9.1 Billion)
##OR you need ~ 4 cores to push 1 million IOPS

###Same as above##################
2.20GHZ / 9100 = 241,758.2418 IOPS
##1,000,000 / 241,758.2418 = ~4.14 cores to produce 1 million IOPS
###On a E5-2630 V4 that leaves 16 cores for work loads
###REF VMWARE VSPHERE 6.5 HOST RESOURCE DEEP DIVE LOC 3826(Digital Edition)


#####SILENT INSTALL VMWARE TOOLS##################################
setup64.exe /s/v"/qn reboot=r"
##The above will suppress reboot
setup64.exe /s/v"/qn" ##This will not

##The above works with all .exe installers for vmware tools


##############NETWORK COMMANDS#####################################
##esxcli network ip neighbor list ##Show ARP table

#####REF:https://www.tunnelsup.com/networking-commands-for-the-vmware-esxi-host-command-line/###


####REUSING DISKS AND CAN'T FORMAT IN ESXI##############################

###YOU MIGHT GET THE BELOW ERROR MESSAGE#############
###The primary GPT table states that the backup GPT is located beyond the end of disk. 
##This may happen if the disk has shrunk or partition table is corrupted. Fix, 
####by writing backup table at the end? This will also fix the last usable sector appropriately as per the new
######reduced size.

####TO FIX SIMPLY##########
partedUtil setptbl /vmfs/devices/disks/naa.600508b1001c5d5077836c8273f1e372 msdos



##############CHECK STATUS OF SYSTEM MODULES#######################
esxcli system module list | more

esxcli system module list | grep vmw_ahci  ##Just show me this module



#########MOVE ESXI SCRATCH LOCATION REF:https://kb.vmware.com/s/article/1014953##################
##You will only have issues with this if you install esxi to a thumb drive or a sd card
##on a datastore of your choosing create a folder .locker-esxhostname
##then under advanced settings for the host locate the following variable
ScratchConfig.ConfiguredScratchLocation

####Some usefule storage commands######
esxcli storage core device list
esxcli storage vmfs extent list
esxcli storage filesystem list  ###VERY USEFUL FOR MOVING YOUR SCRATCH SPACE######


#######ESXCLI command REF:https://www.vladan.fr/esxi-commands-list-getting-started/


###########BACKUP VCSA & PSC USING SCP#########################
#This is by far the easiest way
#path for scp: 1.1.1.1/home/user/VCSA
#scp: 1.1.1.1/home/user/PSC


#####FIX EMAIL ISSUES WITH VCSA#######################


1. Type "shell" to switch to the BASH shell

2. Change to the /etc/mail folder:

cd /etc/mail

3. Make a backup copy of submit.cf:

cp submit.cf submit.cf.orig

4. Edit submit.cf using vi, WinSCP, or whatever method you prefer and look for these lines:

# "Smart" relay host (may be null)

DS

After the "DS", enter the FQDN of your SMTP server like this:

# "Smart" relay host (may be null)

DS mailserver.domain.com

5. Then restart the sendmail service by running:

systemctl restart sendmail.service


####ADD VCSA ROOT CA TO LINU OR MAC###########################
##REF:https://blogs.vmware.com/vsphere/2015/03/vmware-certificate-authority-overview-using-vmca-root-certificates-browser.html
##.rO file is the CRL and the .O is the certificate in .PEM format



####So I had an issue deploying an OVA from Cisco, during validation it kept giving errors
###About missing key values, so fater some Googling I found this cool solution
##You can convert an OVA to VMX and then to an OVF using the ovftool
###cd to directory where ovftool is installed

ovftool C:\path_to_ova\appliance.ova C:\destinationpath\appliance.vmx

##Once finished make a directory to store final OVF files
ovftool C:\destinationpath\appliance.vmx C:\OVFexport\appliance.ovf

##Once everything was finished I was able to successfully import the appliance.

##REF: https://ripplesinharmony.wordpress.com/2017/09/19/installing-ise-2-3-on-esxi-6-x/


############UPDATE VMWARETOOLS ON A HOST USING VUM###########
########REF: https://vinfrastructure.it/2018/01/add-vmware-tools-v10-2-vsphere-environment/

###Simpliy import the Offline VIB into VUM by selecting "Patch Repository" > "Import" 
####And create a Baseline and then just attach it to a host or a cluster, Note for a single host
###This should work as maintenance mode is not required--Also this Offline VIB was made available
###After 10.2.x(I think please check VMware's site)
##Then you can upgrade VMware Tools on the guests using VUM as well under "VM Baselines"

###Note wait about 5 minutes or so and then your VM's should start showing that they are out of date
###No reboot of host(s) or VM(s) required


########Upgrade PSC/VCSA######################
##You can obviously use the VAMI
##Or head to VMware.com log in and then from top right menu select "Products > Product Patches", select VC and then the version
##Then you can download the .ISO file
##The third way is download the update bundle.zip file and place it on a web server but I need to test this way out.



###VCSA backup issues#####

##So I had an issue backing up the VCSA in which it did a validation and returned the below
##Error:  Invalid vCenter Server Status: All required services are not up! Stopped services: 'vmonapi'.
##So after a quick Google REF:https://vpxd.wordpress.com/2017/01/13/vcsa-vcenter-server-appliance-6-5-backup-troubleshooting/
##SSH into the VCSA login @ root
##If BASH isn't enabled follow the direction toenable it
##Then
service-control --status
##This should show running and not running services
#Then
service-control --start vmonapi(or whatever service the backup requires)



#########Using VUM to upgrade Esxi#############################
##Download your specific ISO from vmware.com, then upload into VUM
###Then create a base line and attach to a host or a cluster not you will have to disable admission control if
##it is enabled
##Also upgrade can be done using the .ISO image; there is also the offline bundle, which can be imported into VUM
##But I have not done it that way before.

#########So I had a weird issue after I upgraded one of our hosts and after the update completed
###vSphere HA agent failed to install with the error 'vSphere HA agent cannot be installed or configured'
##I tried to 'Reconfigure HA Agent' from the right mouse click, but that didn't work, I also restarted all
##services to no avail, then I found the below article which instructed me to turn of HA on the cluster and then
##turn it back on again, and viola that fixed the issue
##REF: https://anotheritguy.com/index.php/2017/08/vsphere-ha-agent-has-an-error-vsphere-ha-agent-cannot-be-installed-or-configured/




####So I had an issue with an esxi host where as the host had ssh locked out because of too many bad password
###attempts, so here are some commands to help out
##This will have to be run from the DCUI

pam_tally2 --user root ##see how many bad attempts and who is causing it
pam_tally2 uuser root --reset



#####CALCULATE NUMA SIZE OF A VM ############################################
###I NEED TO CHECK THIS I THINK IT'S WRONG################
##Formula = MAX_VM_MEMORY = Host RAM - (num sockets * num cores * NUM NUMA NODES)
##4 sockets, 6 cores, 4 NUMA nodes, 128GB RAM
##4 * 6 * 4 - 128 or ~32GB is the size the VM has to be
##REF: VMware session "Monster VM's" video @ 45:18

####More NUMA info###########################
Assign less or equal amount of vCPU´s to VMs than the total number of physical cores of a single CPU Socket
##(stay within 1 NUMA Node). Don´t count Hyperthreading!
##EX. 2 socket 10 cores per socket = 20 cores
##12vCPU VM would be configured as 2 sockets w/6 cores
##REF: https://itnext.io/vmware-vsphere-why-checking-numa-configuration-is-so-important-9764c16a7e73


##############More NUMA##############################################
####REF:  http://www.exitthefastlane.com/2016/04/vsphere-design-for-numa-architecture.html
##To see how many NUMA nodes are assigned to a VM 
esxtop
m then f then g 
##And look for "NHN"(Numa Home Node)
###While NUMA is exposed with 8VCPU's if those 8 fit within 1 NUMA node then from task manager
##On Windows, NUMA will still be disabled, this will only be enabled if you crose NUMA borderies
##This is regardless of if you use cores or sockets

#####VMware performance#################

##KAVG(Kernel Average latency) - time an I/O request spent waiting inside the vSphere storage stack.
##GAVG(Guest Average latency) - total latency as seen from vSphere(KAVG + DAVG)
##QAVG(Queue Average latency) - time spent waiting in a queue inside the vSphere Storage Stack

##REF: https://blogs.vmware.com/vsphere/2012/05/troubleshooting-storage-performance-in-vsphere-part-1-the-basics.html
##REF: https://www.petri.com/avoid-stroage-io-bottlenecks



#######NUMA EXPOSED OS VM OS####################
####NUMA layout is only exposed the guest os if a vm is configured for 8vcpu's or above and cpu hot add
###is not enabled


#######VCSA API##################################
https://vcsa_IP_OR_DNS/apiexplorer

####Grow VCSA disk using the api###################
####Obviously your first step would be to backup the PSC and the VSCA
##Then add storage to the affected disks in vCenter





####Visit https://VCSA_IP_OR_DNS/apiexplorer
###Select 'Appliance' and then 'login'
###Then under 'system/storage' '/appliance/system/storage/resize click the "Try it" button
###And then run df -h in the VCSA and you should have expanded your storage

####REF: https://www.virtuallyghetto.com/2016/11/updates-to-vmdk-partitions-disk-resizing-in-vcsa-6-5.html




###Match virtual disks to physical disks in Windows####

Get-WmiObject Win32_DiskDrive | select-object DeviceID,{$_.size/1024/1024/1024},scsiport,scsibus,scsitargetid,scsilogicalunit

##Output to a file####
Get-WmiObject Win32_DiskDrive | select-object DeviceID,{$_.size/1024/1024/1024},scsiport,scsibus,scsitargetid,scsilogicalunit | out-file -FilePath c:\OutputPhysicalDrive.txt

###If the drives are the same size and you need to delete the correct drive, match the 
###scscitargetid with the disk ID in vCenter i.e.
###SCSI(X:Y) usually you see 0:0 which means scsi port 0(or 1 for humans) and disk ID 0
###If you add another SCSI adapter in vCenter then it becomes 1:0, 2:0, 3:0 this will exhaust your 4 scsi controllers
###You are matching he number to the right of the colon; so after running the above command
####scsitargetif of 2 would be a disk that looks like 1:2, or 0:2, or 3:2, then mathc up your device ID's


#####I need to see how I can do this in Linux as well###########################################################
###Note the above comes in really handy if you have a VM with a lot of drives and quite a few of them are the 
####same size

#####REF: http://2ninjas1blog.com/how-to-match-and-correlate-windows-scsi-disk-ids-with-vmware-vmdks/


#######Find open ports on PSC/VCSA################

###ssh into the PSC/VCSA an enable bash shell if it is not already

netstat -atp | awk {'print $1","$4","$5","$6","$7'} | grep -Ev "ESTABLISHED|WAIT"

###Netstat REF: https://www.tecmint.com/20-netstat-commands-for-linux-network-management/"

#####awk Ref: https://www.tutorialspoint.com/awk/awk_basic_examples.htm



#######CPU Ready or %RDY##############
###REF: https://www.vladan.fr/what-is-vmware-cpu-ready/
##%RDY should be below 5%, note the more processors the more time it takes to schedule SMP
##Note in the GUI you want to select Readiness from custom as CPU Ready is in ms



#########HOST PROFILES########################
##REF: https://www.altaro.com/vmware/an-introduction-to-vmware-host-profiles/

######Naming logic##############
##pc(Private Cloud) ex. pcplvcsa
##hc(Hybrid Cloud)  ex. hctw16dockerm(Hybrid Cloud, Test Windows, Docker, Manager)


########Custum Alerts#############

##REF:https://www.virten.net/vmware/vcenter-events/



###Content libray improvements with 6.5###########
#REF: https://www.altaro.com/vmware/vsphere-6-5-content-libraries/

# - guest customization
# - update an existing template
# I'll add more here as a expirement



#####################VCSA STOP/START/RESTART SERVICES##################
##REF: https://kb.vmware.com/s/article/2147152

service-control --status  ##List all services running

##############PHOTONOS STOP/START/RESTART SERVICES####################

systemctl start service

systemctl stop service

systemctl restart service

systemctl status service

systemctl list-units --type service --all


##Webui not accepting password################

##So I ran into an interesting issue today, I did a fresh install of Esxi 6.5U2-HPE, and could
##Login into the DCUI without any issues, but when I tried to log into the webui
##It said my password was incorrect; after a quick Google I saw that others had the same issue
##And the fix was to log back into the DCUI select "Troubleshooting Options" and "Restart Management Agents"
##And viola I could login, let's see if the issue shows itself again, and do I need to re-install from scratch



###Good blog##########
##REF: http://blog.jgriffiths.org/


###Configure vcsa 5.5 ############
/opt/vmware/share/vami/vami_config_net

###SSO migration REFERENCE###

#REF: https://docs.vmware.com/en/VMware-vSphere/5.5/com.vmware.vsphere.vcenterhost.doc/GUID-689AC3F1-6654-4EE2-A146-663BD157FDC2.html


####Good article on repointing in vSphere 6.0 U1######################
###REF: https://blogs.vmware.com/vsphere/2015/10/reconfiguring-and-repointing-deployment-models-in-vcenter-server-6-0-update-1.html


############Get-View####################################################
##REF: https://blogs.vmware.com/PowerCLI/2015/02/get-view-part-1-introduction.html

$VMProps = Get-View -ViewType VirtualMachine -filter @{"Name"="test"}

$VMProps


####Host xxxxx is not compatible with the vDS version######################################
###So I ran across this in my home lab today when I attempted to add a host to a vDS it gave me the above message
###The issue had to do with the fact that I had upgraded the host from 5.5 to 6.5; the fix is quite simple
###Just "Disconnect" the host, "Remove from Inventory" and then just re-add it
##REF: https://vm.knutsson.it/2018/04/host-xxx-xxx-xxx-xxx-is-not-compatible-with-the-vds-version/



########Get your SSO name and Site name##################################
##REF: https://davidring.ie/2016/11/16/vcsa-6-0u2-lookup-sso-domain-name-site-name/

##Get SSO Name
/usr/lib/vmware-vmafd/bin/vmafd-cli get-domain-name --server-name localhost

##Get Site Name
/usr/lib/vmware-vmafd/bin/vmafd-cli get-site-name --server-name localhost

#Get PSC VCSA is pointing to#####
/usr/lib/vmware-vmafd/bin/vmafd-cli get-ls-location --server-name localhost

###Repoint VCSA 6.5+ with External PSC to another External PSC in the same site####################

cmsso-util repoint -repoint-psc FQDN_OF_PSC

/usr/lib/vmware-vmafd/bin/vmafd-cli get-ls-location --server-name localhost

##The Above should show the new PSC
##REF: https://davidring.ie/2018/06/07/vcenter-vcsa-6-5-repoint-to-new-psc/


##vSAN orphaned VM's
##REF: http://www.vmwarearena.com/manage-and-troubleshoot-vsan-cluster-using-rvc/
##REF: https://www.ivobeerens.nl/2017/03/21/fix-orphaned-vsan-objects/
###Enable RVC##################
##Login into the vCenter that is managing your vSAN cluster

rvc administrator@vsphere.local@localhost

##Follow the prompts; note this might require an internet connection so if your vCenter is firewalled off this might not
##Work; but I am not 100% certain about the req for internet connectivity

###So I had to fix some orphaned VM's in vSAN and the only way so far to do this is via the RVC(Ruby vSphere Console####
##Once you've followed the instructions above to enable the console simply run

 vsan.check_state -r /localhost/YOUR_DATACENTER/computers/YOUR_VSAN_CLUSTER


####Find lock files##############
##Works from ESXi 5.5PO5 and later########

cd /bin

vmfsfilelockinfo -p /vmfs/volumes/path_to_vmdk -v VC_IP_OR_DNS -u administrator@vsphere.local(or whatever your SSO is)

###Then reboot the affecting house###########

####GET CDP info CLI#########################
###REF:https://kb.vmware.com/s/article/1007069
###ssh into a host and run the below

vim-cmd hostsvc/net/query_networkhint

###For a specific vmnic######

vim-cmd hostsvc/net/query_networkhint --pnic-name=vmnic0(or whatever your vmnic is)

#########OR######################

esxcfg-info | less

##The above is terrrible to look at so I did this

esxcfg-info > /vmfs/volumes/localdiskname_or_whereever_you_want_to_store_this/output.logs

####Then simply download from the datastore and open in something like Notepad++ or Visual Studio Code and
####Do a search on CDP

####REF:https://blogs.vmware.com/PowerCLI/2017/06/spotlight-new-drs-cmdlets.html

####Join PSC 6.0 to AD##########################
##So ran into this issue while joining a 6.0 PSC to AD it can only be done from vCenter
##Under Administration > System COnfig > Nodes > PSC > Manage > Active Directory
##Also make certain your Domain and Forest Function levels are supported i.e. Server 2012 R2
##Also the user account just use username not enterprise\username
##REF: https://communities.vmware.com/thread/546744

###List installed software on VCSA/PSC(photonOS version only)
##ssh into the appliance and enable "bash"

tdnf list all | more

##Note the above won't list everything!!

#####Find the version of Jetty(Eclipse/Jetty which is a Java web server used by VUM)

cd /usr/lib/vmware-updatemgr/bin/jetty
vi VERSION.txt


###VCSA has storage removed non-gracefully######################
#The VCSA will boot into emergency mode and the type
##You should see a prompt that looks like :/#
##REF: https://nolabnoparty.com/en/vcsa-6-5-fails-to-start-file-system-check-and-network-service-errors/

fsck /dev/sda3
##answer yes to everything
reboot -f


############SSO SSPI issues with VCSA 6.5+##################################
##REF:https://kb.vmware.com/s/article/2118543
##So I was messing around with invoke-vmscript and I noticed that I was being prompted for creds when authenticating
##to my 2 vcsa's, my psc's were both joined to AD and I had set the AD domain as default, but still I was being prompted
##for creds, after some looking around I realized that I had to also join the VCSA's to AD, note only if you have external
##psc's if you are using embedded you don't need this extra step, the thing is you can't join the vcsa from the UI
##you have to do it from the command line so the below is command will fix your issue(hopefully)

/opt/likewise/bin/domainjoin-cli join vmware.local Administrator Passw0rd

##Note the above did not work for me as when I entered the username and password the command just returned nothing
##So I did this

/opt/likewise/bin/domainjoin-cli join vmware.local Administrator

##Which prompted me for a password and then that worked


####Wireshark for Esxi######
##REF:https://blogs.vmware.com/vsphere/2018/12/esxi-network-troubleshooting-tools.html
###REF:https://kb.vmware.com/s/article/2051814
##Capture output from a vmk interface
pktcap-uw --vmk vmk0 -o /tmp/test.pcap


#######Manually rename a VM and all files######################
###This is useful if you only have 1 datastore and called do a storage vMotion#########
##REF:https://kb.vmware.com/s/article/1029513

Renaming virtual machine files in-place using the console

Warning: Before proceeding, ensure that:
The virtual machine has a current backup and that it has been powered down.
The virtual machine does not have snapshots or virtual disks shared with other virtual machines.
To manually rename files of the virtual machine:
Log in to the VMware vSphere Client.
Locate the virtual machine in your host inventory.
Power down the virtual machine.
Right-click on the virtual machine and click Remove from inventory.
Open a console to the ESXi/ESX host. For more information, see Unable to connect to an ESX host using Secure Shell (SSH) (1003807) or Using Tech Support Mode in ESXi 4.1 and ESXi 5.x (1017910).
Navigate to the directory containing the virtual machine. 

For example:

# cd /vmfs/volumes/DatastoreName/originalname

Rename the virtual disk (VMDK) files using the vmkfstools -E command:

# vmkfstools -E "originalname.vmdk" "newname.vmdk"


For more information, see Renaming a virtual machine disk (VMDK) via the vSphere Management Assistant (vMA) or vSphere CLI (vCLI) (1002491).


Notes:
In some cases, it may be required to clone (copy) a virtual disk. To clone a virtual disk to a new virtual disk, run this command:

# vmkfstools -i "originalname.vmdk" "newname.vmdk"

This leaves the original virtual disk untouched. You need enough space available to clone the virtual disk in the destination directory. In the preceding command, the new virtual disk is created in the current directory but a different directory can be specified.

You need not rename the originalname-flat.vmdk file after running the vmkfstools command. The vmkfstools command renames both VMDK files and updates the reference within the descriptor.

Do not use the cp or mv commands to rename virtual disk files. Instead, use VMware utilities such as vmkfstools.

Copy the virtual machine configuration file (.vmx) using the command:

# cp "originalname.vmx" "newname.vmx"

Open the file new virtual machine configuration (for example, newname.vmx) in a text editor. 

For more information, see Editing configuration files in VMware ESXi and ESX (1017022).

For example:

# vi "newname.vmx"

Within the configuration file, modify all old instances of the virtual machine's file names to the new file names. At a minimum, modify these values (more may exist):

nvram = " newname.nvram"
displayName = " newname "
extendedConfigFile = " newname .vmxf"
scsi0:0.fileName = " newname .vmdk"
[...]
migrate.hostlog = "./ newname -UUID.hlog"

Repeat this process for each virtual machine disk. For example:

scsi0:1.fileName = " newname _1.vmdk"
scsi0:2.fileName = " newname _2.vmdk"

Correct the VMkernel swap file reference. 

For example:

sched.swap.derivedName = "/vmfs/volumes/DatastoreUUID/ newname/ newname-UUID.vswp

Note: Ensure that you rename both the .vswp file and the directory name for the swap file in bold.

Correct any other remaining lines referencing the original path or file names.
Save the file and exit the editor.
Rename all the remaining files, except the .vmx configuration file, to the new names.

For example:

# mv "originalname.nvram" "newname.nvram"

Change directory to the parent directory:

# cd ..

Rename the directory for the virtual machine:

# mv "originalname" "newname"

Using the VMware vSphere Client, browse the datastore and navigate to the renamed virtual machine directory.
Right-click the virtual machine's new configuration file (for example, newname.vmx) and select Add to inventory.

Alternatively, you can use this command to add the virtual machine to the inventory:

For ESX:

# vmware-cmd -s register "/vmfs/volumes/DatastoreName/newname/newname.vmx"

For ESXi:

# vim-cmd solo/registervm /vmfs/volumes/DatastoreName/newname/newname.vmx

Power on the virtual machine.
A question for the virtual machine displays in the Summary tab during power-on. To review the question:

Click the Summary tab.
Right-click the virtual machine in your inventory and select Answer question.

When prompted, select I moved it, then click OK.

Warning: Selecting I copied it results in a change of the virtual machine's UUID and MAC address, which may have detrimental effects on guest applications that are sensitive to MAC address changes, and virtual machine backups that rely on UUIDs.

Optionally delete the original virtual machine configuration file.

For example:

# rm /vmfs/volumes/DatastoreName/newname/originalname.vmx


####NFS esxi troubleshooting######################
##REF:https://kb.vmware.com/s/article/2016122?lang=en_US

cat /var/log/vobd.log | less

###You can also look here for general storage issue####

cat /var/log/vmkernel.log |grep -i nfs | less

cat /var/log/vmkernel.log |grep -i | less



#######Get Esxi version & build # CLI######
##REF:https://kb.vmware.com/s/article/1012514
vmware -l ##esxi version
vmware -v ##build number
esxcli system version get



###Network troubleshooting####################
#REF:https://www.jortechnologies.com/vcsa-6-5-photon-network-commands-and-troubleshooting/
#REF:https://blogs.vmware.com/vsphere/2018/12/esxi-network-troubleshooting-tools.html

#nc -zv IP port
nc -zv 192.168.1.1 80


######Resize root partition################################################################
##REF:http://www.enterprisedaddy.com/2016/08/expand-vmfs-datastore-command-line/#prettyPhoto
##REF:https://kb.vmware.com/s/article/2002461
###While you can expand the local datastore of the partition that esxi is not installed on
###you have to use the cli to expand a local datastore that has esxi on it##

esxcfg-scsidevs -m   ##let's get our scsi disks

partedUtil getptbl /vmfs/devices/disk/....  ##this is from the above output

####If you receive an error message about the back partition is not at the end then run this

partedUtil fix /vmfs/devices/disk/....

partedUtil getUsableSectors /vmfs/devices/disk/....

partedUtil resize /vmfs/devices/disk/.... 3(this number is usually for vmfs again you get from getptbl)(start-block we also get from
getptbl) (end-block we get from getUsablkeSectors)

#EX.
partedUtil resize /vmfs/devices/disk/mpx.vmhba0... 3 1000 5000

vmkfstools --growfs /vmfs/devices/disk/....:3 /vmfs/devices/disk/....:3

##If you did everything correctly then you should have more space on the vmfs partition to place VM's
vmkfstools -V  ##refresh everthing



##########NIC issues######################

##It is very important to make certain that if you have 2 or 3 o N nics on a vswitch or vDS that they are configured
##exactly the same, i.e. if 1 is set to auto negotiate they should all be or if you hard code the speed, hard code all
##the same.


##Install PowerCLI offline###############
##REF: https://blogs.vmware.com/PowerCLI/2018/01/powercli-offline-installation-walkthrough.html
##The article above worked for me make sure that both the source server and the destination is
##running powershell 5.x if not you could have some issues desscribed in the article
##also run the below command to see the PSModulePath

Save-Module -Name VMware.PowerCLI -Path C:\Modules

$env:PSModulePath

##I then copied the folders to the C:|Program Files\... from the above output



#############HOST PROFILES ISSUES###########################################
###So I was messing around with host profiles and ran into a couple of issues
##1. make sure the vmk ports matching from the host you captured the profile from
##to the host(s) you are attempting to apply it to I received the error
##"Host unable to check compliance" ref:https://communities.vmware.com/thread/440433
##sure enough I had different # vmk's so I captured the profile from the host that was having the issue
##as the other nodes were all the same
##2. When configured a syslog server in the host profile, make certain the "SYSLOG SERVER IS UP AND RUNNING"
##If not it will fail to apply the profile

####Also strip out as many things as possible from the profile, network,storage etc.. the less in the profile
###The better


#########CREATE VM ENCRYPTION POLICY##############
###When creating an VM encryption policy you must select under "Encryption" "Custom" > "Provider" > 
###"VMware VM Encryption" > "Allow I/O filters before encryption = FALSE"
##If you don't you will see VM's with encrypted home directories, but not encrypted Hard drives



###This sure came in handy my root password to the VCSA appliance password expired and I had to reset it
##REF:https://www.virten.net/2018/05/vcenter-service-appliance-6-7-tips-and-tricks/

##reboot appliance and then hit 'e' when you see the photon os splash screen
##then enter at the end of linux line(after consoleblank=0) rw init=/bin/bash and hit f10
##then passwd
##then umount /
##then reboot -f

##Then once you log back in change the default 90 days expiration, I turned it off

##Get WWN's
##REF:https://nutzandbolts.wordpress.com/2013/02/25/get-hba-wwn-for-hosts-using-powercli/


######ESXCLI NETWORK COMMANDS##############################################

esxcli network vswitch standard add --vswitch-name=vSwitch4 --ports=24

esxcli network vswitch standard uplink add --uplink-name=vmnic3 --vswitch-name=vSwitch4

esxcli network vswitch standard policy failover set --active-uplinks=vmnic3 --vswitch-name=vSwitch4

esxcli network vswitch standard portgroup add --portgroup-name=Automation-SPG --vswitch-name=vSwitch4

esxcli network vswitch standard portgroup set --portgroup-name=Automation-SPG --vlan-id=1000


############iSCSI port binding links##################################
##REF:https://kb.vmware.com/s/article/2045040
##REF: https://kb.vmware.com/s/article/2038869


##Get host PSP###################
##REF:https://pubs.vmware.com/vsphere-50/index.jsp?topic=%2Fcom.vmware.vcli.ref.doc_50%2Fesxcli_storage.html


esxcli storage nmp device list


###NVME ISSUES WITH ESXI 6.7U1 and above#########
##REF:https://vm.knutsson.it/2019/02/vsan-downgrading-nvme-driver-in-esxi-6-7-update-1/amp/

##So this happened to after upgrading to 6.7U1 ESXi no longer
##recognized by HP NVME ssd so I found an article that said to
##Simply take the NVME drivers from the ESXi 6.7 GA iso
## and install it effectively downgrading the driver, and it worked

esxcli software vib install -v VMware_bootbank.....nvme-plugin.vib

esxcli software vin install -v VMW-bootbank_nvme.....vib 

reboot



####INSTALL ESXI VIA KICKSTART SCRIPT#################################
##REF:https://www.altaro.com/vmware/scripted-deployment-esxi-part-1/
##REF:https://www.altaro.com/vmware/scripted-deployment-esxi-part-2/
##REF:https://www.techcrumble.net/2017/08/esxi-kickstart-installation-scripted-weasel-installation/
##REF:http://buildvirtual.net/configure-advanced-bootloader-and-kernel-options/
##REF:https://kb.vmware.com/s/article/2004582

##BEGIN FILE#####################

vmaccepteula
 
# clear paritions and install
clearpart --firstdisk --overwritevmfs
install --firstdisk --overwritevmfs
 
#set the root password
rootpw --iscrypted $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#rootpw myPassword
 
#Host Network Settings
#network --bootproto=static --addvmportgroup=1 --ip=192.168.0.10 --netmask=255.255.255.0 --gateway=192.168.0.1 --nameserver=192.168.0.1 --hostname=ESXHOST1
network --bootproto=dhcp --addvmportgroup=1 --device=vmnic0
 
reboot
 
#Firstboot section 1
%firstboot --interpreter=busybox
### Rename local datastore
vim-cmd hostsvc/datastore/rename datastore1 "$(hostname -s)-LOCAL"
 
    
 
sleep 30
 
#Enter Maintenance mode
#vim-cmd hostsvc/maintenance_mode_enter

### Enable maintaince mode
esxcli system maintenanceMode set -e true
 
#suppress Shell Warning
#esxcli system settings advanced set -o /UserVars/SuppressShellWarning -i 1
#esxcli system settings advanced set -o /UserVars/ESXiShellTimeOut -i 1
 
#Add DNS Nameservers to /etc/resolv.conf
#cat > /etc/resolv.conf << \DNS
#nameserver 192.168.0.1
#nameserver 192.168.0.2
#DNS

##Add DNS server(s)
esxcli network ip dns server add --server=192.168.2.2
esxcli network ip dns server add --server=192.168.3.3

##Add NTP server
esxcli network
 
#VSwitch Configurations
#esxcli network vswitch standard add --vswitch-name=vSwitch0 --ports=24
esxcli network vswitch standard uplink add --uplink-name=vmnic0 --vswitch-name=vSwitch0
esxcli network vswitch standard uplink add --uplink-name=vmnic1 --vswitch-name=vSwitch0
esxcli network vswitch standard policy failover set --active-uplinks=vmnic0,vmnic1 --vswitch-name=vSwitch0
esxcli network vswitch standard portgroup policy failover set --portgroup-name="Management Network" --active-uplinks=vmnic0,vmnic1
#esxcli network vswitch standard portgroup add --portgroup-name=ESXHOST1-prod0 --vswitch-name=vSwitch0
#esxcli network vswitch standard portgroup remove --portgroup-name="VM Network" --vswitch-name=vSwitch0
 
#Firstboot Section 2
%firstboot --interpreter=busybox
 
 
#Disable IPv6
esxcli network ip set --ipv6-enabled=false
 
#Reboot
sleep 30
reboot


####EOF############################

##Note this is an initial attempt and I was able to install ESXI but I think because there was no DHCP server
### only what was above #Firstboot section 1 was executed and nothing below it, I will have to run more tests.

####UPDATE THE ISSUE IS SECURE BOOT IF SECURE BOOT IS ENABLED ONLY WHAT'S ABOVE Fristboot 1 will be executed
###TURN OF SECURE BOOT AND RUN AGAIN AND EVERYTHING SHOULD BE FINE




####MINIMUM RIGHTS to GET VIB's from ESXI################
##REF:https://blogs.vmware.com/vsphere/2013/04/minimum-privileges-to-query-vibs-on-an-esxi-host.html

##Global.Settings is all you need
##so I just created a modified Read-Only Role and added it to that.

###VUM update issues###
##REF#http://jasonnash.com/esx-host-cant-download-patches-from-update-manager/
##If you see the below error message while scanning for or applying updates###


#Host cannot download files from VMware vSphere Update Manager patch store. 
#Check the network connectivity and firewall setup, and check esxupdate logs for details.

##Check your DNS I had the wrong DNS server configured, once I made the change, viola!!!!!



##View log files that are .gz######
##REF:https://www.cyberciti.biz/faq/unix-linux-cat-gz-file-command/
zcat vpxd-1234.log.gz | grep -i error


######vmk1 unknown using vmkping###
##REF:https://vlenzker.net/2016/03/how-to-do-the-esxi-vmkernel-ping-unknown-interface-invalid-argument/

##This is due to changing the default tcpip stack in my case to vmotion so you have to do this instead

vmkping -I vmk1 xx.xx.xx.xx -S vmotion



##Get CDP information from Esxi CLI####
##REF:https://kb.vmware.com/s/article/1007069

vim-cmd hostsvc/net/query_networkhint --pnic-name=vmnic0  ##just query vmnic0

##Get all PNICS

vim-cmd hostsvc/net/query_networkhint


####Disable vSAN on a cluster###############

## Move all VM's off of the vSAN datastore and any data that you may want to keep
## Disable HA and for good measure DRS
## Then on each host delete the disk group and when asked to move the data say no movement(this will be destructive)
## Turn off 'vSAN' on the cluster

##If you would just like to remove a host or a couple of hosts then
## Place the host(s) in maintenance mode and do a 'Full data Migration'
## Once migration is complete and the host(s) are in maintenance mode then remove the disk group(s) from the host(s)
## then remove the host(s) from the cluster and those host(s) can be re-used.


####Clone VM###############
#1. Clone VM
#2. Delete NIC
#3. Login and change admin password
#4. Unjoin from domain you can then reboot and then rename the server and reboot again, or just rename after the unjoin
##Note under most circumstances you will replace step 4 with a sysprep generalize

##Also in a VMware environment before you re-add the NIC log into the VM and under device manager enable hidden devices
##And delete the vmxnet device, don't delete the driver, this way when you add the NIC it will be a fresh device


###Disable datastore heartbeat warning on a cluster#############
##You might have to reconfigure HA
##REF:https://www.petenetlive.com/KB/Article/0001202

das.ignoreInsufficientHbDatastore  
set to 'true' #no quotes


##Install UMDS Windows Server 2016##########
##REF:http://10.143.5.210/umds_store/
##note the above isn't entirely correct it seems just like on Linux there is no longer a requirement
##for a DB as of 6.7U3
##So just install IIS, mount the windows iso and install UMDS service...




###########REST API##############################
##Let's get a token using a rest client i.e. postman, talend api testers
##REF:https://creativeview.co.uk/VMware-vCenter-REST-API-Part-2/#.XeUTMvVKhPY

##Send a POST request to the below URL and use basic auth with your vc creds
https://{{vc}}/rest/com/vmware/cis/session
##vCenter uses Basic auth, so will have to set that up with you're preferred client
##usually though it's pretty easy to set that up with your REST client


####Let's get all our VM's(I think this is limited to the first 1000)
###And add a header key value pair of vmware-api-session-id:token_received_from_above
##Header {Authorization: Basic xxx}

##Send a GET request to https://{{vc}}/rest/vcenter/vm

###Let's find only powered on VM's

##Send a GET request to https://{{vc}}/rest/vcenter/vm?filter.power_states=POWERED_ON


###Get details for a specific VM

##Send a GET request to https://{{vc}}/rest/vcenter/vm/vm-xxx


#####Export VM logs#######
#REF:https://communities.vmware.com/thread/445844
##SSH to the host and cd to the datastore
cd /vmfs/vols/vol1/vm1

###The current log is vmware.log but that file is locked so try this
cat vmware.log > vmware_cur.log

########Remove a host to be renamed from vCenter when attached to a vDS####
###REMOVE THE HOST CLEANLY FROM THE  vDS FIRST TO SAVE YOURSELF FROM THE PAIN THAT COMES IF YOU DON'T


#####Accessing vPostgress database#######
##REF:http://www.vmwarearena.com/basic-commands-interact-vcsa-6-5-embedded-vpostgres-database/
##REF:https://thinkvirtualblog.wordpress.com/2015/04/04/how-to-connect-to-vcsavcva-postgres-database/
###SSH into the VCSA and get type shell

cd /etc/vmware-vpx
cat embedded_db.cfg
###note i had a weird issue when I used the password from the above file, maybe I just fat fingered it
/opt/vmware/vpostgres/current/bin/psql -d VCDB -U postgres

##as long as your password worked you should be at the below prompt
VCDB=#

VCDB=#\l+  ##list all db instances
VCDB=#\d+  ##list all tables
VCDB=#\df  ##list all functions

##We can run queries as well

select * from vpx_version;

select * from vpx_host;  ##this outputs a lot of crap I need to fifure out how to format nicely in postgres

select pg_size_pretty (pg_database_size('VCDB'));  ##get the size of the VCDB database

VCDB=# \q  ##quit





###So I saw the below error message when attempting various tasks

/var/log/journal/xxx could not write disk is full( I'm paraphrasing here)

##So I found the below command

vdf -h


##Which showed /var being 100% full, so I rebooted my host and then ran the above again and viola /var was not full
## the host was up for 97 days


##VCSA livecore dump
##REF:https://pradeeppapnai.com/2019/06/03/vmon-cli/

vmon-cli -d vpxd

##then find your dumps @
/var/core

###get cdp information from esxcli
#REF:https://kb.vmware.com/s/article/1007069

vim-cmd hostsvc/net/query_networkhint -–pnic=vmnic1 | egrep ‘vlan’

vim-cmd hostsvc/net/query_networkhint | egrep ‘vlan’

##the above does not

vim-cmd hostsvc/net/query_networkhint | less

###Add public cert to VCSA 7.x
#REF:https://blog.rylander.io/2020/04/28/add-lets-encrypt-certificate-to-vcenter-7/

##Note if you are using Letsencrypt you have to choose
## Replace with external CA certificate(requires private key)
##If you generated a CSR on the appliance then you need to choose
##Replace with external CA certificate where CSR is generated from vCenter Server (private key embedded)

##Note the above blog resolved my issues with the "trust anchors... error" you have to create a new fullchain.pem 
##The new fullchain should only include the intermediate and root nothing else, in that order, intermediate and then root

#1. Intermediate cert get from here: https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem.txt #note links do change
#2. Root cert get from here: https://www.identrust.com/dst-root-ca-x3 #again link change

##Note just that the links expire but the above certs do expire so get them from the below, these should be updated
##Just download the PEM file
##Get the intermediate and root from here https://letsencrypt.org/certificates/
##I just changed out my cert for the second time and found some new tidbits, when getting the pem files from above
##Make sure you match things up if you use the cross-signed root use the cross-signed intermediate, I used the non-cross-signed certs
##I have not tested out the cross-signed intermediate and root
##Also I pointed to the files for the cert and new fullchain and cat the private key, and that worked like a champ for me.


##that should do it when you go to replace the cert you will have the first cert with is the cert(x).pem, then the above cert you just assembled
##then the private key

##Note when I deploy my vCenters I use uppercase in the FQDN name, well VMware signes the self-signed cert exactly as it sees, letsencrypt would not
##let me create a cert with uppercase maybe a paid authority will but if not then you will not be able to swap out your cert as it will 
##generate an error like "CN does not match"


####VCSA fails to update with error "vCenter is non-operational"#####
##REF:https://tinkertry.com/how-to-workaround-unexpected-error-occurred-while-fetching-the-updates-error-during-vcsa-7-upgrade

rm /etc/applmgmt/appliance/software_update_state.conf

####Test UDP connectivity####
##REF:https://www.thegeekdiary.com/how-to-test-porttcp-udp-connectivity-from-a-linux-server/

nc -z -v -u 192.168.10.12 123


#####Using telnet###
###REF:https://kb.vmware.com/s/article/2097039

curl -v telnet://target ip address:desired port number

curl -v telnet://127.0.0.1:22


```VCSA or ESXi SHA footprint```

````

#VCSA
openssl x509 -in /etc/vmware-vpx/ssl/rui.crt -fingerprint -sha1 -noout

#ESXi
openssl x509 -in /etc/vmware/ssl/rui.crt -fingerprint -sha1 -noout

````

[https://vmware.github.io/vic-product/assets/files/html/1.2/vic_vsphere_admin/obtain_thumbprint.html](https://vmware.github.io/vic-product/assets/files/html/1.2/vic_vsphere_admin/obtain_thumbprint.html)


```vCenter Machine TLS cert expires```

#### So this just happened to me, I purchased a TLS cert for vCenter and it expired on 3-3-2024, when I attempted to log into vCenter I saw the below error message(s)

````
503 Service Unavailable

#or

No healthy Upstreams
````

#### I logged into the Appliance so I could look at some logs

````
cat /var/log/vmware/vpxd/vpxd.log

````

#### And in the above log I saw error messages related to an expired certificate(Again I new this was the case). So how did I fix it, first I ran the below command to make sure only the 1 cert was expired

````
for store in $(/usr/lib/vmware-vmafd/bin/vecs-cli store list | grep -v TRUSTED_ROOT_CRLS); do echo "[*] Store :" $store; /usr/lib/vmware-vmafd/bin/vecs-cli entry list --store $store --text | grep -ie "Alias" -ie "Not After";done;

````
[https://kb.vmware.com/s/article/82332](https://kb.vmware.com/s/article/82332)

#### And now I needed to just re-generate a Self-signed cert so the UI had a healthy certificate

````
/usr/lib/vmware-vmca/bin/certificate-manager #Option 3

````

#### In the above I chose option 3 as I just wanted a vanilla self-signed cert, once successful all services will get restarted and you should be able to log back into the vCenter UI

[https://kb.vmware.com/s/article/2097936](https://kb.vmware.com/s/article/2097936)



```cloud-init```


##### Adding cloud-init to a VM is relatively simple, before you power on the VM you just need to add 2 entries to "VM Options > Advanced > Configuration Parameters"

````
guestinfo.userdata.encoding: base64
guestinfo.userdata: BASE64_ENCODED_DATA_GOES_HERE
````

##### Then simply power on the VM and that should do it

[https://www.youtube.com/watch?v=lhWQBz5oj8o](https://www.youtube.com/watch?v=lhWQBz5oj8o)
