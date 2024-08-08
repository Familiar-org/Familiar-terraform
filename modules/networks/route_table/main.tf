# public rtb
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.prefix}-public-rtb"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = var.public_subnet_ids
  route_table_id = aws_route_table.public.id
}

## public route

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.igw_id
}

# private rtb

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.prefix}-private-rtb"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = var.private_subnet_ids
  route_table_id = aws_route_table.private.id
}

# private route

resource "aws_route" "private" {
  for_each = aws_subnet.var.pub_subnet_cidr_and_az

  route_table_id         = aws_route_table.route_table_private
  destination_cidr_block = each.key
  vpc_endpoint_id        = aws_vpc_endpoint.gw_endpoint_s3.id
}

# private-db rtb

resource "aws_route_table" "route_table_private_db" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.prefix}-private-db-rtb"
  }
}

resource "aws_route_table_association" "route_table_private_db_association" {
  subnet_id      = aws_subnet.private_db_subnet.id
  route_table_id = aws_route_table.route_table_private_db.id
}
