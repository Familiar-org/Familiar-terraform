provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment = "Dev"
      Project     = "Familiar"
      Terraform   = true
    }
  }
}

# Network

module "vpc" {
  source   = "../../modules/networks/vpc"
  vpc_cidr = var.vpc_cidr
  prefix   = var.prefix
}

module "subnet" {
  source                    = "../../modules/networks/subnet"
  vpc_cidr                  = var.vpc_cidr
  prefix                    = var.prefix
  vpc_id                    = module.vpc.vpc_id
  pub_subnet_cidr_and_az    = var.pub_subnet_cidr_and_az
  pri_subnet_cidr_and_az    = var.pri_subnet_cidr_and_az
  pri_db_subnet_cidr_and_az = var.pri_db_subnet_cidr_and_az
}

module "igw" {
  source = "../../modules/networks/internet_gateway"
  vpc_id = module.vpc.vpc_id
  prefix = var.prefix
}

# Front-End


# Back-End


