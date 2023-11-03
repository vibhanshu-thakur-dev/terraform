module "fluxcd" {
  source                 = "./modules/fluxcd"
  cluster_name           = var.cluster_name
  token                  = data.aws_eks_cluster_auth.target.token
  cluster_ca_certificate = data.aws_eks_cluster.target.certificate_authority[0].data
  host                   = data.aws_eks_cluster.target.endpoint

  git_password = var.git_password
  git_username = var.git_username
}

module "external-dns" {
  source             = "./modules/external-dns"
  cluster_name       = var.cluster_name
  externaldns_config = var.externaldns_config
  tags               = var.tags
}

module "cert-manager" {
  source             = "./modules/cert-manager"
  cluster_name       = var.cluster_name
  certmanager_config = var.certmanager_config
  tags               = var.tags
}