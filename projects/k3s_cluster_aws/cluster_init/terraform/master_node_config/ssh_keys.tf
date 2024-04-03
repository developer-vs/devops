resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "public_key_k3s-master" {
  key_name   = "k3s-master.pub"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "local_file" "public_key_k3s-master" {
  filename = "k3s-master.pub"
  content  = aws_key_pair.public_key_k3s-master.public_key
}

resource "local_file" "private_key_k3s-master" {
  filename        = "k3s-master.pem"
  file_permission = "0400"
  content         = tls_private_key.rsa.private_key_pem
}
