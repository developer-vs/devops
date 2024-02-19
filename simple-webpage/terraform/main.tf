terraform {
  required_providers {  
    aws = {
      source = "hashicorp/aws"	
    }
    random = {
      source = "hashicorp/random"	
    }
  }  
  required_version = ">= 1.7"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_instance" "ubuntu_img_2204" {
  count                  = 1
  ami                    = "ami-0c7217cdde317cfec"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  key_name               = aws_key_pair.public_key_simple_webpage.key_name

  tags = {
    Name    = "ubuntu_server_22.04"
    Owner   = ""
    Project = "simple_website"
  }
  
  # Add an IP of the instance to the file hosts.ini to use by Ansible
  provisioner "local-exec" {
    command = "../scripts/update_hosts.sh '${aws_instance.ubuntu_img_2204[0].public_ip}'"
  }
  
  # The file hosts.ini should be destroyed
  provisioner "local-exec" {
    when    = destroy
    command = "rm -f ../ansible/hosts.ini"
  }
}

resource "random_pet" "sg" {}

resource "aws_security_group" "web-sg" {
  name = "${random_pet.sg.id}-sg"
  description = "Simple Webpage Security Group"

  ingress = [{
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow inbound traffic for HTTP protocol"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
  },
  {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow inbound traffic for HTTPS protocol"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
  },
  {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow inbound SSH traffic"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
  }]

  egress = [{
      from_port   = 0
      to_port     = 0
      protocol    = "-1"	
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
  }]
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "public_key_simple_webpage" {
  key_name   = "simple_webpage.pub"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "local_file" "public_key_simple_webpage" {
  filename = "simple_webpage.pub"
  content  = aws_key_pair.public_key_simple_webpage.public_key
}

resource "local_file" "private_key_simple_webpage" {
  filename        = "simple_webpage.pem"
  file_permission = "0400"
  content         = tls_private_key.rsa.private_key_pem
}


