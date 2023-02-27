resource "aws_elb" "vm" {
  name               = "${var.aws_resource_identifier_supershort}"
  subnets            = var.create_vpc == "true" ? aws_subnet.public.*.id : null
  availability_zones = var.create_vpc == "true" ? null : [aws_instance.server.availability_zone]

  security_groups = [aws_security_group.ec2_security_group.id]

  listener {
    instance_port      = 443
    instance_protocol  = "https"
    lb_port            = 80
    lb_protocol        = "http"

  #   TODO: handle ssl (see 01_acm.tf.skip)
  #   lb_port            = 80
  #   lb_protocol        = "http"
  #   ssl_certificate_id = data.aws_acm_certificate.issued.arn
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTPS:443/"
    interval            = 30
  }

  instances                   = [aws_instance.server.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "${var.aws_resource_identifier_supershort}"
  }

  access_logs {
    bucket        = aws_s3_bucket.lb_access_logs.id
    interval      = 60
  }
}

data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket" "lb_access_logs" {
  bucket = var.lb_access_bucket_name

  force_destroy = true

  policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.lb_access_bucket_name}/*",
      "Principal": {
        "AWS": [
          "${data.aws_elb_service_account.main.arn}"
        ]
      }
    }
  ]
}
POLICY

  tags = {
    Name  = var.lb_access_bucket_name
  }
}

resource "aws_s3_bucket_acl" "lb_access_logs_acl" {
  bucket = aws_s3_bucket.lb_access_logs.id
  acl    = "private"
}

output "loadbalancer_public_dns" {
  description = "Public DNS address of the LB"
  value       = aws_elb.vm.dns_name
}
output "loadbalancer_protocol" {
  description = "Protocol of the LB url"
  #   TODO: handle ssl (see 01_acm.tf.skip)
  # value     = local.fqdn_provided ? 'https://' : 'http://'
  value       = "http://"
}