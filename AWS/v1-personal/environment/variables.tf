variable "region" {
  type        = string
  default     = "eu-west-2"
  description = "AWS deployment region"
}

variable "profile" {
  type        = string
  default     = "vibhanshu-personal"
  description = "AWS local profile"
}

variable "az_list" {
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b"]
  description = "EU West 2 availability zones"
}

variable "public_subnet_cidr_list" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  description = "Public subnet CIDRs"
}

variable "private_subnet_cidr_list" {
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  description = "Private subnet CIDRs"
}

variable "emailtag" {
  type        = string
  default     = "vibhanshu@quadcorps.co.uk"
  description = "Email ID for resource tag"
}
