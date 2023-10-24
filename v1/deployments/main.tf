module "fluxcd" {
  source                 = "./modules/fluxcd"
  cluster_name           = var.cluster_name
  token                  = data.aws_eks_cluster_auth.target.token
  cluster_ca_certificate = data.aws_eks_cluster.target.certificate_authority[0].data
  host                   = data.aws_eks_cluster.target.endpoint

  git_password = var.git_password
  git_username = var.git_username
}