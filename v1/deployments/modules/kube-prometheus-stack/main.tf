resource "kubernetes_namespace" "target" {
  count = var.monitoring_config.namespace_create ? 1 : 0
  metadata {
    name = var.monitoring_config.namespace
  }
}

resource "helm_release" "external_dns" {
  name       = "monitoring-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  namespace = var.monitoring_config.namespace

  values = [yamlencode(yamldecode(file("${path.module}/helm-values/values.yaml")))]
}