 
resource "aws_vpc" "main" {
 cidr_block = var.vpc_cidr
 tags = {
   Name = "${var.aws_resource_identifier}"
 }
}
 
resource "aws_internet_gateway" "gw" {
 vpc_id = aws_vpc.main.id
}

# resource "aws_subnet" "private" {
#   vpc_id            = aws_vpc.main.id
#   count             = length(var.private_subnets)
#   cidr_block        = element(var.private_subnets, count.index)
#   availability_zone = element(var.availability_zones, count.index)

#   tags = {
#     Name = "${var.aws_resource_identifier}-private${count.index + 1}"
#     Tier = "Private"
#   }
# }

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  count                   = length(var.public_subnets)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.aws_resource_identifier}-pub${count.index + 1}"
    Tier = "Public"
  }
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.aws_resource_identifier}"
  }
  
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}





resource "aws_security_group" "allow_http" {
 name        = "allow_http"
 description = "Allow HTTP traffic"
 vpc_id      = aws_vpc.main.id
 ingress {
   description = "HTTP"
   from_port   = 80
   to_port     = 80
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }
 egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}
 
resource "aws_security_group" "allow_https" {
 name        = "allow_https"
 description = "Allow HTTPS traffic"
 vpc_id      = aws_vpc.main.id
 ingress {
   description = "HTTPS"
   from_port   = 443
   to_port     = 443
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }
 egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

resource "aws_security_group" "allow_ssh" {
 name        = "allow_ssh"
 description = "Allow SSH traffic"
 vpc_id      = aws_vpc.main.id
 ingress {
   description = "SSH"
   from_port   = 22
   to_port     = 22
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }
 egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}