# Terraform Script for Basic AKS Cluster

## Terraform CLI

1. Initialize Terraform with AzureRM as backend configuration

```sh
terraform init \
    -backend-config=storage_account_name=<Azure Storage Account> \
    -backend-config=container_name=<BLOB Container> \
    -backend-config=key=<BLOB Key> \
    -backend-config=resource_group_name=<Resource Group of the Storage Account> \
    -backend-config=subscription_id=<Azure Subscription ID> \
    -backend-config=tenant_id=<AzureAD Tenant ID> \
    -backend-config=client_id=<AzureAD Service Principal ID> \
    -backend-config=client_secret=<AzureAD Service Principal Secret>
```

2. Plan Terraform with variables

```sh
terraform plan -out=tfplan \
    -var subscription_id=<Azure Subscription ID> \
    -var tenant_id=<AzureAD Tenant ID> \
    -var client_id=<AzureAD Service Principal ID> \
    -var client_secret=<AzureAD Service Principal Secret> \
    -var resource_group_name=<Resource Group of AKS> \
    -var location=<Resource Location> \
    -var aks_cluster_name=<AKS Cluster Name> \
    -var aks_client_id=<AzureAD Service Principal ID for the AKS> \
    -var aks_client_secret=<AzureAD Service Principal Secret> \
    -var tag_cluster=<Cluster nickname as a tag>
```

3. Apply the Plan

```sh
terraform apply tfplan
```

## Azure DevOps Pipeline

1. Create a new environment in Azure Pipeline. You can optionally setup an approval, if you want.

2. Create an Azure Pipeline running against this repo with the following variables:

**Variables for Terraform Backend Configuration in Azure Storage**

| Variable Name | Description |
| --- | --- |
| backendAzureRmServiceName | Service Connection Name |
| backendAzureRmResourceGroupName | Resource Group Name |
| backendAzureRmStorageAccountName | Storage Account Name |
| backendAzureRmContainerName | Storage Container Name |
| backendAzureRmKey | Storage Key Name e.g. `terraform.tfstate` |

**AKS Cluster Configuration Variables**

| Variable Name | Description |
| --- | --- |
| aksAzureRmServiceName | Service Connection Name |
| aksResourceGroupName | Resource Group Name |
| aksLocation | Resource Location |
| aksClusterName | AKS Cluster Name |
| aksServicePrincipleId | Service Principle ID |
| aksServicePrincipleSecret | Service Principle Secret |
| aksClusterNickname | AKS Cluster Nickname (as tag `cluster`) |
| aksADOEnvironmentName | Configured Environment Name in Azure DevOps |

3. Run the pipeline. If you setup an approval, it will need one before apply changes in the last stage