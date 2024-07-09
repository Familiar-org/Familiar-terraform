resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.prefix}-rtb-public"
  }
}

resource "aws_route_table_association" "route_table_public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.route_table_public.id
}

resource "aws_route_table" "route_table_private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.prefix}-rtb-private"
  }
}

resource "aws_route_table_association" "route_table_private_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.route_table_private.id
}

resource "aws_route_table" "route_table_private_db" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.prefix}-rtb-private"
  }
}

resource "aws_route_table_association" "route_table_private_db_association" {
  subnet_id      = aws_subnet.private_db_subnet.id
  route_table_id = aws_route_table.route_table_private_db.id
}
