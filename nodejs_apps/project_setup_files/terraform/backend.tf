terraform {
  backend "s3" {
    bucket = "nodejs-apps-terraform-bucket"
    key    = "dadjokes/terraform.tfstate"
    region = "us-east-1"
	}
}
