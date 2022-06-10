```TKGm information goes here```


#### Okay to deploy TKGm on vSphere I would highly recommend service-installer(arcas), you can find info [here](https://github.com/fabianbrash/Recipes/blob/stable/arcas.md) what you get from service-installer is below

1. Deploys and configures AVI LB
2. Deploys a shared services cluster with harbor(if you want)
3. Deploys a workload cluster


#### After using arcas to deploy your mgmt, and your first workload cluster, you can also use it for subsequent clusters as well by modifying the json file that's saved to /opt/vmware/arcas/src/vsphere-dvs-tkgm.json


#### Note arcas runs on port 8888

#### After you've generated your JSON file you can run the below

````

arcas --env vsphere --file vsphere-dvs-tkgm.json --avi_configuration --verbose #deploy and configure AVI

arcas --env vsphere --file vsphere-dvs-tkgm.json --tkg_mgmt_configuration --verbose #deploy mgmt cluster

arcas --env vsphere --file vsphere-dvs-tkgm.json --shared_service_configuration --verbose #deploy shared-services cluster

arcas --env vsphere --file vsphere-dvs-tkgm.json --workload_preconfig --workload_deploy --verbose # deploy workload cluster

````


```vsphere-dvs-tkgm.json```


````

{
    "envSpec": {
        "vcenterDetails": {
            "vcenterAddress": "192.168.99.254",
            "vcenterSsoUser": "administrator@vsphere.local",
            "vcenterSsoPasswordBase64": "aaaaaaaaaaaaaaaaaa",
            "vcenterDatacenter": "dc-01",
            "vcenterCluster": "cluster-01",
            "vcenterDatastore": "truenas-iscsi-01",
            "contentLibraryName": "Local-CL",
            "aviOvaName": "controller-20.1.7-9154",
            "resourcePoolName": ""
        },
        "envType": "tkgm",
        "marketplaceSpec": {
            "refreshToken": ""
        },
        "saasEndpoints": {
            "tmcDetails": {
                "tmcAvailability": "false",
                "tmcRefreshToken": ""
            },
            "tanzuObservabilityDetails": {
                "tanzuObservabilityAvailability": "false",
                "tanzuObservabilityUrl": "",
                "tanzuObservabilityRefreshToken": ""
            }
        },
        "infraComponents": {
            "dnsServersIp": "192.168.99.100",
            "ntpServers": "192.168.99.200",
            "searchDomains": "fbclouddemo.us"
        },
        "proxySpec": {
            "arcasVm": {
                "enableProxy": "false",
                "httpProxy": "",
                "httpsProxy": "",
                "noProxy": ""
            },
            "tkgMgmt": {
                "enableProxy": "false",
                "httpProxy": "",
                "httpsProxy": "",
                "noProxy": ""
            },
            "tkgSharedservice": {
                "enableProxy": "false",
                "httpProxy": "",
                "httpsProxy": "",
                "noProxy": ""
            },
            "tkgWorkload": {
                "enableProxy": "false",
                "httpProxy": "",
                "httpsProxy": "",
                "noProxy": ""
            }
        }
    },
    "tkgComponentSpec": {
        "aviMgmtNetwork": {
            "aviMgmtNetworkName": "vDS-VMMgtm99",
            "aviMgmtNetworkGatewayCidr": "192.168.99.1/24",
            "aviMgmtServiceIpStartRange": "192.168.99.227",
            "aviMgmtServiceIpEndRange": "192.168.99.232"
        },
        "tkgClusterVipNetwork": {
            "tkgClusterVipNetworkName": "vDS-TKG-FRNT-DATA182",
            "tkgClusterVipNetworkGatewayCidr": "192.168.182.1/24",
            "tkgClusterVipIpStartRange": "192.168.182.20",
            "tkgClusterVipIpEndRange": "192.168.182.200"
        },
        "aviComponents": {
            "aviPasswordBase64": "bbbbbbbbbbbbbbbbbbbb=",
            "aviBackupPassphraseBase64": "bbbbbbbbbbbbbbbbbb=",
            "enableAviHa": "false",
            "aviController01Ip": "192.168.99.225",
            "aviController01Fqdn": "avi-lb-01.fbclouddemo.us",
            "aviController02Ip": "",
            "aviController02Fqdn": "",
            "aviController03Ip": "",
            "aviController03Fqdn": "",
            "aviClusterIp": "",
            "aviClusterFqdn": "",
            "aviSize": "essentials",
            "aviCertPath": "",
            "aviCertKeyPath": ""
        },
        "tkgMgmtComponents": {
            "tkgMgmtNetworkName": "vDS-TKG-MGMTWKLK180",
            "tkgMgmtGatewayCidr": "192.168.180.1/24",
            "tkgMgmtClusterName": "mgmt-0",
            "tkgMgmtSize": "large",
            "tkgMgmtCpuSize": "",
            "tkgMgmtMemorySize": "",
            "tkgMgmtStorageSize": "",
            "tkgMgmtDeploymentType": "prod",
            "tkgMgmtClusterCidr": "100.96.0.0/11",
            "tkgMgmtServiceCidr": "100.64.0.0/13",
            "tkgMgmtBaseOs": "photon",
            "tkgSharedserviceClusterName": "ssc-1",
            "tkgSharedserviceSize": "medium",
            "tkgSharedserviceCpuSize": "",
            "tkgSharedserviceMemorySize": "",
            "tkgSharedserviceStorageSize": "",
            "tkgSharedserviceDeploymentType": "dev",
            "tkgSharedserviceWorkerMachineCount": "2",
            "tkgSharedserviceClusterCidr": "100.96.0.0/11",
            "tkgSharedserviceServiceCidr": "100.64.0.0/13",
            "tkgSharedserviceBaseOs": "photon",
            "tkgSharedserviceKubeVersion": "v1.22.5"
        }
    },
    "tkgMgmtDataNetwork": {
        "tkgMgmtDataNetworkName": "vDS-TKG-FRNT-DATA182",
        "tkgMgmtDataNetworkGatewayCidr": "192.168.182.1/24",
        "tkgMgmtAviServiceIpStartRange": "192.168.182.20",
        "tkgMgmtAviServiceIpEndRange": "192.168.182.200"
    },
    "tkgWorkloadDataNetwork": {
        "tkgWorkloadDataNetworkName": "vDS-TKG-FRNT-DATA182",
        "tkgWorkloadDataNetworkGatewayCidr": "192.168.182.1/24",
        "tkgWorkloadAviServiceIpStartRange": "192.168.182.20",
        "tkgWorkloadAviServiceIpEndRange": "192.168.182.200"
    },
    "tkgWorkloadComponents": {
        "tkgWorkloadNetworkName": "vDS-TKG-WKLK181",
        "tkgWorkloadGatewayCidr": "192.168.181.1/24",
        "tkgWorkloadClusterName": "onprem-tap",
        "tkgWorkloadSize": "extra-large",
        "tkgWorkloadCpuSize": "",
        "tkgWorkloadMemorySize": "",
        "tkgWorkloadStorageSize": "",
        "tkgWorkloadDeploymentType": "prod",
        "tkgWorkloadWorkerMachineCount": "5",
        "tkgWorkloadClusterCidr": "100.96.0.0/11",
        "tkgWorkloadServiceCidr": "100.64.0.0/13",
        "tkgWorkloadBaseOs": "photon",
        "tkgWorkloadKubeVersion": "v1.22.5",
        "tkgWorkloadTsmIntegration": "false",
        "namespaceExclusions": {
            "exactName": "",
            "startsWith": ""
        }
    },
    "harborSpec": {
        "enableHarborExtension": "true",
        "harborFqdn": "harbor-01.fbclouddemo.us",
        "harborPasswordBase64": "ccccccccccccc=",
        "harborCertPath": "",
        "harborCertKeyPath": ""
    },
    "tanzuExtensions": {
        "enableExtensions": "false",
        "tkgClustersName": "",
        "logging": {
            "syslogEndpoint": {
                "enableSyslogEndpoint": "false",
                "syslogEndpointAddress": "",
                "syslogEndpointPort": "",
                "syslogEndpointMode": "",
                "syslogEndpointFormat": ""
            },
            "httpEndpoint": {
                "enableHttpEndpoint": "false",
                "httpEndpointAddress": "",
                "httpEndpointPort": "",
                "httpEndpointUri": "",
                "httpEndpointHeaderKeyValue": ""
            },
            "elasticSearchEndpoint": {
                "enableElasticSearchEndpoint": "false",
                "elasticSearchEndpointAddress": "",
                "elasticSearchEndpointPort": ""
            },
            "kafkaEndpoint": {
                "enableKafkaEndpoint": "false",
                "kafkaBrokerServiceName": "",
                "kafkaTopicName": ""
            },
            "splunkEndpoint": {
                "enableSplunkEndpoint": "false",
                "splunkEndpointAddress": "",
                "splunkEndpointPort": "",
                "splunkEndpointToken": ""
            }
        },
        "monitoring": {
            "enableLoggingExtension": "false",
            "prometheusFqdn": "",
            "prometheusCertPath": "",
            "prometheusCertKeyPath": "",
            "grafanaFqdn": "",
            "grafanaCertPath": "",
            "grafanaCertKeyPath": "",
            "grafanaPasswordBase64": ""
        }
    }
}


````


#### The below JSON will use "custom" four our sizing of the workload cluster


````

{
    "envSpec": {
        "vcenterDetails": {
            "vcenterAddress": "192.168.99.254",
            "vcenterSsoUser": "administrator@vsphere.local",
            "vcenterSsoPasswordBase64": "aaaaaaaaaaaaaaaaaa",
            "vcenterDatacenter": "dc-01",
            "vcenterCluster": "cluster-01",
            "vcenterDatastore": "truenas-iscsi-01",
            "contentLibraryName": "Local-CL",
            "aviOvaName": "controller-20.1.7-9154",
            "resourcePoolName": ""
        },
        "envType": "tkgm",
        "marketplaceSpec": {
            "refreshToken": ""
        },
        "saasEndpoints": {
            "tmcDetails": {
                "tmcAvailability": "false",
                "tmcRefreshToken": ""
            },
            "tanzuObservabilityDetails": {
                "tanzuObservabilityAvailability": "false",
                "tanzuObservabilityUrl": "",
                "tanzuObservabilityRefreshToken": ""
            }
        },
        "infraComponents": {
            "dnsServersIp": "192.168.99.100",
            "ntpServers": "192.168.99.200",
            "searchDomains": "fbclouddemo.us"
        },
        "proxySpec": {
            "arcasVm": {
                "enableProxy": "false",
                "httpProxy": "",
                "httpsProxy": "",
                "noProxy": ""
            },
            "tkgMgmt": {
                "enableProxy": "false",
                "httpProxy": "",
                "httpsProxy": "",
                "noProxy": ""
            },
            "tkgSharedservice": {
                "enableProxy": "false",
                "httpProxy": "",
                "httpsProxy": "",
                "noProxy": ""
            },
            "tkgWorkload": {
                "enableProxy": "false",
                "httpProxy": "",
                "httpsProxy": "",
                "noProxy": ""
            }
        }
    },
    "tkgComponentSpec": {
        "aviMgmtNetwork": {
            "aviMgmtNetworkName": "vDS-VMMgtm99",
            "aviMgmtNetworkGatewayCidr": "192.168.99.1/24",
            "aviMgmtServiceIpStartRange": "192.168.99.227",
            "aviMgmtServiceIpEndRange": "192.168.99.232"
        },
        "tkgClusterVipNetwork": {
            "tkgClusterVipNetworkName": "vDS-TKG-FRNT-DATA182",
            "tkgClusterVipNetworkGatewayCidr": "192.168.182.1/24",
            "tkgClusterVipIpStartRange": "192.168.182.20",
            "tkgClusterVipIpEndRange": "192.168.182.200"
        },
        "aviComponents": {
            "aviPasswordBase64": "bbbbbbbbbbbbbbbbbbbb=",
            "aviBackupPassphraseBase64": "bbbbbbbbbbbbbbbbbb=",
            "enableAviHa": "false",
            "aviController01Ip": "192.168.99.225",
            "aviController01Fqdn": "avi-lb-01.fbclouddemo.us",
            "aviController02Ip": "",
            "aviController02Fqdn": "",
            "aviController03Ip": "",
            "aviController03Fqdn": "",
            "aviClusterIp": "",
            "aviClusterFqdn": "",
            "aviSize": "essentials",
            "aviCertPath": "",
            "aviCertKeyPath": ""
        },
        "tkgMgmtComponents": {
            "tkgMgmtNetworkName": "vDS-TKG-MGMTWKLK180",
            "tkgMgmtGatewayCidr": "192.168.180.1/24",
            "tkgMgmtClusterName": "mgmt-0",
            "tkgMgmtSize": "large",
            "tkgMgmtCpuSize": "",
            "tkgMgmtMemorySize": "",
            "tkgMgmtStorageSize": "",
            "tkgMgmtDeploymentType": "prod",
            "tkgMgmtClusterCidr": "100.96.0.0/11",
            "tkgMgmtServiceCidr": "100.64.0.0/13",
            "tkgMgmtBaseOs": "photon",
            "tkgSharedserviceClusterName": "ssc-1",
            "tkgSharedserviceSize": "medium",
            "tkgSharedserviceCpuSize": "",
            "tkgSharedserviceMemorySize": "",
            "tkgSharedserviceStorageSize": "",
            "tkgSharedserviceDeploymentType": "dev",
            "tkgSharedserviceWorkerMachineCount": "2",
            "tkgSharedserviceClusterCidr": "100.96.0.0/11",
            "tkgSharedserviceServiceCidr": "100.64.0.0/13",
            "tkgSharedserviceBaseOs": "photon",
            "tkgSharedserviceKubeVersion": "v1.22.5"
        }
    },
    "tkgMgmtDataNetwork": {
        "tkgMgmtDataNetworkName": "vDS-TKG-FRNT-DATA182",
        "tkgMgmtDataNetworkGatewayCidr": "192.168.182.1/24",
        "tkgMgmtAviServiceIpStartRange": "192.168.182.20",
        "tkgMgmtAviServiceIpEndRange": "192.168.182.200"
    },
    "tkgWorkloadDataNetwork": {
        "tkgWorkloadDataNetworkName": "vDS-TKG-FRNT-DATA182",
        "tkgWorkloadDataNetworkGatewayCidr": "192.168.182.1/24",
        "tkgWorkloadAviServiceIpStartRange": "192.168.182.20",
        "tkgWorkloadAviServiceIpEndRange": "192.168.182.200"
    },
    "tkgWorkloadComponents": {
        "tkgWorkloadNetworkName": "vDS-TKG-WKLK181",
        "tkgWorkloadGatewayCidr": "192.168.181.1/24",
        "tkgWorkloadClusterName": "onprem-tap",
        "tkgWorkloadSize": "custom",
        "tkgWorkloadCpuSize": "4",
        "tkgWorkloadMemorySize": "16",
        "tkgWorkloadStorageSize": "100",
        "tkgWorkloadDeploymentType": "prod",
        "tkgWorkloadWorkerMachineCount": "5",
        "tkgWorkloadClusterCidr": "100.96.0.0/11",
        "tkgWorkloadServiceCidr": "100.64.0.0/13",
        "tkgWorkloadBaseOs": "photon",
        "tkgWorkloadKubeVersion": "v1.22.5",
        "tkgWorkloadTsmIntegration": "false",
        "namespaceExclusions": {
            "exactName": "",
            "startsWith": ""
        }
    },
    "harborSpec": {
        "enableHarborExtension": "true",
        "harborFqdn": "harbor-01.fbclouddemo.us",
        "harborPasswordBase64": "ccccccccccccc=",
        "harborCertPath": "",
        "harborCertKeyPath": ""
    },
    "tanzuExtensions": {
        "enableExtensions": "false",
        "tkgClustersName": "",
        "logging": {
            "syslogEndpoint": {
                "enableSyslogEndpoint": "false",
                "syslogEndpointAddress": "",
                "syslogEndpointPort": "",
                "syslogEndpointMode": "",
                "syslogEndpointFormat": ""
            },
            "httpEndpoint": {
                "enableHttpEndpoint": "false",
                "httpEndpointAddress": "",
                "httpEndpointPort": "",
                "httpEndpointUri": "",
                "httpEndpointHeaderKeyValue": ""
            },
            "elasticSearchEndpoint": {
                "enableElasticSearchEndpoint": "false",
                "elasticSearchEndpointAddress": "",
                "elasticSearchEndpointPort": ""
            },
            "kafkaEndpoint": {
                "enableKafkaEndpoint": "false",
                "kafkaBrokerServiceName": "",
                "kafkaTopicName": ""
            },
            "splunkEndpoint": {
                "enableSplunkEndpoint": "false",
                "splunkEndpointAddress": "",
                "splunkEndpointPort": "",
                "splunkEndpointToken": ""
            }
        },
        "monitoring": {
            "enableLoggingExtension": "false",
            "prometheusFqdn": "",
            "prometheusCertPath": "",
            "prometheusCertKeyPath": "",
            "grafanaFqdn": "",
            "grafanaCertPath": "",
            "grafanaCertKeyPath": "",
            "grafanaPasswordBase64": ""
        }
    }
}



````


```Deploy TKGm with UI```


### So the above shows how to deploy using Arcas and AVI, but what if we just want to install TKGm with the standard tanzu tool.

##### Before I get into it I have one weird issue when I attempt to us the below command to create a management cluster inside of a VM, I was using an Ubuntu desktop VM, I get to the point where the management node(s) are scaling up and it just sits there for a long time until the installation dies, but on my physical Ubuntu laptop it works just fine, maybe something weird wth docker running inside a VM??


````

tanzu mc create --ui

#or

tanzu management-cluster create --ui

````

### The above will serve up a webpage so you can fill in your data

````

AVI_CA_DATA_B64: ""
AVI_CLOUD_NAME: ""
AVI_CONTROL_PLANE_HA_PROVIDER: ""
AVI_CONTROLLER: ""
AVI_DATA_NETWORK: ""
AVI_DATA_NETWORK_CIDR: ""
AVI_ENABLE: "false"
AVI_LABELS: ""
AVI_MANAGEMENT_CLUSTER_VIP_NETWORK_CIDR: ""
AVI_MANAGEMENT_CLUSTER_VIP_NETWORK_NAME: ""
AVI_PASSWORD: ""
AVI_SERVICE_ENGINE_GROUP: ""
AVI_USERNAME: ""
CLUSTER_CIDR: 100.96.0.0/11
CLUSTER_NAME: mgmt-1
CLUSTER_PLAN: dev
ENABLE_AUDIT_LOGGING: "false"
ENABLE_CEIP_PARTICIPATION: "true"
ENABLE_MHC: "true"
IDENTITY_MANAGEMENT_TYPE: none
INFRASTRUCTURE_PROVIDER: vsphere
LDAP_BIND_DN: ""
LDAP_BIND_PASSWORD: ""
LDAP_GROUP_SEARCH_BASE_DN: ""
LDAP_GROUP_SEARCH_FILTER: ""
LDAP_GROUP_SEARCH_GROUP_ATTRIBUTE: ""
LDAP_GROUP_SEARCH_NAME_ATTRIBUTE: cn
LDAP_GROUP_SEARCH_USER_ATTRIBUTE: DN
LDAP_HOST: ""
LDAP_ROOT_CA_DATA_B64: ""
LDAP_USER_SEARCH_BASE_DN: ""
LDAP_USER_SEARCH_FILTER: ""
LDAP_USER_SEARCH_NAME_ATTRIBUTE: ""
LDAP_USER_SEARCH_USERNAME: userPrincipalName
OIDC_IDENTITY_PROVIDER_CLIENT_ID: ""
OIDC_IDENTITY_PROVIDER_CLIENT_SECRET: ""
OIDC_IDENTITY_PROVIDER_GROUPS_CLAIM: ""
OIDC_IDENTITY_PROVIDER_ISSUER_URL: ""
OIDC_IDENTITY_PROVIDER_NAME: ""
OIDC_IDENTITY_PROVIDER_SCOPES: ""
OIDC_IDENTITY_PROVIDER_USERNAME_CLAIM: ""
OS_ARCH: amd64
OS_NAME: photon
OS_VERSION: "3"
SERVICE_CIDR: 100.64.0.0/13
TKG_HTTP_PROXY_ENABLED: "false"
TKG_IP_FAMILY: ipv4
VSPHERE_CONTROL_PLANE_DISK_GIB: "40"
VSPHERE_CONTROL_PLANE_ENDPOINT: 192.168.180.85
VSPHERE_CONTROL_PLANE_MEM_MIB: "16384"
VSPHERE_CONTROL_PLANE_NUM_CPUS: "4"
VSPHERE_DATACENTER: /dc-01
VSPHERE_DATASTORE: /dc-01/datastore/truenas-iscsi-01
VSPHERE_FOLDER: /dc-01/vm/tkg-vsphere-tkg-mgmt
VSPHERE_INSECURE: "false"
VSPHERE_NETWORK: /dc-01/network/vDS-TKG-MGMTWKLK180-N
VSPHERE_PASSWORD: <encoded:a3VOPmQyc3c=>
VSPHERE_RESOURCE_POOL: /dc-01/host/cluster-02/Resources
VSPHERE_SERVER: 192.168.99.20
VSPHERE_SSH_AUTHORIZED_KEY: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC2Ibvh0f1KXOs3rOp1NedgVefcI+vCI0ucS/CzxY7xXyrT6Y/dky90ZfZD06bX925OrsrtnoTZG0W0SjPI5iO+QcJEaJOT7qdlZFmcNk9CM9YyfiOjB7UMx5+CGgVY6UX1zRkbp004sJzrgAfM5u7eQfxE+u6wZx9myOxPi6KsKDDkYH8owgp+ZIj7fgG7QZYugzsVnWCm9mDp9qTcknctil+Zi35BiOmd5tMHw+y8ZYP0YmFArYxQx5x0djv1rKDTE1JxjFY7nQzlos0g5hKTlr+Wk1Lxu9LAHc6D2XKokXT5wIZIpYmR4MuQlBiyDuYcZjjp5PKj1A+9y2TZQ3S99giM1vW6h15KfS3PApseOtjuwCO/ABdazgzaHWt1H9+rGfnfcb08lvn5uC0pwwjSzBIik75lzRYP2DHASufN4QiEgmS0+P6Ya9LpxTedQ1vDGa+RMGlqYY4CidKOLBc871KvXpijQEbaHmg932JwJiz5OvhbiY4E4YLMS69Aeg0= fabian@fb-HP-EliteBook-850-G5
VSPHERE_TLS_THUMBPRINT: 08:35:EA:FA:18:FF:FF:FF:FF:FF:FF:FF:FF:0B:42:6C:71:0F:BF:D0
VSPHERE_USERNAME: administrator@vsphere.local
VSPHERE_WORKER_DISK_GIB: "40"
VSPHERE_WORKER_MEM_MIB: "16384"
VSPHERE_WORKER_NUM_CPUS: "4"


````


#### The above is an example of a file for a mgmt cluster, I want to call out a few things

#### We are using kube-vip hence this line "VSPHERE_CONTROL_PLANE_ENDPOINT: 192.168.180.85" the kube-vip IP must be in the same VLAN as the DHCP pool but must be outside the pool

#### So my mgmt cluster VMs will be on VLAN 180 PG "vDS-TKG-MGMTWKLK180-N" and those will be inside the DHCP pool



````

AVI_CA_DATA_B64: ""
AVI_CLOUD_NAME: ""
AVI_CONTROL_PLANE_HA_PROVIDER: ""
AVI_CONTROLLER: ""
AVI_DATA_NETWORK: ""
AVI_DATA_NETWORK_CIDR: ""
AVI_ENABLE: "false"
AVI_LABELS: ""
AVI_MANAGEMENT_CLUSTER_VIP_NETWORK_CIDR: ""
AVI_MANAGEMENT_CLUSTER_VIP_NETWORK_NAME: ""
AVI_PASSWORD: ""
AVI_SERVICE_ENGINE_GROUP: ""
AVI_USERNAME: ""
CLUSTER_CIDR: 100.96.0.0/11
CLUSTER_NAME: wkld-1
CLUSTER_PLAN: dev
ENABLE_AUDIT_LOGGING: "false"
ENABLE_CEIP_PARTICIPATION: "true"
ENABLE_MHC: "true"
IDENTITY_MANAGEMENT_TYPE: none
INFRASTRUCTURE_PROVIDER: vsphere
LDAP_BIND_DN: ""
LDAP_BIND_PASSWORD: ""
LDAP_GROUP_SEARCH_BASE_DN: ""
LDAP_GROUP_SEARCH_FILTER: ""
LDAP_GROUP_SEARCH_GROUP_ATTRIBUTE: ""
LDAP_GROUP_SEARCH_NAME_ATTRIBUTE: cn
LDAP_GROUP_SEARCH_USER_ATTRIBUTE: DN
LDAP_HOST: ""
LDAP_ROOT_CA_DATA_B64: ""
LDAP_USER_SEARCH_BASE_DN: ""
LDAP_USER_SEARCH_FILTER: ""
LDAP_USER_SEARCH_NAME_ATTRIBUTE: ""
LDAP_USER_SEARCH_USERNAME: userPrincipalName
OIDC_IDENTITY_PROVIDER_CLIENT_ID: ""
OIDC_IDENTITY_PROVIDER_CLIENT_SECRET: ""
OIDC_IDENTITY_PROVIDER_GROUPS_CLAIM: ""
OIDC_IDENTITY_PROVIDER_ISSUER_URL: ""
OIDC_IDENTITY_PROVIDER_NAME: ""
OIDC_IDENTITY_PROVIDER_SCOPES: ""
OIDC_IDENTITY_PROVIDER_USERNAME_CLAIM: ""
OS_ARCH: amd64
OS_NAME: photon
OS_VERSION: "3"
SERVICE_CIDR: 100.64.0.0/13
TKG_HTTP_PROXY_ENABLED: "false"
TKG_IP_FAMILY: ipv4
VSPHERE_CONTROL_PLANE_DISK_GIB: "40"
VSPHERE_CONTROL_PLANE_ENDPOINT: 192.168.181.200
VSPHERE_CONTROL_PLANE_MEM_MIB: "16384"
VSPHERE_CONTROL_PLANE_NUM_CPUS: "4"
VSPHERE_DATACENTER: /dc-01
VSPHERE_DATASTORE: /dc-01/datastore/truenas-iscsi-01
VSPHERE_FOLDER: /dc-01/vm/tkg-vsphere-workload
VSPHERE_INSECURE: "false"
VSPHERE_NETWORK: /dc-01/network/vDS-TKG-WKLK181-N
VSPHERE_PASSWORD: <encoded:a3VOPmQyc3c=>
VSPHERE_RESOURCE_POOL: /dc-01/host/cluster-02/Resources/wkld-1
VSPHERE_SERVER: 192.168.99.20
VSPHERE_SSH_AUTHORIZED_KEY: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC2Ibvh0f1KXOs3rOp1NedgVefcI+vCI0ucS/CzxY7xXyrT6Y/dky90ZfZD06bX925OrsrtnoTZG0W0SjPI5iO+QcJEaJOT7qdlZFmcNk9CM9YyfiOjB7UMx5+CGgVY6UX1zRkbp004sJzrgAfM5u7eQfxE+u6wZx9myOxPi6KsKDDkYH8owgp+ZIj7fgG7QZYugzsVnWCm9mDp9qTcknctil+Zi35BiOmd5tMHw+y8ZYP0YmFArYxQx5x0djv1rKDTE1JxjFY7nQzlos0g5hKTlr+Wk1Lxu9LAHc6D2XKokXT5wIZIpYmR4MuQlBiyDuYcZjjp5PKj1A+9y2TZQ3S99giM1vW6h15KfS3PApseOtjuwCO/ABdazgzaHWt1H9+rGfnfcb08lvn5uC0pwwjSzBIik75lzRYP2DHASufN4QiEgmS0+P6Ya9LpxTedQ1vDGa+RMGlqYY4CidKOLBc871KvXpijQEbaHmg932JwJiz5OvhbiY4E4YLMS69Aeg0= fabian@fb-HP-EliteBook-850-G5
VSPHERE_TLS_THUMBPRINT: 08:35:EA:FA:18:FF:FF:FF:FF:FF:FF:FF:FF:FF:FF:6C:71:0F:BF:D0
VSPHERE_USERNAME: administrator@vsphere.local
VSPHERE_WORKER_DISK_GIB: "40"
VSPHERE_WORKER_MEM_MIB: "16384"
VSPHERE_WORKER_NUM_CPUS: "4"


````

#### The above is an example of a workload cluster file, note all you do is copy the mgmt file generated and rename it the only changes are the "VSPHERE_CONTROL_PLANE_ENDPOINT" and the PG vDS-TKG-WKLK181-N and the "Name" again here my workload will be deployed into VLAN 181, so this depicts a 2 network topology, but it's extremely flexible as I can copy the file again and deploy a new workload cluster and this time place it in VLAN 900

#### Once I have my workload file I just need to run the below


````

tanzu cluster create mycluster -f /home/myuser/.config/tanzu/tkg/clusterconfigs/wkld1.yaml -v 6

#or generate a mgmt file and then instead of installing with UI I can do this

tanzu management-cluster create mgmt-1  --file /home/fabian/.config/tanzu/tkg/clusterconfigs/jkg8tlr4jt.yaml -v 6

````

#### Get the admin context of a cluster

````

tanzu cluster kubeconfig get wkld-1 --admin

````
