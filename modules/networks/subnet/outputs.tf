output "pub_subnet_ids" {
  value = { for key, subnet in aws_subnet.public_subnet : key => subnet.id }
}

output "pri_subnet_ids" {
  value = {  }
}

output "pri_db_subnet_ids" {
  value = aws_subnet.private_db_subnet
}
