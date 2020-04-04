provider "azurerm" {
    version       = "=2.4.0"
    subscription_id = var.subscription_id
    tenant_id       = var.tenant_id
    client_id       = var.client_id
    client_secret   = var.client_secret
    features {}
}

# resource "azurerm_resource_group" "main" {
#     name     = var.resource_group_name
#     location = var.location
#     tags     = var.tags
# }

# resource "azurerm_kubernetes_cluster" "main" {
#   name                = var.aks_cluster_name
#   location            = var.location
#   resource_group_name = azurerm_resource_group.main.name
#   dns_prefix          = var.aks_cluster_name

#   agent_pool_profile {
#     name            = "default"
#     count           = 2
#     vm_size         = "Standard_B2ms"
#     os_type         = "Linux"
#     os_disk_size_gb = 30
#   }

#   service_principal {
#     client_id     = var.aks_client_id
#     client_secret = var.aks_client_secret
#   }

#   tags = var.tags
# }

resource "azurerm_kubernetes_cluster" "cluster1" {
  # (resource arguments)
}