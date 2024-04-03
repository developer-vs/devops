resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "public_key_k3s-worker" {
  key_name   = "k3s-worker.pub"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "local_file" "public_key_k3s-worker" {
  filename = "k3s-worker.pub"
  content  = aws_key_pair.public_key_k3s-worker.public_key
}

resource "local_file" "private_key_k3s-worker" {
  filename        = "k3s-worker.pem"
  file_permission = "0400"
  content         = tls_private_key.rsa.private_key_pem
}
