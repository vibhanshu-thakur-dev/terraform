variable "monitoring_config" {
  type        = map(any)
  description = "Config for monitoring"
}

variable "tags" {
  type        = map(any)
  description = "Tags for all resources"
}

variable "cluster_name" {
  type        = string
  default     = "vib-eks-cluster"
  description = "EKS Cluster name"
}