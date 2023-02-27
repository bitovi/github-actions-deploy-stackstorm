 resource "aws_vpc" "main" {
 count = var.create_vpc == "true" ? 1 : 0
 cidr_block = var.vpc_cidr
 tags = {
   Name = "${var.aws_resource_identifier}"
 }
}
resource "aws_internet_gateway" "gw" {
  count = var.create_vpc == "true" ? 1 : 0
  vpc_id = aws_vpc.main[0].id
}

# resource "aws_subnet" "private" {
#   vpc_id            = aws_vpc.main[0].id
#   count             = var.create_vpc == "true" ? length(var.private_subnets) : 0
#   cidr_block        = element(var.private_subnets, count.index)
#   availability_zone = element(var.availability_zones, count.index)

#   tags = {
#     Name = "${var.aws_resource_identifier}-private${count.index + 1}"
#     Tier = "Private"
#   }
# }

resource "aws_subnet" "public" {
  count = var.create_vpc == "true" ? length(var.public_subnets) : 0
  vpc_id                  = aws_vpc.main[0].id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.aws_resource_identifier}-pub${count.index + 1}"
    Tier = "Public"
  }
}

resource "aws_route_table" "public" {
  count = var.create_vpc == "true" ? 1 : 0
  vpc_id = aws_vpc.main[0].id

  tags = {
    Name        = "${var.aws_resource_identifier}"
  }
  
}

resource "aws_route" "public" {
  count = var.create_vpc == "true" ? 1 : 0
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw[0].id
}

resource "aws_route_table_association" "public" {
  count = var.create_vpc == "true" ? length(var.public_subnets) : 0
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public[0].id
}


resource "aws_security_group" "ec2_security_group" {
  name        = "${var.aws_resource_identifier_supershort}-SG"
  description = "SG for ${var.aws_resource_identifier}"
  vpc_id      = var.create_vpc == "true" ? aws_vpc.main[0].id : null
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.aws_resource_identifier}-instance-sg"
  }
}

data "aws_security_group" "ec2_security_group" {
  count = var.create_vpc == "true" ? 1 : 0
  id = aws_security_group.ec2_security_group.id
}

resource "aws_security_group_rule" "ingress_http" {
  tags = {
    name            = "Allow HTTP traffic"
  }
  type              = "ingress"
  description       = "${var.aws_resource_identifier} - HTTP"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_security_group.id
}

resource "aws_security_group_rule" "ingress_https" {
  tags = {
    name            = "Allow HTTPS traffic"
  }
  type              = "ingress"
  description       = "${var.aws_resource_identifier} - HTTPS"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_security_group.id
}

resource "aws_security_group_rule" "ingress_ssh" {
  tags = {
    name              = "Allow SSH traffic"
  }
  type              = "ingress"
  description       = "SSH"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_security_group.id
}