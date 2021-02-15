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
  kubernetes_version  = var.kubernetes_version
  tags  = var.tags

  default_node_pool {
    name                 = "default"
    vm_size              = var.aks_node_size
    enable_auto_scaling  = false
    node_count           = var.aks_node_count
    orchestrator_version = var.kubernetes_version
  }

  role_based_access_control  {
    enabled = true
    azure_active_directory {
      managed = true
      tenant_id = var.tenant_id
    }
  }
  
  identity {
    type = "SystemAssigned"
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

resource "kubernetes_namespace" "cert-manager" {
  metadata {
    name = "cert-manager"
  }
}

module "nginx-ingress" {
  source      = "./nginx_ingress"
  kube_config = azurerm_kubernetes_cluster.main.kube_admin_config
  namespace   = "kube-system"
}

module "cert-manager" {
  source      = "./cert_manager"
  kube_config = azurerm_kubernetes_cluster.main.kube_admin_config
  namespace   = kubernetes_namespace.cert-manager.metadata[0].name
}

module "cluster-issuer" {
  source      = "./cluster_issuer"
  kube_config = azurerm_kubernetes_cluster.main.kube_admin_config
  email       = var.cluster_issuer_email
  namespace   = module.cert-manager.namespace
}