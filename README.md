# Contributing

```
All scripts in repository are used for DevTest only.
```

# Prerequisites

| Item | Name | Version | Installation | 
| - | - | - | - | 
| 1 | Binary | 1.1.6 | https://www.terraform.io/downloads | 
| 2 | azurerm | 2.97.0 | https://registry.terraform.io/providers/hashicorp/azurerm/2.97.0 |

# Permission

Require to assign 'User Access Administrator' to AzureRunAsAccount on below resources for role assignment during provisioning

- AKS VNet
- Private DNS Zone
- Container Registry

# Reference

### AKS
https://docs.microsoft.com/en-us/azure/aks/configure-azure-cni
https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough-rm-template
https://docs.microsoft.com/en-us/azure/aks/faq#what-is-azure-cni-transparent-mode-vs-bridge-mode
https://docs.microsoft.com/en-us/azure/aks/use-network-policies#network-policy-options-in-aks
https://docs.microsoft.com/en-us/azure/aks/managed-aad#azure-ad-authentication-overview
https://azure.github.io/PSRule.Rules.Azure/en/rules/Azure.AKS.DNSPrefix/

#### Egress Control
https://docs.microsoft.com/en-us/azure/aks/egress-outboundtype
https://docs.microsoft.com/en-us/azure/aks/limit-egress-traffic#restrict-egress-traffic-using-azure-firewall

#### Integrate with Azure Container Registry
https://docs.microsoft.com/en-us/azure/aks/cluster-container-registry-integration

#### Terraform
https://docs.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-tf-and-aks

#### Issue: Running (0/0 nodes ready) 
https://faultbucket.ca/2021/12/aks-windows-node-problem-after-1-22-upgrade/

### VM

#### VM Size
https://docs.microsoft.com/en-us/azure/virtual-machines/dv3-dsv3-series
https://docs.microsoft.com/en-us/azure/virtual-machines/dv4-dsv4-series

#### Ephemeral OS Disk
https://docs.microsoft.com/en-us/azure/virtual-machines/ephemeral-os-disks
https://docs.microsoft.com/en-us/azure/aks/cluster-configuration?WT.mc_id=Portal-Microsoft_Azure_Expert#ephemeral-os

### Private DNS Zone
https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns#azure-services-dns-zone-configuration


