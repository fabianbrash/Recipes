# Various Powershell commands for installing and configuring a Server core and Server GUI install


``` Configure Server core```
````
sconfig
````
```Powershell AD Join commands```
```` 
#Check available commands 
Get-command –module ADDSDeployment 
 
#Run Powershell against remote servers 
invoke-command {install-addsdomaincontroller –domainname ethernuno.intra –credential (get-credential) –computername dc02 
 
#Simplest way of Creating a new Forest 
Install-ADDSForest –DomainName "lab.net" 
 
#Customized Configuration  
Install-ADDSForest –DomainName ‘lab.net’ –CreateDNSDelegation –DomainMode Win2012R2 –ForestMode Win2012R2 –DatabasePath "d:\NTDS" –SYSVOLPath "d:\SYSVOL" –LogPath "e:\Logs"
Install-ADDSForest –DomainName $domain –DomainMode Win2012R2 –ForestMode Win2012R2 -Force -SafeModeAdministratorPassword (convertto-securestring $password -asplaintext -force) –DatabasePath $locationNTDS –SYSVOLPath $locationSYSVOL –LogPath $locationNTDSLogs -verbose

#First you MUST install AD Role on Server
Install-Windowsfeature AD-Domain-Services,DNS

#Join an existing Domain this is the replacment for DCPROMO
Install-ADDSDomainController -DomainName 'awssol.com' -InstallDNS:$True –Credential (Get-Credential) 

#CleanUp commands 
Get-help Uninstall-ADDSDomainController 
 
#Demote Commands 
Uninstall-ADDSDomainController –Forceremoval -Demoteoperationmasterrole 
````

#### Set TrustedHost this is required to remotely manage a server when both systems are not apart of a Domain

````
Set-Item WSMan:\localhost\Client\TrustedHosts -Value ‘hostname,hostname.local’ –Force 
Set-Item WSMan:\localhost\Client\TrustedHosts -Value ‘IP,IP’ –Force

#####Get Trusted Hosts###################################
Get-Item WSMan:\localhost\Client\TrustedHosts

#Get windows features
Get-Windowsfeature
Get-WindowsFeature | more
Get-WindowsFeature -Name AD*, Web*  ##Get all features with AD and web in the name
Get-WindowsFeature | Where Installed #just get installed features
Get-WindowsFeature | Where Installed | Select Name  ##Just give me the names so we can pipe to a file

#Install windows feature
Install-Windowsfeature -Name 'FeatureName' -IncludeAllSubFeature -IncludeManagementTools
Install-Windowsfeature -Name 'FeatureName','FeatureName'

#Disable FireWall You can also do this with a GPO Computer Config>Admin Templates>Network>Network Connections>Windows Firewall
#Advance Firewall settings GPO comouter config>Policies>Windows Swttings>Security Settings>Windows Firewall with Advanced Security
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

#In a virtual environment you will need configure an external time source for your PDC
w32tm.exe /config /manualpeerlist:"0.us.pool.ntp.org 1.us.pool.ntp.org" /syncfromflags:manual /reliable:YES /update
w32tm.exe /config /update
Restart-Service w32time

#Remote Volume Management
#VDS must be running on both the local and remote device, please make certain to open up 'Remote Volume Management' 

#Must register this on each DC so you can move Schema master role
regsvr32 schmmgmt.dll
#Then load mmc.exe and you should now see an options for 'Active Directory Schema'
###I had an odd issue when attempting to transfer to the schema master role, I kept getting an error
##Schema master could not be contacted, to fix I made certain the schema master has an alternate DNS server
##In my case the DNS of the DC I wanted to be the new schema master, ODD!!
````

```Create Bootable USB stick for Server 2012 R2 I will assume this will work for 2016 as well```

#### Pre-requisites: 7-Zip software [Download](http://7-zip.org/) Windows 2012 (R2) ISO (or Windows 8.1 ISO), 8GB or more USB disk

````
Open Command Prompt in elevated mode (Run as Administrator)
Type diskpart and press Enter
Type list disk and press Enter. Note the list of existing disks.
Insert the USB Disk
Type list disk and press enter again. Note the new disk showed up which is our USB disk. I assume the new disk is 2 for example purpose.
Type select disk X where X is your USB disk. E.g., select disk 2. Press Enter.
Type clean and press enter.
Type create partition primary and press enter to create primary partition 1.
Type select partition 1 and press enter.
Type active and press enter to make the partition 1 active
Type format fs=ntfs and press enter. This will format the partition 1 as NTFS volume.
Type assign and press enter to assign the USB disk to a drive letter.
```` 
````
Now right click on Windows Server 2012 R2 or Windows 8.1 ISO file, select 7-Zip –> Extract Files…
Select your USB disk to extract the ISO contents to the USB disk
That’s all. Boot the server or computer using the bootable USB disk.
````


### Note I simply formatted the USB disk as NTFS in the GUI and then I set the partition as primary
### This also will allow you to upgrade a server instead of doing a clean install

#### Enable Disk performance metrics under server 2012,windows 10, server 2016, windows 8.1 from command prompt enter

````
diskperf -Y
````

#### Windows update tries to update but stops @ updating n%
##### This is probably due to a power outage as the VM was doing it's update
##### boot into safe mode and run make certain C is the correct drive of your Windows install, in my case it was D

````
dism.exe /image:D:\ /cleanup-image /revertpendingactions
######You can also attempt to rename the following file
c:\windows\winsxs\pending.xml
````

```UPGRADING ROOT CA FROM SHA1 TO SHA256```

##### THIS IS IF YOU ONLY HAVE A ROOT CA AND YOU DON'T HAVE SUB-CA'S PLEASE REFERENCE 
[https://www.petenetlive.com/KB/Article/0001243](https://www.petenetlive.com/KB/Article/0001243)

````
#Launch powershell
certutil -setreg ca\csp\CNGHashAlgorithm SHA256
net stop certsvc
net start certsvc
#########Then Renew your Root Certificate and it should now show SHA256
#####FROM YOU CA "Renew CA Certificate" make certain you select "NO" to "Generate new public and private keys"
########ALSO YOU CAN DO THIS SIMPLY IF YOUR CRYPTOGRAPHIC PROVIDER IS "Microsoft Software Key Storage Provider" again refer to above link
####NOTE YOU MUST RUN GPUPDATE /FORCE SO THE NEW CERTIFICATE CAN REPLICATE TO YOUR ENDPOINTS "TRUSTED ROOT CERTIFICATE AUTHORITY"##
#####ALSO YOU CAN USE THE lpd.exe TOOL TO TEST LDAPS FUNCTUNALITY LDAP PORT:389 LDAPS:636###################
````

```FORMAT A DISK 8K BLOCK SIZE```

##### This can be done from the GUI or from diskpart
###### let's first check our current unit allocation size
###### launch elevated command prompt

````
fsutil fsinfo ntfsinfo 'your drive' 'bytes per cluster is your unit allocation'

######now let's format using diskpart
elevated command prompt
diskpart.exe
list volume or list disk
select volume 'your volume number' or select disk
````
#### You can also create a 500 MB partition if this is your C drive like so

````
create partition primary size=500
format quick
####this will give you a 500MB partition and then the below will format the rest as 8k block size
create partition primary
format fs=ntfs quick unit=8192 label=data or
format fs=ntfs quick unit=8k label=data

Boot from Windows installation media.
Press Shift+F10 at the first setup screen to open a command prompt.
Run the following commands to create the partitions:
diskpart
list disk [should only see disk 0]
select disk 0
clean all [erase hard disk (slow process)]
create partition primary size=500 [This will set the size of the System Reserved partition to 500MB (Windows10)]
active
format fs=ntfs label=”System Reserved” quick [This performs a quick format of the System Reserved Partition and sets the cluster size to 4096]
create partition primary                        
format fs=ntfs label="OS" quick unit=8192 [This performs a quick format of the OS Partition and sets the cluster size to 8192]
assign
exit
exit
Install OS
````

```8K BLOCK ON UEFI/EFI SYSTEMS```

[https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/configure-uefigpt-based-hard-drive-partitions](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/configure-uefigpt-based-hard-drive-partitions)

````
##Same as above Shif+F10
list disk
select disk x
clean all ##you can just do 'clean' as well
convert gpt
create partition efi size=100
format quick fs=fat32 label="System"
assign
create partition msr size=16 (Microsoft Reserverd partition)
create partition primary
format quick fs=ntfs label="Windows" unit=8192
assign
exit
exit
Install OS
````

```CHANGE DEFAULT COMPUTER AND USER OU```

````
##Computer redirect
redircmp ou=ComputersOU,dc=mydomain,dc=com

##User redirect
redirusr ou=UsersOU,dc=mydomain,dc=com

##In my case
redircmp "OU=fbWorkstations,DC=fb,DC=com"
````

```INSTALL .NET FROM DVD```

````
DISM /Online /Enable-Feature /FeatureName:NetFx3 /All /LimitAccess /Source:d:\sources\sxs (D is DVD drive)
````


```POWERSHELL FIREWALL CONFIG```

````
Get-NetFirewallProfile | Select name, enabled
or
Get-NetFirewallProfile

Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
````

```SET ENVIRONMENT VARIABLES```
````
Get-ChildItem Env: (List all environment variables)
echo $Env:ProgramFiles (Just list the variable for ProgramFiles)

setx JAVA_HOME "C:\Program Files\Java\jdk1.8.0_121\"
setx path "%path%;%JAVA_HOME%\bin"
````

```RSOP.MSC``` 

[https://prajwaldesai.com/modify-group-policy-refresh-interval-windows-computers/](https://prajwaldesai.com/modify-group-policy-refresh-interval-windows-computers/)

````
##Log on to local pc and run the below
rsop.msc
````


```WINDOWS UPDATE REBOOT LOOP```

### Wndows continuosly prompt user to reboot machine to apply an update

````
##Delete the following reg key
HKLM/Software/Microsoft/Windows/CurrentVersion/WindowsUpdate/Auto Update
##Look for "RebootRequired"
#Delete the entire folder
````
[http://www.squidworks.net/2012/06/solved-always-getting-message-windows-cant-update-important-files-and-services-while-the-system-is-using-them/](http://www.squidworks.net/2012/06/solved-always-getting-message-windows-cant-update-important-files-and-services-while-the-system-is-using-them/)



```STEPS FOR LAPS IMPLEMENTATION```

````
###Download LAPS from Microsoft###################################

####On a management server install the entire LAPS tool LAPS64.msi(or LAPS32.msi)#######

####SOME USEFUL COMMANDS#########################

Import-Module AdmPwd.PS ##This is required in ISE but not if you are running interactively on the command line
Get-Command -Module AdmPwd.PS

###LETS UPDATE THE SCHEMA####################

Update-AdmPwdADSchema


#########LETS GRANT COMPUTERS THE ABILITY TO UPDATE THERE PASSWORDS###############

Set-AdmPwdComputerSelfPermission -Identity "Computers_OU"
##OR
Set-AdmPwdComputerSelfPermission -OrgUnit "OU=MyComputers,DC=lab,DC=org"

#####LETS SEE WHO HAS RIGHTS TO SEE PASSWORDS
Find-AdmPwdExtendedRights -Identity "Computers_OU"

#####LETS NOW GRANT USERS PERMISSION TO SEE THE PC PASSWORD###########
Set-AdmPwdReadPasswordPermission -Identity "Computers_OU" -AllowedPrincipals "Help_Desk"
##or
Set-AdmPwdReadPasswordPermission -OrgUnit "OU=MyComputers,DC=lab,DC=org" -AllowedPrincipals "Help_Desk"

#####Then setup the GPO to enable ADM under Computer>Policies>Admin Templates>LAPS

####Then deploy LAPS to your client devices#####################
````



##### For scripts to run as SYSTEM make certain domain computers have atleast read and execute rights to the share

```FORCE SYSTEM TO SYNC TIME WITH DC```

````
net time \\DC_Name_OR_IP /set /y
````

```PROPER PERMISSIONS FOR ABE```

````
##Grant Read privileges to "This folder only" to "Authenticated Users" to the root folder
###Traverse folder/ execute file
###List folder /read data
##Read attributes
##Read extended attributes
##Read permissions

##Then assign specific rights to the sub-folders
````

```REPAIRING DAMAGED PROFILE```

````
###Log on to the system by using an administrative user account other than the user account that is experiencing the problem.
##Back up all data in the current user's profile folder if the profile folder still exists, and then delete the profile folder. 
##By default, the profile resides in the following location:%SystemDrive%\Users\UserName
##Click Start, type regedit in the Start Search box, and then press ENTER.

##User Account Control permission If you are prompted for an administrator password or for confirmation, type your password, or click Continue.
##Locate the following registry subkey:HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList
##Under the ProfileList subkey, delete the subkey that is named SID.bak. 

Note SID is a placeholder for the security identifier (SID) of the user account that is experiencing the problem. The SID.bak subkey
##should contain a ProfileImagePath registry entry that points to the original profile folder of the user account that is experiencing the problem.
##Exit Registry Editor.
##Log off the system.
##Log on to the system again.
###NOTE IF THE USER LOGS IN AND IS NOT REDIRECTED TRY RUNNING THE OFFLINE FILE FIX AND AFTER REBOOT HAVE THEM LOGIN
````

```INSTALL .MSU FILES```

````
wusa.exe ps.msu

##silent install
wusa.exe ps.msu /quiet

###Add full path
wusa.exe c:\msu\ps.msu
````

```AD DATABASE PERFMON COUNTER```

#### To see if your DC is pulling it's DB from RAM and not disk look at the below counter Database/Database Cache % HIT for lsass(Low hit rate could mean the DC needs more RAM)


```FIX WSUS SERVER 2012R2 AND ABOVE "NODE ERROR"```

````
##This issue is caused by the WSUSAPPPool's memory defaulting to 1.8GB(1843200KB)
##Luanch IIS manager and unser APPPool look for the WSUS apppool and click on "Advanced settings"
###Under "Private Memory Limit(KB) set it to "0" which means unlimited
###This should resolve your isssue

####TEMP FIX FOR WSUS#########

Net stop wsusservice
IISReset /Stop
IISReset /Start
Net start wsusservice
````

[https://social.technet.microsoft.com/Forums/lync/en-US/7226dc0d-e3c5-40c2-817d-048bb0a74980/error-connection-error-click-reset-server-node-to-try-to-connect-to-the-server-again?forum=winserverwsus](https://social.technet.microsoft.com/Forums/lync/en-US/7226dc0d-e3c5-40c2-817d-048bb0a74980/error-connection-error-click-reset-server-node-to-try-to-connect-to-the-server-again?forum=winserverwsus)

######CONFIGURE WSUS GPO#########
##The port number must be in your GPO settings or it will not work as of Server 2012R2 & 2016
##http: 8530
##https: 8531
##ex. http://wsus.enterprise.com:8530


##############EXPORT AND IMPORT DHCP SCOPES FOR MIGRATION REF:http://www.brycematheson.io/how-to-migrate-dhcp-from-windows-server-2008-to-2012-2016/###############

netsh dhcp server export C:\Users\whomever\Desktop\dhcp.txt all ##export scope

netsh dhcp server import C:\Users\whomever\Desktop\dhcp.txt all
####IF YOU RUN THIS FROM THE COMMAND PROMPT AT IT OUTPUTS NOTHING, TRY POWERSHELL ESPECIALLY IF YOUR BACKUP IS
#####IN THE .BAK FORMAT###########


#############SET DISK POLICY POWERSHELL##################################################
Get-StorageSetting | Select-Object NewDiskPolicy  #First let's see the current policy

Set-StorageSetting -NewDiskPolicy OnlineAll  ##Now set the policy


####### DELETE UNWANTED HEALTHY EFI PARTITION#############
##from ad admin cmd or powershell
diskpart
list disk  ###just to see the layout
list partition
select partition 2(or whatever it is)
delete partition override


#########SYSPREP COMMANDS###############

cd c:\Windows\System32\Sysprep
sysprep /oobe /generalize /shutdown



#############Filter username in eventviewer#####################

##Click on filter and then click on the XML tab

<QueryList>
<Query Id="0" Path="Security">
<Select Path="Security">* [EventData[Data[@Name='TargetUserName']='USERNAME']]</Select>
</Query>
</QueryList>


###Filter even more here we are looking for event ID 4771 and the user#####

<QueryList>
  <Query Id="0" Path="Security">
    <Select Path="Security">*[System[(EventID=4771)] and EventData[Data[@Name='TargetUserName'] = 'testuser']]</Select>
  </Query>
</QueryList>

####Filter for events in the last 7 days###################

<QueryList>
  <Query Id="0" Path="Security">
    <Select Path="Security">*[System[TimeCreated[timediff(@SystemTime) &lt;= 604800000]] and EventData[Data[@Name='TargetUserName'] = 'user1'] ]</Select>
  </Query>
</QueryList>



###################Search for user lockout in a Windows Domain#################################
##Go to he PDC emulator in our forest/domain
##And search the eventviewer security logs for event id 4740
##You can also run the above query string to find all events for a particulat user#####
##REF: https://community.spiceworks.com/how_to/128213-identify-the-source-of-account-lockouts-in-active-directory?page=2 



####Force Win10 Server 2016 to re-check WSUS/WindowsUpdate Server###################
##So the issue I have is that if you deploy a new server from a template, there can be a gap
##Before the VM is joined to AD, well in that time Windows would have downloaded updates from
##Windows update, but if you don't want servers in our environment to have newer updates than
##have been approved by your Enteprise how do you force Windows to re-check WSUS after you join it to the
##Domain, well the below one-liner will get you there

(New-Object -ComObject Microsoft.Update.AutoUpdate).DetectNow()

usoclient StartScan


####Location of shares in the registry##################

HKEY_LOCAL_MACHINE subtree, go to the following key:
SYSTEM\CurrentControlSet\Services\LanmanServer\Shares

#####Migrate a FileServer while keeping the original servers name and or IP#####

##In my case I'm just keeping the original name and let DNS handle the IP change#####
##After using Robocopy to copy over all files and permissions, you can export the key above
##Then during a down time rename the current server and reboot and then run

ipconfig /registerdns

###Then name the new server the same as the old one and reboot; then run

ipconfig /registerdns

###If everything is okay your users should not know that the change was made####


#######CERTIFICATE AUTO-ENROLLMENT###############################
##REF: https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/dd379529(v=ws.10)

##Also I had an issue when attempting to enroll a certificate when I added the server to an AD group and gave the group
##enroll rights it would not work, but when I gave the machine enroll rights to the certificate template it worked
##I need to investigate why groups are not working.



###Powershell curl equivalent##############
##More than one way to do this###########


(New-Object System.Net.WebClient).DownloadFile($URL, $filename)

##OR

(New-Object System.Net.WebClient).DownloadFile('http://server/file.js', 'C:\output\file.js')


################BACKUP DHCP SERVER###########################################
netsh dhcp server \\dhcpserver dump > c:\DHCP-config.txt



#####REPADMIN################################
repadmin /showrepl      ##show replication throughout the forest
repadmin /replsummary   ##show replication sumary

repadmin /syncall /A /d /e /P  ###Syncall all changes from this particular DC outward to all other DC's

####REF: https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/cc835086(v%3dws.11)



#####Get model number from a device##################
wmic csproduct get name


###################DHCP IMPORT##################################
##If you use net use dhcp dump to backup your DHCP server(s) you will need to run 
##netsh exec dhcpfile.txt to re-import your scopes, if you get an error "The following command was not found"
##then more than likely the file is in UNICODE format and you need to convert to ANSI; just open the file in notepad and "Save As" ANSI



####Cleanly remove old root CA
##REF: https://mssec.wordpress.com/2013/03/19/manually-remove-old-ca-references-in-active-directory/
##NOTE: The very last instruction gave me issues, so just load the PKI snappin from mmc.exe
##Which you can only get from the new root CA
###Also I added the CA role and did the cleanup after the fact; if I had not installed the role maybe the last command
##Would have worked for me.
###TODO: Add steps here incase the above site goes down

####Also how I knew that ldaps was still using the old cert; I simply ran this command, kudos to the guy who posted this

openssl s_client -connect myldapsserver.domain.com:636

##of course the above requires that you have openssl installed on your system
#REF: https://social.technet.microsoft.com/Forums/windowsserver/en-US/06c2a9cc-bd43-4bcd-9ade-b121c797d1f9/how-to-check-what-certificate-is-being-used-for-ssl-ldaps-connections?forum=winserversecurity



########Get logon DC##########################
##REF: https://www.technipages.com/windows-how-to-switch-domain-controller

nltest /dsgetdc:enterprise.com ## or whatever domain

###This is more accurate than
set l
and 
echo %LOGONSERVE%

####Let's switch a clients domain controller without a reboot##
nltest /Server:ClientComputerName /SC_RESET:DomainName\DomainControllerName
##OR

nltest /Server:computer01 /SC_RESET:enterprise.com\enterprise-dc-01



###########DHCP SERVER IMPORT ISSUES AGAIN###########################
######NOTE IF THE NEW DHCP SERVER HAS A DIFFERENT NAME THEN SIMPLY DO A SEARCH AND REPLACE AND CHANGE THE .TXT FILE TO REFLECT THE NEW NAME
#####AND THEN RUN THE BELOW COMMAND#################
###REF:https://www.petenetlive.com/KB/Article/0001177

netsh exec c:\temp\dhcp.txt  ###Import from a .txt file




###FSMO in a forest and a domain#############
#REF:  https://social.technet.microsoft.com/Forums/ie/en-US/119a167c-26fc-474b-9efd-9698758bbe92/how-many-pdc-emulator?forum=winserverDS

##The important bit

##Considering single Forest with 12 domains, how many FSMO role in total exist?
##Total FSMO roles in this scenario = 38

##12 X 3 = 36 (PDC, RID, Infrastructure) Master
##2 For each Forest (Domain Naming Master and Schema Master per Forest)
##Total = 38

##Troubleshooting folder redirection
##Check Eventviewer and look under Application logs 'Folder Redirection' under source
##Or you can filter for EventID 500-530(Just to be safe)



###Remove a directory with a lot of read-only files############
rmdir C:\directory /s ###/s removes the entire tree
##REF: https://www.computerhope.com/rmdirhlp.htm


###Powershell Get services####
##REF: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-service?view=powershell-6
Get-Service  ##get all our services
Get-Service -DisplayName "*arb*"  ##Get services with name arb in it


###Get installed applications using Powershell
Get-WmiObject -Class Win32_Product

###You can also use these reg keys
$KEY_x86 = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
$KEY_x64 = 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'

##You can do something like this

[int]$isInstalled=0

        if(Get-ItemProperty $KEY_x86 | Where-Object {$_.DisplayName -like $TheApp})
            {
                $isInstalled=1
            }
        else
            {
                $isInstalled=0
            }


##Or just output the values of those keys


Write-Host "================================================ 32-bit Keys====================================================="

Get-ItemProperty $KEY_x86 | Select-Object DisplayName, DisplayVersion | Format-Table -AutoSize
Write-Host "================================================================================================================="

if(Test-Path $KEY_x64)  {
    Write-Host "================================================ 64-bit Keys====================================================="
    Get-ItemProperty $KEY_x64 | Select-Object DisplayName, DisplayVersion | Format-Table -AutoSize
    Write-Host "================================================================================================================="
}

Write-Host ""


#####Log out of windows core##########
logoff

###Find Smb version note the Get-SmbConnection ##commandlet must be run after the client makes a ##connection to the server. 
##If you run this command ##let without making a connection it will return ##zip, nada
##Note this requires Server 2012 and higher

Get-SmbConnection
Get-SmbConnection | Select-Object -Property *

#####Get Environment vars in powershell###################

Get-ChildItem Env: ## List all that is available
Get-ChildItem Env: | ft -Wrap -Autosize ###format nicely

gci Env: | sort name #short hand for Get-ChildItem and then sort output by name

$Env:windir  ##Will get you the windows directory
$Env:SystemRoot ##Will get you the system root
$Env:USERNAME ##Current logged on user
$Env:USERDNSDOMAIN ##FQDN of logon domain
$Env:USERDOMAIN ##Logon Domain

cd $Env:USERPROFILE  ## cd into the user's home directory

& "$Env:CommonProgramFiles\Microsoft Shared\MSInfo\msinfo32.exe"


#####Active Directory Based Activation(ADBA)######
##REF: https://www.thirdphasecomputing.com/en/blog/how-to-configure-active-directory-based-activation

#####REMOVING CHILD DOMAIN########
#I had issues removibng a child domain the only method that worked was below###
##REF: https://www.petri.com/delete_failed_dcs_from_ad

I will re-write here soon


#####Creating FQDN's for a new or existing forest#####
## it is possible to create a root domain as corp.contoso.com
## instead of just contoso.com so you can then create a child
## domain ad and then have ad.corp.contoso.com or create
## ad.contoso.com and then create a child domain as itbu 
## so it becomes itbu.ad.contoso.com 


######RDP error '2308' Schannel SSL error############
##REF:https://cloudriots.wordpress.com/2013/08/27/rdp-connection-errors-and-tlsssl-hardening/
##Set 'Enabled=1' HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server


###Test ports powershell####

Test-NetConnection servername -Port 3389 -InformationLevel Quiet


####Powershell get system uptime#############

Get-CimInstance -ClassName win32_operatingsystem | Select csname, lastbootuptime


###BGINFO###########
####HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
##Add a new String Value "REG_SZ" Named "BgInfo" then edit and add
##C:\BGInfo\Bginfo.exe C:\BGInfo\default.bgi /timer:0 /silent /nolicprompt
##Of course change the path and names to match your environment



#####Server 2012R2 MPIO #########################
##REF:https://www.experts-exchange.com/articles/18225/Windows-Server-2012-and-Multipath-I-O-to-Storage-Area-Network.html

#####Useful time commands########################
w32tm.exe /query /status   ###get status of last or any sync with any time servers

###Activate windows behind a firewall##########
##Run the below command on the server
slui 4
##Follow the prompts


#####Configure VLAN on windows NIC##############
##REF:https://community.mellanox.com/s/article/howto-configure-multiple-vlans-on-windows-2012-server
##Head into the advance settings for the NIC and scroll down to see VLAN and add your VLAN ID


####Windows Firewall####################

##So I had a weird issue where I could not ping a machine nor RDP to it, but it could ping out and it was joined to the 
##domain, well after poking around I noticed that I could not see firewall information, so sure enough
##the firewall service was stopped, so I started it up and everything started to work
##so it's good to know that windows firrewall fails closed and blocks all inbound traffic


####Move folder back to it's original location###########
##So I collegue showed me this say a user moves a folder from it's original location to another
##and say that folder is huge do the following

###map a drive to where the folder should be
##then check to make certain that no one is using the share i.e the folder that was moved
##that would be bad, if they are kick them off
##then go to the folder and drop it on the mapped share where it should be, the one you created earlier
##use the left pane under "THIS PC" to drop it on that
###you should see the file copy window but it instead of taking hours to transfer it should take about 5 - 15 minutes
##depending on the network, but the users will have full access immediately
##Note moving a folder should keep all it's permissions so moving it back will make things much easier as all
##permissions will still be there..



#########Create self-signed certificate PS###############################
##REF:https://docs.microsoft.com/en-us/powershell/module/pkiclient/new-selfsignedcertificate?view=win10-ps
##REF:https://serverfault.com/questions/892193/how-to-create-self-signed-san-certificate-in-iis
New-SelfSignedCertificate -DnsName "localhost", "site", "site.enterprise.com" -FriendlyName "siteSAN" -Subject "CN=site" -CertStoreLocation cert:\localmachine\my

###now the only issue with this is that you will have to export the cert to .pfx and then import it into the the trusted root store


###Get the SHA256 Hash from aa file#################

Get-FileHash RVTools3.11.9.msi


####list routes########
netstat -nr

###add static route#####
route add 192.168.99.0 mask 255.255.255.0 10.0.0.250 -p (-p = permanent)

##delete static route###
route delete 192.168.99.0


####SET SAN Policy Powershell###########

Get-StorageSetting

Set-StorageSetting -NewDiskPolicy OnlineAll


###Extend basic volume diskpart#########

diskpart

list disk

select disk 0

list partition  ##You are looking for the primary partition

select partition 4(or whatever)

extend size=MB

###Note under list disk you can see the free space and that's what you will be extending
##Must be a way to do this with PS

#####some PS disk logic###########
Get-Disk

Get-Disk | Select *

$free = Get-Disk -Number 0 | Select-Object -ExpandProperty LargestFreeExtend

$freeMB = $free / 1024

$freeMB

####Entend disk the PS way#########

$MaxSize = (Get-PartitionSupportedSize -DriveLetter c).sizeMax

Resize-Partition -DriveLetter c -Size $MaxSize


####Install certificate powershell#####

Import-Certificate -FilePath "C:\Users\Xyz\Desktop\BackupCert.Cer" -CertStoreLocation Cert:\LocalMachine\Root

##the above installs the cert to the machines trusted root store


####Check some basic winrm issues###########
##REF:https://www.dtonias.com/add-computers-trustedhosts-list-powershell/
winrm quickconfig

Get-Item WSMan:\localhost\Client\TrustedHosts

Set-Item WSMan:\localhost\Client\TrustedHosts -Value 10.10.10.1,[0:0:0:0:0:0:0:0]

###IPv4 and IPV6

##Add all machines probably not a good idea###

Set-Item WSMan:\localhost\Client\TrustedHosts -Value *


###Add all machines on your domain
Set-Item WSMan:\localhost\Client\TrustedHosts *.yourdomain.com



##Invoke-WebRequest server core install###

Invoke-WebReuest -URI http://blah.com

##The above will generate an error about IE not be configured

Invoke-WebReuest -UseBasicParsing -URI http://blah.com




#####Run powershell command from cmd.exe#####

powershell -Command Get-Process

powershell -NoProfile -Command Get-Process


###Generate CSR if web role not available through AD####
##REF:https://www.namecheap.com/support/knowledgebase/article.aspx/9854/14/how-to-generate-a-csr-code-on-a-windowsbased-server-without-iis-manager

##Follow the example above but basically load certifcates in the MMC and under personal certificates > all tasks > advanced operations
## > create custom request leave everything default but remember under details click the properties button and fill out 
## at least common name, and DNS so you can have a valid SAN


###Get system uptime

SystemInfo | find "System Boot Time"




####FTP########
##Ran into an issue when setting up ftp after making my changes I still could not log in to the ftp server
##Apparently after making rules changes you need to restart the ftp service in services.msc




#####Microsoft builds and updates site####
##REF:https://support.microsoft.com/en-us/help/4480961/windows-10-update-kb4480961


###Installing Windows updates PSModules####
##REF:https://www.itechtics.com/run-windows-update-cmd/

Install-Module -Name PSWindowsUpdate

Show-WindowsUpdate -Confirm:$false #???

Get-WindowsUpdate -Verbose | Format-Table AutoSize

Get-WindowsUpdate -Verbose -Install -AutoReboot -AcceptAll

Get-Command -Name *WindowsUpdate*

####Note with the install above you actually get something resemblying a progress bar##
##Also some of these Functions are aliases so check the docs

Get-Help Get-WindowsUpdate -Full

####Get Hotfixes######
##REF:https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-hotfix?view=powershell-5.1

Get-HotFix | Format-Table -AutoSize


#####Disable UAC####

New-ItemProperty -Path HKLM:Software\Microsoft\Windows\CurrentVersion\policies\system -Name EnableLUA -PropertyType DWord -Value 0 -Force

##Note the above will create the key if it doesn't exist best to check if it is there first



```INSTALL DOCKER WINDOWS SERVER 2016```

````
#####Note I installed this on Server 2016 core
###Also you must install the 'Containers' role/feature

##Get a Powershell Prompt
PS> Install-Module -Name DockerMsftProvider -Repository PSGallery -Force
PS> Install-Package -Name docker -ProviderName DockerMsftProvider (Select 'A')
PS> Restart-Computer -Force

###Get Installed Version
PS> Get-Package -Name Docker -ProviderName DockerMsftProvider
##Get Current Version from Repo
PS> Find-Package -Name Docker -ProviderName DockerMsftProvider
````

[https://docs.microsoft.com/en-us/virtualization/windowscontainers/quick-start/quick-start-windows-server](https://docs.microsoft.com/en-us/virtualization/windowscontainers/quick-start/quick-start-windows-serve)


```Upgrade Docker```

````
PS> Install-Package -Name Docker -ProviderName DockerMsftProvider -Update -Force
PS> Start-Service Docker
````

```Install docker Windows Server 2019```

````
###Also you must install the 'Containers' role/feature
##REF:https://blog.sixeyed.com/getting-started-with-docker-on-windows-server-2019/
Install-Module -Name DockerMsftProvider -Repository PSGallery -Force

Install-Package -name docker -ProviderName DockerMsftProvider -Force ##You can also add -RequiredVersion 18.03 which would install 18.03
Start-Service -Name docker
````
[https://blog.sixeyed.com/getting-started-with-docker-on-windows-server-2019/](https://blog.sixeyed.com/getting-started-with-docker-on-windows-server-2019/)


####Disassociate a file exentsion with a program
##REF:https://www.raymond.cc/blog/how-unassociate-windows-vista-7-file-type/

##what worked for me was the last part 

HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer \FileExts\.extension 

##also before you do the above delete the value in 'value data' below
HKEY_CLASSES_ROOT\.extension

####.NET Framework Resources
##REF:https://docs.microsoft.com/en-us/dotnet/framework/migration-guide/how-to-determine-which-versions-are-installed
##REF:https://docs.microsoft.com/en-us/dotnet/framework/tools/ngen-exe-native-image-generator

##Let's find our version of .NET framework
(Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full").Release

##From the above output you can match the number with the abovve 1st link


##check when a VM crashed you can look for event ID 6008 and make sure you read the time in the message
##as it will tell the actual time and not the time the event was logged in Windows i.e. the log date and time
##might say 1-1-2020 but the details inside will have the 'real time' this is the 'System' log


```Dealing with packages in Windows Powershell```

````
Get-PackageProvider -ListAvailable

Install-Package -Name 'package name'

Uninstall-Package -Name 'package name'

Find-PackageProvider
````

####Install Nuget##########
Get-PackageProvider -ListAvailable
###If you don't see Nuget then you have to do this
Install-PackageProvider -Name NuGet  ##This might error out??


###Set a package source as trusted
Get-PackageSource

Set-PackageSource -Name PSGallery -ProviderName PowerShellGet -Trusted

##Note all this is still a bit fussy to me



########Disable IPv6#####
##REF: https://www.tenforums.com/tutorials/90033-enable-disable-ipv6-windows.html

Get-NetAdapterBinding -ComponentID ms_tcpip6

Disable-NetAdapterBinding -Name "Adapter Name" -ComponentID ms_tcpip6

####Disable on all adapters

Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6


##### Find user that rebooted server#########
#REF:https://www.tenforums.com/tutorials/78335-read-shutdown-logs-event-viewer-windows.html

## In the eventviewer under 'System' filter for 1074,6006,6008


### Get share permissions

````
(Get-Acl -Path \\myshare\folder).Access | ft autosize

````


```Activate Windows with DISM```

##### Note this upgrades you from the eval version to the retail version
````
DISM /Online /Set-Edition:ServerDatacenter /ProductKey:12345-12345-12345-12345-12345 /AcceptEula

DISM /Online /Set-Edition:ServerStandard /ProductKey:12345-12345-12345-12345-12345 /AcceptEula

slmgr /dli  #make sure things look good

DISM /online /Get-CurrentEdition

DISM /online /Get-TargetEditions
````


##### Note with the above DISM will sit at 10% removing the eval pieces, after Googling around I found a solution, launch services.msc and look for the Windows License Manager Service if it's not running start it, if it is restart it and then hit enter in the powershell console a few times to wake it up, you should see the progress start back up again, it could still take about 10-15 minutes though

[https://woshub.com/how-to-upgrade-windows-server-2016-evaluation-to-full-version/#:~:text=To%20convert%20Windows%20Server%202019%20EVAL%20to%20a,upgrade%20Windows%20Server%202019%20edition%20the%20same%20way.](https://woshub.com/how-to-upgrade-windows-server-2016-evaluation-to-full-version/#:~:text=To%20convert%20Windows%20Server%202019%20EVAL%20to%20a,upgrade%20Windows%20Server%202019%20edition%20the%20same%20way.)
