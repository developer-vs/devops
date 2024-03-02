# Create IAM role for Jenkins
resource "aws_iam_role" "simple_webpage_role" {
  name = "simple-webpage-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "simple_webpage_profile" {
  name = "simple-webpage-profile"
  role = aws_iam_role.simple_webpage_role.name
}

resource "aws_iam_role_policy" "simple_webpage_policy" {
  name = "simple-webpage-policy"
  role = aws_iam_role.simple_webpage_role.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "ec2:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Sid": "EC2InstanceConnect",
            "Action": [
                "ec2:DescribeInstances",
                "ec2-instance-connect:SendSSHPublicKey"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Action": [
                "s3:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
    })
}
