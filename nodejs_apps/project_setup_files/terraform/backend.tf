terraform {
  backend "s3" {
    bucket = "${aws_s3_bucket.nodejs_apps_bucket.bucket}"
    key    = "nodejs_apps/dadjokes/terraform.tfstate"
    region = "us-east-1"
	}
}
