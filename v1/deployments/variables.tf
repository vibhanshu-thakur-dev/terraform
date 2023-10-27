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

variable "emailtag" {
  type        = string
  default     = "vibhanshu@quadcorps.co.uk"
  description = "Email ID for resource tag"
}

variable "cluster_name" {
  type        = string
  default     = "vib-eks-cluster"
  description = "EKS Cluster name"
}

variable "git_username" {
  type        = string
  default     = "vibhanshu-thakur-dev"
  description = "Git username"
}


variable "git_password" {
  type        = string
  default     = ""
  description = "Git password"
}

variable "externaldns_config" {
  type        = map(any)
  description = "External DNS config"
}

variable "tags" {
  type        = map(any)
  description = "Tags for all resources"
}