# Terraform Script for Basic AKS Cluster

## Prerequisites

Create an Azure AD Group and add a member.

```sh
# Create a new group
group_id=$(az ad group create --display-name "<group-name>" --mail-nickname "<group-name>" | jq -r ".objectId")

# Add a member to the group
member_id=$(az ad user list --upn "<email address>" --query '[0].objectId' --output tsv)
az ad group member add --group "${group_id}" --member-id "${member_id}"
```

To list and remove member:

```sh
# List current members
az ad group member list --group "${group_id}" --query '[].userPrincipalName'

# Remove a member
member_id=$(az ad user list --upn "<email address>" --query '[0].objectId' --output tsv)
az ad group member remove --group "${group_id}" --member-id "${member_id}"
```

## Azure DevOps Pipeline

1. Create a new environment in Azure Pipeline. You can optionally setup an approval, if you want.

2. Create an Azure Pipeline running against this repo with the following variables:

**Terraform Backend Configuration**

| Variable Name | Description |
| --- | --- |
| backendAzureRmSubscriptionId | Azure Subscription ID |
| backendAzureRmTenantId | Azure Tenant ID |
| backendAzureRmClientId | Service Principal ID |
| backendAzureRmClientSecret | Service Principal Secret |
| backendAzureRmResourceGroupName | Resource Group Name |
| backendAzureRmStorageAccountName | Storage Account Name |
| backendAzureRmContainerName | Storage Container Name |
| backendAzureRmKey | Storage Key Name e.g. `terraform.tfstate` |

**AKS Cluster Configuration**

| Variable Name | Description |
| --- | --- |
| subscriptionId | Azure Subscription ID |
| tenantId | Azure Tenant ID |
| servicePrincipleId | Service Principal ID |
| servicePrincipleSecret | Service Principal Secret |
| aksResourceGroupName | Resource Group Name |
| aksLocation | Resource Location |
| aksClusterName | AKS Cluster Name |
| aksAdminGroupID | Azure AD Group ID to assign as AKS cluster admin |
| aksNodeSize | AKS Default Node Size e.g. `Standard_B2ms` |
| aksNodeCount | AKS Default Node Count e.g. `2` |
| resourceTags | Resource Tags e.g. `{name1="value1",name2="value2"}` |
| kubeVersion | Kubernetes version of the control pane and node pool |

**Other Configuration**

| Variable Name | Description |
| --- | --- |
| environmentName | Azure DevOps Environment Name |
| clusterIssuerContactEmail | Let's Encrypt Cluster Issuer Contact Email |

3. Run the pipeline. If you setup an approval, it will need one before apply changes in the last stage

## Terraform CLI

1. Initialize Terraform with AzureRM as backend configuration

```sh
terraform init \
    -backend-config=storage_account_name=<backendAzureRmStorageAccountName> \
    -backend-config=container_name=<backendAzureRmContainerName> \
    -backend-config=key=<backendAzureRmKey> \
    -backend-config=resource_group_name=<backendAzureRmResourceGroupName> \
    -backend-config=subscription_id=<backendAzureRmSubscriptionId> \
    -backend-config=tenant_id=<backendAzureRmTenantId> \
    -backend-config=client_id=<backendAzureRmClientId> \
    -backend-config=client_secret=<backendAzureRmClientSecret>
```

2. Plan Terraform with variables

```sh
terraform plan -out=tfplan \
    -var subscription_id=<subscriptionId> \
    -var tenant_id=<tenantId> \
    -var client_id=<servicePrincipleId> \
    -var client_secret=<servicePrincipleSecret> \
    -var resource_group_name=<aksResourceGroupName> \
    -var location=<aksLocation> \
    -var aks_cluster_name=<aksClusterName> \
    -var aks_node_size=<aksNodeSize> \
    -var aks_node_count=<aksNodeCount> \
    -var kubernetes_version=<kubeVersion> \
    -var admin_group_id=<aksAdminGroupID> \
    -var cluster_issuer_email=<clusterIssuerContactEmail> \
    -var tags='<resourceTags>' \
```

3. Apply the Plan

```sh
terraform apply tfplan
```