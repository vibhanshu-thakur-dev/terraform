module "vpc" {
    source = "./modules/vpc"

    region = var.region
    az_list = var.az_list
    emailtag = var.emailtag
    environment = var.environment
    profile = var.profile

    public_subnet_cidr_list = var.public_subnet_cidr_list
    private_subnet_cidr_list = var.private_subnet_cidr_list
    vpc_name = var.vpc_name

}