### So there are a few differences between Debian and Ubuntu and there derivatives

#### First when I installed Debian11 from the DVD sudo is not installed by default again it's a more secure OS and it wants you to su to root also when I tried to run apt update
#### I ran into another issue where it gave an error similar to cdrom:\\Debian 11 ... not found the fix for that is below

````
su -
vi /etc/apt/sources.list
````

#### Comment out any line that references the install DVD
