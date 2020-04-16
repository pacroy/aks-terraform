resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "stable" #data.helm_repository.stable.name
  chart      = "cert-manager"
  namespace  = var.namespace
}