resource "helm_release" "cert-manager" {
  name          = "cert-manager"
  repository    = data.helm_repository.main.metadata[0].name
  chart         = "cert-manager"
  namespace     = var.namespace
  force_update  = true

  set {
    name  = "email"
    value = var.email
  }

}