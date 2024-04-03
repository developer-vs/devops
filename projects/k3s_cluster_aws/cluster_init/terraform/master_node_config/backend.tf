terraform {
  backend "s3" {
    bucket = "pacman-k3s-bucket"
    key    = "k3s_master/terraform.tfstate"
    region = "us-east-1"
	}
}
