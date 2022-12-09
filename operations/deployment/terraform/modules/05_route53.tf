resource "aws_acm_certificate_validation" "cert_validation" {
  provider        = aws
  certificate_arn = data.aws_acm_certificate.issued.arn
}
