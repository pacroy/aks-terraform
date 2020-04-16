resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = data.helm_repository.stable.name
  chart      = "cert-manager"
  namespace  = var.namespace

#   set {
#     name  = "external-dns.azure.aadClientSecret"
#     value = var.external_dns_aad_client_secret
#   }

#   values = [
#     file("${abspath(path.module)}/${var.value_file}")
#   ]

}