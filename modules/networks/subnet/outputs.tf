output "pub_subnet_id" {
  value = aws_subnet.public_subnet
}

output "pri_subnet_ids" {
  value = aws_subnet.private_subnet
}

output "pri_db_subnet_ids" {
  value = aws_subnet.private_db_subnet
}
