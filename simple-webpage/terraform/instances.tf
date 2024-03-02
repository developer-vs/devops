resource "aws_instance" "ubuntu_img_2204" {
  count                  = 1
  ami                    = "ami-0c7217cdde317cfec"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.simple-webpage.id]
  key_name               = aws_key_pair.public_key_simple_webpage.key_name

  tags = {
    Name    = "Simple Webpage"
    Owner   = ""
    Project = "Simple Webpage Project running with Jenkins, Terraform, and Ansible"
  }
  
  # Add an IP of the instance to the file hosts.ini to use by Ansible
  provisioner "local-exec" {
    command = "../scripts/update_hosts.sh '${aws_instance.ubuntu_img_2204[0].public_ip}'"
  }
}
