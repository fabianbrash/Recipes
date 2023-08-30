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

##### Before I get into it I have one weird issue when I attempt to use the below command to create a management cluster inside of a VM, I was using an Ubuntu desktop VM, I get to the point where the management node(s) are scaling up and it just sits there for a long time until the installation dies, but on my physical Ubuntu laptop it works just fine, maybe something weird wth docker running inside a VM??


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
CLUSTER_NAME: wkld-2
CLUSTER_PLAN: prod
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
VSPHERE_CONTROL_PLANE_ENDPOINT: 192.168.181.201
VSPHERE_CONTROL_PLANE_MEM_MIB: "16384"
VSPHERE_CONTROL_PLANE_NUM_CPUS: "4"
VSPHERE_DATACENTER: /dc-01
VSPHERE_DATASTORE: /dc-01/datastore/truenas-iscsi-01
VSPHERE_FOLDER: /dc-01/vm/tkg-vsphere-workload
VSPHERE_INSECURE: "false"
VSPHERE_NETWORK: /dc-01/network/vDS-TKG-WKLK181-N
VSPHERE_PASSWORD: <encoded:a3VOPmQyc3c=>
VSPHERE_RESOURCE_POOL: /dc-01/host/cluster-02/Resources/wkld-2
VSPHERE_SERVER: 192.168.99.20
VSPHERE_SSH_AUTHORIZED_KEY: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC2Ibvh0f1KXOs3rOp1NedgVefcI+vCI0ucS/CzxY7xXyrT6Y/dky90ZfZD06bX925OrsrtnoTZG0W0SjPI5iO+QcJEaJOT7qdlZFmcNk9CM9YyfiOjB7UMx5+CGgVY6UX1zRkbp004sJzrgAfM5u7eQfxE+u6wZx9myOxPi6KsKDDkYH8owgp+ZIj7fgG7QZYugzsVnWCm9mDp9qTcknctil+Zi35BiOmd5tMHw+y8ZYP0YmFArYxQx5x0djv1rKDTE1JxjFY7nQzlos0g5hKTlr+Wk1Lxu9LAHc6D2XKokXT5wIZIpYmR4MuQlBiyDuYcZjjp5PKj1A+9y2TZQ3S99giM1vW6h15KfS3PApseOtjuwCO/ABdazgzaHWt1H9+rGfnfcb08lvn5uC0pwwjSzBIik75lzRYP2DHASufN4QiEgmS0+P6Ya9LpxTedQ1vDGa+RMGlqYY4CidKOLBc871KvXpijQEbaHmg932JwJiz5OvhbiY4E4YLMS69Aeg0= fabian@fb-HP-EliteBook-850-G5
VSPHERE_TLS_THUMBPRINT: 08:35:EA:FA:18:FF:FF:FF:FF:FF:FF:FF:FF:0B:42:6C:71:0F:BF:D0
VSPHERE_USERNAME: administrator@vsphere.local
VSPHERE_WORKER_DISK_GIB: "40"
VSPHERE_WORKER_MEM_MIB: "16384"
VSPHERE_WORKER_NUM_CPUS: "4"
WORKER_MACHINE_COUNT: 4


````


```Windows workload```


````


#! ---------------------------------------------------------------------
#! vSphere non proxy env configs
#! ---------------------------------------------------------------------
AVI_CA_DATA_B64: S0tLS0tCk1JSUR3VENDQXFtZ0F3SUJBZ0lVUG5xWjVjSWNGU01hcEhhd08vQlBCUW9JRlEwd0RRWUpLb1pJaHZjTkFRRUwKQlFBd2dZSXhDekFKQmdOVkJBWVRBbFZUTVeVF5SzkxMSsrMGV3ClU3UWUrQWFEWk5ETlJob2lnN2NaN2p5aVVmZEVDWGh6VFF1eFlhR1U5REoxZG0rRSt0RWk3dnFxTnRZTXlNNi8KRTRUY1V6Z1VvZHAwbm04Y0wrbTdDNjVieHByY1A4WjBMR2ZaQVN3OXI5U2gzR0k0R0dCRCtGS3hYMlloUEEwbgpidzNScTl4Uy90Y3Y2dnM3N00wSjVHVk9ON0hTZUgxZ21yYXN5SGR0b3h3MDR3R0M5YU5ieUNkMVZpVW==
AVI_CLOUD_NAME: tkgvsphere-cloud01
AVI_CONTROLLER: avi-lb-01.fbclouddemo.us
AVI_DATA_NETWORK: vDS-TKG-FRNT-DATA182
AVI_DATA_NETWORK_CIDR: 192.168.182.0/24
AVI_ENABLE: 'true'
AVI_LABELS: |
    'type': 'management'
AVI_PASSWORD: <encoded:111dddffgggtty>
AVI_SERVICE_ENGINE_GROUP: tkgvsphere-tkgmgmt-group01
AVI_USERNAME: admin
CLUSTER_CIDR: 100.96.0.0/11
CLUSTER_NAME: fb-win-wkld-1
CLUSTER_PLAN: dev
ENABLE_CEIP_PARTICIPATION: 'true'
INFRASTRUCTURE_PROVIDER: vsphere
SERVICE_CIDR: 100.64.0.0/13
TKG_HTTP_PROXY_ENABLED: false
DEPLOY_TKG_ON_VSPHERE7: 'true'
VSPHERE_DATACENTER: /dc-01
VSPHERE_DATASTORE: /dc-01/datastore/truenas-iscsi-01
VSPHERE_FOLDER: /dc-01/vm/tkg-vsphere-tkg-mgmt
VSPHERE_NETWORK: vDS-TKG-MGMTWKLK180
VSPHERE_PASSWORD: <encoded:1111dddffgggg>
VSPHERE_RESOURCE_POOL: /dc-01/host/cluster-01/Resources/tkg-vsphere-tkg-Mgmt
VSPHERE_SERVER: 192.168.99.20
VSPHERE_SSH_AUTHORIZED_KEY: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCXxC/DmQp2xhMZu/lGfv8K06fvHP+vNWnY2/gJNu9QfmlHnUWz3XPb78dyHa5SDRv1KrDdV9sWZgygwB4V5HMfR1beAdauvp1qtriAJgdCs+WWHPyYrcTpzVuTWEkDcxyh27Ejmkm9Z1t/LLmxUPCY4mv3FiwmUunjvJCKMANvqvgYG2vbrjAWccC0tLriyEsHiXbbRzYaNJ9vl59Q9vPrY4GwGtW3KNXt6Dz3fRNUc+lfLoS9XZqGaGK+Ondc1QUhexwoZ8i8gTYiIEKATDlfDf0Tip4hzT9JaGr+QQMbCVB2aWj1gnL3xaRs66+HdlQkrDg8DaIxz+TrdzpHOuzza+x3hcCjIAXPLA9GOHzxEl6udgQJpBedvXxoZ/ARwPDGoyNMG004Jbh43A3V5JJhqvko8fCAk8p0sMXYzCw86PPNXPjWLaLUnF9f9DNGzq6wTRdLRY6JXWHb5dAwDRVkoWd/m82JqpGJ3+dREXhD4yjdlk1Pct01m9L7W2Egb3dOS9tle324hbvF4+5WYzj4k8srS+ApQVUQaZgOh7n3A29xTvHqMQ6heCtKqeLOZBvmWrWysZEC4S43cnjxqBT55kHEGgiMJKQ9NGm2A9kNL89iKac98/3PzV1UTLhTQnVhY9QSKer3xTEIioD1B+f90cMkC5oj5eroBtCCgTJRMQ== administrator@vsphere.local

VSPHERE_USERNAME: administrator@vsphere.local
VSPHERE_INSECURE: 'true'
AVI_CONTROL_PLANE_HA_PROVIDER: 'true'
ENABLE_AUDIT_LOGGING: 'true'
OS_ARCH: amd64
OS_NAME: ubuntu
OS_VERSION: 20.04
AVI_MANAGEMENT_CLUSTER_VIP_NETWORK_NAME: vDS-TKG-FRNT-DATA182
AVI_MANAGEMENT_CLUSTER_VIP_NETWORK_CIDR: 192.168.182.0/24

VSPHERE_CONTROL_PLANE_NUM_CPUS: 4
VSPHERE_CONTROL_PLANE_DISK_GIB: 100
VSPHERE_CONTROL_PLANE_MEM_MIB: 16384
VSPHERE_WORKER_NUM_CPUS: 4
VSPHERE_WORKER_DISK_GIB: 100
VSPHERE_WORKER_MEM_MIB: 16384
IS_WINDOWS_WORKLOAD_CLUSTER: "true"
VSPHERE_WINDOWS_TEMPLATE: windows-2019-kube-v1.22.8
WORKER_MACHINE_COUNT: 2
ENABLE_MHC: "false"

IDENTITY_MANAGEMENT_TYPE: none

#! ---------------------------------------------------------------------
#! vSphere proxy env configs
#! ---------------------------------------------------------------------


#! ---------------------------------------------------------------------
#! vSphere airgapped env configs
#! ---------------------------------------------------------------------



````


#### Above we are using the prod plan and insteadd of 3 worker nodes we have specified 4

#### Once I have my workload file I just need to run the below


````

tanzu cluster create mycluster -f /home/myuser/.config/tanzu/tkg/clusterconfigs/wkld1.yaml -v 6

#or generate a mgmt file and then instead of installing with UI I can do this

tanzu management-cluster create mgmt-1  --file /home/fabian/.config/tanzu/tkg/clusterconfigs/jkg8tlr4jt.yaml -v 6

````

#### Get the admin context of a cluster

````

tanzu cluster kubeconfig get wkld-1 --admin

tanzu cluster kubeconfig get wkld-1 #this will get the kubeconfig for a regular user/non-admin


tanzu mc kubeconfig get --export-file /tmp/my-cluster-kubeconfig  ## Export to a file, this of course is for the mgmt cluster note we are not using --admin so this would be regular access or if clusterrolebindings are not in effect no access to resources

tanzu cluster kubeconfig get my-cluster --export-file /tmp/my-cluster-kubeconfig ## Export to a file for a dev


tanzu login --endpoint https://172.31.0.49:6443 --name tkg-mgmt-cluster  #We can also get a dev access to the mgmt cluster this way(should this be a workload cluster and not mgmt??)

````


#### Create a new cluster by copying an existing cluster YAML file and then make the appropriate changes to it


````

cp mycluster.yaml newcluster.yaml

#Make changes to the new file newcluster.yaml

tanzu cluster create --dry-run --file newcluster.yaml > newcluster-output.yaml

kubectl apply -f newcluster-output.yaml

````

```PINNIPED/DEX config```


```LDAPS```


[https://cormachogan.com/2021/06/18/tkg-v1-3-active-directory-integration-with-pinniped-and-dex/](https://cormachogan.com/2021/06/18/tkg-v1-3-active-directory-integration-with-pinniped-and-dex/)


[https://tanzu.vmware.com/content/blog/cluster-api-based-kubernetes-tanzu-kubernetes-grid-1-3](https://tanzu.vmware.com/content/blog/cluster-api-based-kubernetes-tanzu-kubernetes-grid-1-3)

[https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.5/vmware-tanzu-kubernetes-grid-15/GUID-iam-configure-id-mgmt.html](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.5/vmware-tanzu-kubernetes-grid-15/GUID-iam-configure-id-mgmt.html)

[https://brianragazzi.wordpress.com/2020/05/12/configure-tanzu-kubernetes-grid-to-use-active-directory/](https://brianragazzi.wordpress.com/2020/05/12/configure-tanzu-kubernetes-grid-to-use-active-directory/)

````


IDENTITY_MANAGEMENT_TYPE: ldap
LDAP_BIND_DN: CN=User John,OU=fb-admin,OU=Users,OU=Restricted,DC=fbclouddemo,DC=us
LDAP_BIND_PASSWORD: mypassword
LDAP_GROUP_SEARCH_BASE_DN: OU=RestrictedGroups,OU=Restricted,DC=fbclouddemo,DC=us
LDAP_GROUP_SEARCH_FILTER: (objectClass=group)
LDAP_GROUP_SEARCH_GROUP_ATTRIBUTE: member
LDAP_GROUP_SEARCH_NAME_ATTRIBUTE: cn
LDAP_HOST: fb-dc-01.fbclouddemo.us
LDAP_ROOT_CA_DATA_B64: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUZnVENDQTJtZ0F3SUJBZ0lRTGFwL0NXOG55SVJBbmUxNytxWTh2ekFOQmdrcWhraUc5dzBCQVFzRkFEQlQKTVJJd0VBWUtDWkltaVpQeUxHUUJHUllDZFhNeEd6QVpCZ29Ka2lhSmsvSXNaQUVaRmd0bVltTnNiM1ZrWkdWdApiekVnTUI0R0ExVUVBeE1YWm1KamJHOTFaR1JsYlc4dFJrSXRRMEV0TURFdFEwRXdIaGNOTWpJd05UQTFNVEUwCk5USXdXaGNOTWpjd05UQTFNVEUxTlRFNFdqQlRNUkl3RUFZS0NaSW1pWlB5TEdRQkdSWUNkWE14R3pBWkJnb0oKa2lhSmsvSXNaQUVaRmd0bVltTnNiM1ZrWkdWdGJ6RWdNQjRHQTFVRUF4TVhabUpqYkc5MVpHUmxiVzh0UmtJdApRMEV0TURFdFEwRXdnZ0lpTUEwR0NTcUdTSWIzRFFFQkFRVUFBNElDRHdBd2dnSUtBb0lDQVFDN1dEQjlNVGVtCkI4dG9rSHRqbGFYL2c0Qkp3WVFGNkZMNVBVOVpmUlA1cS9yNTZhVno2cXJUdXF1NE4wVGJFZVpoMDNxME5pN20KdXBIb3I0ZC9HRWJHaTNwdVpJbGhWbXYzMkxlUU1mVDFOM0NUNG1XaWQ1aHJyNWtzR2pGUDBTNTd0SWJzeldpWgplVEdyTHB4bWF4M2lJSXhkTjgwR3FFTllsYy9pQzdMU2xlL0l4VytMWXoxd2FiRVlZNjBEakV3UkFEdkRzWEtzCkNiaWJwR0hHb3hGdElOZW10Tm1MbWZaWTdVcGFKZ1VGRXJDNmtNa3g2NEtFeVNyZnlrMWlucjlaTUxkdnU5SVkKNDkyRUUySFdBb1ZLejI0WExvaklNWGdwZW9pSEFLTWtwVHgreFA5cXQyTGtzc2dFRHM0T2o4aUlabysvbEZlZgpxbW41d3BLVE1LRjdBdUpSQ21MNzFFdDdwbmlMZjl0N2k2UGlka0VVbEE0aGN4WFZQdVN0Ni9DOWZ6T25NZjVPCnRMcmEzdjdhcXVxNWQ0a3o2eVhtTTNPT05xN25MRlRrZGlGMVRteXo1bmIyOXpMQlJkUi9URDNmTHhqZ1BDUXEKS1Jnd3hUNjYwZEd2VkRFVXBxVHdiUGovN2tEbFNtMVJxMzVtakdET2UySXZrdmJDQUZPSlZkTFZSUW5xdVpYTgphYjVWbDBrMmpZbEIxdk1XMEZKWERhSzdNWHV4d2xXNTFzcVBHd1MrSUNUMnExTzBIUXV2MEhHbSszWTBKS0k5CkpFMHBzN1liVFUxbzJwVi91blp5Tm10SG9qNTlBNFJmQkVYbzQvRHZ0Q2o4Z3didjZSNllkUG5lUDMxRFVGanYKRkVXb3dwVE85R1owYkhWbzU2NzRRV0pzYnpVK3hnVGVOUUlEQVFBQm8xRXdUekFMQmdOVkhROEVCQU1DQVlZdwpEd1lEVlIwVEFRSC9CQVV3QXdFQi96QWRCZ05WSFE0RUZnUVVGemRpL01rNEhEM0wrV1hXaThtSzNVbkpvbTR3CkVBWUpLd1lCQkFHQ054VUJCQU1DQVFBd0RRWUpLb1pJaHZjTkFRRUxCUUFEZ2dJQkFDdlRZZStxSjBnMzNHdFcKSUJrTkZqVW8xcGRaRmFWc0p6anNjakFBMGNFYjRBUy9PRTVUcFozaVVnWDRHdStTZ05MQUVKNitNV0gwM1N3cQpOenhMcDZhd3NxR20rWHZNcDNORzROY1NBdW1oZTdIaFNEZ3YxL3F6a3NZcVJkdThiQ0psNm5NZkEwVWkvSDhTCnlRWmFFUDd6ditvdXVkTS9xaFRUYkFwTFlYWTdobXArNy9PNjNheFFCY0dKVS84eWh6S1NCaC90NjN4VVRic0YKVXBDR1Z4L21LU1hOZGhFOWxhamdJQkZJQlpMZE55Kzg2eGxmanJaUWt1S2tMNjgxMUFSdjQ3S0RuNlJvUDhHZQoyM0pSckk4VFczT3pqckdBMXdxcWxPdGZ5cVZUUXNkbUJ6N2RPODBSTlhaYmFKWHArM0JPbzcvU2s4SFR1VzdMCm5mOWZEQlRmb1JDR2tDU3NuWGpvYUpic05qdW8rdkxSb0NVcFBKTjFtVE1HLzBpUHh2eUl4V1Z1dXZCdHpUN2EKZEZ5YXhTUzNuYlFXRVZ3SWlvSVhHSXVOdFhxbEJ0L1V0WXdJNGNDeTJqOXl1NkZ0NjlVMFVHZjZCL3F3ZERQUQpsYUovMG1XeHA5aUNJU2pMUlMvMG5wSThnWDBXNmQzMXd2T0N2SmF1SmlJS3k2VEV2cmFTL3BLYTViWDgwTXprCitnU1Mrcy9SaE1FTEsvV2d3U29HZDVKZko2dDRBeFVKY1Vsajd3R21jUVcvVnRaNndHK21UNlg4bHM0UEhRbEIKcVNkVldjY3c4RWpzcFU4QzMxaWcvd1gxanhaN3lqWnN6M21QZnN6ZkRjak80bjVSMGQ0R21Wek10TEZXNWFGYgpKSERYYkxiQ0swclgwWDZIK1FzTTRUR3VaaklwCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLSQ$#@EDFFFGGG=
LDAP_USER_SEARCH_BASE_DN: OU=Users,OU=Restricted,DC=fbclouddemo,DC=us
LDAP_USER_SEARCH_EMAIL_ATTRIBUTE: 'DN'
LDAP_USER_SEARCH_ID_ATTRIBUTE: 'DN'
LDAP_USER_SEARCH_NAME_ATTRIBUTE: 'userPrincipalName'
LDAP_USER_SEARCH_FILTER: (objectClass=person)
LDAP_USER_SEARCH_USERNAME: userPrincipalName

````

#### Switch context to the worload cluster, as admin and create a cluster role on the cluster so DevUsers can have view access or whatever else you want

````
kubectl get clusterrole

kubectl create clusterrolebinding DevUsers --clusterrole=view --group=DevUsers  ## Here I am giving any user in the DevUsers AD group 'view' access to the cluster

````

#### The root-CA certificate we upload from the above can be found here

````

 kubectl get cm -n pinniped-supervisor
 
 kubectl get cm kube-root-ca.crt -oyaml -n pinniped-supervisor
 
````

#### Pinniped also creates it's own root CA cert and private key and that you can find here

````

kubectl get secrets -n pinniped-concierge

kubectl get secret pinniped-concierge-api-tls-serving-certificate -oyaml -n pinniped-concierge


````

#### ODD thing the above cert and private key is base64 encoded while your root-CA certificate is not, is that because it was base64 encoded when we exported it??



#### Now let's label our cluster if it wasn't already labeled

````

kubectl label cluster mycluster type=workload-set01


kubectl get cluster mycluster --show-labels

````

```Create an ADC```


````

apiVersion: networking.tkg.tanzu.vmware.com/v1alpha1
kind: AKODeploymentConfig
metadata:
  finalizers:
  - ako-operator.networking.tkg.tanzu.vmware.com
  generation: 2
  name: workload-ako
spec:
  adminCredentialRef:
    name: avi-controller-credentials
    namespace: tkg-system-networking
  certificateAuthorityRef:
    name: avi-controller-ca
    namespace: tkg-system-networking
  cloudName: tkgvsphere-cloud01
  clusterSelector:
    matchLabels:
      type: workload
  controller: avi-lb-01.fbclouddemo.us
  dataNetwork:
    cidr: 192.168.182.0/24
    name: vDS-TKG-FRNT-DATA182
  extraConfigs:
    cniPlugin: antrea
    disableStaticRouteSync: true
    #image:
    #pullPolicy: IfNotPresent
    #repository: projects-stg.registry.vmware.com/tkg/ako
    #version: v1.3.2_vmware.1
    ingress:
      defaultIngressController: false
      disableIngressClass: true
  serviceEngineGroup: tkgvsphere-tkgworkload-group01

````

##### Then from the mgmt context label your workload cluster(s)

````
kubectl label cluster mycluster type=workload


kubectl get cluster mycluster --show-labels

````


```TKGm on Azure```


##### So I deployed TKGm on Azure and my management cluster deploye no issues, then I went to deploy my workload cluster and it kept failing by not creating any VMs for the workload cluster, I ran the below command and sure enough it was a quota issue, note this is my personal Azure account, I didn't realize I needed to manage quotas with it, I thought they just charged me for what I use.


````
kubectl describe cluster-api -A

````

##### Log into the azure portal and search for quotas and request an increase for the desired region


```TKGm 2.x```

##### You might run into an issue when creating a workload cluster


````
Validation error when running tanzu cluster create

````


````
tanzu config set features.cluster.auto-apply-generated-clusterclass-based-configuration true

````

[https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/2.1/tkg-deploy-mc-21/mgmt-release-notes.html#TKG-17286](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/2.1/tkg-deploy-mc-21/mgmt-release-notes.html#TKG-17286)


```TKG 2.3 Classy```


````

apiVersion: v1
kind: Secret
metadata:
  annotations:
    tkg.tanzu.vmware.com/addon-type: authentication/pinniped
  labels:
    clusterctl.cluster.x-k8s.io/move: ""
    tkg.tanzu.vmware.com/addon-name: pinniped
    tkg.tanzu.vmware.com/cluster-name: workload-kv-1 #This name must match everywhere
  name: workload-kv-1-pinniped-package
  namespace: default #This much match throughout our document
stringData:
  values.yaml: |
    infrastructure_provider: vsphere
    tkg_cluster_role: workload
    identity_management_type: none
type: clusterbootstrap-secret
---
apiVersion: cpi.tanzu.vmware.com/v1alpha1
kind: VSphereCPIConfig
metadata:
  name: workload-kv-1
  namespace: default
spec:
  vsphereCPI:
    mode: vsphereCPI
    tlsCipherSuites: TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
    vmNetwork:
      excludeExternalSubnetCidr: 192.168.181.200/32 #These are our kube-vip IP
      excludeInternalSubnetCidr: 192.168.181.200/32
---
apiVersion: csi.tanzu.vmware.com/v1alpha1
kind: VSphereCSIConfig
metadata:
  name: workload-kv-1
  namespace: default
spec:
  vsphereCSI:
    config:
      datacenter: /dc-01
      httpProxy: ""
      httpsProxy: ""
      insecureFlag: false
      noProxy: ""
      region: null
      tlsThumbprint: 80:25:43:3B:6E:EE:8E:7B:E9:0F:6C:5F:5E:92
      useTopologyCategories: false
      zone: null
    mode: vsphereCSI
---
apiVersion: run.tanzu.vmware.com/v1alpha3
kind: ClusterBootstrap
metadata:
  annotations:
    tkg.tanzu.vmware.com/add-missing-fields-from-tkr: v1.26.5---vmware.2-tkg.1
  name: workload-kv-1
  namespace: default
spec:
  additionalPackages:
  - refName: metrics-server*
  - refName: secretgen-controller*
  - refName: pinniped*
  cpi:
    refName: vsphere-cpi*
    valuesFrom:
      providerRef:
        apiGroup: cpi.tanzu.vmware.com
        kind: VSphereCPIConfig
        name: workload-kv-1
  csi:
    refName: vsphere-csi*
    valuesFrom:
      providerRef:
        apiGroup: csi.tanzu.vmware.com
        kind: VSphereCSIConfig
        name: workload-kv-1
  kapp:
    refName: kapp-controller*
---
apiVersion: v1
kind: Secret
metadata:
  name: workload-kv-1
  namespace: default
stringData:
  password: supersecret # vCenter username and password
  username: administrator@vsphere.local
---
apiVersion: cluster.x-k8s.io/v1beta1
kind: Cluster
metadata:
  annotations:
    osInfo: photon,3,amd64
    tkg.tanzu.vmware.com/cluster-controlplane-endpoint: 192.168.181.200 #kube-vip IP
    tkg/plan: prod
  labels:
    #cluster-role.tkg.tanzu.vmware.com/management: "" this has to be commented out or just deleted or cluster creation will fail
    tkg.tanzu.vmware.com/cluster-name: workload-kv-1
  name: workload-kv-1
  namespace: default
spec:
  clusterNetwork:
    pods:
      cidrBlocks:
      - 100.96.0.0/11
    services:
      cidrBlocks:
      - 100.64.0.0/13
  topology:
    class: tkg-vsphere-default-v1.1.0
    controlPlane:
      metadata:
        annotations:
          run.tanzu.vmware.com/resolve-os-image: image-type=ova,os-name=photon
      replicas: 3
    variables:
    - name: cni
      value: antrea
    - name: controlPlaneCertificateRotation
      value:
        activate: true
        daysBefore: 90
    - name: auditLogging
      value:
        enabled: true
    - name: podSecurityStandard
      value:
        audit: restricted
        deactivated: false
        warn: restricted
    - name: apiServerEndpoint
      value: 192.168.181.200 #kube-vip IP
    - name: aviAPIServerHAProvider
      value: false
    - name: vcenter
      value:
        cloneMode: fullClone
        datacenter: /dc-01
        datastore: /dc-01/datastore/truenas-iscsi-01
        folder: /dc-01/vm/tkg-vsphere-workload
        network: /dc-01/network/vDS-TKG-WKLK181
        resourcePool: /dc-01/host/cluster-01/Resources/tkg-workloads
        server: 192.168.100.20 #vCenter IP or FQDN
        storagePolicyID: ""
        template: /dc-01/vm/TKGm-templates/photon-3-kube-v1.26.5+vmware.2
        tlsThumbprint: 80:25:43:3B:6E:EE:8E:7B:E9:0F:6C
    - name: user
      value:
        sshAuthorizedKeys:
        - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEouXZ/n3+vqAAhyJBztmPFs8
    - name: controlPlane
      value:
        machine:
          diskGiB: 20
          memoryMiB: 4096
          numCPUs: 2
    - name: worker
      value:
        machine:
          diskGiB: 80
          memoryMiB: 4096
          numCPUs: 2
    - name: security
      value:
        fileIntegrityMonitoring:
          enabled: false
        imagePolicy:
          pullAlways: false
          webhook:
            enabled: false
            spec:
              allowTTL: 50
              defaultAllow: true
              denyTTL: 60
              retryBackoff: 500
        kubeletOptions:
          eventQPS: 50
          streamConnectionIdleTimeout: 4h0m0s
        systemCryptoPolicy: default
    version: v1.26.5+vmware.2-tkg.1
    workers:
      machineDeployments:
      - class: tkg-worker
        metadata:
          annotations:
            run.tanzu.vmware.com/resolve-os-image: image-type=ova,os-name=photon
        name: md-0
        replicas: 1
      - class: tkg-worker
        metadata:
          annotations:
            run.tanzu.vmware.com/resolve-os-image: image-type=ova,os-name=photon
        name: md-1
        replicas: 1
      - class: tkg-worker
        metadata:
          annotations:
            run.tanzu.vmware.com/resolve-os-image: image-type=ova,os-name=photon
        name: md-2
        replicas: 1

````

#### The above is a guide I simply copied the mgmt YAML file and made the appropriate edits, of course the above will not work as we need TLS thumbprints, etc. Also this is very important, you must remove the management role label or the cluster creation will fail.


```TKG 2.3 tiny single node cluster(s)```

````
apiVersion: v1
kind: Secret
metadata:
  annotations:
    tkg.tanzu.vmware.com/addon-type: authentication/pinniped
  labels:
    clusterctl.cluster.x-k8s.io/move: ""
    tkg.tanzu.vmware.com/addon-name: pinniped
    tkg.tanzu.vmware.com/cluster-name: workload-tiny-kv-1 #this must match everywhere
  name: workload-tiny-kv-1-pinniped-package
  namespace: default
stringData:
  values.yaml: |
    infrastructure_provider: vsphere
    tkg_cluster_role: workload
    identity_management_type: none
type: clusterbootstrap-secret
---
apiVersion: cpi.tanzu.vmware.com/v1alpha1
kind: VSphereCPIConfig
metadata:
  name: workload-tiny-kv-1
  namespace: default
spec:
  vsphereCPI:
    mode: vsphereCPI
    tlsCipherSuites: TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
    vmNetwork:
      excludeExternalSubnetCidr: 192.168.181.201/32
      excludeInternalSubnetCidr: 192.168.181.201/32
---
apiVersion: csi.tanzu.vmware.com/v1alpha1
kind: VSphereCSIConfig
metadata:
  name: workload-tiny-kv-1
  namespace: default
spec:
  vsphereCSI:
    config:
      datacenter: /dc-01
      httpProxy: ""
      httpsProxy: ""
      insecureFlag: false
      noProxy: ""
      region: null
      tlsThumbprint: 80:25:43:3B:6E:EE:8E:7B:E9:0F:6C:5F #Unique to your env
      useTopologyCategories: false
      zone: null
    mode: vsphereCSI
---
apiVersion: run.tanzu.vmware.com/v1alpha3
kind: ClusterBootstrap
metadata:
  annotations:
    tkg.tanzu.vmware.com/add-missing-fields-from-tkr: v1.26.5+vmware.1-tiny.2
  name: workload-tiny-kv-1
  namespace: default
spec:
  additionalPackages:
  - refName: metrics-server*
  - refName: secretgen-controller*
  - refName: pinniped*
  cpi:
    refName: vsphere-cpi*
    valuesFrom:
      providerRef:
        apiGroup: cpi.tanzu.vmware.com
        kind: VSphereCPIConfig
        name: workload-tiny-kv-1
  csi:
    refName: vsphere-csi*
    valuesFrom:
      providerRef:
        apiGroup: csi.tanzu.vmware.com
        kind: VSphereCSIConfig
        name: workload-tiny-kv-1
  kapp:
    refName: kapp-controller*
---
apiVersion: v1
kind: Secret
metadata:
  name: workload-tiny-kv-1
  namespace: default
stringData:
  password: mysecretpassword
  username: administrator@vsphere.local
---
apiVersion: cluster.x-k8s.io/v1beta1
kind: Cluster
metadata:
  annotations:
    osInfo: photon,3,amd64
    tkg.tanzu.vmware.com/cluster-controlplane-endpoint: 192.168.181.201
    tkg/plan: dev
    run.tanzu.vmware.com/resolve-tkr: 'tkr.tanzu.vmware.com/tiny'
  labels:
    tkg.tanzu.vmware.com/cluster-name: workload-tiny-kv-1
  name: workload-tiny-kv-1
  namespace: default
spec:
  clusterNetwork:
    pods:
      cidrBlocks:
      - 100.96.0.0/11
    services:
      cidrBlocks:
      - 100.64.0.0/13
  topology:
    class: tkg-vsphere-default-v1.1.0
    controlPlane:
      metadata:
        annotations:
          run.tanzu.vmware.com/resolve-os-image: image-type=ova,os-name=photon
      replicas: 1
    variables:
    - name: cni
      value: antrea
    - name: controlPlaneCertificateRotation
      value:
        activate: true
        daysBefore: 90
    - name: auditLogging
      value:
        enabled: true
    - name: podSecurityStandard
      value:
        audit: restricted
        deactivated: false
        warn: restricted
    - name: apiServerEndpoint
      value: 192.168.181.201
    - name: aviAPIServerHAProvider
      value: false
    - name: vcenter
      value:
        cloneMode: fullClone
        datacenter: /dc-01
        datastore: /dc-01/datastore/truenas-iscsi-01
        folder: /dc-01/vm/tkg-vsphere-workload
        network: /dc-01/network/vDS-TKG-WKLK181
        resourcePool: /dc-01/host/cluster-01/Resources/tkg-singlenodes
        server: 192.168.99.20
        storagePolicyID: ""
        template: /dc-01/vm/TKGm-templates/photon-3-kube-v1.26.5+vmware.1-tiny.2
        tlsThumbprint: 80:25:43:3B:6E:EE:8E:7B:E9:0F:6C:5F:5E:92:E1:16 #Unique to your env
    - name: user
      value:
        sshAuthorizedKeys:
        - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEouXZ/n3+vqAAhyJBztmPFs8tuJRBB37mXFraUDHD/n #your ssh public key
    - name: controlPlane
      value:
        machine:
          diskGiB: 200
          memoryMiB: 16384
          numCPUs: 8
    - name: controlPlaneTaint
      value: false

    #- name: worker
      #value:
        #machine:
          #diskGiB: 80
          #memoryMiB: 4096
          #numCPUs: 2
    - name: security
      value:
        fileIntegrityMonitoring:
          enabled: false
        imagePolicy:
          pullAlways: false
          webhook:
            enabled: false
            spec:
              allowTTL: 50
              defaultAllow: true
              denyTTL: 60
              retryBackoff: 500
        kubeletOptions:
          eventQPS: 50
          streamConnectionIdleTimeout: 4h0m0s
        systemCryptoPolicy: default
    version: v1.26.5+vmware.1-tiny.2
    #workers:
      #machineDeployments:
      #- class: tkg-worker
        #metadata:
          #annotations:
            #run.tanzu.vmware.com/resolve-os-image: image-type=ova,os-name=photon
        #name: md-0
        #replicas: 1
      #- class: tkg-worker
        #metadata:
          #annotations:
            #run.tanzu.vmware.com/resolve-os-image: image-type=ova,os-name=photon
        #name: md-1
        #replicas: 1
      #- class: tkg-worker
        #metadata:
          #annotations:
            #run.tanzu.vmware.com/resolve-os-image: image-type=ova,os-name=photon
        #name: md-2
        #replicas: 1

````

```tkg 2.3 node ipam cluster```

````

apiVersion: v1
kind: Secret
metadata:
  annotations:
    tkg.tanzu.vmware.com/addon-type: authentication/pinniped
  labels:
    clusterctl.cluster.x-k8s.io/move: ""
    tkg.tanzu.vmware.com/addon-name: pinniped
    tkg.tanzu.vmware.com/cluster-name: workload-kv-nodeipam
  name: workload-kv-nodeipam-pinniped-package
  namespace: default
stringData:
  values.yaml: |
    infrastructure_provider: vsphere
    tkg_cluster_role: workload
    identity_management_type: none
type: clusterbootstrap-secret
---
apiVersion: cpi.tanzu.vmware.com/v1alpha1
kind: VSphereCPIConfig
metadata:
  name: workload-kv-nodeipam
  namespace: default
spec:
  vsphereCPI:
    mode: vsphereCPI
    tlsCipherSuites: TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
    vmNetwork:
      excludeExternalSubnetCidr: 192.168.181.205/32
      excludeInternalSubnetCidr: 192.168.181.205/32
---
apiVersion: csi.tanzu.vmware.com/v1alpha1
kind: VSphereCSIConfig
metadata:
  name: workload-kv-nodeipam
  namespace: default
spec:
  vsphereCSI:
    config:
      datacenter: /dc-01
      httpProxy: ""
      httpsProxy: ""
      insecureFlag: false
      noProxy: ""
      region: null
      tlsThumbprint: 80:25:43:3B:6E:EE:8E:7B:E9:0F:6C:5F:5E:92:E1 #this is unique for your env
      useTopologyCategories: false
      zone: null
    mode: vsphereCSI
---
apiVersion: run.tanzu.vmware.com/v1alpha3
kind: ClusterBootstrap
metadata:
  annotations:
    tkg.tanzu.vmware.com/add-missing-fields-from-tkr: v1.26.5---vmware.2-tkg.1
  name: workload-kv-nodeipam
  namespace: default
spec:
  additionalPackages:
  - refName: metrics-server*
  - refName: secretgen-controller*
  - refName: pinniped*
  cpi:
    refName: vsphere-cpi*
    valuesFrom:
      providerRef:
        apiGroup: cpi.tanzu.vmware.com
        kind: VSphereCPIConfig
        name: workload-kv-nodeipam
  csi:
    refName: vsphere-csi*
    valuesFrom:
      providerRef:
        apiGroup: csi.tanzu.vmware.com
        kind: VSphereCSIConfig
        name: workload-kv-nodeipam
  kapp:
    refName: kapp-controller*
---
apiVersion: v1
kind: Secret
metadata:
  name: workload-kv-nodeipam
  namespace: default
stringData:
  password: mypassword
  username: administrator@vsphere.local
---
apiVersion: cluster.x-k8s.io/v1beta1
kind: Cluster
metadata:
  annotations:
    osInfo: photon,3,amd64
    tkg.tanzu.vmware.com/cluster-controlplane-endpoint: 192.168.181.205
    tkg/plan: prod
  labels:
    tkg.tanzu.vmware.com/cluster-name: workload-kv-nodeipam
  name: workload-kv-nodeipam
  namespace: default
spec:
  clusterNetwork:
    pods:
      cidrBlocks:
      - 100.96.0.0/11
    services:
      cidrBlocks:
      - 100.64.0.0/13
  topology:
    class: tkg-vsphere-default-v1.1.0
    controlPlane:
      metadata:
        annotations:
          run.tanzu.vmware.com/resolve-os-image: image-type=ova,os-name=photon
      replicas: 3
    variables:
    - name: cni
      value: antrea
    - name: controlPlaneCertificateRotation
      value:
        activate: true
        daysBefore: 90
    - name: auditLogging
      value:
        enabled: true
    - name: podSecurityStandard
      value:
        audit: restricted
        deactivated: false
        warn: restricted
    - name: network
      value:
        addressesFromPools:
        - apiGroup: ipam.cluster.x-k8s.io
          kind: InClusterIPPool
          name: inclusterippool
    - name: apiServerEndpoint
      value: 192.168.181.205
    - name: aviAPIServerHAProvider
      value: false
    - name: vcenter
      value:
        cloneMode: fullClone
        datacenter: /dc-01
        datastore: /dc-01/datastore/truenas-iscsi-01
        folder: /dc-01/vm/tkg-vsphere-workload
        network: /dc-01/network/vDS-TKG-WKLK181
        resourcePool: /dc-01/host/cluster-01/Resources/tkg-workloads
        server: 192.168.99.20
        storagePolicyID: ""
        template: /dc-01/vm/TKGm-templates/photon-3-kube-v1.26.5+vmware.2
        tlsThumbprint: 80:25:43:3B:6E:EE:8E:7B:E9:0F:6C:5F:5E #this is unique for your env
    - name: user
      value:
        sshAuthorizedKeys:
        - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEouXZ/n3+vqAAhyJBztmPFs8tuJRBB37mXFraUDHD/n
    - name: controlPlane
      value:
        machine:
          diskGiB: 20
          memoryMiB: 4096
          numCPUs: 2
        network:
          nameservers: [192.168.99.100,8.8.8.8]
    - name: worker
      value:
        machine:
          diskGiB: 80
          memoryMiB: 4096
          numCPUs: 2
        network:
          nameservers: [192.168.99.100,8.8.8.8]
    - name: security
      value:
        fileIntegrityMonitoring:
          enabled: false
        imagePolicy:
          pullAlways: false
          webhook:
            enabled: false
            spec:
              allowTTL: 50
              defaultAllow: true
              denyTTL: 60
              retryBackoff: 500
        kubeletOptions:
          eventQPS: 50
          streamConnectionIdleTimeout: 4h0m0s
        systemCryptoPolicy: default
    version: v1.26.5+vmware.2-tkg.1
    workers:
      machineDeployments:
      - class: tkg-worker
        metadata:
          annotations:
            run.tanzu.vmware.com/resolve-os-image: image-type=ova,os-name=photon
        name: md-0
        replicas: 1
      - class: tkg-worker
        metadata:
          annotations:
            run.tanzu.vmware.com/resolve-os-image: image-type=ova,os-name=photon
        name: md-1
        replicas: 1
      - class: tkg-worker
        metadata:
          annotations:
            run.tanzu.vmware.com/resolve-os-image: image-type=ova,os-name=photon
        name: md-2
        replicas: 1

````

```node ipam Ubuntu cluster```

````
apiVersion: v1
kind: Secret
metadata:
  annotations:
    tkg.tanzu.vmware.com/addon-type: authentication/pinniped
  labels:
    clusterctl.cluster.x-k8s.io/move: ""
    tkg.tanzu.vmware.com/addon-name: pinniped
    tkg.tanzu.vmware.com/cluster-name: cluster-kv-nodeipam-1 #custom per your env
  name: cluster-kv-nodeipam-1-pinniped-package #custom per your env
  namespace: default
stringData:
  values.yaml: |
    infrastructure_provider: vsphere
    tkg_cluster_role: workload
    identity_management_type: none
type: clusterbootstrap-secret
---
apiVersion: cpi.tanzu.vmware.com/v1alpha1
kind: VSphereCPIConfig
metadata:
  name: cluster-kv-nodeipam-1
  namespace: default
spec:
  vsphereCPI:
    mode: vsphereCPI
    tlsCipherSuites: TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
    vmNetwork:
      excludeExternalSubnetCidr: 192.168.181.200/32 #custom per your env
      excludeInternalSubnetCidr: 192.168.181.200/32 #custom per your env
---
apiVersion: csi.tanzu.vmware.com/v1alpha1
kind: VSphereCSIConfig
metadata:
  name: cluster-kv-nodeipam-1 #custom per your env
  namespace: default
spec:
  vsphereCSI:
    config:
      datacenter: /dc-01
      httpProxy: ""
      httpsProxy: ""
      insecureFlag: false
      noProxy: ""
      region: null
      tlsThumbprint: 80:25:43:3B:6E:EE:8E:7B:E9:0F:6C #custom per your env
      useTopologyCategories: false
      zone: null
    mode: vsphereCSI
---
apiVersion: run.tanzu.vmware.com/v1alpha3
kind: ClusterBootstrap
metadata:
  annotations:
    tkg.tanzu.vmware.com/add-missing-fields-from-tkr: v1.26.5---vmware.2-tkg.1
  name: cluster-kv-nodeipam-1
  namespace: default
spec:
  additionalPackages:
  - refName: metrics-server*
  - refName: secretgen-controller*
  - refName: pinniped*
  cpi:
    refName: vsphere-cpi*
    valuesFrom:
      providerRef:
        apiGroup: cpi.tanzu.vmware.com
        kind: VSphereCPIConfig
        name: cluster-kv-nodeipam-1
  csi:
    refName: vsphere-csi*
    valuesFrom:
      providerRef:
        apiGroup: csi.tanzu.vmware.com
        kind: VSphereCSIConfig
        name: cluster-kv-nodeipam-1
  kapp:
    refName: kapp-controller*
---
apiVersion: v1
kind: Secret
metadata:
  name: cluster-kv-nodeipam-1 #custom per your env
  namespace: default
stringData:
  password: mysecretpass #custom per your env
  username: administrator@vsphere.local
---
apiVersion: cluster.x-k8s.io/v1beta1
kind: Cluster
metadata:
  annotations:
    osInfo: ubuntu,20.04,amd64
    tkg.tanzu.vmware.com/cluster-controlplane-endpoint: 192.168.181.200
    tkg/plan: prod
  labels:
    #cluster-role.tkg.tanzu.vmware.com/management: "" this has to go this is not a mgmt cluster
    tkg.tanzu.vmware.com/cluster-name: cluster-kv-nodeipam-1 #custom per your env
  name: cluster-kv-nodeipam-1
  namespace: default
spec:
  clusterNetwork:
    pods:
      cidrBlocks:
      - 100.96.0.0/11
    services:
      cidrBlocks:
      - 100.64.0.0/13
  topology:
    class: tkg-vsphere-default-v1.1.0
    controlPlane:
      metadata:
        annotations:
          run.tanzu.vmware.com/resolve-os-image: image-type=ova,os-name=ubuntu
      replicas: 3
    variables:
    - name: network
      value:
        addressesFromPools:
        - apiGroup: ipam.cluster.x-k8s.io
          kind: InClusterIPPool
          name: cluster-kv-nodeipam-1 #custom per your env
    - name: cni
      value: antrea
    - name: controlPlaneCertificateRotation
      value:
        activate: true
        daysBefore: 90
    - name: auditLogging
      value:
        enabled: true
    - name: podSecurityStandard
      value:
        audit: restricted
        deactivated: false
        warn: restricted
    - name: apiServerEndpoint
      value: 192.168.181.200
    - name: aviAPIServerHAProvider
      value: false
    - name: vcenter
      value:
        cloneMode: fullClone
        datacenter: /dc-01
        datastore: /dc-01/datastore/truenas-iscsi-01
        folder: /dc-01/vm/tkg-vsphere-workload
        network: /dc-01/network/vDS-TKG-WKLK181
        resourcePool: /dc-01/host/cluster-01/Resources/tkg-workloads
        server: 192.168.99.20
        storagePolicyID: ""
        tlsThumbprint: 80:25:43:3B:6E:EE:8E:7B:E9:0F #custom per your env
    - name: user
      value:
        sshAuthorizedKeys:
        - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEouXZ/n3+vqAAhyJBztmPFs8tuJRBB37mXFraUDHD/n #custom per your env
    - name: controlPlane
      value:
        machine:
          diskGiB: 40
          memoryMiB: 8192
          numCPUs: 2
        network:
          nameservers:
          - 192.168.99.100
    - name: worker
      value:
        machine:
          diskGiB: 80
          memoryMiB: 8192
          numCPUs: 2
        network:
          nameservers:
          - 192.168.99.100
    - name: security
      value:
        fileIntegrityMonitoring:
          enabled: false
        imagePolicy:
          pullAlways: false
          webhook:
            enabled: false
            spec:
              allowTTL: 50
              defaultAllow: true
              denyTTL: 60
              retryBackoff: 500
        kubeletOptions:
          eventQPS: 50
          streamConnectionIdleTimeout: 4h0m0s
        systemCryptoPolicy: default
    version: v1.26.5+vmware.2-tkg.1
    workers:
      machineDeployments:
      - class: tkg-worker
        metadata:
          annotations:
            run.tanzu.vmware.com/resolve-os-image: image-type=ova,os-name=ubuntu
        name: md-0
        replicas: 1
      - class: tkg-worker
        metadata:
          annotations:
            run.tanzu.vmware.com/resolve-os-image: image-type=ova,os-name=ubuntu
        name: md-1
        replicas: 1
      - class: tkg-worker
        metadata:
          annotations:
            run.tanzu.vmware.com/resolve-os-image: image-type=ova,os-name=ubuntu
        name: md-2
        replicas: 1

````

```tkg 2.3 nodeipam mgmt cluster```

````

AVI_CA_DATA_B64: ""
AVI_CLOUD_NAME: ""
AVI_CONTROL_PLANE_HA_PROVIDER: "false"
AVI_CONTROL_PLANE_NETWORK: ""
AVI_CONTROL_PLANE_NETWORK_CIDR: ""
AVI_CONTROLLER: ""
AVI_DATA_NETWORK: ""
AVI_DATA_NETWORK_CIDR: ""
AVI_ENABLE: "false"
AVI_LABELS: ""
AVI_MANAGEMENT_CLUSTER_CONTROL_PLANE_VIP_NETWORK_CIDR: ""
AVI_MANAGEMENT_CLUSTER_CONTROL_PLANE_VIP_NETWORK_NAME: ""
AVI_MANAGEMENT_CLUSTER_SERVICE_ENGINE_GROUP: ""
AVI_MANAGEMENT_CLUSTER_VIP_NETWORK_CIDR: ""
AVI_MANAGEMENT_CLUSTER_VIP_NETWORK_NAME: ""
AVI_PASSWORD: ""
AVI_SERVICE_ENGINE_GROUP: ""
AVI_USERNAME: ""
CLUSTER_ANNOTATIONS: 'description:,location:'
CLUSTER_CIDR: 100.96.0.0/11
CLUSTER_NAME: mgmt-kv-nodeipam-1
CLUSTER_PLAN: prod
ENABLE_AUDIT_LOGGING: "true"
ENABLE_CEIP_PARTICIPATION: "false"
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
OS_NAME: ubuntu
OS_VERSION: "20.04"
SERVICE_CIDR: 100.64.0.0/13
TKG_HTTP_PROXY_ENABLED: "false"
VSPHERE_CONTROL_PLANE_DISK_GIB: "40"
VSPHERE_CONTROL_PLANE_ENDPOINT: 192.168.180.200
VSPHERE_CONTROL_PLANE_MEM_MIB: "8192"
VSPHERE_CONTROL_PLANE_NUM_CPUS: "2"
VSPHERE_DATACENTER: /dc-01
VSPHERE_DATASTORE: /dc-01/datastore/truenas-iscsi-01
VSPHERE_FOLDER: /dc-01/vm/tkg-vsphere-tkg-mgmt
VSPHERE_INSECURE: "false"
VSPHERE_NETWORK: /dc-01/network/vDS-TKG-MGMTWKLK180
VSPHERE_PASSWORD: <encoded:mmmmmmmmmmm>  #custom to your env
VSPHERE_RESOURCE_POOL: /dc-01/host/cluster-01/Resources/tkgm-mgmt
VSPHERE_SERVER: 192.168.99.20
VSPHERE_SSH_AUTHORIZED_KEY: ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEouXZ/n3+vqAAhyJBztmPFs8tuJRBB37mXFraUDHD/n #custom to your env
VSPHERE_TLS_THUMBPRINT: 80:25:43:3B:6E:EE:8E:7B:E9:0F:6C:5F #custom to you env
VSPHERE_USERNAME: administrator@vsphere.local
VSPHERE_WORKER_DISK_GIB: "40"
VSPHERE_WORKER_MEM_MIB: "8192"
VSPHERE_WORKER_NUM_CPUS: "2"
WORKER_ROLLOUT_STRATEGY: ""
MANAGEMENT_NODE_IPAM_IP_POOL_GATEWAY: "192.168.180.1"
MANAGEMENT_NODE_IPAM_IP_POOL_ADDRESSES: "192.168.180.81-192.168.180.120"
MANAGEMENT_NODE_IPAM_IP_POOL_SUBNET_PREFIX: "24"
CONTROL_PLANE_NODE_NAMESERVERS: "192.168.99.100"
WORKER_NODE_NAMESERVERS: "192.168.99.100"

````

#### The above uses Ubuntu nodes


```Classy version```

````

apiVersion: v1
kind: Secret
metadata:
  annotations:
    tkg.tanzu.vmware.com/addon-type: authentication/pinniped
  labels:
    clusterctl.cluster.x-k8s.io/move: ""
    tkg.tanzu.vmware.com/addon-name: pinniped
    tkg.tanzu.vmware.com/cluster-name: mgmt-kv-nodeipam-1 #custom to your env
  name: mgmt-kv-nodeipam-1-pinniped-package
  namespace: tkg-system
stringData:
  values.yaml: |
    infrastructure_provider: vsphere
    tkg_cluster_role: workload
    identity_management_type: none
type: clusterbootstrap-secret
---
apiVersion: cpi.tanzu.vmware.com/v1alpha1
kind: VSphereCPIConfig
metadata:
  name: mgmt-kv-nodeipam-1
  namespace: tkg-system
spec:
  vsphereCPI:
    mode: vsphereCPI
    tlsCipherSuites: TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
    vmNetwork:
      excludeExternalSubnetCidr: 192.168.180.200/32 #custom to your env
      excludeInternalSubnetCidr: 192.168.180.200/32 #custom to your env
---
apiVersion: csi.tanzu.vmware.com/v1alpha1
kind: VSphereCSIConfig
metadata:
  name: mgmt-kv-nodeipam-1
  namespace: tkg-system
spec:
  vsphereCSI:
    config:
      datacenter: /dc-01
      httpProxy: ""
      httpsProxy: ""
      insecureFlag: false
      noProxy: ""
      region: null
      tlsThumbprint: 80:25:43:3B:6E:EE:8E:7B #custom to your env
      useTopologyCategories: false
      zone: null
    mode: vsphereCSI
---
apiVersion: run.tanzu.vmware.com/v1alpha3
kind: ClusterBootstrap
metadata:
  annotations:
    tkg.tanzu.vmware.com/add-missing-fields-from-tkr: v1.26.5---vmware.2-tkg.1
  name: mgmt-kv-nodeipam-1
  namespace: tkg-system
spec:
  additionalPackages:
  - refName: metrics-server*
  - refName: secretgen-controller*
  - refName: pinniped*
  cpi:
    refName: vsphere-cpi*
    valuesFrom:
      providerRef:
        apiGroup: cpi.tanzu.vmware.com
        kind: VSphereCPIConfig
        name: mgmt-kv-nodeipam-1
  csi:
    refName: vsphere-csi*
    valuesFrom:
      providerRef:
        apiGroup: csi.tanzu.vmware.com
        kind: VSphereCSIConfig
        name: mgmt-kv-nodeipam-1
  kapp:
    refName: kapp-controller*
---
apiVersion: v1
kind: Secret
metadata:
  name: mgmt-kv-nodeipam-1
  namespace: tkg-system
stringData:
  password: mysecreatpass #custom to your env
  username: administrator@vsphere.local
---
apiVersion: cluster.x-k8s.io/v1beta1
kind: Cluster
metadata:
  annotations:
    osInfo: ubuntu,20.04,amd64
    tkg.tanzu.vmware.com/cluster-controlplane-endpoint: 192.168.180.200  #custom to your env
    tkg/plan: prod
  labels:
    cluster-role.tkg.tanzu.vmware.com/management: ""
    tkg.tanzu.vmware.com/cluster-name: mgmt-kv-nodeipam-1  #custom to your env
  name: mgmt-kv-nodeipam-1
  namespace: tkg-system
spec:
  clusterNetwork:
    pods:
      cidrBlocks:
      - 100.96.0.0/11
    services:
      cidrBlocks:
      - 100.64.0.0/13
  topology:
    class: tkg-vsphere-default-v1.1.0
    controlPlane:
      metadata:
        annotations:
          run.tanzu.vmware.com/resolve-os-image: image-type=ova,os-name=ubuntu
      replicas: 3
    variables:
    - name: network
      value:
        addressesFromPools:
        - apiGroup: ipam.cluster.x-k8s.io
          kind: InClusterIPPool
          name: mgmt-kv-nodeipam-1
    - name: cni
      value: antrea
    - name: controlPlaneCertificateRotation
      value:
        activate: true
        daysBefore: 90
    - name: auditLogging
      value:
        enabled: true
    - name: podSecurityStandard
      value:
        audit: restricted
        deactivated: false
        warn: restricted
    - name: apiServerEndpoint
      value: 192.168.180.200
    - name: aviAPIServerHAProvider
      value: false
    - name: vcenter
      value:
        cloneMode: fullClone
        datacenter: /dc-01
        datastore: /dc-01/datastore/truenas-iscsi-01
        folder: /dc-01/vm/tkg-vsphere-tkg-mgmt
        network: /dc-01/network/vDS-TKG-MGMTWKLK180
        resourcePool: /dc-01/host/cluster-01/Resources/tkgm-mgmt
        server: 192.168.99.20
        storagePolicyID: ""
        tlsThumbprint: 80:25:43:3B:6E:EE:8E:7B:E9:0F #custom to your env
    - name: user
      value:
        sshAuthorizedKeys:
        - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEouXZ/n3+vqAAhyJBztmPFs8tuJRBB37mXFraUDHD/n #custom to your env
    - name: controlPlane
      value:
        machine:
          diskGiB: 40
          memoryMiB: 8192
          numCPUs: 2
        network:
          nameservers:
          - 192.168.99.100
    - name: worker
      value:
        machine:
          diskGiB: 40
          memoryMiB: 8192
          numCPUs: 2
        network:
          nameservers:
          - 192.168.99.100
    - name: security
      value:
        fileIntegrityMonitoring:
          enabled: false
        imagePolicy:
          pullAlways: false
          webhook:
            enabled: false
            spec:
              allowTTL: 50
              defaultAllow: true
              denyTTL: 60
              retryBackoff: 500
        kubeletOptions:
          eventQPS: 50
          streamConnectionIdleTimeout: 4h0m0s
        systemCryptoPolicy: default
    version: v1.26.5+vmware.2-tkg.1
    workers:
      machineDeployments:
      - class: tkg-worker
        metadata:
          annotations:
            run.tanzu.vmware.com/resolve-os-image: image-type=ova,os-name=ubuntu
        name: md-0
        replicas: 1
      - class: tkg-worker
        metadata:
          annotations:
            run.tanzu.vmware.com/resolve-os-image: image-type=ova,os-name=ubuntu
        name: md-1
        replicas: 1
      - class: tkg-worker
        metadata:
          annotations:
            run.tanzu.vmware.com/resolve-os-image: image-type=ova,os-name=ubuntu
        name: md-2
        replicas: 1
---
apiVersion: ipam.cluster.x-k8s.io/v1alpha2
kind: InClusterIPPool
metadata:
  annotations:
    ipam.cluster.x-k8s.io/skip-validate-delete-webhook: ""
  labels:
    clusterctl.cluster.x-k8s.io/move-hierarchy: ""
  name: mgmt-kv-nodeipam-1
  namespace: tkg-system
spec:
  addresses:
  - 192.168.180.81-192.168.180.120
  gateway: 192.168.180.1
  prefix: 24

````

````

AVI_CA_DATA_B64: ""
AVI_CLOUD_NAME: ""
AVI_CONTROL_PLANE_HA_PROVIDER: "false"
AVI_CONTROL_PLANE_NETWORK: ""
AVI_CONTROL_PLANE_NETWORK_CIDR: ""
AVI_CONTROLLER: ""
AVI_DATA_NETWORK: ""
AVI_DATA_NETWORK_CIDR: ""
AVI_ENABLE: "false"
AVI_LABELS: ""
AVI_MANAGEMENT_CLUSTER_CONTROL_PLANE_VIP_NETWORK_CIDR: ""
AVI_MANAGEMENT_CLUSTER_CONTROL_PLANE_VIP_NETWORK_NAME: ""
AVI_MANAGEMENT_CLUSTER_SERVICE_ENGINE_GROUP: ""
AVI_MANAGEMENT_CLUSTER_VIP_NETWORK_CIDR: ""
AVI_MANAGEMENT_CLUSTER_VIP_NETWORK_NAME: ""
AVI_PASSWORD: ""
AVI_SERVICE_ENGINE_GROUP: ""
AVI_USERNAME: ""
CLUSTER_ANNOTATIONS: 'description:,location:'
CLUSTER_CIDR: 100.96.0.0/11
CLUSTER_NAME: mgmt-kv-nodeipam-1
CLUSTER_PLAN: prod
ENABLE_AUDIT_LOGGING: "true"
ENABLE_CEIP_PARTICIPATION: "false"
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
VSPHERE_CONTROL_PLANE_DISK_GIB: "40"
VSPHERE_CONTROL_PLANE_ENDPOINT: 192.168.180.200
VSPHERE_CONTROL_PLANE_MEM_MIB: "8192"
VSPHERE_CONTROL_PLANE_NUM_CPUS: "2"
VSPHERE_DATACENTER: /dc-01
VSPHERE_DATASTORE: /dc-01/datastore/truenas-iscsi-01
VSPHERE_FOLDER: /dc-01/vm/tkg-vsphere-tkg-mgmt
VSPHERE_INSECURE: "false"
VSPHERE_NETWORK: /dc-01/network/vDS-TKG-MGMTWKLK180
VSPHERE_PASSWORD: <encoded:mmmmmmmmmmmmmmmmmmmmm> #custom to you env
VSPHERE_RESOURCE_POOL: /dc-01/host/cluster-01/Resources/tkgm-mgmt
VSPHERE_SERVER: 192.168.99.20
VSPHERE_SSH_AUTHORIZED_KEY: ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEouXZ/n3+vqAAhyJBztmPFs8tuJRBB37mXFraUDHD/n #custom to you env
VSPHERE_TLS_THUMBPRINT: 80:25:43:3B:6E:EE:8E:7B:E9:0F #custom to you env
VSPHERE_USERNAME: administrator@vsphere.local
VSPHERE_WORKER_DISK_GIB: "40"
VSPHERE_WORKER_MEM_MIB: "8192"
VSPHERE_WORKER_NUM_CPUS: "2"
WORKER_ROLLOUT_STRATEGY: ""
MANAGEMENT_NODE_IPAM_IP_POOL_GATEWAY: "192.168.180.1"
MANAGEMENT_NODE_IPAM_IP_POOL_ADDRESSES: "192.168.180.81-192.168.180.120"
MANAGEMENT_NODE_IPAM_IP_POOL_SUBNET_PREFIX: "24"
CONTROL_PLANE_NODE_NAMESERVERS: "192.168.99.100"
WORKER_NODE_NAMESERVERS: "192.168.99.100"

````

#### The above uses photon

```inclusteripam pool```


````
---
apiVersion: ipam.cluster.x-k8s.io/v1alpha2
kind: InClusterIPPool
metadata:
  annotations:
    ipam.cluster.x-k8s.io/skip-validate-delete-webhook: ""
  labels:
    clusterctl.cluster.x-k8s.io/move-hierarchy: ""
  name: cluster-kv-nodeipam-1
  namespace: default
spec:
  addresses:
  - 192.168.181.81-192.168.181.120
  gateway: 192.168.181.1
  prefix: 24

````

#### The above has to be applied before you create your workload cluster(s)



```SSH into nodes```

````
ssh -i /path/to/privatekey capv@NODE_IP

````
