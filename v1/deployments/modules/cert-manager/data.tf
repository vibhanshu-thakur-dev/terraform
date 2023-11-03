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

