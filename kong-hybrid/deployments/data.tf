data "aws_eks_cluster" "target" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "target" {
  name = var.cluster_name
}