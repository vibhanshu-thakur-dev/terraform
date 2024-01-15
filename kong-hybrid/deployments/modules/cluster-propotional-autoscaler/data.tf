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
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeScalingActivities",
        "autoscaling:DescribeTags",
        "ec2:DescribeInstanceTypes",
        "ec2:DescribeLaunchTemplateVersions"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup",
        "ec2:DescribeImages",
        "ec2:GetInstanceTypesFromInstanceRequirements",
        "eks:DescribeNodegroup"
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
      values   = ["system:serviceaccount:${var.cluster_proportional_autoscaler_config.namespace}:${var.cluster_proportional_autoscaler_config.service_account_name}"]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_eks_cluster.target.identity[0].oidc[0].issuer, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}