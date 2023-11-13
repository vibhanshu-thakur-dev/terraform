
terraform {

  backend "s3" {
    bucket = "quadcorps-dev-vt-tf-state"
    key    = "terraform-aws-vpc-k8-kong/local/macbook/environment"
    region = "eu-west-2"
  }

  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.57"
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