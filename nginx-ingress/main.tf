resource "helm_release" "nginx-ingress" {
  name          = "nginx-ingress"
  chart         = "stable/nginx-ingress"
  namespace     = "kube-system"
}