resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.vpc.id
 
  tags = {
    Name = "${var.prefix}-rtb-public"
  }
}

resource "aws_route_table_association" "route_table_public_association" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.route_table_public.id
}
