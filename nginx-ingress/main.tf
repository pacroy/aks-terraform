resource "helm_release" "nginx-ingress" {
  name          = "nginx-ingress"
  repository    - "https://kubernetes-charts.storage.googleapis.com"
  chart         = "stable/nginx-ingress"
  namespace     = "kube-system"
}