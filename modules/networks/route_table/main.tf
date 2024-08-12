# public route table
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = {
    Name = "${prefix}-pub-rt"
  }
}

resource "aws_route_table_association" "public_subnets" {
  route_table_id = aws_route_table.public.id
  subnet_id      = var.public_subnet_id
}


# private route table
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.nat_gw_id
  }
}

resource "aws_route_table_association" "private_subnets" {
  route_table_id = aws_route_table.private.id
  subnet_id      = var.private_subnet_id
}

# db private route table association
resource "aws_route_table_association" "db_private_subnets" {
  route_table_id = aws_route_table.private.id
  subnet_id      = var.db_private_subnet_id
}
