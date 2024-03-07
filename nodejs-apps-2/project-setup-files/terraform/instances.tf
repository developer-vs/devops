resource "aws_instance" "nodejs-apps-server" {
  ami                    = "ami-0c7217cdde317cfec" # Ubuntu server 22.04
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.nodejs-apps-sg.id]
  key_name               = aws_key_pair.public_key_nodejs-apps.key_name

  tags = {
    Name    = "Node_JS_Apps"
    Owner   = ""
    Project = "Node_JS_Apps running with Jenkins, Terraform, and Ansible"
  }
  
  # Add an IP of the instance to the file hosts.ini to use by Ansible
  provisioner "local-exec" {
    command = "../scripts/update_hosts.sh '${aws_instance.nodejs-apps-server.public_ip}'"
  }
}
