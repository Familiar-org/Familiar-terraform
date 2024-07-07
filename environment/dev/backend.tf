terraform {
  backend "s3" {
    bucket  = "familiar-terraform-s3-bucket"
    key     = "dev/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
