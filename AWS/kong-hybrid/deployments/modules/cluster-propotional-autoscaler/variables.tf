variable "cluster_proportional_autoscaler_config" {
  type        = map(any)
  description = "Cluster Proportional Autoscaler Config"
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