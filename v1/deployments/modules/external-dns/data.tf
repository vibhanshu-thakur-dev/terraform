###############################################################
# GET EKS CLUSTER
###############################################################

data "aws_eks_cluster" "target" {
  name = var.cluster_name
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
      "route53:ChangeResourceRecordSets"
    ]
    resources = ["arn:aws:route53:::hostedzone/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets"
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
      type = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.target.arn]
    }
    condition {
      test = "StringEquals"
      variable = "${replace(data.aws_eks_cluster.target.identity[0].oidc[0].issuer, "https://", "")}:sub"
      values = ["system:serviceaccount:${var.externaldns_config.namespace}:${var.externaldns_config.service_account_name}"]
    }
    condition {
      test = "StringEquals"
      variable = "${replace(data.aws_eks_cluster.target.identity[0].oidc[0].issuer, "https://", "")}:aud"
      values = ["sts.amazonaws.com"]
    }    
  }
}