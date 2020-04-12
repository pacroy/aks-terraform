#Provider
variable "subscription_id" {
    default = null
}
variable "tenant_id" {
    default = null
}
variable "client_id" {
    default = null
}
variable "client_secret" {
    default = null
}

#Resource Group
variable "resource_group_name" {}

#AKS cluster
variable "location" {}
variable "aks_cluster_name" {}
variable "aks_client_id" {}
variable "aks_client_secret" {}

#Tags
variable "tag_cluster" {}
