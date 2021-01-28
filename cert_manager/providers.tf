provider "helm" {
  version = "~> 1.3.0"
  kubernetes {
    host = var.kube_config.host

    client_certificate     = base64decode(var.kube_config.client_certificate)
    client_key             = base64decode(var.kube_config.client_key)
    cluster_ca_certificate = base64decode(var.kube_config.cluster_ca_certificate)
    load_config_file       = false
  }
}