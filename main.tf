provider "azurerm" {
    version       = "=2.4.0"
    subscription_id = var.subscription_id
    tenant_id       = var.tenant_id
    client_id       = var.client_id
    client_secret   = var.client_secret
    features {}
}

resource "azurerm_resource_group" "main" {
    name     = var.resource_group_name
    location = var.location
    tags     = var.tags
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = var.aks_cluster_name
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = var.aks_cluster_name
  kubernetes_version  = "1.15.10"

  default_node_pool {
    name                = "default"
    vm_size             = "Standard_B2ms"
    enable_auto_scaling = false
    node_count          = 2

    tags                = var.tags
  }
  
  service_principal {
    client_id     = var.aks_client_id
    client_secret = var.aks_client_secret
  }

  network_profile {
    load_balancer_sku = "standard"
    network_plugin    = "kubenet"
    network_policy    = "calico"
  }

  addon_profile {
    kube_dashboard {
      enabled = false
    }

    oms_agent {
      enabled = false
    }
  }

  role_based_access_control  {
    enabled = false
  }

  tags = var.tags
}
