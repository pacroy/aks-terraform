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

**Tool Download URLs**

| Variable Name | Description |
| --- | --- |
| terraformDownloadUrl | Terraform Download URL e.g. `https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip` |
| helmDownloadUrl | Helm Download URL e.g. `https://get.helm.sh/helm-v3.1.2-linux-amd64.tar.gz` |

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
| aksServicePrincipleId | Service Principle ID for AKS Cluster |
| aksServicePrincipleSecret | Service Principle Secret for AKS Cluster |
| aksClusterNickname | AKS Cluster Nickname (as tag `cluster`) |

**Other Configuration**

| Variable Name | Description |
| --- | --- |
| environmentName | Azure DevOps Environment Name |
| clusterIssuerContactEmail | Let's Encrypt Cluster Issuer Contact Email |

3. Run the pipeline. If you setup an approval, it will need one before apply changes in the last stage