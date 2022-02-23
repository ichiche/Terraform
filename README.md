# Contributing

```
All scripts in repository are used for DevTest only.
```

# Prerequisites and Version

| Item | Name | Version | Installation | 
| - | - | - | - | 
| 1 | Binary | 1.1.6 | https://www.terraform.io/downloads | 
| 2 | azurerm | 2.97.0 | https://registry.terraform.io/providers/hashicorp/azurerm/2.97.0 |

# Permission Delegation

> :memo: **Azure-Run-As-Account** is the account used by Terraform for executing task in Azure

> :bulb: Least privilege of provisioning

For role assignment during provisioning, grant **User Access Administrator** to **Azure-Run-As-Account** on below resources

- AKS Virtual Network (Resource Level)
- Private DNS Zone (Resource Level)
- Container Registry (Resource Level)

---

For resource provisioning, grant **Contributor** to **Azure-Run-As-Account** on below resources

Any of the following apply:

**Approach 1** (Recommended)

  - AKS Resource Group (Precreated)
  - AKS Virtual Network (Resource Level)
  - Private DNS Zone (Resource Level)
  - Log Analytics Workspace (Resource Level)

**Approach 2**

  - Subscription Level 

# Azure Kubernetes Service (AKS)

### Private DNS Zone for AKS

https://docs.microsoft.com/en-us/azure/aks/private-clusters#configure-private-dns-zone

### Outbound (Egress) Control

1. The outbound (egress) routing method which should be used for Kubernetes Cluster. 
1. Supported values are 'loadBalancer' and 'userDefinedRouting'. 
1. If 'userDefinedRouting' is used, Default route 0.0.0.0/0 from route table must be associated with subnet prior to AKS creation.
1. Default route 0.0.0.0/0 must have the next hops of VirtualAppliance or VirtualNetworkGateway only.
1. If AKS and VirtualAppliance / VirtualNetworkGateway locate in different Virtual Networks, those Virtual Networks must be peered prior to AKS creation.

https://docs.microsoft.com/en-us/azure/aks/egress-outboundtype

https://docs.microsoft.com/en-us/azure/aks/limit-egress-traffic#restrict-egress-traffic-using-azure-firewall

### Integrate with Azure Container Registry

This role is assigned to the kubelet managed identity

https://docs.microsoft.com/en-us/azure/aks/cluster-container-registry-integration

### Azure CLI Command

https://docs.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest#az-aks-create

### Parameter

> **Virtual Network and Subnet**

At this time the subnet must be the same for all node pools in the cluster

Add a node pool with a unique subnet is still preview feature with :warning: **Limitation**

https://docs.microsoft.com/en-us/azure/aks/use-multiple-node-pools#add-a-node-pool-with-a-unique-subnet-preview

> **Azure CNI**

https://docs.microsoft.com/en-us/azure/aks/configure-azure-cni

> **DNS prefix**

Used with hosted Kubernetes API server FQDN for both public and private AKS Cluster

If not specified, generate a hostname using the managed cluster and resource group names

https://azure.github.io/PSRule.Rules.Azure/en/rules/Azure.AKS.DNSPrefix/

> **Transparent Mode** 

Default from v1.2.0

https://docs.microsoft.com/en-us/azure/aks/faq#what-is-azure-cni-transparent-mode-vs-bridge-mode

> **Network Policy**

Supported configurations are None, Azure and Calico

https://docs.microsoft.com/en-us/azure/aks/use-network-policies#network-policy-options-in-aks

> **Container Insight**

https://docs.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-onboard

> **Host-based encryption**

```PowerShell
# Verify EncryptionAtHost feature is registered
az feature show --namespace "Microsoft.Compute" --name "EncryptionAtHost"

# Register EncryptionAtHost feature
az feature register --namespace "Microsoft.Compute" --name "EncryptionAtHost"
```

https://docs.microsoft.com/en-us/azure/aks/enable-host-encryption

### Issue: Running (0/0 nodes ready) 

https://faultbucket.ca/2021/12/aks-windows-node-problem-after-1-22-upgrade/

### Quick Start

https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough-rm-template

https://docs.microsoft.com/en-us/samples/azure-samples/private-aks-cluster-terraform-devops/private-aks-cluster-terraform-devops/

https://docs.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-tf-and-aks

### FAQ

https://docs.microsoft.com/en-us/azure/aks/faq#can-i-provide-my-own-name-for-the-aks-node-resource-group

# Authentication and Authorization

### **AKS-managed Azure Active Directory integration**

https://docs.microsoft.com/en-us/azure/aks/managed-aad#azure-ad-authentication-overview

### **Azure RBAC for Kubernetes**

https://docs.microsoft.com/en-us/azure/aks/manage-azure-rbac

# Managed Identity

### **All type of Managed Identity for AKS**

https://docs.microsoft.com/en-us/azure/aks/use-managed-identity#summary-of-managed-identities

# Virtual Machine

### Size

https://docs.microsoft.com/en-us/azure/virtual-machines/dv4-dsv4-series

https://docs.microsoft.com/en-us/azure/virtual-machines/dv3-dsv3-series


https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-b-series-burstable

### Ephemeral OS Disk

:warning: **Limitation**

- Selected VM size must has a cache and temp storage larger than node OS disk size

https://docs.microsoft.com/en-us/azure/virtual-machines/ephemeral-os-disks

https://docs.microsoft.com/en-us/azure/aks/cluster-configuration?WT.mc_id=Portal-Microsoft_Azure_Expert#ephemeral-os

# Azure Firewall

- Required outbound network rules and FQDNs for AKS clusters

https://docs.microsoft.com/en-us/azure/aks/limit-egress-traffic#required-outbound-network-rules-and-fqdns-for-aks-clusters

# Private DNS Zone

https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns#azure-services-dns-zone-configuration

# Proximity Placement Group

:warning: **Limitation**

- A proximity placement group can map to at most one availability zone

https://docs.microsoft.com/en-us/azure/aks/reduce-latency-ppg

# Recommended Abbreviation

https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations

# Terraform

### Managed Identity

https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/managed_service_identity

https://registry.terraform.io/modules/bcochofel/aks/azurerm/latest/examples/user-assigned-identity

### Assigns a given Principal (User or Group) to a given Role

https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment

### Private DNZ Zone

https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone

### Azure Kubernetes Service

https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster

### Kubernetes Cluster Node Pool

https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool

### Attaching a Container Registry to a Kubernetes Cluster

https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry#example-usage-attaching-a-container-registry-to-a-kubernetes-cluster


### Issue Log

https://github.com/hashicorp/terraform-provider-azurerm/issues/10193

https://github.com/hashicorp/terraform-provider-azurerm/issues/9379
