### Arcas(Service-Installer) notes

#### Enable Workload Control Plane (WCP) or configure Namespaces and deploy Workload clusters

#### Some initial setup, create a CL and name it below, don't select download immediately, set it to when needed

````
CL Name: SubscribedAutomation-Lib

Subscription URL: https://wp-content.vmware.com/v2/latest/lib.json

````

[Github](https://github.com/vmware-tanzu/service-installer-for-vmware-tanzu)

````
arcas --env vsphere --file vsphere-dvs-tkgm.json --avi_configuration --verbose

arcas --env vsphere --file vsphere-dvs-tkgm.json --tkg_mgmt_configuration --verbose

arcas --env vsphere --file vsphere-dvs-tkgm.json --tkg_mgmt_configuration --shared_service_configuration --verbose

arcas --env vsphere --file vsphere-dvs-tkgm.json --workload_preconfig --workload_deploy --verbose



#tkgs

arcas --env vsphere --file vsphere-dvs-tkgs-wcp.json --avi_configuration --avi_wcp_configuration --enable_wcp --verbose

````