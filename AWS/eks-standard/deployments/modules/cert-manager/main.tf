locals {
  use_letsencrypt_dns = true

  module_values = {
    serviceAccount = {
      name = var.certmanager_config.service_account_name
      annotations = !local.use_letsencrypt_dns ? {} : {
        "eks.amazonaws.com/role-arn" = aws_iam_role.service_account_role.arn
      }
    }
  }
}

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
  version    = "v1.13.2"

  values = concat(
    [yamlencode(yamldecode(templatefile("${path.module}/helm-values/cert-manager-values.yaml", {
      role_arn : aws_iam_role.service_account_role.arn
    })))],
    [yamlencode(local.module_values)]
  )

  depends_on = [
    kubernetes_namespace.target,
    aws_iam_role_policy_attachment.service_account_attach
  ]
}

# resource "kubectl_manifest" "letsencrypt-cluster-issuer" {
#  for_each  = data.kubectl_file_documents.letsencrypt-cluster-issuer.manifests
#  yaml_body = each.value

#  depends_on = [ helm_release.cert-manager ]
# }

# resource "kubectl_manifest" "certificate" {
#  for_each  = data.kubectl_file_documents.certificate.manifests
#  yaml_body = each.value

#  depends_on = [ helm_release.cert-manager , kubectl_manifest.letsencrypt-cluster-issuer]
# }