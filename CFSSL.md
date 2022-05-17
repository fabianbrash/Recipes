### cfssl tool, can be used instead of openssl to create certificates, written in go

[https://github.com/cloudflare/cfssl](https://github.com/cloudflare/cfssl)

[https://medium.com/@rob.blackbourn/how-to-use-cfssl-to-create-self-signed-certificates-d55f76ba5781](https://medium.com/@rob.blackbourn/how-to-use-cfssl-to-create-self-signed-certificates-d55f76ba5781)

[https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/04-certificate-authority.md](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/04-certificate-authority.md)

[https://stelfox.net/notes/cfssl/](https://stelfox.net/notes/cfssl/)

### let's create a root CA to sign our certificates


```ca-csr.json```


````

{

    "CN": "My CA",
    "key": {
      "algo": "rsa",
      "size": 2048
    },
    "names": [
    {
      "C": "US",
      "L": "Richmond",
      "O": "ORGA",
      "OU": "ORGB",
      "ST": "Virginia"
    }

  ]

}
````


### Now let's generate our key and cert


````
cfssl gencert -initca ca-csr.json | cfssljson -bare ca
````

#### The above will generate ca.pem, ca-key.pem, ca.csr

#### Now we have to create a config.json file

```ca-config.json```

````

{

    "signing": {
      "default": {
        "expiry": "8760h"
       },
       "profiles": {
         "server": {
	   "usages": ["signing", "digital signing","key encipherment", "server auth", "client auth"],
	   "expiry": "8760h"
	 }
     }
   }
}
````


#### The above file basically sets how long the cert will be for, create a profile and what the profile can be used for

#### now lets create a json file for our server so it can get a cert from our CA

```server-0-csr.json```


````

{
  "CN": "server-0.test.com",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
  {
    "C": "US",
    "L": "Richmond",
    "O": "ORGA",
    "OU": "ORGB",
    "ST": "Virginia"
  }
 ],
 "hosts": [
   "server-0",
   "server-0.test.com",
   "localhost"
  ]
}

````

#### Now lets generate the cert

````
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=server server-0-csr.json | cfssljson -bare server-0
````

#### you should now have serever-0.pem, server-0-key.pem, server-0.csr


#### Note the above will generate a RSA key if you want to use ECDSA there is nn option for that

[https://stelfox.net/notes/cfssl](https://stelfox.net/notes/cfssl)

#### I will be doing that next


#### let's create a root CA to sign our certificates


```ca-csr.json```

````

{

    "CN": "My CA",
    "key": {
      "algo": "ecdsa",
      "size": 256
    },
    "name": [
    {
      "C": "US",
      "L": "Richmond",
      "O": "ORGA",
      "OU": "ORGB",
      "ST": "Virginia"
    }

  ]

}

````

#### Now let's generate our key and cert

````
cfssl gencert -initca ca-csr.json | cfssljson -bare ca
````

#### The above will generate ca.pem, ca-key.pem, ca.csr


```server-0-csr.json```

````


{
  "CN": "server-0.test.com",
  "key": {
    "algo": "ecdsa",
    "size": 256
  },
  "names": [
  {
    "C": "US",
    "L": "Richmond",
    "O": "ORGA",
    "OU": "ORGB",
    "ST": "Virginia"
  }
 ],
 "hosts": [
   "server-0",
   "server-0.test.com",
   "localhost"
  ]
}

````

#### Now lets generate the cert

````
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=server server-0-csr.json | cfssljson -bare server-0
````


#### you should now have serever-0.pem, server-0-key.pem, server-0.csr


#### Even though I've changed the above length to 256 it generates a 512 key I think I need to make the CA 256 as well??

#### Also if you are on Fedora you can view a cert using gcr-view cert.pem
