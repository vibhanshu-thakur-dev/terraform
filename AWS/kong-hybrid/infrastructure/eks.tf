
################################################################################
# EKS Module
################################################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.17.2"

  count                   = length(var.cluster_name)

  cluster_name                   = element(var.cluster_name, count.index)
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


  vpc_id     = data.aws_vpc.main.id
  subnet_ids = data.aws_subnets.private_subnets.ids
  #control_plane_subnet_ids = data.aws_vpc.main.intra_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = [var.eks_config.instance_type]

    # EKS Managed Node Group(s)
    # attach_cluster_primary_security_group = true

  }

  eks_managed_node_groups = {
    vib_managed_node_group = {
      min_size     = var.eks_config.node_min
      max_size     = var.eks_config.node_max
      desired_size = var.eks_config.node_desired

      instance_types = [var.eks_config.instance_type]
      capacity_type  = var.eks_config.capacity_type
      labels = {
        Environment = var.environment
        GithubRepo  = "terraform-aws-eks"
        GithubOrg   = "terraform-aws-modules"
        ClusterName                   = element(var.cluster_name, count.index)
      }



      update_config = {
        max_unavailable_percentage = 33 # or set `max_unavailable`
      }

      tags = {
        terraform   = "true"
        Name        = element(var.cluster_name, count.index)
        Environment = "${var.environment}"
        Email       = "${var.emailtag}"
        Owner       = "${var.emailtag}"
      }
    }
  }

  # Extend node-to-node security group rules
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
  }
}