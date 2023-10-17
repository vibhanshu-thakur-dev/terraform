
terraform {
  required_version = ">= 1.0"

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



provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(element(data.aws_eks_cluster.cluster.certificate_authority,0).data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}

provider "flux" {
  kubernetes = {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(element(data.aws_eks_cluster.cluster.certificate_authority,0).data)
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
  git = {
    url = "https://github.com/vibhanshu-thakur-dev/k8-manifest.git"
    http = {
      username = "${var.git_username}"
      password = "${var.git_password}"
    }
  }
}
