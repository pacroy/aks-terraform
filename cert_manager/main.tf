resource "helm_release" "cert-manager" {
  name              = "cert-manager"
  repository        = "https://charts.jetstack.io"
  chart             = "cert-manager"
  namespace         = var.namespace
  version           = "0.16.0"
  force_update      = true

  set {
    name  = "installCRDs"
    value = true
  }
}

output "namespace" {
  value = cert-manager.metadata.namespace
}