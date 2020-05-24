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
  kubernetes_version  = "1.15.11"
  tags  = var.tags

  default_node_pool {
    name                = "default"
    vm_size             = var.aks_node_size
    enable_auto_scaling = false
    node_count          = var.aks_node_count
    tags                = var.tags
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
}

module "nginx-ingress" {
  source      = "./nginx-ingress"
  kube_config = azurerm_kubernetes_cluster.main.kube_config[0]
  namespace   = "kube-system"
}

module "cert-manager" {
  source      = "./cert-manager"
  kube_config = azurerm_kubernetes_cluster.main.kube_config[0]
  namespace   = "cert-manager"
}

module "cluster-issuer" {
  source      = "./cluster-issuer"
  kube_config = azurerm_kubernetes_cluster.main.kube_config[0]
  email       = var.cluster_issuer_email
  depends_on  = [ module.cert-manager ]
}