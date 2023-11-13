resource "kubernetes_namespace" "target" {
  metadata {
    name = var.certmanager_config.namespace
  }
}

resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  namespace  = var.certmanager_config.namespace
  chart      = "cert-manager"
  repository = "https://charts.jetstack.io"
  version    = "v1.5.3"

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com\\/role-arn"
    value = aws_iam_role.service_account_role.arn
  }
}