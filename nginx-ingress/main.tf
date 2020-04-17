resource "helm_release" "nginx-ingress" {
  name       = "nginx-ingress"
  repository = data.helm_repository.main.name
  chart      = "nginx-ingress"
  namespace  = "kube-system"
}