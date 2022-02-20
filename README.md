# Contributing

```
All scripts in repository are used for DevTest only.
```

# Prerequisites

| Item | Name | Version | Installation | 
| - | - | - | - | 
| 1 | Binary | 1.1.6 | https://www.terraform.io/downloads | 
| 2 | azurerm | 2.97.0 | https://registry.terraform.io/providers/hashicorp/azurerm/2.97.0 |

# Permission Delegation

- For role assignment during provisioning, grant 'User Access Administrator' to Azure-Run-As-Account used by Terraform on below resources
  - Private DNS Zone
  - Container Registry

- For resource provisioning, grant 'Contributor' to Azure-Run-As-Account used by Terraform on below resources
  - AKS Resource Group (If RG is pre-created) **OR** Subscription Level (If RG is created by Terraform Script)
  - AKS VNet

# Reference

> ### AKS

https://docs.microsoft.com/en-us/azure/aks/configure-azure-cni

https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough-rm-template

https://docs.microsoft.com/en-us/azure/aks/faq#what-is-azure-cni-transparent-mode-vs-bridge-mode

https://docs.microsoft.com/en-us/azure/aks/use-network-policies#network-policy-options-in-aks

https://docs.microsoft.com/en-us/azure/aks/managed-aad#azure-ad-authentication-overview

https://azure.github.io/PSRule.Rules.Azure/en/rules/Azure.AKS.DNSPrefix/

##### Private DNS Zone for AKS

https://docs.microsoft.com/en-us/azure/aks/private-clusters#configure-private-dns-zone

##### Egress Control

https://docs.microsoft.com/en-us/azure/aks/egress-outboundtype

https://docs.microsoft.com/en-us/azure/aks/limit-egress-traffic#restrict-egress-traffic-using-azure-firewall

##### Integrate with Azure Container Registry

https://docs.microsoft.com/en-us/azure/aks/cluster-container-registry-integration

##### Terraform
https://docs.microsoft.com/en-us/samples/azure-samples/private-aks-cluster-terraform-devops/private-aks-cluster-terraform-devops/

https://docs.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-tf-and-aks

https://registry.terraform.io/modules/bcochofel/aks/azurerm/latest/examples/user-assigned-identity

https://github.com/hashicorp/terraform-provider-azurerm/issues/10193

https://github.com/hashicorp/terraform-provider-azurerm/issues/9379

##### Issue: Running (0/0 nodes ready) 

https://faultbucket.ca/2021/12/aks-windows-node-problem-after-1-22-upgrade/

##### FAQ

https://docs.microsoft.com/en-us/azure/aks/faq#can-i-provide-my-own-name-for-the-aks-node-resource-group

---

> ### Managed Identity

https://docs.microsoft.com/en-us/azure/aks/use-managed-identity#summary-of-managed-identities

https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/managed_service_identity

---

> ### VM

##### Size

https://docs.microsoft.com/en-us/azure/virtual-machines/dv4-dsv4-series

https://docs.microsoft.com/en-us/azure/virtual-machines/dv3-dsv3-series


https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-b-series-burstable

##### Ephemeral OS Disk

https://docs.microsoft.com/en-us/azure/virtual-machines/ephemeral-os-disks

https://docs.microsoft.com/en-us/azure/aks/cluster-configuration?WT.mc_id=Portal-Microsoft_Azure_Expert#ephemeral-os

---

> ### Private DNS Zone

https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns#azure-services-dns-zone-configuration

---

> ### Recommended Abbreviation

https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations
