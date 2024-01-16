
terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket  = "quadcorps-dev-vt-tf-state"
    key     = "terraform-aws-vpc-k8-kong/local/macbook/deployments"
    region  = "eu-west-2"
    profile = "quadcorps-vt"
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
    helm = {
      source  = "hashicorp/helm"
      version = ">=2.9.0"
    }
    kind = {
      source  = "tehcyx/kind"
      version = ">=0.0.16"
    }
    flux = {
      source = "fluxcd/flux"
    }

    github = {
      source  = "integrations/github"
      version = ">=5.18.0"
    }

    kubectl = {
      source  = "alekc/kubectl"
      version = ">= 2.0.2"
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
  host                   = data.aws_eks_cluster.target.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.target.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.target.token
}

provider "kubectl" {
  host                   = data.aws_eks_cluster.target.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.target.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.target.token
  load_config_file       = false
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.target.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.target.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.target.token
  }
}
