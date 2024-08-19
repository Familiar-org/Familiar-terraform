variable "prefix" {
  description = "Project name and environment"
}
variable "region" {

}

# global

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

