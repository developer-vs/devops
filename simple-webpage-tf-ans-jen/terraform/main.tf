terraform {
  required_providers {  
    aws = {
      source = "hashicorp/aws"	
    }
  }  
  required_version = ">= 1.7"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

