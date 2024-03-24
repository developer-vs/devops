resource "aws_instance" "jenkins-server" {
  ami                    = "ami-0c7217cdde317cfec" # Ubuntu server 22.04
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.jenkins_server_sg.id]
  key_name               = aws_key_pair.public_key_jenkins_server.key_name

  tags = {
    Name    = "Jenkins Server"
    Owner   = ""
    Project = "Jenkins Server running with Jenkins, Terraform, and Ansible."
  }
}
