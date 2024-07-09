# public rtb
resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.prefix}-public-rtb"
  }
}

resource "aws_route_table_association" "route_table_public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.route_table_public.id
}

## public route

resource "aws_route" "route_public" {
  route_table_id         = aws_route_table.route_table_public
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.igw_id
}

# private rtb

resource "aws_route_table" "route_table_private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.prefix}-private-rtb"
  }
}

resource "aws_route_table_association" "route_table_private_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.route_table_private.id
}

resource "aws_route" "route_private" {
  for_each = aws_subnet.var.pub_subnet_cidr_and_az

  route_table_id         = aws_route_table.route_table_private
  destination_cidr_block = each.key
  vpc_endpoint_id        = aws_vpc_endpoint.gw_endpoint_s3.id
}

# private-db rtb

resource "aws_route_table" "route_table_private_db" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.prefix}-private-db-rtb"
  }
}

resource "aws_route_table_association" "route_table_private_db_association" {
  subnet_id      = aws_subnet.private_db_subnet.id
  route_table_id = aws_route_table.route_table_private_db.id
}
