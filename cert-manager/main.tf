resource "helm_release" "cert-manager" {
  name          = "cert-manager"
  repository    = data.helm_repository.main.metadata[0].url
  chart         = "cert-manager"
  namespace     = var.namespace
  version       = "0.14.2"
  force_update  = true

  set {
    name  = "email"
    value = var.email
  }

}