data "aws_vpc" "jenkins-server" {
  default = true
}

data "aws_subnets" "jenkins-server-vpcsubnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.jenkins-server.id]
  }
  filter {
    name   = "default-for-az"
    values = [true]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_subnet" "vpcsubnet" {
  for_each = { for index, subnetid in data.aws_subnets.jenkins-server-vpcsubnets.ids : index => subnetid }
  id       = each.value
}

data "aws_caller_identity" "current" {}
