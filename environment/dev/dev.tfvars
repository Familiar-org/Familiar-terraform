prefix = "familiar-dev"

# networks
vpc_cidr = "10.0.0.0/23"

region = "us-east-1"

pub_subnet_cidr_and_az = {
  "10.0.0.0/26"  = "us-east-1a",
  "10.0.0.64/26" = "us-east-1c"
}

pri_subnet_cidr_and_az = {
  "10.0.1.0/26"   = "us-east-1a",
  "10.0.1.64/26"  = "us-east-1c",
  "10.0.1.128/26" = "us-east-1a",
  "10.0.1.192/26" = "us-east-1c"
}
