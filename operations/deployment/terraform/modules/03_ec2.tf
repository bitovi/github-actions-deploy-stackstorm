resource "aws_instance" "server" {
 ami                         = data.aws_ami.ubuntu.id
 instance_type               = "${var.ec2_instance_type}"
 key_name                    = aws_key_pair.deployer.key_name
 associate_public_ip_address = true
 
 #   TODO: handle no subnet_id (see 02_networking.tf) - flag create_vpc
 subnet_id                   = aws_subnet.public.*.id[0]
 vpc_security_group_ids      = [aws_security_group.allow_http.id, aws_security_group.allow_https.id, aws_security_group.allow_ssh.id]
 user_data = <<EOF
#!/bin/bash
echo "symlink for python3 -> python"
sudo ln -s /usr/bin/python3 /usr/bin/python
EOF
 tags = {
   Name = "${var.aws_resource_identifier}"
 }
}

output "ec2_public_dns" {
  description = "Public IP address of the ec2"
  value       = aws_instance.server.public_ip
}