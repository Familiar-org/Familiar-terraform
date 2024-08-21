variable "prefix" {
  description = "Project name and environment"
}
variable "region" {

}

# global

variable "wildcard_familiar_link_domain_name" {
  
}

variable "familiar_link_domain_name" {
  
}


# networks
variable "vpc_cidr" {

}

variable "pub_subnet_cidr_and_az" {
  type = map(string)
}
variable "pri_subnet_cidr_and_az" {
  type = map(string)
}
variable "pri_db_subnet_cidr_and_az" {
  type = map(string)
}

# application

variable "backend_node_instance_type" {
  
}

variable "ecs_backend_min_asg_size" {
  
}

variable "ecs_backend_max_asg_size" {
  
}