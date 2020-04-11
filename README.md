# Terraform Script for Basic AKS Cluster

## How to Use

Run an Azure Pipeline on this repo with the following variables:

| Variable Name | Description |
| --- | --- |
| resource_group_name | Resource Group name |
| location | Resource location |
| aks_cluster_name | AKS Cluster Name |
| aks_client_id | Service Principle ID |
| aks_client_secret | Service Principle Secret |
| tag_cluster | `cluster` tag value |
