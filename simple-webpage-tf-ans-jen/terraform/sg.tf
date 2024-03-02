resource "aws_security_group" "simple-webpage" {
  name = "simple-webpage-sg"
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

