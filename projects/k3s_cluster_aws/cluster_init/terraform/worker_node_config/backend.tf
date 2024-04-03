terraform {
  backend "s3" {
    bucket = "pacman-k3s-bucket"
    key    = "k3s_worker/terraform.tfstate"
    region = "us-east-1"
  }
}
