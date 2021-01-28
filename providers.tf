terraform {
  backend "azurerm" {
  }

  required_providers {
    azurerm = {
      source = "azurerm"
      version = "~> 2.44.0"
    }

    kubernetes = {
      source = "kubernetes"
      version = "~> 1.13.0"
    }
  }
}

provider "azurerm" {
    subscription_id = var.subscription_id
    tenant_id       = var.tenant_id
    client_id       = var.client_id
    client_secret   = var.client_secret
    features {}
}

provider "kubernetes" {
  host = azurerm_kubernetes_cluster.main.kube_config[0].host

  client_certificate     = base64decode(azurerm_kubernetes_cluster.main.kube_config[0].client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.main.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate)
  load_config_file       = false
}