variable "profile" {
  type        = string
  default     = "quadcorps"
  description = "AWS Profile"
}

variable "region" {
  type        = string
  default     = "eu-west-2"
  description = "AWS deployment region"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "environment"
}

variable "vpc_name" {
  type        = string
  default     = ""
  description = "VPC Name"
}

variable "az_list" {
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b"]
  description = "EU West 2 availability zones"
}

variable "emailtag" {
  type        = string
  default     = "vibhanshu@quadcorps.co.uk"
  description = "Email ID for resource tag"
}

variable "cluster_name" {
  type        = list(string)
  default     = ["vib-eks-cluster-1","vib-eks-cluster-2","vib-eks-cluster-3"]
  description = "EKS Cluster name"
}

variable "eks_config" {
  type        = map(any)
  description = "EKS config"
}