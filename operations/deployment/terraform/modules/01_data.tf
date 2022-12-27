data "aws_ami" "ubuntu" {
 most_recent = true
 filter {
   name   = "name"
   values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
 }
 filter {
   name   = "virtualization-type"
   values = ["hvm"]
 }
 owners = ["099720109477"]
}

// generates a ssh key pair
resource "tls_private_key" "stackstorm_generated_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

// Creates an ec2 key pair using the tls_private_key.stackstorm_generated_key public key
resource "aws_key_pair" "deployer" {
  key_name   = "${var.aws_resource_identifier_supershort}-ec2kp-${random_string.random.result}"
  public_key = tls_private_key.stackstorm_generated_key.public_key_openssh
}

// Creates a secret manager secret for the operations_stackstorm public key
resource "aws_secretsmanager_secret" "stackstorm_keys_sm_secret" {
   key_name   = "${var.aws_resource_identifier_supershort}-ec2kp-pub-${random_string.random.result}"
   name = "operations_stackstorm_keys-${random_string.random.result}"
}
 
resource "aws_secretsmanager_secret_version" "stackstorm_keys_sm_secret_version" {
  secret_id = aws_secretsmanager_secret.stackstorm_keys_sm_secret.id
  secret_string = <<EOF
   {
    "key": "public_key",
    "value": "${sensitive(tls_private_key.stackstorm_generated_key.public_key_openssh)}"
   },
   {
    "key": "private_key",
    "value": "${sensitive(tls_private_key.stackstorm_generated_key.private_key_openssh)}"
   }
EOF
}

resource "random_string" "random" {
  length    = 5
  lower     = true
  special   = false
  numeric   = false
}