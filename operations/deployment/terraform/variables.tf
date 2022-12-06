variable "common_tags" {
  default     = {}
  description = "Common resource tags"
  type        = map(string)
}

variable "aws-profile" {
  default     = ""
  description = "AWS profile ID"
  type        = string
}

variable "aws-region" {
  default     = ""
  description = "AWS target region"
  type        = string
}

variable "environment" {
  default     = ""
  description = "Environment of deployment"
  type        = string
}

variable "vpc_cidr" {
  default     = ""
  description = "CIDR of the VPC"
  type        = string
}

variable "availability_zones" {
  default     = []
  description = "A list of availability zones"
  type        = list(string)
}

variable "public_subnets" {
  default     = []
  description = "A list of public subnets"
  type        = list(string)
}

variable "private_subnets" {
  default     = []
  description = "A list of private subnets"
  type        = list(string)
}

variable "route53_zone_id" {
  default     = ""
  description = "Route53 Zone ID"
  type        = string
}

variable "domain_name" {
  default     = ""
  description = "Domain Name"
  type        = string
}