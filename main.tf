provider "azurerm" {
    version       = "~> 2.4.0"
    subscription_id = var.subscription_id
    tenant_id       = var.tenant_id
    client_id       = var.client_id
    client_secret   = var.client_secret
    features {}
}

terraform {
  backend "azurerm" {
    subscription_id  = "99813d40-928b-44b2-a969-2c7ea5bd8b96" #par-shared-002 
    tenant_id        = "3e3564a4-647b-44d3-b3ca-32631ec63210"
    client_id        = "ef11eb5f-12ac-401e-991d-eaaebf6c63c1" #http://parspforcli
    client_secret    = "OQg.Kj7vY2VUN8/e5Pw@WLrn.yQu=14_"
    resource_group_name  = "rg-par-storage-shared-002"
    storage_account_name = "stparaksshared003"
    container_name       = "tfstate-aks"
    key                  = "terraform.tfstate"
  }
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
  }

  role_based_access_control  {
    enabled = false
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
    aci_connector_linux {
      enabled = false
    }

    azure_policy {
      enabled = false
    }

    http_application_routing {
      enabled = false
    }

    kube_dashboard {
      enabled = false
    }

    oms_agent {
      enabled = false
    }
  }

  tags = var.tags
}
