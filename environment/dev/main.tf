provider "aws" {
  region = var.region
}

module "vpc" {
  source   = "../../modules/networks/vpc"
  vpc_cidr = var.vpc_cidr
  prefix   = var.prefix
}

module "subnet" {
  source          = "../../modules/networks/subnet"
  vpc_cidr        = var.vpc_cidr
  prefix          = var.prefix
  pub_subnet_az   = [""]
  pub_subnet_cidr = [""]
  pri_subnet_az   = [""]
  pri_subnet_cidr = [""]
}
