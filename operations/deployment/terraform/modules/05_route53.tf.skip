resource "aws_acm_certificate_validation" "cert_validation" {
  provider        = aws
  certificate_arn = data.aws_acm_certificate.issued.arn
}

resource "aws_route53_record" "root-a" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_elb.vm.dns_name
    zone_id                = aws_elb.vm.zone_id
    evaluate_target_health = true
  }
}