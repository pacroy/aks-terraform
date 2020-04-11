# Terraform Script for Basic AKS Cluster

## How to Use

1. Create a new environment named `shared` and you can optionally setup an approval

2. Create an Azure Pipeline running against this repo with the following variables:

| Variable Name | Description |
| --- | --- |
| resource_group_name | Resource Group name |
| location | Resource location |
| aks_cluster_name | AKS Cluster Name |
| aks_client_id | Service Principle ID |
| aks_client_secret | Service Principle Secret |
| tag_cluster | `cluster` tag value |

3. Run the pipeline. If you setup an approval, it will need one before apply changes in the last stage