module "Stackstorm-Single-VM" {
  source              = "./modules"
  app_port=var.app_port
  lb_port=var.lb_port
  lb_healthcheck=var.lb_healthcheck
  app_repo_name=var.app_repo_name
  app_org_name=var.app_org_name
  app_branch_name=var.app_branch_name
  app_install_root=var.app_install_root
  os_system_user=var.os_system_user
  ops_repo_environment=var.ops_repo_environment
  ec2_instance_public_ip=var.ec2_instance_public_ip
  security_group_name=var.security_group_name
  ec2_iam_instance_profile=var.ec2_iam_instance_profile
  ec2_instance_type=var.ec2_instance_type
  lb_access_bucket_name=var.lb_access_bucket_name
  aws_resource_identifier=var.aws_resource_identifier
  aws_resource_identifier_supershort=var.aws_resource_identifier_supershort
  sub_domain_name=var.sub_domain_name
  domain_name=var.domain_name
  create_vpc=var.create_vpc
  #create_domain=var.create_domain
  availability_zones=local.availability_zones
  route53_zone_id=var.route53_zone_id
}

locals {
  availability_zones = "${formatlist("${var.region}%s", var.availability_zones)}"
}

output "availability_zone" {
  value = local.availability_zones
}

output "Stackstorm-Single-VM" {
  value = module.Stackstorm-Single-VM
}