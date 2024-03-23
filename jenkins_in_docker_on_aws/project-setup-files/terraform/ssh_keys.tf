resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "public_key_jenkins_server" {
  key_name   = "jenkins-server.pub"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "local_file" "public_key_jenkins_server" {
  filename = "jenkins-server.pub"
  content  = aws_key_pair.public_key_jenkins_server.public_key
}

resource "local_file" "private_key_jenkins_server" {
  filename        = "jenkins-server.pem"
  file_permission = "0400"
  content         = tls_private_key.rsa.private_key_pem
}
