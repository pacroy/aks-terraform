resource "helm_release" "nginx-ingress" {
  name       = "nginx-ingress"
  repository = data.helm_repository.main.metadata[0].name
  chart      = "nginx-ingress"
  namespace  = "kube-system"
}