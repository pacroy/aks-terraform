resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = data.helm_repository.jetstack.name
  chart      = "cert-manager"
  namespace  = var.namespace
  version    = "0.14.2"
}