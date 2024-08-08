resource "aws_subnet" "public_subnet" {
  for_each = var.pub_subnet_cidr_and_az

  vpc_id                  = var.vpc_id
  cidr_block              = each.key
  availability_zone       = each.value
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.prefix}-public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  for_each = var.pri_subnet_cidr_and_az

  vpc_id            = var.vpc_id
  cidr_block        = each.key
  availability_zone = each.value
  tags = {
    Name = "${var.prefix}-private-subnet"
  }
}

resource "aws_subnet" "private_db_subnet" {
  for_each = var.pri_db_subnet_cidr_and_az

  vpc_id            = var.vpc_id
  cidr_block        = each.key
  availability_zone = each.value
  tags = {
    Name = "${var.prefix}-private-db-subnet"
  }
}
