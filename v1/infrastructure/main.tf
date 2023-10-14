
################################################################################
# EKS Module
################################################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.17.2"

  cluster_name                   = "vib-eks-cluster"
  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }


  vpc_id     = var.vpc_id
  subnet_ids = ["subnet-0d62c00fb697d5b5a", "subnet-0857ec09e610ccad1"]
  #control_plane_subnet_ids = data.aws_vpc.main.intra_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["t3.large"]

    attach_cluster_primary_security_group = true

  }

  eks_managed_node_groups = {
    vib_managed_node_group = {
      min_size     = 2
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
      labels = {
        Environment = "test"
        GithubRepo  = "terraform-aws-eks"
        GithubOrg   = "terraform-aws-modules"
      }

      taints = {
        dedicated = {
          key    = "dedicated"
          value  = "gpuGroup"
          effect = "NO_SCHEDULE"
        }
      }

      update_config = {
        max_unavailable_percentage = 33 # or set `max_unavailable`
      }

      tags = {
        terraform = "true"
        Name      = "vib-test-eks-cluster"
        Email     = "${var.emailtag}"
        Owner     = "${var.emailtag}"
      }
    }
  }
}