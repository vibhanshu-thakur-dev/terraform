
terraform {
  required_version = ">= 1.0"

  required_providers {
    flux = {
      source = "fluxcd/flux"
    }

    github = {
      source  = "integrations/github"
      version = ">=5.18.0"
    }
  }
}

provider "flux" {
  kubernetes = {
    host                   = var.host
    cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
    token                  = var.token
  }
  git = {
    url = "https://github.com/vibhanshu-thakur-dev/k8-manifest.git"
    http = {
      username = var.git_username
      password = var.git_password
    }
  }
}