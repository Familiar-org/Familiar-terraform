resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub_subnet_cidr
  availability_zone       = var.pub_subnet_az
  map_public_ip_on_launch = true
  tags = {
    Name = "${prefix}-public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.pri_subnet_cidr
  availability_zone = var.pri_subnet_az
  tags = {
    Name = "${prefix}-private-subnet"
  }
}
