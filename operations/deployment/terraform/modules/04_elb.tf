resource "aws_elb" "vm" {
  name               = "${var.aws_resource_identifier}"
  subnets = aws_subnet.public.*.id

  security_groups = [aws_security_group.allow_http.id, aws_security_group.allow_https.id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  # TODO: handle ssl (see 01_acm.tf.skip)
  # listener {
  #   instance_port      = 443
  #   instance_protocol  = "https"
  #   lb_port            = 443
  #   lb_protocol        = "https"
  #   ssl_certificate_id = data.aws_acm_certificate.issued.arn
  # }

  # TODO: handle ssl (see 01_acm.tf.skip)
  # health_check {
  #   healthy_threshold   = 2
  #   unhealthy_threshold = 2
  #   timeout             = 3
  #   target              = "HTTPS:443/"
  #   interval            = 30
  # }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTPS:80/"
    interval            = 30
  }

  instances                   = [aws_instance.server.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "${var.aws_resource_identifier}"
  }
}

output "loadbalancer_public_dns" {
  description = "Public DNS address of the LB"
  value       = aws_elb.vm.dns_name
}