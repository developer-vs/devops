output "web_address" {
  value = aws_instance.ubuntu_img_2204[0].public_ip
}
