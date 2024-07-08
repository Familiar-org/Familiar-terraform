variable "prefix" {
  description = "Project name and environment"
}
variable "region" {}

# networks
variable "vpc_cidr" {}
variable "pub_subnet_az" {

}
variable "pri_subnet_az" {

}
variable "pub_subnet_cidr_and_az" {
  type = map(string)
}
variable "pri_subnet_cidr_and_az" {
  type = map(string)
}
# application

