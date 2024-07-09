resource "aws_vpc_endpoint" "gw_endpoint_s3" {
  service_name = "com.amazonaws.us-east-1.s3"
  vpc_id       = aws_vpc.vpc_id

  tags = {
    Name = "${var.prefix}-gw-endpoint-s3"
  }
}
