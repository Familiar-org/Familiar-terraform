resource "aws_vpc_endpoint" "gw_endpoint_s3" {
  service_name    = "com.amazonaws.us-east-1.s3"
  vpc_id          = var.vpc_id
  route_table_ids = [var.route_table_ids]
  policy = <<EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Action": "*",
        "Effect": "Allow",
        "Resource": "*",
        "Principal": "*"
      }
    ]
  }
  EOF
  tags = {
    Name = "${var.prefix}-gw-endpoint-s3"
  }
}