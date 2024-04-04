resource "aws_launch_template" "k3s_master" {
  name_prefix   = "k3s-master-"
  image_id      = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  vpc_security_group_ids = [data.aws_security_group.k3s_sg.id]
  key_name      = aws_key_pair.public_key_k3s-master.key_name

  iam_instance_profile {
    name = data.aws_iam_instance_profile.k3s_node_instance_profile.name
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "K3s_Master"
    }
  }
}
