output "web_address" {
  value = aws_instance.ubuntu_img_2204[0].public_ip
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "aws_vpc" {
  value = data.aws_vpc.main
}

output "aws_subnets" {
  value = data.aws_subnets.vpcsubnets
}
