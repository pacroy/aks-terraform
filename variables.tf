#Provider
variable "subscription_id" {
    default = ""
}
variable "tenant_id" {
    default = ""
}
variable "client_id" {
    default = ""
}
variable "client_secret" {
    default = ""
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
