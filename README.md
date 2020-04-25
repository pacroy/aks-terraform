# Terraform Script for Basic AKS Cluster

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
| aksNodeSize | AKS Default Node Size e.g. `Standard_B2ms` |
| aksNoceCount | AKS Default Node Count e.g. `2` |
| aksServicePrincipleId | Service Principle ID for AKS Cluster |
| aksServicePrincipleSecret | Service Principle Secret for AKS Cluster |
| resourceTags | Resource Tags e.g. `{name1="value1",name2="value2"}` |

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
    -var aks_client_id=<aksServicePrincipleId> \
    -var aks_client_secret=<aksServicePrincipleSecret> \
    -var tags='<resourceTags>' \
    -var cluster_issuer_email=<clusterIssuerContactEmail>
```

3. Apply the Plan

```sh
terraform apply tfplan
```