variable "cluster_name" {
  type        = string
  description = "The name of the EKS cluster"
}

variable "token" {
  type        = string
  description = "EKS cluster auth token"
}

variable "host" {
  type        = string
  description = "EKS cluster host"
}

variable "cluster_ca_certificate" {
  type        = string
  description = "EKS cluster CA cert"
}

variable "git_username" {
  type        = string
  description = "GitHub Username"
}

variable "git_password" {
  type        = string
  description = "GitHub password"
}