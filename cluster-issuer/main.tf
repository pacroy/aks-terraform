resource "helm_release" "cluster-issuer" {
  name          = "cluster-issuer"
  repository    = data.helm_repository.main.metadata[0].name
  chart         = "cluster-issuer"
  version       = "1.0.0"

  set {
    name  = "email"
    value = var.email
  }
}