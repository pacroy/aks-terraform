# Terraform Script for Basic AKS Cluster

[![Lint Code Base](https://github.com/pacroy/aks-terraform/actions/workflows/linter.yml/badge.svg)](https://github.com/pacroy/aks-terraform/actions/workflows/linter.yml)

## Service Principal

The template needs at least one service principal to access Azure storage that keeping terraform tfstate file and create AKS cluster resources in an Azure subscription.

### Create Service Principal

Create service principal and grant Contributor permission over a subscription that will you want to deploy AKS cluster within.

```sh
az ad sp create-for-rbac --name "http://your-sp-name" --role "Contributor" --scope "/subscriptions/{subscription-id}"
```

### Grant Permission

If storage account is in another subscription, you have to grant additional permission to the storage account.

```sh
az role assignment create --assignee "{service-principal-id}" --role "Contributor" --scope "/subscriptions/{subscription-id}/resourceGroups/{resource-group}/providers/Microsoft.Storage/storageAccounts/{storage-account}"
```

### List permission to verify

```sh
az role assignment list --all --assignee "{service-principal-id}" --subscription "{subscription-id}" --output table
```

## Azure AD Group

An Azure AD group is required by the template to give initial access to AKS cluster as cluster admin.

### Create Azure AD Group

```sh
group_id=$(az ad group create --display-name "<group-name>" --mail-nickname "<group-name>" | jq -r ".objectId")
```

### Add Member to Azure AD Group

```
member_id=$(az ad user list --upn "<email address>" --query '[0].objectId' --output tsv)
az ad group member add --group "${group_id}" --member-id "${member_id}"
```

### List Member in Azure AD Group

```sh
az ad group member list --group "${group_id}" --query '[].userPrincipalName'
```

### Remove Member from Azure AD Group

```sh
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

## Troubleshooting

### failed calling webhook "webhook.cert-manager.io"

**Symptom**: Got the error below while applying

```
Error: Internal error occurred: failed calling webhook "webhook.cert-manager.io": Post "https://cert-manager-webhook.cert-manager.svc:443/mutate?timeout=10s": x509: certificate signed by unknown authority

on cluster_issuer/main.tf line 1, in resource "helm_release" "cluster-issuer":
1: resource "helm_release" "cluster-issuer" {
```

**Resolution**: Try applying again
