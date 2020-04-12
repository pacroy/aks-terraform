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

| Variable Name | Description |
| --- | --- |
| resource_group_name | Resource Group name |
| location | Resource location |
| aks_cluster_name | AKS Cluster Name |
| aks_client_id | Service Principle ID |
| aks_client_secret | Service Principle Secret |
| tag_cluster | `cluster` tag value |
| environment_name | Azure Pipeline Environment name created in 1. |

3. Run the pipeline. If you setup an approval, it will need one before apply changes in the last stage