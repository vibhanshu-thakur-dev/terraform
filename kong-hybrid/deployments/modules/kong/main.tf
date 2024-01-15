resource "kubernetes_namespace" "target" {
  count = var.konggw_config.namespace_create ? 1 : 0
  metadata {
    name = var.konggw_config.namespace
  }
}

resource "helm_release" "external_dns" {
  name       = "konggw-dbless"
  repository = "https://charts.konghq.com"
  chart      = "kong"

  namespace = "kong"

  values = [yamlencode(yamldecode(file("${path.module}/helm-values/values.yaml")))]
}