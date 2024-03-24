terraform {
  backend "s3" {
    bucket = "jenkins-server-terraform-bucket"
    key    = "jenkins-server/terraform.tfstate"
    region = "us-east-1"
	}
}
