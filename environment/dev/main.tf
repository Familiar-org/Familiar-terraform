# Provider

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

module "domain" {
  source = "../../modules/global/domain"
  prefix = var.prefix
  familiar_zone_name = var.familiar_link_domain_name
  familiar_link_domain_name = var.familiar_link_domain_name
  wildcard_familiar_link_domain_name = var.wildcard_familiar_link_domain_name
  familiar_a_name = var.familiar_link_domain_name
  familiar_cf_alias_name = module.frontend.cf_alias_name
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

module "frontend" {
  source = "../../modules/services/frontend-app"
  prefix = var.prefix
  familiar_com_acm_id = module.domain.familiar_acm_id
  alb_origin_id = module.backend.backend_alb_id
}

# Back-End

module "backend" {
  source = "../../modules/services/backend-app"
  vpc_id = module.vpc.vpc_id
  prefix = var.prefix
  pub_subnet_ids = module.subnet.pub_subnet_ids
  backend_node_instance_type = var.backend_node_instance_type
  ecs_backend_min_asg_size = var.ecs_backend_min_asg_size
  ecs_backend_max_asg_size = var.ecs_backend_max_asg_size
}