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

#### Get the admin context of a cluster

````

tanzu cluster kubeconfig get wkld-1 --admin

````

