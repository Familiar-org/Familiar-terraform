output "pub_subnet_ids" {
  value = [
    "${aws_subnet.public_subnet[each.key].id}"
  ]
}

output "pri_subnet_ids" {
  value = [
    "${aws_subnet.private_subnet[each.key].id}"
  ]
}

output "pri_db_subnet_ids" {
  value = [
    "${aws_subnet.private_db_subnet[each.key].id}"
  ]
}
