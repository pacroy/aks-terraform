resource "helm_release" "nginx-ingress" {
  name       = "nginx-ingress"
  repository = "stable" #data.helm_repository.stable.name
  chart      = "nginx-ingress"
  namespace  = "kube-system"
}