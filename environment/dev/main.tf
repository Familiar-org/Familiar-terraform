provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment = "Dev"
      Project = "Familiar"
      Terraform = true
    }
  }
}

module "vpc" {
  source   = "../../modules/networks/vpc"
  vpc_cidr = var.vpc_cidr
  prefix   = var.prefix
}

module "subnet" {
  source                    = "../../modules/networks/subnet"
  vpc_cidr                  = var.vpc_cidr
  prefix                    = var.prefix
  pub_subnet_cidr_and_az    = var.pub_subnet_cidr_and_az
  pri_subnet_cidr_and_az    = var.pri_subnet_cidr_and_az
  pri_db_subnet_cidr_and_az = var.pri_db_subnet_cidr_and_az
}
