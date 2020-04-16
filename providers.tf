terraform {
  backend "azurerm" {
  }
}

provider "azurerm" {
    version       = "~> 2.4"
    subscription_id = var.subscription_id
    tenant_id       = var.tenant_id
    client_id       = var.client_id
    client_secret   = var.client_secret
    features {}
}

provider "kubernetes" {
  host = module.aks-cluster-non-production.aks_kube_admin_config.host

  client_certificate     = base64decode(module.aks-cluster-non-production.aks_kube_admin_config.client_certificate)
  client_key             = base64decode(module.aks-cluster-non-production.aks_kube_admin_config.client_key)
  cluster_ca_certificate = base64decode(module.aks-cluster-non-production.aks_kube_admin_config.cluster_ca_certificate)
  load_config_file       = false
  version                = "~> 1.10"
}