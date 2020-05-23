resource "helm_release" "cert-manager" {
  name          = "cert-manager"
  repository    = "https://raw.githubusercontent.com/pacroy/helm-repo/master"
  chart         = "cert-manager"
  namespace     = var.namespace
  force_update  = true

  set {
    name  = "email"
    value = var.email
  }

}