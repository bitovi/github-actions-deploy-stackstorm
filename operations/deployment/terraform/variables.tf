variable "app_port" {
  type = string
  default = "443"
  description = "app port"
}
variable "lb_port" {
  type = string
  default = ""
  description = "Load balancer listening port. Defaults to 80 if NO FQDN provided, 443 if FQDN provided"
}
variable "lb_healthcheck" {
  type = string
  default = "HTTPS:443/"
  description = "Load balancer health check string. Defaults to HTTP:app_port"
}
variable "app_repo_name" {
  type = string
  description = "GitHub Repo Name"
}
variable "app_org_name" {
  type = string
  description = "GitHub Org Name"
}
variable "app_branch_name" {
  type = string
  description = "GitHub Branch Name"
}

variable "app_install_root" {
  type = string
  description = "Path on the instance where the app will be cloned (do not include app_repo_name)."
  default = "/home/ubuntu"
}

variable "os_system_user" {
  type = string
  description = "User for the OS"
  default = "ubuntu"
}

variable "ops_repo_environment" {
  type = string
  description = "Ops Repo Environment (i.e. directory name)"
}

variable "ec2_instance_type" {
  type = string
  default = "t2.medium"
  description = "Instance type for the EC2 instance"
}
variable "ec2_instance_public_ip" {
  type = string
  default = "false"
  description = "Attach public IP to the EC2 instance"
}
variable "security_group_name" {
  type = string
  default = "SG for deployment"
  description = "Name of the security group to use"
}
variable "ec2_iam_instance_profile" {
  type = string
  description = "IAM role for the ec2 instance"
  default = ""
}
variable "lb_access_bucket_name" {
  type = string
  description = "s3 bucket for the lb access logs"
}

variable "aws_resource_identifier" {
  type = string
  description = "Identifier to use for AWS resources (defaults to GITHUB_ORG-GITHUB_REPO-GITHUB_BRANCH)"
}

variable "aws_resource_identifier_supershort" {
  type = string
  description = "Identifier to use for AWS resources (defaults to GITHUB_ORG-GITHUB_REPO-GITHUB_BRANCH) shortened to 30 chars"
}

variable "create_vpc" {
  type = string
  default = "false"
  description = "Attach public IP to the EC2 instance"
}


## NEW NEEDS REVIEW
variable "vpc_cidr" {
  description = "CIDR of the VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnets" {
  default     = ["10.10.110.0/24", "10.10.111.0/24"]
  description = "A list of public subnets"
  type        = list(string)
}

variable "private_subnets" {
  default     = ["10.10.0.0/24", "10.10.1.0/24"]
  description = "A list of private subnets"
  type        = list(string)
}

variable "availability_zones" {
  default     = ["a", "b"]
  description = "A list of availability zones (to be mapped to the region \"{region}{availability_zones}\""
  type        = list(string)
}

variable "region" {
  type = string
  description = "AWS Region to deploy to"
  default = ""
}

variable "aws_extra_tags" {
  type        = map(string)
  description = "A list of tags that will be added to created resources"
  default     = {}

}

# variable "common_tags" {
#   default     = {}
#   description = "Common resource tags"
#   type        = map(string)
# }

# variable "aws-profile" {
#   default     = ""
#   description = "AWS profile ID"
#   type        = string
# }

# variable "aws-region" {
#   default     = ""
#   description = "AWS target region"
#   type        = string
# }

# variable "environment" {
#   default     = ""
#   description = "Environment of deployment"
#   type        = string
# }


# variable "public_subnets" {
#   default     = []
#   description = "A list of public subnets"
#   type        = list(string)
# }

# variable "private_subnets" {
#   default     = []
#   description = "A list of private subnets"
#   type        = list(string)
# }



variable "sub_domain_name" {
  type        = string
  description = "Subdomain name for DNS record"
  default     = ""
}
variable "domain_name" {
  type        = string
  description = "root domain name without any subdomains"
  default     = ""
}
variable "root_domain" {
  type        = string
  description = "deploy to root domain"
  default     = ""
}

variable "cert_arn" {
  type        = string
  description = "Certificate ARN to use"
  default     = ""
}

variable "create_root_cert" {
  type        = string
  description = "Create root cert"
  default     = ""
}

variable "create_sub_cert" {
  type        = string
  description = "Create sub_domain certificate"
  default     = ""
}

variable "no_cert" {
  type        = string
  description = "disable cert lookup"
  default     = ""
}