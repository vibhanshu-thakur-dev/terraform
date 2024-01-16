resource "kubernetes_namespace" "target" {
  metadata {
    name = var.externaldns_config.namespace
  }
}

resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"

  namespace = var.externaldns_config.namespace

  set {
    name  = "wait-for"
    value = aws_iam_role.service_account_role.arn
  }

  set {
    name  = "domainFilters"
    value = "{${var.externaldns_config.domain}}"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com\\/role-arn"
    value = aws_iam_role.service_account_role.arn
  }
}