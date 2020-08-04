resource "helm_release" "cluster-issuer" {
  name          = "cluster-issuer"
  repository    = "https://raw.githubusercontent.com/pacroy/helm-repo/master"
  chart         = "cluster-issuer"
  version       = "1.0.0"
  namespace     = var.namespace

  set {
    name  = "email"
    value = var.email
  }
}