resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.prefix}-vpc"
  }
}

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

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${prefix}-igw"
  }
}

resource "aws_internet_gateway_attachment" "name" {
  internet_gateway_id = aws_internet_gateway.igw.id
  vpc_id              = aws_vpc.vpc.id
}

resource "aws_route_table" "name" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.prefix}-rtb-public"
  }
}

resource "aws_route" "name" {

}

resource "aws_route_table_association" "name" {

}
