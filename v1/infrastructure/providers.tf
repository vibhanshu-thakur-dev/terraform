
terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket         = "quadcorps-dev-vt-tf-state"
    key            = "terraform-aws-vpc-k8-kong/local/macbook/infrastructure"
    region         = "eu-west-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.57"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10"
    }
  }
}


# Configure the AWS Provider
provider "aws" {
  region  = var.region
  profile = var.profile

  default_tags {
    tags = {
      terraform   = "true"
      Email       = "${var.emailtag}"
      Owner       = "${var.emailtag}"
      Environment = "${var.environment}"
    }
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  #config_path    = "~/.kube/config"
  #config_context = "my-context"

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}
