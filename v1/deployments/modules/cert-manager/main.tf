resource "helm_release" "cert-manager" {
  name             = "cert-manager"
  namespace        = var.certmanager_config.namespace
  create_namespace = true
  chart            = "cert-manager"
  repository       = "https://charts.jetstack.io"
  version          = "v1.5.3"
  
  set {
    name  = "installCRDs"
    value = "true"
  }
}