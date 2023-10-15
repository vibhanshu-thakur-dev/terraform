variable "vpc_id" {
  type        = string
  description = "AWS VPC ID"
}

variable "emailtag" {
  type        = string
  default     = "vibhanshu@quadcorps.co.uk"
  description = "Email ID for resource tag"
}

variable "region" {
  type        = string
  default     = "eu-west-2"
  description = "AWS deployment region"
}
variable "profile" {
  type        = string
  default     = "vibhanshu-personal"
  description = "AWS profile"
}
variable "az_list" {
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b"]
  description = "EU West 2 availability zones"
}

variable "subnet_list" {
  type        = list(string)
  default     = ["subnet-0f9455d8a8466ed74","subnet-015e6b9113991fe83"]
  description = "List of private subnets"
}