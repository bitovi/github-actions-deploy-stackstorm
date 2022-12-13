data "aws_acm_certificate" "issued" {
  domain   = "${var.sub_domain_name}.${var.domain_name}"
  statuses = ["ISSUED"]
  depends_on = [time_sleep.wait_60_seconds]
}

data "aws_route53_zone" "selected" {
  name          = "${var.domain_name}."
  private_zone  = false
  depends_on = [time_sleep.wait_60_seconds]
}

resource "null_resource" "previous" {}

resource "time_sleep" "wait_60_seconds" {
  depends_on = [null_resource.previous]
  create_duration = "60s"
}