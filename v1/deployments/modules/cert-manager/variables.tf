variable "certmanager_config" {
    type = map(any)
    description = "Cert Manager config"
}

variable "tags" {
    type = map(any)
    description = "Tags for all resources"
}

variable "cluster_name" {
  type        = string
  default     = "vib-eks-cluster"
  description = "EKS Cluster name"
}