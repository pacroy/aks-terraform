#Provider
variable "subscription_id" {}
variable "tenant_id" {}
variable "client_id" {}
variable "client_secret" {}

#Resource Group
variable "resource_group_name" {}

#AKS cluster
variable "location" {}
variable "aks_cluster_name" {}
variable "aks_client_id" {}
variable "aks_client_secret" {}

#Tags
variable "tags" {
    type = map
}