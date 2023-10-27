resource "kubernetes_namespace" "target" {
  metadata {
    name        = var.externaldns_config.namespace
  }
}

resource "helm_release" "external_dns" {
  name       = "external-dns"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  namespace =var.externaldns_config.namespace 

  set {
    name = "Values.serviceAccount.annotations"
    value = "eks.amazonaws.com/role-arn: aws_iam_role.service_account_role.arn"
  }
}