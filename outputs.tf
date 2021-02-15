output "id" {
  value = azurerm_kubernetes_cluster.main.id
}

output "fqdn" {
  value = azurerm_kubernetes_cluster.main.fqdn
}

output "host" {
  value = azurerm_kubernetes_cluster.main.kube_config.0.host
}

output "node_resource_group" {
  value = azurerm_kubernetes_cluster.main.node_resource_group
}
