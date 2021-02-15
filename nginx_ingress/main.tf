resource "helm_release" "nginx-ingress" {
  name              = "nginx-ingress"
  repository        = "https://charts.helm.sh/stable"
  chart             = "nginx-ingress"
  namespace         = var.namespace
  create_namespace  = true
}