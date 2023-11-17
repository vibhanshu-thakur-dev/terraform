###############################################################
# GET EKS CLUSTER
###############################################################

data "aws_eks_cluster" "target" {
  name = var.cluster_name
}

###############################################################################
# Route53 Hosted Zone
###############################################################################
data "aws_route53_zone" "target" {
  count = local.use_letsencrypt_dns ? 1 : 0
  name  = var.certmanager_config.domain
}

###############################################################
# GET OPEN ID CONNECT PROVIDER URL
###############################################################
data "aws_iam_openid_connect_provider" "target" {
  url = data.aws_eks_cluster.target.identity[0].oidc[0].issuer
}


###############################################################
# SERVICE ACCOUNT POLICY DOCUMENT
###############################################################
data "aws_iam_policy_document" "iam_service_account_policy" {
  statement {
    effect = "Allow"
    actions = [
      "route53:GetChange"
    ]
    resources = ["arn:aws:route53:::change/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "route53:ListResourceRecordSets",
      "route53:ChangeResourceRecordSets"
    ]
    resources = ["arn:aws:route53:::hostedzone/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "route53:ListHostedZonesByName"
    ]
    resources = ["*"]
  }
}

###############################################################
# SERVICE ACCOUNT ROLE DOCUMENT
###############################################################
data "aws_iam_policy_document" "iam_service_account_assume_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.target.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_eks_cluster.target.identity[0].oidc[0].issuer, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.certmanager_config.namespace}:${var.certmanager_config.service_account_name}"]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_eks_cluster.target.identity[0].oidc[0].issuer, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}


###############################################################
# K8 YAML
###############################################################

data "kubectl_file_documents" "letsencrypt-cluster-issuer" {
  content = file("${path.module}/k8-manifests/cluster-issuer.yaml")
}

data "kubectl_file_documents" "certificate" {
  content = file("${path.module}/k8-manifests/certificate.yaml")
}