terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.56.1"
    }
  }
  backend "s3" {
    bucket  = "familiar-terraform-s3-bucket"
    key     = "dev/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }

}
