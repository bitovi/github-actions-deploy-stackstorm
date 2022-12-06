terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"

  backend "s3" {
    region         = "us-east-1"
    bucket         = "bitovi-terraform-state-files"
    key            = "Operations_Stackstorm/stackstorm.tfstate"
  }
}


provider aws {
  region  = "ca-central-1"
}

module "Stackstorm-Single-VM" {
  source              = "./modules"
  common_tags         = var.common_tags
  aws-profile         = var.aws-profile
  aws-region          = var.aws-region
  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  availability_zones  = var.availability_zones
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
  route53_zone_id     = var.route53_zone_id
  domain_name         = var.domain_name
}
