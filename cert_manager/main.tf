resource "helm_release" "cert-manager" {
  name              = "cert-manager"
  repository        = "https://charts.jetstack.io"
  chart             = "cert-manager"
  namespace         = var.namespace
  create_namespace  = true
  version           = "1.1.0"
  force_update      = true

  set {
    name  = "installCRDs"
    value = true
  }
}

output "namespace" {
  value = helm_release.cert-manager.namespace
}