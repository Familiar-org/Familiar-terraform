variable "prefix" {

}

variable "vpc_cidr" {

}

variable "vpc_id" {

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
