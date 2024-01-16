resource "kubernetes_namespace" "target" {
  metadata {
    name = "ingress-nginx"
  }
}

resource "helm_release" "nginx_ingress" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  namespace = "ingress-nginx"

  values = [yamlencode(yamldecode(file("${path.module}/helm-values/values.yaml")))]
}