output "pub_subnet_ids" {
  value = [ for subnet in aws_subnet.public_subnet : subnet.id ]
}

output "pri_subnet_ids" {
  value = [ for subnet in aws_subnet.private_subnet : subnet.id ]
}

output "pri_db_subnet_ids" {
  value = [ for subnet in aws_subnet.private_subnet : subnet.id ]
}
