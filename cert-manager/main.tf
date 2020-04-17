resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = data.helm_repository.main.name
  chart      = "cert-manager"
  namespace  = var.namespace
  version    = "0.14.2"

  set {
    name  = "email"
    value = var.email
  }

}