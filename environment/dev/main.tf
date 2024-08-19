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

# Global

module "acm" {
  source = "../../modules/global/acm"
  prefix = var.prefix
  familiar_com_domain_name = var.familiar_com_domain_name
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

module "nat_gw" {
  depends_on = [ module.subnet ]
  source        = "../../modules/networks/nat_gateway"
  prefix        = var.prefix
  pri_subnet_id = module.subnet.pri_subnet_ids[0]
}

module "route_table" {
  source                = "../../modules/networks/route_table"
  prefix                = var.prefix
  igw_id                = module.igw.igw_id
  vpc_id                = module.vpc.vpc_id
  nat_gw_id             = module.nat_gw.nat_gw_id
  public_subnet_ids     = module.subnet.pub_subnet_ids
  private_subnet_ids    = module.subnet.pri_subnet_ids
  db_private_subnet_ids = module.subnet.pri_db_subnet_ids
}

module "vpc_endpoint" {
  source = "../../modules/networks/vpc_endpoint"
  route_table_ids = module.route_table.pri_rtb_id
  prefix = var.prefix
  vpc_id = module.vpc.vpc_id
}

# Front-End


# Back-End


