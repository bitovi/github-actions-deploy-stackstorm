# # SSL Certificate
resource "aws_acm_certificate" "ssl_certificate" {
  provider                  = aws
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "hello_cert_dns" {
  allow_overwrite = true
  name =  tolist(aws_acm_certificate.ssl_certificate.domain_validation_options)[0].resource_record_name
  records = [tolist(aws_acm_certificate.ssl_certificate.domain_validation_options)[0].resource_record_value]
  type = tolist(aws_acm_certificate.ssl_certificate.domain_validation_options)[0].resource_record_type
  zone_id = var.route53_zone_id
  ttl = 60
}
