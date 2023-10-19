# variables.tfvars
region = "eu-west-2"
az_list = ["eu-west-2a","eu-west-2b"]
emailtag = "vibhanshu@quadcorps.co.uk"
#public_subnet_cidr_list = ["10.0.1.0/24", "10.0.2.0/24"]
#private_subnet_cidr_list = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
cluster_name = "vib-eks-cluster"
environment = "dev"
profile = "quadcorps"

public_subnet_cidr_list = ["10.0.0.0/20", "10.0.16.0/20"]
private_subnet_cidr_list = ["10.0.32.0/20", "10.0.48.0/20", "10.0.64.0/20", "10.0.80.0/20"]
