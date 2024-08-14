output "pub_subnet_ids" {
  value = [
    "${aws_subnet.public_subnet.id}"
  ]
}

output "pri_subnet_ids" {
  value = aws_subnet.private_subnet
}

output "pri_db_subnet_ids" {
  value = aws_subnet.private_db_subnet
}
