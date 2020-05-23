resource "helm_release" "cert-manager" {
  name          = "cert-manager"
  chart         = "pacroy/cert-manager"
  namespace     = var.namespace
  force_update  = true

  set {
    name  = "email"
    value = var.email
  }

}