prefix = "familiar-dev"

# global

familiar_link_domain_name = "familiar.link"

wildcard_familiar_link_domain_name = "*.familiar.link"

# networks
vpc_cidr = "10.0.0.0/23"

region = "us-east-1"

pub_subnet_cidr_and_az = {
  "10.0.0.0/26"  = "us-east-1a",
  "10.0.0.64/26" = "us-east-1c"
}

pri_subnet_cidr_and_az = {
  "10.0.1.0/26"  = "us-east-1a",
  "10.0.1.64/26" = "us-east-1c"
}

pri_db_subnet_cidr_and_az = {
  "10.0.1.128/26" = "us-east-1a",
  "10.0.1.192/26" = "us-east-1c"
}

# Backend

backend_node_instance_type = "t2.micro"

ecs_backend_min_asg_size = 2

ecs_backend_max_asg_size = 6
