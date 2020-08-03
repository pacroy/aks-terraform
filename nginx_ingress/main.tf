resource "helm_release" "nginx-ingress" {
  name          = "nginx-ingress"
  repository    = "https://kubernetes-charts.storage.googleapis.com"
  chart         = "nginx-ingress"
  namespace     = "kube-system"
}