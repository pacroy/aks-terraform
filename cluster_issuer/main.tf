resource "helm_release" "cluster-issuer" {
  name              = "cluster-issuer"
  repository        = "https://pacroy.github.io/helm-repo"
  chart             = "cluster-issuer"
  version           = "2.0.0"
  namespace         = var.namespace
  create_namespace  = true

  set {
    name  = "email"
    value = var.email
  }
}