resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "public_key_nodejs-apps" {
  key_name   = "nodejs-apps.pub"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "local_file" "public_key_nodejs-apps" {
  filename = "nodejs-apps.pub"
  content  = aws_key_pair.public_key_nodejs-apps.public_key
}

resource "local_file" "private_key_nodejs-apps" {
  filename        = "nodejs-apps.pem"
  file_permission = "0400"
  content         = tls_private_key.rsa.private_key_pem
}
