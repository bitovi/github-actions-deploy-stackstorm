echo "In generate_acm_tf.sh"

echo "
# SSL Certificate
resource \"aws_acm_certificate\" \"ssl_certificate\" {
  # Could be used to control whether to create the resource of not
  provider                  = aws
  domain_name               = var.domain_name
  subject_alternative_names = [\"*.\${var.domain_name}\"]
  validation_method         = \"DNS\"

  lifecycle {
    create_before_destroy = true
  }
}

resource \"aws_route53_record\" \"cert_dns\" {
  allow_overwrite = true
  name =  tolist(aws_acm_certificate.ssl_certificate.domain_validation_options)[0].resource_record_name
  records = [tolist(aws_acm_certificate.ssl_certificate.domain_validation_options)[0].resource_record_value]
  type = tolist(aws_acm_certificate.ssl_certificate.domain_validation_options)[0].resource_record_type
  zone_id = data.aws_route53_zone.selected[0].zone_id
  ttl = 60
}

data \"aws_route53_zone\" \"selected\" {
  count        = local.fqdn_provided ? 1 : 0
  name         = \"\${var.domain_name}.\"
  private_zone = false
}

locals {
  fqdn_provided = (
    (var.sub_domain_name != \"\") ?
    (var.domain_name != \"\" ?
      true :
      false
    ):
    false
  )
}

" > "${GITHUB_ACTION_PATH}/operations/deployment/terraform/modules/00_create_acm.tf"


sed -i -e 's/##depends_on/depends_on/g' ${GITHUB_ACTION_PATH}/operations/deployment/terraform/modules/01_acm.tf
