resource "aws_subnet" "public_subnet" {
  for_each = toset(var.pub_subnet_cidr_and_az)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.key
  availability_zone       = each.value
  map_public_ip_on_launch = true
  tags = {
    Name = "${prefix}-public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  for_each = toset(var.pri_subnet_cidr_and_az)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.key
  availability_zone = each.value
  tags = {
    Name = "${prefix}-private-subnet"
  }
}
