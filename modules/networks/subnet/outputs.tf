output "pub_subnet_ids" {
  value = values(aws_subnet.public_subnet)[*].id
}

output "pri_subnet_ids" {
  value = [
    "${aws_subnet.private_subnet.*.id}"
  ]
}

output "pri_db_subnet_ids" {
  value = [
    "${aws_subnet.private_db_subnet.*.id}"
  ]
}
