echo "In generate_acm_tf.sh"

data_hosted_zone="data \"aws_route53_zone\" \"selected\" {
  name          = \"\${var.domain_name}.\"
  private_zone  = false
}"


if [[ "$CREATE_HOSTED_ZONE" == "true" ]]; then
  hosted_zone="resource \"aws_route53_zone\" \"primary\" {
  name = \"\${var.domain_name}.\"
}"
  # Trims the last 2 characters off the variable, results trimmed: "\n}"
  data_hosted_zone=${data_hosted_zone%??}
  data_hosted_zone="$data_hosted_zone
  depends_on     = [aws_route53_zone.primary]
}"
fi


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

$data_hosted_zone

$hosted_zone

" > "${GITHUB_ACTION_PATH}/operations/deployment/terraform/modules/00_create_acm.tf"