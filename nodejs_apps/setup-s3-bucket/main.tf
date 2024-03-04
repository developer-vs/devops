terraform {
  required_providers {  
    aws = {
      source = "hashicorp/aws"  
    }
  }  
  required_version = ">= 1.7"
}

variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

provider "aws" {
  profile = "default"
  region  = "${var.region}"
}

resource "aws_s3_bucket" "nodejs_apps_bucket" {
  bucket = "nodejs_apps-terraform-bucket"
  
  tags = {
    Name        = "NodejsAppsBucket"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "nodejs_apps_bucket_encryption" {
  bucket = aws_s3_bucket.nodejs_apps_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "nodejs_apps_bucket_versioning" {
  bucket = aws_s3_bucket.nodejs_apps_bucket.id  
  
  versioning_configuration {
    status = "Enabled"
  }
}

# Output the S3 bucket name for reference
output "s3_bucket_name" {
  value = aws_s3_bucket.nodejs_apps_bucket.bucket
}

# Generate backend.tf once the S3 bucket is created
resource "null_resource" "generate_backend" {
  # Wait for the S3 bucket creation
  depends_on = [
    aws_s3_bucket.nodejs_apps_bucket,    
    aws_s3_bucket_server_side_encryption_configuration.nodejs_apps_bucket_encryption,
    aws_s3_bucket_versioning.nodejs_apps_bucket_versioning
  ]

  # Check for the existence of the S3 bucket
  provisioner "local-exec" {
    command = <<-EOT
      count=0
      while [ $count -lt 60 ]; do
        if aws s3api head-bucket --bucket "${aws_s3_bucket.nodejs_apps_bucket.bucket}" 2>/dev/null; then
          echo "Bucket exists"
          exit 0
        else
          echo "Bucket not yet available. Waiting..."
          sleep 10
          count=$((count+1))
        fi
      done
      echo "Timeout waiting for the bucket to be available"
      exit 1
    EOT
  }
  
  # Use local-exec provisioner to generate the backend.tf file
  provisioner "local-exec" {
    command = <<-EOT
      cat <<EOF > backend.tf
      terraform {
        backend "s3" {
          bucket = "${aws_s3_bucket.nodejs_apps_bucket.bucket}"
          key    = "nodejs_apps/setup_s3/terraform.tfstate"
          region = "${var.region}"
        }
      }
      EOF
    EOT
  }
}
