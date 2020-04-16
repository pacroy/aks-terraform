resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = data.helm_repository.jetstack.name
  chart      = "cert-manager"
  namespace  = var.namespace
  version    = "v0.15.0-alpha.0" #This version includes CRDs in the chart
}