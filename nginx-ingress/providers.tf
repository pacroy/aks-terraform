provider "helm" {
  version = "~> 1.2"
  kubernetes {
    host = var.kube_config.host

    client_certificate     = base64decode(var.kube_config.client_certificate)
    client_key             = base64decode(var.kube_config.client_key)
    cluster_ca_certificate = base64decode(var.kube_config.cluster_ca_certificate)
    load_config_file       = false
  }
}

data "helm_repository" "main" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}