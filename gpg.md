```GPG Note this is the simpliest way to use GPG please read up on how to do this properly```


````
gpg -c myfile.txt ## You will be prompted for a passphrase

gpg -d myfile.txt.gpg ## This will decrypt the file and display contents to stdout

gpg myfile.txt.gpg ##This will create a decrypted file on the filesystem
````
