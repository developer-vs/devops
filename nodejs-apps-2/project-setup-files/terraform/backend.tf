terraform {
  backend "s3" {
    bucket = "nodejs-apps-terraform-bucket"
    key    = "nodejs-apps/terraform.tfstate"
    region = "us-east-1"
	}
}
